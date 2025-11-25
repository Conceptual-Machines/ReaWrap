#include <ReaWrap/Take.h>
#include <ReaWrap/TakeFX.h>
#include <cstring>

namespace ReaWrap {

TakeFX::TakeFX(Take *take, int fx_index) : m_take(take), m_fx_index(fx_index) {}

TakeFX *TakeFX::addByName(Take *take, const char *fxname) {
  if (!ReaperAPI::IsAvailable() || !take || !fxname || !fxname[0]) {
    return nullptr;
  }

  MediaItem_Take *reaper_take = take->getReaperTake();
  if (!reaper_take) {
    return nullptr;
  }

  // Add FX (instantiate = -1 means always create new)
  int fx_index = ReaperAPI::TakeFX_AddByName(reaper_take, fxname, -1);
  if (fx_index < 0) {
    return nullptr;
  }

  return new TakeFX(take, fx_index);
}

TakeFX *TakeFX::getByIndex(Take *take, int fx_index) {
  if (!ReaperAPI::IsAvailable() || !take || fx_index < 0) {
    return nullptr;
  }

  // Verify FX exists by checking count
  MediaItem_Take *reaper_take = take->getReaperTake();
  if (!reaper_take) {
    return nullptr;
  }

  int count = ReaperAPI::TakeFX_GetCount(reaper_take);
  if (fx_index >= count) {
    return nullptr;
  }

  return new TakeFX(take, fx_index);
}

bool TakeFX::getName(char *buf, int buf_size) const {
  if (!m_take || !buf || buf_size <= 0) {
    return false;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return false;
  }
  return ReaperAPI::TakeFX_GetFXName(reaper_take, m_fx_index, buf, buf_size);
}

int TakeFX::getNumParams() const {
  if (!m_take) {
    return 0;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return 0;
  }
  return ReaperAPI::TakeFX_GetNumParams(reaper_take, m_fx_index);
}

bool TakeFX::getParamName(int param_index, char *buf, int buf_size) const {
  if (!m_take || !buf || buf_size <= 0) {
    return false;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return false;
  }
  return ReaperAPI::TakeFX_GetParamName(reaper_take, m_fx_index, param_index, buf, buf_size);
}

double TakeFX::getParam(int param_index, double *minvalOut, double *maxvalOut) const {
  if (!m_take) {
    return 0.0;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return 0.0;
  }
  return ReaperAPI::TakeFX_GetParam(reaper_take, m_fx_index, param_index, minvalOut, maxvalOut);
}

bool TakeFX::setParam(int param_index, double value) {
  if (!m_take) {
    return false;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return false;
  }
  return ReaperAPI::TakeFX_SetParam(reaper_take, m_fx_index, param_index, value);
}

double TakeFX::getParamNormalized(int param_index) const {
  if (!m_take) {
    return 0.0;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return 0.0;
  }
  return ReaperAPI::TakeFX_GetParamNormalized(reaper_take, m_fx_index, param_index);
}

bool TakeFX::setParamNormalized(int param_index, double value) {
  if (!m_take) {
    return false;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return false;
  }
  return ReaperAPI::TakeFX_SetParamNormalized(reaper_take, m_fx_index, param_index, value);
}

bool TakeFX::formatParamValue(int param_index, double value, char *buf, int buf_size) const {
  if (!m_take || !buf || buf_size <= 0) {
    return false;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return false;
  }
  return ReaperAPI::TakeFX_FormatParamValue(reaper_take, m_fx_index, param_index, value, buf,
                                            buf_size);
}

bool TakeFX::isEnabled() const {
  if (!m_take) {
    return false;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return false;
  }
  return ReaperAPI::TakeFX_GetEnabled(reaper_take, m_fx_index);
}

bool TakeFX::setEnabled(bool enabled) {
  if (!m_take) {
    return false;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return false;
  }
  return ReaperAPI::TakeFX_SetEnabled(reaper_take, m_fx_index, enabled);
}

bool TakeFX::deleteFX() {
  if (!m_take) {
    return false;
  }
  MediaItem_Take *reaper_take = m_take->getReaperTake();
  if (!reaper_take) {
    return false;
  }
  return ReaperAPI::TakeFX_Delete(reaper_take, m_fx_index);
}

std::vector<ParamInfo> TakeFX::getParamValues() const {
  std::vector<ParamInfo> params;
  if (!m_take) {
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

std::vector<std::string> TakeFX::getParamNames() const {
  std::vector<std::string> names;
  if (!m_take) {
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
