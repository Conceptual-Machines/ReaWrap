--- Unit tests for Track module.
-- @module unit.test_track

local assert = require("assertions")
local Track = require("track")

local M = {}

function M.run()
    -- Setup mock data
    reaper._add_track({ name = "Track 1", selected = true })
    reaper._add_track({ name = "Track 2", selected = false })
    reaper._add_track({
        name = "Track 3",
        fx = {
            { name = "VST: Compressor", enabled = true },
            { name = "VST: EQ", enabled = false },
        }
    })

    M.test_new()
    M.test_get_name()
    M.test_set_name()
    M.test_get_fx_count()
    M.test_iter_track_fx_chain()
end

function M.test_new()
    assert.set_test("Track:new")

    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)

    assert.is_not_nil(track, "Track should be created")
    assert.is_type(track, "table", "Track should be a table")
end

function M.test_get_name()
    assert.set_test("Track:get_name")

    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)

    local name = track:get_name()
    assert.equals("Track 1", name, "Track name should match")
end

function M.test_set_name()
    assert.set_test("Track:set_name")

    local track_ptr = reaper.GetTrack(0, 0)
    local track = Track:new(track_ptr)

    track:set_name("New Name")
    local name = track:get_name()
    assert.equals("New Name", name, "Track name should be updated")
end

function M.test_get_fx_count()
    assert.set_test("Track:get_fx_count")

    local track_ptr = reaper.GetTrack(0, 2)  -- Track 3 with 2 FX
    local track = Track:new(track_ptr)

    local count = track:get_fx_count()
    assert.equals(2, count, "Track should have 2 FX")
end

function M.test_iter_track_fx_chain()
    assert.set_test("Track:iter_track_fx_chain")

    local track_ptr = reaper.GetTrack(0, 2)  -- Track 3 with 2 FX
    local track = Track:new(track_ptr)

    local fx_names = {}
    for fx in track:iter_track_fx_chain() do
        table.insert(fx_names, fx:get_name())
    end

    assert.length(fx_names, 2, "Should iterate over 2 FX")
    assert.equals("VST: Compressor", fx_names[1], "First FX name should match")
    assert.equals("VST: EQ", fx_names[2], "Second FX name should match")
end

return M
