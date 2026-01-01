--- Core Classes Integration Tests for ReaWrap.
-- Run this script inside REAPER to test Track, Project, Item, Take, TrackFX classes.
-- Can be run via CLI: /path/to/REAPER.app/Contents/MacOS/REAPER -newinst -script "path/to/test_core_classes.lua"
--
-- @module test_core_classes
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
-- Test Framework
--------------------------------------------------------------------------------

local TestRunner = {
    tests = {},
    results = {
        passed = 0,
        failed = 0,
        skipped = 0,
        errors = {},
    },
    log_file = nil,
}

function TestRunner:log(msg)
    reaper.ShowConsoleMsg(msg .. "\n")
    if self.log_file then
        self.log_file:write(msg .. "\n")
    end
end

function TestRunner:add(name, fn, requires_project)
    table.insert(self.tests, {
        name = name,
        fn = fn,
        requires_project = requires_project or false,
    })
end

function TestRunner:run_all(project_available)
    self.results = { passed = 0, failed = 0, skipped = 0, errors = {} }

    for _, test in ipairs(self.tests) do
        if test.requires_project and not project_available then
            self.results.skipped = self.results.skipped + 1
            self:log("⊘ " .. test.name .. " (skipped - needs project)")
        else
            local ok, err = pcall(test.fn)
            if ok then
                self.results.passed = self.results.passed + 1
                self:log("✓ " .. test.name)
            else
                self.results.failed = self.results.failed + 1
                self:log("✗ " .. test.name)
                self:log("  Error: " .. tostring(err))
                table.insert(self.results.errors, {
                    name = test.name,
                    error = tostring(err),
                })
            end
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

function TestRunner:assert_gt(expected, actual, msg)
    if not (actual > expected) then
        error(string.format("%s: expected > %s, got %s",
            msg or "Assert greater than", tostring(expected), tostring(actual)), 2)
    end
end

--------------------------------------------------------------------------------
-- Load Modules
--------------------------------------------------------------------------------

local Project = require("project")
local Track = require("track")

--------------------------------------------------------------------------------
-- Tests: Project Class
--------------------------------------------------------------------------------

TestRunner:add("Project:new creates instance", function()
    local proj = Project:new()
    TestRunner:assert_not_nil(proj)
    TestRunner:assert_equals("ReaProject*", proj.pointer_type)
end)

TestRunner:add("Project:get_name returns string", function()
    local proj = Project:new()
    local name = proj:get_name()
    TestRunner:assert_type("string", name)
end)

TestRunner:add("Project:count_tracks returns number", function()
    local proj = Project:new()
    local count = proj:count_tracks()
    TestRunner:assert_type("number", count)
    TestRunner:assert(count >= 0, "Track count should be >= 0")
end)

TestRunner:add("Project:get_cursor_position_ex returns number", function()
    local proj = Project:new()
    local pos = proj:get_cursor_position_ex()
    TestRunner:assert_type("number", pos)
    TestRunner:assert(pos >= 0, "Cursor position should be >= 0")
end)

TestRunner:add("Project:get_play_state_ex returns number", function()
    local proj = Project:new()
    local state = proj:get_play_state_ex()
    TestRunner:assert_type("number", state)
end)

TestRunner:add("Project:get_project_length returns number", function()
    local proj = Project:new()
    local length = proj:get_project_length()
    TestRunner:assert_type("number", length)
    TestRunner:assert(length >= 0, "Project length should be >= 0")
end)

TestRunner:add("Project:get_project_time_signature returns bpm and bpi", function()
    local proj = Project:new()
    local bpm, bpi = proj:get_project_time_signature()
    TestRunner:assert_type("number", bpm)
    TestRunner:assert_type("number", bpi)
    TestRunner:assert_gt(0, bpm, "BPM should be > 0")
    TestRunner:assert_gt(0, bpi, "BPI should be > 0")
end)

TestRunner:add("Project:get_play_rate returns number", function()
    local proj = Project:new()
    local rate = proj:get_play_rate()
    TestRunner:assert_type("number", rate)
    TestRunner:assert_gt(0, rate, "Play rate should be > 0")
end)

TestRunner:add("Project:count_media_items returns number", function()
    local proj = Project:new()
    local count = proj:count_media_items()
    TestRunner:assert_type("number", count)
    TestRunner:assert(count >= 0, "Item count should be >= 0")
end)

TestRunner:add("Project:count_selected_tracks returns number", function()
    local proj = Project:new()
    local count = proj:count_selected_tracks()
    TestRunner:assert_type("number", count)
    TestRunner:assert(count >= 0, "Selected track count should be >= 0")
end)

