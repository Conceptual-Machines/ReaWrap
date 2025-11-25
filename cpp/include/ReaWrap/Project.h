#pragma once

#include "ReaperAPI.h"
#include "reaper_plugin.h"
#include <vector>

namespace ReaWrap {

// Forward declarations
class Track;
class MediaItem;

// Project-level utilities
class Project {
public:
  // Time conversion
  static double barToTime(int bar);
  static int timeToBar(double time);
  static double barsToTime(int bars);

  // Project info
  static bool getName(char *buf, int buf_size);
  static double getLength();
  static double getTempo();
  static bool getTimeSignature(int *numerator, int *denominator);

  // Iterator support - get collections
  static std::vector<Track *> getTracks();
  static std::vector<Track *> getSelectedTracks(bool includeMaster = false);
  static std::vector<MediaItem *> getSelectedItems();

  // Iterator support - check if collections have items
  static bool hasTracks();
  static bool hasSelectedTracks(bool includeMaster = false);
  static bool hasSelectedItems();

  // Updates
  static void updateArrange();
};

} // namespace ReaWrap
