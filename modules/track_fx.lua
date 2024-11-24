-- @description Provide implementation for TrackFX functions.
-- @author NomadMonad
-- @license MIT

local r = reaper
local helpers = require("helpers")

local TrackFX = {}

--- Create new TrackFX instance.
-- @param track Track. The Track object
-- @param fx_idx . The index of the FX
-- @return TrackFX table.
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

-- @section ReaWrap Custom Methods

--- Log messages with the TrackFX logger.
-- @param ... (varargs) Messages to log.
function TrackFX:log(...)
	local logger = helpers.log_func("TrackFX")
	logger(...)
	return nil
end

--- String representation of the TrackFX instance.
-- @return string
function TrackFX:__tostring()
	return string.format("<TrackFX name=%s>", self:get_name())
end

--- Get param values from TrackFX.
-- @return table array<Envelope>
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
-- @return function iterator
function TrackFX:iter_param_values()
	return helpers.iter(self:get_param_values())
end

--- Get param names from TrackFX.
-- @return table array<Envelope>
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
-- @return function iterator
function TrackFX:iter_param_names()
	return helpers.iter(self:get_param_names())
end

-- @section ReaScript API Methods

--- End Param Edit. Wraps TrackFX_EndParamEdit.
-- @param param number
-- @return boolean
function TrackFX:end_param_edit(param)
	return r.TrackFX_EndParamEdit(self.track.pointer, self.pointer, param)
end

--- Format Param Value. Wraps TrackFX_FormatParamValue.
-- Note: only works with FX that support Cockos VST extensions.
-- @param param number
-- @param val number
-- @return buf string
function TrackFX:format_param_value(param, val)
	local ret_val, buf = r.TrackFX_FormatParamValue(self.track.pointer, self.pointer, param, val)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Format Param Value Normalized. Wraps TrackFX_FormatParamValueNormalized.
-- Note: only works with FX that support Cockos VST extensions.
-- @param param number
-- @param value number
-- @param buf string
-- @return buf string
function TrackFX:format_param_value_normalized(param, value, buf)
	local ret_val, buf = r.TrackFX_FormatParamValueNormalized(self.track.pointer, self.pointer, param, value, buf)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Chain Visible. Wraps TrackFX_GetChainVisible.
-- returns index of effect visible in chain, or -1 for chain hidden, or -2 for
-- chain visible but no effect selected
-- @return number
function TrackFX:get_chain_visible()
	return r.TrackFX_GetChainVisible(self.track.pointer)
end

--- Get Enabled. Wraps TrackFX_GetEnabled.
-- @return boolean
function TrackFX:get_enabled()
	return r.TrackFX_GetEnabled(self.track.pointer, self.pointer)
end

--- Get Eq. Wraps TrackFX_GetEQ.
-- Get the index of ReaEQ in the track FX chain. If ReaEQ is not in the chain and
-- instantiate is true, it will be inserted. See TrackFX_GetInstrument,
-- TrackFX_GetByName.
-- @param instantiate boolean Optional.
-- @return number
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
-- @param band_type number. TrackFX.BandTypeConstants.
-- @param band_idx number. TrackFX.BandIndexConstants.
-- @return boolean
function TrackFX:get_eq_band_enabled(band_type, band_idx)
	return r.TrackFX_GetEQBandEnabled(self.track.pointer, self.pointer, band_type, band_idx)
end

--- Get Eq Param. Wraps TrackFX_GetEQParam.
-- Returns false if track/fx_idx is not ReaEQ.
-- bandpass.
-- @param param_idx number
-- @return band_type number. See TrackFX.BandTypeConstants.
-- @return band_idx number. See TrackFX.BandIndexConstants.
-- @return param_type number
-- @return norm_val number
function TrackFX:get_eq_param(param_idx)
	local ret_val, band_type, band_idx, param_type, norm_val =
		r.TrackFX_GetEQParam(self.track.pointer, fx_idx, param_idx)
	if ret_val then
		return band_type, band_idx, param_type, norm_val
	else
		return nil
	end
end

--- Get Floating Window. Wraps TrackFX_GetFloatingWindow.
-- returns HWND of floating window for effect index, if any.
-- and container_item.X.
-- @return HWND
function TrackFX:get_floating_window()
	return r.TrackFX_GetFloatingWindow(self.track.pointer, self.pointer)
end

