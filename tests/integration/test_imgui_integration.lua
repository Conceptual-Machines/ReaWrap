--- ImGui Integration Tests for ReaWrap.
-- Run this script inside REAPER to verify that the ImGui wrapper works
-- correctly with the real ReaImGui extension.
--
-- @module test_imgui_integration
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
-- Test Framework
--------------------------------------------------------------------------------

local TestRunner = {
    tests = {},
    results = {
        passed = 0,
        failed = 0,
        errors = {},
    },
    current_test = nil,
}

function TestRunner:add(name, fn)
    table.insert(self.tests, { name = name, fn = fn })
end

function TestRunner:run_all()
    self.results = { passed = 0, failed = 0, errors = {} }

    for _, test in ipairs(self.tests) do
        self.current_test = test.name
        local ok, err = pcall(test.fn)
        if ok then
            self.results.passed = self.results.passed + 1
        else
            self.results.failed = self.results.failed + 1
            table.insert(self.results.errors, {
                name = test.name,
                error = tostring(err),
            })
        end
    end

    return self.results
end

function TestRunner:assert(condition, msg)
    if not condition then
        error(msg or "Assertion failed", 2)
    end
end

function TestRunner:assert_equals(expected, actual, msg)
    if expected ~= actual then
        error(string.format("%s: expected %s, got %s",
            msg or "Assert equals", tostring(expected), tostring(actual)), 2)
    end
end

function TestRunner:assert_type(expected_type, value, msg)
    if type(value) ~= expected_type then
        error(string.format("%s: expected type %s, got %s",
            msg or "Assert type", expected_type, type(value)), 2)
    end
end

function TestRunner:assert_not_nil(value, msg)
    if value == nil then
        error(msg or "Expected non-nil value", 2)
    end
end

--------------------------------------------------------------------------------
-- Tests: Basic ImGui Availability
--------------------------------------------------------------------------------

TestRunner:add("ReaImGui is available", function()
    TestRunner:assert(imgui.is_available(), "ReaImGui should be available")
end)

