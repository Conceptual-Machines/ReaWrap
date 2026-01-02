--- Theme system for ReaImGui.
-- Provides pre-built themes and easy color customization.
-- @module imgui.theme
-- @author Nomad Monad
-- @license MIT

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

--- Convert REAPER color format (BGR) to RGBA format.
-- REAPER returns colors as BGR (blue in low byte, red in high byte).
-- @param reaper_color number REAPER color value
-- @return number RGBA color value
local function reaper_to_rgba(reaper_color)
    if reaper_color < 0 then
        return nil
    end
    -- REAPER color: BGR format (blue, green, red)
    local b = (reaper_color >> 0) & 0xFF
    local g = (reaper_color >> 8) & 0xFF
    local r = (reaper_color >> 16) & 0xFF
    local a = 255
    return M.rgba(r, g, b, a)
end

--- Get a REAPER theme color.
-- @param ini_key string Theme color key (e.g., "col_main_bg")
-- @param fallback number|nil Fallback color if theme color not found
-- @return number|nil RGBA color or nil
local function get_reaper_theme_color(ini_key, fallback)
    local color = r.GetThemeColor(ini_key, 0)
    if color >= 0 then
        return reaper_to_rgba(color)
    end
    return fallback
end

--- Calculate luminance of a color (0-1, higher = brighter).
-- @param color number RGBA color
-- @return number Luminance value
local function get_luminance(color)
    local r = ((color >> 24) & 0xFF) / 255.0
    local g = ((color >> 16) & 0xFF) / 255.0
    local b = ((color >> 8) & 0xFF) / 255.0
    -- Relative luminance formula
    return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

