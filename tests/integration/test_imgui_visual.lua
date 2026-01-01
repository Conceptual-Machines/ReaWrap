--- ImGui Visual/Interactive Integration Tests for ReaWrap.
-- This script shows a UI with all widget types so you can visually verify
-- that ReaWrap's ImGui wrapper works correctly with the real ReaImGui.
--
-- @module test_imgui_visual
-- @author Nomad Monad
-- @license MIT

--------------------------------------------------------------------------------
-- Setup Paths
--------------------------------------------------------------------------------

local script_path = ({ reaper.get_action_context() })[2]:match('^.+[\\//]')
local root_path = script_path:match('^(.+/)tests/')

package.path = root_path .. "lua/?.lua;" .. package.path
package.path = root_path .. "lua/?/init.lua;" .. package.path

--------------------------------------------------------------------------------
-- Load Modules
--------------------------------------------------------------------------------

local imgui = require("imgui")
local window = require("imgui.window")
local theme = require("imgui.theme")

--------------------------------------------------------------------------------
-- Check ReaImGui
--------------------------------------------------------------------------------

if not imgui.is_available() then
    reaper.ShowMessageBox(
        "ReaImGui is not installed.\n\nPlease install it via ReaPack to run these tests.",
        "Missing Dependency",
        0
    )
    return
end

--------------------------------------------------------------------------------
-- Test State
--------------------------------------------------------------------------------

local state = {
    -- Widgets tab
    checkbox1 = true,
    checkbox2 = false,
    radio_option = 1,
    slider_int = 50,
    slider_float = 0.5,
    input_text = "Hello World",
    input_int = 42,
    input_float = 3.14159,
    combo_selected = 1,
    selectable_items = { false, true, false, false },

    -- Theme tab
    current_theme = 1,
    themes = {
        { name = "Dark", theme = theme.Dark },
        { name = "Light", theme = theme.Light },
        { name = "Reaper", theme = theme.Reaper },
        { name = "High Contrast", theme = theme.HighContrast },
    },

    -- Stats
    button_clicks = 0,
    frame_count = 0,
}

--------------------------------------------------------------------------------
-- Draw Functions
--------------------------------------------------------------------------------

local function draw_widgets_tab(ctx)
    ctx:spacing()

    -- Buttons section
    if ctx:collapsing_header("Buttons", nil) then
        ctx:indent(10)

        if ctx:button("Click Me!", 120, 0) then
            state.button_clicks = state.button_clicks + 1
        end
        ctx:same_line()
        ctx:text_fmt("Clicked: %d times", state.button_clicks)

        ctx:spacing()

        if ctx:small_button("Small Button") then
            state.button_clicks = state.button_clicks + 1
        end

        ctx:spacing()

        ctx:begin_disabled(true)
        ctx:button("Disabled Button", 120, 0)
        ctx:end_disabled()

        ctx:unindent(10)
        ctx:spacing()
    end

    -- Checkboxes section
    if ctx:collapsing_header("Checkboxes & Radio", nil) then
        ctx:indent(10)

        local changed1, val1 = ctx:checkbox("Checkbox 1", state.checkbox1)
        if changed1 then state.checkbox1 = val1 end

        local changed2, val2 = ctx:checkbox("Checkbox 2", state.checkbox2)
        if changed2 then state.checkbox2 = val2 end

        ctx:spacing()
        ctx:separator()
        ctx:spacing()

        ctx:text("Radio Buttons:")
        if ctx:radio_button("Option A", state.radio_option == 1) then
            state.radio_option = 1
        end
        if ctx:radio_button("Option B", state.radio_option == 2) then
            state.radio_option = 2
        end
        if ctx:radio_button("Option C", state.radio_option == 3) then
            state.radio_option = 3
        end
        ctx:text_fmt("Selected: Option %s", string.char(64 + state.radio_option))

        ctx:unindent(10)
        ctx:spacing()
    end

    -- Sliders section
    if ctx:collapsing_header("Sliders", nil) then
        ctx:indent(10)

        ctx:push_item_width(200)

        local changed_int, val_int = ctx:slider_int("Int Slider", state.slider_int, 0, 100)
        if changed_int then state.slider_int = val_int end

        local changed_float, val_float = ctx:slider_double("Float Slider", state.slider_float, 0.0, 1.0)
        if changed_float then state.slider_float = val_float end

        ctx:pop_item_width()

        ctx:spacing()
        ctx:text_fmt("Int value: %d", state.slider_int)
        ctx:text_fmt("Float value: %.3f", state.slider_float)

        ctx:unindent(10)
        ctx:spacing()
    end

    -- Inputs section
    if ctx:collapsing_header("Input Fields", nil) then
        ctx:indent(10)

        ctx:push_item_width(200)

        local changed_text, val_text = ctx:input_text("Text Input", state.input_text)
        if changed_text then state.input_text = val_text end

        local changed_int, val_int = ctx:input_int("Integer Input", state.input_int)
        if changed_int then state.input_int = val_int end

        local changed_dbl, val_dbl = ctx:input_double("Float Input", state.input_float, 0.01, 0.1)
        if changed_dbl then state.input_float = val_dbl end

        ctx:pop_item_width()

        ctx:unindent(10)
        ctx:spacing()
    end

    -- Selectables section
    if ctx:collapsing_header("Selectables", nil) then
        ctx:indent(10)

        local items = { "Item One", "Item Two", "Item Three", "Item Four" }
        for i, item in ipairs(items) do
            local clicked = ctx:selectable(item, state.selectable_items[i])
            if clicked then
                state.selectable_items[i] = not state.selectable_items[i]
            end
        end

        ctx:unindent(10)
        ctx:spacing()
    end
