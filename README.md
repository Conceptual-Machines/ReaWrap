# ReaWrap

Making REAPER automation easier, faster, and more intuitive.

## History

Back in 2020, I was using REAPER and wanted to learn Lua, so I built this project by scraping the REAPER documentation in Python. It was a bit messy, but I managed to create a working Lua wrapper that made the REAPER API more approachable.

Like many side projects, I eventually gave up on it. But I always wanted to resurrect it.

Fast forward to 2024, and here we are: ReaWrap has been reborn, reorganized, and expanded. The project now supports both Lua (for ReaScript) and C++ (for REAPER extensions), with a clean, object-oriented API that makes working with REAPER a joy instead of a chore.

## Why ReaWrap?

The REAPER API is powerful but can be obscure and verbose. Writing code with the vanilla API requires:
- Memorizing cryptic function names like `GetSetMediaTrackInfo_String`
- Managing raw pointers and indices
- Converting between different time formats manually
- Looking up documentation constantly
- Writing boilerplate error checking everywhere

**ReaWrap lets you write code faster** by providing an intuitive, object-oriented interface that handles the complexity for you.

## Code Comparison: Vanilla API vs ReaWrap

### Example 1: Create a Track with an Instrument

**Vanilla REAPER API (Lua):**
```lua
-- Get project
local proj = 0

-- Insert track
reaper.InsertTrackInProject(proj, -1, 1)
local track = reaper.GetTrack(proj, reaper.CountTracks(proj) - 1)

-- Set track name
reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "Drums", true)

-- Add instrument
local fx_idx = reaper.TrackFX_AddByName(track, "VST3:Serum (Xfer Records)", false, -1)
if fx_idx < 0 then
    error("Failed to add instrument")
end

-- Set volume to -3dB
local vol_db = -3.0
local vol_linear = 10^(vol_db / 20.0)
reaper.SetTrackUIVolPan(track, vol_linear, 0.0)
```

**ReaWrap (Lua):**
```lua
local Track = require("track")

local track = Track:new(reaper.GetTrack(0, 0))
track:set_name("Drums")
track:add_instrument("VST3:Serum (Xfer Records)")
track:set_volume(-3.0)  -- Automatically converts dB to linear
```

**ReaWrap (C++):**
```cpp
#include <ReaWrap/Track.h>

Track* track = Track::create(-1, "Drums", "VST3:Serum (Xfer Records)");
track->setVolume(-3.0);  // Automatically converts dB to linear
```

### Example 2: Create a Track and Add a Clip at Bar 17

**Vanilla REAPER API (Lua):**
```lua
-- Create track (same as above)
reaper.InsertTrackInProject(0, -1, 1)
local track = reaper.GetTrack(0, reaper.CountTracks(0) - 1)

-- Convert bar 17 to time
local measure = 16  -- 0-based
local qn_start, qn_end, timesig_num, timesig_denom, tempo = 
    reaper.TimeMap_GetMeasureInfo(0, measure, 0, 0, 0, 0, 0)
local start_time = reaper.TimeMap2_QNToTime(0, qn_start)

-- Get measure length for 4 bars
local qn_end_4bars = 0
reaper.TimeMap_GetMeasureInfo(0, measure + 4, 0, &qn_end_4bars, 0, 0, 0)
local end_time = reaper.TimeMap2_QNToTime(0, qn_end_4bars)
local length = end_time - start_time

-- Create item
local item = reaper.AddMediaItemToTrack(track)
reaper.SetMediaItemPosition(item, start_time, false)
reaper.SetMediaItemLength(item, length, false)
```

**ReaWrap (Lua):**
```lua
local Track = require("track")

local track = Track:new(reaper.GetTrack(0, 0))
local item = track:add_clip_at_bar(17, 4)  -- Bar 17, 4 bars long
```

**ReaWrap (C++):**
```cpp
#include <ReaWrap/Track.h>

Track* track = Track::create(-1);
MediaItem* item = track->addClipAtBar(17, 4);  // Bar 17, 4 bars long
```

### Example 3: Iterate Over All Tracks and Their FX

