#include <ReaWrap/Item.h>
#include <ReaWrap/Project.h>
#include <ReaWrap/Track.h>
#include <cstring>

namespace ReaWrap {

double Project::barToTime(int bar) { return ReaperAPI::BarToTime(bar); }

int Project::timeToBar(double time) { return ReaperAPI::TimeToBar(time); }

double Project::barsToTime(int bars) { return ReaperAPI::BarsToTime(bars); }

bool Project::getName(char *buf, int buf_size) {
  if (!ReaperAPI::IsAvailable() || !buf || buf_size <= 0) {
    return false;
  }

  reaper_plugin_info_t *rec = ReaperAPI::GetRec();
  if (!rec) {
    return false;
  }

  void (*GetProjectName)(ReaProject *, char *, int) =
      (void (*)(ReaProject *, char *, int))rec->GetFunc("GetProjectName");
  if (!GetProjectName) {
    return false;
  }

  GetProjectName(nullptr, buf, buf_size);
  return true;
}

double Project::getLength() {
  if (!ReaperAPI::IsAvailable()) {
    return 0.0;
  }

  reaper_plugin_info_t *rec = ReaperAPI::GetRec();
  if (!rec) {
    return 0.0;
  }

  double (*GetProjectLength)(ReaProject *) =
      (double (*)(ReaProject *))rec->GetFunc("GetProjectLength");
  if (!GetProjectLength) {
    return 0.0;
  }

  return GetProjectLength(nullptr);
}

double Project::getTempo() {
  if (!ReaperAPI::IsAvailable()) {
    return 120.0;
  }

  // Get tempo from first measure
  double qn_start = 0.0;
  double qn_end = 0.0;
  int timesig_num = 4;
  int timesig_denom = 4;
  double tempo = 120.0;

  ReaperAPI::GetMeasureInfo(0, &qn_start, &qn_end, &timesig_num, &timesig_denom, &tempo);

  return tempo;
}

bool Project::getTimeSignature(int *numerator, int *denominator) {
  if (!ReaperAPI::IsAvailable() || !numerator || !denominator) {
    return false;
  }

  double qn_start = 0.0;
  double qn_end = 0.0;
  int timesig_num = 4;
  int timesig_denom = 4;
  double tempo = 120.0;

  ReaperAPI::GetMeasureInfo(0, &qn_start, &qn_end, &timesig_num, &timesig_denom, &tempo);
  *numerator = timesig_num;
  *denominator = timesig_denom;
  return true;
}

void Project::updateArrange() { ReaperAPI::UpdateArrange(); }

std::vector<Track *> Project::getTracks() {
  std::vector<Track *> tracks;
  if (!ReaperAPI::IsAvailable()) {
    return tracks;
  }

  int count = ReaperAPI::GetNumTracks();
  for (int i = 0; i < count; i++) {
    Track *track = Track::findByIndex(i);
    if (track) {
      tracks.push_back(track);
    }
  }
  return tracks;
}

std::vector<Track *> Project::getSelectedTracks(bool includeMaster) {
  std::vector<Track *> tracks;
  if (!ReaperAPI::IsAvailable()) {
    return tracks;
  }

  int count = ReaperAPI::CountSelectedTracks(includeMaster);
  for (int i = 0; i < count; i++) {
    ReaMediaTrack *reaper_track = ReaperAPI::GetSelectedTrack(i, includeMaster);
    if (reaper_track) {
      // Find the track index
      int num_tracks = ReaperAPI::GetNumTracks();
      for (int j = 0; j < num_tracks; j++) {
        ReaMediaTrack *t = ReaperAPI::GetTrack(j);
        if (t == reaper_track) {
          Track *track = Track::findByIndex(j);
          if (track) {
            tracks.push_back(track);
          }
          break;
        }
      }
    }
  }
  return tracks;
}

std::vector<MediaItem *> Project::getSelectedItems() {
  std::vector<MediaItem *> items;
  if (!ReaperAPI::IsAvailable()) {
    return items;
  }

  int count = ReaperAPI::CountSelectedMediaItems();
  for (int i = 0; i < count; i++) {
    ReaMediaItem *reaper_item = ReaperAPI::GetSelectedMediaItem(i);
    if (reaper_item) {
      // Create MediaItem wrapper - note: we need to find the track
      // For now, create a minimal wrapper
      double pos = ReaperAPI::GetMediaItemPosition(reaper_item);
      double len = ReaperAPI::GetMediaItemLength(reaper_item);
      // We can't create without a track, so this is a limitation
      // In production, you'd want to find the track from the item
      // For now, return nullptr items
    }
  }
  return items;
}

bool Project::hasTracks() {
  if (!ReaperAPI::IsAvailable()) {
    return false;
  }
  return ReaperAPI::GetNumTracks() > 0;
}

bool Project::hasSelectedTracks(bool includeMaster) {
  if (!ReaperAPI::IsAvailable()) {
    return false;
  }
  return ReaperAPI::CountSelectedTracks(includeMaster) > 0;
}

bool Project::hasSelectedItems() {
  if (!ReaperAPI::IsAvailable()) {
    return false;
  }
  return ReaperAPI::CountSelectedMediaItems() > 0;
}

} // namespace ReaWrap