--- Ensure minimum contrast between text and background.
-- @param text_color number Text color
-- @param bg_color number Background color
-- @param min_contrast number Minimum contrast ratio (default 4.5 for WCAG AA)
-- @return number Adjusted text color
local function ensure_contrast(text_color, bg_color, min_contrast)
    min_contrast = min_contrast or 4.5
    local text_lum = get_luminance(text_color)
    local bg_lum = get_luminance(bg_color)

    -- Calculate current contrast
    local lighter = math.max(text_lum, bg_lum)
    local darker = math.min(text_lum, bg_lum)
    local contrast = (lighter + 0.05) / (darker + 0.05)

    if contrast >= min_contrast then
        return text_color
    end

    -- Need to adjust: if text is darker than bg, make it lighter; if lighter, make it darker
    if text_lum < bg_lum then
        -- Text is darker, brighten it
        local target_lum = (bg_lum + 0.05) * min_contrast - 0.05
        target_lum = math.min(1.0, target_lum)
        local factor = target_lum / (text_lum + 0.0001)  -- Avoid division by zero
        return M.brighten(text_color, factor)
    else
        -- Text is lighter, darken it (shouldn't happen often)
        local target_lum = (bg_lum + 0.05) / min_contrast - 0.05
        target_lum = math.max(0.0, target_lum)
        local factor = target_lum / (text_lum + 0.0001)
        return M.brighten(text_color, factor)
    end
end

--- Create a theme from REAPER's current theme colors.
-- Reads colors from REAPER's theme and maps them to ImGui colors.
-- @param name string Theme name (default: "REAPER Dynamic")
-- @return Theme
function M.from_reaper_theme(name)
    name = name or "REAPER Dynamic"

    -- Read REAPER theme colors - use actual theme colors
    local bg = get_reaper_theme_color("col_main_bg", M.hex("#2B2B2B"))
    local bg2 = get_reaper_theme_color("col_main_bg2", M.hex("#363636"))
    local bg3 = get_reaper_theme_color("col_main_bg3", M.hex("#404040"))
    local text = get_reaper_theme_color("col_main_text", M.hex("#E0E0E0"))
    local text2 = get_reaper_theme_color("col_main_text2", M.hex("#707070"))
    local edge = get_reaper_theme_color("col_main_edge", M.hex("#4A4A4A"))
    local sel = get_reaper_theme_color("col_main_sel", M.hex("#5BA0D0"))

    -- Only adjust if background is pure black or extremely dark (luminance < 0.02)
    -- Otherwise, trust the REAPER theme
    local bg_lum = get_luminance(bg)
    if bg_lum < 0.02 then
        -- Only brighten pure black slightly - keep it dark to match theme
        bg = M.brighten(bg, 0.02 / (bg_lum + 0.0001))
    end

    local bg2_lum = get_luminance(bg2)
    if bg2_lum < 0.02 then
        bg2 = M.brighten(bg2, 0.02 / (bg2_lum + 0.0001))
    end

    local bg3_lum = get_luminance(bg3)
    if bg3_lum < 0.02 then
        bg3 = M.brighten(bg3, 0.02 / (bg3_lum + 0.0001))
    end

    -- Only fix text if it's clearly wrong (dark text on dark bg)
    -- Otherwise use theme colors
    local text_lum = get_luminance(text)
    local bg_lum_final = get_luminance(bg)

    -- If text is darker than background, that's wrong - fix it
    if text_lum < bg_lum_final then
        -- Text is darker than background - use light text
        text = M.hex("#E0E0E0")  -- Light gray text
    end
    -- If text is very dark (luminance < 0.3), it's probably wrong
    if text_lum < 0.3 then
        text = M.hex("#E0E0E0")  -- Light gray text
    end

    local text2_lum = get_luminance(text2)
    if text2_lum < bg_lum_final or text2_lum < 0.25 then
        text2 = M.hex("#A0A0A0")  -- Medium gray for disabled text
    end

    -- Derive additional colors from base colors
    local hovered = M.brighten(bg3, 1.2)
    local active = M.brighten(bg3, 1.4)
    local border = edge
    local separator = edge

    -- Create darker background for child windows (darker than main window)
    local child_bg = M.brighten(bg, 0.7)  -- Make it 70% of brightness (darker)

    -- Ensure borders are visible
    if get_luminance(border) < 0.25 then
        border = M.brighten(border, 0.25 / (get_luminance(border) + 0.0001))
    end
    separator = border

    -- Ensure all text colors have good contrast on their backgrounds
    local frame_text = ensure_contrast(text, bg3, 4.5)
    local button_text = ensure_contrast(text, bg3, 4.5)

    -- Final override: ALWAYS use light gray backgrounds for better visibility
    -- Don't trust REAPER theme colors if they're too dark
    local final_bg_lum = get_luminance(bg)
    if final_bg_lum < 0.25 then
        -- Force to a clearly visible light gray
        bg = M.hex("#404040")  -- Light gray (clearly not black)
    end

    local final_bg2_lum = get_luminance(bg2)
    if final_bg2_lum < 0.28 then
        bg2 = M.hex("#4A4A4A")  -- Lighter gray
    end

    local final_bg3_lum = get_luminance(bg3)
    if final_bg3_lum < 0.30 then
        bg3 = M.hex("#545454")  -- Even lighter gray
    end

    -- Recalculate child_bg after bg adjustments
    child_bg = M.brighten(bg, 0.7)  -- Darker than main window

    local colors = {
        Text = text,
        TextDisabled = text2,
        WindowBg = bg,  -- Main window background from REAPER theme
        ChildBg = child_bg,  -- Child windows use darker bg for visual distinction
        PopupBg = bg2,
        Border = border,
        BorderShadow = M.hex("#00000000"),
        FrameBg = bg3,
        FrameBgHovered = hovered,
        FrameBgActive = active,
        TitleBg = bg,  -- Title bar same as window
        TitleBgActive = bg2,
        TitleBgCollapsed = M.with_alpha(bg, 128),
        MenuBarBg = bg2,
        ScrollbarBg = bg,  -- Scrollbar background same as window
        ScrollbarGrab = M.brighten(bg3, 1.3),
        ScrollbarGrabHovered = M.brighten(bg3, 1.5),
        ScrollbarGrabActive = M.brighten(bg3, 1.7),
        CheckMark = sel,
        SliderGrab = sel,
        SliderGrabActive = M.brighten(sel, 1.3),
        Button = bg3,
        ButtonHovered = hovered,
        ButtonActive = sel,
        Header = bg3,
        HeaderHovered = hovered,
        HeaderActive = sel,
        Separator = separator,
        SeparatorHovered = M.brighten(separator, 1.2),
        SeparatorActive = M.brighten(separator, 1.4),
        ResizeGrip = bg3,
        ResizeGripHovered = hovered,
        ResizeGripActive = active,
        Tab = bg3,
        TabHovered = hovered,
        TabSelected = bg3,
        TabDimmed = M.brighten(bg, 0.9),
        TabDimmedSelected = bg3,
        TableHeaderBg = bg2,
        TableBorderStrong = border,
        TableBorderLight = M.brighten(border, 0.7),
        TableRowBg = M.hex("#00000000"),
        TableRowBgAlt = M.with_alpha(text, 6),
    }

    return Theme:new(name, colors)
end

return M
