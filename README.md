# ReaWrap

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Lua](https://img.shields.io/badge/lua-5.1+-blue.svg)
![REAPER](https://img.shields.io/badge/REAPER-7.0+-green.svg)
![Version](https://img.shields.io/badge/version-0.4.1-orange.svg)
[![ReaPack](https://img.shields.io/badge/ReaPack-available-brightgreen.svg)](https://reapack.com/)
[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://conceptual-machines.github.io/ReaWrap/)

**Object-Oriented Wrapper for ReaScript Lua API**

Write REAPER scripts faster with a clean, intuitive, object-oriented interface.

## History

This project started in 2020 as a way to learn Lua while scratching an itch: the REAPER API is incredibly powerful, but its C-style interface felt verbose and low-level. I wanted something more intuitive — an object-oriented layer that reads more like Python than pointer arithmetic. So I scraped the REAPER documentation with Python and auto-generated Lua wrapper classes around it.

Like many side projects, it eventually got shelved. But the itch never went away.

Fast forward to 2025 — ReaWrap has been resurrected, reorganized, and expanded. The codebase is cleaner, the API is more complete, and it now includes full support for REAPER 7's FX containers.

## Why ReaWrap?

The REAPER API is powerful but verbose. You end up writing code like this:

```lua
-- Vanilla REAPER API 😓
reaper.InsertTrackInProject(0, -1, 1)
local track = reaper.GetTrack(0, reaper.CountTracks(0) - 1)
reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "Drums", true)
local fx_idx = reaper.TrackFX_AddByName(track, "VST3:Serum", false, -1)
local vol_linear = 10^(-3.0 / 20.0)
reaper.SetTrackUIVolPan(track, vol_linear, 0.0)
```

**ReaWrap makes it simple:**

```lua
-- ReaWrap 🎉
local Track = require("track")
local track = Track:new(reaper.GetTrack(0, 0))
track:set_name("Drums")
track:add_fx_by_name("VST3:Serum", false, -1)
track:set_track_ui_volume(-3.0)
```

## Features

- **Object-Oriented API** - Work with `Track`, `Item`, `Take`, `TrackFX`, `TakeFX`, `Project` objects
- **Iterators** - `track:iter_items()`, `project:iter_tracks()`, `fx:iter_param_names()`
- **Container Support (Reaper 7+)** - Full API for FX containers
- **Constants** - Named constants for all REAPER enums
- **Documentation** - LDoc-generated API docs

## Quick Start

### Installation

#### Option 1: ReaPack (Recommended)

1. Open REAPER → Extensions → ReaPack → Import repositories
2. Add this URL:
   ```
   https://raw.githubusercontent.com/Conceptual-Machines/ReaWrap/main/index.xml
   ```
3. Extensions → ReaPack → Browse packages → Search "ReaWrap" → Install

#### Option 2: Git Clone

```bash
cd ~/Library/Application\ Support/REAPER/Scripts  # macOS
# or: cd ~/AppData/Roaming/REAPER/Scripts         # Windows
git clone https://github.com/Conceptual-Machines/ReaWrap.git
```

#### Option 3: Git Submodule (for script developers)

```bash
git submodule add -b build https://github.com/Conceptual-Machines/ReaWrap.git
```

### Basic Usage

```lua
-- Setup path (adjust based on your structure)
local script_path = ({ reaper.get_action_context() })[2]:match('^.+[\\//]')
package.path = script_path .. "ReaWrap/?.lua;" .. package.path

-- Import modules
local Project = require("project")
local Track = require("track")

-- Get selected track
local project = Project:new()
local track = project:get_selected_track(0)

if track then
    print("Track: " .. track:get_name())

    -- Iterate over FX
    for fx in track:iter_track_fx_chain() do
        print("  FX: " .. fx:get_name())
    end
end
```

## Container Support (Reaper 7+)

ReaWrap provides full support for Reaper 7's FX containers:

```lua
local Track = require("track")
local track = Track:new(reaper.GetTrack(0, 0))

-- Create a container
local container = track:create_container()

-- Check if FX is a container
if fx:is_container() then
    -- Get children
    for _, child_fx in ipairs(fx:get_children()) do
        print(child_fx:get_name())
    end

    -- Configure container routing
    fx:set_container_channel_count(4)   -- Internal channels
    fx:set_container_input_pins(2)      -- Stereo in
    fx:set_container_output_pins(2)     -- Stereo out
end

-- Get parent container
local parent = fx:get_parent_container()

-- Move FX into container
fx:move_to_container(container_fx)

-- Get flat list of all FX (including nested)
local all_fx = fx:get_all_fx_flat_recursive()
for _, entry in ipairs(all_fx) do
    local indent = string.rep("  ", entry.depth)
    print(indent .. entry.name)
end
```

## ImGui Wrapper

ReaWrap includes a clean OOP wrapper for [ReaImGui](https://forum.cockos.com/showthread.php?t=250419) that reduces boilerplate and provides safer patterns.

> **Requires:** ReaImGui extension (install via ReaPack)

### Quick Start

```lua
local window = require("imgui.window")

window.Window.run({
    title = "My Tool",
    width = 400,
    height = 300,
    data = { counter = 0 },  -- Your state goes here

    on_draw = function(self, ctx)
        ctx:text("Hello from ReaWrap!")
        ctx:separator()

        if ctx:button("Click Me") then
            self.data.counter = self.data.counter + 1
        end
        ctx:same_line()
        ctx:text_fmt("Count: %d", self.data.counter)

        ctx:spacing()
        if ctx:button("Close") then
            self:close()  -- Safe! Deferred until after frame
        end
    end,
})
```

### Theming

```lua
local window = require("imgui.window")
local theme = require("imgui.theme")

window.Window.run({
    title = "Themed Window",
    on_draw = function(self, ctx)
        -- Apply a built-in theme
        theme.Dark:apply(ctx)

        ctx:text("Dark themed content")
        -- ... your UI ...

        theme.Dark:unapply(ctx)
    end,
})
```

**Built-in themes:** `theme.Dark`, `theme.Light`, `theme.Reaper`, `theme.HighContrast`

### Context Methods

The `ctx` object wraps ReaImGui with cleaner method names:

```lua
-- Widgets
ctx:text("Static text")
ctx:text_fmt("Formatted: %d", value)
ctx:text_wrapped("Long text that wraps...")
local clicked = ctx:button("Click", width, height)
local changed, new_val = ctx:checkbox("Enable", current_val)
local changed, new_val = ctx:slider_int("Volume", current, min, max)
local changed, new_val = ctx:slider_double("Pan", current, min, max)
local changed, new_text = ctx:input_text("Name", current_text)
local changed, new_val = ctx:combo("Select", current_idx, {"A", "B", "C"})

-- Layout
ctx:same_line()
ctx:spacing()
ctx:separator()
ctx:indent(pixels)
ctx:unindent(pixels)

-- Groups & Trees
ctx:begin_group() ... ctx:end_group()
if ctx:tree_node("Section") then ... ctx:tree_pop() end
if ctx:collapsing_header("Header") then ... end

-- Tables
if ctx:begin_table("mytable", 3) then
    ctx:table_setup_column("Col1")
    ctx:table_headers_row()
    ctx:table_next_row()
    ctx:table_next_column()
    ctx:text("Cell")
    ctx:end_table()
end

-- Tabs
if ctx:begin_tab_bar("tabs") then
    if ctx:begin_tab_item("Tab 1") then ... ctx:end_tab_item() end
    if ctx:begin_tab_item("Tab 2") then ... ctx:end_tab_item() end
    ctx:end_tab_bar()
end

-- Style
ctx:push_style_color(imgui.Col.Text(), 0xFF0000FF)  -- Red
ctx:pop_style_color()
```

### Deferred Actions

When you need to perform actions after the frame completes (e.g., opening another window):

```lua
on_draw = function(self, ctx)
    if ctx:button("Open Settings") then
        self:defer_action(function()
            -- This runs after the current frame
            open_settings_window()
        end)
    end

    if ctx:button("Close and Do Something") then
        self:close()
        self:defer_action(function()
            -- Runs after window closes
            reaper.ShowMessageBox("Goodbye!", "Info", 0)
        end)
    end
end
```

### Modal Dialogs

```lua
local window = require("imgui.window")

window.Modal.run({
    title = "Confirm Delete",
    width = 300,
    height = 150,
    data = { confirmed = false },

    on_draw = function(self, ctx)
        ctx:text("Are you sure you want to delete?")
        ctx:spacing()

        if ctx:button("Yes", 80) then
            self.data.confirmed = true
            self:close()
        end
        ctx:same_line()
        if ctx:button("No", 80) then
            self:close()
        end
    end,

    on_close = function(self)
        if self.data.confirmed then
            -- Do the delete
        end
    end,
})

## API Overview

### Core Modules

| Module | Description |
|--------|-------------|
| `project` | Project-level operations, track management |
| `track` | Track properties, FX chain, sends/receives |
| `track_fx` | Track FX parameters, presets, containers |
| `item` | Media items, position, length |
| `take` | Takes, sources, stretch markers |
| `take_fx` | Take FX parameters |
| `pcm` | PCM source operations |
| `audio_accessor` | Audio data access |
| `helpers` | Utility functions |
| `constants` | REAPER API constants |
| `version` | Version info |

### ImGui Modules

| Module | Description |
|--------|-------------|
| `imgui` | Core ImGui wrapper, context creation, flags |
| `imgui.window` | `Window` and `Modal` classes for managing windows |
| `imgui.theme` | Color utilities and built-in themes (Dark, Light, etc.) |

### Common Patterns

```lua
-- Iterate over all tracks
for track in project:iter_tracks() do
    -- ...
end

-- Iterate over items on a track
for item in track:iter_items() do
    -- ...
end

-- Get/set FX parameters
local value = fx:get_param_normalized(0)
fx:set_param_normalized(0, 0.5)

-- Get all parameter names
for name in fx:iter_param_names() do
    print(name)
end
```

## Project Structure

```
ReaWrap/
├── lua/                    # Core modules
│   ├── project.lua         # Project class
│   ├── track.lua           # Track class
│   ├── track_fx.lua        # TrackFX class (with container support)
│   ├── item.lua            # Item class
│   ├── take.lua            # Take class
│   ├── take_fx.lua         # TakeFX class
│   ├── pcm.lua             # PCM source class
│   ├── audio_accessor.lua  # AudioAccessor class
│   ├── helpers.lua         # Utility functions
│   ├── constants.lua       # REAPER API constants
│   ├── version.lua         # Version info
│   └── imgui/              # ImGui wrapper
│       ├── init.lua        # Core Context class
│       ├── window.lua      # Window & Modal classes
│       └── theme.lua       # Themes & color utilities
├── doc/                    # Generated LDoc documentation
├── tests/
│   ├── unit/               # Unit tests (with mocks)
│   └── integration/        # Integration tests (run in REAPER)
├── tools/
│   └── modules_generator/  # Scrapes REAPER docs to generate modules
├── CHANGELOG.md
└── README.md
```

## Documentation

- **[API Documentation](https://conceptual-machines.github.io/ReaWrap/)** - Full API reference (GitHub Pages)
- **[Changelog](CHANGELOG.md)** - Version history

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md).

Run pre-commit hooks before committing:
```bash
pre-commit install
pre-commit run --all-files
```

## License

MIT License - see [LICENSE](LICENSE).

## Acknowledgments

- [REAPER](https://www.reaper.fm/)
- [ReaScript Documentation](https://www.extremraym.com/cloud/reascript-doc/) - Community docs
