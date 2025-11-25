# ReaWrap Reorganization Plan

## Current Structure
```
ReaWrap/
├── modules/          # Lua modules
├── doc/              # Lua docs
├── tests/            # Lua tests
├── tools/            # Module generator
└── README.md
```

## Target Structure
```
ReaWrap/
├── lua/                      # Lua implementation
│   ├── modules/             # Move from root
│   ├── doc/                 # Move from root
│   ├── tests/               # Move from root
│   └── README.md            # Lua-specific README
├── cpp/                     # NEW: C++ implementation
│   ├── include/
│   │   └── ReaWrap/
│   │       ├── Track.h
│   │       ├── Item.h
│   │       ├── Take.h
│   │       ├── Project.h
│   │       └── ReaperAPI.h
│   ├── src/
│   │   ├── Track.cpp
│   │   ├── Item.cpp
│   │   ├── Take.cpp
│   │   ├── Project.cpp
│   │   └── ReaperAPI.cpp
│   ├── examples/
│   │   └── basic_usage.cpp
│   ├── tests/
│   │   └── test_track.cpp
│   ├── CMakeLists.txt
│   └── README.md            # C++-specific README
├── docs/                    # NEW: Cross-language docs
│   ├── api/
│   │   ├── track.md
│   │   ├── item.md
│   │   └── ...
│   ├── guides/
│   │   ├── getting_started.md
│   │   ├── lua.md
│   │   └── cpp.md
│   └── examples/
│       ├── create_track.md
│       └── ...
├── tools/                   # Keep as-is
│   └── modules_generator/
├── .github/
│   └── workflows/
│       ├── test_lua.yml
│       └── test_cpp.yml
├── README.md                # Main README (updated)
├── LICENSE
└── CONTRIBUTING.md          # NEW
```

## Migration Steps

1. **Move Lua code to `lua/`**
   ```bash
   mkdir -p lua
   mv modules lua/
   mv doc lua/
   mv tests lua/
   ```

2. **Create C++ structure**
   ```bash
   mkdir -p cpp/{include/ReaWrap,src,examples,tests}
   ```

3. **Create docs structure**
   ```bash
   mkdir -p docs/{api,guides,examples}
   ```

4. **Update README.md** (already done)

5. **Create language-specific READMEs**
   - `lua/README.md`
   - `cpp/README.md`

6. **Set up build system**
   - `cpp/CMakeLists.txt`
   - `cpp/Makefile` (optional)

7. **Add CI/CD**
   - Test Lua scripts
   - Build and test C++ code

## Naming Conventions

### C++ Namespace
```cpp
namespace ReaWrap {
    class Track { ... };
    class Item { ... };
}
```

### Include Path
```cpp
#include <ReaWrap/Track.h>
#include <ReaWrap/Item.h>
```

### Lua Module Path
```lua
require("ReaWrap.Track")
require("ReaWrap.Item")
```

## API Parity

Both Lua and C++ should have:
- Same method names (where possible)
- Same concepts
- Same behavior
- Language-appropriate idioms

Example:
- Lua: `track:set_name("Drums")`
- C++: `track->setName("Drums")` (camelCase for C++)

