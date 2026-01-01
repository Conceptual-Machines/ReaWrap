--- Container Operations Integration Tests for ReaWrap.
-- Tests container creation, nested containers, and FX movement.
-- Run this script inside REAPER to test container functionality.
--
-- @module test_containers
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
local TrackFX = require("track_fx")

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------

local function get_test_track()
    local proj = Project:new()
    if proj:count_tracks() == 0 then
        error("No tracks available - create a track first")
    end
    return proj:get_track(0)
end

local function clear_track_fx(track)
    local fx_count = track:get_track_fx_count()
    for i = fx_count - 1, 0, -1 do
        local fx = TrackFX:new(track, i)
        fx:delete()
    end
end

local function add_test_fx(track, name)
    local idx = reaper.TrackFX_AddByName(track.pointer, name, false, -1)
    if idx < 0 then
        error("Failed to add FX: " .. name)
    end
    return TrackFX:new(track, idx)
end

--------------------------------------------------------------------------------
-- Tests: Container Creation
--------------------------------------------------------------------------------

TestRunner:add("Track:create_container creates container", function()
    local track = get_test_track()
    clear_track_fx(track)

    local container = track:create_container(0)
    TestRunner:assert_not_nil(container)
    TestRunner:assert(container:is_container(), "Should be a container")
    TestRunner:assert_equals(0, container:get_container_child_count(), "Container should be empty")
end, true)

TestRunner:add("Track:create_container at specific position", function()
    local track = get_test_track()
    clear_track_fx(track)

    -- Add an FX first
    add_test_fx(track, "ReaEQ")

    -- Create container at position 1
    local container = track:create_container(1)
    TestRunner:assert_not_nil(container)
    TestRunner:assert(container:is_container(), "Should be a container")

    -- Verify FX count
    TestRunner:assert_equals(2, track:get_track_fx_count(), "Should have 2 FX (ReaEQ + Container)")
end, true)

--------------------------------------------------------------------------------
-- Tests: Adding FX to Containers
--------------------------------------------------------------------------------

TestRunner:add("TrackFX:add_fx_to_container moves FX into top-level container", function()
    local track = get_test_track()
    clear_track_fx(track)

    -- Create container
    local container = track:create_container(0)
    local container_guid = container:get_guid()

    -- Add FX to track
    local fx = add_test_fx(track, "ReaEQ")
    local fx_guid = fx:get_guid()  -- Store GUID before move!

    -- Move FX into container
    local success = container:add_fx_to_container(fx)
    TestRunner:assert(success, "Should successfully move FX into container")

    -- Verify FX is in container
    TestRunner:assert_equals(1, container:get_container_child_count(), "Container should have 1 child")

    -- Verify FX has parent (use stored GUID since fx object is stale)
    local moved_fx = track:find_fx_by_guid(fx_guid)
    TestRunner:assert_not_nil(moved_fx, "Should find FX by GUID")
    local parent = moved_fx:get_parent_container()
    TestRunner:assert_not_nil(parent, "FX should have parent container")
    TestRunner:assert(parent:get_guid() == container_guid, "Parent should be the container")
end, true)

