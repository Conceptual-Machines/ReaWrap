--- Theme system for ReaImGui.
-- Provides pre-built themes and easy color customization.
-- @module imgui.theme
-- @author Nomad Monad
-- @license MIT
-- @release 0.3.0

local r = reaper

local M = {}

--------------------------------------------------------------------------------
-- Color Utilities
--------------------------------------------------------------------------------

--- Create an RGBA color from components.
-- @param r number Red (0-255)
-- @param g number Green (0-255)
-- @param b number Blue (0-255)
-- @param a number|nil Alpha (0-255, default 255)
-- @return number RGBA color value
function M.rgba(red, green, blue, alpha)
    alpha = alpha or 255
    return (math.floor(red) << 24) | (math.floor(green) << 16) | (math.floor(blue) << 8) | math.floor(alpha)
end

--- Create an RGBA color from hex string.
-- @param hex string Hex color (e.g., "#FF5500" or "FF5500" or "#FF550080")
-- @return number RGBA color value
function M.hex(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16) or 0
    local g = tonumber(hex:sub(3, 4), 16) or 0
    local b = tonumber(hex:sub(5, 6), 16) or 0
    local a = tonumber(hex:sub(7, 8), 16) or 255
    return M.rgba(r, g, b, a)
end

--- Adjust color brightness.
-- @param color number RGBA color
-- @param factor number Brightness factor (1.0 = no change, >1 = brighter, <1 = darker)
-- @return number Adjusted color
function M.brighten(color, factor)
    local r = math.min(255, math.floor(((color >> 24) & 0xFF) * factor))
    local g = math.min(255, math.floor(((color >> 16) & 0xFF) * factor))
    local b = math.min(255, math.floor(((color >> 8) & 0xFF) * factor))
    local a = color & 0xFF
    return M.rgba(r, g, b, a)
end

--- Set color alpha.
-- @param color number RGBA color
-- @param alpha number Alpha (0-255)
-- @return number Color with new alpha
function M.with_alpha(color, alpha)
    return (color & 0xFFFFFF00) | math.floor(alpha)
end

--------------------------------------------------------------------------------
-- Theme Class
--------------------------------------------------------------------------------

--- Theme class for managing ImGui colors.
-- @type Theme
local Theme = {}
Theme.__index = Theme

--- Create a new theme.
-- @param name string Theme name
-- @param colors table Color definitions
-- @return Theme
function Theme:new(name, colors)
    return setmetatable({
        name = name,
        colors = colors or {},
        _applied = false,
        _push_count = 0,
    }, Theme)
end

--- Apply theme colors to a context.
-- @param ctx Context ImGui context wrapper
function Theme:apply(ctx)
    if self._applied then
        return
    end

    local raw_ctx = ctx:get_raw()
    local count = 0

    for col_name, color in pairs(self.colors) do
        local col_fn = r["ImGui_Col_" .. col_name]
        if col_fn then
            r.ImGui_PushStyleColor(raw_ctx, col_fn(), color)
            count = count + 1
        end
    end

    self._applied = true
    self._push_count = count
end

--- Remove theme colors from context.
-- @param ctx Context ImGui context wrapper
function Theme:unapply(ctx)
    if not self._applied then
        return
    end

    local raw_ctx = ctx:get_raw()
    r.ImGui_PopStyleColor(raw_ctx, self._push_count)
    self._applied = false
    self._push_count = 0
end

--- Execute a function with this theme applied.
-- @param ctx Context ImGui context wrapper
-- @param fn function Function to execute
function Theme:with(ctx, fn)
    self:apply(ctx)
    fn()
    self:unapply(ctx)
end

--------------------------------------------------------------------------------
-- Pre-built Themes
--------------------------------------------------------------------------------

--- Dark theme (default-ish but refined).
M.Dark = Theme:new("Dark", {
    Text = M.hex("#FFFFFF"),
    TextDisabled = M.hex("#808080"),
    WindowBg = M.hex("#1A1A1A"),
    ChildBg = M.hex("#1A1A1A00"),
    PopupBg = M.hex("#252525"),
    Border = M.hex("#404040"),
    BorderShadow = M.hex("#00000000"),
    FrameBg = M.hex("#2D2D2D"),
    FrameBgHovered = M.hex("#3D3D3D"),
    FrameBgActive = M.hex("#4D4D4D"),
    TitleBg = M.hex("#1A1A1A"),
    TitleBgActive = M.hex("#252525"),
    TitleBgCollapsed = M.hex("#1A1A1A80"),
    MenuBarBg = M.hex("#252525"),
    ScrollbarBg = M.hex("#1A1A1A"),
    ScrollbarGrab = M.hex("#404040"),
    ScrollbarGrabHovered = M.hex("#505050"),
    ScrollbarGrabActive = M.hex("#606060"),
    CheckMark = M.hex("#7FBA00"),
    SliderGrab = M.hex("#7FBA00"),
    SliderGrabActive = M.hex("#9FDA20"),
    Button = M.hex("#404040"),
    ButtonHovered = M.hex("#505050"),
    ButtonActive = M.hex("#606060"),
    Header = M.hex("#404040"),
    HeaderHovered = M.hex("#505050"),
    HeaderActive = M.hex("#606060"),
    Separator = M.hex("#404040"),
    SeparatorHovered = M.hex("#707070"),
    SeparatorActive = M.hex("#909090"),
    ResizeGrip = M.hex("#404040"),
    ResizeGripHovered = M.hex("#505050"),
    ResizeGripActive = M.hex("#606060"),
    Tab = M.hex("#2D2D2D"),
    TabHovered = M.hex("#505050"),
    TabSelected = M.hex("#404040"),
    TabDimmed = M.hex("#252525"),
    TabDimmedSelected = M.hex("#353535"),
    TableHeaderBg = M.hex("#252525"),
    TableBorderStrong = M.hex("#404040"),
    TableBorderLight = M.hex("#303030"),
    TableRowBg = M.hex("#00000000"),
    TableRowBgAlt = M.hex("#FFFFFF06"),
})

