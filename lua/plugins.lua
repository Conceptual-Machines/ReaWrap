--- Provide utilities for scanning and searching installed FX plugins.
-- @author Nomad Monad
-- @license MIT
-- @release 0.3.2
-- @module plugins

local r = reaper
local helpers = require("helpers")

local Plugins = {}

--- Plugin format constants.
--- @within Constants
Plugins.Format = {
  VST3 = "VST3",
  VST3i = "VST3i",
  VST = "VST",
  VSTi = "VSTi",
  AU = "AU",
  AUi = "AUi",
  CLAP = "CLAP",
  CLAPi = "CLAPi",
  JS = "JS",
  DX = "DX",
  DXi = "DXi",
}

--- Default format preference order (higher priority first).
--- @within Constants
Plugins.FormatOrder = {
  "VST3", "VST3i", "CLAP", "CLAPi", "VST", "VSTi", "AU", "AUi", "JS", "DX", "DXi"
}

--- PluginInfo class for representing a single plugin.
--- @type PluginInfo
local PluginInfo = {}
PluginInfo.__index = PluginInfo

--- Create a new PluginInfo instance.
--- @param data table Table with plugin data
--- @return PluginInfo
function PluginInfo:new(data)
  local obj = setmetatable({}, self)
  obj.name = data.name or ""
  obj.full_name = data.full_name or ""
  obj.format = data.format or ""
  obj.manufacturer = data.manufacturer or ""
  obj.is_instrument = data.is_instrument or false
  obj.ident = data.ident or ""
  return obj
end

--- String representation.
--- @return string
function PluginInfo:__tostring()
  local type_str = self.is_instrument and "Instrument" or "Effect"
  return string.format("<%s: %s (%s)>", type_str, self.name, self.format)
end

Plugins.PluginInfo = PluginInfo

--------------------------------------------------------------------------------
-- Private helpers
--------------------------------------------------------------------------------

--- Check if plugin name indicates it's an instrument.
--- @param full_name string The full plugin name
--- @return boolean
local function is_instrument(full_name)
  if not full_name then return false end
  -- Instruments have 'i' suffix: VSTi, VST3i, AUi, CLAPi, DXi
  return full_name:match("^VSTi:") ~= nil
      or full_name:match("^VSTi ") ~= nil
      or full_name:match("^VST3i:") ~= nil
      or full_name:match("^VST3i ") ~= nil
      or full_name:match("^AUi:") ~= nil
      or full_name:match("^AUi ") ~= nil
      or full_name:match("^CLAPi:") ~= nil
      or full_name:match("^CLAPi ") ~= nil
      or full_name:match("^DXi:") ~= nil
      or full_name:match("^DXi ") ~= nil
end

