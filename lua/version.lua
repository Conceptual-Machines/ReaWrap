--- ReaWrap version information.
-- @module version
-- @author Nomad Monad
-- @license MIT

local M = {}

M.MAJOR = 0
M.MINOR = 6
M.PATCH = 4

M.VERSION = string.format("%d.%d.%d", M.MAJOR, M.MINOR, M.PATCH)

M.NAME = "ReaWrap"
M.DESCRIPTION = "Object-oriented Lua wrapper for the REAPER ReaScript API"
M.AUTHOR = "Nomad Monad"
M.LICENSE = "MIT"
M.URL = "https://github.com/Conceptual-Machines/ReaWrap"

--- Get full version string.
-- @return string Version in format "ReaWrap v0.2.0"
function M.get_version_string()
  return string.format("%s v%s", M.NAME, M.VERSION)
end

--- Check if version meets minimum requirement.
-- @param major number Required major version
-- @param minor number Required minor version (default 0)
-- @param patch number Required patch version (default 0)
-- @return boolean True if current version >= required version
function M.check_version(major, minor, patch)
  minor = minor or 0
  patch = patch or 0

  if M.MAJOR > major then
    return true
  elseif M.MAJOR < major then
    return false
  end

  if M.MINOR > minor then
    return true
  elseif M.MINOR < minor then
    return false
  end

  return M.PATCH >= patch
end

return M
