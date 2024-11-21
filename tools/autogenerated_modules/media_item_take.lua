-- @description MediaItemTake: Provide implementation for MediaItemTake functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local pcm_source = require('pcm_source')


local MediaItemTake = {}



--- Create new MediaItemTake instance.
-- @param take userdata. The pointer to Reaper MediaItem_Take*
-- @return MediaItemTake table.
function MediaItemTake:new(take)
    local obj = {
        pointer_type = constants.PointerTypes.MediaItemTake,
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
-- @param _idx integer
-- @return boolean
function MediaItemTake:delete_take_marker(_idx)
    return r.DeleteTakeMarker(self.pointer, _idx)
end

    
--- Delete Take Stretch Markers.
-- Deletes one or more stretch markers. Returns number of stretch markers deleted.
-- @param _idx integer
-- @param integer countIn optional
-- @return integer
function MediaItemTake:delete_take_stretch_markers(_idx, integer)
    local integer = integer or nil
    return r.DeleteTakeStretchMarkers(self.pointer, _idx, integer)
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
-- @param peakrate number
-- @param starttime number
-- @param numchannels integer
-- @param numsamplesperchannel integer
-- @param want_extra_type integer
-- @param buf reaper.array
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

    
--- Get Info Value.
-- Get media item take numerical-value attributes. D_STARTOFFS : double * : start
-- offset in source media, in seconds D_VOL : double * : take volume, 0=-inf,
-- 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped D_PAN :
-- double * : take pan, -1..1 D_PANLAW : double * : take pan law, -1=default,
-- 0.5=-6dB, 1.0=+0dB, etc D_PLAYRATE : double * : take playback rate, 0.5=half
-- speed, 1=normal, 2=double speed, etc D_PITCH : double * : take pitch adjustment
-- in semitones, -12=one octave down, 0=normal, +12=one octave up, etc B_PPITCH :
-- bool * : preserve pitch when changing playback rate I_LASTY : int * : Y-position
-- (relative to top of track) in pixels (read-only) I_LASTH : int * : height in
-- pixels (read-only) I_CHANMODE : int * : channel mode, 0=normal, 1=reverse
-- stereo, 2=downmix, 3=left, 4=right I_PITCHMODE : int * : pitch shifter mode,
-- -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter
-- I_STRETCHFLAGS : int * : stretch marker flags (&7 mask for mode override:
-- 0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo)
-- F_STRETCHFADESIZE : float * : stretch marker fade size in seconds (0.0025
-- default) I_RECPASSID : int * : record pass ID I_TAKEFX_NCH : int * : number of
-- internal audio channels for per-take FX to use (OK to call with setNewValue, but
-- the returned value is read-only) I_CUSTOMCOLOR : int * : custom color, OS
-- dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not
-- |0x1000000, then it will not be used, but will store the color IP_TAKENUMBER :
-- int : take number (read-only, returns the take number directly) P_TRACK :
-- pointer to MediaTrack (read-only) P_ITEM : pointer to MediaItem (read-only)
-- P_SOURCE : PCM_source *. Note that if setting this, you should first retrieve
-- the old source, set the new, THEN delete the old.
-- @param parmname string
-- @return number
function MediaItemTake:get_info_value(parmname)
    return r.GetMediaItemTakeInfo_Value(self.pointer, parmname)
end

    
--- Get Num Take Markers.
-- Returns number of take markers. See GetTakeMarker, SetTakeMarker,
-- DeleteTakeMarker
-- @return integer
function MediaItemTake:get_num_take_markers()
    return r.GetNumTakeMarkers(self.pointer)
end

    
--- Get Set Info String.
-- Gets/sets a take attribute string: P_NAME : char * : take name P_EXT:xyz : char
-- * : extension-specific persistent data GUID : GUID * : 16-byte GUID, can query
-- or update. If using a _String() function, GUID is a string {xyz-...}.
-- @param parmname string
-- @param string_need_big string
-- @param set_new_value boolean
-- @return string_need_big string
function MediaItemTake:get_set_info_string(parmname, string_need_big, set_new_value)
    local retval, string_need_big = r.GetSetMediaItemTakeInfo_String(self.pointer, parmname, string_need_big, set_new_value)
    if retval then
        return string_need_big
    else
        return nil
    end
end

    
--- Get Take Envelope.
-- @param env_idx integer
-- @return TrackEnvelope table
function MediaItemTake:get_take_envelope(env_idx)
    local result = r.GetTakeEnvelope(self.pointer, env_idx)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Take Envelope By Name.
-- @param envname string
-- @return TrackEnvelope table
function MediaItemTake:get_take_envelope_by_name(envname)
    local result = r.GetTakeEnvelopeByName(self.pointer, envname)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Take Marker.
-- Get information about a take marker. Returns the position in media item source
-- time, or -1 if the take marker does not exist. See GetNumTakeMarkers,
-- SetTakeMarker, DeleteTakeMarker
-- @param _idx integer
-- @return name string
-- @return integer color
function MediaItemTake:get_take_marker(_idx)
    local retval, name, integer = r.GetTakeMarker(self.pointer, _idx)
    if retval then
        return name, integer
    else
        return nil
    end
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
-- @param _idx integer
-- @return pos number
-- @return number srcpos
function MediaItemTake:get_take_stretch_marker(_idx)
    local retval, pos, number = r.GetTakeStretchMarker(self.pointer, _idx)
    if retval then
        return pos, number
    else
        return nil
    end
end

    
--- Get Take Stretch Marker Slope.
-- See SetTakeStretchMarkerSlope
-- @param _idx integer
-- @return number
function MediaItemTake:get_take_stretch_marker_slope(_idx)
    return r.GetTakeStretchMarkerSlope(self.pointer, _idx)
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

    
--- Set Info Value.
-- Set media item take numerical-value attributes. D_STARTOFFS : double * : start
-- offset in source media, in seconds D_VOL : double * : take volume, 0=-inf,
-- 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped D_PAN :
-- double * : take pan, -1..1 D_PANLAW : double * : take pan law, -1=default,
-- 0.5=-6dB, 1.0=+0dB, etc D_PLAYRATE : double * : take playback rate, 0.5=half
-- speed, 1=normal, 2=double speed, etc D_PITCH : double * : take pitch adjustment
-- in semitones, -12=one octave down, 0=normal, +12=one octave up, etc B_PPITCH :
-- bool * : preserve pitch when changing playback rate I_LASTY : int * : Y-position
-- (relative to top of track) in pixels (read-only) I_LASTH : int * : height in
-- pixels (read-only) I_CHANMODE : int * : channel mode, 0=normal, 1=reverse
-- stereo, 2=downmix, 3=left, 4=right I_PITCHMODE : int * : pitch shifter mode,
-- -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter
-- I_STRETCHFLAGS : int * : stretch marker flags (&7 mask for mode override:
-- 0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo)
-- F_STRETCHFADESIZE : float * : stretch marker fade size in seconds (0.0025
-- default) I_RECPASSID : int * : record pass ID I_TAKEFX_NCH : int * : number of
-- internal audio channels for per-take FX to use (OK to call with setNewValue, but
-- the returned value is read-only) I_CUSTOMCOLOR : int * : custom color, OS
-- dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not
-- |0x1000000, then it will not be used, but will store the color IP_TAKENUMBER :
-- int : take number (read-only, returns the take number directly)
-- @param parmname string
-- @param newvalue number
-- @return boolean
function MediaItemTake:set_info_value(parmname, newvalue)
    return r.SetMediaItemTakeInfo_Value(self.pointer, parmname, newvalue)
end

    
--- Set Take Marker.
-- Inserts or updates a take marker. If idx<0, a take marker will be added,
-- otherwise an existing take marker will be updated. Returns the index of the new
-- or updated take marker (which may change if srcPos is updated). See
-- GetNumTakeMarkers, GetTakeMarker, DeleteTakeMarker
-- @param _idx integer
-- @param name_in string
-- @param number srcposIn optional
-- @param integer colorIn optional
-- @return integer
function MediaItemTake:set_take_marker(_idx, name_in, number, integer)
    local number = number or nil
    local integer = integer or nil
    return r.SetTakeMarker(self.pointer, _idx, name_in, number, integer)
end

    
--- Set Take Stretch Marker.
-- Adds or updates a stretch marker. If idx<0, stretch marker will be added. If
-- idx>=0, stretch marker will be updated. When adding, if srcposInOptional is
-- omitted, source position will be auto-calculated. When updating a stretch
-- marker, if srcposInOptional is omitted, srcpos will not be modified.
-- Position/srcposition values will be constrained to nearby stretch markers.
-- Returns index of stretch marker, or -1 if did not insert (or marker already
-- existed at time).
-- @param _idx integer
-- @param pos number
-- @param number srcposIn optional
-- @return integer
function MediaItemTake:set_take_stretch_marker(_idx, pos, number)
    local number = number or nil
    return r.SetTakeStretchMarker(self.pointer, _idx, pos, number)
end

    
--- Set Take Stretch Marker Slope.
-- See GetTakeStretchMarkerSlope
-- @param _idx integer
-- @param slope number
-- @return boolean
function MediaItemTake:set_take_stretch_marker_slope(_idx, slope)
    return r.SetTakeStretchMarkerSlope(self.pointer, _idx, slope)
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
-- @return section boolean
-- @return start number
-- @return length number
-- @return fade number
-- @return reverse boolean
function MediaItemTake:get_media_source_properties()
    local retval, section, start, length, fade, reverse = r.BR_GetMediaSourceProperties(self.pointer)
    if retval then
        return section, start, length, fade, reverse
    else
        return nil
    end
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
-- @return guid_string string
function MediaItemTake:get_midi_take_pool_guid()
    local retval, guid_string = r.BR_GetMidiTakePoolGUID(self.pointer)
    if retval then
        return guid_string
    else
        return nil
    end
end

    
--- Get Midi Take Tempo Info.
-- [BR] Get "ignore project tempo" information for MIDI take. Returns true if take
-- can ignore project tempo (no matter if it's actually ignored), otherwise false.
-- @return ignore_proj_tempo boolean
-- @return bpm number
-- @return num integer
-- @return den integer
function MediaItemTake:get_midi_take_tempo_info()
    local retval, ignore_proj_tempo, bpm, num, den = r.BR_GetMidiTakeTempoInfo(self.pointer)
    if retval then
        return ignore_proj_tempo, bpm, num, den
    else
        return nil
    end
end

    
--- Get Take Fx Count.
-- [BR] Returns FX count for supplied take
-- @return integer
function MediaItemTake:get_take_fx_count()
    return r.BR_GetTakeFXCount(self.pointer)
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
-- @return in_project_midi boolean
function MediaItemTake:is_take_midi()
    local retval, in_project_midi = r.BR_IsTakeMidi(self.pointer)
    if retval then
        return in_project_midi
    else
        return nil
    end
end

    
--- Set Media Source Properties.
-- [BR] Set take media source properties. Returns false if take can't have them
-- (MIDI items etc.). Section parameters have to be valid only when passing
-- section=true. To get source properties, see BR_GetMediaSourceProperties.
-- @param section boolean
-- @param start number
-- @param length number
-- @param fade number
-- @param reverse boolean
-- @return boolean
function MediaItemTake:set_media_source_properties(section, start, length, fade, reverse)
    return r.BR_SetMediaSourceProperties(self.pointer, section, start, length, fade, reverse)
end

    
--- Set Midi Take Tempo Info.
-- [BR] Set "ignore project tempo" information for MIDI take. Returns true in case
-- the take was successfully updated.
-- @param ignore_proj_tempo boolean
-- @param bpm number
-- @param num integer
-- @param den integer
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
-- @param filename_in string
-- @param in_project_data boolean
-- @return boolean
function MediaItemTake:set_take_source_from_file(filename_in, in_project_data)
    return r.BR_SetTakeSourceFromFile(self.pointer, filename_in, in_project_data)
end

    
--- Set Take Source From File2.
-- [BR] Differs from BR_SetTakeSourceFromFile only that it can also preserve
-- existing take media source properties.
-- @param filename_in string
-- @param in_project_data boolean
-- @param keep_source_properties boolean
-- @return boolean
function MediaItemTake:set_take_source_from_file2(filename_in, in_project_data, keep_source_properties)
    return r.BR_SetTakeSourceFromFile2(self.pointer, filename_in, in_project_data, keep_source_properties)
end

    
--- Get Take Fx Chain.
-- Return a handle to the given take FX chain window. HACK: This temporarily
-- renames the take in order to disambiguate the take FX chain window from
-- similarily named takes.
-- @return FxChain
function MediaItemTake:get_take_fx_chain()
    return r.CF_GetTakeFXChain(self.pointer)
end

    
--- Select Take Fx.
-- Set which take effect is active in the take's FX chain. The FX chain window does
-- not have to be open.
-- @param index integer
-- @return boolean
function MediaItemTake:select_take_fx(index)
    return r.CF_SelectTakeFX(self.pointer, index)
end

return MediaItemTake
