#pragma once

#include "reaper_plugin.h"

namespace ReaWrap {

// Low-level wrapper for REAPER API functions
// Caches function pointers for performance
class ReaperAPI {
public:
  // Initialize API (call once at plugin load)
  static bool Initialize(reaper_plugin_info_t *rec);
  static bool IsAvailable();

  // Track operations
  static MediaTrack *InsertTrack(int index, int flags = 1);
  static MediaTrack *GetTrack(int index);
  static int GetNumTracks();
  static bool SetTrackName(MediaTrack *track, const char *name);
  static bool GetTrackName(MediaTrack *track, char *buf, int buf_size);
  static MediaTrack *GetSelectedTrack(int sel_idx, bool want_master = false);
  static int CountSelectedTracks(bool want_master = false);

  // Media item operations
  static MediaItem *AddMediaItem(MediaTrack *track);
  static bool SetMediaItemPosition(MediaItem *item, double position);
  static bool SetMediaItemLength(MediaItem *item, double length);
  static double GetMediaItemPosition(MediaItem *item);
  static double GetMediaItemLength(MediaItem *item);
  static MediaItem *GetTrackMediaItem(MediaTrack *track, int item_idx);
  static int CountTrackMediaItems(MediaTrack *track);
  static MediaItem *GetSelectedMediaItem(int sel_idx);
  static int CountSelectedMediaItems();

  // Track properties
  static bool SetTrackVolume(MediaTrack *track, double volume_db);
  static bool SetTrackPan(MediaTrack *track, double pan);
  static bool SetTrackMute(MediaTrack *track, bool mute);
  static bool SetTrackSolo(MediaTrack *track, bool solo);
  static bool GetTrackVolume(MediaTrack *track, double *volume_db);
  static bool GetTrackPan(MediaTrack *track, double *pan);
  static bool GetTrackMute(MediaTrack *track, bool *mute);
  static bool GetTrackSolo(MediaTrack *track, bool *solo);

  // FX operations
  static int AddTrackFX(MediaTrack *track, const char *fxname, bool recFX = false);
  
  // TrackFX operations
  static bool TrackFX_GetFXName(MediaTrack *track, int fx_index, char *buf, int buf_size);
  static int TrackFX_GetCount(MediaTrack *track, bool isInputFX = false);
  static int TrackFX_GetNumParams(MediaTrack *track, int fx_index);
  static bool TrackFX_GetParamName(MediaTrack *track, int fx_index, int param_index, char *buf, int buf_size);
  // GetParam returns the value and outputs min/max via pointers
  static double TrackFX_GetParam(MediaTrack *track, int fx_index, int param_index, double *minvalOut, double *maxvalOut);
  static bool TrackFX_SetParam(MediaTrack *track, int fx_index, int param_index, double value);
  // GetParamNormalized returns the value directly (0.0-1.0)
  static double TrackFX_GetParamNormalized(MediaTrack *track, int fx_index, int param_index);
  static bool TrackFX_SetParamNormalized(MediaTrack *track, int fx_index, int param_index, double value);
  static bool TrackFX_FormatParamValue(MediaTrack *track, int fx_index, int param_index, double value, char *buf, int buf_size);
  static bool TrackFX_GetEnabled(MediaTrack *track, int fx_index);
  static bool TrackFX_SetEnabled(MediaTrack *track, int fx_index, bool enabled);
  static bool TrackFX_Delete(MediaTrack *track, int fx_index);
  
  // TakeFX operations
  static bool TakeFX_GetFXName(MediaItem_Take *take, int fx_index, char *buf, int buf_size);
  static int TakeFX_GetCount(MediaItem_Take *take);
  static int TakeFX_GetNumParams(MediaItem_Take *take, int fx_index);
  static bool TakeFX_GetParamName(MediaItem_Take *take, int fx_index, int param_index, char *buf, int buf_size);
  // GetParam returns the value and outputs min/max via pointers
  static double TakeFX_GetParam(MediaItem_Take *take, int fx_index, int param_index, double *minvalOut, double *maxvalOut);
  static bool TakeFX_SetParam(MediaItem_Take *take, int fx_index, int param_index, double value);
  // GetParamNormalized returns the value directly (0.0-1.0)
  static double TakeFX_GetParamNormalized(MediaItem_Take *take, int fx_index, int param_index);
  static bool TakeFX_SetParamNormalized(MediaItem_Take *take, int fx_index, int param_index, double value);
  static bool TakeFX_FormatParamValue(MediaItem_Take *take, int fx_index, int param_index, double value, char *buf, int buf_size);
  static bool TakeFX_GetEnabled(MediaItem_Take *take, int fx_index);
  static bool TakeFX_SetEnabled(MediaItem_Take *take, int fx_index, bool enabled);
  static bool TakeFX_Delete(MediaItem_Take *take, int fx_index);
  static int TakeFX_AddByName(MediaItem_Take *take, const char *fxname, int instantiate = -1);

