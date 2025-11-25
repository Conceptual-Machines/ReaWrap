#include <ReaWrap/TrackFX.h>
#include <ReaWrap/Track.h>
#include <cstring>

namespace ReaWrap {

TrackFX::TrackFX(Track *track, int fx_index, bool isInputFX)
    : m_track(track), m_fx_index(fx_index), m_is_input_fx(isInputFX) {}

TrackFX *TrackFX::addByName(Track *track, const char *fxname, bool isInputFX) {
  if (!ReaperAPI::IsAvailable() || !track || !fxname || !fxname[0]) {
    return nullptr;
  }

  MediaTrack *reaper_track = track->getReaperTrack();
  if (!reaper_track) {
    return nullptr;
  }

  // Add FX (instantiate = -1 means always create new)
  int fx_index = ReaperAPI::AddTrackFX(reaper_track, fxname, isInputFX);
  if (fx_index < 0) {
    return nullptr;
  }

  return new TrackFX(track, fx_index, isInputFX);
}

TrackFX *TrackFX::getByIndex(Track *track, int fx_index, bool isInputFX) {
  if (!ReaperAPI::IsAvailable() || !track || fx_index < 0) {
    return nullptr;
  }

  // Verify FX exists by checking count
  MediaTrack *reaper_track = track->getReaperTrack();
  if (!reaper_track) {
    return nullptr;
  }

  int count = ReaperAPI::TrackFX_GetCount(reaper_track, isInputFX);
  if (fx_index >= count) {
    return nullptr;
  }

  return new TrackFX(track, fx_index, isInputFX);
}

bool TrackFX::getName(char *buf, int buf_size) const {
  if (!m_track || !buf || buf_size <= 0) {
    return false;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return false;
  }
  return ReaperAPI::TrackFX_GetFXName(reaper_track, m_fx_index, buf, buf_size);
}

int TrackFX::getNumParams() const {
  if (!m_track) {
    return 0;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return 0;
  }
  return ReaperAPI::TrackFX_GetNumParams(reaper_track, m_fx_index);
}

bool TrackFX::getParamName(int param_index, char *buf, int buf_size) const {
  if (!m_track || !buf || buf_size <= 0) {
    return false;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return false;
  }
  return ReaperAPI::TrackFX_GetParamName(reaper_track, m_fx_index, param_index, buf, buf_size);
}

double TrackFX::getParam(int param_index, double *minvalOut, double *maxvalOut) const {
  if (!m_track) {
    return 0.0;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return 0.0;
  }
  return ReaperAPI::TrackFX_GetParam(reaper_track, m_fx_index, param_index, minvalOut, maxvalOut);
}

bool TrackFX::setParam(int param_index, double value) {
  if (!m_track) {
    return false;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return false;
  }
  return ReaperAPI::TrackFX_SetParam(reaper_track, m_fx_index, param_index, value);
}

double TrackFX::getParamNormalized(int param_index) const {
  if (!m_track) {
    return 0.0;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return 0.0;
  }
  return ReaperAPI::TrackFX_GetParamNormalized(reaper_track, m_fx_index, param_index);
}

bool TrackFX::setParamNormalized(int param_index, double value) {
  if (!m_track) {
    return false;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return false;
  }
  return ReaperAPI::TrackFX_SetParamNormalized(reaper_track, m_fx_index, param_index, value);
}

bool TrackFX::formatParamValue(int param_index, double value, char *buf, int buf_size) const {
  if (!m_track || !buf || buf_size <= 0) {
    return false;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return false;
  }
  return ReaperAPI::TrackFX_FormatParamValue(reaper_track, m_fx_index, param_index, value, buf, buf_size);
}

bool TrackFX::isEnabled() const {
  if (!m_track) {
    return false;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return false;
  }
  return ReaperAPI::TrackFX_GetEnabled(reaper_track, m_fx_index);
}

bool TrackFX::setEnabled(bool enabled) {
  if (!m_track) {
    return false;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return false;
  }
  return ReaperAPI::TrackFX_SetEnabled(reaper_track, m_fx_index, enabled);
}

bool TrackFX::deleteFX() {
  if (!m_track) {
    return false;
  }
  MediaTrack *reaper_track = m_track->getReaperTrack();
  if (!reaper_track) {
    return false;
  }
  return ReaperAPI::TrackFX_Delete(reaper_track, m_fx_index);
}

std::vector<ParamInfo> TrackFX::getParamValues() const {
  std::vector<ParamInfo> params;
  if (!m_track) {
    return params;
  }
  
  int num_params = getNumParams();
  for (int i = 0; i < num_params; i++) {
    ParamInfo info;
    info.index = i;
    
    // Get parameter name
    char name_buf[256];
    if (getParamName(i, name_buf, sizeof(name_buf))) {
      info.name = std::string(name_buf);
    }
    
    // Get parameter value and range
    double min_val = 0.0, max_val = 0.0;
    info.value = getParam(i, &min_val, &max_val);
    info.minValue = min_val;
    info.maxValue = max_val;
    info.normalizedValue = getParamNormalized(i);
    
    params.push_back(info);
  }
  return params;
}

std::vector<std::string> TrackFX::getParamNames() const {
  std::vector<std::string> names;
  if (!m_track) {
    return names;
  }
  
  int num_params = getNumParams();
  for (int i = 0; i < num_params; i++) {
    char name_buf[256];
    if (getParamName(i, name_buf, sizeof(name_buf))) {
      names.push_back(std::string(name_buf));
    } else {
      names.push_back(std::string(""));
    }
  }
  return names;
}

} // namespace ReaWrap

