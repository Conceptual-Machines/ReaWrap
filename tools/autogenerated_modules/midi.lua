-- @description MIDI: Provide implementation for MIDI functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_item = require('media_item')
local media_item_take = require('media_item_take')
local media_track = require('media_track')


local MIDI = {}



--- Create new MIDI instance.
-- @return MIDI table.
function MIDI:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the MIDI logger.
-- @param ... (varargs) Messages to log.
function MIDI:log(...)
    local logger = helpers.log_func('MIDI')
    logger(...)
    return nil
end

    
--- Count Evts.
-- Count the number of notes, CC events, and text/sysex events in a given MIDI
-- item.
-- @return notecnt integer
-- @return ccevtcnt integer
-- @return textsyxevtcnt integer
function MIDI:count_evts()
    local retval, notecnt, ccevtcnt, textsyxevtcnt = r.MIDI_CountEvts(self.pointer)
    if retval then
        return notecnt, ccevtcnt, textsyxevtcnt
    else
        return nil
    end
end

    
--- Delete Cc.
-- Delete a MIDI CC event.
-- @param cc_idx integer
-- @return boolean
function MIDI:delete_cc(cc_idx)
    return r.MIDI_DeleteCC(self.pointer, cc_idx)
end

    
--- Delete Evt.
-- Delete a MIDI event.
-- @param evt_idx integer
-- @return boolean
function MIDI:delete_evt(evt_idx)
    return r.MIDI_DeleteEvt(self.pointer, evt_idx)
end

    
--- Delete Note.
-- Delete a MIDI note.
-- @param note_idx integer
-- @return boolean
function MIDI:delete_note(note_idx)
    return r.MIDI_DeleteNote(self.pointer, note_idx)
end

    
--- Delete Text Sysex Evt.
-- Delete a MIDI text or sysex event.
-- @param textsyxevt_idx integer
-- @return boolean
function MIDI:delete_text_sysex_evt(textsyxevt_idx)
    return r.MIDI_DeleteTextSysexEvt(self.pointer, textsyxevt_idx)
end

    
--- Disable Sort.
-- Disable sorting for all MIDI insert, delete, get and set functions, until
-- MIDI_Sort is called.
function MIDI:disable_sort()
    return r.MIDI_DisableSort(self.pointer)
end

    
--- Enum Sel Cc.
-- Returns the index of the next selected MIDI CC event after ccidx (-1 if there
-- are no more selected events).
-- @param cc_idx integer
-- @return integer
function MIDI:enum_sel_cc(cc_idx)
    return r.MIDI_EnumSelCC(self.pointer, cc_idx)
end

    
--- Enum Sel Evts.
-- Returns the index of the next selected MIDI event after evtidx (-1 if there are
-- no more selected events).
-- @param evt_idx integer
-- @return integer
function MIDI:enum_sel_evts(evt_idx)
    return r.MIDI_EnumSelEvts(self.pointer, evt_idx)
end

    
--- Enum Sel Notes.
-- Returns the index of the next selected MIDI note after noteidx (-1 if there are
-- no more selected events).
-- @param note_idx integer
-- @return integer
function MIDI:enum_sel_notes(note_idx)
    return r.MIDI_EnumSelNotes(self.pointer, note_idx)
end

    
--- Enum Sel Text Sysex Evts.
-- Returns the index of the next selected MIDI text/sysex event after textsyxidx
-- (-1 if there are no more selected events).
-- @param textsyx_idx integer
-- @return integer
function MIDI:enum_sel_text_sysex_evts(textsyx_idx)
    return r.MIDI_EnumSelTextSysexEvts(self.pointer, textsyx_idx)
