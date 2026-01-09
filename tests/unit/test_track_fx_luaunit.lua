--- Unit tests for TrackFX module (LuaUnit version).
-- @module unit.test_track_fx_luaunit

local luaunit = require("luaunit")
local Track = require("track")
local TrackFX = require("track_fx")

TestTrackFX = {}

function TestTrackFX:setUp()
    -- Setup mock data before each test
    reaper._reset()
    reaper._add_track({
        name = "FX Track",
        fx = {
            {
                name = "VST: Compressor",
                enabled = true,
                params = {
                    { value = 0.5, min = 0, max = 1 },
                    { value = -10, min = -60, max = 0 },
                },
            },
            {
                name = "Container",
                enabled = true,
                config = {
                    container_count = "2",
                    container_nch = "4",
                },
            },
        }
    })
end

function TestTrackFX:test_new()
    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)
    local fx = TrackFX:new(track, 0)

    luaunit.assertNotIsNil(fx, "TrackFX should be created")
    luaunit.assertEquals("table", type(fx), "TrackFX should be a table")
end

function TestTrackFX:test_get_name()
    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)
    local fx = TrackFX:new(track, 0)

    local name = fx:get_name()
    luaunit.assertEquals("VST: Compressor", name, "FX name should match")
end

function TestTrackFX:test_get_enabled()
    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)
    local fx = TrackFX:new(track, 0)

    local enabled = fx:get_enabled()
    luaunit.assertTrue(enabled, "FX should be enabled")
end

function TestTrackFX:test_set_enabled()
    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)
    local fx = TrackFX:new(track, 0)

    fx:set_enabled(false)
    local enabled = fx:get_enabled()
    luaunit.assertFalse(enabled, "FX should be disabled after set_enabled(false)")

    fx:set_enabled(true)
    enabled = fx:get_enabled()
    luaunit.assertTrue(enabled, "FX should be enabled after set_enabled(true)")
end

function TestTrackFX:test_is_container()
    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)

    local fx1 = TrackFX:new(track, 0)  -- Compressor
    local fx2 = TrackFX:new(track, 1)  -- Container

    luaunit.assertFalse(fx1:is_container(), "Compressor should not be a container")
    luaunit.assertTrue(fx2:is_container(), "Container FX should be a container")
end

function TestTrackFX:test_container_methods()
    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)
    local container = TrackFX:new(track, 1)

    -- Test get_container_child_count
    local count = container:get_container_child_count()
    luaunit.assertEquals(2, count, "Container should have 2 children")

    -- Test get_container_channels
    local channels = container:get_container_channels()
    luaunit.assertEquals(4, channels, "Container should have 4 internal channels")

    -- Test set_container_channels
    container:set_container_channels(8)
    channels = container:get_container_channels()
    luaunit.assertEquals(8, channels, "Container channels should be updated to 8")
end
