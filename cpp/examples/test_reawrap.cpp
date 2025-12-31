// Minimal test extension to verify ReaWrap works in isolation
#include "reaper_plugin.h"
#include <ReaWrap/ReaperAPI.h>
#include <ReaWrap/Track.h>

HINSTANCE g_hInst = nullptr;
reaper_plugin_info_t *g_rec = nullptr;

extern "C" {
REAPER_PLUGIN_DLL_EXPORT int REAPER_PLUGIN_ENTRYPOINT(REAPER_PLUGIN_HINSTANCE hInstance,
                                                      reaper_plugin_info_t *rec) {
  if (!rec) {
    return 0;
  }

  if (rec->caller_version != REAPER_PLUGIN_VERSION) {
    return 0;
  }

  g_hInst = hInstance;
  g_rec = rec;

  void (*ShowConsoleMsg)(const char *msg) = (void (*)(const char *))rec->GetFunc("ShowConsoleMsg");

  if (ShowConsoleMsg) {
    ShowConsoleMsg("TEST_REAWRAP: Extension loaded\n");
  }

  // Test ReaWrap initialization
  if (ShowConsoleMsg) {
    ShowConsoleMsg("TEST_REAWRAP: Initializing ReaWrap...\n");
  }

  if (!ReaWrap::ReaperAPI::Initialize(rec)) {
    if (ShowConsoleMsg) {
      ShowConsoleMsg("TEST_REAWRAP: ERROR - Initialization failed!\n");
    }
    return 0;
  }

  if (ShowConsoleMsg) {
    ShowConsoleMsg("TEST_REAWRAP: ReaWrap initialized successfully\n");
  }

  // Test creating a track
  if (ShowConsoleMsg) {
    ShowConsoleMsg("TEST_REAWRAP: Creating test track...\n");
  }

  ReaWrap::Track *track = ReaWrap::Track::create(-1, "ReaWrap Test Track");

  if (track) {
    if (ShowConsoleMsg) {
      ShowConsoleMsg("TEST_REAWRAP: Track created successfully!\n");
    }
    ReaWrap::ReaperAPI::UpdateArrange();
  } else {
    if (ShowConsoleMsg) {
      ShowConsoleMsg("TEST_REAWRAP: Failed to create track\n");
    }
  }

  if (ShowConsoleMsg) {
    ShowConsoleMsg("TEST_REAWRAP: All tests passed!\n");
  }

  return 1;
}
}
