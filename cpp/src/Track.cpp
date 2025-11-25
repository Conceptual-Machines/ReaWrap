#include <ReaWrap/Item.h>
#include <ReaWrap/Track.h>
#include <ReaWrap/TrackFX.h>
#include <cstring>

namespace ReaWrap {

Track::Track(ReaMediaTrack *track, int index) : m_reaper_track(track), m_index(index) {}

Track *Track::create(int index, const char *name, const char *instrument) {
  if (!ReaperAPI::IsAvailable()) {
    return nullptr;
  }

  // Determine insertion index
  int insert_index = index;
  if (insert_index < 0) {
    insert_index = ReaperAPI::GetNumTracks();
  }

  // Create track
  ReaMediaTrack *reaper_track = ReaperAPI::InsertTrack(insert_index, 1);
  if (!reaper_track) {
    return nullptr;
  }

  Track *track_obj = new Track(reaper_track, insert_index);

  // Set name if provided
  if (name && name[0]) {
    track_obj->setName(name);
  }

  // Add instrument if provided
  if (instrument && instrument[0]) {
    track_obj->addInstrument(instrument);
  }

  return track_obj;
}

bool Track::getName(char *buf, int buf_size) const {
  return ReaperAPI::GetTrackName(m_reaper_track, buf, buf_size);
}

Track *Track::setName(const char *name) {
  if (name && name[0]) {
    ReaperAPI::SetTrackName(m_reaper_track, name);
  }
  return this; // Return this for chaining
}

Track *Track::addInstrument(const char *fxname) {
  if (fxname && fxname[0]) {
    ReaperAPI::AddTrackFX(m_reaper_track, fxname, false);
  }
  return this; // Return this for chaining
}

Track *Track::addFX(const char *fxname) {
  return addInstrument(fxname); // Alias for addInstrument
}

MediaItem *Track::addClip(double position, double length) {
  return MediaItem::create(this, position, length);
}

MediaItem *Track::addClipAtBar(int bar, int length_bars) {
  return MediaItem::createAtBar(this, bar, length_bars);
}

Track *Track::setVolume(double volume_db) {
  ReaperAPI::SetTrackVolume(m_reaper_track, volume_db);
  return this; // Return this for chaining
}

Track *Track::setPan(double pan) {
  ReaperAPI::SetTrackPan(m_reaper_track, pan);
  return this; // Return this for chaining
}

Track *Track::setMute(bool mute) {
  ReaperAPI::SetTrackMute(m_reaper_track, mute);
  return this; // Return this for chaining
}

Track *Track::setSolo(bool solo) {
  ReaperAPI::SetTrackSolo(m_reaper_track, solo);
  return this; // Return this for chaining
}

Track *Track::findByIndex(int index) {
  if (!ReaperAPI::IsAvailable()) {
    return nullptr;
  }
  ReaMediaTrack *reaper_track = ReaperAPI::GetTrack(index);
  if (!reaper_track) {
    return nullptr;
  }
  return new Track(reaper_track, index);
}

Track *Track::findByName(const char *name) {
  if (!ReaperAPI::IsAvailable() || !name || !name[0]) {
    return nullptr;
  }

  int num_tracks = ReaperAPI::GetNumTracks();
  for (int i = 0; i < num_tracks; i++) {
    ReaMediaTrack *reaper_track = ReaperAPI::GetTrack(i);
    if (reaper_track) {
      char track_name[256];
      if (ReaperAPI::GetTrackName(reaper_track, track_name, sizeof(track_name))) {
        if (strcmp(track_name, name) == 0) {
          return new Track(reaper_track, i);
        }
      }
    }
  }
  return nullptr;
}

int Track::getCount() {
  if (!ReaperAPI::IsAvailable()) {
    return 0;
  }
  return ReaperAPI::GetNumTracks();
}

std::vector<MediaItem *> Track::getItems() const {
  std::vector<MediaItem *> items;
  if (!m_reaper_track || !ReaperAPI::IsAvailable()) {
    return items;
  }

  int count = ReaperAPI::CountTrackMediaItems(m_reaper_track);
  for (int i = 0; i < count; i++) {
    ReaMediaItem *reaper_item = ReaperAPI::GetTrackMediaItem(m_reaper_track, i);
    if (reaper_item) {
      // Create MediaItem wrapper - note: this creates new objects each time
      // In a production system, you might want to cache these
      // const_cast is safe here - we're not modifying the track, just creating a wrapper
      items.push_back(MediaItem::create(const_cast<Track *>(this),
                                        ReaperAPI::GetMediaItemPosition(reaper_item),
                                        ReaperAPI::GetMediaItemLength(reaper_item)));
    }
  }
  return items;
}

std::vector<TrackFX *> Track::getFXChain() const {
  std::vector<TrackFX *> fx_chain;
  if (!m_reaper_track || !ReaperAPI::IsAvailable()) {
    return fx_chain;
  }

  int count = ReaperAPI::TrackFX_GetCount(m_reaper_track, false);
  for (int i = 0; i < count; i++) {
    TrackFX *fx = TrackFX::getByIndex(const_cast<Track *>(this), i, false);
    if (fx) {
      fx_chain.push_back(fx);
    }
  }
  return fx_chain;
}

bool Track::hasItems() const {
  if (!m_reaper_track || !ReaperAPI::IsAvailable()) {
    return false;
  }
  return ReaperAPI::CountTrackMediaItems(m_reaper_track) > 0;
}

bool Track::hasFX() const {
  if (!m_reaper_track || !ReaperAPI::IsAvailable()) {
    return false;
  }
  return ReaperAPI::TrackFX_GetCount(m_reaper_track, false) > 0;
}

} // namespace ReaWrap