end

    
--- Get All Evts.
-- Get all MIDI data. MIDI buffer is returned as a list of { int offset, char flag,
-- int msglen, unsigned char msg[] }. offset: MIDI ticks from previous event flag:
-- &1=selected &2=muted flag high 4 bits for CC shape: &16=linear, &32=slow
-- start/end, &16|32=fast start, &64=fast end, &64|16=bezier msg: the MIDI message.
-- A meta-event of type 0xF followed by 'CCBZ ' and 5 more bytes represents bezier
-- curve data for the previous MIDI event: 1 byte for the bezier type (usually 0)
-- and 4 bytes for the bezier tension as a float. For tick intervals longer than a
-- 32 bit word can represent, zero-length meta events may be placed between valid
-- events. See MIDI_SetAllEvts.
-- @return buf string
function MIDI:get_all_evts()
    local retval, buf = r.MIDI_GetAllEvts(self.pointer)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Cc.
-- Get MIDI CC event properties.
-- @param cc_idx integer
-- @return selected boolean
-- @return muted boolean
-- @return ppqpos number
-- @return chanmsg integer
-- @return chan integer
-- @return msg2 integer
-- @return msg3 integer
function MIDI:get_cc(cc_idx)
    local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = r.MIDI_GetCC(self.pointer, cc_idx)
    if retval then
        return selected, muted, ppqpos, chanmsg, chan, msg2, msg3
    else
        return nil
    end
end

    
--- Get Cc Shape.
-- Get CC shape and bezier tension. See MIDI_GetCC, MIDI_SetCCShape
-- @param cc_idx integer
-- @return shape integer
-- @return beztension number
function MIDI:get_cc_shape(cc_idx)
    local retval, shape, beztension = r.MIDI_GetCCShape(self.pointer, cc_idx)
    if retval then
        return shape, beztension
    else
        return nil
    end
end

    
--- Get Evt.
-- Get MIDI event properties.
-- @param evt_idx integer
-- @return selected boolean
-- @return muted boolean
-- @return ppqpos number
-- @return msg string
function MIDI:get_evt(evt_idx)
    local retval, selected, muted, ppqpos, msg = r.MIDI_GetEvt(self.pointer, evt_idx)
    if retval then
        return selected, muted, ppqpos, msg
    else
        return nil
    end
end

    
--- Get Grid.
-- Returns the most recent MIDI editor grid size for this MIDI take, in QN. Swing
-- is between 0 and 1. Note length is 0 if it follows the grid size.
-- @return number swing
-- @return number noteLen
function MIDI:get_grid()
    local retval, number, number = r.MIDI_GetGrid(self.pointer)
    if retval then
        return number, number
    else
        return nil
    end
end

    
--- Get Hash.
-- Get a string that only changes when the MIDI data changes. If notesonly==true,
-- then the string changes only when the MIDI notes change. See MIDI_GetTrackHash
-- @param notesonly boolean
-- @return hash string
function MIDI:get_hash(notesonly)
    local retval, hash = r.MIDI_GetHash(self.pointer, notesonly)
    if retval then
        return hash
    else
        return nil
    end
end

    
--- Get Note.
-- Get MIDI note properties.
-- @param note_idx integer
-- @return selected boolean
-- @return muted boolean
-- @return startppqpos number
-- @return endppqpos number
-- @return chan integer
-- @return pitch integer
-- @return vel integer
function MIDI:get_note(note_idx)
    local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = r.MIDI_GetNote(self.pointer, note_idx)
    if retval then
        return selected, muted, startppqpos, endppqpos, chan, pitch, vel
    else
        return nil
    end
end

    
--- Get Ppq Pos End Of Measure.
-- Returns the MIDI tick (ppq) position corresponding to the end of the measure.
-- @param ppqpos number
-- @return number
function MIDI:get_ppq_pos_end_of_measure(ppqpos)
    return r.MIDI_GetPPQPos_EndOfMeasure(self.pointer, ppqpos)
end

    
--- Get Ppq Pos Start Of Measure.
-- Returns the MIDI tick (ppq) position corresponding to the start of the measure.
-- @param ppqpos number
-- @return number
function MIDI:get_ppq_pos_start_of_measure(ppqpos)
    return r.MIDI_GetPPQPos_StartOfMeasure(self.pointer, ppqpos)
end

    
--- Get Ppq Pos From Proj Qn.
-- Returns the MIDI tick (ppq) position corresponding to a specific project time in
-- quarter notes.
-- @param projqn number
-- @return number
function MIDI:get_ppq_pos_from_proj_qn(projqn)
    return r.MIDI_GetPPQPosFromProjQN(self.pointer, projqn)