--- Parse a plugin name to extract format, name, and manufacturer.
-- Example: "VST3: Serum (Xfer Records)" -> format="VST3", name="Serum", manufacturer="Xfer Records"
--- @param full_name string The full plugin name from REAPER
--- @return PluginInfo|nil
local function parse_plugin_name(full_name)
  if not full_name or full_name == "" then
    return nil
  end

  local info = {
    full_name = full_name,
    is_instrument = is_instrument(full_name),
    name = "",
    format = "",
    manufacturer = "",
    ident = "",
  }

  -- Parse format and name from "FORMAT: Name (Manufacturer)"
  local colon_pos = full_name:find(":")
  if colon_pos then
    -- Extract format (everything before colon)
    info.format = full_name:sub(1, colon_pos - 1):gsub("%s+$", "")

    -- Extract rest (name and possibly manufacturer)
    local rest = full_name:sub(colon_pos + 1):gsub("^%s+", "")

    -- Look for manufacturer in parentheses, but skip bitness markers
    local paren_start = rest:find("%(")
    if paren_start then
      local paren_end = rest:find("%)", paren_start)
      if paren_end then
        local paren_content = rest:sub(paren_start + 1, paren_end - 1)
        local paren_lower = paren_content:lower()

        -- Check if this is a bitness marker or numeric value (buffer sizes, etc)
        local is_bitness = paren_lower == "x64" or paren_lower == "x86"
            or paren_lower == "64bit" or paren_lower == "32bit"
            or paren_lower == "64-bit" or paren_lower == "32-bit"
        local is_numeric = paren_content:match("^%d+$") ~= nil
            or paren_content:match("^%d+ samples?$") ~= nil
            or paren_content:match("^%d+ch$") ~= nil

        -- Extract name (everything before opening paren, trimmed)
        info.name = rest:sub(1, paren_start - 1):gsub("%s+$", "")

        -- Set manufacturer if not a bitness marker or numeric value
        if not is_bitness and not is_numeric and paren_content ~= "" then
          info.manufacturer = paren_content
        end
      else
        info.name = rest
      end
    else
      info.name = rest
    end
  else
    -- No colon - assume JS or similar format
    if full_name:match("^JS:") then
      info.format = "JS"
      info.name = full_name:sub(4):gsub("^%s+", "")
    else
      info.format = "JS"
      info.name = full_name
    end
  end

  -- Trim whitespace from name
  info.name = info.name:gsub("^%s+", ""):gsub("%s+$", "")

  if info.name == "" then
    return nil
  end

  return PluginInfo:new(info)
end

--------------------------------------------------------------------------------
-- Scanner class
--------------------------------------------------------------------------------

--- PluginScanner class for scanning and caching installed plugins.
--- @type PluginScanner
local PluginScanner = {}
PluginScanner.__index = PluginScanner

--- Create a new PluginScanner instance.
--- @return PluginScanner
function PluginScanner:new()
  local obj = setmetatable({}, self)
  obj._plugins = {}
  obj._by_format = {}
  obj._instruments = {}
  obj._effects = {}
  obj._scanned = false
  return obj
end

--- Log messages.
--- @param ... varargs Messages to log
function PluginScanner:log(...)
  local logger = helpers.log_func("PluginScanner")
  logger(...)
end

