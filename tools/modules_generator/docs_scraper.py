import logging
import re
from dataclasses import dataclass
from typing import Annotated, Iterator

from bs4 import BeautifulSoup

from modules_generator import API_HTML, REAPER_TYPES, REA_FUNC_NAMESPACES

logger = logging.getLogger(__name__)
handler = logging.StreamHandler()
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)
logger.setLevel(logging.DEBUG)
logger.addHandler(handler)

lua_reserved_keywords = (
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function",
    "goto", "if", "in", "local", "nil", "not", "or", "repeat", "return",
    "then", "true", "until", "while"
)


@dataclass
class ReaType:
    lua_type: str
    name: str | None = None
    is_optional: bool = False
    description: str | None = None
    _default_value: str | None = None

    @property
    def is_reaper_type(self) -> bool:
        return self.lua_type in REAPER_TYPES

    @property
    def reawrap_class(self) -> str:
        return f"ReaWrap{self.lua_type}"

    @property
    def default_value(self) -> str:
        if self._default_value is None:
            if self.lua_type == "boolean":
                self._default_value = "false"
            elif self.lua_type == "number":
                self._default_value = "0"
            elif self.lua_type == "string":
                self._default_value = '""'
            else:
                self._default_value = "nil"
        return self._default_value

    @default_value.setter
    def default_value(self, value: str):
        self._default_value = value


@dataclass
class ReaFunc:
    signature: Annotated[str, "The function signature including arguments."]
    rea_name: Annotated[str, "The function name as per Reaper API."]
    fn_name_space: Annotated[
        str, "The ReaAPI function namespace, e.g Track, TrackFX, etc."
    ]
    arguments: Annotated[list[ReaType], "The function arguments."]
    return_values: Annotated[list[ReaType], "The function return values."]
    docs: Annotated[str, "The function documentation."]
    reawrap_name: Annotated[
        str | None, "The ReaWrap function name. Like rea_name but snake_case"
    ] = None


def to_snake(s: str) -> str:
    # Add an underscore before each uppercase letter that is followed by a lowercase letter
    s = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1_\2", s)
    # Add an underscore before each lowercase letter that is preceded by an uppercase letter
    s = re.sub(r"([a-z\d])([A-Z])", r"\1_\2", s)
    # Convert the entire string to lowercase
    s = s.lower()
    return s


def get_html_from_file(html_file: str) -> BeautifulSoup:
    """Get the HTML content from a file."""
    with open(html_file, "r") as file:
        return BeautifulSoup(file, "html.parser")


def get_function_signature(parts: list[str]) -> str:
    """Get the function signature from a list of parts."""
    pattern = r"\w+\s*\(\s*[^)]*\s*\)"
    for part in parts:
        if re.match(pattern, part):
            return part
    raise ValueError(f"Could not find function signature in {parts}")


def get_arguments(signature: str) -> list[str]:
    """Get the arguments from a function signature."""
    pattern = r"\(([^)]*)\)"
    match = re.search(pattern, signature)
    if match:
        return match.group(1).split(",")
    raise ValueError(f"Could not find arguments in {signature}")


def parse_return_values(values: str) -> list[dict[str, str]]:
    """Parse the return values from a string."""
    if values:
        parts = values.split(",")
        types_and_names = [part.replace("=", "").strip() for part in parts]
        return list(iter_types_and_names(types_and_names))


def iter_types_and_names(types_and_names: str) -> Iterator[ReaType]:
    """Iterate over the types and names and return a dict with keys type and name."""

    def get_type(type_: str) -> str:
        if type_ == "MediaItem_Take":
            return "MediaItemTake"
        return type_

    for value in types_and_names:
        if not value:
            return None
        parts = [p for p in value.split(" ") if p]
        name = to_snake(parts[1]) if len(parts) > 1 else None
        if name in lua_reserved_keywords:
            name = f"{name}_"
        if name:
            name = name.replace(".", "")
            if name.endswith("idx"):
                name = name.replace("idx", "_idx")
            if name.startswith("is"):
                name = name.replace("is", "is_")
        if parts[0] == "optional":
            yield ReaType(name=name, lua_type=parts[2], is_optional=True)
        elif len(parts) == 1:
            yield ReaType(lua_type=get_type(parts[0]))
        else:
            yield ReaType(lua_type=get_type(parts[0]), name=name)


def get_function_name(signature: str) -> str:
    """Get the function name from a function signature."""
    pattern = r"\b\w+(?=\s*\()"
    match = re.search(pattern, signature)
    if match:
        return match.group(0)
    raise ValueError(f"Could not find function name in {signature}")


def get_fn_name_space(fn_name_space_parts) -> str:
    fn_namespace = fn_name_space_parts[0] if len(fn_name_space_parts) > 1 else None
    if fn_namespace and fn_namespace in REA_FUNC_NAMESPACES:
        # we want to filter out false positives like "GetSetProjectInfo_String"
        return fn_namespace
    return None


