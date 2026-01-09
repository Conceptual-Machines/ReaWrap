--- Test runner for ReaWrap using LuaUnit.
-- Can run both inside REAPER and standalone with Lua.
--
-- Usage (standalone):
--   cd ReaWrap
--   lua tests/runner_luaunit.lua
--
-- Usage (in REAPER):
--   Run this script as a ReaScript
--
-- @module runner_luaunit
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
-- Load LuaUnit
--------------------------------------------------------------------------------

local luaunit = require("luaunit")

--------------------------------------------------------------------------------
-- Test Discovery
--------------------------------------------------------------------------------

-- List of test modules to run (LuaUnit format)
local test_modules = {
    "unit.test_track_luaunit",
    "unit.test_track_fx_luaunit",
    "unit.test_version_luaunit",
    "unit.test_imgui_luaunit",
}

--------------------------------------------------------------------------------
-- Run Tests
--------------------------------------------------------------------------------

print("")
print("========================================")
print("ReaWrap Test Runner (LuaUnit)")
print("========================================")
print("")

if not reaper or reaper._reset then
    print("Mode: Standalone (using mock REAPER API)")
else
    print("Mode: REAPER")
end
print("")

-- Load all test modules (LuaUnit auto-discovers Test* classes)
for _, module_name in ipairs(test_modules) do
    -- Clear cached module to allow re-running
    package.loaded[module_name] = nil
    require(module_name)
end

-- Run LuaUnit
local result = luaunit.LuaUnit.run()

-- Exit with proper code for CI
if not reaper then
    os.exit(result)
end
