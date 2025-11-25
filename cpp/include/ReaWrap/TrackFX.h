#pragma once

#include "reaper_plugin.h"
#include "ReaperAPI.h"
#include <vector>
#include <string>

namespace ReaWrap {

// Forward declaration
class Track;

// Parameter info structure for iterators
struct ParamInfo {
  int index;
  std::string name;
  double value;
  double normalizedValue;
  double minValue;
  double maxValue;
};

// High-level TrackFX object
// Represents a single FX in a track's FX chain
class TrackFX {
private:
  Track *m_track;
  int m_fx_index;
  bool m_is_input_fx; // true for input FX, false for track FX

public:
  // Factory method - add FX by name
  // Returns nullptr on failure
  static TrackFX *addByName(Track *track, const char *fxname, bool isInputFX = false);

  // Get FX by index
  static TrackFX *getByIndex(Track *track, int fx_index, bool isInputFX = false);

  // Getters
  Track *getTrack() const { return m_track; }
  int getIndex() const { return m_fx_index; }
  bool isInputFX() const { return m_is_input_fx; }

  // FX information
  bool getName(char *buf, int buf_size) const;
  int getNumParams() const;
  bool getParamName(int param_index, char *buf, int buf_size) const;

  // Parameter operations
  // GetParam returns the value and optionally outputs min/max range
  double getParam(int param_index, double *minvalOut = nullptr, double *maxvalOut = nullptr) const;
  bool setParam(int param_index, double value);
  // GetParamNormalized returns normalized value (0.0-1.0)
  double getParamNormalized(int param_index) const;
  bool setParamNormalized(int param_index, double value);
  bool formatParamValue(int param_index, double value, char *buf, int buf_size) const;

  // Iterator support - get parameter collections
  std::vector<ParamInfo> getParamValues() const;
  std::vector<std::string> getParamNames() const;

  // FX state
  bool isEnabled() const;
  bool setEnabled(bool enabled);

  // Operations
  bool deleteFX();

  // Method chaining support
  TrackFX *setParamValue(int param_index, double value) {
    setParam(param_index, value);
    return this;
  }

private:
  // Private constructor - use factory methods
  TrackFX(Track *track, int fx_index, bool isInputFX);
};

} // namespace ReaWrap

