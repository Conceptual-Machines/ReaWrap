# ReaWrap

Object-Oriented wrapper for the REAPER API, making it easier and more intuitive to work with REAPER programmatically.

## Why ReaWrap?

The REAPER API is powerful but can be obscure and verbose. ReaWrap provides:

- **Object-Oriented API**: Work with `Track`, `Item`, `Take` objects instead of raw pointers
- **Method Chaining**: `Track::create("Drums").addInstrument("Serum").addClipAtBar(17)`
- **Better Documentation**: Clear, well-documented methods with examples
- **Type Safety**: Compile-time checking (C++) and runtime validation (Lua)
- **Cross-Language**: Same concepts, different languages

## Languages

### Lua (ReaScript)
For REAPER scripts and extensions written in Lua.

```lua
local Track = require("ReaWrap.Track")

local track = Track:new(reaper.GetTrack(0, 0))
track:set_name("Drums")
track:add_instrument("VST3:Serum (Xfer Records)")
```

### C++ (Extension API)
For REAPER extensions written in C++.

```cpp
#include <ReaWrap/Track.h>

Track* track = Track::create(-1, "Drums", "VST3:Serum (Xfer Records)");
track->addClipAtBar(17, 4);
```

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

## Quick Start

### Lua

```lua
-- In your ReaScript
local ReaWrap = require("ReaWrap")

local track = ReaWrap.Track:new(reaper.GetTrack(0, 0))
track:set_name("My Track")
track:add_instrument("VST3:ReaSynth (Cockos)")
```

### C++

```cpp
#include <ReaWrap/Track.h>
#include <ReaWrap/ReaperAPI.h>

// Initialize once at plugin load
ReaperAPI::Initialize(rec);

// Use the API
Track* track = Track::create(-1, "My Track", "VST3:ReaSynth (Cockos)");
```

## Core Concepts

### Track
Create and manipulate tracks.

**Lua:**
```lua
local track = ReaWrap.Track:new(reaper.GetTrack(0, 0))
track:set_name("Drums")
track:set_volume(-3.0)  -- dB
track:add_instrument("VST3:Serum")
```

**C++:**
```cpp
Track* track = Track::create(-1, "Drums");
track->setVolume(-3.0);
track->addInstrument("VST3:Serum");
```

### Item (Clip)
Create and manipulate media items.

**Lua:**
```lua
local item = track:add_item_at_bar(17, 4)  -- bar 17, 4 bars long
item:set_name("Clip 1")
```

**C++:**
```cpp
MediaItem* item = track->addClipAtBar(17, 4);
```

### Method Chaining
Chain operations for fluent code.

**C++:**
```cpp
Track* track = Track::create(-1, "Bass")
    ->addInstrument("VST3:Serum")
    ->setVolume(-3.0)
    ->setPan(0.5);
```

## Documentation

- [API Reference](docs/api/)
- [Lua Guide](docs/guides/lua.md)
- [C++ Guide](docs/guides/cpp.md)
- [Examples](docs/examples/)

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) file.

## Related Projects

- [REAPER SDK](https://www.reaper.fm/sdk/) - Official REAPER API
- [ReaScript Documentation](https://www.extremraym.com/cloud/reascript-doc/) - REAPER scripting reference
