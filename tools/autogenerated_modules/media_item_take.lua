-- @description Provide implementation for MediaItemTake functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')
local pcm_source = require('pcm_source')


local MediaItemTake = {}



--- Create new MediaItemTake instance.
-- @param take userdata. The pointer to Reaper MediaItem_Take*
-- @return MediaItemTake table.
function MediaItemTake:new(take)
    local obj = {
        pointer_type = "MediaItem_Take*",
        pointer = take
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the MediaItemTake logger.
-- @param ... (varargs) Messages to log.
function MediaItemTake:log(...)
    local logger = helpers.log_func('MediaItemTake')
    logger(...)
    return nil
end

    
--- Count Take Envelopes.
-- See GetTakeEnvelope
-- @return integer
function MediaItemTake:count_take_envelopes()
    return r.CountTakeEnvelopes(self.pointer)
end

    
--- Create Take Audio Accessor.
-- Create an audio accessor object for this take. Must only call from the main
-- thread. See CreateTrackAudioAccessor, DestroyAudioAccessor,
-- AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime,
-- GetAudioAccessorSamples.
-- @return AudioAccessor table
function MediaItemTake:create_take_audio_accessor()
    local result = r.CreateTakeAudioAccessor(self.pointer)
    return audio_accessor.AudioAccessor:new(result)
end

    
--- Delete Take Marker.
-- Delete a take marker. Note that idx will change for all following take markers.
-- See GetNumTakeMarkers, GetTakeMarker, SetTakeMarker
-- @param idx integer.
-- @return boolean
function MediaItemTake:delete_take_marker(idx)
    return r.DeleteTakeMarker(self.pointer, idx)
end

    
--- Delete Take Stretch Markers.
-- Deletes one or more stretch markers. Returns number of stretch markers deleted.
-- @param idx integer.
-- @param integer countIn Optional.
-- @return integer
function MediaItemTake:delete_take_stretch_markers(idx, integer)
    local integer = integer or nil
    return r.DeleteTakeStretchMarkers(self.pointer, idx, integer)
end

    
--- Get Item.
-- Get parent item of media item take
-- @return MediaItem table
function MediaItemTake:get_item()
    local result = r.GetMediaItemTake_Item(self.pointer)
    return media_item.MediaItem:new(result)
end

    
--- Get Peaks.
-- Gets block of peak samples to buf. Note that the peak samples are interleaved,
-- but in two or three blocks (maximums, then minimums, then extra). Return value
-- has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000),
-- then a bit to signify whether extra_type was available (0x1000000). extra_type
-- can be 115 ('s') for spectral information, which will return peak samples as
-- integers with the low 15 bits frequency, next 14 bits tonality.
-- @param peakrate number.
-- @param starttime number.
-- @param numchannels integer.
-- @param numsamplesperchannel integer.
-- @param want_extra_type integer.
-- @param buf reaper.array.
-- @return integer
function MediaItemTake:get_peaks(peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
    return r.GetMediaItemTake_Peaks(self.pointer, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
end

    
--- Get Source.
-- Get media source of media item take
-- @return PCM_source table
function MediaItemTake:get_source()
    local result = r.GetMediaItemTake_Source(self.pointer)
    return pcm_source.PCM_source:new(result)
end

    
--- Get Track.
-- Get parent track of media item take
-- @return MediaTrack table
function MediaItemTake:get_track()
    local result = r.GetMediaItemTake_Track(self.pointer)
    return media_track.MediaTrack:new(result)
end

    
--- Constants for MediaItemTake:get_info_value.
-- @field D_STARTOFFS double *: start offset in source media, in seconds
-- @field D_VOL double *: take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped
-- @field D_PAN double *: take pan, -1..1
-- @field D_PANLAW double *: take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc
-- @field D_PLAYRATE double *: take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc
-- @field D_PITCH double *: take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc
-- @field B_PPITCH boolean: preserve pitch when changing playback rate
-- @field I_LASTY number: Y-position (relative to top of track) in pixels (read-only)
-- @field I_LASTH number: height in pixels (read-only)
-- @field I_CHANMODE number: channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right
-- @field I_PITCHMODE number: pitch shifter mode, -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter
-- @field I_STRETCHFLAGS number: int *stretch marker flags (&7 mask for mode override0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo)
-- @field F_STRETCHFADESIZE float *: stretch marker fade size in seconds (0.0025 default)
-- @field I_RECPASSID number: record pass ID
-- @field I_TAKEFX_NCH number: number of internal audio channels for per-take FX to use (OK to call with setNewValue, but the returned value is read-only)
-- @field I_CUSTOMCOLOR number: custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
-- @field IP_TAKENUMBER number: take number (read-only, returns the take number directly)
-- @field P_TRACK MediaTrack: pointer to MediaTrack (read-only)
-- @field P_ITEM MediaItem: pointer to MediaItem (read-only)
-- @field P_SOURCE PCM_source: PCM_source *. Note that if setting this, you should first retrieve the old source, set the new, THEN delete the old.
MediaItemTake.GetInfoValueConstants{
    D_STARTOFFS = "D_STARTOFFS",
    D_VOL = "D_VOL",
    D_PAN = "D_PAN",
    D_PANLAW = "D_PANLAW",
    D_PLAYRATE = "D_PLAYRATE",
    D_PITCH = "D_PITCH",
    B_PPITCH = "B_PPITCH",
    I_LASTY = "I_LASTY",
    I_LASTH = "I_LASTH",
    I_CHANMODE = "I_CHANMODE",
    I_PITCHMODE = "I_PITCHMODE",
    I_STRETCHFLAGS = "I_STRETCHFLAGS",
    F_STRETCHFADESIZE = "F_STRETCHFADESIZE",
    I_RECPASSID = "I_RECPASSID",
    I_TAKEFX_NCH = "I_TAKEFX_NCH",
    I_CUSTOMCOLOR = "I_CUSTOMCOLOR",
    IP_TAKENUMBER = "IP_TAKENUMBER",
    P_TRACK = "P_TRACK",
    P_ITEM = "P_ITEM",
    P_SOURCE = "P_SOURCE",
}
    
--- Get Info Value.
-- Get media item take numerical-value attributes.
-- @param parm_name string. MediaItemTake.GetInfoValueConstants
-- @return number
function MediaItemTake:get_info_value(parm_name)
    return r.GetMediaItemTakeInfo_Value(self.pointer, parm_name)
end

    
--- Get Num Take Markers.
-- Returns number of take markers. See GetTakeMarker, SetTakeMarker,
-- DeleteTakeMarker
-- @return integer
function MediaItemTake:get_num_take_markers()
    return r.GetNumTakeMarkers(self.pointer)
end

    
--- Constants for MediaItemTake:get_set_info_string.
-- @field P_NAME string: take name
-- @field P_EXT xyz: xyzchar *extension-specific persistent data
-- @field GUID GUID *: 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
MediaItemTake.GetSetInfoStringConstants{
    P_NAME = "P_NAME",
    P_EXT = "P_EXT",
    GUID = "GUID",
}
    
--- Get Set Info String.
-- Gets/sets a take attribute string:
-- @param parm_name string. MediaItemTake.GetSetInfoStringConstants
-- @param string_need_big string.
-- @param set_new_value boolean.
-- @return ret_val boolean
-- @return string_need_big string
function MediaItemTake:get_set_info_string(parm_name, string_need_big, set_new_value)
    return r.GetSetMediaItemTakeInfo_String(self.pointer, parm_name, string_need_big, set_new_value)
end

    
--- Get Take Envelope.
-- @param env_idx integer.
-- @return TrackEnvelope table
function MediaItemTake:get_take_envelope(env_idx)
    local result = r.GetTakeEnvelope(self.pointer, env_idx)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Take Envelope By Name.
-- @param env_name string.
-- @return TrackEnvelope table
function MediaItemTake:get_take_envelope_by_name(env_name)
    local result = r.GetTakeEnvelopeByName(self.pointer, env_name)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Take Marker.
-- Get information about a take marker. Returns the position in media item source
-- time, or -1 if the take marker does not exist. See GetNumTakeMarkers,
-- SetTakeMarker, DeleteTakeMarker
-- @param idx integer.
-- @return ret_val number
-- @return name string
-- @return integer color
function MediaItemTake:get_take_marker(idx)
    return r.GetTakeMarker(self.pointer, idx)
end

    
--- Get Take Name.
-- returns NULL if the take is not valid
-- @return string
function MediaItemTake:get_take_name()
    return r.GetTakeName(self.pointer)
end

    
--- Get Take Num Stretch Markers.
-- Returns number of stretch markers in take
-- @return integer
function MediaItemTake:get_take_num_stretch_markers()
    return r.GetTakeNumStretchMarkers(self.pointer)
end

    
--- Get Take Stretch Marker.
-- Gets information on a stretch marker, idx is 0..n. Returns -1 if stretch marker
-- not valid. posOut will be set to position in item, srcposOutOptional will be set
-- to source media position. Returns index. if input index is -1, the following
-- marker is found using position (or source position if position is -1). If
-- position/source position are used to find marker position, their values are not
-- updated.
-- @param idx integer.
-- @return ret_val integer
-- @return pos number
-- @return number srcpos
function MediaItemTake:get_take_stretch_marker(idx)
    return r.GetTakeStretchMarker(self.pointer, idx)
end

    
--- Get Take Stretch Marker Slope.
-- See SetTakeStretchMarkerSlope
-- @param idx integer.
-- @return number
function MediaItemTake:get_take_stretch_marker_slope(idx)
    return r.GetTakeStretchMarkerSlope(self.pointer, idx)
end

    
--- Count Evts.
-- Count the number of notes, CC events, and text/sysex events in a given MIDI
-- item.
-- @return ret_val integer
-- @return notecnt integer
-- @return ccevtcnt integer
-- @return textsyxevtcnt integer
function MediaItemTake:count_evts()
    return r.MIDI_CountEvts(self.pointer)
end

    
--- Delete Cc.
-- Delete a MIDI CC event.
-- @param cc_idx integer.
-- @return boolean
function MediaItemTake:delete_cc(cc_idx)
    return r.MIDI_DeleteCC(self.pointer, cc_idx)
end

    
--- Delete Evt.
-- Delete a MIDI event.
-- @param evt_idx integer.
-- @return boolean
function MediaItemTake:delete_evt(evt_idx)
    return r.MIDI_DeleteEvt(self.pointer, evt_idx)
end

    
--- Delete Note.
-- Delete a MIDI note.
-- @param note_idx integer.
-- @return boolean
function MediaItemTake:delete_note(note_idx)
    return r.MIDI_DeleteNote(self.pointer, note_idx)
end

    
--- Delete Text Sysex Evt.
-- Delete a MIDI text or sysex event.
-- @param textsyxevt_idx integer.
-- @return boolean
function MediaItemTake:delete_text_sysex_evt(textsyxevt_idx)
    return r.MIDI_DeleteTextSysexEvt(self.pointer, textsyxevt_idx)
end

    
--- Disable Sort.
-- Disable sorting for all MIDI insert, delete, get and set functions, until
-- MIDI_Sort is called.
function MediaItemTake:disable_sort()
    return r.MIDI_DisableSort(self.pointer)
end

    
--- Enum Sel Cc.
-- Returns the index of the next selected MIDI CC event after ccidx (-1 if there
-- are no more selected events).
-- @param cc_idx integer.
-- @return integer
function MediaItemTake:enum_sel_cc(cc_idx)
    return r.MIDI_EnumSelCC(self.pointer, cc_idx)
end

    
--- Enum Sel Evts.
-- Returns the index of the next selected MIDI event after evtidx (-1 if there are
-- no more selected events).
-- @param evt_idx integer.
-- @return integer
function MediaItemTake:enum_sel_evts(evt_idx)
    return r.MIDI_EnumSelEvts(self.pointer, evt_idx)
end

    
--- Enum Sel Notes.
-- Returns the index of the next selected MIDI note after noteidx (-1 if there are
-- no more selected events).
-- @param note_idx integer.
-- @return integer
function MediaItemTake:enum_sel_notes(note_idx)
    return r.MIDI_EnumSelNotes(self.pointer, note_idx)
end

    
--- Enum Sel Text Sysex Evts.
-- Returns the index of the next selected MIDI text/sysex event after textsyxidx
-- (-1 if there are no more selected events).
-- @param textsyx_idx integer.
-- @return integer
function MediaItemTake:enum_sel_text_sysex_evts(textsyx_idx)
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
-- @return ret_val boolean
-- @return buf string
function MediaItemTake:get_all_evts()
    return r.MIDI_GetAllEvts(self.pointer)
end

    
--- Get Cc.
-- Get MIDI CC event properties.
-- @param cc_idx integer.
-- @return ret_val boolean
-- @return selected boolean
-- @return muted boolean
-- @return ppqpos number
-- @return chanmsg integer
-- @return chan integer
-- @return msg2 integer
-- @return msg3 integer
function MediaItemTake:get_cc(cc_idx)
    return r.MIDI_GetCC(self.pointer, cc_idx)
end

    
--- Get Cc Shape.
-- Get CC shape and bezier tension. See MIDI_GetCC, MIDI_SetCCShape
-- @param cc_idx integer.
-- @return ret_val boolean
-- @return shape integer
-- @return beztension number
function MediaItemTake:get_cc_shape(cc_idx)
    return r.MIDI_GetCCShape(self.pointer, cc_idx)
end

    
--- Get Evt.
-- Get MIDI event properties.
-- @param evt_idx integer.
-- @return ret_val boolean
-- @return selected boolean
-- @return muted boolean
-- @return ppqpos number
-- @return msg string
function MediaItemTake:get_evt(evt_idx)
    return r.MIDI_GetEvt(self.pointer, evt_idx)
end

    
--- Get Grid.
-- Returns the most recent MIDI editor grid size for this MIDI take, in QN. Swing
-- is between 0 and 1. Note length is 0 if it follows the grid size.
-- @return ret_val number
-- @return number swing
-- @return number noteLen
function MediaItemTake:get_grid()
    return r.MIDI_GetGrid(self.pointer)
end

    
--- Get Hash.
-- Get a string that only changes when the MIDI data changes. If notesonly==true,
-- then the string changes only when the MIDI notes change. See MIDI_GetTrackHash
-- @param notesonly boolean.
-- @return ret_val boolean
-- @return hash string
function MediaItemTake:get_hash(notesonly)
    return r.MIDI_GetHash(self.pointer, notesonly)
end

    
--- Get Note.
-- Get MIDI note properties.
-- @param note_idx integer.
-- @return ret_val boolean
-- @return selected boolean
-- @return muted boolean
-- @return startppqpos number
-- @return endppqpos number
-- @return chan integer
-- @return pitch integer
-- @return vel integer
function MediaItemTake:get_note(note_idx)
    return r.MIDI_GetNote(self.pointer, note_idx)
end

    
--- Get Ppq Pos End Of Measure.
-- Returns the MIDI tick (ppq) position corresponding to the end of the measure.
-- @param ppqpos number.
-- @return number
function MediaItemTake:get_ppq_pos_end_of_measure(ppqpos)
    return r.MIDI_GetPPQPos_EndOfMeasure(self.pointer, ppqpos)
end

    
--- Get Ppq Pos Start Of Measure.
-- Returns the MIDI tick (ppq) position corresponding to the start of the measure.
-- @param ppqpos number.
-- @return number
function MediaItemTake:get_ppq_pos_start_of_measure(ppqpos)
    return r.MIDI_GetPPQPos_StartOfMeasure(self.pointer, ppqpos)
end

    
--- Get Ppq Pos From Proj Qn.
-- Returns the MIDI tick (ppq) position corresponding to a specific project time in
-- quarter notes.
-- @param projqn number.
-- @return number
function MediaItemTake:get_ppq_pos_from_proj_qn(projqn)
    return r.MIDI_GetPPQPosFromProjQN(self.pointer, projqn)
end

    
--- Get Ppq Pos From Proj Time.
-- Returns the MIDI tick (ppq) position corresponding to a specific project time in
-- seconds.
-- @param projtime number.
-- @return number
function MediaItemTake:get_ppq_pos_from_proj_time(projtime)
    return r.MIDI_GetPPQPosFromProjTime(self.pointer, projtime)
end

    
--- Get Proj Qn From Ppq Pos.
-- Returns the project time in quarter notes corresponding to a specific MIDI tick
-- (ppq) position.
-- @param ppqpos number.
-- @return number
function MediaItemTake:get_proj_qn_from_ppq_pos(ppqpos)
    return r.MIDI_GetProjQNFromPPQPos(self.pointer, ppqpos)
end

    
--- Get Proj Time From Ppq Pos.
-- Returns the project time in seconds corresponding to a specific MIDI tick (ppq)
-- position.
-- @param ppqpos number.
-- @return number
function MediaItemTake:get_proj_time_from_ppq_pos(ppqpos)
    return r.MIDI_GetProjTimeFromPPQPos(self.pointer, ppqpos)
end

    
--- Get Scale.
-- Get the active scale in the media source, if any. root 0=C, 1=C#, etc. scale
-- &0x1=root, &0x2=minor 2nd, &0x4=major 2nd, &0x8=minor 3rd, &0xF=fourth, etc.
-- @return ret_val boolean
-- @return root integer
-- @return scale integer
-- @return name string
function MediaItemTake:get_scale()
    return r.MIDI_GetScale(self.pointer)
end

    
--- Get Text Sysex Evt.
-- Get MIDI meta-event properties. Allowable types are -1:sysex (msg should not
-- include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event.
-- For all other meta-messages, type is returned as -2 and msg returned as all
-- zeroes. See MIDI_GetEvt.
-- @param textsyxevt_idx integer.
-- @param boolean selected Optional.
-- @param boolean muted Optional.
-- @param number ppqpos Optional.
-- @param integer type Optional.
-- @param string msg Optional.
-- @return ret_val boolean
-- @return boolean selected
-- @return boolean muted
-- @return number ppqpos
-- @return integer type
-- @return string msg
function MediaItemTake:get_text_sysex_evt(textsyxevt_idx, boolean, boolean, number, integer, string)
    local boolean = boolean or nil
    local number = number or nil
    local integer = integer or nil
    local string = string or nil
    return r.MIDI_GetTextSysexEvt(self.pointer, textsyxevt_idx, boolean, boolean, number, integer, string)
end

    
--- Insert Cc.
-- Insert a new MIDI CC event.
-- @param selected boolean.
-- @param muted boolean.
-- @param ppqpos number.
-- @param chanmsg integer.
-- @param chan integer.
-- @param msg2 integer.
-- @param msg3 integer.
-- @return boolean
function MediaItemTake:insert_cc(selected, muted, ppqpos, chanmsg, chan, msg2, msg3)
    return r.MIDI_InsertCC(self.pointer, selected, muted, ppqpos, chanmsg, chan, msg2, msg3)
end

    
--- Insert Evt.
-- Insert a new MIDI event.
-- @param selected boolean.
-- @param muted boolean.
-- @param ppqpos number.
-- @param bytestr string.
-- @return boolean
function MediaItemTake:insert_evt(selected, muted, ppqpos, bytestr)
    return r.MIDI_InsertEvt(self.pointer, selected, muted, ppqpos, bytestr)
end

    
--- Insert Note.
-- Insert a new MIDI note. Set noSort if inserting multiple events, then call
-- MIDI_Sort when done.
-- @param selected boolean.
-- @param muted boolean.
-- @param startppqpos number.
-- @param endppqpos number.
-- @param chan integer.
-- @param pitch integer.
-- @param vel integer.
-- @param boolean noSortIn Optional.
-- @return boolean
function MediaItemTake:insert_note(selected, muted, startppqpos, endppqpos, chan, pitch, vel, boolean)
    local boolean = boolean or nil
    return r.MIDI_InsertNote(self.pointer, selected, muted, startppqpos, endppqpos, chan, pitch, vel, boolean)
end

    
--- Insert Text Sysex Evt.
-- Insert a new MIDI text or sysex event. Allowable types are -1:sysex (msg should
-- not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation
-- event.
-- @param selected boolean.
-- @param muted boolean.
-- @param ppqpos number.
-- @param type integer.
-- @param bytestr string.
-- @return boolean
function MediaItemTake:insert_text_sysex_evt(selected, muted, ppqpos, type, bytestr)
    return r.MIDI_InsertTextSysexEvt(self.pointer, selected, muted, ppqpos, type, bytestr)
end

    
--- Refresh Editors.
-- Synchronously updates any open MIDI editors for MIDI take
function MediaItemTake:refresh_editors()
    return r.MIDI_RefreshEditors(self.pointer)
end

    
--- Select All.
-- Select or deselect all MIDI content.
-- @param select boolean.
function MediaItemTake:select_all(select)
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
-- @param buf string.
-- @return boolean
function MediaItemTake:set_all_evts(buf)
    return r.MIDI_SetAllEvts(self.pointer, buf)
end

    
--- Set Cc.
-- Set MIDI CC event properties. Properties passed as NULL will not be set. set
-- noSort if setting multiple events, then call MIDI_Sort when done.
-- @param cc_idx integer.
-- @param boolean selectedIn Optional.
-- @param boolean mutedIn Optional.
-- @param number ppqposIn Optional.
-- @param integer chanmsgIn Optional.
-- @param integer chanIn Optional.
-- @param integer msg2In Optional.
-- @param integer msg3In Optional.
-- @param boolean noSortIn Optional.
-- @return boolean
function MediaItemTake:set_cc(cc_idx, boolean, boolean, number, integer, integer, integer, integer, boolean)
    local boolean = boolean or nil
    local number = number or nil
    local integer = integer or nil
    return r.MIDI_SetCC(self.pointer, cc_idx, boolean, boolean, number, integer, integer, integer, integer, boolean)
end

    
--- Set Cc Shape.
-- Set CC shape and bezier tension. set noSort if setting multiple events, then
-- call MIDI_Sort when done. See MIDI_SetCC, MIDI_GetCCShape
-- @param cc_idx integer.
-- @param shape integer.
-- @param beztension number.
-- @param boolean noSortIn Optional.
-- @return boolean
function MediaItemTake:set_cc_shape(cc_idx, shape, beztension, boolean)
    local boolean = boolean or nil
    return r.MIDI_SetCCShape(self.pointer, cc_idx, shape, beztension, boolean)
end

    
--- Set Evt.
-- Set MIDI event properties. Properties passed as NULL will not be set.  set
-- noSort if setting multiple events, then call MIDI_Sort when done.
-- @param evt_idx integer.
-- @param boolean selectedIn Optional.
-- @param boolean mutedIn Optional.
-- @param number ppqposIn Optional.
-- @param string msg Optional.
-- @param boolean noSortIn Optional.
-- @return boolean
function MediaItemTake:set_evt(evt_idx, boolean, boolean, number, string, boolean)
    local boolean = boolean or nil
    local number = number or nil
    local string = string or nil
    return r.MIDI_SetEvt(self.pointer, evt_idx, boolean, boolean, number, string, boolean)
end

    
--- Set Note.
-- Set MIDI note properties. Properties passed as NULL (or negative values) will
-- not be set. Set noSort if setting multiple events, then call MIDI_Sort when
-- done. Setting multiple note start positions at once is done more safely by
-- deleting and re-inserting the notes.
-- @param note_idx integer.
-- @param boolean selectedIn Optional.
-- @param boolean mutedIn Optional.
-- @param number startppqposIn Optional.
-- @param number endppqposIn Optional.
-- @param integer chanIn Optional.
-- @param integer pitchIn Optional.
-- @param integer velIn Optional.
-- @param boolean noSortIn Optional.
-- @return boolean
function MediaItemTake:set_note(note_idx, boolean, boolean, number, number, integer, integer, integer, boolean)
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
-- @param textsyxevt_idx integer.
-- @param boolean selectedIn Optional.
-- @param boolean mutedIn Optional.
-- @param number ppqposIn Optional.
-- @param integer typeIn Optional.
-- @param string msg Optional.
-- @param boolean noSortIn Optional.
-- @return boolean
function MediaItemTake:set_text_sysex_evt(textsyxevt_idx, boolean, boolean, number, integer, string, boolean)
    local boolean = boolean or nil
    local number = number or nil
    local integer = integer or nil
    local string = string or nil
    return r.MIDI_SetTextSysexEvt(self.pointer, textsyxevt_idx, boolean, boolean, number, integer, string, boolean)
end

    
--- Sort.
-- Sort MIDI events after multiple calls to MIDI_SetNote, MIDI_SetCC, etc.
function MediaItemTake:sort()
    return r.MIDI_Sort(self.pointer)
end

    
--- Set Active Take.
-- set this take active in this media item
function MediaItemTake:set_active_take()
    return r.SetActiveTake(self.pointer)
end

    
--- Set Source.
-- Set media source of media item take. The old source will not be destroyed, it is
-- the caller's responsibility to retrieve it and destroy it after. If source
-- already exists in any project, it will be duplicated before being set. C/C++
-- code should not use this and instead use GetSetMediaItemTakeInfo() with P_SOURCE
-- to manage ownership directly.
-- @return boolean
function MediaItemTake:set_source()
    return r.SetMediaItemTake_Source(self.pointer, source)
end

    
--- Constants for MediaItemTake:set_info_value.
-- @field D_STARTOFFS double *: start offset in source media, in seconds
-- @field D_VOL double *: take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped
-- @field D_PAN double *: take pan, -1..1
-- @field D_PANLAW double *: take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc
-- @field D_PLAYRATE double *: take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc
-- @field D_PITCH double *: take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc
-- @field B_PPITCH boolean: preserve pitch when changing playback rate
-- @field I_LASTY number: Y-position (relative to top of track) in pixels (read-only)
-- @field I_LASTH number: height in pixels (read-only)
-- @field I_CHANMODE number: channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right
-- @field I_PITCHMODE number: pitch shifter mode, -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter
-- @field I_STRETCHFLAGS number: int *stretch marker flags (&7 mask for mode override0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo)
-- @field F_STRETCHFADESIZE float *: stretch marker fade size in seconds (0.0025 default)
-- @field I_RECPASSID number: record pass ID
-- @field I_TAKEFX_NCH number: number of internal audio channels for per-take FX to use (OK to call with setNewValue, but the returned value is read-only)
-- @field I_CUSTOMCOLOR number: custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
-- @field IP_TAKENUMBER number: take number (read-only, returns the take number directly)
MediaItemTake.SetInfoValueConstants{
    D_STARTOFFS = "D_STARTOFFS",
    D_VOL = "D_VOL",
    D_PAN = "D_PAN",
    D_PANLAW = "D_PANLAW",
    D_PLAYRATE = "D_PLAYRATE",
    D_PITCH = "D_PITCH",
    B_PPITCH = "B_PPITCH",
    I_LASTY = "I_LASTY",
    I_LASTH = "I_LASTH",
    I_CHANMODE = "I_CHANMODE",
    I_PITCHMODE = "I_PITCHMODE",
    I_STRETCHFLAGS = "I_STRETCHFLAGS",
    F_STRETCHFADESIZE = "F_STRETCHFADESIZE",
    I_RECPASSID = "I_RECPASSID",
    I_TAKEFX_NCH = "I_TAKEFX_NCH",
    I_CUSTOMCOLOR = "I_CUSTOMCOLOR",
    IP_TAKENUMBER = "IP_TAKENUMBER",
}
    
--- Set Info Value.
-- Set media item take numerical-value attributes.
-- @param parm_name string. MediaItemTake.SetInfoValueConstants
-- @param newvalue number.
-- @return boolean
function MediaItemTake:set_info_value(parm_name, newvalue)
    return r.SetMediaItemTakeInfo_Value(self.pointer, parm_name, newvalue)
end

    
--- Set Take Marker.
-- Inserts or updates a take marker. If idx<0, a take marker will be added,
-- otherwise an existing take marker will be updated. Returns the index of the new
-- or updated take marker (which may change if srcPos is updated). See
-- GetNumTakeMarkers, GetTakeMarker, DeleteTakeMarker
-- @param idx integer.
-- @param name_in string.
-- @param number srcposIn Optional.
-- @param integer colorIn Optional.
-- @return integer
function MediaItemTake:set_take_marker(idx, name_in, number, integer)
    local number = number or nil
    local integer = integer or nil
    return r.SetTakeMarker(self.pointer, idx, name_in, number, integer)
end

    
--- Set Take Stretch Marker.
-- Adds or updates a stretch marker. If idx<0, stretch marker will be added. If
-- idx>=0, stretch marker will be updated. When adding, if srcposInOptional is
-- omitted, source position will be auto-calculated. When updating a stretch
-- marker, if srcposInOptional is omitted, srcpos will not be modified.
-- Position/srcposition values will be constrained to nearby stretch markers.
-- Returns index of stretch marker, or -1 if did not insert (or marker already
-- existed at time).
-- @param idx integer.
-- @param pos number.
-- @param number srcposIn Optional.
-- @return integer
function MediaItemTake:set_take_stretch_marker(idx, pos, number)
    local number = number or nil
    return r.SetTakeStretchMarker(self.pointer, idx, pos, number)
end

    
--- Set Take Stretch Marker Slope.
-- See GetTakeStretchMarkerSlope
-- @param idx integer.
-- @param slope number.
-- @return boolean
function MediaItemTake:set_take_stretch_marker_slope(idx, slope)
    return r.SetTakeStretchMarkerSlope(self.pointer, idx, slope)
end

    
--- Take Is Midi.
-- Returns true if the active take contains MIDI.
-- @return boolean
function MediaItemTake:take_is_midi()
    return r.TakeIsMIDI(self.pointer)
end

    
--- Br Get Guid.
-- [BR] Get media item take GUID as a string (guidStringOut_sz should be at least
-- 64). To get take from GUID string, see SNM_GetMediaItemTakeByGUID.
-- @return guid_string string
function MediaItemTake:br_get_guid()
    return r.BR_GetMediaItemTakeGUID(self.pointer)
end

    
--- Get Media Source Properties.
-- [BR] Get take media source properties as they appear in Item properties. Returns
-- false if take can't have them (MIDI items etc.). To set source properties, see
-- BR_SetMediaSourceProperties.
-- @return ret_val boolean
-- @return section boolean
-- @return start number
-- @return length number
-- @return fade number
-- @return reverse boolean
function MediaItemTake:get_media_source_properties()
    return r.BR_GetMediaSourceProperties(self.pointer)
end

    
--- Get Midi Source Len Ppq.
-- [BR] Get MIDI take source length in PPQ. In case the take isn't MIDI, return
-- value will be -1.
-- @return number
function MediaItemTake:get_midi_source_len_ppq()
    return r.BR_GetMidiSourceLenPPQ(self.pointer)
end

    
--- Get Midi Take Pool Guid.
-- [BR] Get MIDI take pool GUID as a string (guidStringOut_sz should be at least
-- 64). Returns true if take is pooled.
-- @return ret_val boolean
-- @return guid_string string
function MediaItemTake:get_midi_take_pool_guid()
    return r.BR_GetMidiTakePoolGUID(self.pointer)
end

    
--- Get Midi Take Tempo Info.
-- [BR] Get "ignore project tempo" information for MIDI take. Returns true if take
-- can ignore project tempo (no matter if it's actually ignored), otherwise false.
-- @return ret_val boolean
-- @return ignore_proj_tempo boolean
-- @return bpm number
-- @return num integer
-- @return den integer
function MediaItemTake:get_midi_take_tempo_info()
    return r.BR_GetMidiTakeTempoInfo(self.pointer)
end

    
--- Is Midi Open In Inline Editor.
-- [SWS] Check if take has MIDI inline editor open and returns true or false.
-- @return boolean
function MediaItemTake:is_midi_open_in_inline_editor()
    return r.BR_IsMidiOpenInInlineEditor(self.pointer)
end

    
--- Is Take Midi.
-- [BR] Check if take is MIDI take, in case MIDI take is in-project MIDI source
-- data, inProjectMidiOut will be true, otherwise false.
-- @return ret_val boolean
-- @return in_project_midi boolean
function MediaItemTake:is_take_midi()
    return r.BR_IsTakeMidi(self.pointer)
end

    
--- Set Media Source Properties.
-- [BR] Set take media source properties. Returns false if take can't have them
-- (MIDI items etc.). Section parameters have to be valid only when passing
-- section=true. To get source properties, see BR_GetMediaSourceProperties.
-- @param section boolean.
-- @param start number.
-- @param length number.
-- @param fade number.
-- @param reverse boolean.
-- @return boolean
function MediaItemTake:set_media_source_properties(section, start, length, fade, reverse)
    return r.BR_SetMediaSourceProperties(self.pointer, section, start, length, fade, reverse)
end

    
--- Set Midi Take Tempo Info.
-- [BR] Set "ignore project tempo" information for MIDI take. Returns true in case
-- the take was successfully updated.
-- @param ignore_proj_tempo boolean.
-- @param bpm number.
-- @param num integer.
-- @param den integer.
-- @return boolean
function MediaItemTake:set_midi_take_tempo_info(ignore_proj_tempo, bpm, num, den)
    return r.BR_SetMidiTakeTempoInfo(self.pointer, ignore_proj_tempo, bpm, num, den)
end

    
--- Set Take Source From File.
-- [BR] Set new take source from file. To import MIDI file as in-project source
-- data pass inProjectData=true. Returns false if failed. Any take source
-- properties from the previous source will be lost - to preserve them, see
-- BR_SetTakeSourceFromFile2. Note: To set source from existing take, see
-- SNM_GetSetSourceState2.
-- @param filename_in string.
-- @param in_project_data boolean.
-- @return boolean
function MediaItemTake:set_take_source_from_file(filename_in, in_project_data)
    return r.BR_SetTakeSourceFromFile(self.pointer, filename_in, in_project_data)
end

    
--- Set Take Source From File2.
-- [BR] Differs from BR_SetTakeSourceFromFile only that it can also preserve
-- existing take media source properties.
-- @param filename_in string.
-- @param in_project_data boolean.
-- @param keep_source_properties boolean.
-- @return boolean
function MediaItemTake:set_take_source_from_file2(filename_in, in_project_data, keep_source_properties)
    return r.BR_SetTakeSourceFromFile2(self.pointer, filename_in, in_project_data, keep_source_properties)
end

    
--- Alloc Midi Take.
-- [FNG] Allocate a RprMidiTake from a take pointer. Returns a NULL pointer if the
-- take is not an in-project MIDI take
-- @return RprMidiTake
function MediaItemTake:alloc_midi_take()
    return r.FNG_AllocMidiTake(self.pointer)
end

    
--- Wildcard Parse Take.
-- Returns a string by parsing wildcards relative to the supplied MediaItem_Take
-- @param input string.
-- @return value string
function MediaItemTake:wildcard_parse_take(input)
    return r.GU_WildcardParseTake(self.pointer, input)
end

    
--- Analyze Take Loudness.
-- Full loudness analysis. retval: returns true on successful analysis, false on
-- MIDI take or when analysis failed for some reason. analyzeTruePeak=true: Also do
-- true peak analysis. Returns true peak value in dBTP and true peak position
-- (relative to item position). Considerably slower than without true peak analysis
-- (since it uses oversampling). Note: Short term uses a time window of 3 sec. for
-- calculation. So for items shorter than this shortTermMaxOut can't be calculated
-- correctly. Momentary uses a time window of 0.4 sec.
-- @param analyze_true_peak boolean.
-- @return ret_val boolean
-- @return lufs_integrated number
-- @return range number
-- @return true_peak number
-- @return true_peak_pos number
-- @return short_term_max number
-- @return momentary_max number
function MediaItemTake:analyze_take_loudness(analyze_true_peak)
    return r.NF_AnalyzeTakeLoudness(self.pointer, analyze_true_peak)
end

    
--- Analyze Take Loudness2.
-- Same as NF_AnalyzeTakeLoudness but additionally returns shortTermMaxPos and
-- momentaryMaxPos (in absolute project time). Note: shortTermMaxPos and
-- momentaryMaxPos indicate the beginning of time intervalls, (3 sec. and 0.4 sec.
-- resp.).
-- @param analyze_true_peak boolean.
-- @return ret_val boolean
-- @return lufs_integrated number
-- @return range number
-- @return true_peak number
-- @return true_peak_pos number
-- @return short_term_max number
-- @return momentary_max number
-- @return short_term_max_pos number
-- @return momentary_max_pos number
function MediaItemTake:analyze_take_loudness2(analyze_true_peak)
    return r.NF_AnalyzeTakeLoudness2(self.pointer, analyze_true_peak)
end

    
--- Analyze Take Loudness Integrated Only.
-- Does LUFS integrated analysis only. Faster than full loudness analysis
-- (NF_AnalyzeTakeLoudness) . Use this if only LUFS integrated is required. Take
-- vol. env. is taken into account. See: Signal flow
-- @return ret_val boolean
-- @return lufs_integrated number
function MediaItemTake:analyze_take_loudness_integrated_only()
    return r.NF_AnalyzeTakeLoudness_IntegratedOnly(self.pointer)
end

    
--- Get Set Source State2.
-- [S&M] Gets or sets a take source state. Returns false if failed. Note: this
-- function cannot deal with empty takes, see SNM_GetSetSourceState.
-- @param state WDL_FastString.
-- @param setnewvalue boolean.
-- @return boolean
function MediaItemTake:get_set_source_state2(state, setnewvalue)
    return r.SNM_GetSetSourceState2(self.pointer, state, setnewvalue)
end

return MediaItemTake
