-- @description TrackEnvelope: Provide implementation for TrackEnvelope functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local TrackEnvelope = {}



--- Create new TrackEnvelope instance.
-- @return TrackEnvelope table.
function TrackEnvelope:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the TrackEnvelope logger.
-- @param ... (varargs) Messages to log.
function TrackEnvelope:log(...)
    local logger = helpers.log_func('TrackEnvelope')
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
-- @param autoitem__idx integer
-- @return integer
function TrackEnvelope:count_envelope_points_ex(autoitem__idx)
    return r.CountEnvelopePointsEx(self.pointer, autoitem__idx)
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
-- @param autoitem__idx integer
-- @param pt_idx integer
-- @return boolean
function TrackEnvelope:delete_envelope_point_ex(autoitem__idx, pt_idx)
    return r.DeleteEnvelopePointEx(self.pointer, autoitem__idx, pt_idx)
end

    
--- Delete Envelope Point Range.
-- Delete a range of envelope points. See DeleteEnvelopePointRangeEx,
-- DeleteEnvelopePointEx.
-- @param time_start number
-- @param time_end number
-- @return boolean
function TrackEnvelope:delete_envelope_point_range(time_start, time_end)
    return r.DeleteEnvelopePointRange(self.pointer, time_start, time_end)
end

    
--- Delete Envelope Point Range Ex.
-- Delete a range of envelope points. autoitem_idx=-1 for the underlying envelope,
-- 0 for the first automation item on the envelope, etc.
-- @param autoitem__idx integer
-- @param time_start number
-- @param time_end number
-- @return boolean
function TrackEnvelope:delete_envelope_point_range_ex(autoitem__idx, time_start, time_end)
    return r.DeleteEnvelopePointRangeEx(self.pointer, autoitem__idx, time_start, time_end)
end

    
--- Get Envelope Info Value.
-- Gets an envelope numerical-value attribute: I_TCPY : int : Y offset of envelope
-- relative to parent track (may be separate lane or overlap with track contents)
-- I_TCPH : int : visible height of envelope I_TCPY_USED : int : Y offset of
-- envelope relative to parent track, exclusive of padding I_TCPH_USED : int :
-- visible height of envelope, exclusive of padding P_TRACK : MediaTrack * : parent
-- track pointer (if any) P_DESTTRACK : MediaTrack * : destination track pointer,
-- if on a send P_ITEM : MediaItem * : parent item pointer (if any) P_TAKE :
-- MediaItem_Take * : parent take pointer (if any) I_SEND_IDX : int : 1-based index
-- of send in P_TRACK, or 0 if not a send I_HWOUT_IDX : int : 1-based index of
-- hardware output in P_TRACK or 0 if not a hardware output I_RECV_IDX : int :
-- 1-based index of receive in P_DESTTRACK or 0 if not a send/receive
-- @param parmname string
-- @return number
function TrackEnvelope:get_envelope_info_value(parmname)
    return r.GetEnvelopeInfo_Value(self.pointer, parmname)
end

    
--- Get Envelope Name.
-- @return buf string
function TrackEnvelope:get_envelope_name()
    local retval, buf = r.GetEnvelopeName(self.pointer)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Envelope Point.
-- Get the attributes of an envelope point. See GetEnvelopePointEx.
-- @param pt_idx integer
-- @return time number
-- @return value number
-- @return shape integer
-- @return tension number
-- @return selected boolean
function TrackEnvelope:get_envelope_point(pt_idx)
    local retval, time, value, shape, tension, selected = r.GetEnvelopePoint(self.pointer, pt_idx)
    if retval then
        return time, value, shape, tension, selected
    else
        return nil
    end
end

    
--- Get Envelope Point By Time.
-- Returns the envelope point at or immediately prior to the given time position.
-- See GetEnvelopePointByTimeEx.
-- @param time number
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
-- @param autoitem__idx integer
-- @param time number
-- @return integer
function TrackEnvelope:get_envelope_point_by_time_ex(autoitem__idx, time)
    return r.GetEnvelopePointByTimeEx(self.pointer, autoitem__idx, time)
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
-- @param autoitem__idx integer
-- @param pt_idx integer
-- @return time number
-- @return value number
-- @return shape integer
-- @return tension number
-- @return selected boolean
function TrackEnvelope:get_envelope_point_ex(autoitem__idx, pt_idx)
    local retval, time, value, shape, tension, selected = r.GetEnvelopePointEx(self.pointer, autoitem__idx, pt_idx)
    if retval then
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
-- @param str string
-- @param is_undo boolean
-- @return str string
function TrackEnvelope:get_envelope_state_chunk(str, is_undo)
    local retval, str = r.GetEnvelopeStateChunk(self.pointer, str, is_undo)
    if retval then
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

    
--- Get Set Automation Item Info.
-- Get or set automation item information. autoitem_idx=0 for the first automation
-- item on an envelope, 1 for the second item, etc. desc can be any of the
-- following: D_POOL_ID : double * : automation item pool ID (as an integer); edits
-- are propagated to all other automation items that share a pool ID D_POSITION :
-- double * : automation item timeline position in seconds D_LENGTH : double * :
-- automation item length in seconds D_STARTOFFS : double * : automation item start
-- offset in seconds D_PLAYRATE : double * : automation item playback rate
-- D_BASELINE : double * : automation item baseline value in the range [0,1]
-- D_AMPLITUDE : double * : automation item amplitude in the range [-1,1] D_LOOPSRC
-- : double * : nonzero if the automation item contents are looped D_UISEL : double
-- * : nonzero if the automation item is selected in the arrange view D_POOL_QNLEN
-- : double * : automation item pooled source length in quarter notes (setting will
-- affect all pooled instances)
-- @param autoitem__idx integer
-- @param desc string
-- @param value number
-- @param is__set boolean
-- @return number
function TrackEnvelope:get_set_automation_item_info(autoitem__idx, desc, value, is__set)
    return r.GetSetAutomationItemInfo(self.pointer, autoitem__idx, desc, value, is__set)
