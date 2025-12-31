# ReaWrap

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Lua](https://img.shields.io/badge/lua-5.1+-blue.svg)
![REAPER](https://img.shields.io/badge/REAPER-7.0+-green.svg)
![Version](https://img.shields.io/badge/version-0.3.0-orange.svg)
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

ReaWrap includes a clean OOP wrapper for ReaImGui that reduces boilerplate:

```lua
local Window = require("imgui.window")
local Theme = require("imgui.theme")

-- Define your window
local MyWindow = Window:extend()

function MyWindow:init()
    self.title = "My Tool"
    self.width = 400
    self.height = 300
    self.counter = 0
end

function MyWindow:draw()
    local ctx = self.ctx

    -- Apply theme
    Theme.Dark:apply(ctx)

    -- Simple widgets with method chaining
    ctx:text("Hello from ReaWrap!")
    ctx:separator()

    if ctx:button("Click Me") then
        self.counter = self.counter + 1
    end
    ctx:same_line()
    ctx:text("Count: " .. self.counter)

    -- Disabled sections
    ctx:with_disabled(self.counter == 0, function()
        if ctx:button("Reset") then
            self.counter = 0
        end
    end)

    Theme.Dark:pop(ctx)
end

-- Run the window
MyWindow:run()
```

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
| `imgui` | ImGui wrapper (Context, Window, Theme) |
| `helpers` | Utility functions |
| `constants` | REAPER API constants |
| `version` | Version info |

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
├── lua/              # Core modules
│   ├── track.lua
│   ├── track_fx.lua
│   ├── item.lua
│   ├── take.lua
│   ├── project.lua
│   ├── version.lua
│   └── ...
├── doc/              # Generated LDoc documentation
├── tests/            # Test files
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
