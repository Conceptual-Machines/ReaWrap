import os
import pickle
from pathlib import Path

import stringcase
from dataclasses import dataclass, field
from typing import Optional, Union
from jinja2 import Template
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import re

BASE_URL = "https://www.extremraym.com/cloud/reascript-doc/"

base_classes = {
    "ReaProject": "Project",
    "MediaTrack": "Track",
    "MediaItem": "Item",
    "MediaItem_Take": "Take",
    "TrackEnvelope": "Envelope",
    "PCM_source": "PCMSource",
    "ImGui": "ImGui",
    "TimeMap": "TimeMap",
    "TimeMap2": "TimeMap",
    "SNM": "SNM",
    "CF": "CF",
    "GSC": "GSC",
    "ReaPack": "ReaPack",
    "BR": "BR",
    "MIDI": "MIDI",
    "ULT": "ULT",
    "MRP": "MRP",
    "NF": "NF",
    "TrackList": "TrackList",
    "JS": "JS",
    "Xen": "Xen",
}

lua_function_template = """
{%- if docs -%} 
-- {{ docs }}
{% endif -%}
{%- if args -%}
{{ args }}
{% endif -%}
{%- if ret_val -%}
-- {{ ret_val }} 
{% endif -%}
function {{ function_signature }}
    {{ function_call }}
end
"""

func_call_template = Template(
    """local {{ rea }} = {{ func }}
    if retval then
        return {{ reawrap }}
    end"""
)

class_template = """function {{ class_name }}:new()
    local o = {
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function {{ class_name }}:__tostring()
    return string.format('<{{ class_name }}>')
end"""

args_pattern = re.compile("\((.*)\)")
func_pattern = re.compile("reaper\.(.*)\(")


def safe_name(name):
    protected_names = [
        "and",
        "break",
        "do",
        "else",
        "elseif",
        "end",
        "false",
        "for",
        "function",
        "if",
        "in",
        "local",
        "nil",
        "not",
        "or",
        "repeat",
        "return",
        "then",
        "true",
        "until",
        "while",
    ]
    if name.lower() in protected_names:
        name = f"{name}_"
    return name


@dataclass
class ReaType:
    name: str
    lua_type: str
    is_optional: bool = False

    def __str__(self):
        return f"<ReaArg name={self.name}, lua_type={self.lua_type}, is_optional={self.is_optional}>"


@dataclass
class ReaFunc:
    signature: str
    args: list[Union[ReaType, None]]
    ret_vals: list[Union[ReaType, None]]
    docs: str

    def get_name(self):
        try:
            return re.findall(func_pattern, self.signature)[0]
        except Exception as e:
            print(e)


