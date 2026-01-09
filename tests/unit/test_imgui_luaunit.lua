--- Unit tests for ImGui wrapper module (LuaUnit version).
-- @module unit.test_imgui_luaunit

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
local luaunit = require("luaunit")

TestImGui = {}

function TestImGui:setUp()
    -- Clean up any contexts created in previous tests
    -- (ImGui contexts are global, so we need to be careful)
end

function TestImGui:test_imgui_is_available()
    luaunit.assertTrue(imgui.is_available(), "imgui.is_available should return true when ReaImGui is loaded")
end

function TestImGui:test_imgui_get_version()
    local version = imgui.get_version()
    luaunit.assertNotIsNil(version)
    luaunit.assertEquals("string", type(version))
end

function TestImGui:test_imgui_create_context()
    local ctx = imgui.create_context("Test Context")
    luaunit.assertNotIsNil(ctx)
    luaunit.assertTrue(ctx:is_valid())
    ctx:destroy()
end

function TestImGui:test_context_destroy_invalidates()
    local ctx = imgui.create_context("Test")
    luaunit.assertTrue(ctx:is_valid())
    ctx:destroy()
    luaunit.assertFalse(ctx:is_valid())
end

function TestImGui:test_context_get_raw()
    local ctx = imgui.create_context("Test")
    local raw = ctx:get_raw()
    luaunit.assertNotIsNil(raw)
    ctx:destroy()
end

function TestImGui:test_context_button()
    local ctx = imgui.create_context("Test")
    local clicked = ctx:button("Test Button", 100, 30)
    luaunit.assertEquals("boolean", type(clicked))
    ctx:destroy()
end

function TestImGui:test_context_checkbox()
    local ctx = imgui.create_context("Test")
    local changed, value = ctx:checkbox("Test", true)
    luaunit.assertEquals("boolean", type(changed))
    luaunit.assertEquals("boolean", type(value))
    ctx:destroy()
end

function TestImGui:test_context_slider_int()
    local ctx = imgui.create_context("Test")
    local changed, value = ctx:slider_int("Volume", 50, 0, 100)
    luaunit.assertEquals("boolean", type(changed))
    luaunit.assertEquals("number", type(value))
    ctx:destroy()
end

function TestImGui:test_context_input_text()
    local ctx = imgui.create_context("Test")
    local changed, value = ctx:input_text("Name", "initial")
    luaunit.assertEquals("boolean", type(changed))
    luaunit.assertEquals("string", type(value))
    ctx:destroy()
end

function TestImGui:test_context_layout_methods()
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
end

function TestImGui:test_context_get_content_region_avail()
    local ctx = imgui.create_context("Test")
    local w, h = ctx:get_content_region_avail()
    luaunit.assertEquals("number", type(w))
    luaunit.assertEquals("number", type(h))
    ctx:destroy()
end

function TestImGui:test_context_calc_text_size()
    local ctx = imgui.create_context("Test")
    local w, h = ctx:calc_text_size("Hello World")
    luaunit.assertEquals("number", type(w))
    luaunit.assertEquals("number", type(h))
    luaunit.assertTrue(w > 0)
    luaunit.assertTrue(h > 0)
    ctx:destroy()
end

function TestImGui:test_context_with_disabled()
    local ctx = imgui.create_context("Test")
    local called = false
    ctx:with_disabled(true, function()
        called = true
    end)
    luaunit.assertTrue(called)
    ctx:destroy()
end

function TestImGui:test_context_is_item_hovered()
    local ctx = imgui.create_context("Test")
    local hovered = ctx:is_item_hovered()
    luaunit.assertEquals("boolean", type(hovered))
    ctx:destroy()
end

function TestImGui:test_window_new()
    local win = window.Window:new({
        title = "Test Window",
        on_draw = function() end,
    })
    luaunit.assertNotIsNil(win)
    luaunit.assertEquals("Test Window", win.title)
end

function TestImGui:test_window_new_requires_title()
    local ok = pcall(function()
        window.Window:new({ on_draw = function() end })
    end)
    luaunit.assertFalse(ok)
