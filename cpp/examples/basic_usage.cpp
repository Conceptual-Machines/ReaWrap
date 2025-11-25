// Example: Basic usage of ReaWrap C++ API
// This demonstrates how to use ReaWrap in a REAPER extension

#include <ReaWrap/Item.h>
#include <ReaWrap/ReaperAPI.h>
#include <ReaWrap/Track.h>

// In your plugin entry point:
REAPER_PLUGIN_DLL_EXPORT int REAPER_PLUGIN_ENTRYPOINT(REAPER_PLUGIN_HINSTANCE hInstance,
                                                      reaper_plugin_info_t *rec) {

  // 1. Initialize ReaWrap
  if (!ReaWrap::ReaperAPI::Initialize(rec)) {
    return 0; // Failed to initialize
  }

  // 2. Create a track with an instrument
  ReaWrap::Track *track = ReaWrap::Track::create(-1,                         // Append at end
                                                 "Drums",                    // Name
                                                 "VST3:Serum (Xfer Records)" // Instrument
  );

  // 3. Add a clip at bar 17
  ReaWrap::MediaItem *item = track->addClipAtBar(17, 4);

  // 4. Method chaining example
  ReaWrap::Track *bass = ReaWrap::Track::create(-1, "Bass")
                             ->addInstrument("VST3:Serum")
                             ->setVolume(-3.0)     // -3 dB
                             ->setPan(0.5)         // Pan right
                             ->addClipAtBar(1, 8); // Clip from bar 1, 8 bars long

  // 5. Update the arrange view
  ReaWrap::ReaperAPI::UpdateArrange();

  return 1; // Plugin loaded successfully
}
