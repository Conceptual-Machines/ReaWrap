-- @description Provide implementation for Envelope functions.
-- @author NomadMonad
-- @license MIT

local r = reaper
local helpers = require("helpers")

local Envelope = {}

--- Create new Envelope instance.
-- @param envelope . The pointer to Reaper TrackEnvelope*
-- @return Envelope table.
function Envelope:new(envelope)
	local obj = {
		pointer_type = "TrackEnvelope*",
		pointer = envelope,
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

-- @section ReaWrap Custom Methods

--- Log messages with the Envelope logger.
-- @param ... (varargs) Messages to log.
function Envelope:log(...)
	local logger = helpers.log_func("Envelope")
	logger(...)
	return nil
end

-- @section ReaScript API Methods

--- Count Automation Items. Wraps CountAutomationItems.
-- Returns the number of automation items on this envelope. See
-- GetSetAutomationItemInfo
-- @return number
function Envelope:count_automation_items()
	return r.CountAutomationItems(self.pointer)
end

--- Count Envelope Points. Wraps CountEnvelopePoints.
-- Returns the number of points in the envelope. See CountEnvelopePointsEx.
-- @return number
function Envelope:count_envelope_points()
	return r.CountEnvelopePoints(self.pointer)
end

--- Count Envelope Points Ex. Wraps CountEnvelopePointsEx.
-- Returns the number of points in the envelope. autoitem_idx=-1 for the underlying
-- envelope, 0 for the first automation item on the envelope, etc. For automation
-- items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one
-- full loop iteration, even if the automation item is trimmed so that not all
-- points are visible. Otherwise, ptidx will be based on the number of visible
-- points in the automation item, including all loop iterations. See
-- GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx,
-- DeleteEnvelopePointEx.
-- @param autoitem_idx number
-- @return number
function Envelope:count_envelope_points_ex(autoitem_idx)
	return r.CountEnvelopePointsEx(self.pointer, autoitem_idx)
end

--- Delete Envelope Point Ex. Wraps DeleteEnvelopePointEx.
-- Delete an envelope point. If setting multiple points at once, set noSort=true,
-- and call Envelope_SortPoints when done. autoitem_idx=-1 for the underlying
-- envelope, 0 for the first automation item on the envelope, etc. For automation
-- items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one
-- full loop iteration, even if the automation item is trimmed so that not all
-- points are visible. Otherwise, ptidx will be based on the number of visible
-- points in the automation item, including all loop iterations. See
-- CountEnvelopePointsEx, GetEnvelopePointEx, SetEnvelopePointEx,
-- InsertEnvelopePointEx.
-- @param autoitem_idx number
-- @param pt_idx number
-- @return boolean
function Envelope:delete_envelope_point_ex(autoitem_idx, pt_idx)
	return r.DeleteEnvelopePointEx(self.pointer, autoitem_idx, pt_idx)
end

--- Delete Envelope Point Range. Wraps DeleteEnvelopePointRange.
-- Delete a range of envelope points. See DeleteEnvelopePointRangeEx,
-- DeleteEnvelopePointEx.
-- @param time_start number
-- @param time_end number
-- @return boolean
function Envelope:delete_envelope_point_range(time_start, time_end)
	return r.DeleteEnvelopePointRange(self.pointer, time_start, time_end)
end

--- Delete Envelope Point Range Ex. Wraps DeleteEnvelopePointRangeEx.
-- Delete a range of envelope points. autoitem_idx=-1 for the underlying envelope,
-- 0 for the first automation item on the envelope, etc.
-- @param autoitem_idx number
-- @param time_start number
-- @param time_end number
-- @return boolean
function Envelope:delete_envelope_point_range_ex(autoitem_idx, time_start, time_end)
	return r.DeleteEnvelopePointRangeEx(self.pointer, autoitem_idx, time_start, time_end)
end

--- Evaluate. Wraps Envelope_Evaluate.
-- Get the effective envelope value at a given time position. samplesRequested is
-- how long the caller expects until the next call to Envelope_Evaluate (often, the
-- buffer block size). The return value is how many samples beyond that time
-- position that the returned values are valid. dVdS is the change in value per
-- sample (first derivative), ddVdS is the second derivative, dddVdS is the third
-- derivative. See GetEnvelopeScalingMode.
-- @param time number
-- @param samplerate number
-- @param samples_requested number
-- @return value number
-- @return d_vd_s number
-- @return dd_vd_s number
-- @return ddd_vd_s number
function Envelope:evaluate(time, samplerate, samples_requested)
	local ret_val, value, d_vd_s, dd_vd_s, ddd_vd_s =
		r.Envelope_Evaluate(self.pointer, time, samplerate, samples_requested)
	if ret_val then
		return value, d_vd_s, dd_vd_s, ddd_vd_s
	else
		return nil
	end
end

--- Format Value. Wraps Envelope_FormatValue.
-- Formats the value of an envelope to a user-readable form
-- @param value number
-- @return buf string
function Envelope:format_value(value)
	return r.Envelope_FormatValue(self.pointer, value)
end

--- Get Parent Take. Wraps Envelope_GetParentTake.
-- If take envelope, gets the take from the envelope. If FX, indexOut set to FX
-- index, index2Out set to parameter index, otherwise -1.
-- @return index number
-- @return index2 number
function Envelope:get_parent_take()
	local ret_val, index, index2 = r.Envelope_GetParentTake(self.pointer)
	if ret_val then
		return index, index2
	else
		return nil
	end
end

--- Get Parent Track. Wraps Envelope_GetParentTrack.
-- If track envelope, gets the track from the envelope. If FX, indexOut set to FX
-- index, index2Out set to parameter index, otherwise -1.
-- @return index number
-- @return index2 number
function Envelope:get_parent_track()
	local ret_val, index, index2 = r.Envelope_GetParentTrack(self.pointer)
	if ret_val then
		return index, index2
	else
		return nil
	end
end

--- Sort Points. Wraps Envelope_SortPoints.
-- Sort envelope points by time. See SetEnvelopePoint, InsertEnvelopePoint.
-- @return boolean
function Envelope:sort_points()
	return r.Envelope_SortPoints(self.pointer)
end

--- Sort Points Ex. Wraps Envelope_SortPointsEx.
-- Sort envelope points by time. autoitem_idx=-1 for the underlying envelope, 0 for
-- the first automation item on the envelope, etc. See SetEnvelopePoint,
-- InsertEnvelopePoint.
-- @param autoitem_idx number
-- @return boolean
function Envelope:sort_points_ex(autoitem_idx)
	return r.Envelope_SortPointsEx(self.pointer, autoitem_idx)
end

--- Constants for Envelope:get_envelope_info_value.
-- @field I_TCPY number: Y offset of envelope relative to parent track (may be separate lane or overlap with track contents)
-- @field I_TCPH number: visible height of envelope
-- @field I_TCPY_USED number: Y offset of envelope relative to parent track, exclusive of padding
-- @field I_TCPH_USED number: visible height of envelope, exclusive of padding
-- @field P_TRACK userdata: parent track pointer (if any)
-- @field P_DESTTRACK userdata: destination track pointer, if on a send
-- @field P_ITEM userdata: parent item pointer (if any)
-- @field P_TAKE userdata: parent take pointer (if any)
-- @field I_SEND_IDX number: 1-based index of send in P_TRACK, or 0 if not a send
-- @field I_HWOUT_IDX number: 1-based index of hardware output in P_TRACK or 0 if not a hardware output
-- @field I_RECV_IDX number: 1-based index of receive in P_DESTTRACK or 0 if not a send/receive
Envelope.GetEnvelopeInfoValueConstants = {
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

--- Get Envelope Info Value. Wraps GetEnvelopeInfo_Value.
-- Gets an envelope numerical-value attribute:
-- @param parm_name string. Envelope.GetEnvelopeInfoValueConstants
-- @return number
function Envelope:get_envelope_info_value(parm_name)
	return r.GetEnvelopeInfo_Value(self.pointer, parm_name)
end

--- Get Envelope Name. Wraps GetEnvelopeName.
-- @return buf string
function Envelope:get_envelope_name()
	local ret_val, buf = r.GetEnvelopeName(self.pointer)
	if ret_val then
		return buf
	else
		return nil
	end
end

--- Get Envelope Point. Wraps GetEnvelopePoint.
-- Get the attributes of an envelope point. See GetEnvelopePointEx.
-- @param pt_idx number
-- @return time number
-- @return value number
-- @return shape number
-- @return tension number
-- @return selected boolean
function Envelope:get_envelope_point(pt_idx)
	local ret_val, time, value, shape, tension, selected = r.GetEnvelopePoint(self.pointer, pt_idx)
	if ret_val then
		return time, value, shape, tension, selected
	else
		return nil
	end
end

--- Get Envelope Point By Time. Wraps GetEnvelopePointByTime.
-- Returns the envelope point at or immediately prior to the given time position.
-- See GetEnvelopePointByTimeEx.
-- @param time number
-- @return number
function Envelope:get_envelope_point_by_time(time)
	return r.GetEnvelopePointByTime(self.pointer, time)
end

--- Get Envelope Point By Time Ex. Wraps GetEnvelopePointByTimeEx.
-- Returns the envelope point at or immediately prior to the given time position.
-- autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on
-- the envelope, etc. For automation items, pass autoitem_idx|0x10000000 to base
-- ptidx on the number of points in one full loop iteration, even if the automation
-- item is trimmed so that not all points are visible. Otherwise, ptidx will be
-- based on the number of visible points in the automation item, including all loop
-- iterations. See GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx,
-- DeleteEnvelopePointEx.
-- @param autoitem_idx number
-- @param time number
-- @return number
function Envelope:get_envelope_point_by_time_ex(autoitem_idx, time)
	return r.GetEnvelopePointByTimeEx(self.pointer, autoitem_idx, time)
end

--- Get Envelope Point Ex. Wraps GetEnvelopePointEx.
-- Get the attributes of an envelope point. autoitem_idx=-1 for the underlying
-- envelope, 0 for the first automation item on the envelope, etc. For automation
-- items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one
-- full loop iteration, even if the automation item is trimmed so that not all
-- points are visible. Otherwise, ptidx will be based on the number of visible
-- points in the automation item, including all loop iterations. See
-- CountEnvelopePointsEx, SetEnvelopePointEx, InsertEnvelopePointEx,
-- DeleteEnvelopePointEx.
-- @param autoitem_idx number
-- @param pt_idx number
-- @return time number
-- @return value number
-- @return shape number
-- @return tension number
-- @return selected boolean
function Envelope:get_envelope_point_ex(autoitem_idx, pt_idx)
	local ret_val, time, value, shape, tension, selected = r.GetEnvelopePointEx(self.pointer, autoitem_idx, pt_idx)
	if ret_val then
		return time, value, shape, tension, selected
	else
		return nil
	end
end

--- Get Envelope Scaling Mode. Wraps GetEnvelopeScalingMode.
-- Returns the envelope scaling mode: 0=no scaling, 1=fader scaling. All API
-- functions deal with raw envelope point values, to convert raw from/to scaled
-- values see ScaleFromEnvelopeMode, ScaleToEnvelopeMode.
-- @return number
function Envelope:get_envelope_scaling_mode()
	return r.GetEnvelopeScalingMode(self.pointer)
end

--- Get Envelope State Chunk. Wraps GetEnvelopeStateChunk.
-- Gets the RPPXML state of an envelope, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string
-- @param is_undo boolean
-- @return str string
function Envelope:get_envelope_state_chunk(str, is_undo)
	local ret_val, str = r.GetEnvelopeStateChunk(self.pointer, str, is_undo)
	if ret_val then
		return str
	else
		return nil
	end
end

--- Get Envelope Ui State. Wraps GetEnvelopeUIState.
-- gets information on the UI state of an envelope: returns &1 if
-- automation/modulation is playing back, &2 if automation is being actively
-- written, &4 if the envelope recently had an effective automation mode change
-- @return number
function Envelope:get_envelope_ui_state()
	return r.GetEnvelopeUIState(self.pointer)
end

--- Constants for Envelope:get_set_automation_item_info.
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
Envelope.GetSetAutomationItemInfoConstants = {
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

--- Get Set Automation Item Info. Wraps GetSetAutomationItemInfo.
-- Get or set automation item information. autoitem_idx=0 for the first automation
-- item on an envelope, 1 for the second item, etc. desc can be any of the
-- following:
-- @param autoitem_idx number
-- @param desc string. Envelope.GetSetAutomationItemInfoConstants
-- @param value number
-- @param is_set boolean
-- @return number
function Envelope:get_set_automation_item_info(autoitem_idx, desc, value, is_set)
	return r.GetSetAutomationItemInfo(self.pointer, autoitem_idx, desc, value, is_set)
end

--- Constants for Envelope:get_set_automation_item_info_string.
-- @field P_POOL_NAME string: name of the underlying automation item pool
-- @field P_POOL_EXT xyz: xyzchar *extension-specific persistent data
Envelope.GetSetAutomationItemInfoStringConstants = {
	P_POOL_NAME = "P_POOL_NAME",
	P_POOL_EXT = "P_POOL_EXT",
}

--- Get Set Automation Item Info String. Wraps GetSetAutomationItemInfo_String.
-- Get or set automation item information. autoitem_idx=0 for the first automation
-- item on an envelope, 1 for the second item, etc. returns true on success. desc
-- can be any of the following:
-- @param autoitem_idx number
-- @param desc string. Envelope.GetSetAutomationItemInfoStringConstants
-- @param valuestr_need_big string
-- @param is_set boolean
-- @return valuestr_need_big string
function Envelope:get_set_automation_item_info_string(autoitem_idx, desc, valuestr_need_big, is_set)
	local ret_val, valuestr_need_big =
		r.GetSetAutomationItemInfo_String(self.pointer, autoitem_idx, desc, valuestr_need_big, is_set)
	if ret_val then
		return valuestr_need_big
	else
		return nil
	end
end

--- Constants for Envelope:get_set_envelope_info_string.
-- @field ACTIVE string: active state (bool as a string "0" or "1")
-- @field ARM any: armed state (bool...)
-- @field VISIBLE any: visible state (bool...)
-- @field SHOWLANE any: show envelope in separate lane (bool...)
-- @field GUID string: (read-only) GUID as a string {xyz-....}
-- @field P_EXT xyz: extension-specific persistent data
Envelope.GetSetEnvelopeInfoStringConstants = {
	ACTIVE = "ACTIVE",
	ARM = "ARM",
	VISIBLE = "VISIBLE",
	SHOWLANE = "SHOWLANE",
	GUID = "GUID",
	P_EXT = "P_EXT",
}

--- Get Set Envelope Info String. Wraps GetSetEnvelopeInfo_String.
-- Gets/sets an attribute string:Note that when writing some of these attributes
-- you will need to manually update the arrange and/or track panels,
-- seeTrackList_AdjustWindows
-- @param parm_name string. Envelope.GetSetEnvelopeInfoStringConstants
-- @param string_need_big string
-- @param set_new_value boolean
-- @return string_need_big string
function Envelope:get_set_envelope_info_string(parm_name, string_need_big, set_new_value)
	local ret_val, string_need_big =
		r.GetSetEnvelopeInfo_String(self.pointer, parm_name, string_need_big, set_new_value)
	if ret_val then
		return string_need_big
	else
		return nil
	end
end

--- Insert Automation Item. Wraps InsertAutomationItem.
-- Insert a new automation item. pool_id < 0 collects existing envelope points into
-- the automation item; if pool_id is >= 0 the automation item will be a new
-- instance of that pool (which will be created as an empty instance if it does not
-- exist). Returns the index of the item, suitable for passing to other automation
-- item API functions. See GetSetAutomationItemInfo.
-- @param pool_id number
-- @param position number
-- @param length number
-- @return number
function Envelope:insert_automation_item(pool_id, position, length)
	return r.InsertAutomationItem(self.pointer, pool_id, position, length)
end

--- Insert Envelope Point. Wraps InsertEnvelopePoint.
-- Insert an envelope point. If setting multiple points at once, set noSort=true,
-- and call Envelope_SortPoints when done. See InsertEnvelopePointEx.
-- @param time number
-- @param value number
-- @param shape number
-- @param tension number
-- @param selected boolean
-- @param boolean noSortIn Optional
-- @return boolean
function Envelope:insert_envelope_point(time, value, shape, tension, selected, boolean)
	local boolean = boolean or nil
	return r.InsertEnvelopePoint(self.pointer, time, value, shape, tension, selected, boolean)
end

--- Insert Envelope Point Ex. Wraps InsertEnvelopePointEx.
-- Insert an envelope point. If setting multiple points at once, set noSort=true,
-- and call Envelope_SortPoints when done. autoitem_idx=-1 for the underlying
-- envelope, 0 for the first automation item on the envelope, etc. For automation
-- items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one
-- full loop iteration, even if the automation item is trimmed so that not all
-- points are visible. Otherwise, ptidx will be based on the number of visible
-- points in the automation item, including all loop iterations. See
-- CountEnvelopePointsEx, GetEnvelopePointEx, SetEnvelopePointEx,
-- DeleteEnvelopePointEx.
-- @param autoitem_idx number
-- @param time number
-- @param value number
-- @param shape number
-- @param tension number
-- @param selected boolean
-- @param boolean noSortIn Optional
-- @return boolean
function Envelope:insert_envelope_point_ex(autoitem_idx, time, value, shape, tension, selected, boolean)
	local boolean = boolean or nil
	return r.InsertEnvelopePointEx(self.pointer, autoitem_idx, time, value, shape, tension, selected, boolean)
end

--- Set Envelope Point. Wraps SetEnvelopePoint.
-- Set attributes of an envelope point. Values that are not supplied will be
-- ignored. If setting multiple points at once, set noSort=true, and call
-- Envelope_SortPoints when done. See SetEnvelopePointEx.
-- @param pt_idx number
-- @param number timeIn Optional
-- @param number valueIn Optional
-- @param integer shapeIn Optional
-- @param number tensionIn Optional
-- @param boolean selectedIn Optional
-- @param boolean noSortIn Optional
-- @return boolean
function Envelope:set_envelope_point(pt_idx, number, number, integer, number, boolean, boolean)
	local number = number or nil
	local integer = integer or nil
	local boolean = boolean or nil
	return r.SetEnvelopePoint(self.pointer, pt_idx, number, number, integer, number, boolean, boolean)
end

--- Set Envelope Point Ex. Wraps SetEnvelopePointEx.
-- Set attributes of an envelope point. Values that are not supplied will be
-- ignored. If setting multiple points at once, set noSort=true, and call
-- Envelope_SortPoints when done. autoitem_idx=-1 for the underlying envelope, 0
-- for the first automation item on the envelope, etc. For automation items, pass
-- autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop
-- iteration, even if the automation item is trimmed so that not all points are
-- visible. Otherwise, ptidx will be based on the number of visible points in the
-- automation item, including all loop iterations. See CountEnvelopePointsEx,
-- GetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
-- @param autoitem_idx number
-- @param pt_idx number
-- @param number timeIn Optional
-- @param number valueIn Optional
-- @param integer shapeIn Optional
-- @param number tensionIn Optional
-- @param boolean selectedIn Optional
-- @param boolean noSortIn Optional
-- @return boolean
function Envelope:set_envelope_point_ex(autoitem_idx, pt_idx, number, number, integer, number, boolean, boolean)
	local number = number or nil
	local integer = integer or nil
	local boolean = boolean or nil
	return r.SetEnvelopePointEx(self.pointer, autoitem_idx, pt_idx, number, number, integer, number, boolean, boolean)
end

--- Set Envelope State Chunk. Wraps SetEnvelopeStateChunk.
-- Sets the RPPXML state of an envelope, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string
-- @param is_undo boolean
-- @return boolean
function Envelope:set_envelope_state_chunk(str, is_undo)
	return r.SetEnvelopeStateChunk(self.pointer, str, is_undo)
end

--- Env Alloc. Wraps BR_EnvAlloc.
-- [BR] Allocate envelope object from track or take envelope pointer. Always call
-- BR_EnvFree when done to release the object and commit changes if needed.
-- takeEnvelopesUseProjectTime: take envelope points' positions are counted from
-- take position, not project start time. If you want to work with project time
-- instead, pass this as true.
-- @param take_envelopes_use_project_time boolean
-- @return BR_Envelope
function Envelope:env_alloc(take_envelopes_use_project_time)
	return r.BR_EnvAlloc(self.pointer, take_envelopes_use_project_time)
end

--- Calculate Envelope Hash. Wraps MRP_CalculateEnvelopeHash.
-- This function isn't really correct... it calculates a 64 bit hash but returns it
-- as a 32 bit int. Should reimplement this. Or rather, even more confusingly : The
-- hash will be 32 bit when building for 32 bit architecture and 64 bit when
-- building for 64 bit architecture! It comes down to how size_t is of different
-- size between the 32 and 64 bit architectures.
-- @return number
function Envelope:calculate_envelope_hash()
	return r.MRP_CalculateEnvelopeHash(self.pointer)
end

return Envelope
