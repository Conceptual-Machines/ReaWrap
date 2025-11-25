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

### As Part of Your Project

Add to your `CMakeLists.txt`:

```cmake
add_subdirectory(ReaWrap/cpp)
target_link_libraries(your_plugin ReaWrap)
target_include_directories(your_plugin PRIVATE ReaWrap/cpp/include)
```

### Standalone

```bash
cd cpp
mkdir build && cd build
cmake ..
make
```

## API Reference

See [docs/api/](../docs/api/) for full API documentation.

## Examples

See [examples/](examples/) directory for complete examples.

