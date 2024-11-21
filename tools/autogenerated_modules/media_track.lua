-- @description MediaTrack: Provide implementation for MediaTrack functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_item = require('media_item')


local MediaTrack = {}



--- Create new MediaTrack instance.
-- @param media_track userdata. The pointer to Reaper MediaTrack*
-- @return MediaTrack table.
function MediaTrack:new(media_track)
    local obj = {
        pointer_type = constants.PointerTypes.MediaTrack,
        pointer = media_track
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the MediaTrack logger.
-- @param ... (varargs) Messages to log.
function MediaTrack:log(...)
    local logger = helpers.log_func('MediaTrack')
    logger(...)
    return nil
end

    
--- Add Media Item To Track.
-- creates a new media item.
-- @return MediaItem table
function MediaTrack:add_media_item_to_track()
    local result = r.AddMediaItemToTrack(self.pointer)
    return media_item.MediaItem:new(result)
end

    
--- Count Track Envelopes.
-- see GetTrackEnvelope
-- @return integer
function MediaTrack:count_track_envelopes()
    return r.CountTrackEnvelopes(self.pointer)
end

    
--- Count Track Media Items.
-- count the number of items in the track
-- @return integer
function MediaTrack:count_track_media_items()
    return r.CountTrackMediaItems(self.pointer)
end

    
--- Create New Midi Item In Proj.
-- Create a new MIDI media item, containing no MIDI events. Time is in seconds
-- unless qn is set.
-- @param starttime number
-- @param endtime number
-- @param boolean qnIn optional
-- @return MediaItem table
function MediaTrack:create_new_midi_item_in_proj(starttime, endtime, boolean)
    local boolean = boolean or nil
    local result = r.CreateNewMIDIItemInProj(self.pointer, starttime, endtime, boolean)
    return media_item.MediaItem:new(result)
end

    
--- Create Track Audio Accessor.
-- Create an audio accessor object for this track. Must only call from the main
-- thread. See CreateTakeAudioAccessor, DestroyAudioAccessor,
-- AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime,
-- GetAudioAccessorSamples.
-- @return AudioAccessor table
function MediaTrack:create_track_audio_accessor()
    local result = r.CreateTrackAudioAccessor(self.pointer)
    return audio_accessor.AudioAccessor:new(result)
end

    
--- Create Track Send.
-- Create a send/receive (desttrInOptional!=NULL), or a hardware output
-- (desttrInOptional==NULL) with default properties, return >=0 on success (== new
-- send/receive index). See RemoveTrackSend, GetSetTrackSendInfo,
-- GetTrackSendInfo_Value, SetTrackSendInfo_Value.
-- @return integer
function MediaTrack:create_track_send()
    return r.CreateTrackSend(self.pointer, desttr_in)
end

    
--- Delete Track.
-- deletes a track
function MediaTrack:delete_track()
    return r.DeleteTrack(self.pointer)
end

    
--- Delete Track Media Item.
-- @return boolean
function MediaTrack:delete_track_media_item()
    return r.DeleteTrackMediaItem(self.pointer, it)
end

    
--- Get Fx Envelope.
-- Returns the FX parameter envelope. If the envelope does not exist and
-- create=true, the envelope will be created. If the envelope already exists and is
-- bypassed and create=true, then the envelope will be unbypassed.
-- @param fxindex integer
-- @param parameterindex integer
-- @param create boolean
-- @return TrackEnvelope table
function MediaTrack:get_fx_envelope(fxindex, parameterindex, create)
    local result = r.GetFXEnvelope(self.pointer, fxindex, parameterindex, create)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Parent Track.
-- @return MediaTrack table
function MediaTrack:get_parent_track()
    local result = r.GetParentTrack(self.pointer)
    return media_track.MediaTrack:new(result)
end

    
--- Get Set Info String.
-- Get or set track string attributes. P_NAME : char * : track name (on master
-- returns NULL) P_ICON : const char * : track icon (full filename, or relative to
-- resource_path/data/track_icons) P_LANENAME:n : char * : lane name (returns NULL
-- for non-fixed-lane-tracks) P_MCP_LAYOUT : const char * : layout name
-- P_RAZOREDITS : const char * : list of razor edit areas, as space-separated
-- triples of start time, end time, and envelope GUID string.   Example: "0.0 1.0
-- \"\" 0.0 1.0 "{xyz-...}" P_RAZOREDITS_EXT : const char * : list of razor edit
-- areas, as comma-separated sets of space-separated tuples of start time, end
-- time, optional: envelope GUID string, fixed/fipm top y-position, fixed/fipm
-- bottom y-position.   Example: "0.0 1.0,0.0 1.0 "{xyz-...}",1.0 2.0 "" 0.25 0.75"
-- P_TCP_LAYOUT : const char * : layout name P_EXT:xyz : char * : extension-
-- specific persistent data P_UI_RECT:tcp.mute : char * : read-only, allows
-- querying screen position + size of track WALTER elements (tcp.size queries
-- screen position and size of entire TCP, etc). GUID : GUID * : 16-byte GUID, can
-- query or update. If using a _String() function, GUID is a string {xyz-...}.
-- @param parmname string
-- @param string_need_big string
-- @param set_new_value boolean
-- @return string_need_big string
function MediaTrack:get_set_info_string(parmname, string_need_big, set_new_value)
    local retval, string_need_big = r.GetSetMediaTrackInfo_String(self.pointer, parmname, string_need_big, set_new_value)
    if retval then
        return string_need_big
    else
        return nil
    end
end

    
--- Get Set Track Group Membership.
-- Gets or modifies the group membership for a track. Returns group state prior to
-- call (each bit represents one of the 32 group numbers). if setmask has bits set,
-- those bits in setvalue will be applied to group. Group can be one of:
-- MEDIA_EDIT_LEAD MEDIA_EDIT_FOLLOW VOLUME_LEAD VOLUME_FOLLOW VOLUME_VCA_LEAD
-- VOLUME_VCA_FOLLOW PAN_LEAD PAN_FOLLOW WIDTH_LEAD WIDTH_FOLLOW MUTE_LEAD
-- MUTE_FOLLOW SOLO_LEAD SOLO_FOLLOW RECARM_LEAD RECARM_FOLLOW POLARITY_LEAD
-- POLARITY_FOLLOW AUTOMODE_LEAD AUTOMODE_FOLLOW VOLUME_REVERSE PAN_REVERSE
-- WIDTH_REVERSE NO_LEAD_WHEN_FOLLOW VOLUME_VCA_FOLLOW_ISPREFX
-- @param groupname string
-- @param setmask integer
-- @param setvalue integer
-- @return integer
function MediaTrack:get_set_track_group_membership(groupname, setmask, setvalue)
    return r.GetSetTrackGroupMembership(self.pointer, groupname, setmask, setvalue)
end

    
--- Get Set Track Group Membership Ex.
-- Gets or modifies 32 bits (at offset, where 0 is the low 32 bits of the grouping)
-- of the group membership for a track. Returns group state prior to call. if
-- setmask has bits set, those bits in setvalue will be applied to group. Group can
-- be one of: MEDIA_EDIT_LEAD MEDIA_EDIT_FOLLOW VOLUME_LEAD VOLUME_FOLLOW
-- VOLUME_VCA_LEAD VOLUME_VCA_FOLLOW PAN_LEAD PAN_FOLLOW WIDTH_LEAD WIDTH_FOLLOW
-- MUTE_LEAD MUTE_FOLLOW SOLO_LEAD SOLO_FOLLOW RECARM_LEAD RECARM_FOLLOW
-- POLARITY_LEAD POLARITY_FOLLOW AUTOMODE_LEAD AUTOMODE_FOLLOW VOLUME_REVERSE
-- PAN_REVERSE WIDTH_REVERSE NO_LEAD_WHEN_FOLLOW VOLUME_VCA_FOLLOW_ISPREFX
-- @param groupname string
-- @param offset integer
-- @param setmask integer
-- @param setvalue integer
-- @return integer
function MediaTrack:get_set_track_group_membership_ex(groupname, offset, setmask, setvalue)
    return r.GetSetTrackGroupMembershipEx(self.pointer, groupname, offset, setmask, setvalue)
end

    
--- Get Set Track Group Membership High.
-- Gets or modifies the group membership for a track. Returns group state prior to
-- call (each bit represents one of the high 32 group numbers). if setmask has bits
-- set, those bits in setvalue will be applied to group. Group can be one of:
-- MEDIA_EDIT_LEAD MEDIA_EDIT_FOLLOW VOLUME_LEAD VOLUME_FOLLOW VOLUME_VCA_LEAD
-- VOLUME_VCA_FOLLOW PAN_LEAD PAN_FOLLOW WIDTH_LEAD WIDTH_FOLLOW MUTE_LEAD
-- MUTE_FOLLOW SOLO_LEAD SOLO_FOLLOW RECARM_LEAD RECARM_FOLLOW POLARITY_LEAD
-- POLARITY_FOLLOW AUTOMODE_LEAD AUTOMODE_FOLLOW VOLUME_REVERSE PAN_REVERSE
-- WIDTH_REVERSE NO_LEAD_WHEN_FOLLOW VOLUME_VCA_FOLLOW_ISPREFX
-- @param groupname string
-- @param setmask integer
-- @param setvalue integer
-- @return integer
function MediaTrack:get_set_track_group_membership_high(groupname, setmask, setvalue)
    return r.GetSetTrackGroupMembershipHigh(self.pointer, groupname, setmask, setvalue)
end

    
--- Get Set Track Send Info String.
-- Gets/sets a send attribute string: P_EXT:xyz : char * : extension-specific
-- persistent data
-- @param category integer
-- @param send_idx integer
-- @param parmname string
-- @param string_need_big string
-- @param set_new_value boolean
-- @return string_need_big string
function MediaTrack:get_set_track_send_info_string(category, send_idx, parmname, string_need_big, set_new_value)
    local retval, string_need_big = r.GetSetTrackSendInfo_String(self.pointer, category, send_idx, parmname, string_need_big, set_new_value)
    if retval then
        return string_need_big
    else
        return nil
    end
end

    
--- Get Track Automation Mode.
-- return the track mode, regardless of global override
-- @return integer
function MediaTrack:get_track_automation_mode()
    return r.GetTrackAutomationMode(self.pointer)
end

    
--- Get Track Color.
-- Returns the track custom color as OS dependent color|0x1000000 (i.e.
-- ColorToNative(r,g,b)|0x1000000). Black is returned as 0x1000000, no color
-- setting is returned as 0.
-- @return integer
function MediaTrack:get_track_color()
    return r.GetTrackColor(self.pointer)
end

    
--- Get Track Depth.
-- @return integer
function MediaTrack:get_track_depth()
    return r.GetTrackDepth(self.pointer)
end

    
--- Get Track Envelope.
-- @param env_idx integer
-- @return TrackEnvelope table
function MediaTrack:get_track_envelope(env_idx)
    local result = r.GetTrackEnvelope(self.pointer, env_idx)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Track Envelope By Chunk Name.
-- Gets a built-in track envelope by configuration chunk name, like "<VOLENV", or
-- GUID string, like "{B577250D-146F-B544-9B34-F24FBE488F1F}".
-- @param cfgchunkname_or_guid string
-- @return TrackEnvelope table
function MediaTrack:get_track_envelope_by_chunk_name(cfgchunkname_or_guid)
    local result = r.GetTrackEnvelopeByChunkName(self.pointer, cfgchunkname_or_guid)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Track Envelope By Name.
-- @param envname string
-- @return TrackEnvelope table
function MediaTrack:get_track_envelope_by_name(envname)
    local result = r.GetTrackEnvelopeByName(self.pointer, envname)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Track Guid.
-- @return guid string
function MediaTrack:get_track_guid()
    return r.GetTrackGUID(self.pointer)
end

    
--- Get Track Media Item.
-- @param item_idx integer
-- @return MediaItem table
function MediaTrack:get_track_media_item(item_idx)
    local result = r.GetTrackMediaItem(self.pointer, item_idx)
    return media_item.MediaItem:new(result)
end

    
--- Get Track Midi Lyrics.
-- Get all MIDI lyrics on the track. Lyrics will be returned as one string with
-- tabs between each word. flag&1: double tabs at the end of each measure and
-- triple tabs when skipping measures, flag&2: each lyric is preceded by its beat
-- position in the project (example with flag=2: "1.1.2\tLyric for measure 1 beat
-- 2\t2.1.1\tLyric for measure 2 beat 1      "). See SetTrackMIDILyrics
-- @param flag integer
-- @return buf string
function MediaTrack:get_track_midi_lyrics(flag)
    local retval, buf = r.GetTrackMIDILyrics(self.pointer, flag)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Track Name.
-- Returns "MASTER" for master track, "Track N" if track has no name.
-- @return buf string
function MediaTrack:get_track_name()
    local retval, buf = r.GetTrackName(self.pointer)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Track Num Media Items.
-- @return integer
function MediaTrack:get_track_num_media_items()
    return r.GetTrackNumMediaItems(self.pointer)
end

    
--- Get Track Num Sends.
-- returns number of sends/receives/hardware outputs - category is <0 for receives,
-- 0=sends, >0 for hardware outputs
-- @param category integer
-- @return integer
function MediaTrack:get_track_num_sends(category)
    return r.GetTrackNumSends(self.pointer, category)
end

    
--- Get Track Receive Name.
-- See GetTrackSendName.
-- @param recv_index integer
-- @return buf string
function MediaTrack:get_track_receive_name(recv_index)
    local retval, buf = r.GetTrackReceiveName(self.pointer, recv_index)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Track Receive Ui Mute.
-- See GetTrackSendUIMute.
-- @param recv_index integer
-- @return mute boolean
function MediaTrack:get_track_receive_ui_mute(recv_index)
    local retval, mute = r.GetTrackReceiveUIMute(self.pointer, recv_index)
    if retval then
        return mute
    else
        return nil
    end
end

    
--- Get Track Receive Ui Vol Pan.
-- See GetTrackSendUIVolPan.
-- @param recv_index integer
-- @return volume number
-- @return pan number
function MediaTrack:get_track_receive_ui_vol_pan(recv_index)
    local retval, volume, pan = r.GetTrackReceiveUIVolPan(self.pointer, recv_index)
    if retval then
        return volume, pan
    else
        return nil
    end
end

    
--- Get Track Send Name.
-- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveName.
-- @param send_index integer
-- @return buf string
function MediaTrack:get_track_send_name(send_index)
    local retval, buf = r.GetTrackSendName(self.pointer, send_index)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Track Send Ui Mute.
-- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See
-- GetTrackReceiveUIMute.
-- @param send_index integer
-- @return mute boolean
function MediaTrack:get_track_send_ui_mute(send_index)
    local retval, mute = r.GetTrackSendUIMute(self.pointer, send_index)
    if retval then
        return mute
    else
        return nil
    end
end

    
--- Get Track Send Ui Vol Pan.
-- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See
-- GetTrackReceiveUIVolPan.
-- @param send_index integer
-- @return volume number
-- @return pan number
function MediaTrack:get_track_send_ui_vol_pan(send_index)
    local retval, volume, pan = r.GetTrackSendUIVolPan(self.pointer, send_index)
    if retval then
        return volume, pan
    else
        return nil
    end
end

    
--- Get Track State.
-- Gets track state, returns track name. flags will be set to: &1=folder
-- &2=selected &4=has fx enabled &8=muted &16=soloed &32=SIP'd (with &16) &64=rec
-- armed &128=rec monitoring on &256=rec monitoring auto &512=hide from TCP
-- &1024=hide from MCP
-- @return flags integer
function MediaTrack:get_track_state()
    local retval, flags = r.GetTrackState(self.pointer)
    if retval then
        return flags
    else
        return nil
    end
end

    
--- Get Track State Chunk.
-- Gets the RPPXML state of a track, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string
-- @param is_undo boolean
-- @return str string
function MediaTrack:get_track_state_chunk(str, is_undo)
    local retval, str = r.GetTrackStateChunk(self.pointer, str, is_undo)
    if retval then
        return str
    else
        return nil
    end
end

    
--- Get Track Ui Mute.
-- @return mute boolean
function MediaTrack:get_track_ui_mute()
    local retval, mute = r.GetTrackUIMute(self.pointer)
    if retval then
        return mute
    else
        return nil
    end
end

    
--- Get Track Ui Pan.
-- @return pan1 number
-- @return pan2 number
-- @return panmode integer
function MediaTrack:get_track_ui_pan()
    local retval, pan1, pan2, panmode = r.GetTrackUIPan(self.pointer)
    if retval then
        return pan1, pan2, panmode
    else
        return nil
    end
end

    
--- Get Track Ui Vol Pan.
-- @return volume number
-- @return pan number
function MediaTrack:get_track_ui_vol_pan()
    local retval, volume, pan = r.GetTrackUIVolPan(self.pointer)
    if retval then
        return volume, pan
    else
        return nil
    end
end

    
--- Is Track Selected.
-- @return boolean
function MediaTrack:is_track_selected()
    return r.IsTrackSelected(self.pointer)
end

    
--- Is Track Visible.
-- If mixer==true, returns true if the track is visible in the mixer.  If
-- mixer==false, returns true if the track is visible in the track control panel.
-- @param mixer boolean
-- @return boolean
function MediaTrack:is_track_visible(mixer)
    return r.IsTrackVisible(self.pointer, mixer)
end

    
--- Mark Track Items Dirty.
-- If track is supplied, item is ignored
function MediaTrack:mark_track_items_dirty()
    return r.MarkTrackItemsDirty(self.pointer, item)
end

    
--- Midi Editor Flags For Track.
-- Get or set MIDI editor settings for this track. pitchwheelrange: semitones up or
-- down. flags &1: snap pitch lane edits to semitones if pitchwheel range is
-- defined.
-- @param pitchwheelrange integer
-- @param flags integer
-- @param is__set boolean
-- @return pitchwheelrange integer
-- @return flags integer
function MediaTrack:midi_editor_flags_for_track(pitchwheelrange, flags, is__set)
    return r.MIDIEditorFlagsForTrack(self.pointer, pitchwheelrange, flags, is__set)
end

    
--- Remove Track Send.
-- Remove a send/receive/hardware output, return true on success. category is <0
-- for receives, 0=sends, >0 for hardware outputs. See CreateTrackSend,
-- GetSetTrackSendInfo, GetTrackSendInfo_Value, SetTrackSendInfo_Value,
-- GetTrackNumSends.
-- @param category integer
-- @param send_idx integer
-- @return boolean
function MediaTrack:remove_track_send(category, send_idx)
    return r.RemoveTrackSend(self.pointer, category, send_idx)
end

    
--- Set Mixer Scroll.
-- Scroll the mixer so that leftmosttrack is the leftmost visible track. Returns
-- the leftmost track after scrolling, which may be different from the passed-in
-- track if there are not enough tracks to its right.
-- @return MediaTrack table
function MediaTrack:set_mixer_scroll()
    local result = r.SetMixerScroll(self.pointer)
    return media_track.MediaTrack:new(result)
end

    
--- Set Only Track Selected.
-- Set exactly one track selected, deselect all others
function MediaTrack:set_only_track_selected()
    return r.SetOnlyTrackSelected(self.pointer)
end

    
--- Set Track Automation Mode.
-- @param mode integer
function MediaTrack:set_track_automation_mode(mode)
    return r.SetTrackAutomationMode(self.pointer, mode)
end

    
--- Set Track Color.
-- Set the custom track color, color is OS dependent (i.e. ColorToNative(r,g,b). To
-- unset the track color, see SetMediaTrackInfo_Value I_CUSTOMCOLOR
-- @param color integer
function MediaTrack:set_track_color(color)
    return r.SetTrackColor(self.pointer, color)
end

    
--- Set Track Midi Lyrics.
-- Set all MIDI lyrics on the track. Lyrics will be stuffed into any MIDI items
-- found in range. Flag is unused at present. str is passed in as beat position,
-- tab, text, tab (example with flag=2: "1.1.2\tLyric for measure 1 beat
-- 2\t2.1.1\tLyric for measure 2 beat 1   "). See GetTrackMIDILyrics
-- @param flag integer
-- @param str string
-- @return boolean
function MediaTrack:set_track_midi_lyrics(flag, str)
    return r.SetTrackMIDILyrics(self.pointer, flag, str)
end

    
--- Set Track Selected.
-- @param selected boolean
function MediaTrack:set_track_selected(selected)
    return r.SetTrackSelected(self.pointer, selected)
end

    
--- Set Track Send Ui Pan.
-- send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1
-- for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
-- @param send__idx integer
-- @param pan number
-- @param is_end integer
-- @return boolean
function MediaTrack:set_track_send_ui_pan(send__idx, pan, is_end)
    return r.SetTrackSendUIPan(self.pointer, send__idx, pan, is_end)
end

    
--- Set Track Send Ui Vol.
-- send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1
-- for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
-- @param send__idx integer
-- @param vol number
-- @param is_end integer
-- @return boolean
function MediaTrack:set_track_send_ui_vol(send__idx, vol, is_end)
    return r.SetTrackSendUIVol(self.pointer, send__idx, vol, is_end)
end

    
--- Set Track State Chunk.
-- Sets the RPPXML state of a track, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string
-- @param is_undo boolean
-- @return boolean
function MediaTrack:set_track_state_chunk(str, is_undo)
    return r.SetTrackStateChunk(self.pointer, str, is_undo)
end

    
--- Set Track Ui Input Monitor.
-- monitor: 0=no monitoring, 1=monitoring, 2=auto-monitoring. returns new value or
-- -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent
-- selection ganging
-- @param monitor integer
-- @param igngroupflags integer
-- @return integer
function MediaTrack:set_track_ui_input_monitor(monitor, igngroupflags)
    return r.SetTrackUIInputMonitor(self.pointer, monitor, igngroupflags)
end

    
--- Set Track Ui Mute.
-- mute: <0 toggles, >0 sets mute, 0=unsets mute. returns new value or -1 if error.
-- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
-- @param mute integer
-- @param igngroupflags integer
-- @return integer
function MediaTrack:set_track_ui_mute(mute, igngroupflags)
    return r.SetTrackUIMute(self.pointer, mute, igngroupflags)
end

    
--- Set Track Ui Pan.
-- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
-- @param pan number
-- @param relative boolean
-- @param done boolean
-- @param igngroupflags integer
-- @return number
function MediaTrack:set_track_ui_pan(pan, relative, done, igngroupflags)
    return r.SetTrackUIPan(self.pointer, pan, relative, done, igngroupflags)
end

    
--- Set Track Ui Polarity.
-- polarity (AKA phase): <0 toggles, 0=normal, >0=inverted. returns new value or -1
-- if error.igngroupflags: &1 to prevent track grouping, &2 to prevent selection
-- ganging
-- @param polarity integer
-- @param igngroupflags integer
-- @return integer
function MediaTrack:set_track_ui_polarity(polarity, igngroupflags)
    return r.SetTrackUIPolarity(self.pointer, polarity, igngroupflags)
end

    
--- Set Track Ui Rec Arm.
-- recarm: <0 toggles, >0 sets recarm, 0=unsets recarm. returns new value or -1 if
-- error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection
-- ganging
-- @param recarm integer
-- @param igngroupflags integer
-- @return integer
function MediaTrack:set_track_ui_rec_arm(recarm, igngroupflags)
    return r.SetTrackUIRecArm(self.pointer, recarm, igngroupflags)
end

    
--- Set Track Ui Solo.
-- solo: <0 toggles, 1 sets solo (default mode), 0=unsets solo, 2 sets solo (non-
-- SIP), 4 sets solo (SIP). returns new value or -1 if error. igngroupflags: &1 to
-- prevent track grouping, &2 to prevent selection ganging
-- @param solo integer
-- @param igngroupflags integer
-- @return integer
function MediaTrack:set_track_ui_solo(solo, igngroupflags)
    return r.SetTrackUISolo(self.pointer, solo, igngroupflags)
end

    
--- Set Track Ui Volume.
-- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
-- @param volume number
-- @param relative boolean
-- @param done boolean
-- @param igngroupflags integer
-- @return number
function MediaTrack:set_track_ui_volume(volume, relative, done, igngroupflags)
    return r.SetTrackUIVolume(self.pointer, volume, relative, done, igngroupflags)
end

    
--- Set Track Ui Width.
-- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
-- @param width number
-- @param relative boolean
-- @param done boolean
-- @param igngroupflags integer
-- @return number
function MediaTrack:set_track_ui_width(width, relative, done, igngroupflags)
    return r.SetTrackUIWidth(self.pointer, width, relative, done, igngroupflags)
end

    
--- Toggle Track Send Ui Mute.
-- send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends.
-- @param send__idx integer
-- @return boolean
function MediaTrack:toggle_track_send_ui_mute(send__idx)
    return r.ToggleTrackSendUIMute(self.pointer, send__idx)
end

    
--- Br Get Freeze Count.
-- [BR] Get media track freeze count (if track isn't frozen at all, returns 0).
-- @return integer
function MediaTrack:br_get_freeze_count()
    return r.BR_GetMediaTrackFreezeCount(self.pointer)
end

    
--- Br Get Send Info Envelope.
-- [BR] Get track envelope for send/receive/hardware output.
-- @param category integer
-- @param send_idx integer
-- @param envelope_type integer
-- @return TrackEnvelope table
function MediaTrack:br_get_send_info_envelope(category, send_idx, envelope_type)
    local result = r.BR_GetMediaTrackSendInfo_Envelope(self.pointer, category, send_idx, envelope_type)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Br Get Send Info Track.
-- [BR] Get source or destination media track for send/receive.
-- @param category integer
-- @param send_idx integer
-- @param track_type integer
-- @return MediaTrack table
function MediaTrack:br_get_send_info_track(category, send_idx, track_type)
    local result = r.BR_GetMediaTrackSendInfo_Track(self.pointer, category, send_idx, track_type)
    return media_track.MediaTrack:new(result)
end

    
--- Get Set Track Send Info.
-- [BR] Get or set send attributes.
-- @param category integer
-- @param send_idx integer
-- @param parmname string
-- @param set_new_value boolean
-- @param new_value number
-- @return number
function MediaTrack:get_set_track_send_info(category, send_idx, parmname, set_new_value, new_value)
    return r.BR_GetSetTrackSendInfo(self.pointer, category, send_idx, parmname, set_new_value, new_value)
end

    
--- Get Track Fx Chain.
-- Return a handle to the given track FX chain window.
-- @return FxChain
function MediaTrack:get_track_fx_chain()
    return r.CF_GetTrackFXChain(self.pointer)
end

    
--- Select Track Fx.
-- Set which track effect is active in the track's FX chain. The FX chain window
-- does not have to be open.
-- @param index integer
-- @return boolean
function MediaTrack:select_track_fx(index)
    return r.CF_SelectTrackFX(self.pointer, index)
end

return MediaTrack
