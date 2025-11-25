#pragma once

#include "ReaperAPI.h"
#include "reaper_plugin.h"

namespace ReaWrap {

// Forward declarations
class Track;
using ReaMediaItem = ::MediaItem;

// High-level MediaItem (clip) object
class MediaItem {
private:
  ReaMediaItem *m_reaper_item;
  Track *m_track;

public:
  // Factory methods
  static MediaItem *create(Track *track, double position, double length);
  static MediaItem *createAtBar(Track *track, int bar, int length_bars = 4);

  // Operations
  bool setPosition(double position);
  bool setLength(double length);
  bool setPositionAtBar(int bar);
  bool setLengthInBars(int bars);

  // Getters
  double getPosition() const;
  double getLength() const;
  Track *getTrack() const { return m_track; }
  ReaMediaItem *getReaperItem() const { return m_reaper_item; }

private:
  // Private constructor - use create() factory methods
  MediaItem(ReaMediaItem *item, Track *track);
};

} // namespace ReaWrap
