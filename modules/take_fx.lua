--- Provide implementation for TakeFX functions.
-- @author NomadMonad
-- @license MIT
-- @release 0.0.1

local r = reaper
local helpers = require("helpers")

-- @class TakeFX
-- @field take Take. The Take object.
-- @field pointer number. The index of the FX.
-- @field pointer_type string. The type of the pointer.
local TakeFX = {}

--- Create new TakeFX instance.
-- @param take Take. The Take object.
-- @param fx_idx number. The index of the FX.
-- @return TakeFX table.
function TakeFX:new(take, fx_idx)
	local obj = {
		pointer_type = "TakeFX*",
		take = take,
		pointer = fx_idx,
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

-- @section ReaWrap Custom Methods

--- Log messages with the TakeFX logger.
-- @param ... (varargs) Messages to log.
function TakeFX:log(...)
	local logger = helpers.log_func("TakeFX")
	logger(...)
	return nil
end

--- String representation of the TakeFX instance.
-- @return string
function TakeFX:_tostring()
	return string.format("<TakeFX name=%s>", self:get_name())
end

-- @section ReaScript API Methods

--- Add By Name. Wraps TakeFX_AddByName.
-- @param fx_name string
-- @param instantiate number
-- @return number
function TakeFX:add_by_name(fx_name, instantiate)
	return r.TakeFX_AddByName(self.take.pointer, fx_name, instantiate)
end

--- Copy To Take. Wraps TakeFX_CopyToTake.
-- @param dest_take Take table
-- @param dest_fx number
-- @param is_move boolean
function TakeFX:copy_to_take(dest_take, dest_fx, is_move)
	return r.TakeFX_CopyToTake(self.src_take.pointer, src_fx, dest_take.pointer, dest_fx, is_move)
end

--- Copy To Track. Wraps TakeFX_CopyToTrack.
-- @param dest_track Track table
-- @param dest_fx number
-- @param is_move boolean
function TakeFX:copy_to_track(dest_track, dest_fx, is_move)
	return r.TakeFX_CopyToTrack(self.src_take.pointer, src_fx, dest_track.pointer, dest_fx, is_move)
end

--- End Param Edit. Wraps TakeFX_EndParamEdit.
-- @param param number
-- @return boolean
function TakeFX:end_param_edit(param)
	return r.TakeFX_EndParamEdit(self.take.pointer, self.pointer, param)
end

--- Format Param Value. Wraps TakeFX_FormatParamValue.
-- Note: only works with FX that support Cockos VST extensions.
-- @param param number
-- @param val number
-- @return buf string
function TakeFX:format_param_value(param, val)
	local ret_val, buf = r.TakeFX_FormatParamValue(self.take.pointer, self.pointer, param, val)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Format Param Value Normalized. Wraps TakeFX_FormatParamValueNormalized.
-- @param param number
-- @param value number
-- @param buf string
-- @return buf string
function TakeFX:format_param_value_normalized(param, value, buf)
	local ret_val, buf = r.TakeFX_FormatParamValueNormalized(self.take.pointer, self.pointer, param, value, buf)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Chain Visible. Wraps TakeFX_GetChainVisible.
-- returns index of effect visible in chain, or -1 for chain hidden, or -2 for
-- chain visible but no effect selected
-- @return number
function TakeFX:get_chain_visible()
	return r.TakeFX_GetChainVisible(self.take.pointer)
end

--- Get Enabled. Wraps TakeFX_GetEnabled.
-- @return boolean
function TakeFX:get_enabled()
	return r.TakeFX_GetEnabled(self.take.pointer, self.pointer)
end

--- Get Envelope. Wraps TakeFX_GetEnvelope.
-- @param param_idx number
-- @param create boolean Optional. Default false.
-- @return Envelope table
function TakeFX:get_envelope(param_idx, create)
	local create = create or false
	local Envelope = require("envelope")
	local result = r.TakeFX_GetEnvelope(self.take.pointer, self.pointer, param_idx, create)
	return Envelope:new(result)
end

--- Get Floating Window. Wraps TakeFX_GetFloatingWindow.
-- @return HWND
function TakeFX:get_floating_window()
	return r.TakeFX_GetFloatingWindow(self.take.pointer, index)
end

--- Get Formatted Param Value. Wraps TakeFX_GetFormattedParamValue.
-- @param param number
-- @return buf string
function TakeFX:get_formatted_param_value(param)
	local ret_val, buf = r.TakeFX_GetFormattedParamValue(self.take.pointer, self.pointer, param)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Guid. Wraps TakeFX_GetFXGUID.
-- @return guid string
function TakeFX:get_guid()
	return r.TakeFX_GetFXGUID(self.take.pointer, self.pointer)
end

--- Get Name. Wraps TakeFX_GetFXName.
-- @return buf string
function TakeFX:get_name()
	local ret_val, buf = r.TakeFX_GetFXName(self.take.pointer, self.pointer)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Io Size. Wraps TakeFX_GetIOSize.
-- @return input_pins number
-- @return output_pins number
function TakeFX:get_io_size()
	local ret_val, input_pins, output_pins = r.TakeFX_GetIOSize(self.take.pointer, self.pointer)
	if ret_val then
		return input_pins, output_pins
	else
		return nil
	end
end

--- Get Named Config Parm. Wraps TakeFX_GetNamedConfigParm.
-- @param param_name string
-- @return buf string
function TakeFX:get_named_config_parm(param_name)
	local ret_val, buf = r.TakeFX_GetNamedConfigParm(self.take.pointer, self.pointer, param_name)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Num Params. Wraps TakeFX_GetNumParams.
-- @return number
function TakeFX:get_num_params()
	return r.TakeFX_GetNumParams(self.take.pointer, self.pointer)
end

--- Get Offline. Wraps TakeFX_GetOffline.
-- @return boolean
function TakeFX:get_offline()
	return r.TakeFX_GetOffline(self.take.pointer, self.pointer)
end

--- Get Open. Wraps TakeFX_GetOpen.
-- @return boolean
function TakeFX:get_open()
	return r.TakeFX_GetOpen(self.take.pointer, self.pointer)
end

--- Get Param. Wraps TakeFX_GetParam.
-- @param param number
-- @return min_val number
-- @return max_val number
function TakeFX:get_param(param)
	local ret_val, min_val, max_val = r.TakeFX_GetParam(self.take.pointer, self.pointer, param)
	if ret_val then
		return min_val, max_val
	else
		return nil
	end
end

--- Get Parameter Step Sizes. Wraps TakeFX_GetParameterStepSizes.
-- @param param number
-- @return step number
-- @return small_step number
-- @return large_step number
-- @return is_toggle boolean
function TakeFX:get_parameter_step_sizes(param)
	local ret_val, step, small_step, large_step, is_toggle =
		r.TakeFX_GetParameterStepSizes(self.take.pointer, self.pointer, param)
	if ret_val then
		return step, small_step, large_step, is_toggle
	else
		return nil
	end
end

--- Get Param Ex. Wraps TakeFX_GetParamEx.
-- @param param number
-- @return min_val number
-- @return max_val number
-- @return mid_val number
function TakeFX:get_param_ex(param)
	local ret_val, min_val, max_val, mid_val = r.TakeFX_GetParamEx(self.take.pointer, self.pointer, param)
	if ret_val then
		return min_val, max_val, mid_val
	else
		return nil
	end
end

--- Get Param From Ident. Wraps TakeFX_GetParamFromIdent.
-- @param ident_str string
-- @return number
function TakeFX:get_param_from_ident(ident_str)
	return r.TakeFX_GetParamFromIdent(self.take.pointer, self.pointer, ident_str)
end

--- Get Param Ident. Wraps TakeFX_GetParamIdent.
-- @param param number
-- @return buf string
function TakeFX:get_param_ident(param)
	local ret_val, buf = r.TakeFX_GetParamIdent(self.take.pointer, self.pointer, param)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Param Name. Wraps TakeFX_GetParamName.
-- @param param number
-- @return buf string
function TakeFX:get_param_name(param)
	local ret_val, buf = r.TakeFX_GetParamName(self.take.pointer, self.pointer, param)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Param Normalized. Wraps TakeFX_GetParamNormalized.
-- @param param number
-- @return number
function TakeFX:get_param_normalized(param)
	return r.TakeFX_GetParamNormalized(self.take.pointer, self.pointer, param)
end

--- Get Pin Mappings. Wraps TakeFX_GetPinMappings.
-- @param is_output number
-- @param pin number
-- @return high32 number
function TakeFX:get_pin_mappings(is_output, pin)
	local ret_val, high32 = r.TakeFX_GetPinMappings(self.take.pointer, self.pointer, is_output, pin)
	if ret_val then
		return high32
	else
		return nil
	end
end

--- Get Preset. Wraps TakeFX_GetPreset.
-- @return preset_name string
function TakeFX:get_preset()
	local ret_val, preset_name = r.TakeFX_GetPreset(self.take.pointer, self.pointer)
	if ret_val then
		return preset_name
	else
		return nil
	end
end

--- Get Preset Index. Wraps TakeFX_GetPresetIndex.
-- @return number_of_presets number
function TakeFX:get_preset_index()
	local ret_val, number_of_presets = r.TakeFX_GetPresetIndex(self.take.pointer, self.pointer)
	if ret_val then
		return number_of_presets
	else
		return nil
	end
end

--- Get User Preset Filename. Wraps TakeFX_GetUserPresetFilename.
-- @return fn string
function TakeFX:get_user_preset_filename()
	return r.TakeFX_GetUserPresetFilename(self.take.pointer, self.pointer)
end

--- Navigate Presets. Wraps TakeFX_NavigatePresets.
-- preset_move==1 activates the next preset, preset_move==-1 activates the previous
-- preset, etc.
-- @param preset_move number
-- @return boolean
function TakeFX:navigate_presets(preset_move)
	return r.TakeFX_NavigatePresets(self.take.pointer, self.pointer, preset_move)
end

--- Set Enabled. Wraps TakeFX_SetEnabled.
-- @param enabled boolean
function TakeFX:set_enabled(enabled)
	return r.TakeFX_SetEnabled(self.take.pointer, self.pointer, enabled)
end

--- Set Named Config Parm. Wraps TakeFX_SetNamedConfigParm.
-- @param param_name string
-- @param value string
-- @return boolean
function TakeFX:set_named_config_parm(param_name, value)
	return r.TakeFX_SetNamedConfigParm(self.take.pointer, self.pointer, param_name, value)
end

--- Set Offline. Wraps TakeFX_SetOffline.
-- @param offline boolean
function TakeFX:set_offline(offline)
	return r.TakeFX_SetOffline(self.take.pointer, self.pointer, offline)
end

--- Set Open. Wraps TakeFX_SetOpen.
-- @param open boolean Optional. Default true.
function TakeFX:set_open(open)
	local open = open or true
	return r.TakeFX_SetOpen(self.take.pointer, self.pointer, open)
end

--- Set Param. Wraps TakeFX_SetParam.
-- @param param number
-- @param val number
-- @return boolean
function TakeFX:set_param(param, val)
	return r.TakeFX_SetParam(self.take.pointer, self.pointer, param, val)
end

--- Set Param Normalized.
-- @param param number
-- @param value number
-- @return boolean
function TakeFX:set_param_normalized(param, value)
	return r.TakeFX_SetParamNormalized(self.take.pointer, self.pointer, param, value)
end

--- Set Pin Mappings. Wraps TakeFX_SetPinMappings.
-- @param is_output number
-- @param pin number
-- @param low32bits number
-- @param hi32bits number
-- @return boolean
function TakeFX:set_pin_mappings(is_output, pin, low32bits, hi32bits)
	return r.TakeFX_SetPinMappings(self.take.pointer, self.pointer, is_output, pin, low32bits, hi32bits)
end

--- Set Preset. Wraps TakeFX_SetPreset.
-- @param preset_name string
-- @return boolean
function TakeFX:set_preset(preset_name)
	return r.TakeFX_SetPreset(self.take.pointer, self.pointer, preset_name)
end

--- Set Preset By Index. Wraps TakeFX_SetPresetByIndex.
-- @return boolean
function TakeFX:set_preset_by_index()
	return r.TakeFX_SetPresetByIndex(self.take.pointer, self.pointer, idx)
end

--- Show. Wraps TakeFX_Show.
-- @param show_flag number
function TakeFX:show(show_flag)
	return r.TakeFX_Show(self.take.pointer, self.pointer, show_flag)
end

--- Get Fx Count. Wraps BR_GetTakeFXCount.
-- [BR] Returns FX count for supplied take
-- @return number
function TakeFX:get_fx_count()
	return r.BR_GetTakeFXCount(self.take.pointer)
end

--- Get Chain. Wraps CF_GetTakeFXChain.
-- Return a handle to the given take FX chain window. HACK: This temporarily
-- renames the take in order to disambiguate the take FX chain window from
-- similarly named takes.
-- @return FxChain
function TakeFX:get_chain()
	return r.CF_GetTakeFXChain(self.take.pointer)
end

--- Select. Wraps CF_SelectTakeFX.
-- Set which take effect is active in the take's FX chain. The FX chain window does
-- not have to be open.
-- @return boolean
function TakeFX:select()
	return r.CF_SelectTakeFX(self.take.pointer, self.pointer)
end

return TakeFX
