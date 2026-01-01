--- Register test script as action and get command ID for CLI use.
-- Run this ONCE in REAPER to register the test script.
--
-- @module register_test_action
-- @author Nomad Monad

local script_path = ({ reaper.get_action_context() })[2]:match('^.+[\\//]')
local test_script = script_path .. "test_core_classes.lua"

-- Register the script (section 0 = main section)
local cmd_id = reaper.AddRemoveReaScript(true, 0, test_script, true)

if cmd_id > 0 then
    -- Get the command name (starts with _RS)
    local _, _, section, cmd, _, _, _ = reaper.get_action_context()

    -- Look up the registered script's identifier
    local action_name = reaper.ReverseNamedCommandLookup(cmd_id)

    local msg = string.format(
        "Test script registered successfully!\n\n" ..
        "Command ID: %d\n" ..
        "Action identifier: %s\n\n" ..
        "To run from CLI:\n" ..
        "/Applications/REAPER.app/Contents/MacOS/REAPER -newinst \"%s\"\n\n" ..
        "(Copy the action identifier above)",
        cmd_id,
        action_name or "(use ID)",
        action_name and ("action:" .. action_name) or ("action:" .. cmd_id)
    )

    reaper.ShowConsoleMsg(msg .. "\n")
    reaper.ShowMessageBox(msg, "Test Script Registered", 0)
else
    reaper.ShowMessageBox(
        "Failed to register test script.\n\nPath: " .. test_script,
        "Error",
        0
    )
end
