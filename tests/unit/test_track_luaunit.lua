--- Unit tests for Track module (LuaUnit version).
-- @module unit.test_track_luaunit

local luaunit = require("luaunit")
local Track = require("track")

TestTrack = {}

function TestTrack:setUp()
    -- Setup mock data before each test
    reaper._reset()
    reaper._add_track({ name = "Track 1", selected = true })
    reaper._add_track({ name = "Track 2", selected = false })
    reaper._add_track({
        name = "Track 3",
        fx = {
            { name = "VST: Compressor", enabled = true },
            { name = "VST: EQ", enabled = false },
        }
    })
end

function TestTrack:test_new()
    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)

    luaunit.assertNotIsNil(track, "Track should be created")
    luaunit.assertEquals("table", type(track), "Track should be a table")
end

function TestTrack:test_get_name()
    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)

    local name = track:get_name()
    luaunit.assertEquals("Track 1", name, "Track name should match")
end

function TestTrack:test_has_track_fx()
    local track_ptr = reaper.GetTrack(0, 0)
    local track_no_fx = Track:new(track_ptr)
    luaunit.assertFalse(track_no_fx:has_track_fx(), "Track 1 should have no FX")

    local track_ptr2 = reaper.GetTrack(0, 2)  -- Track 3 with FX
    local track_with_fx = Track:new(track_ptr2)
    luaunit.assertTrue(track_with_fx:has_track_fx(), "Track 3 should have FX")
end

function TestTrack:test_iter_track_fx_chain()
    local track_ptr = reaper.GetTrack(0, 2)  -- Track 3 with 2 FX
    local track = Track:new(track_ptr)

    local fx_names = {}
    for fx in track:iter_track_fx_chain() do
        table.insert(fx_names, fx:get_name())
    end

    luaunit.assertEquals(2, #fx_names, "Should iterate over 2 FX")
    luaunit.assertEquals("VST: Compressor", fx_names[1], "First FX name should match")
    luaunit.assertEquals("VST: EQ", fx_names[2], "Second FX name should match")
end
