--- Provide implementation for Take functions.
-- @author NomadMonad
-- @license MIT
-- @release 0.0.1
-- @module take

local r = reaper
local helpers = require("helpers")

--@ class Take
--@ field pointer_type string: "MediaItemTake*"
--@ field pointer userdata: The pointer to Reaper MediaItem_Take*
local Take = {}

--- Create new Take instance.
--- @within ReaWrap Custom Methods
--- @param take userdata. The pointer to Reaper MediaItem_Take*
--- @return Take table.
function Take:new(take)
  local obj = {
    pointer_type = "MediaItemTake*",
    pointer = take,
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

--- Log messages with the Take logger.
--- @within ReaWrap Custom Methods
--- @param ... (varargs) Messages to log.
function Take:log(...)
  local logger = helpers.log_func("Take")
  logger(...)
  return nil
end

--- String representation of the Take instance.
--- @within ReaWrap Custom Methods
--- @return string
function Take:__tostring()
  return string.format("<Take name=%s>", self:get_name())
end

-- @section ReaScript API Methods

--- Count Take Envelopes. Wraps CountTakeEnvelopes.
--- @within ReaScript Wrapped Methods
--- @return number
--- @see Take:get_envelope
function Take:count_envelopes()
  return r.CountTakeEnvelopes(self.pointer)
end

--- Create Take Audio Accessor. Wraps CreateTakeAudioAccessor.
-- Create an audio accessor object for this take. Must only call from the main thread.
--- @within ReaScript Wrapped Methods
--- @return table AudioAccessor object
function Take:create_take_audio_accessor()
  local AudioAccessor = require("audio_accessor")
  local result = r.CreateTakeAudioAccessor(self.pointer)
  return AudioAccessor:new(result)
end

--- Delete Take Marker. Wraps DeleteTakeMarker.
-- Delete a take marker. Note that idx will change for all following take markers.
--- @within ReaScript Wrapped Methods
--- @param idx number
--- @return boolean
--- @see Take:get_num_markers
--- @see Take:get_marker
--- @see Take:set_marker
function Take:delete_marker(idx)
  return r.DeleteTakeMarker(self.pointer, idx)
end

--- Delete Take Stretch Markers. Wraps DeleteTakeStretchMarkers.
-- Deletes one or more stretch markers. Returns number of stretch markers deleted.
--- @within ReaScript Wrapped Methods
--- @param idx number
--- @param integer countIn Optional
--- @return number
function Take:delete_take_stretch_markers(idx, integer)
  local integer = integer or nil
  return r.DeleteTakeStretchMarkers(self.pointer, idx, integer)
end

--- Get Item. Wraps GetMediaItemTake_Item.
-- Get parent item of media item take
--- @within ReaScript Wrapped Methods
--- @return Item table
function Take:get_item()
  local Item = require("item")
  local result = r.GetMediaItemTake_Item(self.pointer)
  return Item:new(result)
end

--- Get Peaks. Wraps GetMediaItemTake_Peaks.
-- Gets block of peak samples to buf. Note that the peak samples are interleaved,
-- but in two or three blocks (maximums, then minimums, then extra). Return value
-- has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000),
-- then a bit to signify whether extra_type was available (0x1000000). extra_type
-- can be 115 ('s') for spectral information, which will return peak samples as
-- integers with the low 15 bits frequency, next 14 bits tonality.
--- @within ReaScript Wrapped Methods
--- @param peak_rate number
--- @param start_time number
--- @param num_channels number
--- @param samples_per_channel number
--- @param want_extra_type number
--- @param buf reaper.array
--- @return number
function Take:get_peaks(
  peak_rate,
  start_time,
  num_channels,
  samples_per_channel,
  want_extra_type,
  buf
)
  return r.GetMediaItemTake_Peaks(
    self.pointer,
    peak_rate,
    start_time,
    num_channels,
    samples_per_channel,
    want_extra_type,
    buf
  )
end

--- Get Source. Wraps GetMediaItemTake_Source.
-- Get media source of media item take
--- @within ReaScript Wrapped Methods
--- @return userdata
function Take:get_source()
  local PCM_source = require("pcm_source")
  local result = r.GetMediaItemTake_Source(self.pointer)
  return PCM_source:new(result)
end

--- Get Track. Wraps GetMediaItemTake_Track.
-- Get parent track of media item take
--- @within ReaScript Wrapped Methods
--- @return Track table
function Take:get_track()
  local Track = require("track")
  local result = r.GetMediaItemTake_Track(self.pointer)
  return Track:new(result)
end