--- Light theme.
M.Light = Theme:new("Light", {
    Text = M.hex("#1A1A1A"),
    TextDisabled = M.hex("#808080"),
    WindowBg = M.hex("#F0F0F0"),
    ChildBg = M.hex("#F0F0F000"),
    PopupBg = M.hex("#FFFFFF"),
    Border = M.hex("#C0C0C0"),
    BorderShadow = M.hex("#00000000"),
    FrameBg = M.hex("#FFFFFF"),
    FrameBgHovered = M.hex("#E8E8E8"),
    FrameBgActive = M.hex("#D8D8D8"),
    TitleBg = M.hex("#E0E0E0"),
    TitleBgActive = M.hex("#D0D0D0"),
    TitleBgCollapsed = M.hex("#E0E0E080"),
    MenuBarBg = M.hex("#E8E8E8"),
    ScrollbarBg = M.hex("#F0F0F0"),
    ScrollbarGrab = M.hex("#C0C0C0"),
    ScrollbarGrabHovered = M.hex("#A0A0A0"),
    ScrollbarGrabActive = M.hex("#808080"),
    CheckMark = M.hex("#2D7D46"),
    SliderGrab = M.hex("#2D7D46"),
    SliderGrabActive = M.hex("#3D9D56"),
    Button = M.hex("#E0E0E0"),
    ButtonHovered = M.hex("#D0D0D0"),
    ButtonActive = M.hex("#C0C0C0"),
    Header = M.hex("#D8D8D8"),
    HeaderHovered = M.hex("#C8C8C8"),
    HeaderActive = M.hex("#B8B8B8"),
    Separator = M.hex("#C0C0C0"),
    SeparatorHovered = M.hex("#909090"),
    SeparatorActive = M.hex("#707070"),
})

--- REAPER-inspired theme.
M.Reaper = Theme:new("Reaper", {
    Text = M.hex("#E0E0E0"),
    TextDisabled = M.hex("#707070"),
    WindowBg = M.hex("#2B2B2B"),
    ChildBg = M.hex("#2B2B2B00"),
    PopupBg = M.hex("#363636"),
    Border = M.hex("#4A4A4A"),
    FrameBg = M.hex("#404040"),
    FrameBgHovered = M.hex("#505050"),
    FrameBgActive = M.hex("#5A5A5A"),
    TitleBg = M.hex("#2B2B2B"),
    TitleBgActive = M.hex("#363636"),
    TitleBgCollapsed = M.hex("#2B2B2B80"),
    MenuBarBg = M.hex("#363636"),
    ScrollbarBg = M.hex("#2B2B2B"),
    ScrollbarGrab = M.hex("#606060"),
    ScrollbarGrabHovered = M.hex("#707070"),
    ScrollbarGrabActive = M.hex("#808080"),
    CheckMark = M.hex("#5BA0D0"),
    SliderGrab = M.hex("#5BA0D0"),
    SliderGrabActive = M.hex("#7BC0F0"),
    Button = M.hex("#505050"),
    ButtonHovered = M.hex("#606060"),
    ButtonActive = M.hex("#5BA0D0"),
    Header = M.hex("#404040"),
    HeaderHovered = M.hex("#505050"),
    HeaderActive = M.hex("#5BA0D0"),
    Separator = M.hex("#4A4A4A"),
})

--- High contrast theme for accessibility.
M.HighContrast = Theme:new("HighContrast", {
    Text = M.hex("#FFFFFF"),
    TextDisabled = M.hex("#AAAAAA"),
    WindowBg = M.hex("#000000"),
    ChildBg = M.hex("#00000000"),
    PopupBg = M.hex("#0A0A0A"),
    Border = M.hex("#FFFFFF"),
    FrameBg = M.hex("#1A1A1A"),
    FrameBgHovered = M.hex("#333333"),
    FrameBgActive = M.hex("#4D4D4D"),
    TitleBg = M.hex("#000000"),
    TitleBgActive = M.hex("#1A1A1A"),
    CheckMark = M.hex("#00FF00"),
    SliderGrab = M.hex("#00FF00"),
    SliderGrabActive = M.hex("#00FF00"),
    Button = M.hex("#333333"),
    ButtonHovered = M.hex("#555555"),
    ButtonActive = M.hex("#00FF00"),
    Header = M.hex("#333333"),
    HeaderHovered = M.hex("#555555"),
    HeaderActive = M.hex("#00FF00"),
    Separator = M.hex("#FFFFFF"),
})

--------------------------------------------------------------------------------
-- Module Exports
--------------------------------------------------------------------------------

M.Theme = Theme

--- Create a custom theme.
-- @param name string Theme name
-- @param colors table Color definitions (ImGui_Col_* names without prefix)
-- @return Theme
function M.create(name, colors)
    return Theme:new(name, colors)
end

--- Create a theme by extending an existing one.
-- @param base Theme Base theme to extend
-- @param name string New theme name
-- @param overrides table Color overrides
-- @return Theme
function M.extend(base, name, overrides)
    local colors = {}
    for k, v in pairs(base.colors) do
        colors[k] = v
    end
    for k, v in pairs(overrides) do
        colors[k] = v
    end
    return Theme:new(name, colors)
end

return M