end

    
--- Get Set Automation Item Info String.
-- Get or set automation item information. autoitem_idx=0 for the first automation
-- item on an envelope, 1 for the second item, etc. returns true on success. desc
-- can be any of the following: P_POOL_NAME : char * : name of the underlying
-- automation item pool P_POOL_EXT:xyz : char * : extension-specific persistent
-- data
-- @param autoitem__idx integer
-- @param desc string
-- @param valuestr_need_big string
-- @param is__set boolean
-- @return valuestr_need_big string
function TrackEnvelope:get_set_automation_item_info_string(autoitem__idx, desc, valuestr_need_big, is__set)
    local retval, valuestr_need_big = r.GetSetAutomationItemInfo_String(self.pointer, autoitem__idx, desc, valuestr_need_big, is__set)
    if retval then
        return valuestr_need_big
    else
        return nil
    end
end

    
--- Get Set Envelope Info String.
-- Gets/sets an attribute string: ACTIVE : active state (bool as a string "0" or
-- "1") ARM : armed state (bool...) VISIBLE : visible state (bool...) SHOWLANE :
-- show envelope in separate lane (bool...) GUID : (read-only) GUID as a string
-- {xyz-....} P_EXT:xyz : extension-specific persistent data Note that when writing
-- some of these attributes you will need to manually update the arrange and/or
-- track panels, see TrackList_AdjustWindows
-- @param parmname string
-- @param string_need_big string
-- @param set_new_value boolean
-- @return string_need_big string
function TrackEnvelope:get_set_envelope_info_string(parmname, string_need_big, set_new_value)
    local retval, string_need_big = r.GetSetEnvelopeInfo_String(self.pointer, parmname, string_need_big, set_new_value)
    if retval then
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
-- @param pool_id integer
-- @param position number
-- @param length number
-- @return integer
function TrackEnvelope:insert_automation_item(pool_id, position, length)
    return r.InsertAutomationItem(self.pointer, pool_id, position, length)
end

    
--- Insert Envelope Point.
-- Insert an envelope point. If setting multiple points at once, set noSort=true,
-- and call Envelope_SortPoints when done. See InsertEnvelopePointEx.
-- @param time number
-- @param value number
-- @param shape integer
-- @param tension number
-- @param selected boolean
-- @param boolean noSortIn optional
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
-- @param autoitem__idx integer
-- @param time number
-- @param value number
-- @param shape integer
-- @param tension number
-- @param selected boolean
-- @param boolean noSortIn optional
-- @return boolean
function TrackEnvelope:insert_envelope_point_ex(autoitem__idx, time, value, shape, tension, selected, boolean)
    local boolean = boolean or nil
    return r.InsertEnvelopePointEx(self.pointer, autoitem__idx, time, value, shape, tension, selected, boolean)
end

    
--- Set Envelope Point.
-- Set attributes of an envelope point. Values that are not supplied will be
-- ignored. If setting multiple points at once, set noSort=true, and call
-- Envelope_SortPoints when done. See SetEnvelopePointEx.
-- @param pt_idx integer
-- @param number timeIn optional
-- @param number valueIn optional
-- @param integer shapeIn optional
-- @param number tensionIn optional
-- @param boolean selectedIn optional
-- @param boolean noSortIn optional
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
-- @param autoitem__idx integer
-- @param pt_idx integer
-- @param number timeIn optional
-- @param number valueIn optional
-- @param integer shapeIn optional
-- @param number tensionIn optional
-- @param boolean selectedIn optional
-- @param boolean noSortIn optional
-- @return boolean
function TrackEnvelope:set_envelope_point_ex(autoitem__idx, pt_idx, number, number, integer, number, boolean, boolean)
    local number = number or nil
    local integer = integer or nil
    local boolean = boolean or nil
    return r.SetEnvelopePointEx(self.pointer, autoitem__idx, pt_idx, number, number, integer, number, boolean, boolean)
end

    
--- Set Envelope State Chunk.
-- Sets the RPPXML state of an envelope, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string
-- @param is_undo boolean
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
-- @param take_envelopes_use_project_time boolean
-- @return BR_Envelope
function TrackEnvelope:env_alloc(take_envelopes_use_project_time)
    return r.BR_EnvAlloc(self.pointer, take_envelopes_use_project_time)
end

return TrackEnvelope