end

local function draw_layout_tab(ctx)
    ctx:spacing()

    -- Groups section
    if ctx:collapsing_header("Groups & Same Line", nil) then
        ctx:indent(10)

        ctx:begin_group()
        ctx:text("Group 1")
        ctx:button("Btn 1", 60, 0)
        ctx:button("Btn 2", 60, 0)
        ctx:end_group()

        ctx:same_line()

        ctx:begin_group()
        ctx:text("Group 2")
        ctx:button("Btn 3", 60, 0)
        ctx:button("Btn 4", 60, 0)
        ctx:end_group()

        ctx:unindent(10)
        ctx:spacing()
    end

    -- Tables section
    if ctx:collapsing_header("Tables", nil) then
        ctx:indent(10)

        local table_flags = reaper.ImGui_TableFlags_Borders()
            | reaper.ImGui_TableFlags_RowBg()
            | reaper.ImGui_TableFlags_Resizable()

        if ctx:begin_table("test_table", 3, table_flags) then
            ctx:table_setup_column("Name")
            ctx:table_setup_column("Value")
            ctx:table_setup_column("Status")
            ctx:table_headers_row()

            local data = {
                { "Alpha", "100", "OK" },
                { "Beta", "200", "Warning" },
                { "Gamma", "300", "Error" },
            }

            for _, row in ipairs(data) do
                ctx:table_next_row()
                for _, cell in ipairs(row) do
                    ctx:table_next_column()
                    ctx:text(cell)
                end
            end

            ctx:end_table()
        end

        ctx:unindent(10)
        ctx:spacing()
    end

    -- Trees section
    if ctx:collapsing_header("Trees", nil) then
        ctx:indent(10)

        if ctx:tree_node("Root Node") then
            ctx:text("Root content")

            if ctx:tree_node("Child 1") then
                ctx:text("Child 1 content")
                ctx:tree_pop()
            end

            if ctx:tree_node("Child 2") then
                ctx:text("Child 2 content")
                ctx:tree_pop()
            end

            ctx:tree_pop()
        end

        ctx:unindent(10)
        ctx:spacing()
    end

    -- Child windows section
    if ctx:collapsing_header("Child Windows", nil) then
        ctx:indent(10)

        if ctx:begin_child("child1", 200, 100, imgui.ChildFlags.Border()) then
            ctx:text("This is a child window")
            ctx:text("With some content")
            ctx:button("Child Button", 0, 0)
            ctx:end_child()
        end

        ctx:unindent(10)
        ctx:spacing()
    end
end