--- Get Formatted Param Value. Wraps TrackFX_GetFormattedParamValue.
-- @param param number
-- @return buf string
function TrackFX:get_formatted_param_value(param)
	local ret_val, buf = r.TrackFX_GetFormattedParamValue(self.track.pointer, self.pointer, param)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Guid. Wraps TrackFX_GetFXGUID.
-- @return guid string
function TrackFX:get_guid()
	return r.TrackFX_GetFXGUID(self.track.pointer, self.pointer)
end

--- Get Name. Wraps TrackFX_GetFXName.
-- @return buf string
function TrackFX:get_name()
	local ret_val, buf = r.TrackFX_GetFXName(self.track.pointer, self.pointer)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Instrument. Wraps TrackFX_GetInstrument.
-- Get the index of the first track FX insert that is a virtual instrument, or -1
-- if none. See TrackFX_GetEQ, TrackFX_GetByName.
-- @return number
function TrackFX:get_instrument()
	return r.TrackFX_GetInstrument(self.track.pointer)
end

--- Get Io Size. Wraps TrackFX_GetIOSize.
-- Gets the number of input/output pins for FX if available, returns plug-in type
-- or -1 on error.
-- @return input_pins number
-- @return output_pins number
function TrackFX:get_io_size()
	local ret_val, input_pins, output_pins = r.TrackFX_GetIOSize(self.track.pointer, self.pointer)
	if ret_val then
		return input_pins, output_pins
	else
		return nil
	end
end

--- Get Named Config Parm. Wraps TrackFX_GetNamedConfigParm.
-- gets plug-in specific named configuration value (returns true on success).
-- @param param_name string
-- @return buf string
function TrackFX:get_named_config_param(param_name)
	local ret_val, buf = r.TrackFX_GetNamedConfigParm(self.track.pointer, self.pointer, param_name)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Num Params. Wraps TrackFX_GetNumParams.
-- @return number
function TrackFX:get_num_params()
	return r.TrackFX_GetNumParams(self.track.pointer, self.pointer)
end

--- Get Offline. Wraps TrackFX_GetOffline.
-- @return boolean
function TrackFX:get_offline()
	return r.TrackFX_GetOffline(self.track.pointer, self.pointer)
end

--- Get Open. Wraps TrackFX_GetOpen.
-- @return boolean
function TrackFX:get_open()
	return r.TrackFX_GetOpen(self.track.pointer, self.pointer)
end

--- Get Param. Wraps TrackFX_GetParam.
-- @param param number
-- @return min_val number
-- @return max_val number
function TrackFX:get_param(param)
	local ret_val, min_val, max_val = r.TrackFX_GetParam(self.track.pointer, self.pointer, param)
	if ret_val then
		return min_val, max_val
	else
		return nil
	end
end

--- Get Parameter Step Sizes. Wraps TrackFX_GetParameterStepSizes.
-- @param param number
-- @return step number
-- @return small_step number
-- @return large_step number
-- @return is_toggle boolean
function TrackFX:get_parameter_step_sizes(param)
	local ret_val, step, small_step, large_step, is_toggle =
		r.TrackFX_GetParameterStepSizes(self.track.pointer, self.pointer, param)
	if ret_val then
		return step, small_step, large_step, is_toggle
	else
		return nil
	end
end

--- Get Param Ex. Wraps TrackFX_GetParamEx.
-- @param param number
-- @return min_val number
-- @return max_val number
-- @return mid_val number
function TrackFX:get_param_ex(param)
	local ret_val, min_val, max_val, mid_val = r.TrackFX_GetParamEx(self.track.pointer, self.pointer, param)
	if ret_val then
		return min_val, max_val, mid_val
	else
		return nil
	end
end

--- Get Param From Ident. Wraps TrackFX_GetParamFromIdent.
-- gets the parameter index from an identifying string (:wet, :bypass, :delta, or a
-- string returned from GetParamIdent), or -1 if unknown.
-- @param ident_str string
-- @return number
function TrackFX:get_param_from_ident(ident_str)
	return r.TrackFX_GetParamFromIdent(self.track.pointer, self.pointer, ident_str)
end

--- Get Param Ident. Wraps TrackFX_GetParamIdent.
-- @param param number
-- @return buf string
function TrackFX:get_param_ident(param)
	local ret_val, buf = r.TrackFX_GetParamIdent(self.track.pointer, self.pointer, param)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Param Name. Wraps TrackFX_GetParamName.
-- @param param number
-- @return buf string
function TrackFX:get_param_name(param)
	local ret_val, buf = r.TrackFX_GetParamName(self.track.pointer, self.pointer, param)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Param Normalized. Wraps TrackFX_GetParamNormalized.