def parse_rea_values(orig_values):
    if not orig_values:
        yield None
    else:
        values = orig_values.split(",")
        name = "retval"
        lua_type = "ReaType"
        is_optional = False
        for val in values:
            parts = val.split()
            if not parts:
                yield None
            if len(parts) == 1:
                lua_type = parts[0]
            elif len(parts) == 2:
                lua_type = parts[0]
                name = parts[1]
            elif len(parts) == 3:
                if parts[0] == "optional":
                    lua_type = parts[1]
                    name = parts[2]
                else:
                    # workarounds bugs in docs (missing comma in string)
                    if parts == ["ImGui_Context", "ctxImGui_Font", "font"]:
                        yield ReaType(
                            name="ctx",
                            lua_type="ImGui_Context",
                            is_optional=is_optional,
                        )
                        yield ReaType(
                            name="font", lua_type="ImGui_Font", is_optional=is_optional
                        )

                    elif parts == ["string", "labelreaper_array", "values"]:
                        yield ReaType(
                            name="label", lua_type="string", is_optional=is_optional
                        )
                        yield ReaType(
                            name="values",
                            lua_type="reaper_array",
                            is_optional=is_optional,
                        )
                    elif parts == ["ImGui_DrawList", "draw_listreaper_array", "points"]:
                        yield ReaType(
                            name="draw_list",
                            lua_type="ImGui_DrawList",
                            is_optional=is_optional,
                        )
                        yield ReaType(
                            name="values",
                            lua_type="reaper_array",
                            is_optional=is_optional,
                        )
                    elif parts == ["ImGui_DrawList", "draw_listImGui_Font", "font"]:
                        yield ReaType(
                            name="draw_list",
                            lua_type="ImGui_DrawList",
                            is_optional=is_optional,
                        )
                        yield ReaType(
                            name="font", lua_type="ImGui_Font", is_optional=is_optional
                        )
                    elif parts == ["string", "filenameLICE_IBitmap", "bitmap"]:
                        yield ReaType(
                            name="filename", lua_type="string", is_optional=is_optional
                        )
                        yield ReaType(
                            name="bitmap",
                            lua_type="LICE_IBitmap",
                            is_optional=is_optional,
                        )

                    elif parts == ["boolean", "isrgnWDL_FastString", "name"]:
                        yield ReaType(
                            name="isrgn", lua_type="boolean", is_optional=is_optional
                        )
                        yield ReaType(
                            name="name",
                            lua_type="WDL_FastString",
                            is_optional=is_optional,
                        )
                    elif parts == ["identifier", "objWDL_FastString", "state"]:
                        yield ReaType(
                            name="identifier", lua_type="obj", is_optional=is_optional
                        )
                        yield ReaType(
                            name="state",
                            lua_type="WDL_FastString",
                            is_optional=is_optional,
                        )

                    elif parts == ["integer", "takeidxWDL_FastString", "state"]:
                        yield ReaType(
                            name="takeidx", lua_type="integer", is_optional=is_optional
                        )
                        yield ReaType(
                            name="state",
                            lua_type="WDL_FastString",
                            is_optional=is_optional,
                        )
                    elif parts == ["MediaItem_Take", "takeWDL_FastString", "state"]:
                        yield ReaType(
                            name="take",
                            lua_type="MediaItem_Take",
                            is_optional=is_optional,
                        )
                        yield ReaType(
                            name="state",
                            lua_type="WDL_FastString",
                            is_optional=is_optional,
                        )
                    elif parts == ["MediaItem_Take", "takeWDL_FastString", "type"]:
                        yield ReaType(
                            name="take",
                            lua_type="MediaItem_Take",
                            is_optional=is_optional,
                        )
                        yield ReaType(
                            name="type",
                            lua_type="WDL_FastString",
                            is_optional=is_optional,
                        )

            elif len(parts) == 4:
                if parts == [
                    "MRP_Array",
                    "array1MRP_Array",
                    "array2MRP_Array",
                    "array3",
                ]:
                    for i in range(1, 4):
                        yield ReaType(
                            name=f"array_{i}",
                            lua_type="MRP_Array",
                            is_optional=is_optional,
                        )
            yield ReaType(
                name=stringcase.snakecase(safe_name(name)),
                lua_type=lua_type,
                is_optional=is_optional,
            )