TestRunner:add("Get ReaImGui version", function()
    local version = imgui.get_version()
    TestRunner:assert_not_nil(version, "Version should not be nil")
    TestRunner:assert_type("string", version, "Version should be a string")
    TestRunner:assert(#version > 0, "Version should not be empty")
end)

--------------------------------------------------------------------------------
-- Tests: Context Management
--------------------------------------------------------------------------------

TestRunner:add("Create and destroy context", function()
    local ctx = imgui.create_context("Test Context")
    TestRunner:assert_not_nil(ctx, "Context should be created")
    TestRunner:assert(ctx:is_valid(), "Context should be valid")

    local raw = ctx:get_raw()
    TestRunner:assert_not_nil(raw, "Raw context should exist")

    ctx:destroy()
    TestRunner:assert(not ctx:is_valid(), "Context should be invalid after destroy")
end)

TestRunner:add("Context with config flags", function()
    -- Config flags are passed directly to CreateContext
    local ctx = imgui.create_context("Test Flags", {
        config_flags = reaper.ImGui_ConfigFlags_NavEnableKeyboard(),
    })
    TestRunner:assert_not_nil(ctx, "Context with flags should be created")
    ctx:destroy()
end)

--------------------------------------------------------------------------------
-- Tests: Window Flags
--------------------------------------------------------------------------------

TestRunner:add("Window flags are numbers", function()
    TestRunner:assert_type("number", imgui.WindowFlags.None())
    TestRunner:assert_type("number", imgui.WindowFlags.NoTitleBar())
    TestRunner:assert_type("number", imgui.WindowFlags.NoResize())
    TestRunner:assert_type("number", imgui.WindowFlags.NoMove())
    TestRunner:assert_type("number", imgui.WindowFlags.NoScrollbar())
    TestRunner:assert_type("number", imgui.WindowFlags.NoCollapse())
    TestRunner:assert_type("number", imgui.WindowFlags.MenuBar())
    TestRunner:assert_type("number", imgui.WindowFlags.AlwaysAutoResize())
end)

TestRunner:add("Condition flags are numbers", function()
    TestRunner:assert_type("number", imgui.Cond.Always())
    TestRunner:assert_type("number", imgui.Cond.Once())
    TestRunner:assert_type("number", imgui.Cond.FirstUseEver())
    TestRunner:assert_type("number", imgui.Cond.Appearing())
end)

TestRunner:add("Color constants are numbers", function()
    TestRunner:assert_type("number", imgui.Col.Text())
    TestRunner:assert_type("number", imgui.Col.WindowBg())
    TestRunner:assert_type("number", imgui.Col.Button())
    TestRunner:assert_type("number", imgui.Col.ButtonHovered())
    TestRunner:assert_type("number", imgui.Col.ButtonActive())
end)

TestRunner:add("Key modifiers are numbers", function()
    TestRunner:assert_type("number", imgui.Key.Shift())
    TestRunner:assert_type("number", imgui.Key.Ctrl())
    TestRunner:assert_type("number", imgui.Key.Alt())
    TestRunner:assert_type("number", imgui.Key.Super())
end)

--------------------------------------------------------------------------------
-- Tests: Theme Module
--------------------------------------------------------------------------------

TestRunner:add("theme.rgba creates color value", function()
    local color = theme.rgba(255, 128, 64, 255)
    TestRunner:assert_type("number", color)
    TestRunner:assert(color > 0, "Color should be non-zero")
end)

TestRunner:add("theme.hex parses hex colors", function()
    local color1 = theme.hex("#FF8040")
    local color2 = theme.hex("FF8040")
    local color3 = theme.hex("#FF804080")

    TestRunner:assert_type("number", color1)
    TestRunner:assert_type("number", color2)
    TestRunner:assert_type("number", color3)
    TestRunner:assert_equals(color1, color2, "# prefix should be optional")
end)

TestRunner:add("theme.brighten adjusts brightness", function()
    local original = theme.rgba(100, 100, 100, 255)
    local brighter = theme.brighten(original, 1.5)
    local darker = theme.brighten(original, 0.5)

    TestRunner:assert(brighter ~= original, "Brighter should differ from original")
    TestRunner:assert(darker ~= original, "Darker should differ from original")
end)

TestRunner:add("theme.with_alpha changes alpha", function()
    local original = theme.rgba(255, 128, 64, 255)
    local transparent = theme.with_alpha(original, 128)

    TestRunner:assert(original ~= transparent, "Alpha change should produce different color")
end)

TestRunner:add("Pre-built themes exist and are valid", function()
    TestRunner:assert_not_nil(theme.Dark, "Dark theme should exist")
    TestRunner:assert_not_nil(theme.Light, "Light theme should exist")
    TestRunner:assert_not_nil(theme.Reaper, "Reaper theme should exist")
    TestRunner:assert_not_nil(theme.HighContrast, "HighContrast theme should exist")

    -- Check they have colors
    TestRunner:assert_not_nil(theme.Dark.colors, "Dark theme should have colors")
    TestRunner:assert_not_nil(theme.Dark.colors.Text, "Dark theme should have Text color")
end)

TestRunner:add("Theme creation works", function()
    local t = theme.create("Custom", {
        Text = theme.hex("#FFFFFF"),
        Button = theme.hex("#FF0000"),
    })

    TestRunner:assert_not_nil(t, "Theme should be created")
    TestRunner:assert_equals("Custom", t.name)
    TestRunner:assert_not_nil(t.colors.Text)
    TestRunner:assert_not_nil(t.colors.Button)
end)

TestRunner:add("Theme extension works", function()
    local extended = theme.extend(theme.Dark, "MyDark", {
        Button = theme.hex("#00FF00"),
    })

    TestRunner:assert_not_nil(extended)
    TestRunner:assert_equals("MyDark", extended.name)
    -- Should inherit Text from Dark
    TestRunner:assert_not_nil(extended.colors.Text)
    -- Should have overridden Button
    TestRunner:assert_equals(theme.hex("#00FF00"), extended.colors.Button)
end)

--------------------------------------------------------------------------------
-- Tests: Window Class
--------------------------------------------------------------------------------

TestRunner:add("Window:new creates window instance", function()
    local win = window.Window:new({
        title = "Test Window",
        on_draw = function() end,
    })

    TestRunner:assert_not_nil(win)
    TestRunner:assert_equals("Test Window", win.title)
    TestRunner:assert_equals(400, win.width) -- default
    TestRunner:assert_equals(300, win.height) -- default
end)

TestRunner:add("Window:new validates required options", function()
    -- Missing title
    local ok1 = pcall(function()
        window.Window:new({ on_draw = function() end })
    end)
    TestRunner:assert(not ok1, "Should fail without title")

    -- Missing on_draw
    local ok2 = pcall(function()
        window.Window:new({ title = "Test" })
    end)
    TestRunner:assert(not ok2, "Should fail without on_draw")
end)

TestRunner:add("Window:new accepts custom options", function()
    local win = window.Window:new({
        title = "Custom",
        width = 500,
        height = 400,
        x = 100,
        y = 200,
        closeable = false,
        data = { value = 42 },
        on_draw = function() end,
    })

    TestRunner:assert_equals(500, win.width)
    TestRunner:assert_equals(400, win.height)
    TestRunner:assert_equals(100, win.x)
    TestRunner:assert_equals(200, win.y)
    TestRunner:assert_equals(false, win.closeable)
    TestRunner:assert_equals(42, win.data.value)
end)

TestRunner:add("Window is not open initially", function()
    local win = window.Window:new({
        title = "Test",
        on_draw = function() end,
    })
    TestRunner:assert(not win:is_open())
end)

--------------------------------------------------------------------------------
-- Tests: Context Widget Methods (requires open context)
--------------------------------------------------------------------------------

TestRunner:add("Context widget methods exist and are callable", function()
    local ctx = imgui.create_context("Widget Test")
    TestRunner:assert_not_nil(ctx)

    -- Check that methods exist
    TestRunner:assert_type("function", ctx.text)
    TestRunner:assert_type("function", ctx.button)
    TestRunner:assert_type("function", ctx.checkbox)
    TestRunner:assert_type("function", ctx.slider_int)
    TestRunner:assert_type("function", ctx.slider_double)
    TestRunner:assert_type("function", ctx.input_text)
    TestRunner:assert_type("function", ctx.input_int)
    TestRunner:assert_type("function", ctx.input_double)
    TestRunner:assert_type("function", ctx.begin_window)
    TestRunner:assert_type("function", ctx.end_window)
    TestRunner:assert_type("function", ctx.same_line)
    TestRunner:assert_type("function", ctx.spacing)
    TestRunner:assert_type("function", ctx.separator)

    ctx:destroy()
end)

TestRunner:add("Context layout methods exist and are callable", function()
    local ctx = imgui.create_context("Layout Test")

    TestRunner:assert_type("function", ctx.begin_group)
    TestRunner:assert_type("function", ctx.end_group)
    TestRunner:assert_type("function", ctx.indent)
    TestRunner:assert_type("function", ctx.unindent)
    TestRunner:assert_type("function", ctx.push_item_width)
    TestRunner:assert_type("function", ctx.pop_item_width)
    TestRunner:assert_type("function", ctx.set_cursor_pos_x)
    TestRunner:assert_type("function", ctx.set_cursor_pos_y)
    TestRunner:assert_type("function", ctx.get_cursor_pos_x)
    TestRunner:assert_type("function", ctx.get_cursor_pos_y)

    ctx:destroy()
end)

TestRunner:add("Context table methods exist and are callable", function()
    local ctx = imgui.create_context("Table Test")

    TestRunner:assert_type("function", ctx.begin_table)
    TestRunner:assert_type("function", ctx.end_table)
    TestRunner:assert_type("function", ctx.table_next_row)
    TestRunner:assert_type("function", ctx.table_next_column)
    TestRunner:assert_type("function", ctx.table_setup_column)
    TestRunner:assert_type("function", ctx.table_headers_row)

    ctx:destroy()
end)

TestRunner:add("Context tree methods exist and are callable", function()
    local ctx = imgui.create_context("Tree Test")

    TestRunner:assert_type("function", ctx.tree_node)
    TestRunner:assert_type("function", ctx.tree_pop)
    TestRunner:assert_type("function", ctx.collapsing_header)

    ctx:destroy()
end)

TestRunner:add("Context popup methods exist and are callable", function()
    local ctx = imgui.create_context("Popup Test")

    TestRunner:assert_type("function", ctx.begin_popup)
    TestRunner:assert_type("function", ctx.begin_popup_modal)
    TestRunner:assert_type("function", ctx.end_popup)
    TestRunner:assert_type("function", ctx.open_popup)
    TestRunner:assert_type("function", ctx.close_current_popup)
    TestRunner:assert_type("function", ctx.begin_popup_context_item)

    ctx:destroy()
end)

TestRunner:add("Context menu methods exist and are callable", function()
    local ctx = imgui.create_context("Menu Test")

    TestRunner:assert_type("function", ctx.begin_menu_bar)
    TestRunner:assert_type("function", ctx.end_menu_bar)
    TestRunner:assert_type("function", ctx.begin_menu)
    TestRunner:assert_type("function", ctx.end_menu)
    TestRunner:assert_type("function", ctx.menu_item)

    ctx:destroy()
end)

TestRunner:add("Context tab methods exist and are callable", function()
    local ctx = imgui.create_context("Tab Test")

    TestRunner:assert_type("function", ctx.begin_tab_bar)
    TestRunner:assert_type("function", ctx.end_tab_bar)
    TestRunner:assert_type("function", ctx.begin_tab_item)
    TestRunner:assert_type("function", ctx.end_tab_item)

    ctx:destroy()
end)

TestRunner:add("Context style methods exist and are callable", function()
    local ctx = imgui.create_context("Style Test")

    TestRunner:assert_type("function", ctx.push_style_color)
    TestRunner:assert_type("function", ctx.pop_style_color)
    TestRunner:assert_type("function", ctx.push_style_var)
    TestRunner:assert_type("function", ctx.pop_style_var)

    ctx:destroy()
end)

TestRunner:add("Context utility methods exist and are callable", function()
    local ctx = imgui.create_context("Utility Test")

    TestRunner:assert_type("function", ctx.calc_text_size)
    TestRunner:assert_type("function", ctx.get_content_region_avail)
    TestRunner:assert_type("function", ctx.get_content_region_avail_width)
    TestRunner:assert_type("function", ctx.get_window_size)
    TestRunner:assert_type("function", ctx.get_window_pos)

    ctx:destroy()
end)

--------------------------------------------------------------------------------
-- UI Test Runner Window
--------------------------------------------------------------------------------

local function show_results_window(results)
    local total = results.passed + results.failed
    local pass_rate = total > 0 and (results.passed / total * 100) or 0

    window.Window.run({
        title = "ReaWrap ImGui Integration Tests",
        width = 600,
        height = 500,
        data = {
            results = results,
            scroll_to_errors = false,
        },
        on_draw = function(self, ctx)
            -- Header
            ctx:text_fmt("ReaWrap ImGui Integration Test Results")
            ctx:separator()
            ctx:spacing()

            -- Summary
            if results.failed == 0 then
                ctx:push_style_color(imgui.Col.Text(), theme.hex("#00FF00"))
                ctx:text_fmt("✓ All %d tests passed!", total)
                ctx:pop_style_color()
            else
                ctx:push_style_color(imgui.Col.Text(), theme.hex("#FF4444"))
                ctx:text_fmt("✗ %d of %d tests failed", results.failed, total)
                ctx:pop_style_color()
            end

            ctx:spacing()
            ctx:text_fmt("Pass Rate: %.1f%%", pass_rate)
            ctx:text_fmt("ReaImGui Version: %s", imgui.get_version() or "unknown")

            ctx:spacing()
            ctx:separator()
            ctx:spacing()

            -- Errors list
            if #results.errors > 0 then
                ctx:push_style_color(imgui.Col.Text(), theme.hex("#FF8800"))
                ctx:text("Failed Tests:")
                ctx:pop_style_color()
                ctx:spacing()

                if ctx:begin_child("errors", 0, 300, imgui.ChildFlags.Border()) then
                    for i, err in ipairs(results.errors) do
                        ctx:push_style_color(imgui.Col.Text(), theme.hex("#FF4444"))
                        ctx:text_fmt("%d. %s", i, err.name)
                        ctx:pop_style_color()
                        ctx:indent(20)
                        ctx:push_style_color(imgui.Col.Text(), theme.hex("#AAAAAA"))
                        ctx:text_wrapped(err.error)
                        ctx:pop_style_color()
                        ctx:unindent(20)
                        ctx:spacing()
                    end
                    ctx:end_child()
                end
            else
                ctx:push_style_color(imgui.Col.Text(), theme.hex("#888888"))
                ctx:text("No errors to display.")
                ctx:pop_style_color()
            end

            ctx:spacing()
            ctx:separator()
            ctx:spacing()

            -- Actions
            if ctx:button("Run Tests Again", 120, 0) then
                -- close() is now deferred, safe to call during on_draw
                self:close()
                -- Schedule re-run for next frame (after window closes)
                self:defer_action(function()
                    local new_results = TestRunner:run_all()
                    show_results_window(new_results)
                end)
            end

            ctx:same_line()

            if ctx:button("Close", 80, 0) then
                self:close()
            end
        end,
    })
end

--------------------------------------------------------------------------------
-- Main Entry Point
--------------------------------------------------------------------------------

-- Run all tests
reaper.ClearConsole()
reaper.ShowConsoleMsg("ReaWrap ImGui Integration Tests\n")
reaper.ShowConsoleMsg("================================\n\n")

-- Check if ReaImGui is installed
if not reaper.ImGui_CreateContext then
    reaper.ShowMessageBox(
        "ReaImGui is not installed.\n\nPlease install it via ReaPack to run these tests.",
        "Missing Dependency",
        0
    )
    return
end

-- Run tests
local results = TestRunner:run_all()

-- Log to console
reaper.ShowConsoleMsg(string.format("Passed: %d\n", results.passed))
reaper.ShowConsoleMsg(string.format("Failed: %d\n", results.failed))

if #results.errors > 0 then
    reaper.ShowConsoleMsg("\nErrors:\n")
    for _, err in ipairs(results.errors) do
        reaper.ShowConsoleMsg(string.format("  - %s: %s\n", err.name, err.error))
    end
end

reaper.ShowConsoleMsg("\n")

-- Show results window
show_results_window(results)