--- Constants for Take:get_info_value.
--- @within Constants
--- @field D_STARTOFFS number: start offset in source media, in seconds
--- @field D_VOL number: take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped
--- @field D_PAN number: take pan, -1..1
--- @field D_PANLAW number: take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc
--- @field D_PLAYRATE number: take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc
--- @field D_PITCH number: take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc
--- @field B_PPITCH boolean: preserve pitch when changing playback rate
--- @field I_LASTY number: Y-position (relative to top of track) in pixels (read-only)
--- @field I_LASTH number: height in pixels (read-only)
--- @field I_CHANMODE number: channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right
--- @field I_PITCHMODE number: pitch shifter mode, -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter
--- @field I_STRETCHFLAGS number: int *stretch marker flags (&7 mask for mode override0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo)
--- @field F_STRETCHFADESIZE float *: stretch marker fade size in seconds (0.0025 default)
--- @field I_RECPASSID number: record pass ID
--- @field I_TAKEFX_NCH number: number of internal audio channels for per-take FX to use (OK to call with setNewValue, but the returned value is read-only)
--- @field I_CUSTOMCOLOR number: custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
--- @field IP_TAKENUMBER number: take number (read-only, returns the take number directly)
--- @field P_TRACK userdata: pointer to MediaTrack (read-only)
--- @field P_ITEM userdata: pointer to MediaItem (read-only)
--- @field P_SOURCE userdata: PCM_source *. Note that if setting this, you should first retrieve the old source, set the new, THEN delete the old.
Take.GetInfoValueConstants = {
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

--- Get Info Value. Wraps GetMediaItemTakeInfo_Value.
-- Get media item take numerical-value attributes.
--- @within ReaScript Wrapped Methods
--- @param param_name string Take.GetInfoValueConstants
--- @return number
--- @see Take.GetInfoValueConstants
function Take:get_info_value(param_name)
  return r.GetMediaItemTakeInfo_Value(self.pointer, param_name)
end

--- Get Num Take Markers. Wraps GetNumTakeMarkers.
-- Returns number of take markers.
--- @within ReaScript Wrapped Methods
--- @return number
--- @see Take:get_marker
--- @see Take:set_marker
function Take:get_num_markers()
  return r.GetNumTakeMarkers(self.pointer)
end

--- Constants for Take:get_set_info_string.
--- @within Constants
--- @field P_NAME string: take name
--- @field P_EXT xyz: xyzchar *extension-specific persistent data
--- @field GUID GUID *: 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
Take.GetSetInfoStringConstants = {
  P_NAME = "P_NAME",
  P_EXT = "P_EXT",
  GUID = "GUID",
}

--- Get Set Info String. Wraps GetSetMediaItemTakeInfo_String.
-- Gets/sets a take attribute string.
--- @within ReaScript Wrapped Methods
--- @param param_name string Take.GetSetInfoStringConstants
--- @param string_need_big string
--- @param set_new_value boolean
--- @return string
function Take:get_set_info_string(param_name, string_need_big, set_new_value)
  local ret_val, string_need_big =
    r.GetSetMediaItemTakeInfo_String(self.pointer, param_name, string_need_big, set_new_value)
  if ret_val then
    return string_need_big
  else
    error("Error getting/setting take info string")
  end
end

--- Get Take Envelope by index. Wraps GetTakeEnvelope.
--- @within ReaScript Wrapped Methods
--- @param env_idx number
--- @return table Envelope object
function Take:get_envelope(env_idx)
  local Envelope = require("envelope")
  local result = r.GetTakeEnvelope(self.pointer, env_idx)
  return Envelope:new(result)
end

--- Get Take Envelope By Name. Wraps GetTakeEnvelopeByName.
--- @within ReaScript Wrapped Methods
--- @param env_name string
--- @return table Envelope object
function Take:get_envelope_by_name(env_name)
  local Envelope = require("envelope")
  local result = r.GetTakeEnvelopeByName(self.pointer, env_name)
  return Envelope:new(result)
end

--- Get Take Marker. Wraps GetTakeMarker.
-- Get information about a take marker. Returns the position in media item source
-- time, or -1 if the take marker does not exist.
--- @within ReaScript Wrapped Methods
--- @param idx number
--- @return string name
--- @return number color
--- @see Take:get_num_markers
--- @see Take:set_marker
function Take:get_marker(idx)
  local ret_val, name, integer = r.GetTakeMarker(self.pointer, idx)
  if ret_val then
    return name, integer
  else
    error("Error getting take marker")
  end
end

--- Get Take Name. Wraps GetTakeName.
-- returns NULL if the take is not valid
--- @within ReaScript Wrapped Methods
--- @return string
function Take:get_name()
  return r.GetTakeName(self.pointer)
end

--- Get Take Num Stretch Markers. Wraps GetTakeNumStretchMarkers.
-- Returns number of stretch markers in take
--- @within ReaScript Wrapped Methods
--- @return number
function Take:get_take_num_stretch_markers()
  return r.GetTakeNumStretchMarkers(self.pointer)
end

--- Get Take Stretch Marker. Wraps GetTakeStretchMarker.
-- Gets information on a stretch marker, idx is 0..n. Returns -1 if stretch marker
-- not valid. posOut will be set to position in item, srcposOutOptional will be set
-- to source media position. Returns index. if input index is -1, the following
-- marker is found using position (or source position if position is -1). If
-- position/source position are used to find marker position, their values are not
-- updated.
--- @within ReaScript Wrapped Methods
--- @param idx number
--- @return number pos
--- @return number srcpos
function Take:get_take_stretch_marker(idx)
  local ret_val, pos, srcpos = r.GetTakeStretchMarker(self.pointer, idx)
  if ret_val then
    return pos, srcpos
  else
    error("Error getting take stretch marker")
  end
end

--- Get Take Stretch Marker Slope. Wraps GetTakeStretchMarkerSlope.
--- @within ReaScript Wrapped Methods
--- @param idx number
--- @return number
--- @see Take:set_take_stretch_marker_slope
function Take:get_take_stretch_marker_slope(idx)
  return r.GetTakeStretchMarkerSlope(self.pointer, idx)
end

--- Midi Count Evts. Wraps MIDI_CountEvts.
-- Count the number of notes, CC events, and text/sysex events in a given MIDI
-- item.
--- @within ReaScript Wrapped Methods
--- @return number notecnt
--- @return number ccevtcnt
--- @return number textsyxevtcnt
function Take:midi_count_evts()
  local ret_val, notecnt, ccevtcnt, textsyxevtcnt = r.MIDI_CountEvts(self.pointer)
  if ret_val then
    return notecnt, ccevtcnt, textsyxevtcnt
  else
    error("Error counting MIDI events")
  end
end

--- Midi Delete Cc. Wraps MIDI_DeleteCC.
-- Delete a MIDI CC event.
--- @within ReaScript Wrapped Methods
--- @param cc_idx number
--- @return boolean
function Take:midi_delete_cc(cc_idx)
  return r.MIDI_DeleteCC(self.pointer, cc_idx)
end

--- Midi Delete Evt. Wraps MIDI_DeleteEvt.
-- Delete a MIDI event.
--- @within ReaScript Wrapped Methods
--- @param evt_idx number
--- @return boolean
function Take:midi_delete_evt(evt_idx)
  return r.MIDI_DeleteEvt(self.pointer, evt_idx)
end

--- Midi Delete Note. Wraps MIDI_DeleteNote.
-- Delete a MIDI note.
--- @within ReaScript Wrapped Methods
--- @param note_idx number
--- @return boolean
function Take:midi_delete_note(note_idx)
  return r.MIDI_DeleteNote(self.pointer, note_idx)
end

--- Midi Delete Text Sysex Evt. Wraps MIDI_DeleteTextSysexEvt.
-- Delete a MIDI text or sysex event.
--- @within ReaScript Wrapped Methods
--- @param sysxevt_idx number
--- @return boolean
function Take:midi_delete_text_sysex_evt(sysxevt_idx)
  return r.MIDI_DeleteTextSysexEvt(self.pointer, sysxevt_idx)
end

--- Midi Disable Sort. Wraps MIDI_DisableSort.
-- Disable sorting for all MIDI insert, delete, get and set functions, until
-- MIDI_Sort is called.
--- @within ReaScript Wrapped Methods
function Take:midi_disable_sort()
  return r.MIDI_DisableSort(self.pointer)
end

--- Midi Enum Sel Cc. Wraps MIDI_EnumSelCC.
-- Returns the index of the next selected MIDI CC event after ccidx (-1 if there
-- are no more selected events).
--- @within ReaScript Wrapped Methods
--- @param cc_idx number
--- @return number
function Take:midi_enum_sel_cc(cc_idx)
  return r.MIDI_EnumSelCC(self.pointer, cc_idx)
end

--- Midi Enum Sel Evts. Wraps MIDI_EnumSelEvts.
-- Returns the index of the next selected MIDI event after evtidx (-1 if there are
-- no more selected events).
--- @within ReaScript Wrapped Methods
--- @param evt_idx number
--- @return number
function Take:midi_enum_sel_evts(evt_idx)
  return r.MIDI_EnumSelEvts(self.pointer, evt_idx)
end

--- Midi Enum Sel Notes. Wraps MIDI_EnumSelNotes.
-- Returns the index of the next selected MIDI note after noteidx (-1 if there are
-- no more selected events).
--- @within ReaScript Wrapped Methods
--- @param note_idx number
--- @return number
function Take:midi_enum_sel_notes(note_idx)
  return r.MIDI_EnumSelNotes(self.pointer, note_idx)
end

--- Midi Enum Sel Text Sysex Evts. Wraps MIDI_EnumSelTextSysexEvts.
-- Returns the index of the next selected MIDI text/sysex event after textsyxidx
-- (-1 if there are no more selected events).
--- @within ReaScript Wrapped Methods
--- @param textsyx_idx number
--- @return number
function Take:midi_enum_sel_text_sysex_evts(textsyx_idx)
  return r.MIDI_EnumSelTextSysexEvts(self.pointer, textsyx_idx)
end

--- Midi Get All Evts. Wraps MIDI_GetAllEvts.
-- Get all MIDI data. MIDI buffer is returned as a list of { int offset, char flag,
-- int msglen, unsigned char msg[] }. offset: MIDI ticks from previous event flag:
-- &1=selected &2=muted flag high 4 bits for CC shape: &16=linear, &32=slow
-- start/end, &16|32=fast start, &64=fast end, &64|16=bezier msg: the MIDI message.
-- A meta-event of type 0xF followed by 'CCBZ ' and 5 more bytes represents bezier
-- curve data for the previous MIDI event: 1 byte for the bezier type (usually 0)
-- and 4 bytes for the bezier tension as a float. For tick intervals longer than a
-- 32 bit word can represent, zero-length meta events may be placed between valid
-- events.
--- @within ReaScript Wrapped Methods
--- @return buf string
--- @see Take:midi_set_all_evts
function Take:midi_get_all_evts()
  local ret_val, buf = r.MIDI_GetAllEvts(self.pointer)
  if ret_val then
    return buf
  else
    error("Error getting all MIDI events")
  end
end

--- Midi Get Cc. Wraps MIDI_GetCC.
-- Get MIDI CC event properties.
--- @within ReaScript Wrapped Methods
--- @param cc_idx number
--- @return boolean selected
--- @return boolean muted
--- @return number ppq_pos
--- @return number chan_msg
--- @return number chan
--- @return number msg2
--- @return number msg3
function Take:midi_get_cc(cc_idx)
  local ret_val, selected, muted, ppq_pos, chan_msg, chan, msg2, msg3 =
    r.MIDI_GetCC(self.pointer, cc_idx)
  if ret_val then
    return selected, muted, ppq_pos, chan_msg, chan, msg2, msg3
  else
    error("Error getting MIDI CC")
  end
end

--- Midi Get Cc Shape. Wraps MIDI_GetCCShape.
-- Get CC shape and bezier tension.
--- @within ReaScript Wrapped Methods
--- @param cc_idx number
--- @return number shape
--- @return number bez_tension
--- @see Take:midi_set_cc_shape
--- @see Take:midi_get_cc
function Take:midi_get_cc_shape(cc_idx)
  local ret_val, shape, bez_tension = r.MIDI_GetCCShape(self.pointer, cc_idx)
  if ret_val then
    return shape, bez_tension
  else
    error("Error getting MIDI CC shape")
  end
end

--- Midi Get Evt. Wraps MIDI_GetEvt.
-- Get MIDI event properties.
--- @within ReaScript Wrapped Methods
--- @param evt_idx number
--- @return boolean selected
--- @return boolean muted
--- @return number ppq_pos
--- @return string msg
function Take:midi_get_evt(evt_idx)
  local ret_val, selected, muted, ppq_pos, msg = r.MIDI_GetEvt(self.pointer, evt_idx)
  if ret_val then
    return selected, muted, ppq_pos, msg
  else
    error("Error getting MIDI event")
  end
end

--- Midi Get Grid. Wraps MIDI_GetGrid.
-- Returns the most recent MIDI editor grid size for this MIDI take, in QN. Swing
-- is between 0 and 1. Note length is 0 if it follows the grid size.
--- @within ReaScript Wrapped Methods
--- @return number swing
--- @return number noteLen
function Take:midi_get_grid()
  local ret_val, number, number = r.MIDI_GetGrid(self.pointer)
  if ret_val then
    return number, number
  else
    error("Error getting MIDI grid")
  end
end

--- Midi Get Hash. Wraps MIDI_GetHash.
-- Get a string that only changes when the MIDI data changes. If notes_only==true,
-- then the string changes only when the MIDI notes change.
--- @within ReaScript Wrapped Methods
--- @param notes_only boolean
--- @return string
function Take:midi_get_hash(notes_only)
  local ret_val, hash = r.MIDI_GetHash(self.pointer, notes_only)
  if ret_val then
    return hash
  else
    error("Error getting MIDI hash")
  end
end

--- Midi Get Note. Wraps MIDI_GetNote.
-- Get MIDI note properties.
--- @within ReaScript Wrapped Methods
--- @param note_idx number
--- @return boolean selected
--- @return boolean muted
--- @return number start_ppq
--- @return number end_ppq
--- @return number chan
--- @return number pitch
--- @return number vel
function Take:midi_get_note(note_idx)
  local ret_val, selected, muted, start_ppq, end_ppq, chan, pitch, vel =
    r.MIDI_GetNote(self.pointer, note_idx)
  if ret_val then
    return selected, muted, start_ppq, end_ppq, chan, pitch, vel
  else
    error("Error getting MIDI note")
  end
end

--- Midi Get Ppq Pos End Of Measure. Wraps MIDI_GetPPQPos_EndOfMeasure.
-- Returns the MIDI tick (ppq) position corresponding to the end of the measure.
--- @within ReaScript Wrapped Methods
--- @param ppq_pos number
--- @return number
function Take:midi_get_ppq_pos_end_of_measure(ppq_pos)
  return r.MIDI_GetPPQPos_EndOfMeasure(self.pointer, ppq_pos)
end

--- Midi Get Ppq Pos Start Of Measure. Wraps MIDI_GetPPQPos_StartOfMeasure.
-- Returns the MIDI tick (ppq) position corresponding to the start of the measure.
--- @within ReaScript Wrapped Methods
--- @param ppq_pos number
--- @return number
function Take:midi_get_ppq_pos_start_of_measure(ppq_pos)
  return r.MIDI_GetPPQPos_StartOfMeasure(self.pointer, ppq_pos)
end

--- Midi Get Ppq Pos From Proj Qn. Wraps MIDI_GetPPQPosFromProjQN.
-- Returns the MIDI tick (ppq) position corresponding to a specific project time in
-- quarter notes.
--- @within ReaScript Wrapped Methods
--- @param projqn number
--- @return number
function Take:midi_get_ppq_pos_from_proj_qn(projqn)
  return r.MIDI_GetPPQPosFromProjQN(self.pointer, projqn)
end

--- Midi Get Ppq Pos From Proj Time. Wraps MIDI_GetPPQPosFromProjTime.
-- Returns the MIDI tick (ppq) position corresponding to a specific project time in
-- seconds.
--- @within ReaScript Wrapped Methods
--- @param projtime number
--- @return number
function Take:midi_get_ppq_pos_from_proj_time(projtime)
  return r.MIDI_GetPPQPosFromProjTime(self.pointer, projtime)
end

--- Midi Get Proj Qn From Ppq Pos. Wraps MIDI_GetProjQNFromPPQPos.
-- Returns the project time in quarter notes corresponding to a specific MIDI tick
-- (ppq) position.
--- @within ReaScript Wrapped Methods
--- @param ppq_pos number
--- @return number
function Take:midi_get_proj_qn_from_ppq_pos(ppq_pos)
  return r.MIDI_GetProjQNFromPPQPos(self.pointer, ppq_pos)
end

--- Midi Get Proj Time From Ppq Pos. Wraps MIDI_GetProjTimeFromPPQPos.
-- Returns the project time in seconds corresponding to a specific MIDI tick (ppq)
-- position.
--- @within ReaScript Wrapped Methods
--- @param ppq_pos number
--- @return number
function Take:midi_get_proj_time_from_ppq_pos(ppq_pos)
  return r.MIDI_GetProjTimeFromPPQPos(self.pointer, ppq_pos)
end

--- Midi Get Scale. Wraps MIDI_GetScale.
-- Get the active scale in the media source, if any. root 0=C, 1=C#, etc. scale
-- &0x1=root, &0x2=minor 2nd, &0x4=major 2nd, &0x8=minor 3rd, &0xF=fourth, etc.
--- @within ReaScript Wrapped Methods
--- @return number root
--- @return number scale
--- @return string name
function Take:midi_get_scale()
  local ret_val, root, scale, name = r.MIDI_GetScale(self.pointer)
  if ret_val then
    return root, scale, name
  else
    error("Error getting MIDI scale")
  end
end

--- Midi Get Text Sysex Evt. Wraps MIDI_GetTextSysexEvt.
-- Get MIDI meta-event properties. Allowable types are -1:sysex (msg should not
-- include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event.
-- For all other meta-messages, type is returned as -2 and msg returned as all
-- zeroes.
--- @within ReaScript Wrapped Methods
--- @param sysxevt_idx number
--- @param selected boolean Optional
--- @param muted boolean Optional
--- @param ppq_pos number Optional
--- @param type_ number Optional
--- @param msg string Optional
--- @return boolean selected
--- @return boolean muted
--- @return number ppq_pos
--- @return integer type_
--- @return string msg
--- @see Take:midi_get_all_evts
--- @see Take:midi_insert_text_sysex_evt
function Take:midi_get_text_sysex_evt(sysxevt_idx, selected, muted, ppq_pos, type_, msg)
  local selected = selected or true
  local muted = muted or false
  local ppq_pos = ppq_pos or 0
  local msg = msg or ""
  local ret_val, selected, muted, ppq_pos, type, msg =
    r.MIDI_GetTextSysexEvt(self.pointer, sysxevt_idx, selected, muted, ppq_pos, type_, msg)
  if ret_val then
    return selected, muted, ppq_pos, type, msg
  else
    error("Error getting MIDI text sysex event")
  end
end

--- Midi Insert Cc. Wraps MIDI_InsertCC.
-- Insert a new MIDI CC event.
--- @within ReaScript Wrapped Methods
--- @param selected boolean
--- @param muted boolean
--- @param ppq_pos number
--- @param chan_msg number
--- @param chan number
--- @param msg2 number
--- @param msg3 number
--- @return boolean
function Take:midi_insert_cc(selected, muted, ppq_pos, chan_msg, chan, msg2, msg3)
  return r.MIDI_InsertCC(self.pointer, selected, muted, ppq_pos, chan_msg, chan, msg2, msg3)
end

--- Midi Insert Evt. Wraps MIDI_InsertEvt.
-- Insert a new MIDI event.
--- @within ReaScript Wrapped Methods
--- @param selected boolean
--- @param muted boolean
--- @param ppq_pos number
--- @param bytestr string
--- @return boolean
function Take:midi_insert_evt(selected, muted, ppq_pos, bytestr)
  return r.MIDI_InsertEvt(self.pointer, selected, muted, ppq_pos, bytestr)
end

--- Midi Insert Note. Wraps MIDI_InsertNote.
-- Insert a new MIDI note. Set no_sort if inserting multiple events, then call
-- MIDI_Sort when done.
--- @within ReaScript Wrapped Methods
--- @param selected boolean
--- @param muted boolean
--- @param start_ppq number
--- @param end_ppq number
--- @param chan number
--- @param pitch number
--- @param vel number
--- @param no_sort boolean Optional
--- @return boolean
function Take:midi_insert_note(selected, muted, start_ppq, end_ppq, chan, pitch, vel, no_sort)
  local no_sort = no_sort or false
  return r.MIDI_InsertNote(
    self.pointer,
    selected,
    muted,
    start_ppq,
    end_ppq,
    chan,
    pitch,
    vel,
    no_sort
  )
end

--- Midi Insert Text Sysex Evt. Wraps MIDI_InsertTextSysexEvt.
-- Insert a new MIDI text or sysex event. Allowable types are -1:sysex (msg should
-- not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation
-- event.
--- @within ReaScript Wrapped Methods
--- @param selected boolean
--- @param muted boolean
--- @param ppq_pos number
--- @param type number
--- @param bytestr string
--- @return boolean
function Take:midi_insert_text_sysex_evt(selected, muted, ppq_pos, type, bytestr)
  return r.MIDI_InsertTextSysexEvt(self.pointer, selected, muted, ppq_pos, type, bytestr)
end

--- Midi Refresh Editors. Wraps MIDI_RefreshEditors.
-- Synchronously updates any open MIDI editors for MIDI take
--- @within ReaScript Wrapped Methods
function Take:midi_refresh_editors()
  return r.MIDI_RefreshEditors(self.pointer)
end

--- Midi Select All. Wraps MIDI_SelectAll.
-- Select or deselect all MIDI content.
--- @within ReaScript Wrapped Methods
--- @param select boolean
function Take:midi_select_all(select)
  return r.MIDI_SelectAll(self.pointer, select)
end

--- Midi Set All Evts. Wraps MIDI_SetAllEvts.
-- Set all MIDI data. MIDI buffer is passed in as a list of { int offset, char
-- flag, int msglen, unsigned char msg[] }. offset: MIDI ticks from previous event
-- flag: &1=selected &2=muted flag high 4 bits for CC shape: &16=linear, &32=slow
-- start/end, &16|32=fast start, &64=fast end, &64|16=bezier msg: the MIDI message.
-- A meta-event of type 0xF followed by 'CCBZ ' and 5 more bytes represents bezier
-- curve data for the previous MIDI event: 1 byte for the bezier type (usually 0)
-- and 4 bytes for the bezier tension as a float. For tick intervals longer than a
-- 32 bit word can represent, zero-length meta events may be placed between valid
-- events.
--- @within ReaScript Wrapped Methods
--- @param buf string
--- @return boolean
--- @see Take:midi_get_all_evts
function Take:midi_set_all_evts(buf)
  return r.MIDI_SetAllEvts(self.pointer, buf)
end

--- Midi Set Cc. Wraps MIDI_SetCC.
-- Set MIDI CC event properties. Properties passed as NULL will not be set. set
-- no_sort if setting multiple events, then call MIDI_Sort when done.
--- @within ReaScript Wrapped Methods
--- @param cc_idx number
--- @param selected_in boolean Optional. Default true
--- @param muted_in boolean Optional. Default false
--- @param ppq_pos_in number Optional. Default 0
--- @param chan_msg_in number Optional. Default 0xB0
--- @param chan_in number Optional. Default 0
--- @param msg2_in number Optional. Default 0
--- @param msg3_in number Optional. Default 0
--- @param no_sort boolean Optional. Default false
--- @return boolean
function Take:midi_set_cc(
  cc_idx,
  selected_in,
  muted_in,
  ppq_pos_in,
  chan_msg_in,
  chan_in,
  msg2_in,
  msg3_in,
  no_sort
)
  local selected_in = selected_in or true
  local muted_in = muted_in or false
  local ppq_pos_in = ppq_pos_in or 0
  local chan_msg_in = chan_msg_in or 0xB0
  local chan_in = chan_in or 0
  local msg2_in = msg2_in or 0
  local msg3_in = msg3_in or 0
  local no_sort = no_sort or false
  return r.MIDI_SetCC(
    self.pointer,
    cc_idx,
    selected_in,
    muted_in,
    ppq_pos_in,
    chan_msg_in,
    chan_in,
    msg2_in,
    msg3_in,
    no_sort
  )
end

--- Midi Set Cc Shape. Wraps MIDI_SetCCShape.
-- Set CC shape and bezier tension. set no_sort if setting multiple events, then
-- call MIDI_Sort when done.
--- @within ReaScript Wrapped Methods
--- @param cc_idx number
--- @param shape number
--- @param bez_tension number
--- @param no_sort boolean Optional. Default false
--- @return boolean
--- @see Take:midi_get_cc_shape
--- @see Take:midi_set_cc
function Take:midi_set_cc_shape(cc_idx, shape, bez_tension, no_sort)
  local no_sort = no_sort or false
  return r.MIDI_SetCCShape(self.pointer, cc_idx, shape, bez_tension, no_sort)
end

--- Midi Set Evt. Wraps MIDI_SetEvt.
-- Set MIDI event properties. Properties passed as NULL will not be set.  set
-- no_sort if setting multiple events, then call MIDI_Sort when done.
--- @within ReaScript Wrapped Methods
--- @param evt_idx number
--- @param selected_in boolean Optional. Default true.
--- @param muted boolean Optional. Default false.
--- @param ppq_pos number Optional.
--- @param msg string Optional.
--- @param no_sort boolean Optional. Default false.
--- @return boolean
function Take:midi_set_evt(evt_idx, selected_in, muted, ppq_pos, msg, no_sort)
  local selected_in = selected_in or true
  local muted = muted or false
  local ppq_pos = ppq_pos or 0
  local msg = msg or ""
  local no_sort = no_sort or false
  return r.MIDI_SetEvt(self.pointer, evt_idx, selected_in, muted, ppq_pos, msg, no_sort)
end

--- Midi Set Note. Wraps MIDI_SetNote.
-- Set MIDI note properties. Properties passed as NULL (or negative values) will
-- not be set. Set no_sort if setting multiple events, then call MIDI_Sort when
-- done. Setting multiple note start positions at once is done more safely by
-- deleting and re-inserting the notes.
--- @within ReaScript Wrapped Methods
--- @param note_idx number
--- @param selected boolean Optional
--- @param muted boolean Optional
--- @param start_ppq number Optional
--- @param end_ppq number Optional
--- @param chan integer Optional
--- @param pitch integer Optional
--- @param velocity integer Optional
--- @param no_sort boolean Optional
--- @return boolean
function Take:midi_set_note(
  note_idx,
  selected,
  muted,
  start_ppq,
  end_ppq,
  chan,
  pitch,
  velocity,
  no_sort
)
  local selected = selected or true
  local muted = muted or false
  local start_ppq = start_ppq or 0
  local end_ppq = end_ppq or 0
  local chan = chan or 1
  local pitch = pitch or 1
  local velocity = velocity or 1
  local no_sort = no_sort or false
  return r.MIDI_SetNote(
    self.pointer,
    note_idx,
    boolean,
    boolean,
    number,
    number,
    integer,
    integer,
    integer,
    boolean
  )
end

--- Midi Set Text Sysex Evt. Wraps MIDI_SetTextSysexEvt.
-- Set MIDI text or sysex event properties. Properties passed as NULL will not be
-- set. Allowable types are -1:sysex (msg should not include bounding F0..F7),
-- 1-14:MIDI text event types, 15=REAPER notation event. set no_sort if setting
-- multiple events, then call MIDI_Sort when done.
--- @within ReaScript Wrapped Methods
--- @param sysxevt_idx number
--- @param selected boolean Optional
--- @param muted boolean Optional
--- @param ppq_pos number Optional
--- @param type integer Optional
--- @param msg string Optional
--- @param no_sort boolean Optional
--- @return boolean
function Take:midi_set_text_sysex_evt(sysxevt_idx, selected, muted, ppq_pos, type, msg, no_sort)
  local selected = selected or true
  local muted = muted or false
  local ppq_pos = ppq_pos or 0
  local type = type or 0
  local msg = msg or ""
  local no_sort = no_sort or false
  return r.MIDI_SetTextSysexEvt(
    self.pointer,
    sysxevt_idx,
    selected,
    muted,
    ppq_pos,
    type,
    msg,
    no_sort
  )
end

--- Midi Sort. Wraps MIDI_Sort.
-- Sort MIDI events after multiple calls to MIDI_SetNote, MIDI_SetCC, etc.
--- @within ReaScript Wrapped Methods
function Take:midi_sort()
  return r.MIDI_Sort(self.pointer)
end

--- Set Active Take. Wraps SetActiveTake.
-- set this take active in this media item
--- @within ReaScript Wrapped Methods
function Take:set_active_take()
  return r.SetActiveTake(self.pointer)
end

--- Set Source. Wraps SetMediaItemTake_Source.
-- Set media source of media item take. The old source will not be destroyed, it is
-- the caller's responsibility to retrieve it and destroy it after. If source
-- already exists in any project, it will be duplicated before being set. C/C++
-- code should not use this and instead use GetSetMediaItemTakeInfo() with P_SOURCE
-- to manage ownership directly.
--- @within ReaScript Wrapped Methods
--- @param source userdata PCM_source *
--- @return boolean
function Take:set_source(source)
  return r.SetMediaItemTake_Source(self.pointer, source)
end

--- Constants for Take:set_info_value.
--- @within Constants
--- @field D_STARTOFFS number: start offset in source media, in seconds
--- @field D_VOL number: take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped
--- @field D_PAN number: take pan, -1..1
--- @field D_PANLAW number: take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc
--- @field D_PLAYRATE number: take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc
--- @field D_PITCH number: take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc
--- @field B_PPITCH boolean: preserve pitch when changing playback rate
--- @field I_LASTY number: Y-position (relative to top of track) in pixels (read-only)
--- @field I_LASTH number: height in pixels (read-only)
--- @field I_CHANMODE number: channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right
--- @field I_PITCHMODE number: pitch shifter mode, -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter
--- @field I_STRETCHFLAGS number: int *stretch marker flags (&7 mask for mode override0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo)
--- @field F_STRETCHFADESIZE float *: stretch marker fade size in seconds (0.0025 default)
--- @field I_RECPASSID number: record pass ID
--- @field I_TAKEFX_NCH number: number of internal audio channels for per-take FX to use (OK to call with setNewValue, but the returned value is read-only)
--- @field I_CUSTOMCOLOR number: custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
--- @field IP_TAKENUMBER number: take number (read-only, returns the take number directly)
Take.SetInfoValueConstants = {
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

--- Set Info Value. Wraps SetMediaItemTakeInfo_Value.
-- Set media item take numerical-value attributes.
--- @within ReaScript Wrapped Methods
--- @param param_name string Take.SetInfoValueConstants
--- @param new_value number
--- @return boolean
--- @see Take.SetInfoValueConstants
function Take:set_info_value(param_name, new_value)
  return r.SetMediaItemTakeInfo_Value(self.pointer, param_name, new_value)
end

--- Set Take Marker. Wraps SetTakeMarker.
-- Inserts or updates a take marker. If idx<0, a take marker will be added,
-- otherwise an existing take marker will be updated. Returns the index of the new
-- or updated take marker (which may change if src_pos is updated).
--- @within ReaScript Wrapped Methods
--- @param idx number
--- @param name_in string
--- @param src_pos number Optional
--- @param color_in integer Optional
--- @return number
--- @see Take:get_marker
--- @see Take:delete_marker
--- @see Take:get_num_markers
function Take:set_marker(idx, name_in, src_pos, color_in)
  local src_pos = src_pos or 0
  local color_in = color_in or 0
  return r.SetTakeMarker(self.pointer, idx, name_in, src_pos, color_in)
end

--- Set Take Stretch Marker. Wraps SetTakeStretchMarker.
-- Adds or updates a stretch marker. If idx<0, stretch marker will be added. If
-- idx>=0, stretch marker will be updated. When adding, if src_pos is
-- omitted, source position will be auto-calculated. When updating a stretch
-- marker, if src_pos is omitted, src_pos will not be modified.
-- Position/src_pos values will be constrained to nearby stretch markers.
-- Returns index of stretch marker, or -1 if did not insert (or marker already
-- existed at time).
--- @within ReaScript Wrapped Methods
--- @param idx number
--- @param pos number
--- @param src_pos number Optional
--- @return number
function Take:set_take_stretch_marker(idx, pos, src_pos)
  local src_pos = src_pos or 0
  return r.SetTakeStretchMarker(self.pointer, idx, pos, src_pos)
end

--- Set Take Stretch Marker Slope. Wraps SetTakeStretchMarkerSlope.
--- @within ReaScript Wrapped Methods
--- @param idx number
--- @param slope number
--- @return boolean
--- @see Take:get_take_stretch_marker_slope
function Take:set_take_stretch_marker_slope(idx, slope)
  return r.SetTakeStretchMarkerSlope(self.pointer, idx, slope)
end

--- Delete Fx. Wraps TakeFX_Delete.
-- Remove a FX from take chain (returns true on success).
--- @within ReaScript Wrapped Methods
--- @param fx number
--- @return boolean
function Take:delete_fx(fx)
  return r.TakeFX_Delete(self.pointer, fx)
end

--- Get Fx Count. Wraps TakeFX_GetCount.
--- @within ReaScript Wrapped Methods
--- @return number
function Take:get_fx_count()
  return r.TakeFX_GetCount(self.pointer)
end

--- Take Is Midi. Wraps TakeIsMIDI.
-- Returns true if the active take contains MIDI.
--- @within ReaScript Wrapped Methods
--- @return boolean
function Take:take_is_midi()
  return r.TakeIsMIDI(self.pointer)
end

--- Get Guid. Wraps BR_GetMediaItemTakeGUID.
-- [BR] Get media item take GUID as a string (guidStringOut_sz should be at least
-- 64). To get take from GUID string, see SNM_GetMediaItemTakeByGUID.
--- @within ReaScript Wrapped Methods
--- @return string
function Take:get_guid()
  return r.BR_GetMediaItemTakeGUID(self.pointer)
end

--- Get Media Source Properties. Wraps BR_GetMediaSourceProperties.
-- [BR] Get take media source properties as they appear in Item properties. Returns
-- false if take can't have them (MIDI items etc.). To set source properties, see
-- BR_SetMediaSourceProperties.
--- @within ReaScript Wrapped Methods
--- @return boolean section
--- @return number start
--- @return number length
--- @return number fade
--- @return boolean reverse
function Take:get_media_source_properties()
  local ret_val, section, start, length, fade, reverse = r.BR_GetMediaSourceProperties(self.pointer)
  if ret_val then
    return section, start, length, fade, reverse
  else
    error("Error getting media source properties")
  end
end

--- Get Midi Source Len Ppq. Wraps BR_GetMidiSourceLenPPQ.
-- [BR] Get MIDI take source length in PPQ. In case the take isn't MIDI, return
-- value will be -1.
--- @within ReaScript Wrapped Methods
--- @return number
function Take:get_midi_source_len_ppq()
  return r.BR_GetMidiSourceLenPPQ(self.pointer)
end

--- Get Midi Take Pool Guid. Wraps BR_GetMidiTakePoolGUID.
-- [BR] Get MIDI take pool GUID as a string (guidStringOut_sz should be at least
-- 64). Returns true if take is pooled.
--- @within ReaScript Wrapped Methods
--- @return string
function Take:get_midi_take_pool_guid()
  local ret_val, guid_string = r.BR_GetMidiTakePoolGUID(self.pointer)
  if ret_val then
    return guid_string
  else
    error("Error getting MIDI take pool GUID")
  end
end

--- Get Midi Take Tempo Info. Wraps BR_GetMidiTakeTempoInfo.
-- [BR] Get "ignore project tempo" information for MIDI take. Returns true if take
-- can ignore project tempo (no matter if it's actually ignored), otherwise false.
--- @within ReaScript Wrapped Methods
--- @return boolean ignore_proj_tempo
--- @return number bpm
--- @return number num
--- @return number den
function Take:get_midi_take_tempo_info()
  local ret_val, ignore_proj_tempo, bpm, num, den = r.BR_GetMidiTakeTempoInfo(self.pointer)
  if ret_val then
    return ignore_proj_tempo, bpm, num, den
  else
    error("Error getting MIDI take tempo info")
  end
end

--- Is Midi Open In Inline Editor. Wraps BR_IsMidiOpenInInlineEditor.
-- [SWS] Check if take has MIDI inline editor open and returns true or false.
--- @within ReaScript Wrapped Methods
--- @return boolean
function Take:is_midi_open_in_inline_editor()
  return r.BR_IsMidiOpenInInlineEditor(self.pointer)
end

--- Is Take Midi. Wraps BR_IsTakeMidi.
-- [BR] Check if take is MIDI take, in case MIDI take is in-project MIDI source
-- data, inProjectMidiOut will be true, otherwise false.
--- @within ReaScript Wrapped Methods
--- @return boolean
function Take:is_take_midi()
  local ret_val, in_project_midi = r.BR_IsTakeMidi(self.pointer)
  if ret_val then
    return in_project_midi
  else
    error("Error checking if take is MIDI")
  end
end

--- Set Media Source Properties. Wraps BR_SetMediaSourceProperties.
-- [BR] Set take media source properties. Returns false if take can't have them
-- (MIDI items etc.). Section parameters have to be valid only when passing
-- section=true. To get source properties, see BR_GetMediaSourceProperties.
--- @within ReaScript Wrapped Methods
--- @param section boolean
--- @param start number
--- @param length number
--- @param fade number
--- @param reverse boolean
--- @return boolean
function Take:set_media_source_properties(section, start, length, fade, reverse)
  return r.BR_SetMediaSourceProperties(self.pointer, section, start, length, fade, reverse)
end

--- Set Midi Take Tempo Info. Wraps BR_SetMidiTakeTempoInfo.
-- [BR] Set "ignore project tempo" information for MIDI take. Returns true in case
-- the take was successfully updated.
--- @within ReaScript Wrapped Methods
--- @param ignore_proj_tempo boolean
--- @param bpm number
--- @param num number
--- @param den number
--- @return boolean
function Take:set_midi_take_tempo_info(ignore_proj_tempo, bpm, num, den)
  return r.BR_SetMidiTakeTempoInfo(self.pointer, ignore_proj_tempo, bpm, num, den)
end

--- Set Take Source From File. Wraps BR_SetTakeSourceFromFile.
-- [BR] Set new take source from file. To import MIDI file as in-project source
-- data pass inProjectData=true. Returns false if failed. Any take source
-- properties from the previous source will be lost - to preserve them, see
-- BR_SetTakeSourceFromFile2. Note: To set source from existing take, see
-- SNM_GetSetSourceState2.
--- @within ReaScript Wrapped Methods
--- @param filename_in string
--- @param in_project_data boolean
--- @return boolean
function Take:set_take_source_from_file(filename_in, in_project_data)
  return r.BR_SetTakeSourceFromFile(self.pointer, filename_in, in_project_data)
end

--- Set Take Source From File2. Wraps BR_SetTakeSourceFromFile2.
-- [BR] Differs from BR_SetTakeSourceFromFile only that it can also preserve
-- existing take media source properties.
--- @within ReaScript Wrapped Methods
--- @param filename_in string
--- @param in_project_data boolean
--- @param keep_source_properties boolean
--- @return boolean
function Take:set_take_source_from_file2(filename_in, in_project_data, keep_source_properties)
  return r.BR_SetTakeSourceFromFile2(
    self.pointer,
    filename_in,
    in_project_data,
    keep_source_properties
  )
end

--- Alloc Midi Take. Wraps FNG_AllocMidiTake.
-- [FNG] Allocate a RprMidiTake from a take pointer. Returns a NULL pointer if the
-- take is not an in-project MIDI take
--- @within ReaScript Wrapped Methods
--- @return userdata RprMidiTake
function Take:alloc_midi_take()
  return r.FNG_AllocMidiTake(self.pointer)
end

--- Wildcard Parse Take. Wraps GU_WildcardParseTake.
-- Returns a string by parsing wildcards relative to the supplied MediaItem_Take
--- @within ReaScript Wrapped Methods
--- @param input string
--- @return string
function Take:wildcard_parse_take(input)
  return r.GU_WildcardParseTake(self.pointer, input)
end

--- Analyze Take Loudness. Wraps NF_AnalyzeTakeLoudness.
-- Full loudness analysis. retval: returns true on successful analysis, false on
-- MIDI take or when analysis failed for some reason. analyzeTruePeak=true: Also do
-- true peak analysis. Returns true peak value in dBTP and true peak position
-- (relative to item position). Considerably slower than without true peak analysis
-- (since it uses oversampling). Note: Short term uses a time window of 3 sec. for
-- calculation. So for items shorter than this shortTermMaxOut can't be calculated
-- correctly. Momentary uses a time window of 0.4 sec.
--- @within ReaScript Wrapped Methods
--- @param analyze_true_peak boolean
--- @return number lufs_integrated
--- @return number range
--- @return number true_peak
--- @return number true_peak_pos
--- @return number short_term_max
--- @return number momentary_max
function Take:analyze_take_loudness(analyze_true_peak)
  local ret_val, lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max =
    r.NF_AnalyzeTakeLoudness(self.pointer, analyze_true_peak)
  if ret_val then
    return lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max
  else
    error("Error analyzing take loudness")
  end
end

--- Analyze Take Loudness2. Wraps NF_AnalyzeTakeLoudness2.
-- Same as NF_AnalyzeTakeLoudness but additionally returns shortTermMaxPos and
-- momentaryMaxPos (in absolute project time). Note: shortTermMaxPos and
-- momentaryMaxPos indicate the beginning of time intervals, (3 sec. and 0.4 sec.
-- resp.).
--- @within ReaScript Wrapped Methods
--- @param analyze_true_peak boolean
--- @return number lufs_integrated
--- @return number true_peak
--- @return number true_peak_pos
--- @return number short_term_max
--- @return number momentary_max
--- @return number short_term_max_pos
--- @return number momentary_max_pos
function Take:analyze_take_loudness2(analyze_true_peak)
  local ret_val, lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max, short_term_max_pos, momentary_max_pos =
    r.NF_AnalyzeTakeLoudness2(self.pointer, analyze_true_peak)
  if ret_val then
    return lufs_integrated,
      range,
      true_peak,
      true_peak_pos,
      short_term_max,
      momentary_max,
      short_term_max_pos,
      momentary_max_pos
  else
    error("Error analyzing take loudness")
  end
end

--- Analyze Take Loudness Integrated Only. Wraps NF_AnalyzeTakeLoudness_IntegratedOnly.
-- Does LUFS integrated analysis only. Faster than full loudness analysis
-- (NF_AnalyzeTakeLoudness) . Use this if only LUFS integrated is required. Take
-- vol. env. is taken into account. See: Signal flow.
--- @within ReaScript Wrapped Methods
--- @return number
function Take:analyze_take_loudness_integrated_only()
  local ret_val, lufs_integrated = r.NF_AnalyzeTakeLoudness_IntegratedOnly(self.pointer)
  if ret_val then
    return lufs_integrated
  else
    error("Error analyzing take loudness")
  end
end

--- Get Set Source State2. Wraps SNM_GetSetSourceState2.
-- [S&M] Gets or sets a take source state. Returns false if failed. Note: this
-- function cannot deal with empty takes, see SNM_GetSetSourceState.
--- @within ReaScript Wrapped Methods
--- @param state userdata WDL_FastString
--- @param new_value boolean
--- @return boolean
function Take:get_set_source_state2(state, new_value)
  return r.SNM_GetSetSourceState2(self.pointer, state, new_value)
end

return Take