end

function TestImGui:test_window_new_requires_on_draw()
    local ok = pcall(function()
        window.Window:new({ title = "Test" })
    end)
    luaunit.assertFalse(ok)
end

function TestImGui:test_window_new_accepts_options()
    local win = window.Window:new({
        title = "Test",
        width = 500,
        height = 400,
        on_draw = function() end,
    })
    luaunit.assertEquals(500, win.width)
    luaunit.assertEquals(400, win.height)
end

function TestImGui:test_window_is_open()
    local win = window.Window:new({
        title = "Test",
        on_draw = function() end,
    })
    luaunit.assertFalse(win:is_open())
end

function TestImGui:test_window_data_storage()
    local win = window.Window:new({
        title = "Test",
        data = { count = 42 },
        on_draw = function() end,
    })
    luaunit.assertEquals(42, win.data.count)
end

function TestImGui:test_theme_rgba()
    local color = theme.rgba(255, 128, 64, 255)
    luaunit.assertEquals("number", type(color))
end

function TestImGui:test_theme_hex()
    local color1 = theme.hex("#FF8040")
    local color2 = theme.hex("FF8040")
    luaunit.assertEquals("number", type(color1))
    luaunit.assertEquals(color1, color2)
end

function TestImGui:test_theme_hex_alpha()
    local color = theme.hex("#FF804080")
    luaunit.assertEquals("number", type(color))
end

function TestImGui:test_theme_brighten()
    local original = theme.rgba(100, 100, 100, 255)
    local brighter = theme.brighten(original, 1.5)
    local darker = theme.brighten(original, 0.5)
    luaunit.assertNotEquals(brighter, original)
    luaunit.assertNotEquals(darker, original)
end

function TestImGui:test_theme_with_alpha()
    local original = theme.rgba(255, 128, 64, 255)
    local transparent = theme.with_alpha(original, 128)
    luaunit.assertNotEquals(original, transparent)
end

function TestImGui:test_theme_new()
    local t = theme.Theme:new("Custom", {
        Text = theme.hex("#FFFFFF"),
    })
    luaunit.assertNotIsNil(t)
    luaunit.assertEquals("Custom", t.name)
end

function TestImGui:test_theme_create()
    local t = theme.create("MyTheme", {
        Button = theme.hex("#FF0000"),
    })
    luaunit.assertNotIsNil(t)
    luaunit.assertEquals("MyTheme", t.name)
end

function TestImGui:test_theme_extend()
    local extended = theme.extend(theme.Dark, "MyDark", {
        Button = theme.hex("#00FF00"),
    })
    luaunit.assertNotIsNil(extended)
    luaunit.assertEquals("MyDark", extended.name)
    -- Should have inherited colors
    luaunit.assertNotIsNil(extended.colors.Text)
    -- Should have override
    luaunit.assertEquals(theme.hex("#00FF00"), extended.colors.Button)
end

function TestImGui:test_prebuilt_themes()
    luaunit.assertNotIsNil(theme.Dark)
    luaunit.assertNotIsNil(theme.Light)
    luaunit.assertNotIsNil(theme.Reaper)
    luaunit.assertNotIsNil(theme.HighContrast)
end

function TestImGui:test_window_flags_constants()
    luaunit.assertEquals("number", type(imgui.WindowFlags.None()))
    luaunit.assertEquals("number", type(imgui.WindowFlags.NoTitleBar()))
    luaunit.assertEquals("number", type(imgui.WindowFlags.NoResize()))
end

function TestImGui:test_cond_constants()
    luaunit.assertEquals("number", type(imgui.Cond.Always()))
    luaunit.assertEquals("number", type(imgui.Cond.FirstUseEver()))
end

function TestImGui:test_col_constants()
    luaunit.assertEquals("number", type(imgui.Col.Text()))
    luaunit.assertEquals("number", type(imgui.Col.Button()))
end

function TestImGui:test_key_constants()
    luaunit.assertEquals("number", type(imgui.Key.Shift()))
    luaunit.assertEquals("number", type(imgui.Key.Ctrl()))
end
