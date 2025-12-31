#pragma once

#include "reaper_plugin.h"

namespace ReaWrap {

// Type aliases for REAPER SDK types (to avoid conflicts with ReaWrap wrapper types)
using ReaMediaItem = ::MediaItem;
using ReaMediaTrack = ::MediaTrack;
using ReaMediaItemTake = ::MediaItem_Take;
using ReaProject = void *; // ReaProject is typically void* in REAPER API

// Low-level wrapper for REAPER API functions
// Caches function pointers for performance
class ReaperAPI {
public:
  // Initialize API (call once at plugin load)
  static bool Initialize(reaper_plugin_info_t *rec);
  static bool IsAvailable();

  // Track operations (using REAPER SDK types)
  static ReaMediaTrack *InsertTrack(int index, int flags = 1);
  static ReaMediaTrack *GetTrack(int index);
  static int GetNumTracks();
  static bool SetTrackName(ReaMediaTrack *track, const char *name);
  static bool GetTrackName(ReaMediaTrack *track, char *buf, int buf_size);
  static ReaMediaTrack *GetSelectedTrack(int sel_idx, bool want_master = false);
  static int CountSelectedTracks(bool want_master = false);

  // Media item operations (using REAPER SDK types)
  static ReaMediaItem *AddMediaItem(ReaMediaTrack *track);
  static bool SetMediaItemPosition(ReaMediaItem *item, double position);
  static bool SetMediaItemLength(ReaMediaItem *item, double length);
  static double GetMediaItemPosition(ReaMediaItem *item);
  static double GetMediaItemLength(ReaMediaItem *item);
  static ReaMediaItem *GetTrackMediaItem(ReaMediaTrack *track, int item_idx);
  static int CountTrackMediaItems(ReaMediaTrack *track);
  static ReaMediaItem *GetSelectedMediaItem(int sel_idx);
  static int CountSelectedMediaItems();

  // Track properties
  static bool SetTrackVolume(ReaMediaTrack *track, double volume_db);
  static bool SetTrackPan(ReaMediaTrack *track, double pan);
  static bool SetTrackMute(ReaMediaTrack *track, bool mute);
  static bool SetTrackSolo(ReaMediaTrack *track, bool solo);
  static bool GetTrackVolume(ReaMediaTrack *track, double *volume_db);
  static bool GetTrackPan(ReaMediaTrack *track, double *pan);
  static bool GetTrackMute(ReaMediaTrack *track, bool *mute);
  static bool GetTrackSolo(ReaMediaTrack *track, bool *solo);

  // FX operations
  static int AddTrackFX(ReaMediaTrack *track, const char *fxname, bool recFX = false);

  // TrackFX operations
  static bool TrackFX_GetFXName(ReaMediaTrack *track, int fx_index, char *buf, int buf_size);
  static int TrackFX_GetCount(ReaMediaTrack *track, bool isInputFX = false);
  static int TrackFX_GetNumParams(ReaMediaTrack *track, int fx_index);
  static bool TrackFX_GetParamName(ReaMediaTrack *track, int fx_index, int param_index, char *buf,
                                   int buf_size);
  // GetParam returns the value and outputs min/max via pointers
  static double TrackFX_GetParam(ReaMediaTrack *track, int fx_index, int param_index,
                                 double *minvalOut, double *maxvalOut);
  static bool TrackFX_SetParam(ReaMediaTrack *track, int fx_index, int param_index, double value);
  // GetParamNormalized returns the value directly (0.0-1.0)
  static double TrackFX_GetParamNormalized(ReaMediaTrack *track, int fx_index, int param_index);
  static bool TrackFX_SetParamNormalized(ReaMediaTrack *track, int fx_index, int param_index,
                                         double value);
  static bool TrackFX_FormatParamValue(ReaMediaTrack *track, int fx_index, int param_index,
                                       double value, char *buf, int buf_size);
  static bool TrackFX_GetEnabled(ReaMediaTrack *track, int fx_index);
  static bool TrackFX_SetEnabled(ReaMediaTrack *track, int fx_index, bool enabled);
  static bool TrackFX_Delete(ReaMediaTrack *track, int fx_index);

  // TakeFX operations
  static bool TakeFX_GetFXName(ReaMediaItemTake *take, int fx_index, char *buf, int buf_size);
  static int TakeFX_GetCount(ReaMediaItemTake *take);
  static int TakeFX_GetNumParams(ReaMediaItemTake *take, int fx_index);
  static bool TakeFX_GetParamName(ReaMediaItemTake *take, int fx_index, int param_index, char *buf,
                                  int buf_size);
  // GetParam returns the value and outputs min/max via pointers
  static double TakeFX_GetParam(ReaMediaItemTake *take, int fx_index, int param_index,
                                double *minvalOut, double *maxvalOut);
  static bool TakeFX_SetParam(ReaMediaItemTake *take, int fx_index, int param_index, double value);
  // GetParamNormalized returns the value directly (0.0-1.0)
  static double TakeFX_GetParamNormalized(ReaMediaItemTake *take, int fx_index, int param_index);
  static bool TakeFX_SetParamNormalized(ReaMediaItemTake *take, int fx_index, int param_index,
                                        double value);
  static bool TakeFX_FormatParamValue(ReaMediaItemTake *take, int fx_index, int param_index,
                                      double value, char *buf, int buf_size);
  static bool TakeFX_GetEnabled(ReaMediaItemTake *take, int fx_index);
  static bool TakeFX_SetEnabled(ReaMediaItemTake *take, int fx_index, bool enabled);
  static bool TakeFX_Delete(ReaMediaItemTake *take, int fx_index);
  static int TakeFX_AddByName(ReaMediaItemTake *take, const char *fxname, int instantiate = -1);

