-- @description ReaWrap - Object-Oriented Wrapper for ReaScript Lua API
-- @author Nomad Monad
-- @version 0.6.1
-- @changelog
--   v0.6.1 (2026-01-01)
--     * Fixed begin_child() to support window_flags parameter for horizontal scrollbar
--   v0.6.0 (2026-01-01)
--     + ImGui drag-drop API (begin/end source/target, payload methods)
--     + ImGui selectable size parameters
--     + ImGui modifier key detection (is_shift_down, is_ctrl_down, is_alt_down)
--     + TrackFX:move_out_of_container() - move FX back to main chain
--   v0.5.0 (2026-01-01)
--     + Track:find_fx_by_guid() - find FX by stable GUID
--     + Track:add_fx_to_new_container() - create container and move FX into it
--     + TrackFX:delete() - delete FX from track
--     + TrackFX:move_to_container() - move FX into container
--     + Fixed container addressing formula for add_fx_to_container
--     + Improved create_container() with position parameter
--   v0.4.1 (2026-01-01)
--     + ImGui TreeNodeFlags and InputTextFlags
--   v0.4.0 (2026-01-01)
--     + Plugins module for scanning/searching installed FX
--   v0.3.2 (2026-01-01)
--     + ImGui ID stack methods and set_next_item_width
--   v0.3.1 (2026-01-01)
--     + defer_action() for safe post-frame actions
--     + Integration tests
--   v0.3.0 (2025-12-31)
--     + ImGui wrapper module with Context, Window, and Theme classes
--     + Pre-built themes (Dark, Light, Reaper, HighContrast)
--   v0.2.0 (2025-12-31)
--     + Container API support for REAPER 7 FX Containers
--     + Version module
--   v0.1.0 (2025-11-25)
--     + Initial release
-- @provides
--   [nomain] lua/audio_accessor.lua
--   [nomain] lua/constants.lua
--   [nomain] lua/helpers.lua
--   [nomain] lua/item.lua
--   [nomain] lua/pcm.lua
--   [nomain] lua/plugins.lua
--   [nomain] lua/project.lua
--   [nomain] lua/take.lua
--   [nomain] lua/take_fx.lua
--   [nomain] lua/track.lua
--   [nomain] lua/track_fx.lua
--   [nomain] lua/version.lua
--   [nomain] lua/imgui/init.lua
--   [nomain] lua/imgui/window.lua
--   [nomain] lua/imgui/theme.lua
-- @link GitHub https://github.com/Conceptual-Machines/ReaWrap
-- @link Documentation https://conceptual-machines.github.io/ReaWrap/
-- @about
--   # ReaWrap
--
--   Object-Oriented Wrapper for ReaScript Lua API.
--
--   ## Features
--
--   - **OOP Classes**: Project, Track, TrackFX, Item, Take, TakeFX, etc.
--   - **Container Support**: Full REAPER 7 FX Container API
--   - **ImGui Wrapper**: Clean abstractions for ReaImGui
--   - **Themes**: Pre-built color themes for ImGui
--
--   ## Usage
--
--   ```lua
--   -- Add ReaWrap to path
--   local script_path = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
--   package.path = script_path .. "Scripts/ReaWrap/lua/?.lua;" .. package.path
--   package.path = script_path .. "Scripts/ReaWrap/lua/?/init.lua;" .. package.path
--
--   -- Import modules
--   local Project = require('project')
--   local Track = require('track')
--
--   -- Use OOP style
--   local project = Project:new()
--   for track in project:iter_tracks() do
--       print(track:get_name())
--   end
--   ```
--
--   ## ImGui Example
--
--   ```lua
--   local imgui = require('imgui')
--   local Window = require('imgui.window').Window
--   local theme = require('imgui.theme')
--
--   Window.run({
--       title = "My Script",
--       on_draw = function(self, ctx)
--           theme.Reaper:apply(ctx)
--           ctx:text("Hello World!")
--           if ctx:button("Click Me") then
--               print("Clicked!")
--           end
--           theme.Reaper:unapply(ctx)
--       end,
--   })
--   ```
--
--   ## Documentation
--
--   Full API documentation: https://conceptual-machines.github.io/ReaWrap/

-- This file is the ReaPack entry point.
-- It provides all ReaWrap modules for installation via ReaPack.
-- The actual library files are in the lua/ folder.

local info = debug.getinfo(1, "S")
local script_path = info.source:match("@?(.*[\\/])")

reaper.ShowConsoleMsg([[
ReaWrap installed successfully!

To use ReaWrap in your scripts, add this to the top:

  local script_path = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
  package.path = script_path .. "Scripts/ReaWrap/lua/?.lua;" .. package.path
  package.path = script_path .. "Scripts/ReaWrap/lua/?/init.lua;" .. package.path

Then require the modules you need:

  local Project = require('project')
  local Track = require('track')
  local imgui = require('imgui')

Documentation: https://conceptual-machines.github.io/ReaWrap/
]])