  // Time conversion
  static double BarToTime(int bar);
  static int TimeToBar(double time);
  static double BarsToTime(int bars);

  // Project operations
  static void UpdateArrange();

  // Access to rec for functions that need it (e.g., Project utilities)
  static reaper_plugin_info_t *GetRec() { return s_rec; }

private:
  static reaper_plugin_info_t *s_rec;
  static bool s_initialized;

  // Cached function pointers
  static void (*s_InsertTrackInProject)(ReaProject *, int, int);
  static MediaTrack *(*s_GetTrack)(ReaProject *, int);
  static int (*s_GetNumTracks)(ReaProject *);
  static void *(*s_GetSetMediaTrackInfo)(INT_PTR, const char *, void *, bool *);
  static MediaTrack *(*s_GetSelectedTrack2)(ReaProject *, int, bool);
  static int (*s_CountSelectedTracks2)(ReaProject *, bool);

  static MediaItem *(*s_AddMediaItemToTrack)(MediaTrack *);
  static MediaItem *(*s_GetTrackMediaItem)(MediaTrack *, int);
  static int (*s_CountTrackMediaItems)(MediaTrack *);
  static MediaItem *(*s_GetSelectedMediaItem)(ReaProject *, int);
  static int (*s_CountSelectedMediaItems)(ReaProject *);
  static bool (*s_SetMediaItemPosition)(MediaItem *, double, bool);
  static bool (*s_SetMediaItemLength)(MediaItem *, double, bool);
  static double (*s_GetMediaItemPosition)(MediaItem *);
  static double (*s_GetMediaItemLength)(MediaItem *);

  static bool (*s_GetTrackUIVolPan)(MediaTrack *, double *, double *);
  static bool (*s_SetTrackUIVolPan)(MediaTrack *, double, double);
  static bool (*s_GetTrackUIMute)(MediaTrack *, bool *);
  static bool (*s_SetTrackUIMute)(MediaTrack *, bool);
  static bool (*s_GetTrackUISolo)(MediaTrack *, bool *);
  static bool (*s_SetTrackUISolo)(MediaTrack *, bool);

  static int (*s_TrackFX_AddByName)(MediaTrack *, const char *, bool, int);
  static bool (*s_TrackFX_GetFXName)(MediaTrack *, int, char *, int);
  static int (*s_TrackFX_GetCount)(MediaTrack *);
  static int (*s_TrackFX_GetNumParams)(MediaTrack *, int);
  static bool (*s_TrackFX_GetParamName)(MediaTrack *, int, int, char *, int);
  static double (*s_TrackFX_GetParam)(MediaTrack *, int, int, double *, double *);
  static bool (*s_TrackFX_SetParam)(MediaTrack *, int, int, double);
  static double (*s_TrackFX_GetParamNormalized)(MediaTrack *, int, int);
  static bool (*s_TrackFX_SetParamNormalized)(MediaTrack *, int, int, double);
  static bool (*s_TrackFX_FormatParamValue)(MediaTrack *, int, int, double, char *, int);
  static bool (*s_TrackFX_GetEnabled)(MediaTrack *, int);
  static bool (*s_TrackFX_SetEnabled)(MediaTrack *, int, bool);
  static bool (*s_TrackFX_Delete)(MediaTrack *, int);
  
  static int (*s_TakeFX_AddByName)(MediaItem_Take *, const char *, int);
  static bool (*s_TakeFX_GetFXName)(MediaItem_Take *, int, char *, int);
  static int (*s_TakeFX_GetCount)(MediaItem_Take *);
  static int (*s_TakeFX_GetNumParams)(MediaItem_Take *, int);
  static bool (*s_TakeFX_GetParamName)(MediaItem_Take *, int, int, char *, int);
  static double (*s_TakeFX_GetParam)(MediaItem_Take *, int, int, double *, double *);
  static bool (*s_TakeFX_SetParam)(MediaItem_Take *, int, int, double);
  static double (*s_TakeFX_GetParamNormalized)(MediaItem_Take *, int, int);
  static bool (*s_TakeFX_SetParamNormalized)(MediaItem_Take *, int, int, double);
  static bool (*s_TakeFX_FormatParamValue)(MediaItem_Take *, int, int, double, char *, int);
  static bool (*s_TakeFX_GetEnabled)(MediaItem_Take *, int);
  static bool (*s_TakeFX_SetEnabled)(MediaItem_Take *, int, bool);
  static bool (*s_TakeFX_Delete)(MediaItem_Take *, int);

  static double (*s_TimeMap_GetMeasureInfo)(ReaProject *, int, double *, double *,
                                            int *, int *, double *);
  static double (*s_TimeMap2_QNToTime)(ReaProject *, double);
  static double (*s_TimeMap2_timeToQN)(ReaProject *, double);

  static void (*s_UpdateArrange)();
};

} // namespace ReaWrap

