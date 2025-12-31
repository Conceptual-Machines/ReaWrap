--- Unit tests for ImGui wrapper module.
-- @module test_imgui

-- Setup path for requires
local script_path = debug.getinfo(1, "S").source:match("@?(.*/)") or "./"
package.path = script_path .. "../?.lua;"
    .. script_path .. "../../lua/?.lua;"
    .. script_path .. "../../lua/?/init.lua;"
    .. package.path

-- Load mock first
require("mock.reaper")

-- Now load the module under test
local imgui = require("imgui")
local window = require("imgui.window")
local theme = require("imgui.theme")
local assert = require("assertions")

local passed = 0
local failed = 0

local function run_test(name, fn)
    local ok, err = pcall(fn)
    if ok then
        passed = passed + 1
        print("✓ " .. name)
    else
        failed = failed + 1
        print("✗ " .. name)
        print("  Error: " .. tostring(err))
    end
end

-- Assertion helpers that throw on failure
local function assert_true(val)
    if not val then error("Expected true, got: " .. tostring(val)) end
end

local function assert_false(val)
    if val then error("Expected false, got: " .. tostring(val)) end
end

local function assert_not_nil(val)
    if val == nil then error("Expected non-nil value") end
end

local function assert_equals(expected, actual)
    if expected ~= actual then
        error(string.format("Expected %s, got %s", tostring(expected), tostring(actual)))
    end
end

--------------------------------------------------------------------------------
-- ImGui Core Tests
--------------------------------------------------------------------------------

run_test("imgui.is_available returns true when ReaImGui is loaded", function()
    assert_true(imgui.is_available())
end)

run_test("imgui.get_version returns version string", function()
    local version = imgui.get_version()
    assert_not_nil(version)
    assert_equals("string", type(version))
end)

run_test("imgui.create_context creates a context", function()
    local ctx = imgui.create_context("Test Context")
    assert_not_nil(ctx)
    assert_true(ctx:is_valid())
    ctx:destroy()
end)

run_test("Context:destroy invalidates the context", function()
    local ctx = imgui.create_context("Test")
    assert_true(ctx:is_valid())
    ctx:destroy()
    assert_false(ctx:is_valid())
end)

run_test("Context:get_raw returns the raw context", function()
    local ctx = imgui.create_context("Test")
    local raw = ctx:get_raw()
    assert_not_nil(raw)
    ctx:destroy()
end)

--------------------------------------------------------------------------------
-- Context Widget Tests
--------------------------------------------------------------------------------

run_test("Context:button returns boolean", function()
    local ctx = imgui.create_context("Test")
    local clicked = ctx:button("Test Button", 100, 30)
    assert_equals("boolean", type(clicked))
    ctx:destroy()
end)

run_test("Context:checkbox returns changed flag and value", function()
    local ctx = imgui.create_context("Test")
    local changed, value = ctx:checkbox("Test", true)
    assert_equals("boolean", type(changed))
    assert_equals("boolean", type(value))
    ctx:destroy()
end)

run_test("Context:slider_int returns changed flag and value", function()
    local ctx = imgui.create_context("Test")
    local changed, value = ctx:slider_int("Volume", 50, 0, 100)
    assert_equals("boolean", type(changed))
    assert_equals("number", type(value))
    ctx:destroy()
end)

run_test("Context:input_text returns changed flag and value", function()
    local ctx = imgui.create_context("Test")
    local changed, value = ctx:input_text("Name", "initial")
    assert_equals("boolean", type(changed))
    assert_equals("string", type(value))
    ctx:destroy()
end)

--------------------------------------------------------------------------------
-- Context Layout Tests
--------------------------------------------------------------------------------

run_test("Context layout methods don't error", function()
    local ctx = imgui.create_context("Test")
    -- These should all run without error
    ctx:same_line()
    ctx:spacing()
    ctx:separator()
    ctx:newline()
    ctx:begin_group()
    ctx:end_group()
    ctx:indent()
    ctx:unindent()
    ctx:destroy()
end)

run_test("Context:get_content_region_avail returns dimensions", function()
    local ctx = imgui.create_context("Test")
    local w, h = ctx:get_content_region_avail()
    assert_equals("number", type(w))
    assert_equals("number", type(h))
    ctx:destroy()
end)

run_test("Context:calc_text_size returns dimensions", function()
    local ctx = imgui.create_context("Test")
    local w, h = ctx:calc_text_size("Hello World")
    assert_equals("number", type(w))
    assert_equals("number", type(h))
    assert_true(w > 0)
    assert_true(h > 0)
    ctx:destroy()
end)

--------------------------------------------------------------------------------
-- Context State Tests
--------------------------------------------------------------------------------

run_test("Context:with_disabled executes callback", function()
    local ctx = imgui.create_context("Test")
    local called = false
    ctx:with_disabled(true, function()
        called = true
    end)
    assert_true(called)
    ctx:destroy()
end)

