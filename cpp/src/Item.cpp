#include <ReaWrap/Item.h>
#include <ReaWrap/Project.h>

namespace ReaWrap {

MediaItem::MediaItem(MediaItem *item, Track *track) : m_reaper_item(item), m_track(track) {}

MediaItem *MediaItem::create(Track *track, double position, double length) {
  if (!ReaperAPI::IsAvailable() || !track) {
    return nullptr;
  }

  MediaTrack *reaper_track = track->getReaperTrack();
  if (!reaper_track) {
    return nullptr;
  }

  MediaItem *reaper_item = ReaperAPI::AddMediaItem(reaper_track);
  if (!reaper_item) {
    return nullptr;
  }

  // Set position and length
  ReaperAPI::SetMediaItemPosition(reaper_item, position);
  ReaperAPI::SetMediaItemLength(reaper_item, length);

  return new MediaItem(reaper_item, track);
}

MediaItem *MediaItem::createAtBar(Track *track, int bar, int length_bars) {
  if (!ReaperAPI::IsAvailable() || !track) {
    return nullptr;
  }

  // Convert bars to time
  double position = ReaperAPI::BarToTime(bar);
  double length = ReaperAPI::BarsToTime(length_bars);

  return create(track, position, length);
}

bool MediaItem::setPosition(double position) {
  if (!m_reaper_item) {
    return false;
  }
  return ReaperAPI::SetMediaItemPosition(m_reaper_item, position);
}

bool MediaItem::setLength(double length) {
  if (!m_reaper_item) {
    return false;
  }
  return ReaperAPI::SetMediaItemLength(m_reaper_item, length);
}

bool MediaItem::setPositionAtBar(int bar) {
  if (!m_reaper_item) {
    return false;
  }
  double position = ReaperAPI::BarToTime(bar);
  return setPosition(position);
}

bool MediaItem::setLengthInBars(int bars) {
  if (!m_reaper_item) {
    return false;
  }
  double length = ReaperAPI::BarsToTime(bars);
  return setLength(length);
}

double MediaItem::getPosition() const {
  if (!m_reaper_item) {
    return 0.0;
  }
  return ReaperAPI::GetMediaItemPosition(m_reaper_item);
}

double MediaItem::getLength() const {
  if (!m_reaper_item) {
    return 0.0;
  }
  return ReaperAPI::GetMediaItemLength(m_reaper_item);
}

} // namespace ReaWrap