TestRunner:add("Project:get_master_track returns Track", function()
    local proj = Project:new()
    local master = proj:get_master_track()
    TestRunner:assert_not_nil(master)
    TestRunner:assert_equals("MediaTrack*", master.pointer_type)
end)

TestRunner:add("Project:__tostring works", function()
    local proj = Project:new()
    local str = tostring(proj)
    TestRunner:assert_type("string", str)
    TestRunner:assert(str:match("^<Project"), "Should start with <Project")
end)

TestRunner:add("Project constants exist", function()
    TestRunner:assert_not_nil(Project.NudgeConstants)
    TestRunner:assert_not_nil(Project.NudgeConstants.FLAG)
    TestRunner:assert_not_nil(Project.NudgeConstants.WHAT)
    TestRunner:assert_not_nil(Project.NudgeConstants.UNIT)
    TestRunner:assert_not_nil(Project.GetSetProjectInfoConstants)
    TestRunner:assert_not_nil(Project.GetSetProjectInfoStringConstants)
end)

--------------------------------------------------------------------------------
-- Tests: Track Class (requires at least one track)
--------------------------------------------------------------------------------

TestRunner:add("Track:new creates instance", function()
    local proj = Project:new()
    if proj:count_tracks() == 0 then
        error("No tracks available for testing")
    end
    local track = proj:get_track(0)
    TestRunner:assert_not_nil(track)
    TestRunner:assert_equals("MediaTrack*", track.pointer_type)
end, true)

TestRunner:add("Track:get_name returns string", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local name = track:get_name()
    TestRunner:assert_type("string", name)
end, true)

TestRunner:add("Track:__tostring works", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local str = tostring(track)
    TestRunner:assert_type("string", str)
    TestRunner:assert(str:match("^<Track"), "Should start with <Track")
end, true)

TestRunner:add("Track:count_items returns number", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local count = track:count_items()
    TestRunner:assert_type("number", count)
    TestRunner:assert(count >= 0, "Item count should be >= 0")
end, true)

TestRunner:add("Track:count_envelopes returns number", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local count = track:count_envelopes()
    TestRunner:assert_type("number", count)
    TestRunner:assert(count >= 0, "Envelope count should be >= 0")
end, true)

TestRunner:add("Track:get_track_fx_count returns number", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local count = track:get_track_fx_count()
    TestRunner:assert_type("number", count)
    TestRunner:assert(count >= 0, "FX count should be >= 0")
end, true)

TestRunner:add("Track:get_info_value returns numbers", function()
    local proj = Project:new()
    local track = proj:get_track(0)

    local vol = track:get_info_value("D_VOL")
    TestRunner:assert_type("number", vol)

    local pan = track:get_info_value("D_PAN")
    TestRunner:assert_type("number", pan)

    local mute = track:get_info_value("B_MUTE")
    TestRunner:assert_type("number", mute)
end, true)

TestRunner:add("Track:is_track_selected returns boolean", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local selected = track:get_info_value("I_SELECTED")
    TestRunner:assert_type("number", selected)
end, true)

TestRunner:add("Track:get_guid returns string", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local guid = track:get_guid()
    TestRunner:assert_type("string", guid)
    TestRunner:assert(guid:match("^{"), "GUID should start with {")
end, true)

TestRunner:add("Track:get_color returns number", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local color = track:get_color()
    TestRunner:assert_type("number", color)
end, true)

TestRunner:add("Track:get_depth returns number", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local depth = track:get_depth()
    TestRunner:assert_type("number", depth)
    TestRunner:assert(depth >= 0, "Depth should be >= 0")
end, true)

TestRunner:add("Track:get_automation_mode returns number", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local mode = track:get_automation_mode()
    TestRunner:assert_type("number", mode)
end, true)

TestRunner:add("Track constants exist", function()
    TestRunner:assert_not_nil(Track.GetInfoValueConstants)
    TestRunner:assert_not_nil(Track.GetSetInfoStringConstants)
    TestRunner:assert_not_nil(Track.GroupMembershipConstants)
    TestRunner:assert_not_nil(Track.GetTrackSendInfoValueConstants)
    TestRunner:assert_not_nil(Track.SetInfoValueConstants)
    TestRunner:assert_not_nil(Track.SetTrackSendInfoValueConstants)
end)

TestRunner:add("Track:get_items returns table", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local items = track:get_items()
    TestRunner:assert_type("table", items)
end, true)

