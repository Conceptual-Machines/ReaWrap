--- Unit tests for version module (LuaUnit version).
-- @module unit.test_version_luaunit

local luaunit = require("luaunit")
local version = require("version")

TestVersion = {}

function TestVersion:test_version_exists()
    luaunit.assertNotIsNil(version.VERSION, "VERSION should be defined")
    luaunit.assertEquals("string", type(version.VERSION), "VERSION should be a string")
end

function TestVersion:test_version_format()
    -- Version should match semver pattern (e.g., "0.2.0")
    local major, minor, patch = version.VERSION:match("^(%d+)%.(%d+)%.(%d+)")

    luaunit.assertNotIsNil(major, "Version should have major number")
    luaunit.assertNotIsNil(minor, "Version should have minor number")
    luaunit.assertNotIsNil(patch, "Version should have patch number")
end