@dataclass
class ReaWrapFunc:
    rea_func: ReaFunc
    instance_var: bool = False
    is_parent: bool = False
    _ret_vals: list = field(default_factory=lambda: [])
    _parent_class: str = ""

    def __post_init__(self):
        self._parent_class = self._get_parent_class()

    def _get_parent_class(self):
        if self.rea_func.args:
            first_arg = self.rea_func.args[0]
            if first_arg:
                if first_arg_type := base_classes.get(first_arg.lua_type):
                    self.is_parent = True
                    self.instance_var = True
                    return first_arg_type
        ns = self.rea_func.get_name().split("_")[0]
        if ns in base_classes:
            self.is_parent = True
            if ns == "ImGui":
                self.instance_var = True
            return base_classes.get(ns)
        return "Reaper"

    @property
    def parent_class(self):
        return self._parent_class

    def get_reawrap_name(self):
        func_name = safe_name(self.rea_func.get_name())
        if self.parent_class in func_name:
            func_name = func_name.replace(f"{self.parent_class}_", "")
        snake_name = safe_name(stringcase.snakecase(func_name))
        return f"{self.parent_class}:{snake_name}"

    def get_args(self, reawrap=True):
        if self.rea_func.args:
            if self.instance_var:
                if reawrap:
                    return [
                        stringcase.snakecase(a.name)
                        for a in self.rea_func.args[1:]
                        if a is not None
                    ]
                else:
                    instance_var = "self.pointer"
                    if self.parent_class == "ImGui":
                        instance_var = "self.ctx"
                    return [instance_var] + [
                        stringcase.snakecase(a.name)
                        for a in self.rea_func.args[1:]
                        if a is not None
                    ]
            else:
                return [
                    stringcase.snakecase(a.name)
                    for a in self.rea_func.args
                    if a is not None
                ]
        else:
            return []

    def get_reascript_ret_vals(self, as_string=False):
        ret_vals = []
        arg_names = self.get_args()
        for v in self.rea_func.ret_vals:
            if v is not None:
                if v.name in arg_names:
                    ret_vals.append(ReaType(name=f"{v.name}_", lua_type=v.lua_type))
                else:
                    ret_vals.append(v)
        if as_string:
            return ", ".join([v.name for v in ret_vals])
        else:
            return ret_vals

    def get_reawrap_ret_vals(self, as_string=False):
        ret_vals = self.get_reascript_ret_vals()
        if len(ret_vals) > 1 and ret_vals[0].name == "retval":
            ret_vals = ret_vals[1:]
        if as_string:
            return ", ".join([v.name for v in ret_vals])
        else:
            return ret_vals

    def get_reawrap_signature(self):
        name = self.get_reawrap_name()
        args = self.get_args()
        if args is not None:
            args = ", ".join(args)
            return f"{name}({args})"
        else:
            return f"{name}()"

    def get_lua_func_call(self):
        args = self.get_args(reawrap=False)
        name = self.rea_func.get_name()
        if args:
            args = ", ".join(args)
            func_string = f"r.{name}({args})"
        else:
            func_string = f"r.{name}()"
        if self.get_reawrap_ret_vals() == self.get_reascript_ret_vals():
            return f"return {func_string}"
        else:
            reascript_vals = self.get_reascript_ret_vals(as_string=True)
            reawrap_vals = self.get_reawrap_ret_vals(as_string=True)
            return func_call_template.render(
                rea=reascript_vals, reawrap=reawrap_vals, func=func_string
            )

    def generate_code(self):
        data = {}
        template = Template(lua_function_template)
        docs = self.rea_func.docs
        reawrap_signature = self.get_reawrap_signature()
        func_call = self.get_lua_func_call()
        args = None
        if self.rea_func.args:
            if self.instance_var:
                args = "\n".join(
                    [
                        f"-- @{a.name} {a.lua_type}"
                        for a in self.rea_func.args[1:]
                        if a is not None
                    ]
                )
            else:
                args = "\n".join(
                    [
                        f"-- @{a.rea_name} {a.lua_type}"
                        for a in self.rea_func.args
                        if a is not None
                    ]
                )
        ret_vals = self.get_reawrap_ret_vals()
        if ret_vals:
            ret_vals_string = ", ".join(v.lua_type for v in ret_vals)
            ret_vals_string = f"@return {ret_vals_string}"
        else:
            ret_vals_string = ""
        return template.render(
            docs=docs,
            args=args,
            ret_val=ret_vals_string,
            function_signature=reawrap_signature,
            function_call=func_call,
        )


def get_docs(func_def):
    if func_def.p is not None:
        return func_def.p.text


def parse_lua_code(lua_code, docs):
    try:
        lua_text = lua_code.text
        func_sig = re.findall("reaper.*", lua_text)[0]
        return_values = lua_text.split("reaper")[0].replace("=", "").strip()
        parsed_ret_vals = list(parse_rea_values(return_values))
        args = re.findall(args_pattern, func_sig)[0]
        parsed_args = list(parse_rea_values(args))
        if any(x for x in (func_sig, parsed_ret_vals, parsed_args, docs)):
            return ReaFunc(
                signature=func_sig,
                ret_vals=parsed_ret_vals,
                args=parsed_args,
                docs=docs,
            )
    except Exception as e:
        pass


def iter_funcs():
    with open("readocs.html") as f:
        text = f.read()
    soup = BeautifulSoup(text, "html5lib")
    for func_def in soup.find_all("div", {"class": "function_definition"}):
        lua_def = func_def.find("div", {"class": "l_func"})
        docs = get_docs(func_def)
        if lua_def is not None:
            lua_code = lua_def.find("code")
            if lua_code is not None:
                rea_func = parse_lua_code(lua_code, docs)
                if rea_func is None:
                    pass
                else:
                    yield ReaWrapFunc(rea_func)


def main():
    folder = Path("auto_generated_code")
    if os.listdir(folder):
        for f in os.listdir(folder):
            os.remove(folder / f)
    functions = sorted(list(iter_funcs()), key=lambda x: x.get_reawrap_signature())
    for func in functions:
        fname = f"{func.parent_class.lower()}.lua"
        fpath = folder / fname
        print(f"writing {func.get_reawrap_signature()} to {fname}")
        with open(fpath, "a") as f:
            f.write(func.generate_code())
            f.write("\n")
            f.write("\n")


if __name__ == "__main__":
    main()
