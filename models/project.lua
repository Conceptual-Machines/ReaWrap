local constants = require('ReaWrap.models.constants')
local helpers = require('ReaWrap.models.helpers')
local media_item = require('ReaWrap.models.item')
require('ReaWrap.models.reaper')
require('ReaWrap.models.take')
require('ReaWrap.models.track')

local r = reaper

Project = {pointer_type = PointerTypes.ReaProject}

---Create new Project instance.
function Project:new(o)
    --local rea_project, _ = Reaper:enum_projects()
    o = o or {
        active = 0,
        --rea_project = rea_project,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Project:_tostring()
    return string.format('<Project name=%s>', self:get_name())
end

function Project:log(...)
    logger = helpers.log_func('Project')
    logger(...)
end


----Get all selected tracks.
---@return table array<Track>
function Project:get_selected_tracks(master)
    master = master or false
    local tracks = {}
    local count = self:count_selected_tracks(master)
    for i = 0, count - 1 do
        local track = self:get_selected_track(i)
        tracks[i + 1] = track
    end
    return tracks
end

---Iterate over selected tracks
---@return function iterator
function Project:iter_selected_tracks(master)
    return helpers.iter((self:get_selected_tracks(master))
end

---Whether there is at least one selected track
---@return boolean
function Project:has_selected_tracks(master)
    return self:count_selected_tracks(master) > 0
end

---Add track to project ad return it.
----@param idx number
----@param defaults boolean
---@return table Track
function Project:add_track(idx, defaults)
    r.InsertTrackAtIndex(idx, defaults)
    return self:get_track(idx)
end

---Create new track from GUID.
----@param guid string
function Project:track_from_guid(guid)
    return self:get_media_track_by_guid(guid)
end

---Whether there are any selected media items
---@return number
function Project:has_selected_media_items()
    return self:count_selected_media_items() > 0
end

---Get all selected media items
---@return table array<MediaItem>
function Project:get_selected_media_items()
    local selected_media_items = {}
    for i = 0, self:count_selected_media_items() - 1 do
        local media_item = self:get_selected_media_item(i)
        selected_media_items[i + 1] = media_item
    end
    return selected_media_items
end

---Iterate over selected media items
---@return function iterator
function Project:iter_selected_media_items()
    return helpers.iter((self:get_selected_media_items())
end

---Get value by section and key from project state.
----@param section string
----@param key string
---@return string
function Project:get_key_value(section, key)
    return r.GetExtState(section, key)
end


---Set value by section and key into project state.
----@param section string
----@param key string
----@param value string
----@param persist boolean
function Project:set_key_value(section, key, value, persist)
    r.SetExtState(section, key, value, persist)
end

--Delete value by section and key into project state.
---@param section string
---@param key string
---@param persist boolean
function Project:del_key_value(section, key, persist)
    r.DeleteExtState(section, key, persist)
end

--Whether section and key value is stored in project state.
---@param section string
---@param key string
---@param persist boolean
function Project:has_key_value(section, key)
    return r.HasExtState(section, key)
end


---Wrapped ReaScript functions
--------------------------------------------------------------------------------

----Returns the index of the created marker/region, or -1 on failure. 
----Supply want_idx>=0 if you want a particular index number, 
----but you'll get a different index number a region and want_idx is already in use. 
----color should be 0 (default color), or ColorToNative(r,g,b)|0x1000000
---@param is_rgn boolean
---@param pos number
---@param rgn_end number
---@param name string
---@param want_idx number
---@param color number optional (default 0)
---@return number
function Project:add_project_marker(is_rgn, pos, rgn_end, name, want_idx, color)
    color = color or 0
    return r.AddProjectMarker2(self.pointer, is_rgn, pos, rgn_end, name, want_idx, color)
end

---Deprecated. Use SetTempoTimeSigMarker with pt_idx=-1.
---@param time_pos number
---@param bpm number
---@param timesig_num number
---@param timesig_denom number
---@param lineartempochange boolean
---@return boolean
function Project:add_tempo_time_sig_marker(time_pos, bpm, timesig_num, timesig_denom, lineartempochange)
    return r.AddTempoTimeSigMarker(self.pointer, time_pos, bpm, timesig_num, timesig_denom, lineartempochange)
end

---@return boolean
function Project:any_track_solo()
    return r.AnyTrackSolo(self.pointer)
end

---copies: in nudge duplicate mode, number of copies (otherwise ignored)
---@param nudgeflag number
---@param nudgewhat number
---@param nudgeunits number
---@param value number
---@param reverse boolean
---@param copies number
---@return boolean
function Project:apply_nudge(nudgeflag, nudgewhat, nudgeunits, value, reverse, copies)
    return r.ApplyNudge(self.pointer, nudgeflag, nudgewhat, nudgeunits, value, reverse, copies)
end

---[BR] Deprecated, see GetSet_ArrangeView2 (REAPER v5.12pre4+) ---Get start and end time position of arrange view. To set arrange view instead, see BR_SetArrangeView.
---@return number, number
function Project:get_arrange_view()
    return r.BR_GetArrangeView(self.pointer)
end

---[BR] Get media item from GUID string. Note that the GUID must be enclosed in braces {}. To get item's GUID as a string, see BR_GetMediaItemGUID.
---@param guid string
---@return table object MediaItem
function Project:get_media_item_by_guid(guid)
    local mi = r.BR_GetMediaItemByGUID(self.active, guid)
    return media_item.MediaItem:new(mi)
end

----[BR] Get Track from GUID string. 
----Note that the GUID must be enclosed in braces {}.
---@param guid string
---@return table Track
function Project:get_media_track_by_guid(guid)
    local mt = r.BR_GetMediaTrackByGUID(self.active, guid)
    return Track:new(mt)
end

---[BR] Deprecated, see GetSet_ArrangeView2 (REAPER v5.12pre4+) ---Set start and end time position of arrange view. To get arrange view instead, see BR_GetArrangeView.
---@param start_time number
---@param end_time number
function Project:set_arrange_view(start_time, end_time)
    return r.BR_SetArrangeView(self.pointer, start_time, end_time)
end

---count the number of items in the project (proj=0 for active project)
---@return number
function Project:count_media_items()
    return r.CountMediaItems(self.pointer)
end

---num_markersOut and num_regionsOut may be NULL.
---@return number, number
function Project:count_project_markers()
    local retval, num_markers, num_regions = r.CountProjectMarkers(self.pointer)
    if retval then
        return num_markers, num_regions
    end
end

---count the number of selected items in the project (proj=0 for active project)
---@return number
function Project:count_selected_media_items()
    return r.CountSelectedMediaItems(self.active)
end


---Count the number of selected tracks in the project
---@param master boolean optional
---@return number
function Project:count_selected_tracks(master)
    master = master or false
    return r.CountSelectedTracks2(self.active, master)
end

---Count the number of FX parameter knobs displayed on the track control panel.
---@param track table Track
---@return number
function Project:count_tcp_fx_params(track)
    return r.CountTCPFXParms(self.active, track.pointer)
end

---Count the number of tempo/time signature markers in the project. See GetTempoTimeSigMarker, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@return number
function Project:count_tempo_time_sig_markers()
    return r.CountTempoTimeSigMarkers(self.active)
end

---count the number of tracks in the project (proj=0 for active project)
---@return number
function Project:count_tracks()
    return r.CountTracks(self.pointer)
end

---Delete a marker.  proj==NULL for the active project.
---@param marker_idx number
---@param is_rgn boolean
---@return boolean
function Project:delete_project_marker(marker_idx, is_rgn)
    return r.DeleteProjectMarker(self.pointer, marker_idx, is_rgn)
end

---Differs from DeleteProjectMarker only in that marker_idx is 0 for the first marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than representing the displayed marker/region ID number (see SetProjectMarker4).
---@param marker_idx number
---@return boolean
function Project:delete_project_marker_by_index(marker_idx)
    return r.DeleteProjectMarkerByIndex(self.pointer, marker_idx)
end

---Delete a tempo/time signature marker.
---@param marker_idx number
---@return boolean
function Project:delete_tempo_time_sig_marker(marker_idx)
    return r.DeleteTempoTimeSigMarker(self.pointer, marker_idx)
end

---Open the tempo/time signature marker editor dialog.
---@param marker_idx number
---@return boolean
function Project:edit_tempo_time_sig_marker(marker_idx)
    return r.EditTempoTimeSigMarker(self.pointer, marker_idx)
end

---Enumerate the data stored with the project for a specific extname. Returns false when there is no more data. See SetProjExtState, GetProjExtState.
---@param extname string
---@param idx number
---@return string, string
function Project:enum_proj_ext_state(extname, idx)
    local retval, key, val = r.EnumProjExtState(self.active, extname, idx)
    if retval then
        return key, val
    end
end

---@param idx number
---@return boolean, number, number, string, number
function Project:enum_project_markers2(idx)
    local retval, is_rgn, pos, rgn_end, name, marker_idx = r.EnumProjectMarkers2(self.active, idx)
    if retval then
        return is_rgn, pos, rgn_end, name, marker_idx
    end
end

---@param idx number
---@return boolean, number, number, string, number, number
function Project:enum_project_markers3(idx)
    local retval, is_rgn, pos, rgn_end, name, marker_idx, color = r.EnumProjectMarkers3(self.pointer, idx)
    if retval then
        return is_rgn, pos, rgn_end, name, marker_idx, color
    end
end

---Enumerate which tracks will be rendered within this region when using the region render matrix. 
---When called with render_track==0, the function returns the first track that will be rendered (which may be the master track); 
---render_track==1 will return the next track rendered, and so on. The function returns NULL when there are no more tracks that will be rendered within this region.
---@param region_idx number
---@param render_track number
---@return table|nil object Track 
function Project:enum_region_render_matrix(region_idx, render_track)
    local mt = r.EnumRegionRenderMatrix(self.active, region_idx, render_track)
    if mt ~= nil then
        return Track:new(mt)
    end
end

---returns false if there are no plugins on the track that support MIDI programs,or if all programs have been enumerated
---@param track table Track
---@param program_number number
---@return string
function Project:enum_track_midi_program_names_ex(track, program_number)
    local retval, program_name_ = r.EnumTrackMIDIProgramNamesEx(
            self.active, track.pointer, program_number, '')
    if retval then
        return program_name_
    end
end

---Find the tempo/time signature marker that falls at or before this time position (
---the marker that is in effect as of this time position).
---@param time number
---@return number
function Project:find_tempo_time_sig_marker(time)
    return r.FindTempoTimeSigMarker(self.active, time)
end

---Returns the bitwise OR of all project play states (1=playing, 2=pause, 4=recording)
---@return number
function Project:get_all_project_play_states()
    return r.GetAllProjectPlayStates(self.active)
end

---edit cursor position
---@return number
function Project:get_cursor_position_ex()
    return r.GetCursorPositionEx(self.active)
end

---Returns free disk space in megabytes, pathIdx 0 for normal, 1 for alternate.
---@param pathidx number
---@return number
function Project:get_free_disk_space_for_record_path(pathidx)
    return r.GetFreeDiskSpaceForRecordPath(self.active, pathidx)
end

---Get the last project marker before time, and/or the project region that includes time. markeridx and regionidx are returned not necessarily as the displayed marker/region index, but as the index that can be passed to EnumProjectMarkers. Either or both of markeridx and regionidx may be NULL. See EnumProjectMarkers.
---@param time number
---@return number, number
function Project:get_last_marker_and_cur_region(time)
    return r.GetLastMarkerAndCurRegion(self.active, time)
end

---@return table Track
function Project:get_master_track()
    return r.GetMasterTrack(self.active)
end

---get an item from a project by item count (zero-based) (proj=0 for active project)
---@param item_idx number
---@return table MediaItem
function Project:get_media_item(item_idx)
    local mt = r.GetMediaItem(self.active, item_idx)
    return media_item.MediaItemnew(mt)
end

---@param guid string
---@return table Take
function Project:get_media_item_take_by_guid(guid)
    local take = r.GetMediaItemTakeByGUID(self.active, guid)
    return Take:new(take)
end

---Returns position of next audio block being processed
---@return number
function Project:get_play_position2_ex()
    return r.GetPlayPosition2Ex(self.active)
end

---Returns latency-compensated actual-what-you-hear position
---@return number
function Project:get_play_position_ex()
    return r.GetPlayPositionEx(self.active)
end

---&1=playing,&2=pause,&=4 is recording
---@return number
function Project:get_play_state_ex()
    return r.GetPlayStateEx(self.active)
end

---Get the value previously associated with this extname and key, the last time the project was saved. See SetProjExtState, EnumProjExtState.
---@param extname string
---@param key string
---@return string
function Project:get_proj_ext_state(extname, key)
    local retval, val = r.GetProjExtState(self.active, extname, key)
    if retval then
        return val
    end
end

---Returns length of project (maximum of end of media item, markers, end of regions, tempo map
---@return number
function Project:get_project_length()
    return r.GetProjectLength(self.active)
end

---@param buf string optional
---@return string
function Project:get_name(buf)
    buf = buf or ''
    return r.GetProjectName(self.active, buf)
end

---Get the project recording path.
---@param buf string optional
---@return string
function Project:get_path_ex(buf)
    buf = buf or ''
    return r.GetProjectPathEx(self.active, buf)
end

---Returns an number that changes when the project state changes
---@return number
function Project:get_state_change_count()
    return r.GetProjectStateChangeCount(self.active)
end

---Gets project time offset in seconds (project settings - project start time). 
---If rndframe is true, the offset is rounded to a multiple of the project frame size.
---@param rndframe boolean
---@return number
function Project:get_time_offset(rndframe)
    return r.GetProjectTimeOffset(self.active, rndframe)
end

---this does not reflect tempo envelopes but is purely what is set in the project settings.
---@return number, number
function Project:get_time_signature2()
    return r.GetProjectTimeSignature2(self.active)
end

---get the currently selected envelope, returns NULL/nil if no envelope is selected
---@return table Envelope
function Project:get_selected_envelope()
    return Envelope:new(r.GetSelectedEnvelope(self.active))
end

---get a selected item by selected item count (zero-based)
---@param item_idx number
---@return table MediaItem
function Project:get_selected_media_item(item_idx)
    local sel_item = r.GetSelectedMediaItem(self.active, item_idx)
    return media_item.MediaItem:new(sel_item)
end


---Get a selected track from a project by selected track count (zero-based).
---@param track_idx number
---@param want_master boolean optional (default false)
---@return table Track
function Project:get_selected_track(track_idx, want_master)
    want_master = want_master or false
    local mt = r.GetSelectedTrack2(self.active, track_idx, want_master)
    return Track:new(mt)
end

---get the currently selected track envelope, returns NULL/nil if no envelope is selected
---@return table TrackEnvelope
function Project:get_selected_track_envelope()
    return Envelope:new(r.GetSelectedTrackEnvelope(self.active))
end

---Gets or sets the arrange view start/end time for screen coordinates. use screen_x_start=screen_x_end=0 to use the full arrange view's start/end time
---@param is_set boolean
---@param screen_x_start number
---@param screen_x_end number
---@return number, number
function Project:get_set__arrange_view2(is_set, screen_x_start, screen_x_end)
    return r.GetSet_ArrangeView2(self.active, is_set, screen_x_start, screen_x_end)
end

---@param is_set boolean
---@param is_loop boolean
---@param start number
---@param end_ number
---@param allowautoseek boolean
---@return number, number
function Project:get_set__loop_time_range2(is_set, is_loop, start, end_, allowautoseek)
    return r.GetSet_LoopTimeRange2(self.active, is_set, is_loop, start, end_, allowautoseek)
end

---gets or sets project author, author_sz is ignored when setting
---@param set boolean
---@param author string
---@return string
function Project:get_set_project_author(set, author)
    return r.GetSetProjectAuthor(self.active, set, author)
end

---Get or set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note triplet, etc. swingmode can be 1 for swing enabled, swingamt is -1..1. swingmode can be 3 for measure-grid. Returns grid configuration flags
---@param set boolean
---@param division number
---@param swingmode number
---@param swingamt number
---@return number, number, number
function Project:get_set_project_grid(set, division, swingmode, swingamt)
    local retval, division_, swingmode_, swingamt_ = r.GetSetProjectGrid(self.active, set, division, swingmode, swingamt)
    if retval then
        return division_, swingmode_, swingamt_
    end
end

---@param desc string
---@param value number
---@param is_set boolean
---@return number
function Project:get_set_project_info(desc, value, is_set)
    return r.GetSetProjectInfo(self.active, desc, value, is_set)
end

---    "wave" "aiff" "iso " "ddp " "flac" "mp3l" "oggv" "OggS" "FFMP" "GIF " "LCF " "wvpk"
---@param desc string
---@param valuestr_need_big string
---@param is_set boolean
---@return string
function Project:get_set_project_info__string(desc, valuestr_need_big, is_set)
    local retval, valuestr_need_big_ = r.GetSetProjectInfo_String(self.active, desc, valuestr_need_big, is_set)
    if retval then
        return valuestr_need_big_
    end
end

---gets or sets project notes, notesNeedBig_sz is ignored when setting
---@param set boolean
---@param notes string
---@return string
function Project:get_set_project_notes(set, notes)
    return r.GetSetProjectNotes(self.active, set, notes)
end

----1 == query,0=clear,1=set,>1=toggle . returns new value
---@param val number
---@return number
function Project:get_set_repeat_ex(val)
    return r.GetSetRepeatEx(self.active, val)
end

---Get information about a specific FX parameter knob (see CountTCPFXParms).
---@param track table Track
---@param index number
---@return number, number
function Project:get_tcp_fx_param(track, index)
    local retval, fx_idx parm_idx = r.GetTCPFXParm(self.active, track.pointer, index)
    if retval then
        return fx_idx, parm_idx
    end
end

---Get information about a tempo/time signature marker. See CountTempoTimeSigMarkers, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@param pt_idx number
---@return number, number, number, number, number, number, boolean
function Project:get_tempo_time_sig_marker(pt_idx)
    local retval, time_pos, measure_pos, beat_pos, bpm, timesig_num, timesig_denom, lineartempo = r.GetTempoTimeSigMarker(self.active, pt_idx)
    if retval then
        return time_pos, measure_pos, beat_pos, bpm, timesig_num, timesig_denom, lineartempo
    end
end

---get a track from a project by track count (zero-based) (proj=0 for active project)
---@param track_idx number
---@return table Track
function Project:get_track(track_idx)
    local t = r.GetTrack(self.active, track_idx)
    return Track:new(t)
end

---Get note/CC name. pitch 128 for CC0 name, 129 for CC1 name, etc. See SetTrackMIDINoteNameEx
---@param track table Track
---@param pitch number
---@param chan number
---@return string
function Project:get_track_midi_note_name_ex(track, pitch, chan)
    return r.GetTrackMIDINoteNameEx(self.active, track.pointer, pitch, chan)
end

---@param track table Track
---@return number, number
function Project:get_track_midi_note_range(track)
    return r.GetTrackMIDINoteRange(self.active, track.pointer)
end

---Go to marker. If use_timeline_order==true, marker_index 1 refers to the first marker on the timeline.  
---If use_timeline_order==false, marker_index 1 refers to the first marker with the user-editable index of 1.
---@param marker_index number
---@param use_timeline_order boolean
function Project:go_to_marker(marker_index, use_timeline_order)
    return r.GoToMarker(self.active, marker_index, use_timeline_order)
end

---Seek to region after current region finishes playing (smooth seek). 
---If use_timeline_order==true, region_index 1 refers to the first region on the timeline.  
---If use_timeline_order==false, region_index 1 refers to the first region with the user-editable index of 1.
---@param region_index number
---@param use_timeline_order boolean
function Project:go_to_region(region_index, use_timeline_order)
    return r.GoToRegion(self.active, region_index, use_timeline_order)
end

---Returns name of track plugin that is supplying MIDI programs,or NULL if there is none
---@param track table Track
---@return string
function Project:has_track_midi_programs_ex(track)
    return r.HasTrackMIDIProgramsEx(self.active, track.pointer)
end

---Is the project dirty (needing save)? Always returns 0 if 'undo/prompt to save' is disabled in preferences.
---@return number
function Project:is_project_dirty()
    return r.IsProjectDirty(self.active)
end

---Move the loop selection left or right. Returns true if snap is enabled.
---@param direction number
---@return boolean
function Project:loop__on_arrow(direction)
    return r.Loop_OnArrow(self.active, direction)
end

---Save the project.
---@param force_save_as_in boolean
function Project:main__save_project(force_save_as_in)
    return r.Main_SaveProject(self.active, force_save_as_in)
end

---Marks project as dirty (needing save) if 'undo/prompt to save' is enabled in preferences.
function Project:mark_project_dirty()
    return r.MarkProjectDirty(self.active)
end

---@return number
function Project:master__get_play_rate()
    return r.Master_GetPlayRate(self.active)
end

---direct way to simulate pause button hit
function Project:on_pause_button_ex()
    return r.OnPauseButtonEx(self.active)
end

---direct way to simulate play button hit
function Project:on_play_button_ex()
    return r.OnPlayButtonEx(self.active)
end

---direct way to simulate stop button hit
function Project:on_stop_button_ex()
    return r.OnStopButtonEx(self.active)
end

---[S&M] Gets a take by GUID as string. The GUID must be enclosed in braces {}. To get take GUID as string, see BR_GetMediaItemTakeGUID
---@param guid string
---@return table Take
function Project:get_media_item_take_by_guid(guid)
    local take r.SNM_GetMediaItemTakeByGUID(self.active, guid)
    return Take:new(take)
end

---[S&M] Gets a marker/region name. Returns true if marker/region found.
---@param num number
---@param is_rgn boolean
---@param name string WDL_FastString
---@return boolean
function Project:get_project_marker_name(num, is_rgn, name)
    return r.SNM_GetProjectMarkerName(self.active, num, is_rgn, name)
end

---[S&M] Deprecated, see SetProjectMarker4 ---Same function as SetProjectMarker3() except it can set empty names "".
---@param num number
---@param is_rgn boolean
---@param pos number
---@param rgn_end number
---@param name string
---@param color number
---@return boolean
function Project:set_project_marker(num, is_rgn, pos, rgn_end, name, color)
    return r.SNM_SetProjectMarker(self.active, num, is_rgn, pos, rgn_end, name, color)
end

---@param selected boolean
function Project:select_all_media_items(selected)
    return r.SelectAllMediaItems(self.active, selected)
end

function Project:select_project_instance()
    return r.SelectProjectInstance(self.active)
end

---set current BPM in project, set wantUndo=true to add undo point
---@param bpm number
---@param want_undo boolean
function Project:set_current_b_p_m(bpm, want_undo)
    return r.SetCurrentBPM(self.active, bpm, want_undo)
end

---@param time number
---@param moveview boolean
---@param seekplay boolean
function Project:set_edit_cur_pos2(time, moveview, seekplay)
    return r.SetEditCurPos2(self.active, time, moveview, seekplay)
end

---Set the MIDI editor grid division. 0.25=quarter note, 1.0/3.0=half note tripet, etc.
---@param division number
function Project:set_midi_editor_grid(division)
    return r.SetMIDIEditorGrid(self.active, division)
end

---Save a key/value pair for a specific extension, to be restored the next time this specific project is loaded. Typically extname will be the name of a reascript or extension section. If key is NULL or "", all extended data for that extname will be deleted.  If val is NULL or "", the data previously associated with that key will be deleted. Returns the size of the state for this extname. See GetProjExtState, EnumProjExtState.
---@param extname string
---@param key string
---@param value string
---@return number
function Project:set_proj_ext_state(extname, key, value)
    return r.SetProjExtState(self.active, extname, key, value)
end

---Set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note triplet, etc.
---@param division number
function Project:set_project_grid(division)
    return r.SetProjectGrid(self.active, division)
end

---@param marker_idx number
---@param is_rgn boolean
---@param pos number
---@param rgn_end number
---@param name string
---@return boolean
function Project:set_project_marker2(marker_idx, is_rgn, pos, rgn_end, name)
    return r.SetProjectMarker2(self.active, marker_idx, is_rgn, pos, rgn_end, name)
end

---@param marker_idx number
---@param is_rgn boolean
---@param pos number
---@param rgn_end number
---@param name string
---@param color number
---@return boolean
function Project:set_project_marker3(marker_idx, is_rgn, pos, rgn_end, name, color)
    return r.SetProjectMarker3(self.active, marker_idx, is_rgn, pos, rgn_end, name, color)
end

---color should be 0 to not change, or ColorToNative(r,g,b)|0x1000000, flags&1 to clear name
---@param marker_idx number
---@param is_rgn boolean
---@param pos number
---@param rgn_end number
---@param name string
---@param color number
---@param flags number
---@return boolean
function Project:set_project_marker4(marker_idx, is_rgn, pos, rgn_end, name, color, flags)
    return r.SetProjectMarker4(self.active, marker_idx, is_rgn, pos, rgn_end, name, color, flags)
end

---See SetProjectMarkerByIndex2.
---@param marker_idx number
---@param is_rgn boolean
---@param pos number
---@param rgn_end number
---@param i_dnumber number
---@param name string
---@param color number
---@return boolean
function Project:set_project_marker_by_index(marker_idx, is_rgn, pos, rgn_end, i_dnumber, name, color)
    return r.SetProjectMarkerByIndex(self.active, marker_idx, is_rgn, pos, rgn_end, i_dnumber, name, color)
end

---Differs from SetProjectMarker4 in that marker_idx is 0 for the first marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than representing the displayed marker/region ID number (see SetProjectMarker3). Function will fail if attempting to set a duplicate ID number for a region (duplicate ID numbers for markers are OK). , flags&1 to clear name.
---@param marker_idx number
---@param is_rgn boolean
---@param pos number
---@param rgn_end number
---@param i_dnumber number
---@param name string
---@param color number
---@param flags number
---@return boolean
function Project:set_project_marker_by_index2(marker_idx, is_rgn, pos, rgn_end, i_dnumber, name, color, flags)
    return r.SetProjectMarkerByIndex2(self.active, marker_idx, is_rgn, pos, rgn_end, i_dnumber, name, color, flags)
end

---Add (addorremove > 0) or remove (addorremove < 0) a track from this region when using the region render matrix.
---@param region_idx number
---@param track table Track
---@param add_or_remove number
function Project:set_region_render_matrix(region_idx, track, add_or_remove)
    return r.SetRegionRenderMatrix(self.active, region_idx, track.pointer, add_or_remove)
end

---Set parameters of a tempo/time signature marker. Provide either time_pos (with measure_pos=-1, beat_pos=-1), or measure_pos and beat_pos (with time_pos=-1). If timesig_num and timesig_denom are zero, the previous time signature will be used. pt_idx=-1 will insert a new tempo/time signature marker. See CountTempoTimeSigMarkers, GetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@param pt_idx number
---@param time_pos number
---@param measure_pos number
---@param beat_pos number
---@param bpm number
---@param timesig_num number
---@param timesig_denom number
---@param lineartempo boolean
---@return boolean
function Project:set_tempo_time_sig_marker(pt_idx, time_pos, measure_pos, beat_pos, bpm, timesig_num, timesig_denom, lineartempo)
    return r.SetTempoTimeSigMarker(self.active, pt_idx, time_pos, measure_pos, beat_pos, bpm, timesig_num, timesig_denom, lineartempo)
end

---channel < 0 assigns note name to all channels. pitch 128 assigns name for CC0, pitch 129 for CC1, etc.
---@param track table Track
---@param pitch number
---@param chan number
---@param name string
---@return boolean
function Project:set_track_midi_note_name_ex(track, pitch, chan, name)
    return r.SetTrackMIDINoteNameEx(self.active, track.pointer, pitch, chan, name)
end

---@param time_pos number
---@return number
function Project:snap_to_grid(time_pos)
    return r.SnapToGrid(self.active, time_pos)
end

---get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
---@param time number
---@return number
function Project:get_divided_bpm_at_time(time)
    return r.TimeMap2_GetDividedBpmAtTime(self.active, time)
end

---when does the next time map (tempo or time sig) change occur
---@param time number
---@return number
function Project:get_next_change_time(time)
    return r.TimeMap2_GetNextChangeTime(self.active, time)
end

---converts project QN position to time.
---@param qn number
---@return number
function Project:qn_to_time(qn)
    return r.TimeMap2_QNToTime(self.active, qn)
end

---convert a beat position (or optionally a beats+measures if measures is non-NULL) to time.
---@param tpos number
---@param measures_in number
---@return number
function Project:beats_to_time(tpos, measures_in)
    return r.TimeMap2_beatsToTime(self.active, tpos, measures_in)
end

---if cdenom is non-NULL, will be set to the current time signature denominator.
---@param tpos number
---@return number, number, number, number
function Project:time_to_beats(tpos)
    local retval, measures, cml, fullbeats, cdenom = r.TimeMap2_timeToBeats(self.active, tpos)
    if retval then
        return measures, cml, fullbeats, cdenom
    end
end

---converts project time position to QN position.
---@param tpos number
---@return number
function Project:time_to_q_n(tpos)
    return r.TimeMap2_timeToQN(self.active, tpos)
end

---Get the QN position and time signature information for the start of a measure. Return the time in seconds of the measure start.
---@param measure number
---@return number, number, number, number, number
function Project:time_map__get_measure_info(measure)
    local retval, qn_start, qn_end, timesig_num, timesig_denom, tempo = r.TimeMap_GetMeasureInfo(self.active, measure)
    if retval then
        return qn_start, qn_end, timesig_num, timesig_denom, tempo
    end
end

---Fills in a string representing the active metronome pattern. For example, in a 7/8 measure divided 3+4, the pattern might be "1221222".
---The length of the string is the time signature numerator, and the function returns the time signature denominator.
---@param time number
---@param pattern string
---@return string
function Project:time_map__get_metronome_pattern(time, pattern)
    local retval, pattern_ = r.TimeMap_GetMetronomePattern(self.active, time, pattern)
    if retval then
        return pattern_
    end
end

---get the effective time signature and tempo
---@param time number
---@return number, number, number
function Project:time_map__get_time_sig_at_time(time)
    return r.TimeMap_GetTimeSigAtTime(self.active, time)
end

---Find which measure the given QN position falls in.
---@param qn number
---@return number, number
function Project:time_map__q_n_to_measures(qn)
    local retval, qn_measure_start, qn_measure_end = r.TimeMap_QNToMeasures(self.active, qn)
    if retval then
        return qn_measure_start, qn_measure_end
    end
end

---Converts project quarter note count (QN) to time. QN is counted from the start of the project, regardless of any partial measures. See TimeMap2_QNToTime
---@param qn number
---@return number
function Project:time_map__q_n_to_time_abs(qn)
    return r.TimeMap_QNToTime_abs(self.active, qn)
end

---Gets project framerate, and optionally whether it is drop-frame timecode
---@return boolean
function Project:time_map_cur_frame_rate()
    local retval, drop_frame = r.TimeMap_curFrameRate(self.active)
    if retval then
        return drop_frame
    end
end

---Converts project time position to quarter note count (QN). QN is counted from the start of the project, regardless of any partial measures. See TimeMap2_timeToQN
---@param tpos number
---@return number
function Project:time_map_time_to_q_n_abs(tpos)
    return r.TimeMap_timeToQN_abs(self.active, tpos)
end

---call to start a new block
function Project:undo__begin_block2()
    return r.Undo_BeginBlock2(self.active)
end

---Returns string of next action,if able,NULL if not
---@return string
function Project:undo__can_redo2()
    return r.Undo_CanRedo2(self.active)
end

---Returns string of last action,if able,NULL if not
---@return string
function Project:undo__can_undo2()
    return r.Undo_CanUndo2(self.active)
end

---nonzero if success
---@return number
function Project:undo__do_redo2()
    return r.Undo_DoRedo2(self.active)
end

---nonzero if success
---@return number
function Project:undo__do_undo2()
    return r.Undo_DoUndo2(self.active)
end

---call to end the block,with extra flags if any,and a description
---@param desc_change string
---@param extraflags number
function Project:undo__end_block2(desc_change, extraflags)
    return r.Undo_EndBlock2(self.active, desc_change, extraflags)
end

---limited state change to items
---@param desc_change string
function Project:undo__on_state_change2(desc_change)
    return r.Undo_OnStateChange2(self.active, desc_change)
end

---@param name string
---@param item table MediaItem
function Project:undo__on_state_change__item(name, item)
    return r.Undo_OnStateChange_Item(self.active, name, item.pointer)
end

---track_param=-1 by default,or if updating one fx chain,you can specify track index
---@param desc_change string
---@param which_states number
---@param track_param number
function Project:undo__on_state_change_ex2(desc_change, which_states, track_param)
    return r.Undo_OnStateChangeEx2(self.active, desc_change, which_states, track_param)
end

---Return true if the pointer is a valid object of the right type in proj (proj is ignored if pointer is itself a project).
---@return boolean
function Project:is_valid()
    return r.ValidatePtr2(self.active, Reaper.Types.ReaProject)
end

