-- Test script to verify the stale pointer fix for nested containers
-- This reproduces the SideFX issue: adding a chain to a nested rack
-- Run this script in REAPER to test

local r = reaper

-- Load ReaWrap
local script_path = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or ""
local root_path = script_path:match("^(.+/)tests/")
package.path = root_path .. "lua/?.lua;" .. package.path
package.path = root_path .. "lua/?/init.lua;" .. package.path

local Track = require("track")

-- Get first selected track
local track_ptr = r.GetTrack(0, 0)
if not track_ptr then
    r.ShowConsoleMsg("ERROR: No track found. Please select a track.\n")
    return
end

local track = Track:new(track_ptr)

-- Clear all FX
r.ShowConsoleMsg("\n=================================================================\n")
r.ShowConsoleMsg("TESTING STALE POINTER FIX FOR NESTED CONTAINERS\n")
r.ShowConsoleMsg("=================================================================\n\n")

local fx_count = r.TrackFX_GetCount(track_ptr)
for i = fx_count - 1, 0, -1 do
    r.TrackFX_Delete(track_ptr, i)
end

-- Step 1: Create Rack1 (simulating a SideFX rack)
r.ShowConsoleMsg("Step 1: Creating Rack1 (outer rack)\n")
local rack1 = track:create_container()
local rack1_guid = rack1:get_guid()
rack1:set_named_config_param("renamed_name", "Rack1")
r.ShowConsoleMsg(string.format("  Rack1: guid=%s, pointer=0x%X\n", rack1_guid:sub(1,8), rack1.pointer))

-- Step 2: Create Rack2 and nest it inside Rack1
r.ShowConsoleMsg("\nStep 2: Creating Rack2 and nesting it in Rack1\n")
local rack2 = track:create_container()
local rack2_guid = rack2:get_guid()
rack2:set_named_config_param("renamed_name", "Rack2")
r.ShowConsoleMsg(string.format("  Rack2: guid=%s, pointer=%d (before nesting)\n", rack2_guid:sub(1,8), rack2.pointer))

-- Nest Rack2 inside Rack1
rack1 = track:find_fx_by_guid(rack1_guid)
rack2 = track:find_fx_by_guid(rack2_guid)
local nest_success = rack1:add_fx_to_container(rack2, 0)
r.ShowConsoleMsg(string.format("  Nest Rack2 in Rack1: %s\n", tostring(nest_success)))

-- Re-find Rack2 (pointer will be encoded after nesting)
rack2 = track:find_fx_by_guid(rack2_guid)
r.ShowConsoleMsg(string.format("  Rack2 after nesting: pointer=0x%X (encoded)\n", rack2.pointer))

-- Step 3: This is where the bug occurs - try to check if Rack2 is a container
r.ShowConsoleMsg("\nStep 3: Testing stale pointer handling\n")
r.ShowConsoleMsg(string.format("  rack2:is_container() = %s\n", tostring(rack2:is_container())))
r.ShowConsoleMsg(string.format("  rack2:get_container_child_count() = %d\n", rack2:get_container_child_count()))

local parent = rack2:get_parent_container()
r.ShowConsoleMsg(string.format("  rack2:get_parent_container() = %s\n", tostring(parent ~= nil)))

-- Step 4: Now try to add an FX to the nested Rack2 (this is what fails in SideFX)
r.ShowConsoleMsg("\nStep 4: Adding FX to nested Rack2 (the critical test)\n")
local fx = track:add_fx_by_name("ReaEQ", false, -1)
local fx_guid = fx:get_guid()
r.ShowConsoleMsg(string.format("  Created FX: %s\n", fx:get_name()))

-- Re-find rack2 (simulating what SideFX does)
rack2 = track:find_fx_by_guid(rack2_guid)
fx = track:find_fx_by_guid(fx_guid)

r.ShowConsoleMsg(string.format("  Before add_fx_to_container:\n"))
r.ShowConsoleMsg(string.format("    Rack2: pointer=0x%X, is_container=%s\n",
    rack2.pointer, tostring(rack2:is_container())))

local add_success = rack2:add_fx_to_container(fx, 0)
r.ShowConsoleMsg(string.format("  add_fx_to_container() returned: %s\n", tostring(add_success)))

-- Verify
rack2 = track:find_fx_by_guid(rack2_guid)
local child_count = rack2:get_container_child_count()
r.ShowConsoleMsg(string.format("  Rack2 child count after add: %d\n", child_count))

-- Final result
r.ShowConsoleMsg("\n=================================================================\n")
if add_success and child_count == 1 then
    r.ShowConsoleMsg("✓ SUCCESS! The stale pointer fix works!\n")
    r.ShowConsoleMsg("  FX was successfully added to the nested container.\n")
else
    r.ShowConsoleMsg("✗ FAILED! The bug is still present.\n")
    r.ShowConsoleMsg("  FX was not added to the nested container.\n")
end
r.ShowConsoleMsg("=================================================================\n\n")