local function draw_theme_tab(ctx)
    ctx:spacing()

    ctx:text("Current Theme:")
    ctx:spacing()

    for i, t in ipairs(state.themes) do
        if ctx:radio_button(t.name, state.current_theme == i) then
            state.current_theme = i
        end
    end

    ctx:spacing()
    ctx:separator()
    ctx:spacing()

    -- Theme preview
    ctx:text("Color Preview:")
    ctx:spacing()

    local current = state.themes[state.current_theme].theme

    -- Show some color swatches
    local colors_to_show = {
        { "Text", current.colors.Text },
        { "WindowBg", current.colors.WindowBg },
        { "Button", current.colors.Button },
        { "ButtonHovered", current.colors.ButtonHovered },
        { "Header", current.colors.Header },
    }

    for _, item in ipairs(colors_to_show) do
        if item[2] then
            ctx:push_style_color(imgui.Col.Button(), item[2])
            ctx:button(item[1], 100, 20)
            ctx:pop_style_color()
        end
    end

    ctx:spacing()
    ctx:separator()
    ctx:spacing()

    -- Theme utility tests
    ctx:text("Theme Utilities:")
    ctx:spacing()

    local base_color = theme.hex("#4488FF")
    ctx:push_style_color(imgui.Col.Button(), base_color)
    ctx:button("Base Color", 80, 0)
    ctx:pop_style_color()

    ctx:same_line()

    ctx:push_style_color(imgui.Col.Button(), theme.brighten(base_color, 1.3))
    ctx:button("Brighter", 80, 0)
    ctx:pop_style_color()

    ctx:same_line()

    ctx:push_style_color(imgui.Col.Button(), theme.brighten(base_color, 0.7))
    ctx:button("Darker", 80, 0)
    ctx:pop_style_color()

    ctx:spacing()

    ctx:push_style_color(imgui.Col.Button(), theme.with_alpha(base_color, 255))
    ctx:button("Full Alpha", 80, 0)
    ctx:pop_style_color()

    ctx:same_line()

    ctx:push_style_color(imgui.Col.Button(), theme.with_alpha(base_color, 128))
    ctx:button("Half Alpha", 80, 0)
    ctx:pop_style_color()
end

local function draw_info_tab(ctx)
    ctx:spacing()

    ctx:text("ReaWrap ImGui Integration Test")
    ctx:separator()
    ctx:spacing()

    ctx:text_fmt("ReaImGui Version: %s", imgui.get_version())
    ctx:text_fmt("Frame Count: %d", state.frame_count)

    ctx:spacing()
    ctx:separator()
    ctx:spacing()

    ctx:text("Window Info:")
    local w, h = ctx:get_window_size()
    local x, y = ctx:get_window_pos()
    ctx:text_fmt("  Size: %.0f x %.0f", w, h)
    ctx:text_fmt("  Position: %.0f, %.0f", x, y)

    ctx:spacing()

    ctx:text("Content Region:")
    local cw, ch = ctx:get_content_region_avail()
    ctx:text_fmt("  Available: %.0f x %.0f", cw, ch)

    ctx:spacing()
    ctx:separator()
    ctx:spacing()

    ctx:text("Text Metrics:")
    local text = "Sample Text"
    local tw, th = ctx:calc_text_size(text)
    ctx:text_fmt("  '%s' = %.0f x %.0f px", text, tw, th)

    ctx:spacing()
    ctx:separator()
    ctx:spacing()

    ctx:text_colored(theme.hex("#00FF88"), "All systems operational!")
end

--------------------------------------------------------------------------------
-- Main Window
--------------------------------------------------------------------------------

window.Window.run({
    title = "ReaWrap ImGui Visual Test",
    width = 500,
    height = 600,
    on_draw = function(self, ctx)
        state.frame_count = state.frame_count + 1

        -- Apply current theme
        local current_theme = state.themes[state.current_theme].theme
        if current_theme and current_theme.apply then
            current_theme:apply(ctx)
        end

        -- Tab bar
        if ctx:begin_tab_bar("main_tabs") then
            if ctx:begin_tab_item("Widgets") then
                draw_widgets_tab(ctx)
                ctx:end_tab_item()
            end

            if ctx:begin_tab_item("Layout") then
                draw_layout_tab(ctx)
                ctx:end_tab_item()
            end

            if ctx:begin_tab_item("Themes") then
                draw_theme_tab(ctx)
                ctx:end_tab_item()
            end

            if ctx:begin_tab_item("Info") then
                draw_info_tab(ctx)
                ctx:end_tab_item()
            end

            ctx:end_tab_bar()
        end

        -- Unapply theme
        if current_theme and current_theme.unapply then
            current_theme:unapply(ctx)
        end
    end,
})

reaper.ShowConsoleMsg("ReaWrap ImGui Visual Test started.\n")
reaper.ShowConsoleMsg("Interact with the window to verify all widgets work correctly.\n")
