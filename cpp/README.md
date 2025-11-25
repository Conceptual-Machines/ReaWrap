# ReaWrap C++

Object-Oriented C++ wrapper for the REAPER Extension API.

## Quick Start

### 1. Include in Your Project

Copy the `cpp/include/ReaWrap` directory to your project, or add ReaWrap as a submodule.

### 2. Initialize

In your plugin's entry point:

```cpp
#include <ReaWrap/ReaperAPI.h>

REAPER_PLUGIN_DLL_EXPORT int REAPER_PLUGIN_ENTRYPOINT(
    REAPER_PLUGIN_HINSTANCE hInstance,
    reaper_plugin_info_t *rec) {
  
  // Initialize ReaWrap
  if (!ReaWrap::ReaperAPI::Initialize(rec)) {
    return 0;  // Failed to initialize
  }
  
  // ... rest of your plugin code
}
```

### 3. Use the API

```cpp
#include <ReaWrap/Track.h>
#include <ReaWrap/Item.h>

// Create a track with an instrument
Track* track = Track::create(-1, "Drums", "VST3:Serum (Xfer Records)");

// Add a clip at bar 17
MediaItem* item = track->addClipAtBar(17, 4);

// Method chaining
Track* bass = Track::create(-1, "Bass")
    ->addInstrument("VST3:Serum")
    ->setVolume(-3.0)
    ->setPan(0.5);
```

## Building

### As Part of Your Project (Submodule)

If using ReaWrap as a git submodule, add to your `CMakeLists.txt`:

```cmake
# Set REAPER SDK path (if not already set)
set(REAPER_SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/reaper-sdk/sdk")

# Add ReaWrap subdirectory
set(REAWRAP_BUILD_EXAMPLES OFF CACHE BOOL "Build ReaWrap examples" FORCE)
set(REAWRAP_BUILD_TESTS OFF CACHE BOOL "Build ReaWrap tests" FORCE)
if(REAPER_SDK_FOUND)
    set(REAWRAP_REAPER_SDK_PATH ${REAPER_SDK_PATH} CACHE PATH "REAPER SDK path for ReaWrap" FORCE)
endif()
add_subdirectory(reawrap/cpp ReaWrap)

# Link against ReaWrap
target_link_libraries(your_plugin PRIVATE ReaWrap)

# Add REAPER SDK include directory to ReaWrap if needed
if(REAPER_SDK_FOUND AND TARGET ReaWrap)
    target_include_directories(ReaWrap PRIVATE ${REAPER_SDK_PATH})
    target_include_directories(ReaWrap PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/WDL)
endif()
```

### Standalone

```bash
cd cpp
mkdir build && cd build
cmake ..
make
```

## Type Aliases

ReaWrap uses type aliases to avoid naming conflicts between REAPER SDK types and ReaWrap wrapper classes:

- `ReaMediaTrack` - REAPER SDK's `MediaTrack*` type
- `ReaMediaItem` - REAPER SDK's `MediaItem*` type  
- `ReaMediaItemTake` - REAPER SDK's `MediaItem_Take*` type

These are defined in `ReaperAPI.h` and used throughout the low-level API wrapper. The high-level classes (`Track`, `MediaItem`, etc.) are ReaWrap wrapper classes.

## API Reference

See [docs/api/](../docs/api/) for full API documentation.

## Examples

See [examples/](examples/) directory for complete examples.