end

    
--- Get Ppq Pos From Proj Time.
-- Returns the MIDI tick (ppq) position corresponding to a specific project time in
-- seconds.
-- @param projtime number
-- @return number
function MIDI:get_ppq_pos_from_proj_time(projtime)
    return r.MIDI_GetPPQPosFromProjTime(self.pointer, projtime)
end

    
--- Get Proj Qn From Ppq Pos.
-- Returns the project time in quarter notes corresponding to a specific MIDI tick
-- (ppq) position.
-- @param ppqpos number
-- @return number
function MIDI:get_proj_qn_from_ppq_pos(ppqpos)
    return r.MIDI_GetProjQNFromPPQPos(self.pointer, ppqpos)
end

    
--- Get Proj Time From Ppq Pos.
-- Returns the project time in seconds corresponding to a specific MIDI tick (ppq)
-- position.
-- @param ppqpos number
-- @return number
function MIDI:get_proj_time_from_ppq_pos(ppqpos)
    return r.MIDI_GetProjTimeFromPPQPos(self.pointer, ppqpos)
end

    
--- Get Recent Input Event.
-- Gets a recent MIDI input event from the global history. idx=0 for the most
-- recent event, which also latches to the latest MIDI event state (to get a more
-- recent list, calling with idx=0 is necessary). idx=1 next most recent event,
-- returns a non-zero sequence number for the event, or zero if no more events.
-- tsOut will be set to the timestamp in samples relative to the current position
-- (0 is current, -48000 is one second ago, etc). devIdxOut will have the low 16
-- bits set to the input device index, and 0x10000 will be set if device was
-- enabled only for control. projPosOut will be set to project position in seconds
-- if project was playing back at time of event, otherwise -1. Large SysEx events
-- will not be included in this event list.
-- @param _idx integer
-- @return buf string
-- @return ts integer
-- @return dev__idx integer
-- @return proj_pos number
-- @return proj_loop_cnt integer
function MIDI:get_recent_input_event(_idx)
    local retval, buf, ts, dev__idx, proj_pos, proj_loop_cnt = r.MIDI_GetRecentInputEvent(_idx)
    if retval then
        return buf, ts, dev__idx, proj_pos, proj_loop_cnt
    else
        return nil
    end
end

    
--- Get Scale.
-- Get the active scale in the media source, if any. root 0=C, 1=C#, etc. scale
-- &0x1=root, &0x2=minor 2nd, &0x4=major 2nd, &0x8=minor 3rd, &0xF=fourth, etc.
-- @return root integer
-- @return scale integer
-- @return name string
function MIDI:get_scale()
    local retval, root, scale, name = r.MIDI_GetScale(self.pointer)
    if retval then
        return root, scale, name
    else
        return nil
    end
