-- @description ReaProject: Provide implementation for ReaProject functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_item = require('media_item')
local media_track = require('media_track')


local ReaProject = {}



--- Create new ReaProject instance.
-- @param project_idx number Optional. The index of the project
-- @return ReaProject table.
function ReaProject:new(project_idx)
    local project_idx = project_idx or 0
    local obj = {
        pointer_type = constants.PointerTypes.ReaProject,
        pointer = project_idx
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the ReaProject logger.
-- @param ... (varargs) Messages to log.
function ReaProject:log(...)
    local logger = helpers.log_func('ReaProject')
    logger(...)
    return nil
end

    
--- Add Project Marker.
-- Returns the index of the created marker/region, or -1 on failure. Supply
-- wantidx>=0 if you want a particular index number, but you'll get a different
-- index number a region and wantidx is already in use.
-- @param is_rgn boolean
-- @param pos number
-- @param rgnend number
-- @param name string
-- @param want_idx integer
-- @return integer
function ReaProject:add_project_marker(is_rgn, pos, rgnend, name, want_idx)
    return r.AddProjectMarker(self.pointer, is_rgn, pos, rgnend, name, want_idx)
end

    
--- Add Project Marker2.
-- Returns the index of the created marker/region, or -1 on failure. Supply
-- wantidx>=0 if you want a particular index number, but you'll get a different
-- index number a region and wantidx is already in use. color should be 0 (default
-- color), or ColorToNative(r,g,b)|0x1000000
-- @param is_rgn boolean
-- @param pos number
-- @param rgnend number
-- @param name string
-- @param want_idx integer
-- @param color integer
-- @return integer
function ReaProject:add_project_marker2(is_rgn, pos, rgnend, name, want_idx, color)
    return r.AddProjectMarker2(self.pointer, is_rgn, pos, rgnend, name, want_idx, color)
end

    
--- Any Track Solo.
-- @return boolean
function ReaProject:any_track_solo()
    return r.AnyTrackSolo(self.pointer)
end

    
--- Apply Nudge.
-- nudgeflag: &1=set to value (otherwise nudge by value), &2=snap nudgewhat:
-- 0=position, 1=left trim, 2=left edge, 3=right edge, 4=contents, 5=duplicate,
-- 6=edit cursor nudgeunit: 0=ms, 1=seconds, 2=grid, 3=256th notes, ..., 15=whole
-- notes, 16=measures.beats (1.15 = 1 measure + 1.5 beats), 17=samples, 18=frames,
-- 19=pixels, 20=item lengths, 21=item selections value: amount to nudge by, or
-- value to set to reverse: in nudge mode, nudges left (otherwise ignored) copies:
-- in nudge duplicate mode, number of copies (otherwise ignored)
-- @param nudgeflag integer
-- @param nudgewhat integer
-- @param nudgeunits integer
-- @param value number
-- @param reverse boolean
-- @param copies integer
-- @return boolean
function ReaProject:apply_nudge(nudgeflag, nudgewhat, nudgeunits, value, reverse, copies)
    return r.ApplyNudge(self.pointer, nudgeflag, nudgewhat, nudgeunits, value, reverse, copies)
end

    
--- Count Media Items.
-- count the number of items in the project (proj=0 for active project)
-- @return integer
function ReaProject:count_media_items()
    return r.CountMediaItems(self.pointer)
end

    
--- Count Project Markers.
-- num_markersOut and num_regionsOut may be NULL.
-- @return num_markers integer
-- @return num_regions integer
function ReaProject:count_project_markers()
    local retval, num_markers, num_regions = r.CountProjectMarkers(self.pointer)
    if retval then
        return num_markers, num_regions
    else
        return nil
    end
end

    
--- Count Selected Media Items.
-- Discouraged, because GetSelectedMediaItem can be inefficient if media items are
-- added, rearranged, or deleted in between calls. Instead see CountMediaItems,
-- GetMediaItem, IsMediaItemSelected.
-- @return integer
function ReaProject:count_selected_media_items()
    return r.CountSelectedMediaItems(self.pointer)
end

    
--- Count Selected Tracks.
-- Count the number of selected tracks in the project (proj=0 for active project).
-- This function ignores the master track, see CountSelectedTracks2.
-- @return integer
function ReaProject:count_selected_tracks()
    return r.CountSelectedTracks(self.pointer)
end

    
--- Count Selected Tracks2.
-- Count the number of selected tracks in the project (proj=0 for active project).
-- @param wantmaster boolean
-- @return integer
function ReaProject:count_selected_tracks2(wantmaster)
    return r.CountSelectedTracks2(self.pointer, wantmaster)
end

    
--- Count Tcpfx Parms.
-- Count the number of FX parameter knobs displayed on the track control panel.
-- @return integer
function ReaProject:count_tcpfx_parms()
    return r.CountTCPFXParms(self.pointer, track)
end

    
--- Count Tempo Time Sig Markers.
-- Count the number of tempo/time signature markers in the project. See
-- GetTempoTimeSigMarker, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
-- @return integer
function ReaProject:count_tempo_time_sig_markers()
    return r.CountTempoTimeSigMarkers(self.pointer)
end

    
--- Count Tracks.
-- count the number of tracks in the project (proj=0 for active project)
-- @return integer
function ReaProject:count_tracks()
    return r.CountTracks(self.pointer)
end

    
--- Delete Project Marker.
-- Delete a marker.  proj==NULL for the active project.
-- @param markrgnindexnumber integer
-- @param is_rgn boolean
-- @return boolean
function ReaProject:delete_project_marker(markrgnindexnumber, is_rgn)
    return r.DeleteProjectMarker(self.pointer, markrgnindexnumber, is_rgn)
end

    
--- Delete Project Marker By Index.
-- Differs from DeleteProjectMarker only in that markrgnidx is 0 for the first
-- marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than
-- representing the displayed marker/region ID number (see SetProjectMarker4).
-- @param markrgn_idx integer
-- @return boolean
function ReaProject:delete_project_marker_by_index(markrgn_idx)
    return r.DeleteProjectMarkerByIndex(self.pointer, markrgn_idx)
end

    
--- Delete Tempo Time Sig Marker.
-- Delete a tempo/time signature marker.
-- @param markerindex integer
-- @return boolean
function ReaProject:delete_tempo_time_sig_marker(markerindex)
    return r.DeleteTempoTimeSigMarker(self.pointer, markerindex)
end

    
--- Edit Tempo Time Sig Marker.
-- Open the tempo/time signature marker editor dialog.
-- @param markerindex integer
-- @return boolean
function ReaProject:edit_tempo_time_sig_marker(markerindex)
    return r.EditTempoTimeSigMarker(self.pointer, markerindex)
end

    
--- Enum Project Markers2.
-- @param _idx integer
-- @return is_rgn boolean
-- @return pos number
-- @return rgnend number
-- @return name string
-- @return markrgnindexnumber integer
function ReaProject:enum_project_markers2(_idx)
    local retval, is_rgn, pos, rgnend, name, markrgnindexnumber = r.EnumProjectMarkers2(self.pointer, _idx)
    if retval then
        return is_rgn, pos, rgnend, name, markrgnindexnumber
    else
        return nil
    end
end

    
--- Enum Project Markers3.
-- @param _idx integer
-- @return is_rgn boolean
-- @return pos number
-- @return rgnend number
-- @return name string
-- @return markrgnindexnumber integer
-- @return color integer
function ReaProject:enum_project_markers3(_idx)
    local retval, is_rgn, pos, rgnend, name, markrgnindexnumber, color = r.EnumProjectMarkers3(self.pointer, _idx)
    if retval then
        return is_rgn, pos, rgnend, name, markrgnindexnumber, color
    else
        return nil
    end
end

    
--- Enum Proj Ext State.
-- Enumerate the data stored with the project for a specific extname. Returns false
-- when there is no more data. See SetProjExtState, GetProjExtState.
-- @param extname string
-- @param _idx integer
-- @return string key
-- @return string val
function ReaProject:enum_proj_ext_state(extname, _idx)
    local retval, string, string = r.EnumProjExtState(self.pointer, extname, _idx)
    if retval then
        return string, string
    else
        return nil
    end
end

    
--- Enum Region Render Matrix.
-- Enumerate which tracks will be rendered within this region when using the region
-- render matrix. When called with rendertrack==0, the function returns the first
-- track that will be rendered (which may be the master track); rendertrack==1 will
-- return the next track rendered, and so on. The function returns NULL when there
-- are no more tracks that will be rendered within this region.
-- @param regionindex integer
-- @param rendertrack integer
-- @return MediaTrack table
function ReaProject:enum_region_render_matrix(regionindex, rendertrack)
    local result = r.EnumRegionRenderMatrix(self.pointer, regionindex, rendertrack)
    return media_track.MediaTrack:new(result)
end

    
--- Enum Track Midi Program Names Ex.
-- returns false if there are no plugins on the track that support MIDI programs,or
-- if all programs have been enumerated
-- @param program_number integer
-- @param program_name string
-- @return program_name string
function ReaProject:enum_track_midi_program_names_ex(program_number, program_name)
    local retval, program_name = r.EnumTrackMIDIProgramNamesEx(self.pointer, track, program_number, program_name)
    if retval then
        return program_name
    else
        return nil
    end
end

    
--- Find Tempo Time Sig Marker.
-- Find the tempo/time signature marker that falls at or before this time position
-- (the marker that is in effect as of this time position).
-- @param time number
-- @return integer
function ReaProject:find_tempo_time_sig_marker(time)
    return r.FindTempoTimeSigMarker(self.pointer, time)
end

    
--- Get All Project Play States.
-- returns the bitwise OR of all project play states (1=playing, 2=pause,
-- 4=recording)
-- @return integer
function ReaProject:get_all_project_play_states()
    return r.GetAllProjectPlayStates(self.pointer)
end

    
--- Get Cursor Position Ex.
-- edit cursor position
-- @return number
function ReaProject:get_cursor_position_ex()
    return r.GetCursorPositionEx(self.pointer)
end

    
--- Get Free Disk Space For Record Path.
-- returns free disk space in megabytes, pathIdx 0 for normal, 1 for alternate.
-- @param path_idx integer
-- @return integer
function ReaProject:get_free_disk_space_for_record_path(path_idx)
    return r.GetFreeDiskSpaceForRecordPath(self.pointer, path_idx)
end

    
--- Get Last Marker And Cur Region.
-- Get the last project marker before time, and/or the project region that includes
-- time. markeridx and regionidx are returned not necessarily as the displayed
-- marker/region index, but as the index that can be passed to EnumProjectMarkers.
-- Either or both of markeridx and regionidx may be NULL. See EnumProjectMarkers.
-- @param time number
-- @return marker_idx integer
-- @return region_idx integer
function ReaProject:get_last_marker_and_cur_region(time)
    return r.GetLastMarkerAndCurRegion(self.pointer, time)
end

    
--- Get Master Track.
-- @return MediaTrack table
function ReaProject:get_master_track()
    local result = r.GetMasterTrack(self.pointer)
    return media_track.MediaTrack:new(result)
end

    
--- Get Media Item.
-- get an item from a project by item count (zero-based) (proj=0 for active
-- project)
-- @param item_idx integer
-- @return MediaItem table
function ReaProject:get_media_item(item_idx)
    local result = r.GetMediaItem(self.pointer, item_idx)
    return media_item.MediaItem:new(result)
end

    
--- Get Media Item Take By Guid.
-- @param guid_guid string
-- @return MediaItemTake table
function ReaProject:get_media_item_take_by_guid(guid_guid)
    local result = r.GetMediaItemTakeByGUID(self.pointer, guid_guid)
    return media_item_take.MediaItemTake:new(result)
end

    
--- Get Play Position2 Ex.
-- returns position of next audio block being processed
-- @return number
function ReaProject:get_play_position2_ex()
    return r.GetPlayPosition2Ex(self.pointer)
end

    
--- Get Play Position Ex.
-- returns latency-compensated actual-what-you-hear position
-- @return number
function ReaProject:get_play_position_ex()
    return r.GetPlayPositionEx(self.pointer)
end

    
--- Get Play State Ex.
-- &1=playing, &2=paused, &4=is recording
-- @return integer
function ReaProject:get_play_state_ex()
    return r.GetPlayStateEx(self.pointer)
end

    
--- Get Project Length.
-- returns length of project (maximum of end of media item, markers, end of
-- regions, tempo map
-- @return number
function ReaProject:get_project_length()
    return r.GetProjectLength(self.pointer)
end

    
--- Get Project Name.
-- @return buf string
function ReaProject:get_project_name()
    return r.GetProjectName(self.pointer)
end

    
--- Get Project Path Ex.
-- Get the project recording path.
-- @return buf string
function ReaProject:get_project_path_ex()
    return r.GetProjectPathEx(self.pointer)
end

    
--- Get Project State Change Count.
-- returns an integer that changes when the project state changes
-- @return integer
function ReaProject:get_project_state_change_count()
    return r.GetProjectStateChangeCount(self.pointer)
end

    
--- Get Project Time Offset.
-- Gets project time offset in seconds (project settings - project start time). If
-- rndframe is true, the offset is rounded to a multiple of the project frame size.
-- @param rndframe boolean
-- @return number
function ReaProject:get_project_time_offset(rndframe)
    return r.GetProjectTimeOffset(self.pointer, rndframe)
end

    
--- Get Project Time Signature2.
-- Gets basic time signature (beats per minute, numerator of time signature in bpi)
-- this does not reflect tempo envelopes but is purely what is set in the project
-- settings.
-- @return bpm number
-- @return bpi number
function ReaProject:get_project_time_signature2()
    return r.GetProjectTimeSignature2(self.pointer)
end

    
--- Get Proj Ext State.
-- Get the value previously associated with this extname and key, the last time the
-- project was saved. See SetProjExtState, EnumProjExtState.
-- @param extname string
-- @param key string
-- @return val string
function ReaProject:get_proj_ext_state(extname, key)
    local retval, val = r.GetProjExtState(self.pointer, extname, key)
    if retval then
        return val
    else
        return nil
    end
end

    
--- Get Selected Envelope.
-- get the currently selected envelope, returns NULL/nil if no envelope is selected
-- @return TrackEnvelope table
function ReaProject:get_selected_envelope()
    local result = r.GetSelectedEnvelope(self.pointer)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Selected Media Item.
-- Discouraged, because GetSelectedMediaItem can be inefficient if media items are
-- added, rearranged, or deleted in between calls. Instead see CountMediaItems,
-- GetMediaItem, IsMediaItemSelected.
-- @param selitem integer
-- @return MediaItem table
function ReaProject:get_selected_media_item(selitem)
    local result = r.GetSelectedMediaItem(self.pointer, selitem)
    return media_item.MediaItem:new(result)
end

    
--- Get Selected Track.
-- Get a selected track from a project (proj=0 for active project) by selected
-- track count (zero-based). This function ignores the master track, see
-- GetSelectedTrack2.
-- @param seltrack_idx integer
-- @return MediaTrack table
function ReaProject:get_selected_track(seltrack_idx)
    local result = r.GetSelectedTrack(self.pointer, seltrack_idx)
    return media_track.MediaTrack:new(result)
end

    
--- Get Selected Track2.
-- Get a selected track from a project (proj=0 for active project) by selected
-- track count (zero-based).
-- @param seltrack_idx integer
-- @param wantmaster boolean
-- @return MediaTrack table
function ReaProject:get_selected_track2(seltrack_idx, wantmaster)
    local result = r.GetSelectedTrack2(self.pointer, seltrack_idx, wantmaster)
    return media_track.MediaTrack:new(result)
end

    
--- Get Selected Track Envelope.
-- get the currently selected track envelope, returns NULL/nil if no envelope is
-- selected
-- @return TrackEnvelope table
function ReaProject:get_selected_track_envelope()
    local result = r.GetSelectedTrackEnvelope(self.pointer)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Set Arrange View2.
-- Gets or sets the arrange view start/end time for screen coordinates. use
-- screen_x_start=screen_x_end=0 to use the full arrange view's start/end time
-- @param is__set boolean
-- @param screen_x_start integer
-- @param screen_x_end integer
-- @param start_time number
-- @param end_time number
-- @return start_time number
-- @return end_time number
function ReaProject:get_set_arrange_view2(is__set, screen_x_start, screen_x_end, start_time, end_time)
    return r.GetSet_ArrangeView2(self.pointer, is__set, screen_x_start, screen_x_end, start_time, end_time)
end

    
--- Get Set Loop Time Range2.
-- @param is__set boolean
-- @param is__loop boolean
-- @param start number
-- @param end_ number
-- @param allowautoseek boolean
-- @return start number
-- @return end_ number
function ReaProject:get_set_loop_time_range2(is__set, is__loop, start, end_, allowautoseek)
    return r.GetSet_LoopTimeRange2(self.pointer, is__set, is__loop, start, end_, allowautoseek)
end

    
--- Get Set Project Grid.
-- Get or set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note
-- triplet, etc. swingmode can be 1 for swing enabled, swingamt is -1..1. swingmode
-- can be 3 for measure-grid. Returns grid configuration flags
-- @param set boolean
-- @param number division optional
-- @param integer swingmode optional
-- @param number swingamt optional
-- @return number division
-- @return integer swingmode
-- @return number swingamt
function ReaProject:get_set_project_grid(set, number, integer, number)
    local number = number or nil
    local integer = integer or nil
    local retval, number, integer, number = r.GetSetProjectGrid(self.pointer, set, number, integer, number)
    if retval then
        return number, integer, number
    else
        return nil
    end
end

    
--- Get Set Project Info.
-- Get or set project information. RENDER_SETTINGS : &(1|2)=0:master mix,
-- &1=stems+master mix, &2=stems only, &4=multichannel tracks to multichannel
-- files, &8=use render matrix, &16=tracks with only mono media to mono files,
-- &32=selected media items, &64=selected media items via master, &128=selected
-- tracks via master, &256=embed transients if format supports, &512=embed metadata
-- if format supports, &1024=embed take markers if format supports, &2048=2nd pass
-- render RENDER_BOUNDSFLAG : 0=custom time bounds, 1=entire project, 2=time
-- selection, 3=all project regions, 4=selected media items, 5=selected project
-- regions, 6=all project markers, 7=selected project markers RENDER_CHANNELS :
-- number of channels in rendered file RENDER_SRATE : sample rate of rendered file
-- (or 0 for project sample rate) RENDER_STARTPOS : render start time when
-- RENDER_BOUNDSFLAG=0 RENDER_ENDPOS : render end time when RENDER_BOUNDSFLAG=0
-- RENDER_TAILFLAG : apply render tail setting when rendering: &1=custom time
-- bounds, &2=entire project, &4=time selection, &8=all project markers/regions,
-- &16=selected media items, &32=selected project markers/regions RENDER_TAILMS :
-- tail length in ms to render (only used if RENDER_BOUNDSFLAG and RENDER_TAILFLAG
-- are set) RENDER_ADDTOPROJ : &1=add rendered files to project, &2=do not render
-- files that are likely silent RENDER_DITHER : &1=dither, &2=noise shaping,
-- &4=dither stems, &8=noise shaping on stems RENDER_NORMALIZE: &1=enable,
-- (&14==0)=LUFS-I, (&14==2)=RMS, (&14==4)=peak, (&14==6)=true peak,
-- (&14==8)=LUFS-M max, (&14==10)=LUFS-S max, (&4128==32)=normalize stems to common
-- gain based on master, &64=enable brickwall limit, &128=brickwall limit true
-- peak, (&2304==256)=only normalize files that are too loud, (&2304==2048)=only
-- normalize files that are too quiet, &512=apply fade-in, &1024=apply fade-out,
-- (&4128==4096)=normalize to loudest file, (&4128==4128)=normalize as if one long
-- file, &8192=adjust mono media additional -3dB RENDER_NORMALIZE_TARGET: render
-- normalization target as amplitude, so 0.5 means -6.02dB, 0.25 means -12.04dB,
-- etc RENDER_BRICKWALL: render brickwall limit as amplitude, so 0.5 means -6.02dB,
-- 0.25 means -12.04dB, etc RENDER_FADEIN: render fade-in (0.001 means 1 ms,
-- requires RENDER_NORMALIZE&512) RENDER_FADEOUT: render fade-out (0.001 means 1
-- ms, requires RENDER_NORMALIZE&1024) RENDER_FADEINSHAPE: render fade-in shape
-- RENDER_FADEOUTSHAPE: render fade-out shape PROJECT_SRATE : sample rate (ignored
-- unless PROJECT_SRATE_USE set) PROJECT_SRATE_USE : set to 1 if project sample
-- rate is used
-- @param desc string
-- @param value number
-- @param is__set boolean
-- @return number
function ReaProject:get_set_project_info(desc, value, is__set)
    return r.GetSetProjectInfo(self.pointer, desc, value, is__set)
end

    
--- Get Set Project Info String.
-- Get or set project information. PROJECT_NAME : project file name (read-only,
-- is_set will be ignored) PROJECT_TITLE : title field from Project Settings/Notes
-- dialog PROJECT_AUTHOR : author field from Project Settings/Notes dialog
-- TRACK_GROUP_NAME:X : track group name, X should be 1..64 MARKER_GUID:X : get the
-- GUID (unique ID) of the marker or region with index X, where X is the index
-- passed to EnumProjectMarkers, not necessarily the displayed number (read-only)
-- MARKER_INDEX_FROM_GUID:{GUID} : get the GUID index of the marker or region with
-- GUID {GUID} (read-only) OPENCOPY_CFGIDX : integer for the configuration of
-- format to use when creating copies/applying FX. 0=wave (auto-depth),
-- 1=APPLYFX_FORMAT, 2=RECORD_FORMAT RECORD_PATH : recording directory -- may be
-- blank or a relative path, to get the effective path see GetProjectPathEx()
-- RECORD_PATH_SECONDARY : secondary recording directory RECORD_FORMAT :
-- base64-encoded sink configuration (see project files, etc). Callers can also
-- pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use
-- default settings for that sink type. APPLYFX_FORMAT : base64-encoded sink
-- configuration (see project files, etc). Used only if RECFMT_OPENCOPY is set to
-- 1. Callers can also pass a simple 4-byte string (non-base64-encoded), e.g.
-- "evaw" or "l3pm", to use default settings for that sink type. RENDER_FILE :
-- render directory RENDER_PATTERN : render file name (may contain wildcards)
-- RENDER_METADATA : get or set the metadata saved with the project (not metadata
-- embedded in project media). Example, ID3 album name metadata:
-- valuestr="ID3:TALB" to get, valuestr="ID3:TALB|my album name" to set. Call with
-- valuestr="" and is_set=false to get a semicolon-separated list of defined
-- project metadata identifiers. RENDER_TARGETS : semicolon separated list of files
-- that would be written if the project is rendered using the most recent render
-- settings RENDER_STATS : (read-only) semicolon separated list of statistics for
-- the most recently rendered files. call with valuestr="XXX" to run an action (for
-- example, "42437"=dry run render selected items) before returning statistics.
-- RENDER_FORMAT : base64-encoded sink configuration (see project files, etc).
-- Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw"
-- or "l3pm", to use default settings for that sink type. RENDER_FORMAT2 :
-- base64-encoded secondary sink configuration. Callers can also pass a simple
-- 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default
-- settings for that sink type, or "" to disable secondary render.     Formats
-- available on this machine:     "wave" "aiff" "caff" "raw " "iso " "ddp " "flac"
-- "mp3l" "oggv" "OggS" "FFMP" "WMF " "GIF " "LCF " "wvpk"
-- @param desc string
-- @param valuestr_need_big string
-- @param is__set boolean
-- @return valuestr_need_big string
function ReaProject:get_set_project_info_string(desc, valuestr_need_big, is__set)
    local retval, valuestr_need_big = r.GetSetProjectInfo_String(self.pointer, desc, valuestr_need_big, is__set)
    if retval then
        return valuestr_need_big
    else
        return nil
    end
end

    
--- Get Set Project Notes.
-- gets or sets project notes, notesNeedBig_sz is ignored when setting
-- @param set boolean
-- @param notes string
-- @return notes string
function ReaProject:get_set_project_notes(set, notes)
    return r.GetSetProjectNotes(self.pointer, set, notes)
end

    
--- Get Set Repeat Ex.
-- -1 == query,0=clear,1=set,>1=toggle . returns new value
-- @param val integer
-- @return integer
function ReaProject:get_set_repeat_ex(val)
    return r.GetSetRepeatEx(self.pointer, val)
end

    
--- Get Set Tempo Time Sig Marker Flag.
-- Gets or sets the attribute flag of a tempo/time signature marker. flag &1=sets
-- time signature and starts new measure, &2=does not set tempo, &4=allow previous
-- partial measure if starting new measure, &8=set new metronome pattern if
-- starting new measure, &16=reset ruler grid if starting new measure
-- @param point_index integer
-- @param flag integer
-- @param is__set boolean
-- @return integer
function ReaProject:get_set_tempo_time_sig_marker_flag(point_index, flag, is__set)
    return r.GetSetTempoTimeSigMarkerFlag(self.pointer, point_index, flag, is__set)
end

    
--- Get Tcpfx Parm.
-- Get information about a specific FX parameter knob (see CountTCPFXParms).
-- @param index integer
-- @return fxindex integer
-- @return parm_idx integer
function ReaProject:get_tcpfx_parm(index)
    local retval, fxindex, parm_idx = r.GetTCPFXParm(self.pointer, track, index)
    if retval then
        return fxindex, parm_idx
    else
        return nil
    end
end

    
--- Get Tempo Time Sig Marker.
-- Get information about a tempo/time signature marker. See
-- CountTempoTimeSigMarkers, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
-- @param pt_idx integer
-- @return timepos number
-- @return measurepos integer
-- @return beatpos number
-- @return bpm number
-- @return timesig_num integer
-- @return timesig_denom integer
-- @return lineartempo boolean
function ReaProject:get_tempo_time_sig_marker(pt_idx)
    local retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo = r.GetTempoTimeSigMarker(self.pointer, pt_idx)
    if retval then
        return timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo
    else
        return nil
    end
end

    
--- Get Track.
-- get a track from a project by track count (zero-based) (proj=0 for active
-- project)
-- @param track_idx integer
-- @return MediaTrack table
function ReaProject:get_track(track_idx)
    local result = r.GetTrack(self.pointer, track_idx)
    return media_track.MediaTrack:new(result)
end

    
--- Get Track Midi Note Name Ex.
-- Get note/CC name. pitch 128 for CC0 name, 129 for CC1 name, etc. See
-- SetTrackMIDINoteNameEx
-- @param pitch integer
-- @param chan integer
-- @return string
function ReaProject:get_track_midi_note_name_ex(pitch, chan)
    return r.GetTrackMIDINoteNameEx(self.pointer, track, pitch, chan)
end

    
--- Get Track Midi Note Range.
-- @return note_lo integer
-- @return note_hi integer
function ReaProject:get_track_midi_note_range()
    return r.GetTrackMIDINoteRange(self.pointer, track)
end

    
--- Go To Marker.
-- Go to marker. If use_timeline_order==true, marker_index 1 refers to the first
-- marker on the timeline.  If use_timeline_order==false, marker_index 1 refers to
-- the first marker with the user-editable index of 1.
-- @param marker_index integer
-- @param use_timeline_order boolean
function ReaProject:go_to_marker(marker_index, use_timeline_order)
    return r.GoToMarker(self.pointer, marker_index, use_timeline_order)
end

    
--- Go To Region.
-- Seek to region after current region finishes playing (smooth seek). If
-- use_timeline_order==true, region_index 1 refers to the first region on the
-- timeline.  If use_timeline_order==false, region_index 1 refers to the first
-- region with the user-editable index of 1.
-- @param region_index integer
-- @param use_timeline_order boolean
function ReaProject:go_to_region(region_index, use_timeline_order)
    return r.GoToRegion(self.pointer, region_index, use_timeline_order)
end

    
--- Has Track Midi Programs Ex.
-- returns name of track plugin that is supplying MIDI programs,or NULL if there is
-- none
-- @return string
function ReaProject:has_track_midi_programs_ex()
    return r.HasTrackMIDIProgramsEx(self.pointer, track)
end

    
--- Insert Track In Project.
-- inserts a track in project proj at idx, this will be clamped to
-- 0..CountTracks(proj). flags&1 for default envelopes/FX, otherwise no enabled
-- fx/envelopes will be added.
-- @param _idx integer
-- @param flags integer
function ReaProject:insert_track_in_project(_idx, flags)
    return r.InsertTrackInProject(self.pointer, _idx, flags)
end

    
--- Is Project Dirty.
-- Is the project dirty (needing save)? Always returns 0 if 'undo/prompt to save'
-- is disabled in preferences.
-- @return integer
function ReaProject:is_project_dirty()
    return r.IsProjectDirty(self.pointer)
end

    
--- Loop On Arrow.
-- Move the loop selection left or right. Returns true if snap is enabled.
-- @param direction integer
-- @return boolean
function ReaProject:loop_on_arrow(direction)
    return r.Loop_OnArrow(self.pointer, direction)
end

    
--- Mark Project Dirty.
-- Marks project as dirty (needing save) if 'undo/prompt to save' is enabled in
-- preferences.
function ReaProject:mark_project_dirty()
    return r.MarkProjectDirty(self.pointer)
end

    
--- On Pause Button Ex.
-- direct way to simulate pause button hit
function ReaProject:on_pause_button_ex()
    return r.OnPauseButtonEx(self.pointer)
end

    
--- On Play Button Ex.
-- direct way to simulate play button hit
function ReaProject:on_play_button_ex()
    return r.OnPlayButtonEx(self.pointer)
end

    
--- On Stop Button Ex.
-- direct way to simulate stop button hit
function ReaProject:on_stop_button_ex()
    return r.OnStopButtonEx(self.pointer)
end

    
--- Select All Media Items.
-- @param selected boolean
function ReaProject:select_all_media_items(selected)
    return r.SelectAllMediaItems(self.pointer, selected)
end

    
--- Select Project Instance.
function ReaProject:select_project_instance()
    return r.SelectProjectInstance(self.pointer)
end

    
--- Set Current Bpm.
-- set current BPM in project, set wantUndo=true to add undo point
-- @param bpm number
-- @param want_undo boolean
function ReaProject:set_current_bpm(bpm, want_undo)
    return r.SetCurrentBPM(self.pointer, bpm, want_undo)
end

    
--- Set Edit Cur Pos2.
-- @param time number
-- @param moveview boolean
-- @param seekplay boolean
function ReaProject:set_edit_cur_pos2(time, moveview, seekplay)
    return r.SetEditCurPos2(self.pointer, time, moveview, seekplay)
end

    
--- Set Midi Editor Grid.
-- Set the MIDI editor grid division. 0.25=quarter note, 1.0/3.0=half note tripet,
-- etc.
-- @param division number
function ReaProject:set_midi_editor_grid(division)
    return r.SetMIDIEditorGrid(self.pointer, division)
end

    
--- Set Project Grid.
-- Set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note
-- triplet, etc.
-- @param division number
function ReaProject:set_project_grid(division)
    return r.SetProjectGrid(self.pointer, division)
end

    
--- Set Project Marker2.
-- Note: this function can't clear a marker's name (an empty string will leave the
-- name unchanged), see SetProjectMarker4.
-- @param markrgnindexnumber integer
-- @param is_rgn boolean
-- @param pos number
-- @param rgnend number
-- @param name string
-- @return boolean
function ReaProject:set_project_marker2(markrgnindexnumber, is_rgn, pos, rgnend, name)
    return r.SetProjectMarker2(self.pointer, markrgnindexnumber, is_rgn, pos, rgnend, name)
end

    
--- Set Project Marker3.
-- Note: this function can't clear a marker's name (an empty string will leave the
-- name unchanged), see SetProjectMarker4.
-- @param markrgnindexnumber integer
-- @param is_rgn boolean
-- @param pos number
-- @param rgnend number
-- @param name string
-- @param color integer
-- @return boolean
function ReaProject:set_project_marker3(markrgnindexnumber, is_rgn, pos, rgnend, name, color)
    return r.SetProjectMarker3(self.pointer, markrgnindexnumber, is_rgn, pos, rgnend, name, color)
end

    
--- Set Project Marker4.
-- color should be 0 to not change, or ColorToNative(r,g,b)|0x1000000, flags&1 to
-- clear name
-- @param markrgnindexnumber integer
-- @param is_rgn boolean
-- @param pos number
-- @param rgnend number
-- @param name string
-- @param color integer
-- @param flags integer
-- @return boolean
function ReaProject:set_project_marker4(markrgnindexnumber, is_rgn, pos, rgnend, name, color, flags)
    return r.SetProjectMarker4(self.pointer, markrgnindexnumber, is_rgn, pos, rgnend, name, color, flags)
end

    
--- Set Project Marker By Index.
-- See SetProjectMarkerByIndex2.
-- @param markrgn_idx integer
-- @param is_rgn boolean
-- @param pos number
-- @param rgnend number
-- @param i_dnumber integer
-- @param name string
-- @param color integer
-- @return boolean
function ReaProject:set_project_marker_by_index(markrgn_idx, is_rgn, pos, rgnend, i_dnumber, name, color)
    return r.SetProjectMarkerByIndex(self.pointer, markrgn_idx, is_rgn, pos, rgnend, i_dnumber, name, color)
end

    
--- Set Project Marker By Index2.
-- Differs from SetProjectMarker4 in that markrgnidx is 0 for the first
-- marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than
-- representing the displayed marker/region ID number (see SetProjectMarker3).
-- Function will fail if attempting to set a duplicate ID number for a region
-- (duplicate ID numbers for markers are OK). , flags&1 to clear name. If flags&2,
-- markers will not be re-sorted, and after making updates, you MUST call
-- SetProjectMarkerByIndex2 with markrgnidx=-1 and flags&2 to force re-sort/UI
-- updates.
-- @param markrgn_idx integer
-- @param is_rgn boolean
-- @param pos number
-- @param rgnend number
-- @param i_dnumber integer
-- @param name string
-- @param color integer
-- @param flags integer
-- @return boolean
function ReaProject:set_project_marker_by_index2(markrgn_idx, is_rgn, pos, rgnend, i_dnumber, name, color, flags)
    return r.SetProjectMarkerByIndex2(self.pointer, markrgn_idx, is_rgn, pos, rgnend, i_dnumber, name, color, flags)
end

    
--- Set Proj Ext State.
-- Save a key/value pair for a specific extension, to be restored the next time
-- this specific project is loaded. Typically extname will be the name of a
-- reascript or extension section. If key is NULL or "", all extended data for that
-- extname will be deleted.  If val is NULL or "", the data previously associated
-- with that key will be deleted. Returns the size of the state for this extname.
-- See GetProjExtState, EnumProjExtState.
-- @param extname string
-- @param key string
-- @param value string
-- @return integer
function ReaProject:set_proj_ext_state(extname, key, value)
    return r.SetProjExtState(self.pointer, extname, key, value)
end

    
--- Set Region Render Matrix.
-- Add (flag > 0) or remove (flag < 0) a track from this region when using the
-- region render matrix. If adding, flag==2 means force mono, flag==4 means force
-- stereo, flag==N means force N/2 channels.
-- @param regionindex integer
-- @param flag integer
function ReaProject:set_region_render_matrix(regionindex, flag)
    return r.SetRegionRenderMatrix(self.pointer, regionindex, track, flag)
end

    
--- Set Tempo Time Sig Marker.
-- Set parameters of a tempo/time signature marker. Provide either timepos (with
-- measurepos=-1, beatpos=-1), or measurepos and beatpos (with timepos=-1). If
-- timesig_num and timesig_denom are zero, the previous time signature will be
-- used. ptidx=-1 will insert a new tempo/time signature marker. See
-- CountTempoTimeSigMarkers, GetTempoTimeSigMarker, AddTempoTimeSigMarker.
-- @param pt_idx integer
-- @param timepos number
-- @param measurepos integer
-- @param beatpos number
-- @param bpm number
-- @param timesig_num integer
-- @param timesig_denom integer
-- @param lineartempo boolean
-- @return boolean
function ReaProject:set_tempo_time_sig_marker(pt_idx, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo)
    return r.SetTempoTimeSigMarker(self.pointer, pt_idx, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo)
end

    
--- Set Track Midi Note Name Ex.
-- channel < 0 assigns note name to all channels. pitch 128 assigns name for CC0,
-- pitch 129 for CC1, etc.
-- @param pitch integer
-- @param chan integer
-- @param name string
-- @return boolean
function ReaProject:set_track_midi_note_name_ex(pitch, chan, name)
    return r.SetTrackMIDINoteNameEx(self.pointer, track, pitch, chan, name)
end

    
--- Snap To Grid.
-- @param time_pos number
-- @return number
function ReaProject:snap_to_grid(time_pos)
    return r.SnapToGrid(self.pointer, time_pos)
end

    
--- Time Map Beats To Time.
-- convert a beat position (or optionally a beats+measures if measures is non-NULL)
-- to time.
-- @param tpos number
-- @param integer measuresIn optional
-- @return number
function ReaProject:time_map_beats_to_time(tpos, integer)
    local integer = integer or nil
    return r.TimeMap2_beatsToTime(self.pointer, tpos, integer)
end

    
--- Time Map Get Divided Bpm At Time.
-- get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
-- @param time number
-- @return number
function ReaProject:time_map_get_divided_bpm_at_time(time)
    return r.TimeMap2_GetDividedBpmAtTime(self.pointer, time)
end

    
--- Time Map Get Next Change Time.
-- when does the next time map (tempo or time sig) change occur
-- @param time number
-- @return number
function ReaProject:time_map_get_next_change_time(time)
    return r.TimeMap2_GetNextChangeTime(self.pointer, time)
end

    
--- Time Map Qn To Time.
-- converts project QN position to time.
-- @param qn number
-- @return number
function ReaProject:time_map_qn_to_time(qn)
    return r.TimeMap2_QNToTime(self.pointer, qn)
end

    
--- Time Map Time To Beats.
-- convert a time into beats. if measures is non-NULL, measures will be set to the
-- measure count, return value will be beats since measure. if cml is non-NULL,
-- will be set to current measure length in beats (i.e. time signature numerator)
-- if fullbeats is non-NULL, and measures is non-NULL, fullbeats will get the full
-- beat count (same value returned if measures is NULL). if cdenom is non-NULL,
-- will be set to the current time signature denominator.
-- @param tpos number
-- @return integer measures
-- @return integer cml
-- @return number fullbeats
-- @return integer cdenom
function ReaProject:time_map_time_to_beats(tpos)
    local retval, integer, integer, number, integer = r.TimeMap2_timeToBeats(self.pointer, tpos)
    if retval then
        return integer, integer, number, integer
    else
        return nil
    end
end

    
--- Time Map Time To Qn.
-- converts project time position to QN position.
-- @param tpos number
-- @return number
function ReaProject:time_map_time_to_qn(tpos)
    return r.TimeMap2_timeToQN(self.pointer, tpos)
end

    
--- Undo Begin Block2.
-- call to start a new block
function ReaProject:undo_begin_block2()
    return r.Undo_BeginBlock2(self.pointer)
end

    
--- Undo Can Redo2.
-- returns string of next action,if able,NULL if not
-- @return string
function ReaProject:undo_can_redo2()
    return r.Undo_CanRedo2(self.pointer)
end

    
--- Undo Can Undo2.
-- returns string of last action,if able,NULL if not
-- @return string
function ReaProject:undo_can_undo2()
    return r.Undo_CanUndo2(self.pointer)
end

    
--- Undo Do Redo2.
-- nonzero if success
-- @return integer
function ReaProject:undo_do_redo2()
    return r.Undo_DoRedo2(self.pointer)
end

    
--- Undo Do Undo2.
-- nonzero if success
-- @return integer
function ReaProject:undo_do_undo2()
    return r.Undo_DoUndo2(self.pointer)
end

    
--- Undo End Block2.
-- call to end the block,with extra flags if any,and a description
-- @param descchange string
-- @param extraflags integer
function ReaProject:undo_end_block2(descchange, extraflags)
    return r.Undo_EndBlock2(self.pointer, descchange, extraflags)
end

    
--- Undo On State Change2.
-- limited state change to items
-- @param descchange string
function ReaProject:undo_on_state_change2(descchange)
    return r.Undo_OnStateChange2(self.pointer, descchange)
end

    
--- Undo On State Change Item.
-- @param name string
function ReaProject:undo_on_state_change_item(name)
    return r.Undo_OnStateChange_Item(self.pointer, name, item)
end

    
--- Undo On State Change Ex2.
-- trackparm=-1 by default,or if updating one fx chain,you can specify track index
-- @param descchange string
-- @param which_states integer
-- @param trackparm integer
function ReaProject:undo_on_state_change_ex2(descchange, which_states, trackparm)
    return r.Undo_OnStateChangeEx2(self.pointer, descchange, which_states, trackparm)
end

    
--- Update Item Lanes.
-- Recalculate lane arrangement for fixed lane tracks, including auto-removing
-- empty lanes at the bottom of the track
-- @return boolean
function ReaProject:update_item_lanes()
    return r.UpdateItemLanes(self.pointer)
end

    
--- Validate Ptr2.
-- Return true if the pointer is a valid object of the right type in proj (proj is
-- ignored if pointer is itself a project). Supported types are: ReaProject*,
-- MediaTrack*, MediaItem*, MediaItem_Take*, TrackEnvelope* and PCM_source*.
-- @param pointer identifier
-- @param ctypename string
-- @return boolean
function ReaProject:validate_ptr2(pointer, ctypename)
    return r.ValidatePtr2(self.pointer, pointer, ctypename)
end

    
--- Get Media Item By Guid.
-- [BR] Get media item from GUID string. Note that the GUID must be enclosed in
-- braces {}. To get item's GUID as a string, see BR_GetMediaItemGUID.
-- @param guid_string_in string
-- @return MediaItem table
function ReaProject:get_media_item_by_guid(guid_string_in)
    local result = r.BR_GetMediaItemByGUID(self.pointer, guid_string_in)
    return media_item.MediaItem:new(result)
end

    
--- Get Media Track By Guid.
-- [BR] Get media track from GUID string. Note that the GUID must be enclosed in
-- braces {}. To get track's GUID as a string, see GetSetMediaTrackInfo_String.
-- @param guid_string_in string
-- @return MediaTrack table
function ReaProject:get_media_track_by_guid(guid_string_in)
    local result = r.BR_GetMediaTrackByGUID(self.pointer, guid_string_in)
    return media_track.MediaTrack:new(result)
end

    
--- Get Track Fx Chain Ex.
-- Return a handle to the given track FX chain window. Set wantInputChain to get
-- the track's input/monitoring FX chain.
-- @param want_input_chain boolean
-- @return FxChain
function ReaProject:get_track_fx_chain_ex(want_input_chain)
    return r.CF_GetTrackFXChainEx(self.pointer, track, want_input_chain)
end

return ReaProject