  // Time conversion
  static double BarToTime(int bar);
  static int TimeToBar(double time);
  static double BarsToTime(int bars);

  // Time map operations
  static double GetMeasureInfo(int measure, double *qn_start, double *qn_end, int *timesig_num,
                               int *timesig_denom, double *tempo);

  // Project operations
  static void UpdateArrange();

  // Access to rec for functions that need it (e.g., Project utilities)
  static reaper_plugin_info_t *GetRec() { return s_rec; }

private:
  static reaper_plugin_info_t *s_rec;
  static bool s_initialized;

  // Cached function pointers
  static void (*s_InsertTrackInProject)(ReaProject *, int, int);
  static ReaMediaTrack *(*s_GetTrack)(ReaProject *, int);
  static int (*s_GetNumTracks)(ReaProject *);
  static void *(*s_GetSetMediaTrackInfo)(INT_PTR, const char *, void *, bool *);
  static ReaMediaTrack *(*s_GetSelectedTrack2)(ReaProject *, int, bool);
  static int (*s_CountSelectedTracks2)(ReaProject *, bool);

  static ReaMediaItem *(*s_AddMediaItemToTrack)(ReaMediaTrack *);
  static ReaMediaItem *(*s_GetTrackMediaItem)(ReaMediaTrack *, int);
  static int (*s_CountTrackMediaItems)(ReaMediaTrack *);
  static ReaMediaItem *(*s_GetSelectedMediaItem)(ReaProject *, int);
  static int (*s_CountSelectedMediaItems)(ReaProject *);
  static bool (*s_SetMediaItemPosition)(ReaMediaItem *, double, bool);
  static bool (*s_SetMediaItemLength)(ReaMediaItem *, double, bool);
  static double (*s_GetMediaItemPosition)(ReaMediaItem *);
  static double (*s_GetMediaItemLength)(ReaMediaItem *);

  static bool (*s_GetTrackUIVolPan)(ReaMediaTrack *, double *, double *);
  static bool (*s_SetTrackUIVolPan)(ReaMediaTrack *, double, double);
  static bool (*s_GetTrackUIMute)(ReaMediaTrack *, bool *);
  static bool (*s_SetTrackUIMute)(ReaMediaTrack *, bool);
  static bool (*s_GetTrackUISolo)(ReaMediaTrack *, bool *);
  static bool (*s_SetTrackUISolo)(ReaMediaTrack *, bool);

  static int (*s_TrackFX_AddByName)(ReaMediaTrack *, const char *, bool, int);
  static bool (*s_TrackFX_GetFXName)(ReaMediaTrack *, int, char *, int);
  static int (*s_TrackFX_GetCount)(ReaMediaTrack *);
  static int (*s_TrackFX_GetNumParams)(ReaMediaTrack *, int);
  static bool (*s_TrackFX_GetParamName)(ReaMediaTrack *, int, int, char *, int);
  static double (*s_TrackFX_GetParam)(ReaMediaTrack *, int, int, double *, double *);
  static bool (*s_TrackFX_SetParam)(ReaMediaTrack *, int, int, double);
  static double (*s_TrackFX_GetParamNormalized)(ReaMediaTrack *, int, int);
  static bool (*s_TrackFX_SetParamNormalized)(ReaMediaTrack *, int, int, double);
  static bool (*s_TrackFX_FormatParamValue)(ReaMediaTrack *, int, int, double, char *, int);
  static bool (*s_TrackFX_GetEnabled)(ReaMediaTrack *, int);
  static bool (*s_TrackFX_SetEnabled)(ReaMediaTrack *, int, bool);
  static bool (*s_TrackFX_Delete)(ReaMediaTrack *, int);

  static int (*s_TakeFX_AddByName)(ReaMediaItemTake *, const char *, int);
  static bool (*s_TakeFX_GetFXName)(ReaMediaItemTake *, int, char *, int);
  static int (*s_TakeFX_GetCount)(ReaMediaItemTake *);
  static int (*s_TakeFX_GetNumParams)(ReaMediaItemTake *, int);
  static bool (*s_TakeFX_GetParamName)(ReaMediaItemTake *, int, int, char *, int);
  static double (*s_TakeFX_GetParam)(ReaMediaItemTake *, int, int, double *, double *);
  static bool (*s_TakeFX_SetParam)(ReaMediaItemTake *, int, int, double);
  static double (*s_TakeFX_GetParamNormalized)(ReaMediaItemTake *, int, int);
  static bool (*s_TakeFX_SetParamNormalized)(ReaMediaItemTake *, int, int, double);
  static bool (*s_TakeFX_FormatParamValue)(ReaMediaItemTake *, int, int, double, char *, int);
  static bool (*s_TakeFX_GetEnabled)(ReaMediaItemTake *, int);
  static bool (*s_TakeFX_SetEnabled)(ReaMediaItemTake *, int, bool);
  static bool (*s_TakeFX_Delete)(ReaMediaItemTake *, int);

  static double (*s_TimeMap_GetMeasureInfo)(ReaProject *, int, double *, double *, int *, int *,
                                            double *);
  static double (*s_TimeMap2_QNToTime)(ReaProject *, double);
  static double (*s_TimeMap2_timeToQN)(ReaProject *, double);

  static void (*s_UpdateArrange)();
};

} // namespace ReaWrap