-- @param param number
-- @return number
function TrackFX:get_param_normalized(param)
	return r.TrackFX_GetParamNormalized(self.track.pointer, self.pointer, param)
end

--- Get Pin Mappings. Wraps TrackFX_GetPinMappings.
-- gets the effective channel mapping bitmask for a particular pin. high32Out will
-- be set to the high 32 bits. Add 0x1000000 to pin index in order to access the
-- second 64 bits of mappings independent of the first 64 bits. FX indices for
-- tracks can have 0x1000000 added to them in order to reference record input FX
-- (normal tracks) or hardware output FX (master track).
-- @param is_output number
-- @param pin number
-- @return high32 number
function TrackFX:get_pin_mappings(is_output, pin)
	local ret_val, high32 = r.TrackFX_GetPinMappings(self.tr.pointer, self.pointer, is_output, pin)
	if ret_val then
		return high32
	else
		return nil
	end
end

--- Get Preset. Wraps TrackFX_GetPreset.
-- Get the name of the preset currently showing in the REAPER dropdown, or the full
-- path to a factory preset file for VST3 plug-ins (.vstpreset). See
-- TrackFX_SetPreset.
function TrackFX:get_preset()
	local ret_val, preset_name = r.TrackFX_GetPreset(self.track.pointer, self.pointer)
	if ret_val then
		return preset_name
	else
		return nil
	end
end

--- Get Preset Index. Wraps TrackFX_GetPresetIndex.
-- @return number_of_presets number
function TrackFX:get_preset_index()
	local ret_val, number_of_presets = r.TrackFX_GetPresetIndex(self.track.pointer, self.pointer)
	if ret_val then
		return number_of_presets
	else
		return nil
	end
end

--- Get Rec Chain Visible. Wraps TrackFX_GetRecChainVisible.
-- returns index of effect visible in record input chain, or -1 for chain hidden,
-- or -2 for chain visible but no effect selected
-- @return number
function TrackFX:get_rec_chain_visible()
	return r.TrackFX_GetRecChainVisible(self.track.pointer)
end

--- Get Rec Count. Wraps TrackFX_GetRecCount.
-- returns count of record input FX. To access record input FX, use a FX indices
-- [0x1000000..0x1000000+n). On the master track, this accesses monitoring FX
-- rather than record input FX.
-- @return number
function TrackFX:get_rec_count()
	return r.TrackFX_GetRecCount(self.track.pointer)
end

--- Get User Preset Filename. Wraps TrackFX_GetUserPresetFilename.
-- @return fn string
function TrackFX:get_user_preset_filename()
	return r.TrackFX_GetUserPresetFilename(self.track.pointer, self.pointer)
end

--- Navigate Presets. Wraps TrackFX_NavigatePresets.
-- preset_move==1 activates the next preset, preset_move==-1 activates the previous
-- preset, etc.
-- @param preset_move number
-- @return boolean
function TrackFX:navigate_presets(preset_move)
	return r.TrackFX_NavigatePresets(self.track.pointer, self.pointer, preset_move)
end

--- Set Enabled. Wraps TrackFX_SetEnabled.
-- See TrackFX_GetEnabled FX indices for tracks can have 0x1000000 added to them in
-- order to reference record input FX (normal tracks) or hardware output FX (master
-- track).
-- @param enabled boolean
function TrackFX:set_enabled(enabled)
	return r.TrackFX_SetEnabled(self.track.pointer, self.pointer, enabled)
end

--- Set Eq Band Enabled. Wraps TrackFX_SetEQBandEnabled.
-- @param band_type number. TrackFX.BandTypeConstants.
-- @param band_idx number. TrackFX.BandIndexConstants.
-- @param enable boolean
-- @return boolean
function TrackFX:set_eq_band_enabled(band_type, band_idx, enable)
	return r.TrackFX_SetEQBandEnabled(self.track.pointer, self.pointer, band_type, band_idx, enable)
end

--- Set Eq Param. Wraps TrackFX_SetEQParam.
-- Returns false if track/fxidx is not ReaEQ.
-- @param band_type number. TrackFX.BandTypeConstants.
-- @param band_idx number. TrackFX.BandIndexConstants.
-- @param param_type number
-- @param val number
-- @param is_norm boolean
-- @return boolean
function TrackFX:set_eq_param(band_type, band_idx, param_type, val, is_norm)
	return r.TrackFX_SetEQParam(self.track.pointer, self.pointer, band_type, band_idx, param_type, val, is_norm)
