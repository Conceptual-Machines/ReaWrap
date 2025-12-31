--- Unit tests for version module.
-- @module unit.test_version

local assert = require("assertions")
local version = require("version")

local M = {}

function M.run()
    M.test_version_exists()
    M.test_version_format()
end

function M.test_version_exists()
    assert.set_test("version.VERSION")

    assert.is_not_nil(version.VERSION, "VERSION should be defined")
    assert.is_type(version.VERSION, "string", "VERSION should be a string")
end

function M.test_version_format()
    assert.set_test("version format")

    -- Version should match semver pattern (e.g., "0.2.0")
    local major, minor, patch = version.VERSION:match("^(%d+)%.(%d+)%.(%d+)")

    assert.is_not_nil(major, "Version should have major number")
    assert.is_not_nil(minor, "Version should have minor number")
    assert.is_not_nil(patch, "Version should have patch number")
end

return M
