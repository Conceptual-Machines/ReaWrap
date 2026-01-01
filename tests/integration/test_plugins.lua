-- Quick integration test for the Plugins module
-- Run this in REAPER to verify the module works

-- Setup package path
local info = debug.getinfo(1, "S")
local script_path = info.source:match("@(.+[/\\])")
local lua_path = script_path:gsub("tests/integration/", "lua/")

package.path = lua_path .. "?.lua;" .. lua_path .. "?/init.lua;" .. package.path

local r = reaper

r.ShowConsoleMsg("\n=== Plugins Module Integration Test ===\n\n")

-- Load the module
local ok, Plugins = pcall(require, "plugins")
if not ok then
  r.ShowConsoleMsg("FAIL: Could not load plugins module: " .. tostring(Plugins) .. "\n")
  return
end
r.ShowConsoleMsg("✓ Module loaded successfully\n")

-- Test scanning
local count = Plugins.scan()
r.ShowConsoleMsg(string.format("✓ Scanned %d plugins\n", count))

-- Test get_scanner
local scanner = Plugins.get_scanner()
if scanner then
  r.ShowConsoleMsg("✓ get_scanner() returned scanner instance\n")
else
  r.ShowConsoleMsg("FAIL: get_scanner() returned nil\n")
end

-- Test iter_all
local iter_count = 0
for plugin in Plugins.iter_all() do
  iter_count = iter_count + 1
  if iter_count == 1 then
    r.ShowConsoleMsg(string.format("✓ First plugin: %s (%s)\n", plugin.name, plugin.format))
  end
end
r.ShowConsoleMsg(string.format("✓ iter_all() iterated %d plugins\n", iter_count))

-- Test instruments/effects split
local instruments = Plugins.get_instruments()
local effects = Plugins.get_effects()
r.ShowConsoleMsg(string.format("✓ Found %d instruments, %d effects\n", #instruments, #effects))

-- Test iter_instruments
local instr_iter_count = 0
for _ in Plugins.iter_instruments() do
  instr_iter_count = instr_iter_count + 1
end
r.ShowConsoleMsg(string.format("✓ iter_instruments() iterated %d instruments\n", instr_iter_count))

-- Test iter_effects
local fx_iter_count = 0
for _ in Plugins.iter_effects() do
  fx_iter_count = fx_iter_count + 1
end
r.ShowConsoleMsg(string.format("✓ iter_effects() iterated %d effects\n", fx_iter_count))

-- Test search
local search_results = Plugins.search("eq")
r.ShowConsoleMsg(string.format("✓ search('eq') found %d plugins\n", #search_results))

-- Test iter_search
local search_iter_count = 0
for _ in Plugins.iter_search("comp") do
  search_iter_count = search_iter_count + 1
end
r.ShowConsoleMsg(string.format("✓ iter_search('comp') iterated %d plugins\n", search_iter_count))

-- Test get_formats
local formats = scanner:get_formats()
r.ShowConsoleMsg(string.format("✓ Found %d formats: %s\n", #formats, table.concat(formats, ", ")))

-- Test iter_formats
local fmt_iter_count = 0
for _ in scanner:iter_formats() do
  fmt_iter_count = fmt_iter_count + 1
end
r.ShowConsoleMsg(string.format("✓ iter_formats() iterated %d formats\n", fmt_iter_count))

-- Test get_manufacturers
local manufacturers = scanner:get_manufacturers()
r.ShowConsoleMsg(string.format("✓ Found %d manufacturers\n", #manufacturers))

-- Test iter_manufacturers
local mfr_iter_count = 0
for _ in scanner:iter_manufacturers() do
  mfr_iter_count = mfr_iter_count + 1
end
r.ShowConsoleMsg(string.format("✓ iter_manufacturers() iterated %d manufacturers\n", mfr_iter_count))

-- Test deduplicate
local deduped = scanner:deduplicate()
r.ShowConsoleMsg(string.format("✓ deduplicate() returned %d unique plugins (from %d total)\n", #deduped, count))

-- Test iter_deduplicated
local dedup_iter_count = 0
for _ in scanner:iter_deduplicated() do
  dedup_iter_count = dedup_iter_count + 1
end
r.ShowConsoleMsg(string.format("✓ iter_deduplicated() iterated %d plugins\n", dedup_iter_count))

-- Test iter_by_format (if we have VST3)
if scanner._by_format["VST3"] then
  local vst3_iter_count = 0
  for _ in scanner:iter_by_format("VST3") do
    vst3_iter_count = vst3_iter_count + 1
  end
  r.ShowConsoleMsg(string.format("✓ iter_by_format('VST3') iterated %d plugins\n", vst3_iter_count))
end

-- Test iter_by_manufacturer (if we have any)
if #manufacturers > 0 then
  local mfr = manufacturers[1]
  local mfr_plugins_count = 0
  for _ in scanner:iter_by_manufacturer(mfr) do
    mfr_plugins_count = mfr_plugins_count + 1
  end
  r.ShowConsoleMsg(string.format("✓ iter_by_manufacturer('%s') iterated %d plugins\n", mfr, mfr_plugins_count))
end

-- Test PluginInfo tostring
if count > 0 then
  local first = Plugins.get_all()[1]
  r.ShowConsoleMsg(string.format("✓ PluginInfo __tostring: %s\n", tostring(first)))
end

r.ShowConsoleMsg("\n=== All tests passed! ===\n")