TestRunner:add("TrackFX:add_fx_to_container with multiple FX", function()
    local track = get_test_track()
    clear_track_fx(track)

    -- Create container
    local container = track:create_container(0)

    -- Add multiple FX and store GUIDs immediately
    local fx1 = add_test_fx(track, "ReaEQ")
    local fx1_guid = fx1:get_guid()
    local fx2 = add_test_fx(track, "ReaComp")
    local fx2_guid = fx2:get_guid()

    -- Move first FX - need fresh reference since indices may shift
    fx1 = track:find_fx_by_guid(fx1_guid)
    container:add_fx_to_container(fx1)

    -- Move second FX - MUST re-lookup since indices shifted after first move!
    fx2 = track:find_fx_by_guid(fx2_guid)
    container:add_fx_to_container(fx2)

    -- Verify both are in container
    TestRunner:assert_equals(2, container:get_container_child_count(), "Container should have 2 children")

    -- Verify order
    local children = container:get_container_children()
    TestRunner:assert_equals(2, #children, "Should have 2 children")
    TestRunner:assert(children[1]:get_name():match("ReaEQ"), "First child should be ReaEQ")
    TestRunner:assert(children[2]:get_name():match("ReaComp"), "Second child should be ReaComp")
end, true)

--------------------------------------------------------------------------------
-- Tests: Nested Containers
--------------------------------------------------------------------------------

TestRunner:add("TrackFX:add_fx_to_container works with nested containers", function()
    local track = get_test_track()
    clear_track_fx(track)

    -- Create top-level container
    local container1 = track:create_container(0)
    local container1_guid = container1:get_guid()

    -- Add FX to track and store GUID
    local fx1 = add_test_fx(track, "ReaEQ")
    local fx1_guid = fx1:get_guid()

    -- Move FX into container1
    fx1 = track:find_fx_by_guid(fx1_guid)
    container1:add_fx_to_container(fx1)

    -- Create nested container inside container1 (add Container plugin to track, then move it)
    local nested_fx = add_test_fx(track, "Container")
    local nested_guid = nested_fx:get_guid()
    nested_fx = track:find_fx_by_guid(nested_guid)
    container1 = track:find_fx_by_guid(container1_guid)  -- Refresh container reference
    container1:add_fx_to_container(nested_fx)

    -- Now nested_fx should be a container inside container1
    local nested_container = track:find_fx_by_guid(nested_guid)
    TestRunner:assert_not_nil(nested_container, "Should find nested container")

    -- Add FX to nested container
    local fx3 = add_test_fx(track, "ReaEQ")
    local fx3_guid = fx3:get_guid()
    fx3 = track:find_fx_by_guid(fx3_guid)
    nested_container = track:find_fx_by_guid(nested_guid)  -- Refresh reference
    local success = nested_container:add_fx_to_container(fx3)
    TestRunner:assert(success, "Should successfully add FX to nested container")

    -- Verify nested container has child
    nested_container = track:find_fx_by_guid(nested_guid)
    TestRunner:assert_equals(1, nested_container:get_container_child_count(), "Nested container should have 1 child")

    -- Verify FX has correct parent
    local moved_fx = track:find_fx_by_guid(fx3_guid)
    TestRunner:assert_not_nil(moved_fx, "Should find moved FX")
    local parent = moved_fx:get_parent_container()
    TestRunner:assert_not_nil(parent, "FX should have parent")
    TestRunner:assert(parent:get_guid() == nested_guid, "Parent should be nested container")
end, true)

TestRunner:add("TrackFX:move_out_of_container moves FX from nested container to parent", function()
    local track = get_test_track()
    clear_track_fx(track)

    -- Create top-level container
    local container1 = track:create_container(0)
    local container1_guid = container1:get_guid()

    -- Create nested container and store GUID
    local nested = add_test_fx(track, "Container")
    local nested_guid = nested:get_guid()
    nested = track:find_fx_by_guid(nested_guid)
    container1:add_fx_to_container(nested)

    -- Add FX to nested container
    local fx = add_test_fx(track, "ReaEQ")
    local fx_guid = fx:get_guid()
    fx = track:find_fx_by_guid(fx_guid)
    nested = track:find_fx_by_guid(nested_guid)
    nested:add_fx_to_container(fx)

    -- Verify FX is in nested container
    nested = track:find_fx_by_guid(nested_guid)
    TestRunner:assert_equals(1, nested:get_container_child_count(), "Nested should have 1 child")

    -- Move FX out to parent container
    fx = track:find_fx_by_guid(fx_guid)
    local success = fx:move_out_of_container()
    TestRunner:assert(success, "Should successfully move FX out")

    -- Verify FX is now in parent container
    fx = track:find_fx_by_guid(fx_guid)
    local parent = fx:get_parent_container()
    TestRunner:assert_not_nil(parent, "FX should have parent")
    TestRunner:assert(parent:get_guid() == container1_guid, "Parent should be container1")

    -- Verify nested container is empty
    nested = track:find_fx_by_guid(nested_guid)
    TestRunner:assert_equals(0, nested:get_container_child_count(), "Nested should be empty")
end, true)

--------------------------------------------------------------------------------
-- Tests: Track:add_fx_to_new_container
--------------------------------------------------------------------------------

TestRunner:add("Track:add_fx_to_new_container creates container and moves FX", function()
    local track = get_test_track()
    clear_track_fx(track)

    -- Add FX and store GUIDs
    local fx1 = add_test_fx(track, "ReaEQ")
    local fx1_guid = fx1:get_guid()
    local fx2 = add_test_fx(track, "ReaComp")
    local fx2_guid = fx2:get_guid()

    -- Create container with both FX (the function handles stale references internally)
    local container = track:add_fx_to_new_container({fx1, fx2})
    TestRunner:assert_not_nil(container, "Should create container")
    TestRunner:assert(container:is_container(), "Should be a container")
    TestRunner:assert_equals(2, container:get_container_child_count(), "Container should have 2 children")

    -- Verify both FX are in container using stored GUIDs
    fx1 = track:find_fx_by_guid(fx1_guid)
    fx2 = track:find_fx_by_guid(fx2_guid)
    TestRunner:assert_not_nil(fx1, "Should find fx1")
    TestRunner:assert_not_nil(fx2, "Should find fx2")
    TestRunner:assert_not_nil(fx1:get_parent_container(), "fx1 should have parent")
    TestRunner:assert_not_nil(fx2:get_parent_container(), "fx2 should have parent")
end, true)

TestRunner:add("Track:add_fx_to_new_container with nested containers", function()
    local track = get_test_track()
    clear_track_fx(track)

    -- Create first container with FX
    local fx1 = add_test_fx(track, "ReaEQ")
    local fx1_guid = fx1:get_guid()
    local container1 = track:add_fx_to_new_container({fx1})
    TestRunner:assert_not_nil(container1, "Should create container1")
    local container1_guid = container1:get_guid()

    -- Create second container with FX
    local fx2 = add_test_fx(track, "ReaComp")
    local fx2_guid = fx2:get_guid()
    local container2 = track:add_fx_to_new_container({fx2})
    TestRunner:assert_not_nil(container2, "Should create container2")
    local container2_guid = container2:get_guid()

    -- Re-lookup containers before moving (indices may have shifted)
    container1 = track:find_fx_by_guid(container1_guid)
    container2 = track:find_fx_by_guid(container2_guid)
    container1:add_fx_to_container(container2)

    -- Verify nested structure
    container1 = track:find_fx_by_guid(container1_guid)
    TestRunner:assert_equals(2, container1:get_container_child_count(), "Container1 should have 2 children")

    -- Verify container2 is nested
    container2 = track:find_fx_by_guid(container2_guid)
    local parent = container2:get_parent_container()
    TestRunner:assert_not_nil(parent, "Container2 should have parent")
    TestRunner:assert(parent:get_guid() == container1_guid, "Parent should be container1")
end, true)

--------------------------------------------------------------------------------
-- Tests: Container Iteration
--------------------------------------------------------------------------------

TestRunner:add("TrackFX:iter_container_children iterates all children", function()
    local track = get_test_track()
    clear_track_fx(track)

    -- Create container
    local container = track:create_container(0)
    local container_guid = container:get_guid()

    -- Add multiple FX and store GUIDs
    local fx1 = add_test_fx(track, "ReaEQ")
    local fx1_guid = fx1:get_guid()
    local fx2 = add_test_fx(track, "ReaComp")
    local fx2_guid = fx2:get_guid()
    local fx3 = add_test_fx(track, "ReaDelay")
    local fx3_guid = fx3:get_guid()

    -- Move each FX, re-looking up before each operation
    fx1 = track:find_fx_by_guid(fx1_guid)
    container = track:find_fx_by_guid(container_guid)
    container:add_fx_to_container(fx1)

    fx2 = track:find_fx_by_guid(fx2_guid)
    container = track:find_fx_by_guid(container_guid)
    container:add_fx_to_container(fx2)

    fx3 = track:find_fx_by_guid(fx3_guid)
    container = track:find_fx_by_guid(container_guid)
    container:add_fx_to_container(fx3)

    -- Iterate and count
    container = track:find_fx_by_guid(container_guid)
    local count = 0
    for child in container:iter_container_children() do
        count = count + 1
        TestRunner:assert_not_nil(child, "Child should not be nil")
        TestRunner:assert_not_nil(child:get_name(), "Child should have name")
    end

    TestRunner:assert_equals(3, count, "Should iterate 3 children")
    TestRunner:assert_equals(3, container:get_container_child_count(), "Container should have 3 children")
end, true)

--------------------------------------------------------------------------------
-- Tests: find_fx_by_guid with containers
--------------------------------------------------------------------------------

TestRunner:add("Track:find_fx_by_guid finds FX in nested containers", function()
    local track = get_test_track()
    clear_track_fx(track)

    -- Create nested structure
    local container1 = track:create_container(0)
    local container1_guid = container1:get_guid()

    -- Add FX and store GUID before moving
    local fx1 = add_test_fx(track, "ReaEQ")
    local fx1_guid = fx1:get_guid()
    fx1 = track:find_fx_by_guid(fx1_guid)
    container1:add_fx_to_container(fx1)

    -- Add nested container
    local nested = add_test_fx(track, "Container")
    local nested_guid = nested:get_guid()
    nested = track:find_fx_by_guid(nested_guid)
    container1 = track:find_fx_by_guid(container1_guid)
    container1:add_fx_to_container(nested)

    -- Add FX to nested container
    local fx2 = add_test_fx(track, "ReaComp")
    local fx2_guid = fx2:get_guid()
    fx2 = track:find_fx_by_guid(fx2_guid)
    nested = track:find_fx_by_guid(nested_guid)
    nested:add_fx_to_container(fx2)

    -- Find FX by GUID (using stored GUIDs)
    local found_fx1 = track:find_fx_by_guid(fx1_guid)
    local found_fx2 = track:find_fx_by_guid(fx2_guid)

    TestRunner:assert_not_nil(found_fx1, "Should find fx1")
    TestRunner:assert_not_nil(found_fx2, "Should find fx2")
    TestRunner:assert(found_fx1:get_name():match("ReaEQ"), "Found FX should be ReaEQ")
    TestRunner:assert(found_fx2:get_name():match("ReaComp"), "Found FX should be ReaComp")

    -- Verify parents
    TestRunner:assert_not_nil(found_fx1:get_parent_container(), "fx1 should have parent")
    TestRunner:assert_not_nil(found_fx2:get_parent_container(), "fx2 should have parent")
end, true)

--------------------------------------------------------------------------------
-- Main Entry Point
--------------------------------------------------------------------------------

reaper.ClearConsole()

-- Open log file
local log_path = root_path .. "tests/integration/test_containers_results.log"
TestRunner.log_file = io.open(log_path, "w")

TestRunner:log("ReaWrap Container Operations Integration Tests")
TestRunner:log("===============================================")
TestRunner:log("")
TestRunner:log("REAPER Version: " .. reaper.GetAppVersion())
TestRunner:log("Log file: " .. log_path)
TestRunner:log("")
TestRunner:log("NOTE: These tests require REAPER 7+ with container support")
TestRunner:log("")

-- Check if we have a project with tracks
local proj = Project:new()
local has_tracks = proj:count_tracks() > 0

if not has_tracks then
    TestRunner:log("ERROR: No tracks in project - create a track first")
    TestRunner:log("")
end

-- Run tests
local results = TestRunner:run_all(has_tracks)

-- Summary
TestRunner:log("")
TestRunner:log("===============================================")
TestRunner:log(string.format("Passed:  %d", results.passed))
TestRunner:log(string.format("Failed:  %d", results.failed))
TestRunner:log(string.format("Skipped: %d", results.skipped))
TestRunner:log("===============================================")

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
        "ReaWrap Container Operations Integration Tests\n\n" ..
        "Passed: %d\nFailed: %d\nSkipped: %d\n\n" ..
        "Log saved to:\n%s",
        results.passed, results.failed, results.skipped, log_path
    ),
    "Test Results",
    0
)