end

--- Set Named Config Parm. Wraps TrackFX_SetNamedConfigParm.
-- sets plug-in specific named configuration value (returns true on success).
-- @param param_name string
-- @param value string
-- @return boolean
function TrackFX:set_named_config_param(param_name, value)
	return r.TrackFX_SetNamedConfigParm(self.track.pointer, self.pointer, param_name, value)
end

--- Set Offline. Wraps TrackFX_SetOffline.
-- See TrackFX_GetOffline.
-- @param offline boolean
function TrackFX:set_offline(offline)
	return r.TrackFX_SetOffline(self.track.pointer, self.pointer, offline)
end

--- Set Open. Wraps TrackFX_SetOpen.
-- Open this FX UI. See TrackFX_GetOpen.
-- @param open boolean
function TrackFX:set_open(open)
	return r.TrackFX_SetOpen(self.track.pointer, self.pointer, open)
end

--- Set Param. Wraps TrackFX_SetParam.
-- @param param number
-- @param val number
-- @return boolean
function TrackFX:set_param(param, val)
	return r.TrackFX_SetParam(self.track.pointer, self.pointer, param, val)
end

--- Set Param Normalized. Wraps TrackFX_SetParamNormalized.
-- @param param number
-- @param value number
-- @return boolean
function TrackFX:set_param_normalized(param, value)
	return r.TrackFX_SetParamNormalized(self.track.pointer, self.pointer, param, value)
end

--- Set Pin Mappings. Wraps TrackFX_SetPinMappings.
-- sets the channel mapping bitmask for a particular pin. returns false if
-- unsupported (not all types of plug-ins support this capability). Add 0x1000000
-- to pin index in order to access the second 64 bits of mappings independent of
-- the first 64 bits.
-- @param is_output number
-- @param pin number
-- @param low32bits number
-- @param hi32bits number
-- @return boolean
function TrackFX:set_pin_mappings(is_output, pin, low32bits, hi32bits)
	return r.TrackFX_SetPinMappings(self.track.pointer, self.pointer, is_output, pin, low32bits, hi32bits)
end

--- Set Preset. Wraps TrackFX_SetPreset.
-- Activate a preset with the name shown in the REAPER dropdown. Full paths to
-- .vst preset files are also supported for VST3 plug-ins. See TrackFX_GetPreset.
-- @param preset_name string
-- @return boolean
function TrackFX:set_preset(preset_name)
	return r.TrackFX_SetPreset(self.track.pointer, self.pointer, preset_name)
end

--- Set Preset By Index. Wraps TrackFX_SetPresetByIndex.
-- Sets the preset idx, or the factory preset (idx==-2), or the default user preset
-- (idx==-1). Returns true on success. See TrackFX_GetPresetIndex.
-- @param preset_idx number. The index of the preset
-- @return boolean
function TrackFX:set_preset_by_index(preset_idx)
	return r.TrackFX_SetPresetByIndex(self.track.pointer, self.pointer, idx)
end

TrackFX.ShowFlagsConstants = {
	HIDE_CHAIN = 0,
	SHOW_CHAIN = 1,
	HIDE_WINDOW = 2,
	SHOW_WINDOW = 3,
}

--- Show. Wraps TrackFX_Show.
-- @param show_flag number. TrackFX.ShowFlagsConstants.
function TrackFX:show(show_flag)
	return r.TrackFX_Show(self.track.pointer, self.pointer, show_flag)
end

--- Get Chain. Wraps CF_GetTrackFXChain.
-- Return a handle to the given track FX chain window.
-- @return FxChain
function TrackFX:get_chain()
	return r.CF_GetTrackFXChain(self.track.pointer)
end

--- Get Chain Ex. Wraps CF_GetTrackFXChainEx.
-- Return a handle to the given track FX chain window. Set wantInputChain to get
-- the track's input/monitoring FX chain.
-- @param want_input_chain boolean
-- @return FxChain
function TrackFX:get_chain_ex(want_input_chain)
    local Project = require("project")
    local project = Project:new()
    local want_input_chain = want_input_chain or false
	return r.CF_GetTrackFXChainEx(project, self.track.pointer, want_input_chain)
end

--- Select. Wraps CF_SelectTrackFX.
-- Set which track effect is active in the track's FX chain. The FX chain window
-- does not have to be open.
-- @return boolean
function TrackFX:select()
	return r.CF_SelectTrackFX(self.track.pointer, self.pointer)
end

return TrackFX
