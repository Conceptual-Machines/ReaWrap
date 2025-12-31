--- Test runner for ReaWrap.
-- Can run both inside REAPER and standalone with Lua.
--
-- Usage (standalone):
--   cd ReaWrap
--   lua tests/runner.lua
--
-- Usage (in REAPER):
--   Run this script as a ReaScript
--
-- @module runner
-- @author Nomad Monad
-- @license MIT

--------------------------------------------------------------------------------
-- Setup Paths
--------------------------------------------------------------------------------

local script_path
local root_path

-- Detect if running in REAPER or standalone
if reaper then
    -- Running in REAPER
    script_path = ({ reaper.get_action_context() })[2]:match('^.+[\\//]')
    root_path = script_path:match('^(.+/)tests/')
else
    -- Running standalone - set up paths
    local info = debug.getinfo(1, "S")
    script_path = info.source:match("^@(.+/)") or "./"
    root_path = script_path:match("^(.+/)tests/") or script_path .. "../"

    -- Load mock reaper
    package.path = script_path .. "?.lua;" .. package.path
    require("mock.reaper")
end

-- Add paths
package.path = root_path .. "lua/?.lua;" .. package.path
package.path = root_path .. "lua/?/init.lua;" .. package.path
package.path = root_path .. "tests/?.lua;" .. package.path

--------------------------------------------------------------------------------
-- Test Discovery
--------------------------------------------------------------------------------

local function output(msg)
    -- In standalone mode (mock reaper), always use print
    -- In real REAPER, use ShowConsoleMsg
    if reaper and reaper._reset then
        -- Mock mode - use print
        print(msg)
    elseif reaper and reaper.ShowConsoleMsg then
        -- Real REAPER
        reaper.ShowConsoleMsg(msg .. "\n")
    else
        print(msg)
    end
end

-- List of test modules to run
local test_modules = {
    "unit.test_track",
    "unit.test_track_fx",
    "unit.test_version",
    "unit.test_imgui",
}

--------------------------------------------------------------------------------
-- Run Tests
--------------------------------------------------------------------------------

local assert = require("assertions")

output("")
output("========================================")
output("ReaWrap Test Runner")
output("========================================")
output("")

if not reaper or reaper._reset then
    output("Mode: Standalone (using mock REAPER API)")
else
    output("Mode: REAPER")
end
output("")

local all_passed = true

for _, module_name in ipairs(test_modules) do
    output("Running: " .. module_name)
    output("----------------------------------------")

    local ok, err = pcall(function()
        -- Reset mock state between test modules
        if reaper and reaper._reset then
            reaper._reset()
        end
        assert.reset()

        local test_module = require(module_name)
        if type(test_module) == "table" and test_module.run then
            test_module.run()
        end
    end)

    if not ok then
        output("ERROR loading/running " .. module_name .. ": " .. tostring(err))
        all_passed = false
    end

    local results = assert.get_results()
    if results.failed > 0 then
        all_passed = false
    end

    output("")
end

output("========================================")
if all_passed then
    output("All tests passed!")
else
    output("Some tests failed.")
end
output("========================================")

-- Return exit code for CI
if not reaper then
    os.exit(all_passed and 0 or 1)
end