**Vanilla REAPER API (Lua):**
```lua
local proj = 0
local num_tracks = reaper.CountTracks(proj)

for i = 0, num_tracks - 1 do
    local track = reaper.GetTrack(proj, i)
    
    -- Get track name
    local ret, name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    
    -- Get FX count
    local fx_count = reaper.TrackFX_GetCount(track)
    
    for j = 0, fx_count - 1 do
        local ret, fx_name = reaper.TrackFX_GetFXName(track, j, "")
        -- Process FX...
    end
end
```

**ReaWrap (Lua):**
```lua
local Project = require("project")
local project = Project:new()

for track in project:iter_tracks() do
    print(track:get_name())
    
    for fx in track:iter_track_fx_chain() do
        local name = fx:get_name()
        print("  FX: " .. name)
    end
end
```

**ReaWrap (C++):**
```cpp
#include <ReaWrap/Project.h>
#include <ReaWrap/Track.h>

for (Track* track : Project::getTracks()) {
    char name[256];
    track->getName(name, sizeof(name));
    
    for (TrackFX* fx : track->getFXChain()) {
        char fx_name[256];
        fx->getName(fx_name, sizeof(fx_name));
        // Process FX...
    }
}
```

### Example 4: Set FX Parameter Values

**Vanilla REAPER API (Lua):**
```lua
local track = reaper.GetTrack(0, 0)
local fx_idx = 0  -- First FX
local param_idx = 0  -- First parameter

-- Get parameter range
local ret, min_val, max_val = reaper.TrackFX_GetParam(track, fx_idx, param_idx)

-- Set to 50% (normalized)
local normalized = 0.5
reaper.TrackFX_SetParamNormalized(track, fx_idx, param_idx, normalized)

-- Or set to absolute value
local abs_value = min_val + (max_val - min_val) * normalized
reaper.TrackFX_SetParam(track, fx_idx, param_idx, abs_value)
```

**ReaWrap (Lua):**
```lua
local Track = require("track")
local TrackFX = require("track_fx")

local track = Track:new(reaper.GetTrack(0, 0))
local fx = TrackFX:new(track, 0)
fx:set_param_normalized(0, 0.5)  -- Set first param to 50%
```

**ReaWrap (C++):**
```cpp
#include <ReaWrap/Track.h>
#include <ReaWrap/TrackFX.h>

Track* track = Track::findByIndex(0);
TrackFX* fx = TrackFX::getByIndex(track, 0);
fx->setParamNormalized(0, 0.5);  // Set first param to 50%
```

## Getting Started

ReaWrap is available in two flavors:

### Lua (ReaScript)
For REAPER scripts and extensions written in Lua.

👉 **[Read the Lua Guide →](lua/README.md)** for installation, API reference, and examples.

### C++ (Extension API)
For REAPER extensions written in C++.

👉 **[Read the C++ Guide →](cpp/README.md)** for building, initialization, and API reference.

## Project Structure

```
ReaWrap/
├── lua/              # Lua implementation (ReaScript)
│   ├── modules/      # Core modules (Track, Item, Take, etc.)
│   ├── doc/          # Generated documentation
│   └── tests/        # Lua tests
├── cpp/              # C++ implementation (Extension API)
│   ├── include/      # Headers
│   ├── src/          # Implementation
│   ├── examples/     # Example projects
│   └── tests/        # C++ tests
├── docs/             # Cross-language documentation
│   ├── api/          # API reference
│   ├── guides/       # Getting started guides
│   └── examples/     # Code examples
└── tools/            # Shared tools
    └── modules_generator/  # Auto-generate modules from REAPER docs
```

## Documentation

- **[Lua Documentation](lua/README.md)** - Complete guide for ReaScript development
- **[C++ Documentation](cpp/README.md)** - Complete guide for extension development
- [API Reference](docs/api/) - Detailed API documentation
- [Examples](docs/examples/) - Code examples and tutorials

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) file.

## Related Projects

- [REAPER SDK](https://www.reaper.fm/sdk/) - Official REAPER API
- [ReaScript Documentation](https://www.extremraym.com/cloud/reascript-doc/) - REAPER scripting reference
