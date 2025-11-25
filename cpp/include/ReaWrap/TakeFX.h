#pragma once

#include "reaper_plugin.h"
#include "ReaperAPI.h"
#include <vector>
#include <string>

namespace ReaWrap {

// Forward declaration
class Take;

// Parameter info structure for iterators (shared with TrackFX)
struct ParamInfo {
  int index;
  std::string name;
  double value;
  double normalizedValue;
  double minValue;
  double maxValue;
};

// High-level TakeFX object
// Represents a single FX in a take's FX chain
class TakeFX {
private:
  Take *m_take;
  int m_fx_index;

public:
  // Factory method - add FX by name
  // Returns nullptr on failure
  static TakeFX *addByName(Take *take, const char *fxname);

  // Get FX by index
  static TakeFX *getByIndex(Take *take, int fx_index);

  // Getters
  Take *getTake() const { return m_take; }
  int getIndex() const { return m_fx_index; }

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
  TakeFX *setParamValue(int param_index, double value) {
    setParam(param_index, value);
    return this;
  }

private:
  // Private constructor - use factory methods
  TakeFX(Take *take, int fx_index);
};

} // namespace ReaWrap

