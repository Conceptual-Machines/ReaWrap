-- @description Provide implementation for MediaTrack functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')
local media_item = require('media_item')


local MediaTrack = {}



--- Create new MediaTrack instance.
-- @param media_track userdata. The pointer to Reaper MediaTrack*
-- @return MediaTrack table.
function MediaTrack:new(media_track)
    local obj = {
        pointer_type = "MediaTrack*",
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
-- @param starttime number.
-- @param endtime number.
-- @param boolean qnIn Optional.
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

    
--- Get Touch State.
-- @param is_pan integer.
-- @return boolean
function MediaTrack:get_touch_state(is_pan)
    return r.CSurf_GetTouchState(self.pointer, is_pan)
end

    
--- On Fx Change.
-- @param en integer.
-- @return boolean
function MediaTrack:on_fx_change(en)
    return r.CSurf_OnFXChange(self.pointer, en)
end

    
--- On Input Monitor Change.
-- @param monitor integer.
-- @return integer
function MediaTrack:on_input_monitor_change(monitor)
    return r.CSurf_OnInputMonitorChange(self.pointer, monitor)
end

    
--- On Input Monitor Change Ex.
-- @param monitor integer.
-- @param allowgang boolean.
-- @return integer
function MediaTrack:on_input_monitor_change_ex(monitor, allowgang)
    return r.CSurf_OnInputMonitorChangeEx(self.pointer, monitor, allowgang)
end

    
--- On Mute Change.
-- @param mute integer.
-- @return boolean
function MediaTrack:on_mute_change(mute)
    return r.CSurf_OnMuteChange(self.pointer, mute)
end

    
--- On Mute Change Ex.
-- @param mute integer.
-- @param allowgang boolean.
-- @return boolean
function MediaTrack:on_mute_change_ex(mute, allowgang)
    return r.CSurf_OnMuteChangeEx(self.pointer, mute, allowgang)
end

    
--- On Pan Change.
-- @param pan number.
-- @param relative boolean.
-- @return number
function MediaTrack:on_pan_change(pan, relative)
    return r.CSurf_OnPanChange(self.pointer, pan, relative)
end

    
--- On Pan Change Ex.
-- @param pan number.
-- @param relative boolean.
-- @param allow_gang boolean.
-- @return number
function MediaTrack:on_pan_change_ex(pan, relative, allow_gang)
    return r.CSurf_OnPanChangeEx(self.pointer, pan, relative, allow_gang)
end

    
--- On Rec Arm Change.
-- @param recarm integer.
-- @return boolean
function MediaTrack:on_rec_arm_change(recarm)
    return r.CSurf_OnRecArmChange(self.pointer, recarm)
end

    
--- On Rec Arm Change Ex.
-- @param recarm integer.
-- @param allowgang boolean.
-- @return boolean
function MediaTrack:on_rec_arm_change_ex(recarm, allowgang)
    return r.CSurf_OnRecArmChangeEx(self.pointer, recarm, allowgang)
end

    
--- On Recv Pan Change.
-- @param recv_index integer.
-- @param pan number.
-- @param relative boolean.
-- @return number
function MediaTrack:on_recv_pan_change(recv_index, pan, relative)
    return r.CSurf_OnRecvPanChange(self.pointer, recv_index, pan, relative)
end

    
--- On Recv Volume Change.
-- @param recv_index integer.
-- @param volume number.
-- @param relative boolean.
-- @return number
function MediaTrack:on_recv_volume_change(recv_index, volume, relative)
    return r.CSurf_OnRecvVolumeChange(self.pointer, recv_index, volume, relative)
end

    
--- On Selected Change.
-- @param selected integer.
-- @return boolean
function MediaTrack:on_selected_change(selected)
    return r.CSurf_OnSelectedChange(self.pointer, selected)
end

    
--- On Send Pan Change.
-- @param send_index integer.
-- @param pan number.
-- @param relative boolean.
-- @return number
function MediaTrack:on_send_pan_change(send_index, pan, relative)
    return r.CSurf_OnSendPanChange(self.pointer, send_index, pan, relative)
end

    
--- On Send Volume Change.
-- @param send_index integer.
-- @param volume number.
-- @param relative boolean.
-- @return number
function MediaTrack:on_send_volume_change(send_index, volume, relative)
    return r.CSurf_OnSendVolumeChange(self.pointer, send_index, volume, relative)
end

    
--- On Solo Change.
-- @param solo integer.
-- @return boolean
function MediaTrack:on_solo_change(solo)
    return r.CSurf_OnSoloChange(self.pointer, solo)
end

    
--- On Solo Change Ex.
-- @param solo integer.
-- @param allowgang boolean.
-- @return boolean
function MediaTrack:on_solo_change_ex(solo, allowgang)
    return r.CSurf_OnSoloChangeEx(self.pointer, solo, allowgang)
end

    
--- On Track Selection.
function MediaTrack:on_track_selection()
    return r.CSurf_OnTrackSelection(self.pointer)
end

    
--- On Volume Change.
-- @param volume number.
-- @param relative boolean.
-- @return number
function MediaTrack:on_volume_change(volume, relative)
    return r.CSurf_OnVolumeChange(self.pointer, volume, relative)
end

    
--- On Volume Change Ex.
-- @param volume number.
-- @param relative boolean.
-- @param allow_gang boolean.
-- @return number
function MediaTrack:on_volume_change_ex(volume, relative, allow_gang)
    return r.CSurf_OnVolumeChangeEx(self.pointer, volume, relative, allow_gang)
end

    
--- On Width Change.
-- @param width number.
-- @param relative boolean.
-- @return number
function MediaTrack:on_width_change(width, relative)
    return r.CSurf_OnWidthChange(self.pointer, width, relative)
end

    
--- On Width Change Ex.
-- @param width number.
-- @param relative boolean.
-- @param allow_gang boolean.
-- @return number
function MediaTrack:on_width_change_ex(width, relative, allow_gang)
    return r.CSurf_OnWidthChangeEx(self.pointer, width, relative, allow_gang)
end

    
--- Set Surface Mute.
-- @param mute boolean.
-- @param ignoresurf IReaperControlSurface.
function MediaTrack:set_surface_mute(mute, ignoresurf)
    return r.CSurf_SetSurfaceMute(self.pointer, mute, ignoresurf)
end

    
--- Set Surface Pan.
-- @param pan number.
-- @param ignoresurf IReaperControlSurface.
function MediaTrack:set_surface_pan(pan, ignoresurf)
    return r.CSurf_SetSurfacePan(self.pointer, pan, ignoresurf)
end

    
--- Set Surface Rec Arm.
-- @param recarm boolean.
-- @param ignoresurf IReaperControlSurface.
function MediaTrack:set_surface_rec_arm(recarm, ignoresurf)
    return r.CSurf_SetSurfaceRecArm(self.pointer, recarm, ignoresurf)
end

    
--- Set Surface Selected.
-- @param selected boolean.
-- @param ignoresurf IReaperControlSurface.
function MediaTrack:set_surface_selected(selected, ignoresurf)
    return r.CSurf_SetSurfaceSelected(self.pointer, selected, ignoresurf)
end

    
--- Set Surface Solo.
-- @param solo boolean.
-- @param ignoresurf IReaperControlSurface.
function MediaTrack:set_surface_solo(solo, ignoresurf)
    return r.CSurf_SetSurfaceSolo(self.pointer, solo, ignoresurf)
end

    
--- Set Surface Volume.
-- @param volume number.
-- @param ignoresurf IReaperControlSurface.
function MediaTrack:set_surface_volume(volume, ignoresurf)
    return r.CSurf_SetSurfaceVolume(self.pointer, volume, ignoresurf)
end

    
--- Track To Id.
-- @param mcp_view boolean.
-- @return integer
function MediaTrack:track_to_id(mcp_view)
    return r.CSurf_TrackToID(self.pointer, mcp_view)
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
-- @param fxindex integer.
-- @param parameterindex integer.
-- @param create boolean.
-- @return TrackEnvelope table
function MediaTrack:get_fx_envelope(fxindex, parameterindex, create)
    local result = r.GetFXEnvelope(self.pointer, fxindex, parameterindex, create)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Constants for MediaTrack:get_info_value.
-- @field B_MUTE boolean: muted
-- @field B_PHASE boolean: track phase inverted
-- @field B_RECMON_IN_EFFECT boolean: record monitoring in effect (current audio-thread playback state, read-only)
-- @field IP_TRACKNUMBER number: track number 1-based, 0=not found, -1=master track (read-only, returns the int directly)
-- @field I_SOLO number: soloed, 0=not soloed, 1=soloed, 2=soloed in place, 5=safe soloed, 6=safe soloed in place
-- @field B_SOLO_DEFEAT boolean: when set, if anything else is soloed and this track is not muted, this track acts soloed
-- @field I_FXEN number: fx enabled, 0=bypassed, !0=fx active
-- @field I_RECARM number: record armed, 0=not record armed, 1=record armed
-- @field I_RECINPUT number: record input, <0=no input. if 4096 set, input is MIDI and low 5 bits represent channel (0=all, 1-16=only chan), next 6 bits represent physical input (63=all, 62=VKB). If 4096 is not set, low 10 bits (0..1023) are input start channel (ReaRoute/Loopback start at 512). If 2048 is set, input is multichannel input (using track channel count), or if 1024 is set, input is stereo input, otherwise input is mono.
-- @field I_RECMODE number: record mode, 0=input, 1=stereo out, 2=none, 3=stereo out w/latency compensation, 4=midi output, 5=mono out, 6=mono out w/ latency compensation, 7=midi overdub, 8=midi replace
-- @field I_RECMODE_FLAGS number: record mode flags, &3=output recording mode (0=post fader, 1=pre-fx, 2=post-fx/pre-fader)
-- @field I_RECMON number: record monitoring, 0=off, 1=normal, 2=not when playing (tape style)
-- @field I_RECMONITEMS number: monitor items while recording, 0=off, 1=on
-- @field B_AUTO_RECARM boolean: automatically set record arm when selected (does not immediately affect recarm state, script should set directly if desired)
-- @field I_VUMODE number: int *track vu mode, &1disabled, &30==0stereo peaks, &30==2multichannel peaks, &30==4stereo RMS, &30==8combined RMS, &30==12LUFS-M, &30==16LUFS-S (readout=max), &30==20LUFS-S (readout=current), &32LUFS calculation on channels 1+2 only
-- @field I_AUTOMODE number: track automation mode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch
-- @field I_NCHAN number: number of track channels, 2-128, even numbers only
-- @field I_SELECTED number: track selected, 0=unselected, 1=selected
-- @field I_WNDH number: current TCP window height in pixels including envelopes (read-only)
-- @field I_TCPH number: current TCP window height in pixels not including envelopes (read-only)
-- @field I_TCPY number: current TCP window Y-position in pixels relative to top of arrange view (read-only)
-- @field I_MCPX number: current MCP X-position in pixels relative to mixer container (read-only)
-- @field I_MCPY number: current MCP Y-position in pixels relative to mixer container (read-only)
-- @field I_MCPW number: current MCP width in pixels (read-only)
-- @field I_MCPH number: current MCP height in pixels (read-only)
-- @field I_FOLDERDEPTH number: folder depth change, 0=normal, 1=track is a folder parent, -1=track is the last in the innermost folder, -2=track is the last in the innermost and next-innermost folders, etc
-- @field I_FOLDERCOMPACT number: folder collapsed state (only valid on folders), 0=normal, 1=collapsed, 2=fully collapsed
-- @field I_MIDIHWOUT number: track midi hardware output index, <0=disabled, low 5 bits are which channels (0=all, 1-16), next 5 bits are output device index (0-31)
-- @field I_MIDI_INPUT_CHANMAP number: -1 maps to source channel, otherwise 1-16 to map to MIDI channel
-- @field I_MIDI_CTL_CHAN number: -1 no link, 0-15 link to MIDI volume/pan on channel, 16 link to MIDI volume/pan on all channels
-- @field I_MIDI_TRACKSEL_FLAG number: int *MIDI editor track list options&1=expand media items, &2=exclude from list, &4=auto-pruned
-- @field I_PERFFLAGS number: track performance flags, &1=no media buffering, &2=no anticipative FX
-- @field I_CUSTOMCOLOR number: custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
-- @field I_HEIGHTOVERRIDE number: custom height override for TCP window, 0 for none, otherwise size in pixels
-- @field I_SPACER number: int *1=TCP track spacer above this trackB_HEIGHTLOCKbool *track height lock (must set I_HEIGHTOVERRIDE before locking)
-- @field D_VOL double *: trim volume of track, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
-- @field D_PAN double *: trim pan of track, -1..1
-- @field D_WIDTH double *: width of track, -1..1
-- @field D_DUALPANL double *: dualpan position 1, -1..1, only if I_PANMODE==6
-- @field D_DUALPANR double *: dualpan position 2, -1..1, only if I_PANMODE==6
-- @field I_PANMODE number: pan mode, 0=classic 3.x, 3=new balance, 5=stereo pan, 6=dual pan
-- @field D_PANLAW double *: pan law of track, <0=project default, 0.5=-6dB, 0.707..=-3dB, 1=+0dB, 1.414..=-3dB with gain compensation, 2=-6dB with gain compensation, etc
-- @field I_PANLAW_FLAGS number: pan law flags, 0=sine taper, 1=hybrid taper with deprecated behavior when gain compensation enabled, 2=linear taper, 3=hybrid taper
-- @field P_ENV <envchunkname or P_ENV: <envchunkname or P_ENV{GUID...TrackEnvelope *(read-only) chunkname can be <VOLENV, <PANENV, etc; GUID is the stringified envelope GUID.
-- @field B_SHOWINMIXER boolean: track control panel visible in mixer (do not use on master track)
-- @field B_SHOWINTCP boolean: track control panel visible in arrange view (do not use on master track)
-- @field B_MAINSEND boolean: track sends audio to parent
-- @field C_MAINSEND_OFFS string: channel offset of track send to parent
-- @field C_MAINSEND_NCH string: channel count of track send to parent (0=use all child track channels, 1=use one channel only)
-- @field I_FREEMODE number: 1=track free item positioning enabled, 2=track fixed lanes enabled (call UpdateTimeline() after changing)
-- @field I_NUMFIXEDLANES number: number of track fixed lanes (fine to call with setNewValue, but returned value is read-only)
-- @field C_LANESCOLLAPSED string: fixed lane collapse state (1=lanes collapsed, 2=track displays as non-fixed-lanes but hidden lanes exist)
-- @field C_LANESETTINGS string: fixed lane settings (&1=auto-remove empty lanes at bottom, &2=do not auto-comp new recording, &4=newly recorded lanes play exclusively (else add lanes in layers), &8=big lanes (else small lanes), &16=add new recording at bottom (else record into first available lane), &32=hide lane buttons
-- @field C_LANEPLAYS N: Nchar *on fixed lane tracks, 0=lane N does not play, 1=lane N plays exclusively, 2=lane N plays and other lanes also play (fine to call with setNewValue, but returned value is read-only)
-- @field C_ALLLANESPLAY string: on fixed lane tracks, 0=no lanes play, 1=all lanes play, 2=some lanes play (fine to call with setNewValue 0 or 1, but returned value is read-only)
-- @field C_BEATATTACHMODE string: track timebase, -1=project default, 0=time, 1=beats (position, length, rate), 2=beats (position only)
-- @field F_MCP_FXSEND_SCALE float *: scale of fx+send area in MCP (0=minimum allowed, 1=maximum allowed)
-- @field F_MCP_FXPARM_SCALE float *: scale of fx parameter area in MCP (0=minimum allowed, 1=maximum allowed)
-- @field F_MCP_SENDRGN_SCALE float *: scale of send area as proportion of the fx+send total area (0=minimum allowed, 1=maximum allowed)
-- @field F_TCP_FXPARM_SCALE float *: scale of TCP parameter area when TCP FX are embedded (0=min allowed, default, 1=max allowed)
-- @field I_PLAY_OFFSET_FLAG number: track media playback offset state, &1=bypassed, &2=offset value is measured in samples (otherwise measured in seconds)
-- @field D_PLAY_OFFSET double *: track media playback offset, units depend on I_PLAY_OFFSET_FLAG
-- @field P_PARTRACK MediaTrack: parent track (read-only)
-- @field P_PROJECT ReaProject: parent project (read-only)
MediaTrack.GetInfoValueConstants{
    B_MUTE = "B_MUTE",
    B_PHASE = "B_PHASE",
    B_RECMON_IN_EFFECT = "B_RECMON_IN_EFFECT",
    IP_TRACKNUMBER = "IP_TRACKNUMBER",
    I_SOLO = "I_SOLO",
    B_SOLO_DEFEAT = "B_SOLO_DEFEAT",
    I_FXEN = "I_FXEN",
    I_RECARM = "I_RECARM",
    I_RECINPUT = "I_RECINPUT",
    I_RECMODE = "I_RECMODE",
    I_RECMODE_FLAGS = "I_RECMODE_FLAGS",
    I_RECMON = "I_RECMON",
    I_RECMONITEMS = "I_RECMONITEMS",
    B_AUTO_RECARM = "B_AUTO_RECARM",
    I_VUMODE = "I_VUMODE",
    I_AUTOMODE = "I_AUTOMODE",
    I_NCHAN = "I_NCHAN",
    I_SELECTED = "I_SELECTED",
    I_WNDH = "I_WNDH",
    I_TCPH = "I_TCPH",
    I_TCPY = "I_TCPY",
    I_MCPX = "I_MCPX",
    I_MCPY = "I_MCPY",
    I_MCPW = "I_MCPW",
    I_MCPH = "I_MCPH",
    I_FOLDERDEPTH = "I_FOLDERDEPTH",
    I_FOLDERCOMPACT = "I_FOLDERCOMPACT",
    I_MIDIHWOUT = "I_MIDIHWOUT",
    I_MIDI_INPUT_CHANMAP = "I_MIDI_INPUT_CHANMAP",
    I_MIDI_CTL_CHAN = "I_MIDI_CTL_CHAN",
    I_MIDI_TRACKSEL_FLAG = "I_MIDI_TRACKSEL_FLAG",
    I_PERFFLAGS = "I_PERFFLAGS",
    I_CUSTOMCOLOR = "I_CUSTOMCOLOR",
    I_HEIGHTOVERRIDE = "I_HEIGHTOVERRIDE",
    I_SPACER = "I_SPACER",
    D_VOL = "D_VOL",
    D_PAN = "D_PAN",
    D_WIDTH = "D_WIDTH",
    D_DUALPANL = "D_DUALPANL",
    D_DUALPANR = "D_DUALPANR",
    I_PANMODE = "I_PANMODE",
    D_PANLAW = "D_PANLAW",
    I_PANLAW_FLAGS = "I_PANLAW_FLAGS",
    P_ENV = "P_ENV",
    B_SHOWINMIXER = "B_SHOWINMIXER",
    B_SHOWINTCP = "B_SHOWINTCP",
    B_MAINSEND = "B_MAINSEND",
    C_MAINSEND_OFFS = "C_MAINSEND_OFFS",
    C_MAINSEND_NCH = "C_MAINSEND_NCH",
    I_FREEMODE = "I_FREEMODE",
    I_NUMFIXEDLANES = "I_NUMFIXEDLANES",
    C_LANESCOLLAPSED = "C_LANESCOLLAPSED",
    C_LANESETTINGS = "C_LANESETTINGS",
    C_LANEPLAYS = "C_LANEPLAYS",
    C_ALLLANESPLAY = "C_ALLLANESPLAY",
    C_BEATATTACHMODE = "C_BEATATTACHMODE",
    F_MCP_FXSEND_SCALE = "F_MCP_FXSEND_SCALE",
    F_MCP_FXPARM_SCALE = "F_MCP_FXPARM_SCALE",
    F_MCP_SENDRGN_SCALE = "F_MCP_SENDRGN_SCALE",
    F_TCP_FXPARM_SCALE = "F_TCP_FXPARM_SCALE",
    I_PLAY_OFFSET_FLAG = "I_PLAY_OFFSET_FLAG",
    D_PLAY_OFFSET = "D_PLAY_OFFSET",
    P_PARTRACK = "P_PARTRACK",
    P_PROJECT = "P_PROJECT",
}
    
--- Get Info Value.
-- Get track numerical-value attributes.
-- @param parm_name string. MediaTrack.GetInfoValueConstants
-- @return number
function MediaTrack:get_info_value(parm_name)
    return r.GetMediaTrackInfo_Value(self.pointer, parm_name)
end

    
--- Get Parent Track.
-- @return MediaTrack table
function MediaTrack:get_parent_track()
    local result = r.GetParentTrack(self.pointer)
    return media_track.MediaTrack:new(result)
end

    
--- Constants for MediaTrack:get_set_info_string.
-- @field P_NAME string: track name (on master returns NULL)
-- @field P_ICON const char *: track icon (full filename, or relative to resource_path/data/track_icons)
-- @field P_LANENAME n: nchar *lane name (returns NULL for non-fixed-lane-tracks)
-- @field P_MCP_LAYOUT const char *: layout name
-- @field P_RAZOREDITS const char *: list of razor edit areas, as space-separated triples of start time, end time, and envelope GUID string.
-- @field P_RAZOREDITS_EXT const char *: const char *list of razor edit areas, as comma-separated sets of space-separated tuples of start time, end time, optionalenvelope GUID string, fixed/fipm top y-position, fixed/fipm bottom y-position.
-- @field P_TCP_LAYOUT const char *: layout name
-- @field P_EXT xyz: xyzchar *extension-specific persistent data
-- @field P_UI_RECT tcp.mute: tcp.mutechar *read-only, allows querying screen position + size of track WALTER elements (tcp.size queries screen position and size of entire TCP, etc).
-- @field GUID GUID *: 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
MediaTrack.GetSetInfoStringConstants{
    P_NAME = "P_NAME",
    P_ICON = "P_ICON",
    P_LANENAME = "P_LANENAME",
    P_MCP_LAYOUT = "P_MCP_LAYOUT",
    P_RAZOREDITS = "P_RAZOREDITS",
    P_RAZOREDITS_EXT = "P_RAZOREDITS_EXT",
    P_TCP_LAYOUT = "P_TCP_LAYOUT",
    P_EXT = "P_EXT",
    P_UI_RECT = "P_UI_RECT",
    GUID = "GUID",
}
    
--- Get Set Info String.
-- Get or set track string attributes.Example: "0.0 1.0 \"\" 0.0 1.0
-- "{xyz-...}"Example: "0.0 1.0,0.0 1.0 "{xyz-...}",1.0 2.0 "" 0.25 0.75"
-- @param parm_name string. MediaTrack.GetSetInfoStringConstants
-- @param string_need_big string.
-- @param set_new_value boolean.
-- @return ret_val boolean
-- @return string_need_big string
function MediaTrack:get_set_info_string(parm_name, string_need_big, set_new_value)
    return r.GetSetMediaTrackInfo_String(self.pointer, parm_name, string_need_big, set_new_value)
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
-- @param group_name string.
-- @param setmask integer.
-- @param setvalue integer.
-- @return integer
function MediaTrack:get_set_track_group_membership(group_name, setmask, setvalue)
    return r.GetSetTrackGroupMembership(self.pointer, group_name, setmask, setvalue)
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
-- @param group_name string.
-- @param offset integer.
-- @param setmask integer.
-- @param setvalue integer.
-- @return integer
function MediaTrack:get_set_track_group_membership_ex(group_name, offset, setmask, setvalue)
    return r.GetSetTrackGroupMembershipEx(self.pointer, group_name, offset, setmask, setvalue)
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
-- @param group_name string.
-- @param setmask integer.
-- @param setvalue integer.
-- @return integer
function MediaTrack:get_set_track_group_membership_high(group_name, setmask, setvalue)
    return r.GetSetTrackGroupMembershipHigh(self.pointer, group_name, setmask, setvalue)
end

    
--- Constants for MediaTrack:get_set_track_send_info_string.
-- @field P_EXT xyz: xyzchar *extension-specific persistent data
MediaTrack.GetSetTrackSendInfoStringConstants{
    P_EXT = "P_EXT",
}
    
--- Get Set Track Send Info String.
-- Gets/sets a send attribute string:
-- @param category integer.
-- @param send_idx integer.
-- @param parm_name string. MediaTrack.GetSetTrackSendInfoStringConstants
-- @param string_need_big string.
-- @param set_new_value boolean.
-- @return ret_val boolean
-- @return string_need_big string
function MediaTrack:get_set_track_send_info_string(category, send_idx, parm_name, string_need_big, set_new_value)
    return r.GetSetTrackSendInfo_String(self.pointer, category, send_idx, parm_name, string_need_big, set_new_value)
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
-- @param env_idx integer.
-- @return TrackEnvelope table
function MediaTrack:get_track_envelope(env_idx)
    local result = r.GetTrackEnvelope(self.pointer, env_idx)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Track Envelope By Chunk Name.
-- Gets a built-in track envelope by configuration chunk name, like "<VOLENV", or
-- GUID string, like "{B577250D-146F-B544-9B34-F24FBE488F1F}".
-- @param cfgchunkname_or_guid string.
-- @return TrackEnvelope table
function MediaTrack:get_track_envelope_by_chunk_name(cfgchunkname_or_guid)
    local result = r.GetTrackEnvelopeByChunkName(self.pointer, cfgchunkname_or_guid)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Track Envelope By Name.
-- @param env_name string.
-- @return TrackEnvelope table
function MediaTrack:get_track_envelope_by_name(env_name)
    local result = r.GetTrackEnvelopeByName(self.pointer, env_name)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Track Guid.
-- @return guid string
function MediaTrack:get_track_guid()
    return r.GetTrackGUID(self.pointer)
end

    
--- Get Track Media Item.
-- @param item_idx integer.
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
-- @param flag integer.
-- @return ret_val boolean
-- @return buf string
function MediaTrack:get_track_midi_lyrics(flag)
    return r.GetTrackMIDILyrics(self.pointer, flag)
end

    
--- Get Track Name.
-- Returns "MASTER" for master track, "Track N" if track has no name.
-- @return ret_val boolean
-- @return buf string
function MediaTrack:get_track_name()
    return r.GetTrackName(self.pointer)
end

    
--- Get Track Num Media Items.
-- @return integer
function MediaTrack:get_track_num_media_items()
    return r.GetTrackNumMediaItems(self.pointer)
end

    
--- Get Track Num Sends.
-- returns number of sends/receives/hardware outputs - category is <0 for receives,
-- 0=sends, >0 for hardware outputs
-- @param category integer.
-- @return integer
function MediaTrack:get_track_num_sends(category)
    return r.GetTrackNumSends(self.pointer, category)
end

    
--- Get Track Receive Name.
-- See GetTrackSendName.
-- @param recv_index integer.
-- @return ret_val boolean
-- @return buf string
function MediaTrack:get_track_receive_name(recv_index)
    return r.GetTrackReceiveName(self.pointer, recv_index)
end

    
--- Get Track Receive Ui Mute.
-- See GetTrackSendUIMute.
-- @param recv_index integer.
-- @return ret_val boolean
-- @return mute boolean
function MediaTrack:get_track_receive_ui_mute(recv_index)
    return r.GetTrackReceiveUIMute(self.pointer, recv_index)
end

    
--- Get Track Receive Ui Vol Pan.
-- See GetTrackSendUIVolPan.
-- @param recv_index integer.
-- @return ret_val boolean
-- @return volume number
-- @return pan number
function MediaTrack:get_track_receive_ui_vol_pan(recv_index)
    return r.GetTrackReceiveUIVolPan(self.pointer, recv_index)
end

    
--- Constants for MediaTrack:get_track_send_info_value.
-- @field B_MUTE any: bool *
-- @field B_PHASE boolean: true to flip phase
-- @field B_MONO any: bool *
-- @field D_VOL double *: 1.0 = +0dB etc
-- @field D_PAN double *: -1..+1
-- @field D_PANLAW double *: 1.0=+0.0db, 0.5=-6dB, -1.0 = projdef etc
-- @field I_SENDMODE number: 0=post-fader, 1=pre-fx, 2=post-fx (deprecated), 3=post-fx
-- @field I_AUTOMODE number: automation mode (-1=use track automode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch)
-- @field I_SRCCHAN number: -1 for no audio send. Low 10 bits specify channel offset, and higher bits specify channel count. (srcchan>>10) == 0 for stereo, 1 for mono, 2 for 4 channel, 3 for 6 channel, etc.
-- @field I_DSTCHAN number: low 10 bits are destination index, &1024 set to mix to mono.
-- @field I_MIDIFLAGS number: low 5 bits=source channel 0=all, 1-16, 31=MIDI send disabled, next 5 bits=dest channel, 0=orig, 1-16=chan. &1024 for faders-send MIDI vol/pan. (>>14)&255 = src bus (0 for all, 1 for normal, 2+). (>>22)&255=destination bus (0 for all, 1 for normal, 2+)
-- @field P_DESTTRACK MediaTrack: destination track, only applies for sends/recvs (read-only)
-- @field P_SRCTRACK MediaTrack: source track, only applies for sends/recvs (read-only)
-- @field P_ENV <envchunkname: <envchunknameTrackEnvelope *call with<VOLENV,<PANENV, etc appended (read-only)
MediaTrack.GetTrackSendInfoValueConstants{
    B_MUTE = "B_MUTE",
    B_PHASE = "B_PHASE",
    B_MONO = "B_MONO",
    D_VOL = "D_VOL",
    D_PAN = "D_PAN",
    D_PANLAW = "D_PANLAW",
    I_SENDMODE = "I_SENDMODE",
    I_AUTOMODE = "I_AUTOMODE",
    I_SRCCHAN = "I_SRCCHAN",
    I_DSTCHAN = "I_DSTCHAN",
    I_MIDIFLAGS = "I_MIDIFLAGS",
    P_DESTTRACK = "P_DESTTRACK",
    P_SRCTRACK = "P_SRCTRACK",
    P_ENV = "P_ENV",
}
    
--- Get Track Send Info Value.
-- Get send/receive/hardware output numerical-value attributes.category is <0 for
-- receives, 0=sends, >0 for hardware outputsparameter
-- names:SeeCreateTrackSend,RemoveTrackSend,GetTrackNumSends.
-- @param category integer.
-- @param send_idx integer.
-- @param parm_name string. MediaTrack.GetTrackSendInfoValueConstants
-- @return number
function MediaTrack:get_track_send_info_value(category, send_idx, parm_name)
    return r.GetTrackSendInfo_Value(self.pointer, category, send_idx, parm_name)
end

    
--- Get Track Send Name.
-- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveName.
-- @param send_index integer.
-- @return ret_val boolean
-- @return buf string
function MediaTrack:get_track_send_name(send_index)
    return r.GetTrackSendName(self.pointer, send_index)
end

    
--- Get Track Send Ui Mute.
-- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See
-- GetTrackReceiveUIMute.
-- @param send_index integer.
-- @return ret_val boolean
-- @return mute boolean
function MediaTrack:get_track_send_ui_mute(send_index)
    return r.GetTrackSendUIMute(self.pointer, send_index)
end

    
--- Get Track Send Ui Vol Pan.
-- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See
-- GetTrackReceiveUIVolPan.
-- @param send_index integer.
-- @return ret_val boolean
-- @return volume number
-- @return pan number
function MediaTrack:get_track_send_ui_vol_pan(send_index)
    return r.GetTrackSendUIVolPan(self.pointer, send_index)
end

    
--- Get Track State.
-- Gets track state, returns track name. flags will be set to: &1=folder
-- &2=selected &4=has fx enabled &8=muted &16=soloed &32=SIP'd (with &16) &64=rec
-- armed &128=rec monitoring on &256=rec monitoring auto &512=hide from TCP
-- &1024=hide from MCP
-- @return ret_val string
-- @return flags integer
function MediaTrack:get_track_state()
    return r.GetTrackState(self.pointer)
end

    
--- Get Track State Chunk.
-- Gets the RPPXML state of a track, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string.
-- @param is_undo boolean.
-- @return ret_val boolean
-- @return str string
function MediaTrack:get_track_state_chunk(str, is_undo)
    return r.GetTrackStateChunk(self.pointer, str, is_undo)
end

    
--- Get Track Ui Mute.
-- @return ret_val boolean
-- @return mute boolean
function MediaTrack:get_track_ui_mute()
    return r.GetTrackUIMute(self.pointer)
end

    
--- Get Track Ui Pan.
-- @return ret_val boolean
-- @return pan1 number
-- @return pan2 number
-- @return panmode integer
function MediaTrack:get_track_ui_pan()
    return r.GetTrackUIPan(self.pointer)
end

    
--- Get Track Ui Vol Pan.
-- @return ret_val boolean
-- @return volume number
-- @return pan number
function MediaTrack:get_track_ui_vol_pan()
    return r.GetTrackUIVolPan(self.pointer)
end

    
--- Is Track Selected.
-- @return boolean
function MediaTrack:is_track_selected()
    return r.IsTrackSelected(self.pointer)
end

    
--- Is Track Visible.
-- If mixer==true, returns true if the track is visible in the mixer.  If
-- mixer==false, returns true if the track is visible in the track control panel.
-- @param mixer boolean.
-- @return boolean
function MediaTrack:is_track_visible(mixer)
    return r.IsTrackVisible(self.pointer, mixer)
end

    
--- Mark Track Items Dirty.
-- If track is supplied, item is ignored
function MediaTrack:mark_track_items_dirty()
    return r.MarkTrackItemsDirty(self.pointer, item)
end

    
--- Get Track Hash.
-- Get a string that only changes when the MIDI data changes. If notesonly==true,
-- then the string changes only when the MIDI notes change. See MIDI_GetHash
-- @param notesonly boolean.
-- @return ret_val boolean
-- @return hash string
function MediaTrack:get_track_hash(notesonly)
    return r.MIDI_GetTrackHash(self.pointer, notesonly)
end

    
--- Midi Editor Flags For Track.
-- Get or set MIDI editor settings for this track. pitchwheelrange: semitones up or
-- down. flags &1: snap pitch lane edits to semitones if pitchwheel range is
-- defined.
-- @param pitchwheelrange integer.
-- @param flags integer.
-- @param is_set boolean.
-- @return pitchwheelrange integer
-- @return flags integer
function MediaTrack:midi_editor_flags_for_track(pitchwheelrange, flags, is_set)
    return r.MIDIEditorFlagsForTrack(self.pointer, pitchwheelrange, flags, is_set)
end

    
--- Remove Track Send.
-- Remove a send/receive/hardware output, return true on success. category is <0
-- for receives, 0=sends, >0 for hardware outputs. See CreateTrackSend,
-- GetSetTrackSendInfo, GetTrackSendInfo_Value, SetTrackSendInfo_Value,
-- GetTrackNumSends.
-- @param category integer.
-- @param send_idx integer.
-- @return boolean
function MediaTrack:remove_track_send(category, send_idx)
    return r.RemoveTrackSend(self.pointer, category, send_idx)
end

    
--- Constants for MediaTrack:set_info_value.
-- @field B_MUTE boolean: muted
-- @field B_PHASE boolean: track phase inverted
-- @field B_RECMON_IN_EFFECT boolean: record monitoring in effect (current audio-thread playback state, read-only)
-- @field IP_TRACKNUMBER number: track number 1-based, 0=not found, -1=master track (read-only, returns the int directly)
-- @field I_SOLO number: soloed, 0=not soloed, 1=soloed, 2=soloed in place, 5=safe soloed, 6=safe soloed in place
-- @field B_SOLO_DEFEAT boolean: when set, if anything else is soloed and this track is not muted, this track acts soloed
-- @field I_FXEN number: fx enabled, 0=bypassed, !0=fx active
-- @field I_RECARM number: record armed, 0=not record armed, 1=record armed
-- @field I_RECINPUT number: record input, <0=no input. if 4096 set, input is MIDI and low 5 bits represent channel (0=all, 1-16=only chan), next 6 bits represent physical input (63=all, 62=VKB). If 4096 is not set, low 10 bits (0..1023) are input start channel (ReaRoute/Loopback start at 512). If 2048 is set, input is multichannel input (using track channel count), or if 1024 is set, input is stereo input, otherwise input is mono.
-- @field I_RECMODE number: record mode, 0=input, 1=stereo out, 2=none, 3=stereo out w/latency compensation, 4=midi output, 5=mono out, 6=mono out w/ latency compensation, 7=midi overdub, 8=midi replace
-- @field I_RECMODE_FLAGS number: record mode flags, &3=output recording mode (0=post fader, 1=pre-fx, 2=post-fx/pre-fader)
-- @field I_RECMON number: record monitoring, 0=off, 1=normal, 2=not when playing (tape style)
-- @field I_RECMONITEMS number: monitor items while recording, 0=off, 1=on
-- @field B_AUTO_RECARM boolean: automatically set record arm when selected (does not immediately affect recarm state, script should set directly if desired)
-- @field I_VUMODE number: int *track vu mode, &1disabled, &30==0stereo peaks, &30==2multichannel peaks, &30==4stereo RMS, &30==8combined RMS, &30==12LUFS-M, &30==16LUFS-S (readout=max), &30==20LUFS-S (readout=current), &32LUFS calculation on channels 1+2 only
-- @field I_AUTOMODE number: track automation mode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch
-- @field I_NCHAN number: number of track channels, 2-128, even numbers only
-- @field I_SELECTED number: track selected, 0=unselected, 1=selected
-- @field I_WNDH number: current TCP window height in pixels including envelopes (read-only)
-- @field I_TCPH number: current TCP window height in pixels not including envelopes (read-only)
-- @field I_TCPY number: current TCP window Y-position in pixels relative to top of arrange view (read-only)
-- @field I_MCPX number: current MCP X-position in pixels relative to mixer container (read-only)
-- @field I_MCPY number: current MCP Y-position in pixels relative to mixer container (read-only)
-- @field I_MCPW number: current MCP width in pixels (read-only)
-- @field I_MCPH number: current MCP height in pixels (read-only)
-- @field I_FOLDERDEPTH number: folder depth change, 0=normal, 1=track is a folder parent, -1=track is the last in the innermost folder, -2=track is the last in the innermost and next-innermost folders, etc
-- @field I_FOLDERCOMPACT number: folder collapsed state (only valid on folders), 0=normal, 1=collapsed, 2=fully collapsed
-- @field I_MIDIHWOUT number: track midi hardware output index, <0=disabled, low 5 bits are which channels (0=all, 1-16), next 5 bits are output device index (0-31)
-- @field I_MIDI_INPUT_CHANMAP number: -1 maps to source channel, otherwise 1-16 to map to MIDI channel
-- @field I_MIDI_CTL_CHAN number: -1 no link, 0-15 link to MIDI volume/pan on channel, 16 link to MIDI volume/pan on all channels
-- @field I_MIDI_TRACKSEL_FLAG number: int *MIDI editor track list options&1=expand media items, &2=exclude from list, &4=auto-pruned
-- @field I_PERFFLAGS number: track performance flags, &1=no media buffering, &2=no anticipative FX
-- @field I_CUSTOMCOLOR number: custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
-- @field I_HEIGHTOVERRIDE number: custom height override for TCP window, 0 for none, otherwise size in pixels
-- @field I_SPACER number: int *1=TCP track spacer above this trackB_HEIGHTLOCKbool *track height lock (must set I_HEIGHTOVERRIDE before locking)
-- @field D_VOL double *: trim volume of track, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
-- @field D_PAN double *: trim pan of track, -1..1
-- @field D_WIDTH double *: width of track, -1..1
-- @field D_DUALPANL double *: dualpan position 1, -1..1, only if I_PANMODE==6
-- @field D_DUALPANR double *: dualpan position 2, -1..1, only if I_PANMODE==6
-- @field I_PANMODE number: pan mode, 0=classic 3.x, 3=new balance, 5=stereo pan, 6=dual pan
-- @field D_PANLAW double *: pan law of track, <0=project default, 0.5=-6dB, 0.707..=-3dB, 1=+0dB, 1.414..=-3dB with gain compensation, 2=-6dB with gain compensation, etc
-- @field I_PANLAW_FLAGS number: pan law flags, 0=sine taper, 1=hybrid taper with deprecated behavior when gain compensation enabled, 2=linear taper, 3=hybrid taper
-- @field P_ENV <envchunkname or P_ENV: <envchunkname or P_ENV{GUID...TrackEnvelope *(read-only) chunkname can be <VOLENV, <PANENV, etc; GUID is the stringified envelope GUID.
-- @field B_SHOWINMIXER boolean: track control panel visible in mixer (do not use on master track)
-- @field B_SHOWINTCP boolean: track control panel visible in arrange view (do not use on master track)
-- @field B_MAINSEND boolean: track sends audio to parent
-- @field C_MAINSEND_OFFS string: channel offset of track send to parent
-- @field C_MAINSEND_NCH string: channel count of track send to parent (0=use all child track channels, 1=use one channel only)
-- @field I_FREEMODE number: 1=track free item positioning enabled, 2=track fixed lanes enabled (call UpdateTimeline() after changing)
-- @field I_NUMFIXEDLANES number: number of track fixed lanes (fine to call with setNewValue, but returned value is read-only)
-- @field C_LANESCOLLAPSED string: fixed lane collapse state (1=lanes collapsed, 2=track displays as non-fixed-lanes but hidden lanes exist)
-- @field C_LANESETTINGS string: fixed lane settings (&1=auto-remove empty lanes at bottom, &2=do not auto-comp new recording, &4=newly recorded lanes play exclusively (else add lanes in layers), &8=big lanes (else small lanes), &16=add new recording at bottom (else record into first available lane), &32=hide lane buttons
-- @field C_LANEPLAYS N: Nchar *on fixed lane tracks, 0=lane N does not play, 1=lane N plays exclusively, 2=lane N plays and other lanes also play (fine to call with setNewValue, but returned value is read-only)
-- @field C_ALLLANESPLAY string: on fixed lane tracks, 0=no lanes play, 1=all lanes play, 2=some lanes play (fine to call with setNewValue 0 or 1, but returned value is read-only)
-- @field C_BEATATTACHMODE string: track timebase, -1=project default, 0=time, 1=beats (position, length, rate), 2=beats (position only)
-- @field F_MCP_FXSEND_SCALE float *: scale of fx+send area in MCP (0=minimum allowed, 1=maximum allowed)
-- @field F_MCP_FXPARM_SCALE float *: scale of fx parameter area in MCP (0=minimum allowed, 1=maximum allowed)
-- @field F_MCP_SENDRGN_SCALE float *: scale of send area as proportion of the fx+send total area (0=minimum allowed, 1=maximum allowed)
-- @field F_TCP_FXPARM_SCALE float *: scale of TCP parameter area when TCP FX are embedded (0=min allowed, default, 1=max allowed)
-- @field I_PLAY_OFFSET_FLAG number: track media playback offset state, &1=bypassed, &2=offset value is measured in samples (otherwise measured in seconds)
-- @field D_PLAY_OFFSET double *: track media playback offset, units depend on I_PLAY_OFFSET_FLAG
MediaTrack.SetInfoValueConstants{
    B_MUTE = "B_MUTE",
    B_PHASE = "B_PHASE",
    B_RECMON_IN_EFFECT = "B_RECMON_IN_EFFECT",
    IP_TRACKNUMBER = "IP_TRACKNUMBER",
    I_SOLO = "I_SOLO",
    B_SOLO_DEFEAT = "B_SOLO_DEFEAT",
    I_FXEN = "I_FXEN",
    I_RECARM = "I_RECARM",
    I_RECINPUT = "I_RECINPUT",
    I_RECMODE = "I_RECMODE",
    I_RECMODE_FLAGS = "I_RECMODE_FLAGS",
    I_RECMON = "I_RECMON",
    I_RECMONITEMS = "I_RECMONITEMS",
    B_AUTO_RECARM = "B_AUTO_RECARM",
    I_VUMODE = "I_VUMODE",
    I_AUTOMODE = "I_AUTOMODE",
    I_NCHAN = "I_NCHAN",
    I_SELECTED = "I_SELECTED",
    I_WNDH = "I_WNDH",
    I_TCPH = "I_TCPH",
    I_TCPY = "I_TCPY",
    I_MCPX = "I_MCPX",
    I_MCPY = "I_MCPY",
    I_MCPW = "I_MCPW",
    I_MCPH = "I_MCPH",
    I_FOLDERDEPTH = "I_FOLDERDEPTH",
    I_FOLDERCOMPACT = "I_FOLDERCOMPACT",
    I_MIDIHWOUT = "I_MIDIHWOUT",
    I_MIDI_INPUT_CHANMAP = "I_MIDI_INPUT_CHANMAP",
    I_MIDI_CTL_CHAN = "I_MIDI_CTL_CHAN",
    I_MIDI_TRACKSEL_FLAG = "I_MIDI_TRACKSEL_FLAG",
    I_PERFFLAGS = "I_PERFFLAGS",
    I_CUSTOMCOLOR = "I_CUSTOMCOLOR",
    I_HEIGHTOVERRIDE = "I_HEIGHTOVERRIDE",
    I_SPACER = "I_SPACER",
    D_VOL = "D_VOL",
    D_PAN = "D_PAN",
    D_WIDTH = "D_WIDTH",
    D_DUALPANL = "D_DUALPANL",
    D_DUALPANR = "D_DUALPANR",
    I_PANMODE = "I_PANMODE",
    D_PANLAW = "D_PANLAW",
    I_PANLAW_FLAGS = "I_PANLAW_FLAGS",
    P_ENV = "P_ENV",
    B_SHOWINMIXER = "B_SHOWINMIXER",
    B_SHOWINTCP = "B_SHOWINTCP",
    B_MAINSEND = "B_MAINSEND",
    C_MAINSEND_OFFS = "C_MAINSEND_OFFS",
    C_MAINSEND_NCH = "C_MAINSEND_NCH",
    I_FREEMODE = "I_FREEMODE",
    I_NUMFIXEDLANES = "I_NUMFIXEDLANES",
    C_LANESCOLLAPSED = "C_LANESCOLLAPSED",
    C_LANESETTINGS = "C_LANESETTINGS",
    C_LANEPLAYS = "C_LANEPLAYS",
    C_ALLLANESPLAY = "C_ALLLANESPLAY",
    C_BEATATTACHMODE = "C_BEATATTACHMODE",
    F_MCP_FXSEND_SCALE = "F_MCP_FXSEND_SCALE",
    F_MCP_FXPARM_SCALE = "F_MCP_FXPARM_SCALE",
    F_MCP_SENDRGN_SCALE = "F_MCP_SENDRGN_SCALE",
    F_TCP_FXPARM_SCALE = "F_TCP_FXPARM_SCALE",
    I_PLAY_OFFSET_FLAG = "I_PLAY_OFFSET_FLAG",
    D_PLAY_OFFSET = "D_PLAY_OFFSET",
}
    
--- Set Info Value.
-- Set track numerical-value attributes.
-- @param parm_name string. MediaTrack.SetInfoValueConstants
-- @param newvalue number.
-- @return boolean
function MediaTrack:set_info_value(parm_name, newvalue)
    return r.SetMediaTrackInfo_Value(self.pointer, parm_name, newvalue)
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
-- @param mode integer.
function MediaTrack:set_track_automation_mode(mode)
    return r.SetTrackAutomationMode(self.pointer, mode)
end

    
--- Set Track Color.
-- Set the custom track color, color is OS dependent (i.e. ColorToNative(r,g,b). To
-- unset the track color, see SetMediaTrackInfo_Value I_CUSTOMCOLOR
-- @param color integer.
function MediaTrack:set_track_color(color)
    return r.SetTrackColor(self.pointer, color)
end

    
--- Set Track Midi Lyrics.
-- Set all MIDI lyrics on the track. Lyrics will be stuffed into any MIDI items
-- found in range. Flag is unused at present. str is passed in as beat position,
-- tab, text, tab (example with flag=2: "1.1.2\tLyric for measure 1 beat
-- 2\t2.1.1\tLyric for measure 2 beat 1   "). See GetTrackMIDILyrics
-- @param flag integer.
-- @param str string.
-- @return boolean
function MediaTrack:set_track_midi_lyrics(flag, str)
    return r.SetTrackMIDILyrics(self.pointer, flag, str)
end

    
--- Set Track Selected.
-- @param selected boolean.
function MediaTrack:set_track_selected(selected)
    return r.SetTrackSelected(self.pointer, selected)
end

    
--- Constants for MediaTrack:set_track_send_info_value.
-- @field B_MUTE any: bool *
-- @field B_PHASE boolean: true to flip phase
-- @field B_MONO any: bool *
-- @field D_VOL double *: 1.0 = +0dB etc
-- @field D_PAN double *: -1..+1
-- @field D_PANLAW double *: 1.0=+0.0db, 0.5=-6dB, -1.0 = projdef etc
-- @field I_SENDMODE number: 0=post-fader, 1=pre-fx, 2=post-fx (deprecated), 3=post-fx
-- @field I_AUTOMODE number: automation mode (-1=use track automode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch)
-- @field I_SRCCHAN number: -1 for no audio send. Low 10 bits specify channel offset, and higher bits specify channel count. (srcchan>>10) == 0 for stereo, 1 for mono, 2 for 4 channel, 3 for 6 channel, etc.
-- @field I_DSTCHAN number: low 10 bits are destination index, &1024 set to mix to mono.
-- @field I_MIDIFLAGS number: low 5 bits=source channel 0=all, 1-16, 31=MIDI send disabled, next 5 bits=dest channel, 0=orig, 1-16=chan. &1024 for faders-send MIDI vol/pan. (>>14)&255 = src bus (0 for all, 1 for normal, 2+). (>>22)&255=destination bus (0 for all, 1 for normal, 2+)
MediaTrack.SetTrackSendInfoValueConstants{
    B_MUTE = "B_MUTE",
    B_PHASE = "B_PHASE",
    B_MONO = "B_MONO",
    D_VOL = "D_VOL",
    D_PAN = "D_PAN",
    D_PANLAW = "D_PANLAW",
    I_SENDMODE = "I_SENDMODE",
    I_AUTOMODE = "I_AUTOMODE",
    I_SRCCHAN = "I_SRCCHAN",
    I_DSTCHAN = "I_DSTCHAN",
    I_MIDIFLAGS = "I_MIDIFLAGS",
}
    
--- Set Track Send Info Value.
-- Set send/receive/hardware output numerical-value attributes, return true on
-- success.category is <0 for receives, 0=sends, >0 for hardware outputsparameter
-- names:SeeCreateTrackSend,RemoveTrackSend,GetTrackNumSends.
-- @param category integer.
-- @param send_idx integer.
-- @param parm_name string. MediaTrack.SetTrackSendInfoValueConstants
-- @param newvalue number.
-- @return boolean
function MediaTrack:set_track_send_info_value(category, send_idx, parm_name, newvalue)
    return r.SetTrackSendInfo_Value(self.pointer, category, send_idx, parm_name, newvalue)
end

    
--- Set Track Send Ui Pan.
-- send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1
-- for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
-- @param send_idx integer.
-- @param pan number.
-- @param is_end integer.
-- @return boolean
function MediaTrack:set_track_send_ui_pan(send_idx, pan, is_end)
    return r.SetTrackSendUIPan(self.pointer, send_idx, pan, is_end)
end

    
--- Set Track Send Ui Vol.
-- send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1
-- for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
-- @param send_idx integer.
-- @param vol number.
-- @param is_end integer.
-- @return boolean
function MediaTrack:set_track_send_ui_vol(send_idx, vol, is_end)
    return r.SetTrackSendUIVol(self.pointer, send_idx, vol, is_end)
end

    
--- Set Track State Chunk.
-- Sets the RPPXML state of a track, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string.
-- @param is_undo boolean.
-- @return boolean
function MediaTrack:set_track_state_chunk(str, is_undo)
    return r.SetTrackStateChunk(self.pointer, str, is_undo)
end

    
--- Set Track Ui Input Monitor.
-- monitor: 0=no monitoring, 1=monitoring, 2=auto-monitoring. returns new value or
-- -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent
-- selection ganging
-- @param monitor integer.
-- @param igngroupflags integer.
-- @return integer
function MediaTrack:set_track_ui_input_monitor(monitor, igngroupflags)
    return r.SetTrackUIInputMonitor(self.pointer, monitor, igngroupflags)
end

    
--- Set Track Ui Mute.
-- mute: <0 toggles, >0 sets mute, 0=unsets mute. returns new value or -1 if error.
-- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
-- @param mute integer.
-- @param igngroupflags integer.
-- @return integer
function MediaTrack:set_track_ui_mute(mute, igngroupflags)
    return r.SetTrackUIMute(self.pointer, mute, igngroupflags)
end

    
--- Set Track Ui Pan.
-- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
-- @param pan number.
-- @param relative boolean.
-- @param done boolean.
-- @param igngroupflags integer.
-- @return number
function MediaTrack:set_track_ui_pan(pan, relative, done, igngroupflags)
    return r.SetTrackUIPan(self.pointer, pan, relative, done, igngroupflags)
end

    
--- Set Track Ui Polarity.
-- polarity (AKA phase): <0 toggles, 0=normal, >0=inverted. returns new value or -1
-- if error.igngroupflags: &1 to prevent track grouping, &2 to prevent selection
-- ganging
-- @param polarity integer.
-- @param igngroupflags integer.
-- @return integer
function MediaTrack:set_track_ui_polarity(polarity, igngroupflags)
    return r.SetTrackUIPolarity(self.pointer, polarity, igngroupflags)
end

    
--- Set Track Ui Rec Arm.
-- recarm: <0 toggles, >0 sets recarm, 0=unsets recarm. returns new value or -1 if
-- error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection
-- ganging
-- @param recarm integer.
-- @param igngroupflags integer.
-- @return integer
function MediaTrack:set_track_ui_rec_arm(recarm, igngroupflags)
    return r.SetTrackUIRecArm(self.pointer, recarm, igngroupflags)
end

    
--- Set Track Ui Solo.
-- solo: <0 toggles, 1 sets solo (default mode), 0=unsets solo, 2 sets solo (non-
-- SIP), 4 sets solo (SIP). returns new value or -1 if error. igngroupflags: &1 to
-- prevent track grouping, &2 to prevent selection ganging
-- @param solo integer.
-- @param igngroupflags integer.
-- @return integer
function MediaTrack:set_track_ui_solo(solo, igngroupflags)
    return r.SetTrackUISolo(self.pointer, solo, igngroupflags)
end

    
--- Set Track Ui Volume.
-- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
-- @param volume number.
-- @param relative boolean.
-- @param done boolean.
-- @param igngroupflags integer.
-- @return number
function MediaTrack:set_track_ui_volume(volume, relative, done, igngroupflags)
    return r.SetTrackUIVolume(self.pointer, volume, relative, done, igngroupflags)
end

    
--- Set Track Ui Width.
-- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
-- @param width number.
-- @param relative boolean.
-- @param done boolean.
-- @param igngroupflags integer.
-- @return number
function MediaTrack:set_track_ui_width(width, relative, done, igngroupflags)
    return r.SetTrackUIWidth(self.pointer, width, relative, done, igngroupflags)
end

    
--- Toggle Track Send Ui Mute.
-- send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends.
-- @param send_idx integer.
-- @return boolean
function MediaTrack:toggle_track_send_ui_mute(send_idx)
    return r.ToggleTrackSendUIMute(self.pointer, send_idx)
end

    
--- Get Peak Hold Db.
-- Returns meter hold state, in dB*0.01 (0 = +0dB, -0.01 = -1dB, 0.02 = +2dB, etc).
-- If clear is set, clears the meter hold. If channel==1024 or channel==1025,
-- returns loudness values if this is the master track or this track's VU meters
-- are set to display loudness.
-- @param channel integer.
-- @param clear boolean.
-- @return number
function MediaTrack:get_peak_hold_db(channel, clear)
    return r.Track_GetPeakHoldDB(self.pointer, channel, clear)
end

    
--- Get Peak Info.
-- Returns peak meter value (1.0=+0dB, 0.0=-inf) for channel. If channel==1024 or
-- channel==1025, returns loudness values if this is the master track or this
-- track's VU meters are set to display loudness.
-- @param channel integer.
-- @return number
function MediaTrack:get_peak_info(channel)
    return r.Track_GetPeakInfo(self.pointer, channel)
end

    
--- Br Get Freeze Count.
-- [BR] Get media track freeze count (if track isn't frozen at all, returns 0).
-- @return integer
function MediaTrack:br_get_freeze_count()
    return r.BR_GetMediaTrackFreezeCount(self.pointer)
end

    
--- Br Get Send Info Envelope.
-- [BR] Get track envelope for send/receive/hardware output.
-- @param category integer.
-- @param send_idx integer.
-- @param envelope_type integer.
-- @return TrackEnvelope table
function MediaTrack:br_get_send_info_envelope(category, send_idx, envelope_type)
    local result = r.BR_GetMediaTrackSendInfo_Envelope(self.pointer, category, send_idx, envelope_type)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Br Get Send Info Track.
-- [BR] Get source or destination media track for send/receive.
-- @param category integer.
-- @param send_idx integer.
-- @param track_type integer.
-- @return MediaTrack table
function MediaTrack:br_get_send_info_track(category, send_idx, track_type)
    local result = r.BR_GetMediaTrackSendInfo_Track(self.pointer, category, send_idx, track_type)
    return media_track.MediaTrack:new(result)
end

    
--- Get Set Track Send Info.
-- [BR] Get or set send attributes.
-- @param category integer.
-- @param send_idx integer.
-- @param parm_name string.
-- @param set_new_value boolean.
-- @param new_value number.
-- @return number
function MediaTrack:get_set_track_send_info(category, send_idx, parm_name, set_new_value, new_value)
    return r.BR_GetSetTrackSendInfo(self.pointer, category, send_idx, parm_name, set_new_value, new_value)
end

    
--- Get Sws Track Notes.
-- @return string
function MediaTrack:get_sws_track_notes()
    return r.NF_GetSWSTrackNotes(self.pointer)
end

    
--- Set Sws Track Notes.
-- @param str string.
function MediaTrack:set_sws_track_notes(str)
    return r.NF_SetSWSTrackNotes(self.pointer, str)
end

    
--- Add Tcpfx Parm.
-- [S&M] Add an FX parameter knob in the TCP. Returns false if nothing updated
-- (invalid parameters, knob already present, etc..)
-- @param fx_id integer.
-- @param prm_id integer.
-- @return boolean
function MediaTrack:add_tcpfx_parm(fx_id, prm_id)
    return r.SNM_AddTCPFXParm(self.pointer, fx_id, prm_id)
end

    
--- Remove Receives From.
-- [S&M] Removes all receives from srctr. Returns false if nothing updated.
-- @return boolean
function MediaTrack:remove_receives_from()
    return r.SNM_RemoveReceivesFrom(self.pointer, srctr)
end

return MediaTrack
