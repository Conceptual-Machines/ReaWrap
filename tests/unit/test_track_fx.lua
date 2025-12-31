--- Unit tests for TrackFX module.
-- @module unit.test_track_fx

local assert = require("assertions")
local Track = require("track")
local TrackFX = require("track_fx")

local M = {}

function M.run()
    -- Setup mock data
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

    M.test_new()
    M.test_get_name()
    M.test_get_enabled()
    M.test_set_enabled()
    M.test_is_container()
    M.test_container_methods()
end

function M.test_new()
    assert.set_test("TrackFX:new")

    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)
    local fx = TrackFX:new(track, 0)

    assert.is_not_nil(fx, "TrackFX should be created")
    assert.is_type(fx, "table", "TrackFX should be a table")
end

function M.test_get_name()
    assert.set_test("TrackFX:get_name")

    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)
    local fx = TrackFX:new(track, 0)

    local name = fx:get_name()
    assert.equals("VST: Compressor", name, "FX name should match")
end

function M.test_get_enabled()
    assert.set_test("TrackFX:get_enabled")

    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)
    local fx = TrackFX:new(track, 0)

    local enabled = fx:get_enabled()
    assert.is_true(enabled, "FX should be enabled")
end

function M.test_set_enabled()
    assert.set_test("TrackFX:set_enabled")

    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)
    local fx = TrackFX:new(track, 0)

    fx:set_enabled(false)
    local enabled = fx:get_enabled()
    assert.is_false(enabled, "FX should be disabled after set_enabled(false)")

    fx:set_enabled(true)
    enabled = fx:get_enabled()
    assert.is_true(enabled, "FX should be enabled after set_enabled(true)")
end

function M.test_is_container()
    assert.set_test("TrackFX:is_container")

    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)

    local fx1 = TrackFX:new(track, 0)  -- Compressor
    local fx2 = TrackFX:new(track, 1)  -- Container

    assert.is_false(fx1:is_container(), "Compressor should not be a container")
    assert.is_true(fx2:is_container(), "Container FX should be a container")
end

function M.test_container_methods()
    assert.set_test("TrackFX:container_methods")

    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)
    local container = TrackFX:new(track, 1)

    -- Test get_child_count
    local count = container:get_child_count()
    assert.equals(2, count, "Container should have 2 children")

    -- Test get_container_channel_count
    local channels = container:get_container_channel_count()
    assert.equals(4, channels, "Container should have 4 internal channels")

    -- Test set_container_channel_count
    container:set_container_channel_count(8)
    channels = container:get_container_channel_count()
    assert.equals(8, channels, "Container channels should be updated to 8")
end

return M
