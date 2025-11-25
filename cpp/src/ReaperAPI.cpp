#include <ReaWrap/ReaperAPI.h>
#include <cstring>
#include <cmath>

namespace ReaWrap {

// Static member initialization
reaper_plugin_info_t *ReaperAPI::s_rec = nullptr;
bool ReaperAPI::s_initialized = false;

// Function pointer initialization
void (*ReaperAPI::s_InsertTrackInProject)(ReaProject *, int, int) = nullptr;
MediaTrack *(*ReaperAPI::s_GetTrack)(ReaProject *, int) = nullptr;
int (*ReaperAPI::s_GetNumTracks)(ReaProject *) = nullptr;
void *(*ReaperAPI::s_GetSetMediaTrackInfo)(INT_PTR, const char *, void *, bool *) = nullptr;

MediaItem *(*ReaperAPI::s_AddMediaItemToTrack)(MediaTrack *) = nullptr;
bool (*ReaperAPI::s_SetMediaItemPosition)(MediaItem *, double, bool) = nullptr;
bool (*ReaperAPI::s_SetMediaItemLength)(MediaItem *, double, bool) = nullptr;
double (*ReaperAPI::s_GetMediaItemPosition)(MediaItem *) = nullptr;
double (*ReaperAPI::s_GetMediaItemLength)(MediaItem *) = nullptr;

bool (*ReaperAPI::s_GetTrackUIVolPan)(MediaTrack *, double *, double *) = nullptr;
bool (*ReaperAPI::s_SetTrackUIVolPan)(MediaTrack *, double, double) = nullptr;
bool (*ReaperAPI::s_GetTrackUIMute)(MediaTrack *, bool *) = nullptr;
bool (*ReaperAPI::s_SetTrackUIMute)(MediaTrack *, bool) = nullptr;
bool (*ReaperAPI::s_GetTrackUISolo)(MediaTrack *, bool *) = nullptr;
bool (*ReaperAPI::s_SetTrackUISolo)(MediaTrack *, bool) = nullptr;

int (*ReaperAPI::s_TrackFX_AddByName)(MediaTrack *, const char *, bool, int) = nullptr;

double (*ReaperAPI::s_TimeMap_GetMeasureInfo)(ReaProject *, int, double *, double *, int *, int *, double *) = nullptr;
double (*ReaperAPI::s_TimeMap2_QNToTime)(ReaProject *, double) = nullptr;
double (*ReaperAPI::s_TimeMap2_timeToQN)(ReaProject *, double) = nullptr;

void (*ReaperAPI::s_UpdateArrange)() = nullptr;

bool ReaperAPI::Initialize(reaper_plugin_info_t *rec) {
  if (!rec) {
    return false;
  }

  s_rec = rec;

  // Cache all function pointers
  s_InsertTrackInProject = (void (*)(ReaProject *, int, int))rec->GetFunc("InsertTrackInProject");
  s_GetTrack = (MediaTrack *(*)(ReaProject *, int))rec->GetFunc("GetTrack");
  s_GetNumTracks = (int (*)(ReaProject *))rec->GetFunc("GetNumTracks");
  s_GetSetMediaTrackInfo = (void *(*)(INT_PTR, const char *, void *, bool *))rec->GetFunc("GetSetMediaTrackInfo");
  s_GetSelectedTrack2 = (MediaTrack *(*)(ReaProject *, int, bool))rec->GetFunc("GetSelectedTrack2");
  s_CountSelectedTracks2 = (int (*)(ReaProject *, bool))rec->GetFunc("CountSelectedTracks2");

  s_AddMediaItemToTrack = (MediaItem *(*)(MediaTrack *))rec->GetFunc("AddMediaItemToTrack");
  s_GetTrackMediaItem = (MediaItem *(*)(MediaTrack *, int))rec->GetFunc("GetTrackMediaItem");
  s_CountTrackMediaItems = (int (*)(MediaTrack *))rec->GetFunc("CountTrackMediaItems");
  s_GetSelectedMediaItem = (MediaItem *(*)(ReaProject *, int))rec->GetFunc("GetSelectedMediaItem");
  s_CountSelectedMediaItems = (int (*)(ReaProject *))rec->GetFunc("CountSelectedMediaItems");
  s_SetMediaItemPosition = (bool (*)(MediaItem *, double, bool))rec->GetFunc("SetMediaItemPosition");
  s_SetMediaItemLength = (bool (*)(MediaItem *, double, bool))rec->GetFunc("SetMediaItemLength");
  s_GetMediaItemPosition = (double (*)(MediaItem *))rec->GetFunc("GetMediaItemPosition");
  s_GetMediaItemLength = (double (*)(MediaItem *))rec->GetFunc("GetMediaItemLength");

  s_GetTrackUIVolPan = (bool (*)(MediaTrack *, double *, double *))rec->GetFunc("GetTrackUIVolPan");
  s_SetTrackUIVolPan = (bool (*)(MediaTrack *, double, double))rec->GetFunc("SetTrackUIVolPan");
  s_GetTrackUIMute = (bool (*)(MediaTrack *, bool *))rec->GetFunc("GetTrackUIMute");
  s_SetTrackUIMute = (bool (*)(MediaTrack *, bool))rec->GetFunc("SetTrackUIMute");
  s_GetTrackUISolo = (bool (*)(MediaTrack *, bool *))rec->GetFunc("GetTrackUISolo");
  s_SetTrackUISolo = (bool (*)(MediaTrack *, bool))rec->GetFunc("SetTrackUISolo");

  s_TrackFX_AddByName = (int (*)(MediaTrack *, const char *, bool, int))rec->GetFunc("TrackFX_AddByName");
  s_TrackFX_GetFXName = (bool (*)(MediaTrack *, int, char *, int))rec->GetFunc("TrackFX_GetFXName");
  s_TrackFX_GetCount = (int (*)(MediaTrack *))rec->GetFunc("TrackFX_GetCount");
  s_TrackFX_GetNumParams = (int (*)(MediaTrack *, int))rec->GetFunc("TrackFX_GetNumParams");
  s_TrackFX_GetParamName = (bool (*)(MediaTrack *, int, int, char *, int))rec->GetFunc("TrackFX_GetParamName");
  s_TrackFX_GetParam = (double (*)(MediaTrack *, int, int, double *, double *))rec->GetFunc("TrackFX_GetParam");
  s_TrackFX_SetParam = (bool (*)(MediaTrack *, int, int, double))rec->GetFunc("TrackFX_SetParam");
  s_TrackFX_GetParamNormalized = (double (*)(MediaTrack *, int, int))rec->GetFunc("TrackFX_GetParamNormalized");
  s_TrackFX_SetParamNormalized = (bool (*)(MediaTrack *, int, int, double))rec->GetFunc("TrackFX_SetParamNormalized");
  s_TrackFX_FormatParamValue = (bool (*)(MediaTrack *, int, int, double, char *, int))rec->GetFunc("TrackFX_FormatParamValue");
  s_TrackFX_GetEnabled = (bool (*)(MediaTrack *, int))rec->GetFunc("TrackFX_GetEnabled");
  s_TrackFX_SetEnabled = (bool (*)(MediaTrack *, int, bool))rec->GetFunc("TrackFX_SetEnabled");
  s_TrackFX_Delete = (bool (*)(MediaTrack *, int))rec->GetFunc("TrackFX_Delete");

  s_TakeFX_AddByName = (int (*)(MediaItem_Take *, const char *, int))rec->GetFunc("TakeFX_AddByName");
  s_TakeFX_GetFXName = (bool (*)(MediaItem_Take *, int, char *, int))rec->GetFunc("TakeFX_GetFXName");
  s_TakeFX_GetCount = (int (*)(MediaItem_Take *))rec->GetFunc("TakeFX_GetCount");
  s_TakeFX_GetNumParams = (int (*)(MediaItem_Take *, int))rec->GetFunc("TakeFX_GetNumParams");
  s_TakeFX_GetParamName = (bool (*)(MediaItem_Take *, int, int, char *, int))rec->GetFunc("TakeFX_GetParamName");
  s_TakeFX_GetParam = (double (*)(MediaItem_Take *, int, int, double *, double *))rec->GetFunc("TakeFX_GetParam");
  s_TakeFX_SetParam = (bool (*)(MediaItem_Take *, int, int, double))rec->GetFunc("TakeFX_SetParam");
  s_TakeFX_GetParamNormalized = (double (*)(MediaItem_Take *, int, int))rec->GetFunc("TakeFX_GetParamNormalized");
  s_TakeFX_SetParamNormalized = (bool (*)(MediaItem_Take *, int, int, double))rec->GetFunc("TakeFX_SetParamNormalized");
  s_TakeFX_FormatParamValue = (bool (*)(MediaItem_Take *, int, int, double, char *, int))rec->GetFunc("TakeFX_FormatParamValue");
  s_TakeFX_GetEnabled = (bool (*)(MediaItem_Take *, int))rec->GetFunc("TakeFX_GetEnabled");
  s_TakeFX_SetEnabled = (bool (*)(MediaItem_Take *, int, bool))rec->GetFunc("TakeFX_SetEnabled");
  s_TakeFX_Delete = (bool (*)(MediaItem_Take *, int))rec->GetFunc("TakeFX_Delete");

  s_TimeMap_GetMeasureInfo = (double (*)(ReaProject *, int, double *, double *, int *, int *, double *))rec->GetFunc("TimeMap_GetMeasureInfo");
  s_TimeMap2_QNToTime = (double (*)(ReaProject *, double))rec->GetFunc("TimeMap2_QNToTime");
  s_TimeMap2_timeToQN = (double (*)(ReaProject *, double))rec->GetFunc("TimeMap2_timeToQN");

  s_UpdateArrange = (void (*)())rec->GetFunc("UpdateArrange");

  // Check if essential functions are available
  if (!s_InsertTrackInProject || !s_GetTrack || !s_GetSetMediaTrackInfo) {
    return false;
  }

  s_initialized = true;
  return true;
}

bool ReaperAPI::IsAvailable() { return s_initialized && s_rec != nullptr; }

MediaTrack *ReaperAPI::InsertTrack(int index, int flags) {
  if (!IsAvailable() || !s_InsertTrackInProject) {
    return nullptr;
  }
  s_InsertTrackInProject(nullptr, index, flags);
  return GetTrack(index);
}

MediaTrack *ReaperAPI::GetTrack(int index) {
  if (!IsAvailable() || !s_GetTrack) {
    return nullptr;
  }
  return s_GetTrack(nullptr, index);
}

int ReaperAPI::GetNumTracks() {
  if (!IsAvailable() || !s_GetNumTracks) {
    return 0;
  }
  return s_GetNumTracks(nullptr);
}

bool ReaperAPI::SetTrackName(MediaTrack *track, const char *name) {
  if (!IsAvailable() || !track || !name || !s_GetSetMediaTrackInfo) {
    return false;
  }
  s_GetSetMediaTrackInfo((INT_PTR)track, "P_NAME", (void *)name, nullptr);
  return true;
}

bool ReaperAPI::GetTrackName(MediaTrack *track, char *buf, int buf_size) {
  if (!IsAvailable() || !track || !buf || buf_size <= 0 || !s_GetSetMediaTrackInfo) {
    return false;
  }
  const char *name = (const char *)s_GetSetMediaTrackInfo((INT_PTR)track, "P_NAME", nullptr, nullptr);
  if (name) {
    strncpy(buf, name, buf_size - 1);
    buf[buf_size - 1] = '\0';
    return true;
  }
  return false;
}

MediaItem *ReaperAPI::AddMediaItem(MediaTrack *track) {
  if (!IsAvailable() || !track || !s_AddMediaItemToTrack) {
    return nullptr;
  }
  return s_AddMediaItemToTrack(track);
}

bool ReaperAPI::SetMediaItemPosition(MediaItem *item, double position) {
  if (!IsAvailable() || !item || !s_SetMediaItemPosition) {
    return false;
  }
  return s_SetMediaItemPosition(item, position, false);
}

bool ReaperAPI::SetMediaItemLength(MediaItem *item, double length) {
  if (!IsAvailable() || !item || !s_SetMediaItemLength) {
    return false;
  }
  return s_SetMediaItemLength(item, length, false);
}

double ReaperAPI::GetMediaItemPosition(MediaItem *item) {
  if (!IsAvailable() || !item || !s_GetMediaItemPosition) {
    return 0.0;
  }
  return s_GetMediaItemPosition(item);
}

double ReaperAPI::GetMediaItemLength(MediaItem *item) {
  if (!IsAvailable() || !item || !s_GetMediaItemLength) {
    return 0.0;
  }
  return s_GetMediaItemLength(item);
}

MediaItem *ReaperAPI::GetTrackMediaItem(MediaTrack *track, int item_idx) {
  if (!IsAvailable() || !track || !s_GetTrackMediaItem) {
    return nullptr;
  }
  return s_GetTrackMediaItem(track, item_idx);
}

int ReaperAPI::CountTrackMediaItems(MediaTrack *track) {
  if (!IsAvailable() || !track || !s_CountTrackMediaItems) {
    return 0;
  }
  return s_CountTrackMediaItems(track);
}

MediaItem *ReaperAPI::GetSelectedMediaItem(int sel_idx) {
  if (!IsAvailable() || !s_GetSelectedMediaItem) {
    return nullptr;
  }
  return s_GetSelectedMediaItem(nullptr, sel_idx);
}

int ReaperAPI::CountSelectedMediaItems() {
  if (!IsAvailable() || !s_CountSelectedMediaItems) {
    return 0;
  }
  return s_CountSelectedMediaItems(nullptr);
}

MediaTrack *ReaperAPI::GetSelectedTrack(int sel_idx, bool want_master) {
  if (!IsAvailable() || !s_GetSelectedTrack2) {
    return nullptr;
  }
  return s_GetSelectedTrack2(nullptr, sel_idx, want_master);
}

int ReaperAPI::CountSelectedTracks(bool want_master) {
  if (!IsAvailable() || !s_CountSelectedTracks2) {
    return 0;
  }
  return s_CountSelectedTracks2(nullptr, want_master);
}

bool ReaperAPI::SetTrackVolume(MediaTrack *track, double volume_db) {
  if (!IsAvailable() || !track || !s_SetTrackUIVolPan) {
    return false;
  }
  double pan = 0.0;
  if (s_GetTrackUIVolPan && s_GetTrackUIVolPan(track, nullptr, &pan)) {
    // Get current pan to preserve it
  }
  // Convert dB to linear
  double volume_linear = pow(10.0, volume_db / 20.0);
  return s_SetTrackUIVolPan(track, volume_linear, pan);
}

bool ReaperAPI::SetTrackPan(MediaTrack *track, double pan) {
  if (!IsAvailable() || !track || !s_SetTrackUIVolPan) {
    return false;
  }
  double vol = 0.0;
  if (s_GetTrackUIVolPan && s_GetTrackUIVolPan(track, &vol, nullptr)) {
    // Get current volume to preserve it
  }
  return s_SetTrackUIVolPan(track, vol, pan);
}

bool ReaperAPI::SetTrackMute(MediaTrack *track, bool mute) {
  if (!IsAvailable() || !track || !s_SetTrackUIMute) {
    return false;
  }
  return s_SetTrackUIMute(track, mute);
}

bool ReaperAPI::SetTrackSolo(MediaTrack *track, bool solo) {
  if (!IsAvailable() || !track || !s_SetTrackUISolo) {
    return false;
  }
  return s_SetTrackUISolo(track, solo);
}

bool ReaperAPI::GetTrackVolume(MediaTrack *track, double *volume_db) {
  if (!IsAvailable() || !track || !volume_db || !s_GetTrackUIVolPan) {
    return false;
  }
  double vol = 0.0;
  if (s_GetTrackUIVolPan(track, &vol, nullptr)) {
    // Convert linear to dB
    *volume_db = 20.0 * log10(vol);
    return true;
  }
  return false;
}

bool ReaperAPI::GetTrackPan(MediaTrack *track, double *pan) {
  if (!IsAvailable() || !track || !pan || !s_GetTrackUIVolPan) {
    return false;
  }
  return s_GetTrackUIVolPan(track, nullptr, pan);
}

bool ReaperAPI::GetTrackMute(MediaTrack *track, bool *mute) {
  if (!IsAvailable() || !track || !mute || !s_GetTrackUIMute) {
    return false;
  }
  return s_GetTrackUIMute(track, mute);
}

bool ReaperAPI::GetTrackSolo(MediaTrack *track, bool *solo) {
  if (!IsAvailable() || !track || !solo || !s_GetTrackUISolo) {
    return false;
  }
  return s_GetTrackUISolo(track, solo);
}

int ReaperAPI::AddTrackFX(MediaTrack *track, const char *fxname, bool recFX) {
  if (!IsAvailable() || !track || !fxname || !s_TrackFX_AddByName) {
    return -1;
  }
  // instantiate = -1 means always create new instance
  return s_TrackFX_AddByName(track, fxname, recFX, -1);
}

double ReaperAPI::BarToTime(int bar) {
  if (!IsAvailable() || !s_TimeMap_GetMeasureInfo || !s_TimeMap2_QNToTime) {
    return 0.0;
  }
  // Bar is 1-based, measure is 0-based
  int measure = bar - 1;
  double qn_start = 0.0;
  double qn_end = 0.0;
  int timesig_num = 4;
  int timesig_denom = 4;
  double tempo = 120.0;

  s_TimeMap_GetMeasureInfo(nullptr, measure, &qn_start, &qn_end, &timesig_num, &timesig_denom, &tempo);
  return s_TimeMap2_QNToTime(nullptr, qn_start);
}

int ReaperAPI::TimeToBar(double time) {
  if (!IsAvailable() || !s_TimeMap2_timeToQN) {
    return 0;
  }
  double qn = s_TimeMap2_timeToQN(nullptr, time);
  // Convert QN to bar (assuming 4/4 time for now)
  // This is approximate - for accurate conversion, need to query time signature
  int bar = (int)(qn / 4.0) + 1;
  return bar;
}

double ReaperAPI::BarsToTime(int bars) {
  if (!IsAvailable() || !s_TimeMap_GetMeasureInfo || !s_TimeMap2_QNToTime) {
    return 0.0;
  }
  // Get QN for start of first bar and end of last bar
  int start_bar = 1;
  int end_bar = bars;
  double qn_start = 0.0;
  double qn_end = 0.0;
  int timesig_num = 4;
  int timesig_denom = 4;
  double tempo = 120.0;

  s_TimeMap_GetMeasureInfo(nullptr, start_bar - 1, &qn_start, nullptr, &timesig_num, &timesig_denom, &tempo);
  s_TimeMap_GetMeasureInfo(nullptr, end_bar, nullptr, &qn_end, nullptr, nullptr, nullptr);

  double time_start = s_TimeMap2_QNToTime(nullptr, qn_start);
  double time_end = s_TimeMap2_QNToTime(nullptr, qn_end);
  return time_end - time_start;
}

void ReaperAPI::UpdateArrange() {
  if (IsAvailable() && s_UpdateArrange) {
    s_UpdateArrange();
  }
}

// TrackFX wrapper methods
bool ReaperAPI::TrackFX_GetFXName(MediaTrack *track, int fx_index, char *buf, int buf_size) {
  if (!IsAvailable() || !track || !buf || buf_size <= 0 || !s_TrackFX_GetFXName) {
    return false;
  }
  return s_TrackFX_GetFXName(track, fx_index, buf, buf_size);
}

int ReaperAPI::TrackFX_GetCount(MediaTrack *track, bool isInputFX) {
  if (!IsAvailable() || !track || !s_TrackFX_GetCount) {
    return 0;
  }
  // Note: GetCount doesn't distinguish input FX, need to check if there's a separate function
  // For now, assume it returns track FX count
  return s_TrackFX_GetCount(track);
}

int ReaperAPI::TrackFX_GetNumParams(MediaTrack *track, int fx_index) {
  if (!IsAvailable() || !track || !s_TrackFX_GetNumParams) {
    return 0;
  }
  return s_TrackFX_GetNumParams(track, fx_index);
}

bool ReaperAPI::TrackFX_GetParamName(MediaTrack *track, int fx_index, int param_index, char *buf, int buf_size) {
  if (!IsAvailable() || !track || !buf || buf_size <= 0 || !s_TrackFX_GetParamName) {
    return false;
  }
  return s_TrackFX_GetParamName(track, fx_index, param_index, buf, buf_size);
}

double ReaperAPI::TrackFX_GetParam(MediaTrack *track, int fx_index, int param_index, double *minvalOut, double *maxvalOut) {
  if (!IsAvailable() || !track || !s_TrackFX_GetParam) {
    return 0.0;
  }
  return s_TrackFX_GetParam(track, fx_index, param_index, minvalOut, maxvalOut);
}

bool ReaperAPI::TrackFX_SetParam(MediaTrack *track, int fx_index, int param_index, double value) {
  if (!IsAvailable() || !track || !s_TrackFX_SetParam) {
    return false;
  }
  return s_TrackFX_SetParam(track, fx_index, param_index, value);
}

double ReaperAPI::TrackFX_GetParamNormalized(MediaTrack *track, int fx_index, int param_index) {
  if (!IsAvailable() || !track || !s_TrackFX_GetParamNormalized) {
    return 0.0;
  }
  return s_TrackFX_GetParamNormalized(track, fx_index, param_index);
}

bool ReaperAPI::TrackFX_SetParamNormalized(MediaTrack *track, int fx_index, int param_index, double value) {
  if (!IsAvailable() || !track || !s_TrackFX_SetParamNormalized) {
    return false;
  }
  return s_TrackFX_SetParamNormalized(track, fx_index, param_index, value);
}

bool ReaperAPI::TrackFX_FormatParamValue(MediaTrack *track, int fx_index, int param_index, double value, char *buf, int buf_size) {
  if (!IsAvailable() || !track || !buf || buf_size <= 0 || !s_TrackFX_FormatParamValue) {
    return false;
  }
  return s_TrackFX_FormatParamValue(track, fx_index, param_index, value, buf, buf_size);
}

bool ReaperAPI::TrackFX_GetEnabled(MediaTrack *track, int fx_index) {
  if (!IsAvailable() || !track || !s_TrackFX_GetEnabled) {
    return false;
  }
  return s_TrackFX_GetEnabled(track, fx_index);
}

bool ReaperAPI::TrackFX_SetEnabled(MediaTrack *track, int fx_index, bool enabled) {
  if (!IsAvailable() || !track || !s_TrackFX_SetEnabled) {
    return false;
  }
  return s_TrackFX_SetEnabled(track, fx_index, enabled);
}

bool ReaperAPI::TrackFX_Delete(MediaTrack *track, int fx_index) {
  if (!IsAvailable() || !track || !s_TrackFX_Delete) {
    return false;
  }
  return s_TrackFX_Delete(track, fx_index);
}

// TakeFX wrapper methods
int ReaperAPI::TakeFX_AddByName(MediaItem_Take *take, const char *fxname, int instantiate) {
  if (!IsAvailable() || !take || !fxname || !s_TakeFX_AddByName) {
    return -1;
  }
  return s_TakeFX_AddByName(take, fxname, instantiate);
}

bool ReaperAPI::TakeFX_GetFXName(MediaItem_Take *take, int fx_index, char *buf, int buf_size) {
  if (!IsAvailable() || !take || !buf || buf_size <= 0 || !s_TakeFX_GetFXName) {
    return false;
  }
  return s_TakeFX_GetFXName(take, fx_index, buf, buf_size);
}

int ReaperAPI::TakeFX_GetCount(MediaItem_Take *take) {
  if (!IsAvailable() || !take || !s_TakeFX_GetCount) {
    return 0;
  }
  return s_TakeFX_GetCount(take);
}

int ReaperAPI::TakeFX_GetNumParams(MediaItem_Take *take, int fx_index) {
  if (!IsAvailable() || !take || !s_TakeFX_GetNumParams) {
    return 0;
  }
  return s_TakeFX_GetNumParams(take, fx_index);
}

bool ReaperAPI::TakeFX_GetParamName(MediaItem_Take *take, int fx_index, int param_index, char *buf, int buf_size) {
  if (!IsAvailable() || !take || !buf || buf_size <= 0 || !s_TakeFX_GetParamName) {
    return false;
  }
  return s_TakeFX_GetParamName(take, fx_index, param_index, buf, buf_size);
}

double ReaperAPI::TakeFX_GetParam(MediaItem_Take *take, int fx_index, int param_index, double *minvalOut, double *maxvalOut) {
  if (!IsAvailable() || !take || !s_TakeFX_GetParam) {
    return 0.0;
  }
  return s_TakeFX_GetParam(take, fx_index, param_index, minvalOut, maxvalOut);
}

bool ReaperAPI::TakeFX_SetParam(MediaItem_Take *take, int fx_index, int param_index, double value) {
  if (!IsAvailable() || !take || !s_TakeFX_SetParam) {
    return false;
  }
  return s_TakeFX_SetParam(take, fx_index, param_index, value);
}

double ReaperAPI::TakeFX_GetParamNormalized(MediaItem_Take *take, int fx_index, int param_index) {
  if (!IsAvailable() || !take || !s_TakeFX_GetParamNormalized) {
    return 0.0;
  }
  return s_TakeFX_GetParamNormalized(take, fx_index, param_index);
}

bool ReaperAPI::TakeFX_SetParamNormalized(MediaItem_Take *take, int fx_index, int param_index, double value) {
  if (!IsAvailable() || !take || !s_TakeFX_SetParamNormalized) {
    return false;
  }
  return s_TakeFX_SetParamNormalized(take, fx_index, param_index, value);
}

bool ReaperAPI::TakeFX_FormatParamValue(MediaItem_Take *take, int fx_index, int param_index, double value, char *buf, int buf_size) {
  if (!IsAvailable() || !take || !buf || buf_size <= 0 || !s_TakeFX_FormatParamValue) {
    return false;
  }
  return s_TakeFX_FormatParamValue(take, fx_index, param_index, value, buf, buf_size);
}

bool ReaperAPI::TakeFX_GetEnabled(MediaItem_Take *take, int fx_index) {
  if (!IsAvailable() || !take || !s_TakeFX_GetEnabled) {
    return false;
  }
  return s_TakeFX_GetEnabled(take, fx_index);
}

bool ReaperAPI::TakeFX_SetEnabled(MediaItem_Take *take, int fx_index, bool enabled) {
  if (!IsAvailable() || !take || !s_TakeFX_SetEnabled) {
    return false;
  }
  return s_TakeFX_SetEnabled(take, fx_index, enabled);
}

bool ReaperAPI::TakeFX_Delete(MediaItem_Take *take, int fx_index) {
  if (!IsAvailable() || !take || !s_TakeFX_Delete) {
    return false;
  }
  return s_TakeFX_Delete(take, fx_index);
}

} // namespace ReaWrap