--- Scan all installed plugins.
--- @return number Number of plugins found
function PluginScanner:scan()
  self._plugins = {}
  self._by_format = {}
  self._instruments = {}
  self._effects = {}

  local index = 0
  while true do
    local retval, name, ident = r.EnumInstalledFX(index)
    if not retval then
      break
    end

    if name and name ~= "" then
      local info = parse_plugin_name(name)
      if info then
        info.ident = ident or ""
        self._plugins[#self._plugins + 1] = info

        -- Index by format
        local fmt = info.format
        if not self._by_format[fmt] then
          self._by_format[fmt] = {}
        end
        self._by_format[fmt][#self._by_format[fmt] + 1] = info

        -- Index by type
        if info.is_instrument then
          self._instruments[#self._instruments + 1] = info
        else
          self._effects[#self._effects + 1] = info
        end
      end
    end

    index = index + 1
  end

  self._scanned = true
  return #self._plugins
end

--- Check if plugins have been scanned.
--- @return boolean
function PluginScanner:is_scanned()
  return self._scanned
end

--- Get all scanned plugins.
--- @return table Array of PluginInfo
function PluginScanner:get_plugins()
  return self._plugins
end

--- Iterate over all plugins.
--- @return function Iterator
function PluginScanner:iter_plugins()
  return helpers.iter(self._plugins)
end

--- Get plugins by format.
--- @param format string Plugin format (e.g., "VST3", "AU")
--- @return table Array of PluginInfo
function PluginScanner:get_by_format(format)
  return self._by_format[format] or {}
end

--- Iterate over plugins by format.
--- @param format string Plugin format
--- @return function Iterator
function PluginScanner:iter_by_format(format)
  return helpers.iter(self:get_by_format(format))
end

--- Get all instruments.
--- @return table Array of PluginInfo
function PluginScanner:get_instruments()
  return self._instruments
end

--- Iterate over instruments.
--- @return function Iterator
function PluginScanner:iter_instruments()
  return helpers.iter(self._instruments)
end

--- Get all effects.
--- @return table Array of PluginInfo
function PluginScanner:get_effects()
  return self._effects
end

--- Iterate over effects.
--- @return function Iterator
function PluginScanner:iter_effects()
  return helpers.iter(self._effects)
end

--- Get available formats.
--- @return table Array of format strings
function PluginScanner:get_formats()
  local formats = {}
  for fmt, _ in pairs(self._by_format) do
    formats[#formats + 1] = fmt
  end
  table.sort(formats)
  return formats
end

--- Iterate over available formats.
--- @return function Iterator
function PluginScanner:iter_formats()
  return helpers.iter(self:get_formats())
end

--- Find plugin by exact name (case-insensitive).
--- @param name string Plugin name to find
--- @return PluginInfo|nil
function PluginScanner:find(name)
  if not name then return nil end
  local name_lower = name:lower()

  for plugin in self:iter_plugins() do
    if plugin.name:lower() == name_lower then
      return plugin
    end
  end
  return nil
end

--- Search plugins by query (case-insensitive, partial match).
--- @param query string Search query
--- @return table Array of matching PluginInfo
function PluginScanner:search(query)
  local results = {}
  if not query or query == "" then
    return results
  end

  local query_lower = query:lower()

  for plugin in self:iter_plugins() do
    local name_lower = plugin.name:lower()
    local full_name_lower = plugin.full_name:lower()

    if name_lower:find(query_lower, 1, true) or full_name_lower:find(query_lower, 1, true) then
      results[#results + 1] = plugin
    end
  end

  return results
end

--- Iterate over search results.
--- @param query string Search query
--- @return function Iterator
function PluginScanner:iter_search(query)
  return helpers.iter(self:search(query))
end

--- Deduplicate plugins by name, keeping preferred format.
--- @param format_order table|nil Array of formats in preference order
--- @return table Array of deduplicated PluginInfo
function PluginScanner:deduplicate(format_order)
  format_order = format_order or Plugins.FormatOrder

  -- Create format priority map
  local priority = {}
  for i, fmt in ipairs(format_order) do
    priority[fmt] = i
  end

  -- Group by lowercase name
  local groups = {}
  for plugin in self:iter_plugins() do
    local key = plugin.name:lower()
    if not groups[key] then
      groups[key] = {}
    end
    groups[key][#groups[key] + 1] = plugin
  end

  -- Select best plugin from each group
  local results = {}
  for _, group in pairs(groups) do
    if #group == 1 then
      results[#results + 1] = group[1]
    else
      -- Sort by format priority
      table.sort(group, function(a, b)
        local pa = priority[a.format] or 999
        local pb = priority[b.format] or 999
        if pa ~= pb then
          return pa < pb
        end
        -- Prefer instruments if tied
        if a.is_instrument ~= b.is_instrument then
          return a.is_instrument
        end
        return false
      end)
      results[#results + 1] = group[1]
    end
  end

  -- Sort results by name
  table.sort(results, function(a, b)
    return a.name:lower() < b.name:lower()
  end)

  return results
end

--- Iterate over deduplicated plugins.
--- @param format_order table|nil Array of formats in preference order
--- @return function Iterator
function PluginScanner:iter_deduplicated(format_order)
  return helpers.iter(self:deduplicate(format_order))
end

--- Get unique manufacturers.
--- @return table Array of manufacturer strings
function PluginScanner:get_manufacturers()
  local seen = {}
  local manufacturers = {}

  for plugin in self:iter_plugins() do
    local mfr = plugin.manufacturer
    if mfr and mfr ~= "" and not seen[mfr] then
      seen[mfr] = true
      manufacturers[#manufacturers + 1] = mfr
    end
  end

  table.sort(manufacturers)
  return manufacturers
end

--- Iterate over manufacturers.
--- @return function Iterator
function PluginScanner:iter_manufacturers()
  return helpers.iter(self:get_manufacturers())
end

--- Get plugins by manufacturer.
--- @param manufacturer string Manufacturer name
--- @return table Array of PluginInfo
function PluginScanner:get_by_manufacturer(manufacturer)
  local results = {}
  if not manufacturer then return results end

  local mfr_lower = manufacturer:lower()
  for plugin in self:iter_plugins() do
    if plugin.manufacturer:lower() == mfr_lower then
      results[#results + 1] = plugin
    end
  end

  return results
end

--- Iterate over plugins by manufacturer.
--- @param manufacturer string Manufacturer name
--- @return function Iterator
function PluginScanner:iter_by_manufacturer(manufacturer)
  return helpers.iter(self:get_by_manufacturer(manufacturer))
end

--- Get plugin count.
--- @return number
function PluginScanner:count()
  return #self._plugins
end

--- Get instrument count.
--- @return number
function PluginScanner:count_instruments()
  return #self._instruments
end

--- Get effect count.
--- @return number
function PluginScanner:count_effects()
  return #self._effects
end

Plugins.PluginScanner = PluginScanner

--------------------------------------------------------------------------------
-- Module-level convenience functions
--------------------------------------------------------------------------------

-- Shared scanner instance
local _shared_scanner = nil

--- Get or create the shared scanner instance.
--- @return PluginScanner
function Plugins.get_scanner()
  if not _shared_scanner then
    _shared_scanner = PluginScanner:new()
  end
  return _shared_scanner
end

--- Scan plugins using the shared scanner.
--- @return number Number of plugins found
function Plugins.scan()
  local scanner = Plugins.get_scanner()
  return scanner:scan()
end

--- Get all plugins using the shared scanner.
--- Automatically scans if not already scanned.
--- @return table Array of PluginInfo
function Plugins.get_all()
  local scanner = Plugins.get_scanner()
  if not scanner:is_scanned() then
    scanner:scan()
  end
  return scanner:get_plugins()
end

--- Iterate over all plugins using the shared scanner.
--- @return function Iterator
function Plugins.iter_all()
  return helpers.iter(Plugins.get_all())
end

--- Search plugins using the shared scanner.
--- @param query string Search query
--- @return table Array of matching PluginInfo
function Plugins.search(query)
  local scanner = Plugins.get_scanner()
  if not scanner:is_scanned() then
    scanner:scan()
  end
  return scanner:search(query)
end

--- Iterate over search results.
--- @param query string Search query
--- @return function Iterator
function Plugins.iter_search(query)
  return helpers.iter(Plugins.search(query))
end

--- Find plugin by name using the shared scanner.
--- @param name string Plugin name
--- @return PluginInfo|nil
function Plugins.find(name)
  local scanner = Plugins.get_scanner()
  if not scanner:is_scanned() then
    scanner:scan()
  end
  return scanner:find(name)
end

--- Get instruments using the shared scanner.
--- @return table Array of PluginInfo
function Plugins.get_instruments()
  local scanner = Plugins.get_scanner()
  if not scanner:is_scanned() then
    scanner:scan()
  end
  return scanner:get_instruments()
end

--- Iterate over instruments.
--- @return function Iterator
function Plugins.iter_instruments()
  return helpers.iter(Plugins.get_instruments())
end

--- Get effects using the shared scanner.
--- @return table Array of PluginInfo
function Plugins.get_effects()
  local scanner = Plugins.get_scanner()
  if not scanner:is_scanned() then
    scanner:scan()
  end
  return scanner:get_effects()
end

--- Iterate over effects.
--- @return function Iterator
function Plugins.iter_effects()
  return helpers.iter(Plugins.get_effects())
end

return Plugins