run_test("Context:is_item_hovered returns boolean", function()
    local ctx = imgui.create_context("Test")
    local hovered = ctx:is_item_hovered()
    assert_equals("boolean", type(hovered))
    ctx:destroy()
end)

--------------------------------------------------------------------------------
-- Window Tests
--------------------------------------------------------------------------------

run_test("Window:new creates a window instance", function()
    local win = window.Window:new({
        title = "Test Window",
        on_draw = function() end,
    })
    assert_not_nil(win)
    assert_equals("Test Window", win.title)
end)

run_test("Window:new requires title", function()
    local ok = pcall(function()
        window.Window:new({ on_draw = function() end })
    end)
    assert_false(ok)
end)

run_test("Window:new requires on_draw", function()
    local ok = pcall(function()
        window.Window:new({ title = "Test" })
    end)
    assert_false(ok)
end)

run_test("Window:new accepts options", function()
    local win = window.Window:new({
        title = "Test",
        width = 500,
        height = 400,
        on_draw = function() end,
    })
    assert_equals(500, win.width)
    assert_equals(400, win.height)
end)

run_test("Window:is_open returns false before opening", function()
    local win = window.Window:new({
        title = "Test",
        on_draw = function() end,
    })
    assert_false(win:is_open())
end)

run_test("Window data storage works", function()
    local win = window.Window:new({
        title = "Test",
        data = { count = 42 },
        on_draw = function() end,
    })
    assert_equals(42, win.data.count)
end)

--------------------------------------------------------------------------------
-- Theme Tests
--------------------------------------------------------------------------------

run_test("theme.rgba creates color value", function()
    local color = theme.rgba(255, 128, 64, 255)
    assert_equals("number", type(color))
end)

run_test("theme.hex parses hex colors", function()
    local color1 = theme.hex("#FF8040")
    local color2 = theme.hex("FF8040")
    assert_equals("number", type(color1))
    assert_equals(color1, color2)
end)

run_test("theme.hex handles alpha", function()
    local color = theme.hex("#FF804080")
    assert_equals("number", type(color))
end)

run_test("theme.brighten adjusts brightness", function()
    local original = theme.rgba(100, 100, 100, 255)
    local brighter = theme.brighten(original, 1.5)
    local darker = theme.brighten(original, 0.5)
    assert_true(brighter ~= original)
    assert_true(darker ~= original)
end)

run_test("theme.with_alpha changes alpha", function()
    local original = theme.rgba(255, 128, 64, 255)
    local transparent = theme.with_alpha(original, 128)
    assert_true(original ~= transparent)
end)

run_test("Theme:new creates a theme", function()
    local t = theme.Theme:new("Custom", {
        Text = theme.hex("#FFFFFF"),
    })
    assert_not_nil(t)
    assert_equals("Custom", t.name)
end)

run_test("theme.create creates a theme", function()
    local t = theme.create("MyTheme", {
        Button = theme.hex("#FF0000"),
    })
    assert_not_nil(t)
    assert_equals("MyTheme", t.name)
end)

run_test("theme.extend extends a base theme", function()
    local extended = theme.extend(theme.Dark, "MyDark", {
        Button = theme.hex("#00FF00"),
    })
    assert_not_nil(extended)
    assert_equals("MyDark", extended.name)
    -- Should have inherited colors
    assert_not_nil(extended.colors.Text)
    -- Should have override
    assert_equals(theme.hex("#00FF00"), extended.colors.Button)
end)

run_test("Pre-built themes exist", function()
    assert_not_nil(theme.Dark)
    assert_not_nil(theme.Light)
    assert_not_nil(theme.Ableton)
    assert_not_nil(theme.Reaper)
    assert_not_nil(theme.HighContrast)
end)

--------------------------------------------------------------------------------
-- Flag Constants Tests
--------------------------------------------------------------------------------

run_test("WindowFlags constants work", function()
    assert_equals("number", type(imgui.WindowFlags.None()))
    assert_equals("number", type(imgui.WindowFlags.NoTitleBar()))
    assert_equals("number", type(imgui.WindowFlags.NoResize()))
end)

run_test("Cond constants work", function()
    assert_equals("number", type(imgui.Cond.Always()))
    assert_equals("number", type(imgui.Cond.FirstUseEver()))
end)

run_test("Col constants work", function()
    assert_equals("number", type(imgui.Col.Text()))
    assert_equals("number", type(imgui.Col.Button()))
end)

run_test("Key constants work", function()
    assert_equals("number", type(imgui.Key.Shift()))
    assert_equals("number", type(imgui.Key.Ctrl()))
end)

--------------------------------------------------------------------------------
-- Summary
--------------------------------------------------------------------------------

print("")
print(string.format("Results: %d passed, %d failed", passed, failed))

if failed > 0 then
    os.exit(1)
end
