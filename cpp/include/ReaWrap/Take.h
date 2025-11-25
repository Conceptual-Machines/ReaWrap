#pragma once

#include "reaper_plugin.h"

namespace ReaWrap {

// Forward declaration
class MediaItem;

// High-level Take object
// Represents a take (audio/MIDI source) in a media item
class Take {
private:
  MediaItem_Take *m_reaper_take;
  MediaItem *m_item;

public:
  // Factory method
  static Take *create(MediaItem *item);

  // Getters
  MediaItem_Take *getReaperTake() const { return m_reaper_take; }
  MediaItem *getItem() const { return m_item; }

  // Operations
  bool getName(char *buf, int buf_size) const;
  bool setName(const char *name);

private:
  // Private constructor - use create() factory method
  Take(MediaItem_Take *take, MediaItem *item);
};

} // namespace ReaWrap
