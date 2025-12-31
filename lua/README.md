# ReaWrap Lua

Object-Oriented Lua wrapper for the REAPER ReaScript API.

## Quick Start

```lua
local ReaWrap = require("ReaWrap")

-- Get a track
local track = ReaWrap.Track:new(reaper.GetTrack(0, 0))

-- Set properties
track:set_name("Drums")
track:set_volume(-3.0)  -- dB
track:add_instrument("VST3:Serum (Xfer Records)")

-- Add an item
local item = track:add_item_at_bar(17, 4)  -- bar 17, 4 bars long
```

## Installation

1. Copy the `modules/` directory to your REAPER Scripts folder
2. Or add ReaWrap as a submodule in your project

## Documentation

See the generated documentation in `doc/` or visit the [online docs](https://your-site.com/ReaWrap/lua).

## Examples

```lua
-- Create and configure a track
local track = ReaWrap.Track:new(reaper.GetTrack(0, 0))
track:set_name("Bass")
track:add_instrument("VST3:Serum")
track:set_volume(-3.0)
track:set_pan(0.5)

-- Add multiple items
for i = 1, 4 do
    track:add_item_at_bar(i * 4, 4)  -- Every 4 bars
end
```

## API Reference

- [Track](doc/modules/track.html)
- [Item](doc/modules/item.html)
- [Take](doc/modules/take.html)
- [Project](doc/modules/project.html)
