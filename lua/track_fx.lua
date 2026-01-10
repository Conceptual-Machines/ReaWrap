--- Provide implementation for TrackFX functions.
-- @author Nomad Monad
-- @license MIT
-- @module track_fx

local r = reaper
local helpers = require("helpers")

local TrackFX = {}

--- Create new TrackFX instance.
--- @within ReaWrap Custom Methods
--- @param track table The Track object
--- @param fx_idx number The index of the FX
--- @return table TrackFX instance
function TrackFX:new(track, fx_idx)
  local obj = {
    pointer_type = "TrackFX",
    track = track,
    pointer = fx_idx,
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

--- Log messages with the TrackFX logger.
--- @within ReaWrap Custom Methods
--- @param ... (varargs) Messages to log.
function TrackFX:log(...)
  local logger = helpers.log_func("TrackFX")
  logger(...)
  return nil
end

--- String representation of the TrackFX instance.
--- @within ReaWrap Custom Methods
--- @return string
function TrackFX:__tostring()
  return string.format("<TrackFX name=%s>", self:get_name())
end

--- Delete this FX from the track.
--- @within ReaWrap Custom Methods
--- @return boolean Success
function TrackFX:delete()
  return r.TrackFX_Delete(self.track.pointer, self.pointer)
end

--- Get param values from TrackFX.
--- @within ReaWrap Custom Methods
--- @return table array<Envelope>
function TrackFX:get_param_values()
  local params = {}
  local count = self:get_num_params()
  for i = 0, count - 1 do
    local param = self:get_param(i)
    params[i + 1] = param
  end
  return params
end

--- Iterate over TrackFX param values.
--- @within ReaWrap Custom Methods
--- @return function iterator
function TrackFX:iter_param_values()
  return helpers.iter(self:get_param_values())
end

--- Get param names from TrackFX.
--- @within ReaWrap Custom Methods
--- @return table array<Envelope>
function TrackFX:get_param_names()
  local params = {}
  local count = self:get_num_params()
  for i = 0, count - 1 do
    local param = self:get_param_name(i)
    params[i + 1] = param
  end
  return params
end

--- Iterate over TrackFX param names.
--- @within ReaWrap Custom Methods
--- @return function iterator
function TrackFX:iter_param_names()
  return helpers.iter(self:get_param_names())
end

--- End Param Edit. Wraps TrackFX_EndParamEdit.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @return boolean
function TrackFX:end_param_edit(param)
  return r.TrackFX_EndParamEdit(self.track.pointer, self.pointer, param)
end

--- Format Param Value. Wraps TrackFX_FormatParamValue.
-- Note: only works with FX that support Cockos VST extensions.--- @within ReaScript Wrapped Methods param number--- @within ReaScript Wrapped Methods val number
--- @within ReaScript Wrapped Methods
--- @return string
function TrackFX:format_param_value(param, val)
  local ret_val, buf = r.TrackFX_FormatParamValue(self.track.pointer, self.pointer, param, val)
  if ret_val then
    return buf
  else
    error("Failed to format param value.")
  end
end

--- Format Param Value Normalized. Wraps TrackFX_FormatParamValueNormalized.
-- Note: only works with FX that support Cockos VST extensions.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @param value number
--- @param buf string
--- @return string
function TrackFX:format_param_value_normalized(param, value, buf)
  local ret_val, buf =
    r.TrackFX_FormatParamValueNormalized(self.track.pointer, self.pointer, param, value, buf)
  if ret_val then
    return buf
  else
    error("Failed to format param value normalized.")
  end
end

--- Get Chain Visible. Wraps TrackFX_GetChainVisible.
-- returns index of effect visible in chain, or -1 for chain hidden, or -2 for
-- chain visible but no effect selected
--- @within ReaScript Wrapped Methods
--- @return number
function TrackFX:get_chain_visible()
  return r.TrackFX_GetChainVisible(self.track.pointer)
end

--- Get Enabled. Wraps TrackFX_GetEnabled.
--- @within ReaScript Wrapped Methods
--- @return boolean
function TrackFX:get_enabled()
  return r.TrackFX_GetEnabled(self.track.pointer, self.pointer)
end

--- Get Eq. Wraps TrackFX_GetEQ.
-- Get the index of ReaEQ in the track FX chain. If ReaEQ is not in the chain and
-- instantiate is true, it will be inserted.
--- @within ReaScript Wrapped Methods
--- @param instantiate boolean Optional.
--- @return number
--- @see TrackFX:get_instrument
function TrackFX:get_eq(instantiate)
  local instantiate = instantiate or false
  return r.TrackFX_GetEQ(self.track.pointer, instantiate)
end

TrackFX.BandTypeConstants = {
  MASTER_GAIN = -1,
  HIPASS = 0,
  LOSHELF = 1,
  BAND = 2,
  NOTCH = 3,
  HISHELF = 4,
  LOPASS = 5,
  BANDPASS = 6,
  PARALLEL_BANDPASS = 7,
}

TrackFX.BandIndexConstants = {
  FIRST = 0,
  SECOND = 1,
  THIRD = 2,
  FOURTH = 3,
  FIFTH = 4,
  SIXTH = 5,
  SEVENTH = 6,
  EIGHTH = 7,
  NINTH = 8,
  TENTH = 9,
}

--- Get Eq Band Enabled. Wraps TrackFX_GetEQBandEnabled.
-- Returns true if the EQ band is enabled. Returns false if the band is disabled,
-- or if track/fx_idx is not ReaEQ.
--- @within ReaScript Wrapped Methods
--- @param band_type number TrackFX.BandTypeConstants.
--- @param band_idx number TrackFX.BandIndexConstants.
--- @return boolean
function TrackFX:get_eq_band_enabled(band_type, band_idx)
  return r.TrackFX_GetEQBandEnabled(self.track.pointer, self.pointer, band_type, band_idx)
end

--- Get Eq Param. Wraps TrackFX_GetEQParam.
-- Returns false if track/fx_idx is not ReaEQ.
-- bandpass.
--- @within ReaScript Wrapped Methods
--- @param param_idx number
--- @return number band_type. See TrackFX.BandTypeConstants.
--- @return number band_idx See TrackFX.BandIndexConstants.
--- @return number param_type
--- @return number norm_val
function TrackFX:get_eq_param(param_idx)
  local ret_val, band_type, band_idx, param_type, norm_val =
    r.TrackFX_GetEQParam(self.track.pointer, self.pointer, param_idx)
  if ret_val then
    return band_type, band_idx, param_type, norm_val
  else
    error("Failed to get EQ param.")
  end
end

--- Get Floating Window. Wraps TrackFX_GetFloatingWindow.
-- returns HWND of floating window for effect index, if any.
-- and container_item.X.
--- @within ReaScript Wrapped Methods
--- @return userdata HWND
function TrackFX:get_floating_window()
  return r.TrackFX_GetFloatingWindow(self.track.pointer, self.pointer)
end

--- Get Formatted Param Value. Wraps TrackFX_GetFormattedParamValue.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @return string
function TrackFX:get_formatted_param_value(param)
  local ret_val, buf = r.TrackFX_GetFormattedParamValue(self.track.pointer, self.pointer, param)
  if ret_val then
    return buf
  else
    error("Failed to get formatted param value.")
  end
end

--- Get Guid. Wraps TrackFX_GetFXGUID.
--- @within ReaScript Wrapped Methods
--- @return string
function TrackFX:get_guid()
  return r.TrackFX_GetFXGUID(self.track.pointer, self.pointer)
end

--- Get Name. Wraps TrackFX_GetFXName.
--- @within ReaScript Wrapped Methods
--- @param fx_idx number Optional. If not provided, the current FX index will be used.
--- @return string
function TrackFX:get_name(fx_idx)
  local fx_idx = fx_idx or self.pointer
  local ret_val, buf = r.TrackFX_GetFXName(self.track.pointer, fx_idx)
  if ret_val then
    return buf
  else
    error("Failed to get FX name.")
  end
end

--- Get Instrument. Wraps TrackFX_GetInstrument.
-- Get the index of the first track FX insert that is a virtual instrument, or -1
-- if none.
--- @within ReaScript Wrapped Methods
--- @return number
--- @see TrackFX:get_eq
function TrackFX:get_instrument()
  return r.TrackFX_GetInstrument(self.track.pointer)
end

--- Get Io Size. Wraps TrackFX_GetIOSize.
-- Gets the number of input/output pins for FX if available, returns plug-in type
-- or -1 on error.
--- @within ReaScript Wrapped Methods
--- @return number input_pins
--- @return number output_pins
function TrackFX:get_io_size()
  local ret_val, input_pins, output_pins = r.TrackFX_GetIOSize(self.track.pointer, self.pointer)
  if ret_val then
    return input_pins, output_pins
  else
    error("Failed to get IO size.")
  end
end

TrackFX.NamedConfigParamConstants = {}

--- A table of configuration parameters for TrackFX:get_named_config_param. Read Only.
--- @within Constants
--- @field PDC string PDC latency
--- @field IN_PIN_X string name of input pin X
--- @field OUT_PIN_X string name of output pin X
--- @field FX_TYPE string type string
--- @field FX_IDENT string type-specific identifier
--- @field FX_NAME string name of FX (also supported as original_name)
--- @field GAINREDUCTION_DB string [ReaComp + other supported compressors]
--- @field PARENT_CONTAINER string FX ID of parent container, if any (v7.06+)
--- @field CONTAINER_COUNT string [Container] number of FX in container
--- @field CONTAINER_ITEM_X string FX ID of item in container (first item is container_item.0) (v7.06+)
--- @field PARAM_X_CONTAINER_MAP_HINT_ID string unique ID of mapping (preserved if mapping order changes)
--- @field PARAM_X_CONTAINER_MAP_DELETE string read this value in order to remove the mapping for this parameter
--- @field CONTAINER_MAP_ADD string read from this value to add a new container parameter mapping -- will return new parameter index (accessed via param.X.container_map.*)
--- @field CONTAINER_MAP_ADD_FXID_PARMIDX string read from this value to add/get container parameter mapping for FXID/PARMIDX -- will return the parameter index (accessed via param.X.container_map.*). FXID can be a full address (must be a child of the container) or a 0-based sub-index (v7.06+).
--- @field CONTAINER_MAP_GET_FXID_PARMIDX string read from this value to get container parameter mapping for FXID/PARMIDX -- will return the parameter index (accessed via param.X.container_map.*). FXID can be a full address (must be a child of the container) or a 0-based sub-index (v7.06+).
--- @field CHAIN_PDC_ACTUAL string returns the actual chain latency in samples, only valid after playback has commenced, may be rounded up to block size.
--- @field CHAIN_PDC_REPORTING string returns the reported chain latency, always valid, not rounded to block size.
TrackFX.NamedConfigParamConstants.ReadOnly = {}

--- A table of configuration parameters for TrackFX:get_named_config_param. Read Write.
--- @within Constants
--- @field VST_CHUNK_PROGRAM string base64-encoded VST-specific chunk.
--- @field CLAP_CHUNK string base64-encoded CLAP-specific chunk.
--- @field PARAM_X_LFO string parameter modulation LFO state
--- @field PARAM_X_ACS string parameter modulation ACS state
--- @field PARAM_X_PLINK string parameter link/MIDI link: set effect=-100 to support midi_*
--- @field PARAM_X_MOD string parameter module global settings
--- @field PARAM_X_LEARN string first two bytes of MIDI message, or OSC string if set
--- @field PARAM_X_LEARN_MODE string absolution/relative mode flag (0: Absolute, 1: 127=-1,1=+1, 2: 63=-1, 65=+1, 3: 65=-1, 1=+1, 4: toggle if nonzero)
--- @field PARAM_X_LEARN_FLAGS string &1=selected track only, &2=soft takeover, &4=focused FX only, &8=LFO retrigger, &16=visible FX only
--- @field PARAM_X_CONTAINER_MAP_FX_INDEX string index of FX contained in container
--- @field PARAM_X_CONTAINER_MAP_FX_PARM string parameter index of parameter of FX contained in container
--- @field PARAM_X_CONTAINER_MAP_ALIASED_NAME string name of parameter (if user-renamed, otherwise fails)
--- @field BANDTYPE_X string band configuration [ReaEQ]
--- @field BANDENABLED_X string band configuration [ReaEQ]
--- @field THRESHOLD string [ReaLimit]
--- @field CEILING string [ReaLimit]
--- @field TRUEPEAK string [ReaLimit]
--- @field NUMCHANNELS string [ReaSurroundPan]
--- @field NUMSPEAKERS string [ReaSurroundPan]
--- @field RESETCHANNELS string [ReaSurroundPan]
--- @field ITEM_X string [ReaVerb] state configuration line, when writing should be followed by a write of DONE
--- @field FILE string [RS5k] file list, -/+ prefixes are write-only, when writing any, should be followed by a write of DONE
--- @field FILE_X string [RS5k] file list, -/+ prefixes are write-only, when writing any, should be followed by a write of DONE
--- @field MINUS_FILE_X string [RS5k] file list, -/+ prefixes are write-only, when writing any, should be followed by a write of DONE
--- @field PLUS_FILE_X string [RS5k] file list, -/+ prefixes are write-only, when writing any, should be followed by a write of DONE
--- @field MINUS_FILE_STAR string [RS5k] file list, -/+ prefixes are write-only, when writing any, should be followed by a write of DONE
--- @field MODE string [RS5k] general mode, resample mode
--- @field RSMODE string [RS5k] general mode, resample mode
--- @field VIDEO_CODE string [video processor] code
--- @field FORCE_AUTO_BYPASS string 0 or 1 - force auto-bypass plug-in on silence
--- @field PARALLEL string 0, 1 or 2 - 1=process plug-in in parallel with previous, 2=process plug-in parallel and merge MIDI
--- @field INSTANCE_OVERSAMPLE_SHIFT string instance oversampling shift amount, 0=none, 1=~96k, 2=~192k, etc. When setting requires playback stop/start to take effect
--- @field CHAIN_OVERSAMPLE_SHIFT string chain oversampling shift amount, 0=none, 1=~96k, 2=~192k, etc. When setting requires playback stop/start to take effect
--- @field CHAIN_PDC_MODE string chain PDC mode (0=classic, 1=new-default, 2=ignore PDC, 3=hwcomp-master)
--- @field CHAIN_SEL string selected/visible FX in chain
--- @field RENAMED_NAME string renamed FX instance name (empty string = not renamed)
--- @field CONTAINER_NCH string number of internal channels for container
--- @field CONTAINER_NCH_IN string number of input pins for container
--- @field CONTAINER_NCH_OUT string number of output pins for container
--- @field CONTAINER_NCH_FEEDBACK string number of internal feedback channels enabled in container
--- @field FOCUSED string reading returns 1 if focused. Writing a positive value to this sets the FX UI as `last focused.`
--- @field LAST_TOUCHED string reading returns two integers, one indicates whether FX is the last-touched FX, the second indicates which parameter was last touched. Writing a negative value ensures this plug-in is not set as last touched, otherwise the FX is set "last touched," and last touched parameter index is set to the value in the string (if valid).
TrackFX.NamedConfigParamConstants.ReadWrite = {}

--- A table of values to be associated with configuration constants.
--- @within Constants
--- @field container_idx number Index of the container.
--- @field input_pin_idx number Index of the input pin.
--- @field output_pin_idx number Index of the output pin.
--- @field fx_idx number Index of the FX.
--- @field param_idx number Index of the parameter.
--- @field param_value string Value of the parameter.
--- @see TrackFX.NamedConfigParamConstants.ReadOnly
--- @see TrackFX.NamedConfigParamConstants.ReadWrite
TrackFX.NamedConfigParamValues = {}

--- Create a table of named configuration parameters constants.
--- @within ReaScript Wrapped Methods
--- @param params Optional. A table containing values that need to be associated to a constant, e.g. CONTAINER_ITEM_X.
--- @return table. A populated table of configuration constants.
--- @usage -- For config params that require a value to be associated with a constant, e.g. CONTAINER_ITEM_X
-- local constants = TrackFX.NamedConfigParamConstants:create({container_idx = 0})
-- -- For config params that don't require a value
-- local constants = TrackFX.NamedConfigParamConstants:create()
--- @see TrackFX.NamedConfigParamConstants.ReadOnly
--- @see TrackFX.NamedConfigParamConstants.ReadWrite
--- @see TrackFX.NamedConfigParamValues
--- @function TrackFX.NamedConfigParamConstants:create
function TrackFX.NamedConfigParamConstants:create(params)
  local params = params or {}
  return {
    PDC = "pdc",
    IN_PIN_X = string.format("in_pin.%s", params.input_pin_idx),
    OUT_PIN_X = string.format("out_pin.%s", params.output_pin_idx),
    FX_TYPE = "fx_type",
    FX_IDENT = "fx_ident",
    FX_NAME = "fx_name",
    GAINREDUCTION_DB = "GainReduction_dB",
    PARENT_CONTAINER = "parent_container",
    CONTAINER_COUNT = "container_count",
    CONTAINER_ITEM_X = string.format("container_item.%s", params.container_idx),
    PARAM_X_CONTAINER_MAP_HINT_ID = string.format(
      "param.%s.container_map.hint_id",
      params.param_idx
    ),
    PARAM_X_CONTAINER_MAP_DELETE = string.format("param.%s.container_map.delete", params.param_idx),
    CONTAINER_MAP_ADD = "container_map.add",
    CONTAINER_MAP_ADD_FXID_PARMIDX = string.format(
      "container_map.add.%s.%s",
      params.fx_idx or "X",
      params.param_idx or "X"
    ),
    CONTAINER_MAP_GET_FXID_PARMIDX = string.format(
      "container_map.get.%s.%s",
      params.fx_idx or "X",
      params.param_idx or "X"
    ),
    CHAIN_PDC_ACTUAL = "chain_pdc_actual",
    CHAIN_PDC_REPORTING = "chain_pdc_reporting",
    VST_CHUNK_PROGRAM = "vst_chunk[_program]",
    CLAP_CHUNK = "clap_chunk",
    PARAM_X_LFO = string.format(
      "param.%s.lfo.%s",
      params.param_idx or "X",
      params.param_value or "X"
    ),
    PARAM_X_ACS = "param.X.acs.[active,dir,strength,attack,release,dblo,dbhi,chan,stereo,x2,y2]",
    PARAM_X_PLINK = "param.X.plink.[active,scale,offset,effect,param,midi_bus,midi_chan,midi_msg,midi_msg2]",
    PARAM_X_MOD = "param.X.mod.[active,baseline,visible]",
    PARAM_X_LEARN = "param.X.learn.[midi1,midi2,osc]",
    PARAM_X_LEARN_MODE = "param.X.learn.mode",
    PARAM_X_LEARN_FLAGS = "param.X.learn.flags",
    PARAM_X_CONTAINER_MAP_FX_INDEX = "param.X.container_map.fx_index",
    PARAM_X_CONTAINER_MAP_FX_PARM = "param.X.container_map.fx_parm",
    PARAM_X_CONTAINER_MAP_ALIASED_NAME = "param.X.container_map.aliased_name",
    BANDTYPE_X = "BANDTYPEx",
    BANDENABLED_X = "BANDENABLEDx",
    THRESHOLD = "THRESHOLD",
    CEILING = "CEILING",
    TRUEPEAK = "TRUEPEAK",
    NUMCHANNELS = "NUMCHANNELS",
    NUMSPEAKERS = "NUMSPEAKERS",
    RESETCHANNELS = "RESETCHANNELS",
    ITEM_X = "ITEMx",
    FILE = "FILE",
    FILE_X = "FILEx",
    MINUS_FILE_X = "-FILEx",
    PLUS_FILE_X = "+FILEx",
    MINUS_FILE_STAR = "-FILE*",
    MODE = "MODE",
    RSMODE = "RSMODE",
    VIDEO_CODE = "VIDEO_CODE",
    FORCE_AUTO_BYPASS = "force_auto_bypass",
    PARALLEL = "parallel",
    INSTANCE_OVERSAMPLE_SHIFT = "instance_oversample_shift",
    CHAIN_OVERSAMPLE_SHIFT = "chain_oversample_shift",
    CHAIN_PDC_MODE = "chain_pdc_mode",
    CHAIN_SEL = "chain_sel",
    RENAMED_NAME = "renamed_name",
    CONTAINER_NCH = "container_nch",
    CONTAINER_NCH_IN = "container_nch_in",
    CONTAINER_NCH_OUT = "container_nch_out",
    CONTAINER_NCH_FEEDBACK = "container_nch_feedback",
    FOCUSED = "focused",
    LAST_TOUCHED = "last_touched",
  }
end

--- Get Named Config Param. Wraps TrackFX_GetNamedConfigParm.
-- Gets plug-in specific named configuration value.
--- @within ReaScript Wrapped Methods
--- @param param_name string. Use TrackFX.NamedConfigParamConstants:create(params --[[optional]) for valid constants.
--- @return buf string
--- @usage -- For config params that don't require a value
-- local constants = TrackFX.NamedConfigParamConstants:create()
-- TrackFX:get_named_config_param(constants.PDC)
-- -- For config params that require a value
-- local constants = TrackFX.NamedConfigParamConstants:create({container_idx = 0})
-- TrackFX:get_named_config_param(constants.CONTAINER_ITEM_X)
--- @see TrackFX.NamedConfigParamConstants:create
--- @return string|nil value The parameter value, or nil if not found
function TrackFX:get_named_config_param(param_name)
  local ret_val, buf = r.TrackFX_GetNamedConfigParm(self.track.pointer, self.pointer, param_name)
  if ret_val then
    return buf
  else
    return nil  -- Parameter not found/not set (valid for optional params like plink)
  end
end

--- Get Num Params. Wraps TrackFX_GetNumParams.
--- @within ReaScript Wrapped Methods
--- @return number
function TrackFX:get_num_params()
  return r.TrackFX_GetNumParams(self.track.pointer, self.pointer)
end

--- Get Offline. Wraps TrackFX_GetOffline.
--- @within ReaScript Wrapped Methods
--- @return boolean
function TrackFX:get_offline()
  return r.TrackFX_GetOffline(self.track.pointer, self.pointer)
end

--- Get Open. Wraps TrackFX_GetOpen.
--- @within ReaScript Wrapped Methods
--- @return boolean
function TrackFX:get_open()
  return r.TrackFX_GetOpen(self.track.pointer, self.pointer)
end

--- Get Param. Wraps TrackFX_GetParam.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @return number param_value The current parameter value
--- @return number min_val The minimum parameter value
--- @return number max_val The maximum parameter value
function TrackFX:get_param(param)
  local ret_val, min_val, max_val = r.TrackFX_GetParam(self.track.pointer, self.pointer, param)
  if ret_val then
    return ret_val, min_val, max_val
  else
    error("Failed to get param.")
  end
end

--- Get Parameter Step Sizes. Wraps TrackFX_GetParameterStepSizes.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @return number step
--- @return number small_step
--- @return number large_step
--- @return boolean is_toggle
function TrackFX:get_parameter_step_sizes(param)
  local ret_val, step, small_step, large_step, is_toggle =
    r.TrackFX_GetParameterStepSizes(self.track.pointer, self.pointer, param)
  if ret_val then
    return step, small_step, large_step, is_toggle
  else
    error("Failed to get parameter step sizes.")
  end
end

--- Get Param Ex. Wraps TrackFX_GetParamEx.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @return number min_val
--- @return number max_val
--- @return number mid_val
function TrackFX:get_param_ex(param)
  local ret_val, min_val, max_val, mid_val =
    r.TrackFX_GetParamEx(self.track.pointer, self.pointer, param)
  if ret_val then
    return min_val, max_val, mid_val
  else
    error("Failed to get param ex.")
  end
end

--- Get Param From Ident. Wraps TrackFX_GetParamFromIdent.
-- gets the parameter index from an identifying string (:wet, :bypass, :delta, or a
-- string returned from GetParamIdent), or -1 if unknown.
--- @within ReaScript Wrapped Methods
--- @param ident_str string
--- @return number
function TrackFX:get_param_from_ident(ident_str)
  return r.TrackFX_GetParamFromIdent(self.track.pointer, self.pointer, ident_str)
end

--- Get Param Ident. Wraps TrackFX_GetParamIdent.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @return string
function TrackFX:get_param_ident(param)
  local ret_val, buf = r.TrackFX_GetParamIdent(self.track.pointer, self.pointer, param)
  if ret_val then
    return buf
  else
    error("Failed to get param ident.")
  end
end

--- Get Param Name. Wraps TrackFX_GetParamName.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @return string
function TrackFX:get_param_name(param)
  local ret_val, buf = r.TrackFX_GetParamName(self.track.pointer, self.pointer, param)
  if ret_val then
    return buf
  else
    error("Failed to get param name.")
  end
end

--- Get Param Normalized. Wraps TrackFX_GetParamNormalized.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @return number
function TrackFX:get_param_normalized(param)
  return r.TrackFX_GetParamNormalized(self.track.pointer, self.pointer, param)
end

--- Get Pin Mappings. Wraps TrackFX_GetPinMappings.
-- gets the effective channel mapping bitmask for a particular pin. high32Out will
-- be set to the high 32 bits. Add 0x1000000 to pin index in order to access the
-- second 64 bits of mappings independent of the first 64 bits. FX indices for
-- tracks can have 0x1000000 added to them in order to reference record input FX
-- (normal tracks) or hardware output FX (master track).
--- @within ReaScript Wrapped Methods
--- @param is_output number
--- @param pin number
--- @return number high32
function TrackFX:get_pin_mappings(is_output, pin)
  local ret_val, high32 = r.TrackFX_GetPinMappings(self.track.pointer, self.pointer, is_output, pin)
  if ret_val then
    return high32
  else
    error("Failed to get pin mappings.")
  end
end

--- Get Preset. Wraps TrackFX_GetPreset.
-- Get the name of the preset currently showing in the REAPER dropdown, or the full
-- path to a factory preset file for VST3 plug-ins (.vstpreset).
--- @within ReaScript Wrapped Methods
--- @see TrackFX:set_preset
function TrackFX:get_preset()
  local ret_val, preset_name = r.TrackFX_GetPreset(self.track.pointer, self.pointer)
  if ret_val then
    return preset_name
  else
    error("Failed to get preset.")
  end
end

--- Get Preset Index. Wraps TrackFX_GetPresetIndex.
--- @within ReaScript Wrapped Methods
--- @return number
function TrackFX:get_preset_index()
  local ret_val, preset_idx = r.TrackFX_GetPresetIndex(self.track.pointer, self.pointer)
  if ret_val then
    return preset_idx
  else
    error("Failed to get preset index.")
  end
end

--- Get Rec Chain Visible. Wraps TrackFX_GetRecChainVisible.
-- returns index of effect visible in record input chain, or -1 for chain hidden,
-- or -2 for chain visible but no effect selected
--- @within ReaScript Wrapped Methods
--- @return number
function TrackFX:get_rec_chain_visible()
  return r.TrackFX_GetRecChainVisible(self.track.pointer)
end

--- Get Rec Count. Wraps TrackFX_GetRecCount.
-- returns count of record input FX. To access record input FX, use a FX indices
-- [0x1000000..0x1000000+n). On the master track, this accesses monitoring FX
-- rather than record input FX.
--- @within ReaScript Wrapped Methods
--- @return number
function TrackFX:get_rec_count()
  return r.TrackFX_GetRecCount(self.track.pointer)
end

--- Get User Preset Filename. Wraps TrackFX_GetUserPresetFilename.
--- @within ReaScript Wrapped Methods
--- @return string
function TrackFX:get_user_preset_filename()
  return r.TrackFX_GetUserPresetFilename(self.track.pointer, self.pointer)
end

--- Navigate Presets. Wraps TrackFX_NavigatePresets.
-- preset_move==1 activates the next preset, preset_move==-1 activates the previous
-- preset, etc.
--- @within ReaScript Wrapped Methods
--- @param preset_move number
--- @return boolean
function TrackFX:navigate_presets(preset_move)
  return r.TrackFX_NavigatePresets(self.track.pointer, self.pointer, preset_move)
end

--- Set Enabled. Wraps TrackFX_SetEnabled.
-- See TrackFX:get_enabled. FX indices for tracks can have 0x1000000 added to them in
-- order to reference record input FX (normal tracks) or hardware output FX (master
-- track).
--- @within ReaScript Wrapped Methods
--- @param enabled boolean
--- @see TrackFX:get_enabled
function TrackFX:set_enabled(enabled)
  return r.TrackFX_SetEnabled(self.track.pointer, self.pointer, enabled)
end

--- Set Eq Band Enabled. Wraps TrackFX_SetEQBandEnabled.
--- @within ReaScript Wrapped Methods
--- @param band_type number TrackFX.BandTypeConstants.
--- @param band_idx number TrackFX.BandIndexConstants.
--- @param enable boolean
--- @return boolean
function TrackFX:set_eq_band_enabled(band_type, band_idx, enable)
  return r.TrackFX_SetEQBandEnabled(self.track.pointer, self.pointer, band_type, band_idx, enable)
end

--- Set Eq Param. Wraps TrackFX_SetEQParam.
-- Returns false if track/fxidx is not ReaEQ.
--- @within ReaScript Wrapped Methods
--- @param band_type number  TrackFX.BandTypeConstants.
--- @param band_idx number TrackFX.BandIndexConstants.
--- @param param_type number
--- @param val number
--- @param is_norm boolean
--- @return boolean
function TrackFX:set_eq_param(band_type, band_idx, param_type, val, is_norm)
  return r.TrackFX_SetEQParam(
    self.track.pointer,
    self.pointer,
    band_type,
    band_idx,
    param_type,
    val,
    is_norm
  )
end

--- Set Named Config Parm. Wraps TrackFX_SetNamedConfigParm.
-- sets plug-in specific named configuration value (returns true on success).
--- @within ReaScript Wrapped Methods
--- @param param_name string
--- @param value string
--- @return boolean
function TrackFX:set_named_config_param(param_name, value)
  return r.TrackFX_SetNamedConfigParm(self.track.pointer, self.pointer, param_name, value)
end

--- Set Offline. Wraps TrackFX_SetOffline.
--- @within ReaScript Wrapped Methods
--- @param offline boolean
--- @see TrackFX:get_offline
function TrackFX:set_offline(offline)
  return r.TrackFX_SetOffline(self.track.pointer, self.pointer, offline)
end

--- Set Open. Wraps TrackFX_SetOpen.
-- Open this FX UI.
--- @within ReaScript Wrapped Methods
--- @param open boolean
--- @see TrackFX:get_open
function TrackFX:set_open(open)
  return r.TrackFX_SetOpen(self.track.pointer, self.pointer, open)
end

--- Set Param. Wraps TrackFX_SetParam.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @param val number
--- @return boolean
function TrackFX:set_param(param, val)
  return r.TrackFX_SetParam(self.track.pointer, self.pointer, param, val)
end

--- Set Param Normalized. Wraps TrackFX_SetParamNormalized.
--- @within ReaScript Wrapped Methods
--- @param param number
--- @param value number
--- @return boolean
function TrackFX:set_param_normalized(param, value)
  return r.TrackFX_SetParamNormalized(self.track.pointer, self.pointer, param, value)
end

--- Set Pin Mappings. Wraps TrackFX_SetPinMappings.
-- sets the channel mapping bitmask for a particular pin. returns false if
-- unsupported (not all types of plug-ins support this capability). Add 0x1000000
-- to pin index in order to access the second 64 bits of mappings independent of
-- the first 64 bits.
--- @within ReaScript Wrapped Methods
--- @param is_output number
--- @param pin number
--- @param low32bits number
--- @param hi32bits number
--- @return boolean
function TrackFX:set_pin_mappings(is_output, pin, low32bits, hi32bits)
  return r.TrackFX_SetPinMappings(
    self.track.pointer,
    self.pointer,
    is_output,
    pin,
    low32bits,
    hi32bits
  )
end

--- Set Preset. Wraps TrackFX_SetPreset.
-- Activate a preset with the name shown in the REAPER dropdown. Full paths to
-- .vst preset files are also supported for VST3 plug-ins.
--- @within ReaScript Wrapped Methods
--- @param preset_name string
--- @return boolean
--- @see TrackFX:get_preset
function TrackFX:set_preset(preset_name)
  return r.TrackFX_SetPreset(self.track.pointer, self.pointer, preset_name)
end

--- Set Preset By Index. Wraps TrackFX_SetPresetByIndex.
-- Sets the preset idx, or the factory preset (idx==-2), or the default user preset
-- (idx==-1). Returns true on success.
--- @within ReaScript Wrapped Methods
--- @param preset_idx number The index of the preset
--- @return boolean
--- @see TrackFX:get_preset_index
function TrackFX:set_preset_by_index(preset_idx)
  return r.TrackFX_SetPresetByIndex(self.track.pointer, self.pointer, preset_idx)
end

TrackFX.ShowFlagsConstants = {
  HIDE_CHAIN = 0,
  SHOW_CHAIN = 1,
  HIDE_WINDOW = 2,
  SHOW_WINDOW = 3,
}

--- Show. Wraps TrackFX_Show.
--- @within ReaScript Wrapped Methods
--- @param show_flag number TrackFX.ShowFlagsConstants.
function TrackFX:show(show_flag)
  return r.TrackFX_Show(self.track.pointer, self.pointer, show_flag)
end

--- Get Chain. Wraps CF_GetTrackFXChain.
-- Return a handle to the given track FX chain window.
--- @within ReaScript Wrapped Methods
--- @return FxChain
function TrackFX:get_chain()
  return r.CF_GetTrackFXChain(self.track.pointer)
end

--- Get Chain Ex. Wraps CF_GetTrackFXChainEx.
-- Return a handle to the given track FX chain window. Set wantInputChain to get
-- the track's input/monitoring FX chain.
--- @within ReaScript Wrapped Methods
--- @param want_input_chain boolean
--- @return userdata FxChain
---- TODO move this to Project
function TrackFX:get_chain_ex(want_input_chain)
  local Project = require("project")
  local project = Project:new()
  local want_input_chain = want_input_chain or false
  return r.CF_GetTrackFXChainEx(project, self.track.pointer, want_input_chain)
end

--- Select. Wraps CF_SelectTrackFX.
-- Set which track effect is active in the track's FX chain. The FX chain window
-- does not have to be open.
--- @within ReaScript Wrapped Methods
--- @return boolean
function TrackFX:select()
  return r.CF_SelectTrackFX(self.track.pointer, self.pointer)
end

--------------------------------------------------------------------------------
-- Container Methods (Reaper 7+)
--------------------------------------------------------------------------------

--- Check if this FX is a container.
--- @within Container Methods
--- @return boolean True if this FX is a container
function TrackFX:is_container()
  local ok, count = r.TrackFX_GetNamedConfigParm(self.track.pointer, self.pointer, "container_count")
  return ok and count ~= nil
end

--- Get the number of FX in this container.
--- @within Container Methods
--- @return number Number of child FX (0 if not a container)
function TrackFX:get_container_child_count()
  -- Try with current pointer first
  local ok, count = r.TrackFX_GetNamedConfigParm(self.track.pointer, self.pointer, "container_count")
  if ok and count then
    return tonumber(count) or 0
  end

  -- If that failed and pointer looks stale, try refreshing
  if self.pointer >= 0x2000000 then
    self:refresh_pointer()
    ok, count = r.TrackFX_GetNamedConfigParm(self.track.pointer, self.pointer, "container_count")
    if ok and count then
      return tonumber(count) or 0
    end
  end

  return 0
end

--- Get child FX from this container.
--- @within Container Methods
--- @return table Array of TrackFX objects
function TrackFX:get_container_children()
  local count = self:get_container_child_count()
  local children = {}
  for i = 0, count - 1 do
    local ok, child_id = r.TrackFX_GetNamedConfigParm(
      self.track.pointer,
      self.pointer,
      "container_item." .. i
    )
    if ok and child_id then
      children[#children + 1] = TrackFX:new(self.track, tonumber(child_id))
    end
  end
  return children
end

--- Iterate over child FX in this container.
--- @within Container Methods
--- @return function Iterator yielding TrackFX objects
function TrackFX:iter_container_children()
  return helpers.iter(self:get_container_children())
end

--- Get the parent container of this FX.
--- @within Container Methods
--- @return TrackFX|nil Parent container, or nil if top-level
function TrackFX:get_parent_container()
  -- Try with current pointer first
  local ok, parent_id = r.TrackFX_GetNamedConfigParm(
    self.track.pointer,
    self.pointer,
    "parent_container"
  )
  if ok and parent_id and parent_id ~= "" then
    return TrackFX:new(self.track, tonumber(parent_id))
  end

  -- If that failed and pointer looks stale, try refreshing
  if not ok and self.pointer >= 0x2000000 then
    self:refresh_pointer()
    ok, parent_id = r.TrackFX_GetNamedConfigParm(
      self.track.pointer,
      self.pointer,
      "parent_container"
    )
    if ok and parent_id and parent_id ~= "" then
      return TrackFX:new(self.track, tonumber(parent_id))
    end
  end

  return nil
end

--- Get the container hierarchy depth of this FX.
--- @within Container Methods
--- @return number Depth (0 = top-level)
function TrackFX:get_container_depth()
  local depth = 0
  local current = self
  while true do
    local parent = current:get_parent_container()
    if not parent then
      break
    end
    depth = depth + 1
    current = parent
  end
  return depth
end

--- Get the internal channel count of this container.
--- @within Container Methods
--- @return number Channel count (default 2)
function TrackFX:get_container_channels()
  local ok, nch = r.TrackFX_GetNamedConfigParm(
    self.track.pointer,
    self.pointer,
    "container_nch"
  )
  return ok and tonumber(nch) or 2
end

--- Set the internal channel count of this container.
--- @within Container Methods
--- @param channels number Channel count (2, 4, 6, 8, etc.)
--- @return boolean Success
function TrackFX:set_container_channels(channels)
  return r.TrackFX_SetNamedConfigParm(
    self.track.pointer,
    self.pointer,
    "container_nch",
    tostring(channels)
  )
end

--- Get the input pin count of this container.
--- @within Container Methods
--- @return number Input pin count
function TrackFX:get_container_input_pins()
  local ok, pins = r.TrackFX_GetNamedConfigParm(
    self.track.pointer,
    self.pointer,
    "container_nch_in"
  )
  return ok and tonumber(pins) or 2
end

--- Set the input pin count of this container.
--- @within Container Methods
--- @param pins number Input pin count
--- @return boolean Success
function TrackFX:set_container_input_pins(pins)
  return r.TrackFX_SetNamedConfigParm(
    self.track.pointer,
    self.pointer,
    "container_nch_in",
    tostring(pins)
  )
end

--- Get the output pin count of this container.
--- @within Container Methods
--- @return number Output pin count
function TrackFX:get_container_output_pins()
  local ok, pins = r.TrackFX_GetNamedConfigParm(
    self.track.pointer,
    self.pointer,
    "container_nch_out"
  )
  return ok and tonumber(pins) or 2
end

--- Set the output pin count of this container.
--- @within Container Methods
--- @param pins number Output pin count
--- @return boolean Success
function TrackFX:set_container_output_pins(pins)
  return r.TrackFX_SetNamedConfigParm(
    self.track.pointer,
    self.pointer,
    "container_nch_out",
    tostring(pins)
  )
end

--- Refresh this FX's pointer by finding it again using its GUID.
--- This is useful when the pointer might have become stale due to container operations.
--- @within Container Methods
--- @return boolean True if pointer was refreshed successfully
function TrackFX:refresh_pointer()
  local guid = self:get_guid()
  if not guid then
    return false
  end

  -- Search track-level FX first
  local fx_count = r.TrackFX_GetCount(self.track.pointer)
  for i = 0, fx_count - 1 do
    local fx_guid = r.TrackFX_GetFXGUID(self.track.pointer, i)
    if fx_guid == guid then
      self.pointer = i
      return true
    end
  end

  -- Search nested FX by walking through containers
  local function search_container(container_idx)
    local ok, count_str = r.TrackFX_GetNamedConfigParm(self.track.pointer, container_idx, "container_count")
    if not ok or not count_str then
      return nil
    end

    local count = tonumber(count_str)
    for i = 0, count - 1 do
      local ok_child, child_idx_str = r.TrackFX_GetNamedConfigParm(
        self.track.pointer,
        container_idx,
        "container_item." .. i
      )
      if ok_child and child_idx_str then
        local child_idx = tonumber(child_idx_str)
        local child_guid = r.TrackFX_GetFXGUID(self.track.pointer, child_idx)
        if child_guid == guid then
          self.pointer = child_idx
          return true
        end
        -- Recurse into nested containers
        if search_container(child_idx) then
          return true
        end
      end
    end
    return nil
  end

  -- Search all top-level containers
  for i = 0, fx_count - 1 do
    if search_container(i) then
      return true
    end
  end

  return false
end

--- Move this FX into a container.
--- @within Container Methods
--- @param container TrackFX Container to move this FX into
--- @param position number|nil Position within container (nil = end)
--- @return boolean Success
function TrackFX:move_to_container(container, position)
  return container:add_fx_to_container(self, position)
end

--- Move this FX out of its container to the main FX chain.
--- @within Container Methods
--- @param position number|nil 0-based position in main chain (nil = end)
--- @return boolean Success
function TrackFX:move_out_of_container(position)
  local container = self:get_parent_container()
  if not container then
    return false -- Already on track
  end

  local destination = container:get_parent_container()
  local my_guid = self:get_guid()

  if destination then
    -- Container is nested, move to its parent
    return destination:add_fx_to_container(self, position)
  else
    -- Container is on track, move to track
    local fx_count = r.TrackFX_GetCount(self.track.pointer)
    local dest_idx = position or fx_count
    r.TrackFX_CopyToTrack(
      self.track.pointer,
      self.pointer,
      self.track.pointer,
      dest_idx,
      true -- move
    )
    -- Verify by checking if we no longer have a parent
    -- Need to re-find ourselves since pointer changed after move
    local new_self = self.track:find_fx_by_guid(my_guid)
    if new_self then
      local new_parent = new_self:get_parent_container()
      return new_parent == nil  -- Success if no parent (now at track level)
    end
    return false
  end
end

--- Calculate the REAPER FX index for addressing a position inside a container.
--- Handles both top-level and nested containers using REAPER's addressing scheme.
--- For nested containers, walks up the hierarchy to build the correct index.
--- Based on REAPER docs: "This can be extended to sub-containers using
--- TrackFX_GetNamedConfigParm with container_count and similar logic"
--- @within Container Methods
--- @param container TrackFX The container FX object
--- @param position number 0-based position within container
--- @return number The encoded destination index, or nil if invalid
local function calc_container_dest_idx(container, position)
  if not container:is_container() then
    return nil
  end

  local parent = container:get_parent_container()
  local one_based_pos = position + 1

  if not parent then
    -- Top-level container: use track FX count
    -- Formula: 0x2000000 + (1-based position) * (track_fx_count + 1) + (1-based container index)
    local fx_count = r.TrackFX_GetCount(container.track.pointer)
    local one_based_container = container.pointer + 1
    return 0x2000000 + one_based_pos * (fx_count + 1) + one_based_container
  else
    -- Nested container: need to walk up the hierarchy
    -- Build path from container to track level
    local path = {}
    local current = container
    while current do
      local curr_parent = current:get_parent_container()
      table.insert(path, 1, {
        container = current,
        parent = curr_parent
      })
      current = curr_parent
    end

    -- Start with base container address
    local idx = 0x2000000

    -- Walk down the path, accumulating index at each level
    for i, entry in ipairs(path) do
      local cont = entry.container
      local cont_parent = entry.parent

      if cont_parent then
        -- Find position of this container in its parent
        local pos_in_parent = 0
        for child in cont_parent:iter_container_children() do
          if child:get_guid() == cont:get_guid() then
            break
          end
          pos_in_parent = pos_in_parent + 1
        end

        -- Get parent's child count
        local parent_child_count = cont_parent:get_container_child_count()

        -- Add offset for this level
        -- Formula: (1-based position in parent) * (parent's child count + 1)
        idx = idx + (pos_in_parent + 1) * (parent_child_count + 1)
      else
        -- Top-level container - add base offset
        local fx_count = r.TrackFX_GetCount(cont.track.pointer)
        idx = idx + (cont.pointer + 1) * (fx_count + 1)
      end
    end

    -- Add final position within target container
    local target_child_count = container:get_container_child_count()
    idx = idx + one_based_pos * (target_child_count + 1)

    return idx
  end
end

--- Move an FX into this container.
--- @within Container Methods
--- @param fx TrackFX FX to move into this container
--- @param position number|nil 0-based position within container (nil = end)
--- @return boolean Success
function TrackFX:add_fx_to_container(fx, position)
  -- If this container's pointer looks like a stale encoded pointer,
  -- try to refresh it before proceeding
  if self.pointer >= 0x2000000 then
    self:refresh_pointer()
  end

  if not self:is_container() then
    return false
  end

  local child_count = self:get_container_child_count()
  local dest_pos = position or child_count

  -- Check if container is nested
  local parent = self:get_parent_container()

  if not parent then
    -- Container is at track level - use direct addressing
    local dest_idx = calc_container_dest_idx(self, dest_pos)
    if not dest_idx then
      return false
    end

    -- If moving FX from before container on same track, container will shift down
    local container_will_shift = fx.track.pointer == self.track.pointer and fx.pointer < self.pointer

    r.TrackFX_CopyToTrack(
      fx.track.pointer,
      fx.pointer,
      self.track.pointer,
      dest_idx,
      true -- move
    )

    -- Adjust our pointer if container shifted
    if container_will_shift then
      self.pointer = self.pointer - 1
    end

    -- Verify the move succeeded
    local new_child_count = self:get_container_child_count()
    return new_child_count > child_count
  else
    -- Container is nested - use "pop out and put back" method
    -- This is necessary because REAPER's encoded index scheme doesn't work for nested containers

    local container_guid = self:get_guid()
    local fx_guid = fx:get_guid()
    local parent_guid = parent:get_guid()

    -- Find container's position in parent
    local container_pos = 0
    for child in parent:iter_container_children() do
      if child:get_guid() == container_guid then
        break
      end
      container_pos = container_pos + 1
    end

    -- Move container to track level
    self:move_out_of_container()

    -- Re-find everything (pointers changed)
    local container_at_track = self.track:find_fx_by_guid(container_guid)
    local fx_at_track = self.track:find_fx_by_guid(fx_guid)
    local parent_at_track = self.track:find_fx_by_guid(parent_guid)

    if not container_at_track or not fx_at_track or not parent_at_track then
      return false
    end

    -- Add FX to container (now at track level)
    local add_success = container_at_track:add_fx_to_container(fx_at_track, dest_pos)

    if not add_success then
      return false
    end

    -- Move container back into parent
    container_at_track = self.track:find_fx_by_guid(container_guid)
    parent_at_track = self.track:find_fx_by_guid(parent_guid)

    if not container_at_track or not parent_at_track then
      return false
    end

    local restore_success = parent_at_track:add_fx_to_container(container_at_track, container_pos)

    return restore_success
  end
end

--- Copy an FX into this container.
--- @within Container Methods
--- @param fx TrackFX FX to copy into this container
--- @param position number|nil Position within container (nil = end)
--- @return boolean Success
function TrackFX:copy_fx_to_container(fx, position)
  if not self:is_container() then
    return false
  end
  local child_count = self:get_container_child_count()
  local dest_pos = position or child_count
  local dest_idx = self.pointer + 0x2000000 + dest_pos
  return r.TrackFX_CopyToTrack(
    fx.track.pointer,
    fx.pointer,
    self.track.pointer,
    dest_idx,
    false -- copy
  )
end

--- Create a parameter modulation link from a source FX to this FX's parameter.
--- Automatically handles local container indices when both FX are in the same container.
--- @within ReaWrap Custom Methods
--- @param source_fx table The source FX (modulator) TrackFX object
--- @param source_param_idx number The parameter index of the source FX output
--- @param target_param_idx number The parameter index on this FX to modulate
--- @param scale number|nil Modulation scale (0.0-1.0), defaults to 1.0 (100%)
--- @return boolean Success
function TrackFX:create_param_link(source_fx, source_param_idx, target_param_idx, scale)
  if not source_fx or not source_fx.track or not self.track then
    return false
  end

  scale = scale or 1.0

  -- Determine if we need local or global FX index
  local source_fx_idx = source_fx.pointer
  local my_parent = self:get_parent_container()

  -- If both FX share the same parent container, use LOCAL index
  if my_parent then
    local source_parent = source_fx:get_parent_container()

    -- Check if they share the same parent (compare GUIDs)
    if source_parent and source_parent:get_guid() == my_parent:get_guid() then
      -- Find source FX's local position within the container
      local children = my_parent:get_container_children()
      local source_guid = source_fx:get_guid()

      for i, child in ipairs(children) do
        if child:get_guid() == source_guid then
          source_fx_idx = i - 1  -- Convert to 0-based local index
          break
        end
      end
    end
  end

  -- Create the parameter link using REAPER's plink API
  local plink_prefix = string.format("param.%d.plink.", target_param_idx)

  local ok1 = self:set_named_config_param(plink_prefix .. "active", "1")
  local ok2 = self:set_named_config_param(plink_prefix .. "effect", tostring(source_fx_idx))
  local ok3 = self:set_named_config_param(plink_prefix .. "param", tostring(source_param_idx))
  local ok4 = self:set_named_config_param(plink_prefix .. "scale", tostring(scale))

  return ok1 and ok2 and ok3 and ok4
end

--- Remove a parameter modulation link from this FX's parameter.
--- @within ReaWrap Custom Methods
--- @param target_param_idx number The parameter index to remove modulation from
--- @return boolean Success
function TrackFX:remove_param_link(target_param_idx)
  local plink_prefix = string.format("param.%d.plink.", target_param_idx)
  return self:set_named_config_param(plink_prefix .. "active", "0")
end

--- Get parameter modulation link information.
--- @within ReaWrap Custom Methods
--- @param target_param_idx number The parameter index to query
--- @return table|nil Link info table with fields: active, effect, param, scale, offset, or nil if no link
function TrackFX:get_param_link_info(target_param_idx)
  local plink_prefix = string.format("param.%d.plink.", target_param_idx)

  -- get_named_config_param returns a single value (buf or nil), not retval + value
  local active = self:get_named_config_param(plink_prefix .. "active")

  if not active or active ~= "1" then
    return nil  -- No active link
  end

  local effect = self:get_named_config_param(plink_prefix .. "effect")
  local param = self:get_named_config_param(plink_prefix .. "param")
  local scale = self:get_named_config_param(plink_prefix .. "scale")
  local offset = self:get_named_config_param(plink_prefix .. "offset")

  return {
    active = true,
    effect = tonumber(effect),
    param = tonumber(param),
    scale = tonumber(scale) or 1.0,
    offset = tonumber(offset) or 0
  }
end

return TrackFX
