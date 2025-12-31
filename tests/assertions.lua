--- Simple assertion helpers for testing.
-- No external dependencies, works with standard Lua.
--
-- Usage:
--   local assert = require("tests.assertions")
--   assert.equals(1, 1)
--   assert.is_true(true)
--   assert.contains("hello world", "world")
--
-- @module assertions
-- @author Nomad Monad
-- @license MIT

local M = {}

local passed = 0
local failed = 0
local current_test = ""

--------------------------------------------------------------------------------
-- Output Helpers
--------------------------------------------------------------------------------

local function output(msg)
    if reaper and reaper.ShowConsoleMsg then
        reaper.ShowConsoleMsg(msg .. "\n")
    else
        print(msg)
    end
end

local function red(msg)
    return msg  -- No color in basic output
end

local function green(msg)
    return msg
end

--------------------------------------------------------------------------------
-- Test Context
--------------------------------------------------------------------------------

--- Set the current test name (for error messages)
function M.set_test(name)
    current_test = name
end

--- Get test results summary
function M.get_results()
    return {
        passed = passed,
        failed = failed,
        total = passed + failed,
    }
end

--- Reset counters
function M.reset()
    passed = 0
    failed = 0
    current_test = ""
end

--- Print summary
function M.summary()
    output("")
    output("========================================")
    output(string.format("Tests: %d passed, %d failed, %d total",
        passed, failed, passed + failed))
    output("========================================")
    return failed == 0
end

--------------------------------------------------------------------------------
-- Assertion Functions
--------------------------------------------------------------------------------

local function fail(msg)
    failed = failed + 1
    local prefix = current_test ~= "" and ("[" .. current_test .. "] ") or ""
    output("✗ FAIL: " .. prefix .. msg)
end

local function pass(msg)
    passed = passed + 1
    if msg then
        local prefix = current_test ~= "" and ("[" .. current_test .. "] ") or ""
        output("✓ PASS: " .. prefix .. msg)
    end
end

--- Assert that a value is truthy
function M.is_true(value, msg)
    if value then
        pass(msg)
        return true
    else
        fail(msg or "Expected truthy value, got: " .. tostring(value))
        return false
    end
end

--- Assert that a value is falsy
function M.is_false(value, msg)
    if not value then
        pass(msg)
        return true
    else
        fail(msg or "Expected falsy value, got: " .. tostring(value))
        return false
    end
end

--- Assert that a value is nil
function M.is_nil(value, msg)
    if value == nil then
        pass(msg)
        return true
    else
        fail(msg or "Expected nil, got: " .. tostring(value))
        return false
    end
end

--- Assert that a value is not nil
function M.is_not_nil(value, msg)
    if value ~= nil then
        pass(msg)
        return true
    else
        fail(msg or "Expected non-nil value")
        return false
    end
end

--- Assert equality
function M.equals(expected, actual, msg)
    if expected == actual then
        pass(msg)
        return true
    else
        fail(msg or string.format("Expected %s, got %s",
            tostring(expected), tostring(actual)))
        return false
    end
end

--- Assert not equal
function M.not_equals(expected, actual, msg)
    if expected ~= actual then
        pass(msg)
        return true
    else
        fail(msg or string.format("Expected not equal to %s", tostring(expected)))
        return false
    end
end

--- Assert greater than
function M.greater_than(expected, actual, msg)
    if actual > expected then
        pass(msg)
        return true
    else
        fail(msg or string.format("Expected %s > %s",
            tostring(actual), tostring(expected)))
        return false
    end
end

--- Assert less than
function M.less_than(expected, actual, msg)
    if actual < expected then
        pass(msg)
        return true
    else
        fail(msg or string.format("Expected %s < %s",
            tostring(actual), tostring(expected)))
        return false
    end
end

--- Assert string contains substring
function M.contains(haystack, needle, msg)
    if type(haystack) == "string" and haystack:find(needle, 1, true) then
        pass(msg)
        return true
    else
        fail(msg or string.format("Expected '%s' to contain '%s'",
            tostring(haystack), tostring(needle)))
        return false
    end
end

--- Assert table contains value
function M.table_contains(tbl, value, msg)
    if type(tbl) == "table" then
        for _, v in pairs(tbl) do
            if v == value then
                pass(msg)
                return true
            end
        end
    end
    fail(msg or string.format("Expected table to contain %s", tostring(value)))
    return false
end

--- Assert table has key
function M.has_key(tbl, key, msg)
    if type(tbl) == "table" and tbl[key] ~= nil then
        pass(msg)
        return true
    else
        fail(msg or string.format("Expected table to have key '%s'", tostring(key)))
        return false
    end
end

--- Assert table length
function M.length(tbl, expected, msg)
    local len = 0
    if type(tbl) == "table" then
        len = #tbl
    elseif type(tbl) == "string" then
        len = #tbl
    end

    if len == expected then
        pass(msg)
        return true
    else
        fail(msg or string.format("Expected length %d, got %d", expected, len))
        return false
    end
end

--- Assert type
function M.is_type(value, expected_type, msg)
    local actual_type = type(value)
    if actual_type == expected_type then
        pass(msg)
        return true
    else
        fail(msg or string.format("Expected type '%s', got '%s'",
            expected_type, actual_type))
        return false
    end
end

--- Assert function throws an error
function M.throws(func, expected_msg, msg)
    local ok, err = pcall(func)
    if not ok then
        if expected_msg then
            if err:find(expected_msg, 1, true) then
                pass(msg)
                return true
            else
                fail(msg or string.format("Expected error containing '%s', got '%s'",
                    expected_msg, tostring(err)))
                return false
            end
        else
            pass(msg)
            return true
        end
    else
        fail(msg or "Expected function to throw an error")
        return false
    end
end

--- Assert function does not throw
function M.does_not_throw(func, msg)
    local ok, err = pcall(func)
    if ok then
        pass(msg)
        return true
    else
        fail(msg or "Expected function not to throw, got: " .. tostring(err))
        return false
    end
end

--- Assert approximately equal (for floats)
function M.approx_equals(expected, actual, tolerance, msg)
    tolerance = tolerance or 0.0001
    if math.abs(expected - actual) <= tolerance then
        pass(msg)
        return true
    else
        fail(msg or string.format("Expected ~%s (±%s), got %s",
            tostring(expected), tostring(tolerance), tostring(actual)))
        return false
    end
end

return M
