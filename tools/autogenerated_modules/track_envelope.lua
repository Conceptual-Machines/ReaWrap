-- @description Provide implementation for TrackEnvelope functions.
-- @author NomadMonad
-- @license MIT

local r = reaper
local helpers = require("helpers")

local TrackEnvelope = {}

--- Create new TrackEnvelope instance.
-- @param envelope userdata. The pointer to Reaper TrackEnvelope*
-- @return TrackEnvelope table.
function TrackEnvelope:new(envelope)
	local obj = {
		pointer_type = "TrackEnvelope*",
		pointer = envelope,
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

--- Log messages with the TrackEnvelope logger.
-- @param ... (varargs) Messages to log.
function TrackEnvelope:log(...)
	local logger = helpers.log_func("TrackEnvelope")
	logger(...)
	return nil
end

--- Count Automation Items.
-- Returns the number of automation items on this envelope. See
-- GetSetAutomationItemInfo
-- @return integer
function TrackEnvelope:count_automation_items()
	return r.CountAutomationItems(self.pointer)
end

--- Count Envelope Points.
-- Returns the number of points in the envelope. See CountEnvelopePointsEx.
-- @return integer
function TrackEnvelope:count_envelope_points()
	return r.CountEnvelopePoints(self.pointer)
end

--- Count Envelope Points Ex.
-- Returns the number of points in the envelope. autoitem_idx=-1 for the underlying
-- envelope, 0 for the first automation item on the envelope, etc. For automation
-- items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one
-- full loop iteration, even if the automation item is trimmed so that not all
-- points are visible. Otherwise, ptidx will be based on the number of visible
-- points in the automation item, including all loop iterations. See
-- GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx,
-- DeleteEnvelopePointEx.
-- @param autoitem_idx integer.
-- @return integer
function TrackEnvelope:count_envelope_points_ex(autoitem_idx)
	return r.CountEnvelopePointsEx(self.pointer, autoitem_idx)
end

--- Delete Envelope Point Ex.
-- Delete an envelope point. If setting multiple points at once, set noSort=true,
-- and call Envelope_SortPoints when done. autoitem_idx=-1 for the underlying
-- envelope, 0 for the first automation item on the envelope, etc. For automation
-- items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one
-- full loop iteration, even if the automation item is trimmed so that not all
-- points are visible. Otherwise, ptidx will be based on the number of visible
-- points in the automation item, including all loop iterations. See
-- CountEnvelopePointsEx, GetEnvelopePointEx, SetEnvelopePointEx,
-- InsertEnvelopePointEx.
-- @param autoitem_idx integer.
-- @param pt_idx integer.
-- @return boolean
function TrackEnvelope:delete_envelope_point_ex(autoitem_idx, pt_idx)
	return r.DeleteEnvelopePointEx(self.pointer, autoitem_idx, pt_idx)
end

--- Delete Envelope Point Range.
-- Delete a range of envelope points. See DeleteEnvelopePointRangeEx,
-- DeleteEnvelopePointEx.
-- @param time_start number.
-- @param time_end number.
-- @return boolean
function TrackEnvelope:delete_envelope_point_range(time_start, time_end)
	return r.DeleteEnvelopePointRange(self.pointer, time_start, time_end)
end

--- Delete Envelope Point Range Ex.
-- Delete a range of envelope points. autoitem_idx=-1 for the underlying envelope,
-- 0 for the first automation item on the envelope, etc.
-- @param autoitem_idx integer.
-- @param time_start number.
-- @param time_end number.
-- @return boolean
function TrackEnvelope:delete_envelope_point_range_ex(autoitem_idx, time_start, time_end)
	return r.DeleteEnvelopePointRangeEx(self.pointer, autoitem_idx, time_start, time_end)
end

--- Evaluate.
-- Get the effective envelope value at a given time position. samplesRequested is
-- how long the caller expects until the next call to Envelope_Evaluate (often, the
-- buffer block size). The return value is how many samples beyond that time
-- position that the returned values are valid. dVdS is the change in value per
-- sample (first derivative), ddVdS is the second derivative, dddVdS is the third
-- derivative. See GetEnvelopeScalingMode.
-- @param time number.
-- @param samplerate number.
-- @param samples_requested integer.
-- @return value number
-- @return d_vd_s number
-- @return dd_vd_s number
-- @return ddd_vd_s number
function TrackEnvelope:evaluate(time, samplerate, samples_requested)
	local ret_val, value, d_vd_s, dd_vd_s, ddd_vd_s =
		r.Envelope_Evaluate(self.pointer, time, samplerate, samples_requested)
	if ret_val then
		return value, d_vd_s, dd_vd_s, ddd_vd_s
	else
		return nil
	end
end

--- Format Value.
-- Formats the value of an envelope to a user-readable form
-- @param value number.
-- @return buf string
function TrackEnvelope:format_value(value)
	return r.Envelope_FormatValue(self.pointer, value)
end

--- Get Parent Take.
-- If take envelope, gets the take from the envelope. If FX, indexOut set to FX
-- index, index2Out set to parameter index, otherwise -1.
-- @return index integer
-- @return index2 integer
function TrackEnvelope:get_parent_take()
	local ret_val, index, index2 = r.Envelope_GetParentTake(self.pointer)
	if ret_val then
		return index, index2
	else
		return nil
	end
end

--- Get Parent Track.
-- If track envelope, gets the track from the envelope. If FX, indexOut set to FX
-- index, index2Out set to parameter index, otherwise -1.
-- @return index integer
-- @return index2 integer
function TrackEnvelope:get_parent_track()
	local ret_val, index, index2 = r.Envelope_GetParentTrack(self.pointer)
	if ret_val then
		return index, index2
	else
		return nil
	end
end

--- Sort Points.
-- Sort envelope points by time. See SetEnvelopePoint, InsertEnvelopePoint.
-- @return boolean
function TrackEnvelope:sort_points()
	return r.Envelope_SortPoints(self.pointer)
end

--- Sort Points Ex.
-- Sort envelope points by time. autoitem_idx=-1 for the underlying envelope, 0 for
-- the first automation item on the envelope, etc. See SetEnvelopePoint,
-- InsertEnvelopePoint.
-- @param autoitem_idx integer.
-- @return boolean
function TrackEnvelope:sort_points_ex(autoitem_idx)
	return r.Envelope_SortPointsEx(self.pointer, autoitem_idx)
end

--- Constants for TrackEnvelope:get_envelope_info_value.
-- @field I_TCPY number: Y offset of envelope relative to parent track (may be separate lane or overlap with track contents)
-- @field I_TCPH number: visible height of envelope
-- @field I_TCPY_USED number: Y offset of envelope relative to parent track, exclusive of padding
-- @field I_TCPH_USED number: visible height of envelope, exclusive of padding
-- @field P_TRACK MediaTrack: parent track pointer (if any)
-- @field P_DESTTRACK MediaTrack: destination track pointer, if on a send
-- @field P_ITEM MediaItem: parent item pointer (if any)
-- @field P_TAKE MediaItem: parent take pointer (if any)
-- @field I_SEND_IDX number: 1-based index of send in P_TRACK, or 0 if not a send
-- @field I_HWOUT_IDX number: 1-based index of hardware output in P_TRACK or 0 if not a hardware output
-- @field I_RECV_IDX number: 1-based index of receive in P_DESTTRACK or 0 if not a send/receive
TrackEnvelope.GetEnvelopeInfoValueConstants = {
	I_TCPY = "I_TCPY",
	I_TCPH = "I_TCPH",
	I_TCPY_USED = "I_TCPY_USED",
	I_TCPH_USED = "I_TCPH_USED",
	P_TRACK = "P_TRACK",
	P_DESTTRACK = "P_DESTTRACK",
	P_ITEM = "P_ITEM",
	P_TAKE = "P_TAKE",
	I_SEND_IDX = "I_SEND_IDX",
	I_HWOUT_IDX = "I_HWOUT_IDX",
	I_RECV_IDX = "I_RECV_IDX",
}

--- Get Envelope Info Value.
-- Gets an envelope numerical-value attribute:
-- @param parm_name string. TrackEnvelope.GetEnvelopeInfoValueConstants
-- @return number
function TrackEnvelope:get_envelope_info_value(parm_name)
	return r.GetEnvelopeInfo_Value(self.pointer, parm_name)
end

--- Get Envelope Name.
-- @return buf string
function TrackEnvelope:get_envelope_name()
	local ret_val, buf = r.GetEnvelopeName(self.pointer)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Envelope Point.
-- Get the attributes of an envelope point. See GetEnvelopePointEx.
-- @param pt_idx integer.
-- @return time number
-- @return value number
-- @return shape integer
-- @return tension number
-- @return selected boolean
function TrackEnvelope:get_envelope_point(pt_idx)
	local ret_val, time, value, shape, tension, selected = r.GetEnvelopePoint(self.pointer, pt_idx)
	if ret_val then
		return time, value, shape, tension, selected
	else
		return nil
	end
end

--- Get Envelope Point By Time.
-- Returns the envelope point at or immediately prior to the given time position.
-- See GetEnvelopePointByTimeEx.
-- @param time number.
-- @return integer
function TrackEnvelope:get_envelope_point_by_time(time)
	return r.GetEnvelopePointByTime(self.pointer, time)
end

--- Get Envelope Point By Time Ex.
-- Returns the envelope point at or immediately prior to the given time position.
-- autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on
-- the envelope, etc. For automation items, pass autoitem_idx|0x10000000 to base
-- ptidx on the number of points in one full loop iteration, even if the automation
-- item is trimmed so that not all points are visible. Otherwise, ptidx will be
-- based on the number of visible points in the automation item, including all loop
-- iterations. See GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx,
-- DeleteEnvelopePointEx.
-- @param autoitem_idx integer.
-- @param time number.
-- @return integer
function TrackEnvelope:get_envelope_point_by_time_ex(autoitem_idx, time)
	return r.GetEnvelopePointByTimeEx(self.pointer, autoitem_idx, time)
end

--- Get Envelope Point Ex.
-- Get the attributes of an envelope point. autoitem_idx=-1 for the underlying
-- envelope, 0 for the first automation item on the envelope, etc. For automation
-- items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one
-- full loop iteration, even if the automation item is trimmed so that not all
-- points are visible. Otherwise, ptidx will be based on the number of visible
-- points in the automation item, including all loop iterations. See
-- CountEnvelopePointsEx, SetEnvelopePointEx, InsertEnvelopePointEx,
-- DeleteEnvelopePointEx.
-- @param autoitem_idx integer.
-- @param pt_idx integer.
-- @return time number
-- @return value number
-- @return shape integer
-- @return tension number
-- @return selected boolean
function TrackEnvelope:get_envelope_point_ex(autoitem_idx, pt_idx)
	local ret_val, time, value, shape, tension, selected = r.GetEnvelopePointEx(self.pointer, autoitem_idx, pt_idx)
	if ret_val then
		return time, value, shape, tension, selected
	else
		return nil
	end
end

--- Get Envelope Scaling Mode.
-- Returns the envelope scaling mode: 0=no scaling, 1=fader scaling. All API
-- functions deal with raw envelope point values, to convert raw from/to scaled
-- values see ScaleFromEnvelopeMode, ScaleToEnvelopeMode.
-- @return integer
function TrackEnvelope:get_envelope_scaling_mode()
	return r.GetEnvelopeScalingMode(self.pointer)
end

--- Get Envelope State Chunk.
-- Gets the RPPXML state of an envelope, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string.
-- @param is_undo boolean.
-- @return str string
function TrackEnvelope:get_envelope_state_chunk(str, is_undo)
	local ret_val, str = r.GetEnvelopeStateChunk(self.pointer, str, is_undo)
	if ret_val then
		return str
	else
		return nil
	end
end

--- Get Envelope Ui State.
-- gets information on the UI state of an envelope: returns &1 if
-- automation/modulation is playing back, &2 if automation is being actively
-- written, &4 if the envelope recently had an effective automation mode change
-- @return integer
function TrackEnvelope:get_envelope_ui_state()
	return r.GetEnvelopeUIState(self.pointer)
end

--- Constants for TrackEnvelope:get_set_automation_item_info.
-- @field D_POOL_ID double *: automation item pool ID (as an integer); edits are propagated to all other automation items that share a pool ID
-- @field D_POSITION double *: automation item timeline position in seconds
-- @field D_LENGTH double *: automation item length in seconds
-- @field D_STARTOFFS double *: automation item start offset in seconds
-- @field D_PLAYRATE double *: automation item playback rate
-- @field D_BASELINE double *: automation item baseline value in the range [0,1]
-- @field D_AMPLITUDE double *: automation item amplitude in the range [-1,1]
-- @field D_LOOPSRC double *: nonzero if the automation item contents are looped
-- @field D_UISEL double *: nonzero if the automation item is selected in the arrange view
-- @field D_POOL_QNLEN double *: automation item pooled source length in quarter notes (setting will affect all pooled instances)
TrackEnvelope.GetSetAutomationItemInfoConstants = {
	D_POOL_ID = "D_POOL_ID",
	D_POSITION = "D_POSITION",
	D_LENGTH = "D_LENGTH",
	D_STARTOFFS = "D_STARTOFFS",
	D_PLAYRATE = "D_PLAYRATE",
	D_BASELINE = "D_BASELINE",
	D_AMPLITUDE = "D_AMPLITUDE",
	D_LOOPSRC = "D_LOOPSRC",
	D_UISEL = "D_UISEL",
	D_POOL_QNLEN = "D_POOL_QNLEN",
}

--- Get Set Automation Item Info.
-- Get or set automation item information. autoitem_idx=0 for the first automation
-- item on an envelope, 1 for the second item, etc. desc can be any of the
-- following:
-- @param autoitem_idx integer.
-- @param desc string. TrackEnvelope.GetSetAutomationItemInfoConstants
-- @param value number.
-- @param is_set boolean.
-- @return number
function TrackEnvelope:get_set_automation_item_info(autoitem_idx, desc, value, is_set)
	return r.GetSetAutomationItemInfo(self.pointer, autoitem_idx, desc, value, is_set)
end

--- Constants for TrackEnvelope:get_set_automation_item_info_string.
-- @field P_POOL_NAME string: name of the underlying automation item pool
-- @field P_POOL_EXT xyz: xyzchar *extension-specific persistent data
TrackEnvelope.GetSetAutomationItemInfoStringConstants = {
	P_POOL_NAME = "P_POOL_NAME",
	P_POOL_EXT = "P_POOL_EXT",
}

--- Get Set Automation Item Info String.
-- Get or set automation item information. autoitem_idx=0 for the first automation
-- item on an envelope, 1 for the second item, etc. returns true on success. desc
-- can be any of the following:
-- @param autoitem_idx integer.
-- @param desc string. TrackEnvelope.GetSetAutomationItemInfoStringConstants
-- @param valuestr_need_big string.
-- @param is_set boolean.
-- @return valuestr_need_big string
function TrackEnvelope:get_set_automation_item_info_string(autoitem_idx, desc, valuestr_need_big, is_set)
	local ret_val, valuestr_need_big =
		r.GetSetAutomationItemInfo_String(self.pointer, autoitem_idx, desc, valuestr_need_big, is_set)
	if ret_val then
		return valuestr_need_big
	else
		return nil
	end
end

--- Constants for TrackEnvelope:get_set_envelope_info_string.
-- @field ACTIVE string: active state (bool as a string "0" or "1")
-- @field ARM any: armed state (bool...)
-- @field VISIBLE any: visible state (bool...)
-- @field SHOWLANE any: show envelope in separate lane (bool...)
-- @field GUID string: (read-only) GUID as a string {xyz-....}
-- @field P_EXT xyz: extension-specific persistent data
TrackEnvelope.GetSetEnvelopeInfoStringConstants = {
	ACTIVE = "ACTIVE",
	ARM = "ARM",
	VISIBLE = "VISIBLE",
	SHOWLANE = "SHOWLANE",
	GUID = "GUID",
	P_EXT = "P_EXT",
}

--- Get Set Envelope Info String.
-- Gets/sets an attribute string:Note that when writing some of these attributes
-- you will need to manually update the arrange and/or track panels,
-- seeTrackList_AdjustWindows
-- @param parm_name string. TrackEnvelope.GetSetEnvelopeInfoStringConstants
-- @param string_need_big string.
-- @param set_new_value boolean.
-- @return string_need_big string
function TrackEnvelope:get_set_envelope_info_string(parm_name, string_need_big, set_new_value)
	local ret_val, string_need_big =
		r.GetSetEnvelopeInfo_String(self.pointer, parm_name, string_need_big, set_new_value)
	if ret_val then
		return string_need_big
	else
		return nil
	end
end

--- Insert Automation Item.
-- Insert a new automation item. pool_id < 0 collects existing envelope points into
-- the automation item; if pool_id is >= 0 the automation item will be a new
-- instance of that pool (which will be created as an empty instance if it does not
-- exist). Returns the index of the item, suitable for passing to other automation
-- item API functions. See GetSetAutomationItemInfo.
-- @param pool_id integer.
-- @param position number.
-- @param length number.
-- @return integer
function TrackEnvelope:insert_automation_item(pool_id, position, length)
	return r.InsertAutomationItem(self.pointer, pool_id, position, length)
end

--- Insert Envelope Point.
-- Insert an envelope point. If setting multiple points at once, set noSort=true,
-- and call Envelope_SortPoints when done. See InsertEnvelopePointEx.
-- @param time number.
-- @param value number.
-- @param shape integer.
-- @param tension number.
-- @param selected boolean.
-- @param boolean noSortIn Optional.
-- @return boolean
function TrackEnvelope:insert_envelope_point(time, value, shape, tension, selected, boolean)
	local boolean = boolean or nil
	return r.InsertEnvelopePoint(self.pointer, time, value, shape, tension, selected, boolean)
end

--- Insert Envelope Point Ex.
-- Insert an envelope point. If setting multiple points at once, set noSort=true,
-- and call Envelope_SortPoints when done. autoitem_idx=-1 for the underlying
-- envelope, 0 for the first automation item on the envelope, etc. For automation
-- items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one
-- full loop iteration, even if the automation item is trimmed so that not all
-- points are visible. Otherwise, ptidx will be based on the number of visible
-- points in the automation item, including all loop iterations. See
-- CountEnvelopePointsEx, GetEnvelopePointEx, SetEnvelopePointEx,
-- DeleteEnvelopePointEx.
-- @param autoitem_idx integer.
-- @param time number.
-- @param value number.
-- @param shape integer.
-- @param tension number.
-- @param selected boolean.
-- @param boolean noSortIn Optional.
-- @return boolean
function TrackEnvelope:insert_envelope_point_ex(autoitem_idx, time, value, shape, tension, selected, boolean)
	local boolean = boolean or nil
	return r.InsertEnvelopePointEx(self.pointer, autoitem_idx, time, value, shape, tension, selected, boolean)
end

--- Set Envelope Point.
-- Set attributes of an envelope point. Values that are not supplied will be
-- ignored. If setting multiple points at once, set noSort=true, and call
-- Envelope_SortPoints when done. See SetEnvelopePointEx.
-- @param pt_idx integer.
-- @param number timeIn Optional.
-- @param number valueIn Optional.
-- @param integer shapeIn Optional.
-- @param number tensionIn Optional.
-- @param boolean selectedIn Optional.
-- @param boolean noSortIn Optional.
-- @return boolean
function TrackEnvelope:set_envelope_point(pt_idx, number, number, integer, number, boolean, boolean)
	local number = number or nil
	local integer = integer or nil
	local boolean = boolean or nil
	return r.SetEnvelopePoint(self.pointer, pt_idx, number, number, integer, number, boolean, boolean)
end

--- Set Envelope Point Ex.
-- Set attributes of an envelope point. Values that are not supplied will be
-- ignored. If setting multiple points at once, set noSort=true, and call
-- Envelope_SortPoints when done. autoitem_idx=-1 for the underlying envelope, 0
-- for the first automation item on the envelope, etc. For automation items, pass
-- autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop
-- iteration, even if the automation item is trimmed so that not all points are
-- visible. Otherwise, ptidx will be based on the number of visible points in the
-- automation item, including all loop iterations. See CountEnvelopePointsEx,
-- GetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
-- @param autoitem_idx integer.
-- @param pt_idx integer.
-- @param number timeIn Optional.
-- @param number valueIn Optional.
-- @param integer shapeIn Optional.
-- @param number tensionIn Optional.
-- @param boolean selectedIn Optional.
-- @param boolean noSortIn Optional.
-- @return boolean
function TrackEnvelope:set_envelope_point_ex(autoitem_idx, pt_idx, number, number, integer, number, boolean, boolean)
	local number = number or nil
	local integer = integer or nil
	local boolean = boolean or nil
	return r.SetEnvelopePointEx(self.pointer, autoitem_idx, pt_idx, number, number, integer, number, boolean, boolean)
end

--- Set Envelope State Chunk.
-- Sets the RPPXML state of an envelope, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string.
-- @param is_undo boolean.
-- @return boolean
function TrackEnvelope:set_envelope_state_chunk(str, is_undo)
	return r.SetEnvelopeStateChunk(self.pointer, str, is_undo)
end

--- Env Alloc.
-- [BR] Allocate envelope object from track or take envelope pointer. Always call
-- BR_EnvFree when done to release the object and commit changes if needed.
-- takeEnvelopesUseProjectTime: take envelope points' positions are counted from
-- take position, not project start time. If you want to work with project time
-- instead, pass this as true.
-- @param take_envelopes_use_project_time boolean.
-- @return BR_Envelope
function TrackEnvelope:env_alloc(take_envelopes_use_project_time)
	return r.BR_EnvAlloc(self.pointer, take_envelopes_use_project_time)
end

--- Calculate Envelope Hash.
-- This function isn't really correct... it calculates a 64 bit hash but returns it
-- as a 32 bit int. Should reimplement this. Or rather, even more confusingly : The
-- hash will be 32 bit when building for 32 bit architecture and 64 bit when
-- building for 64 bit architecture! It comes down to how size_t is of different
-- size between the 32 and 64 bit architectures.
-- @return integer
function TrackEnvelope:calculate_envelope_hash()
	return r.MRP_CalculateEnvelopeHash(self.pointer)
end

return TrackEnvelope