end

    
--- Get Text Sysex Evt.
-- Get MIDI meta-event properties. Allowable types are -1:sysex (msg should not
-- include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event.
-- For all other meta-messages, type is returned as -2 and msg returned as all
-- zeroes. See MIDI_GetEvt.
-- @param textsyxevt_idx integer
-- @param boolean selected optional
-- @param boolean muted optional
-- @param number ppqpos optional
-- @param integer type optional
-- @param string msg optional
-- @return boolean selected
-- @return boolean muted
-- @return number ppqpos
-- @return integer type
-- @return string msg
function MIDI:get_text_sysex_evt(textsyxevt_idx, boolean, boolean, number, integer, string)
    local boolean = boolean or nil
    local number = number or nil
    local integer = integer or nil
    local string = string or nil
    local retval, boolean, boolean, number, integer, string = r.MIDI_GetTextSysexEvt(self.pointer, textsyxevt_idx, boolean, boolean, number, integer, string)
    if retval then
        return boolean, boolean, number, integer, string
    else
        return nil
    end
end

    
--- Get Track Hash.
-- Get a string that only changes when the MIDI data changes. If notesonly==true,
-- then the string changes only when the MIDI notes change. See MIDI_GetHash
-- @param notesonly boolean
-- @return hash string
function MIDI:get_track_hash(notesonly)
    local retval, hash = r.MIDI_GetTrackHash(self.pointer, notesonly)
    if retval then
        return hash
    else
        return nil
    end
end

    
--- Insert Cc.
-- Insert a new MIDI CC event.
-- @param selected boolean
-- @param muted boolean
-- @param ppqpos number
-- @param chanmsg integer
-- @param chan integer
-- @param msg2 integer
-- @param msg3 integer
-- @return boolean
function MIDI:insert_cc(selected, muted, ppqpos, chanmsg, chan, msg2, msg3)
    return r.MIDI_InsertCC(self.pointer, selected, muted, ppqpos, chanmsg, chan, msg2, msg3)
end

    
--- Insert Evt.
-- Insert a new MIDI event.
-- @param selected boolean
-- @param muted boolean
-- @param ppqpos number
-- @param bytestr string
-- @return boolean
function MIDI:insert_evt(selected, muted, ppqpos, bytestr)
    return r.MIDI_InsertEvt(self.pointer, selected, muted, ppqpos, bytestr)
end

    
--- Insert Note.
-- Insert a new MIDI note. Set noSort if inserting multiple events, then call
-- MIDI_Sort when done.
-- @param selected boolean
-- @param muted boolean
-- @param startppqpos number
-- @param endppqpos number
-- @param chan integer
-- @param pitch integer
-- @param vel integer
-- @param boolean noSortIn optional
-- @return boolean
function MIDI:insert_note(selected, muted, startppqpos, endppqpos, chan, pitch, vel, boolean)
    local boolean = boolean or nil
    return r.MIDI_InsertNote(self.pointer, selected, muted, startppqpos, endppqpos, chan, pitch, vel, boolean)
end

    
--- Insert Text Sysex Evt.
-- Insert a new MIDI text or sysex event. Allowable types are -1:sysex (msg should
-- not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation
-- event.
-- @param selected boolean
-- @param muted boolean
-- @param ppqpos number
-- @param type integer
-- @param bytestr string
-- @return boolean
function MIDI:insert_text_sysex_evt(selected, muted, ppqpos, type, bytestr)
    return r.MIDI_InsertTextSysexEvt(self.pointer, selected, muted, ppqpos, type, bytestr)
end

    
--- Refresh Editors.
-- Synchronously updates any open MIDI editors for MIDI take
function MIDI:refresh_editors()
    return r.MIDI_RefreshEditors(self.pointer)
end

    
--- Select All.
-- Select or deselect all MIDI content.
-- @param select boolean
function MIDI:select_all(select)
    return r.MIDI_SelectAll(self.pointer, select)
end

    
--- Set All Evts.
-- Set all MIDI data. MIDI buffer is passed in as a list of { int offset, char
-- flag, int msglen, unsigned char msg[] }. offset: MIDI ticks from previous event
-- flag: &1=selected &2=muted flag high 4 bits for CC shape: &16=linear, &32=slow
-- start/end, &16|32=fast start, &64=fast end, &64|16=bezier msg: the MIDI message.
-- A meta-event of type 0xF followed by 'CCBZ ' and 5 more bytes represents bezier
-- curve data for the previous MIDI event: 1 byte for the bezier type (usually 0)
-- and 4 bytes for the bezier tension as a float. For tick intervals longer than a
-- 32 bit word can represent, zero-length meta events may be placed between valid
-- events. See MIDI_GetAllEvts.
-- @param buf string
-- @return boolean
function MIDI:set_all_evts(buf)
    return r.MIDI_SetAllEvts(self.pointer, buf)
end

    
--- Set Cc.
-- Set MIDI CC event properties. Properties passed as NULL will not be set. set
-- noSort if setting multiple events, then call MIDI_Sort when done.
-- @param cc_idx integer
-- @param boolean selectedIn optional
-- @param boolean mutedIn optional
-- @param number ppqposIn optional
-- @param integer chanmsgIn optional
-- @param integer chanIn optional
-- @param integer msg2In optional
-- @param integer msg3In optional
-- @param boolean noSortIn optional
-- @return boolean
function MIDI:set_cc(cc_idx, boolean, boolean, number, integer, integer, integer, integer, boolean)
    local boolean = boolean or nil
    local number = number or nil
    local integer = integer or nil
    return r.MIDI_SetCC(self.pointer, cc_idx, boolean, boolean, number, integer, integer, integer, integer, boolean)
end

    
--- Set Cc Shape.
-- Set CC shape and bezier tension. set noSort if setting multiple events, then
-- call MIDI_Sort when done. See MIDI_SetCC, MIDI_GetCCShape
-- @param cc_idx integer
-- @param shape integer
-- @param beztension number
-- @param boolean noSortIn optional
-- @return boolean
function MIDI:set_cc_shape(cc_idx, shape, beztension, boolean)
    local boolean = boolean or nil
    return r.MIDI_SetCCShape(self.pointer, cc_idx, shape, beztension, boolean)
end

    
--- Set Evt.
-- Set MIDI event properties. Properties passed as NULL will not be set.  set
-- noSort if setting multiple events, then call MIDI_Sort when done.
-- @param evt_idx integer
-- @param boolean selectedIn optional
-- @param boolean mutedIn optional
-- @param number ppqposIn optional
-- @param string msg optional
-- @param boolean noSortIn optional
-- @return boolean
function MIDI:set_evt(evt_idx, boolean, boolean, number, string, boolean)
    local boolean = boolean or nil
    local number = number or nil
    local string = string or nil
    return r.MIDI_SetEvt(self.pointer, evt_idx, boolean, boolean, number, string, boolean)
end

    
--- Set Item Extents.
-- Set the start/end positions of a media item that contains a MIDI take.
-- @param start_qn number
-- @param end_qn number
-- @return boolean
function MIDI:set_item_extents(start_qn, end_qn)
    return r.MIDI_SetItemExtents(self.pointer, start_qn, end_qn)
end

    
--- Set Note.
-- Set MIDI note properties. Properties passed as NULL (or negative values) will
-- not be set. Set noSort if setting multiple events, then call MIDI_Sort when
-- done. Setting multiple note start positions at once is done more safely by
-- deleting and re-inserting the notes.
-- @param note_idx integer
-- @param boolean selectedIn optional
-- @param boolean mutedIn optional
-- @param number startppqposIn optional
-- @param number endppqposIn optional
-- @param integer chanIn optional
-- @param integer pitchIn optional
-- @param integer velIn optional
-- @param boolean noSortIn optional
-- @return boolean
function MIDI:set_note(note_idx, boolean, boolean, number, number, integer, integer, integer, boolean)
    local boolean = boolean or nil
    local number = number or nil
    local integer = integer or nil
    return r.MIDI_SetNote(self.pointer, note_idx, boolean, boolean, number, number, integer, integer, integer, boolean)
end

    
--- Set Text Sysex Evt.
-- Set MIDI text or sysex event properties. Properties passed as NULL will not be
-- set. Allowable types are -1:sysex (msg should not include bounding F0..F7),
-- 1-14:MIDI text event types, 15=REAPER notation event. set noSort if setting
-- multiple events, then call MIDI_Sort when done.
-- @param textsyxevt_idx integer
-- @param boolean selectedIn optional
-- @param boolean mutedIn optional
-- @param number ppqposIn optional
-- @param integer typeIn optional
-- @param string msg optional
-- @param boolean noSortIn optional
-- @return boolean
function MIDI:set_text_sysex_evt(textsyxevt_idx, boolean, boolean, number, integer, string, boolean)
    local boolean = boolean or nil
    local number = number or nil
    local integer = integer or nil
    local string = string or nil
    return r.MIDI_SetTextSysexEvt(self.pointer, textsyxevt_idx, boolean, boolean, number, integer, string, boolean)
end

    
--- Sort.
-- Sort MIDI events after multiple calls to MIDI_SetNote, MIDI_SetCC, etc.
function MIDI:sort()
    return r.MIDI_Sort(self.pointer)
end

return MIDI