TestRunner:add("Track:get_track_fx_chain returns table", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local fxs = track:get_track_fx_chain()
    TestRunner:assert_type("table", fxs)
end, true)

TestRunner:add("Track:iter_items works", function()
    local proj = Project:new()
    local track = proj:get_track(0)
    local count = 0
    for _ in track:iter_items() do
        count = count + 1
    end
    TestRunner:assert_equals(track:count_items(), count)
end, true)

--------------------------------------------------------------------------------
-- Tests: Project Iteration
--------------------------------------------------------------------------------

TestRunner:add("Project:get_tracks returns table", function()
    local proj = Project:new()
    local tracks = proj:get_tracks()
    TestRunner:assert_type("table", tracks)
    TestRunner:assert_equals(proj:count_tracks(), #tracks)
end)

TestRunner:add("Project:iter_tracks works", function()
    local proj = Project:new()
    local count = 0
    for _ in proj:iter_tracks() do
        count = count + 1
    end
    TestRunner:assert_equals(proj:count_tracks(), count)
end)

TestRunner:add("Project:get_selected_tracks returns table", function()
    local proj = Project:new()
    local tracks = proj:get_selected_tracks()
    TestRunner:assert_type("table", tracks)
    TestRunner:assert_equals(proj:count_selected_tracks(), #tracks)
end)

--------------------------------------------------------------------------------
-- Tests: Version Module
--------------------------------------------------------------------------------

TestRunner:add("Version module loads", function()
    local version = require("version")
    TestRunner:assert_not_nil(version)
end)

TestRunner:add("Version module has version string", function()
    local version = require("version")
    TestRunner:assert_not_nil(version.VERSION)
    TestRunner:assert_type("string", version.VERSION)
end)

TestRunner:add("Version comparison works", function()
    local version = require("version")
    if version.compare then
        local result = version.compare("1.0.0", "1.0.1")
        TestRunner:assert_type("number", result)
        TestRunner:assert(result < 0, "1.0.0 should be less than 1.0.1")
    end
end)

--------------------------------------------------------------------------------
-- Tests: Helpers Module
--------------------------------------------------------------------------------

TestRunner:add("Helpers module loads", function()
    local helpers = require("helpers")
    TestRunner:assert_not_nil(helpers)
end)

TestRunner:add("Helpers.iter works", function()
    local helpers = require("helpers")
    local arr = { 1, 2, 3 }
    local sum = 0
    for v in helpers.iter(arr) do
        sum = sum + v
    end
    TestRunner:assert_equals(6, sum)
end)

TestRunner:add("Helpers.log_func returns function", function()
    local helpers = require("helpers")
    local logger = helpers.log_func("Test")
    TestRunner:assert_type("function", logger)
end)

--------------------------------------------------------------------------------
-- Main Entry Point
--------------------------------------------------------------------------------

reaper.ClearConsole()

-- Open log file
local log_path = root_path .. "tests/integration/test_results.log"
TestRunner.log_file = io.open(log_path, "w")

TestRunner:log("ReaWrap Core Classes Integration Tests")
TestRunner:log("======================================")
TestRunner:log("")
TestRunner:log("REAPER Version: " .. reaper.GetAppVersion())
TestRunner:log("Log file: " .. log_path)
TestRunner:log("")

-- Check if we have a project with tracks for track tests
local proj = Project:new()
local has_tracks = proj:count_tracks() > 0

if not has_tracks then
    TestRunner:log("NOTE: No tracks in project - some tests will be skipped")
    TestRunner:log("      Create a track to run all tests")
    TestRunner:log("")
end

-- Run tests
local results = TestRunner:run_all(has_tracks)

-- Summary
TestRunner:log("")
TestRunner:log("======================================")
TestRunner:log(string.format("Passed:  %d", results.passed))
TestRunner:log(string.format("Failed:  %d", results.failed))
TestRunner:log(string.format("Skipped: %d", results.skipped))
TestRunner:log("======================================")

if results.failed == 0 then
    TestRunner:log("All tests passed!")
else
    TestRunner:log("Some tests failed - see errors above")
end

-- Close log file
if TestRunner.log_file then
    TestRunner.log_file:close()
end

-- Show message box with summary
reaper.ShowMessageBox(
    string.format(
        "ReaWrap Core Classes Integration Tests\n\n" ..
        "Passed: %d\nFailed: %d\nSkipped: %d\n\n" ..
        "Log saved to:\n%s",
        results.passed, results.failed, results.skipped, log_path
    ),
    "Test Results",
    0
)