def parse_lua_function(text: str) -> dict[str, str]:
    """Parse a Lua function from a string."""
    parts = text.split("reaper.", maxsplit=1)
    return_values = parse_return_values(parts[0] if parts[0] else None) or []
    signature = get_function_signature(parts)
    arguments = list(iter_types_and_names(get_arguments(signature)))
    name = get_function_name(signature)
    fn_name_space_parts = name.split("_", maxsplit=1)
    fn_name_space = get_fn_name_space(fn_name_space_parts)
    if fn_name_space == "TimeMap2":
        fn_name_space = "TimeMap"
    elif fn_name_space == "midi":
        fn_name_space = "MIDI"

    return {
        "signature": signature,
        "rea_name": name,
        "fn_name_space": fn_name_space,
        "arguments": arguments,
        "return_values": return_values,
    }


def iter_lua_functions(soup: BeautifulSoup) -> dict[str, str]:
    """Iterate over the Lua functions in the REAPER API."""
    for func in soup.find("section", class_="functions_all").find_all(
        "div", class_="function_definition"
    ):
        l_func = func.find("div", class_="l_func")
        docs = func.find("p")
        lua_func = parse_lua_function(l_func.text)
        lua_func["docs"] = docs.text if docs else None
        yield ReaFunc(**lua_func)


def group_functions_by_name_space(
    functions: list[ReaFunc],
) -> dict[str, list[ReaFunc]]:
    """Parse the REAPER API functions and group them by namespace.
    The criteria for namespaces are the following:
    If the function name has an underscore, the part before the underscore is the namespace, if upper case.
    If the first argument of a function is of `Reaper` type, the namespace is the type name.
    Functions that do not belong to a namespace are grouped under `Reaper`.
    Some exceptions are made for functions that belong to the `BR` and `CF` namespace, where the first argument, if it's
    of `Reaper` type, is used as the namespace.
    Ultimately, namespaces represent the LUA tables in the modules.
    """

    by_name_space = {}
    for l_func in functions:
        if (
            l_func.fn_name_space == "PCM"
            or l_func.arguments
            and l_func.arguments[0].lua_type in ("PCM_source", "PCM_sink")
        ):
            namespace = "PCM"
        elif (
                l_func.fn_name_space in ("BR", "CF")
                and l_func.arguments
                and l_func.arguments[0].lua_type in REAPER_TYPES
        ):
            namespace = l_func.arguments[0].lua_type
        elif l_func.fn_name_space in REA_FUNC_NAMESPACES:
            namespace = l_func.fn_name_space
        elif l_func.arguments and l_func.arguments[0].lua_type in REAPER_TYPES:
            namespace = l_func.arguments[0].lua_type
        else:
            namespace = "Reaper"

        if namespace not in by_name_space:
            by_name_space[namespace] = []
        by_name_space[namespace].append(l_func)
    return by_name_space


def refine_functions(
    by_name_space: dict[str, list[ReaFunc]],
) -> dict[str, list[ReaFunc]]:
    """Once the functions are grouped by namespace, refine the name by removing the namespace and converting it to snake_case.
    Skip function that are declared as deprecated in the docs."""

    def get_reawrap_name(namespace, fn_name_space, function_name):
        """Remove the namespace from the function name and snake_case it."""
        if "TimeMap2" in function_name:
            function_name = function_name.replace("TimeMap2", "TimeMap")
        elif namespace in function_name:
            function_name = function_name.replace(namespace, "").replace("_", "")
        elif fn_name_space and fn_name_space in function_name:
            function_name = function_name.replace(fn_name_space, "").replace("_", "")

        function_name = to_snake(function_name)
        if function_name in lua_reserved_keywords:
            function_name = f"{function_name}_"
        return function_name

    refined = {}
    for name_space, functions in sorted(
        by_name_space.items(), key=lambda item: item[0].lower()
    ):
        if name_space not in refined:
            refined[name_space] = []
        for func in functions:
            if func.docs and "deprecated" in func.docs.lower():
                logger.debug(
                    f"Skipping deprecated function: {func.rea_name} | namespace: {name_space}"
                )
                continue

            reawrap_name = get_reawrap_name(
                name_space, func.fn_name_space, func.rea_name
            )
            if func.rea_name == "GetSetProjectInfo_String":
                print()
            func.reawrap_name = reawrap_name
            refined[name_space].append(func)
    return refined


def get_functions_from_docs() -> dict[str, list[dict[str, str]]]:
    """Get LUA functions from the REAPER API docs."""
    soup = get_html_from_file(API_HTML)
    functions = list(iter_lua_functions(soup))
    by_name_space = group_functions_by_name_space(functions)
    return refine_functions(by_name_space)

def main():
    functions = get_functions_from_docs()
    for name_space, functions in functions.items():
        print(name_space, len(functions))
        if name_space == "Reaper":
            for func in functions:
                print(func)


if __name__ == "__main__":
    main()