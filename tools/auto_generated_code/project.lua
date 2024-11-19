-- Returns the index of the created marker/region, or -1 on failure. Supply wantidx>=0 if you want a particular index number, but you'll get a different index number a region and wantidx is already in use.
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param wantidx number
---@return number 
function Project:add_project_marker(isrgn, pos, rgnend, name, wantidx)
    return r.AddProjectMarker(self.pointer, isrgn, pos, rgnend, name, wantidx)
end

-- Returns the index of the created marker/region, or -1 on failure. Supply wantidx>=0 if you want a particular index number, but you'll get a different index number a region and wantidx is already in use. color should be 0 (default color), or ColorToNative(r,g,b)|0x1000000
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param wantidx number
---@param color number
---@return number 
function Project:add_project_marker2(isrgn, pos, rgnend, name, wantidx, color)
    return r.AddProjectMarker2(self.pointer, isrgn, pos, rgnend, name, wantidx, color)
end

-- Deprecated. Use SetTempoTimeSigMarker with ptidx=-1.
---@param timepos number
---@param bpm number
---@param timesig_num number
---@param timesig_denom number
---@param lineartempochange boolean
---@return boolean 
function Project:add_tempo_time_sig_marker(timepos, bpm, timesig_num, timesig_denom, lineartempochange)
    return r.AddTempoTimeSigMarker(self.pointer, timepos, bpm, timesig_num, timesig_denom, lineartempochange)
end

---@return boolean 
function Project:any_track_solo()
    return r.AnyTrackSolo(self.pointer)
end

-- copies: in nudge duplicate mode, number of copies (otherwise ignored)
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

-- [BR] Deprecated, see GetSet_ArrangeView2 (REAPER v5.12pre4+) -- Get start and end time position of arrange view. To set arrange view instead, see BR_SetArrangeView.
---@return number, number 
function Project:b_r__get_arrange_view()
    return r.BR_GetArrangeView(self.pointer)
end

-- [BR] Get media item from GUID string. Note that the GUID must be enclosed in braces {}. To get item's GUID as a string, see BR_GetMediaItemGUID.
---@param guid_string_in string
---@return MediaItem 
function Project:b_r__get_media_item_by_g_u_i_d(guid_string_in)
    return r.BR_GetMediaItemByGUID(self.pointer, guid_string_in)
end

-- [BR] Get media track from GUID string. Note that the GUID must be enclosed in braces {}. To get track's GUID as a string, see GetSetMediaTrackInfo_String.
---@param guid_string_in string
---@return MediaTrack 
function Project:b_r__get_media_track_by_g_u_i_d(guid_string_in)
    return r.BR_GetMediaTrackByGUID(self.pointer, guid_string_in)
end

-- [BR] Deprecated, see GetSet_ArrangeView2 (REAPER v5.12pre4+) -- Set start and end time position of arrange view. To get arrange view instead, see BR_GetArrangeView.
---@param start_time number
---@param end_time number
function Project:b_r__set_arrange_view(start_time, end_time)
    return r.BR_SetArrangeView(self.pointer, start_time, end_time)
end

-- count the number of items in the project (proj=0 for active project)
---@return number 
function Project:count_media_items()
    return r.CountMediaItems(self.pointer)
end

-- num_markersOut and num_regionsOut may be NULL.
---@return number, number 
function Project:count_project_markers()
    local retval, num_markers, num_regions = r.CountProjectMarkers(self.pointer)
    if retval then
        return num_markers, num_regions
    end
end

-- count the number of selected items in the project (proj=0 for active project)
---@return number 
function Project:count_selected_media_items()
    return r.CountSelectedMediaItems(self.pointer)
end

-- Count the number of selected tracks in the project (proj=0 for active project). This function ignores the master track, see CountSelectedTracks2.
---@return number 
function Project:count_selected_tracks()
    return r.CountSelectedTracks(self.pointer)
end

-- Count the number of selected tracks in the project (proj=0 for active project).
---@param wantmaster boolean
---@return number 
function Project:count_selected_tracks2(wantmaster)
    return r.CountSelectedTracks2(self.pointer, wantmaster)
end

-- Count the number of FX parameter knobs displayed on the track control panel.
---@param track MediaTrack
---@return number 
function Project:count_t_c_p_f_x_parms(track)
    return r.CountTCPFXParms(self.pointer, track)
end

-- Count the number of tempo/time signature markers in the project. See GetTempoTimeSigMarker, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@return number 
function Project:count_tempo_time_sig_markers()
    return r.CountTempoTimeSigMarkers(self.pointer)
end

-- count the number of tracks in the project (proj=0 for active project)
---@return number 
function Project:count_tracks()
    return r.CountTracks(self.pointer)
end

-- Delete a marker.  proj==NULL for the active project.
---@param markrgnindexnumber number
---@param isrgn boolean
---@return boolean 
function Project:delete_project_marker(markrgnindexnumber, isrgn)
    return r.DeleteProjectMarker(self.pointer, markrgnindexnumber, isrgn)
end

-- Differs from DeleteProjectMarker only in that markrgnidx is 0 for the first marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than representing the displayed marker/region ID number (see SetProjectMarker4).
---@param markrgnidx number
---@return boolean 
function Project:delete_project_marker_by_index(markrgnidx)
    return r.DeleteProjectMarkerByIndex(self.pointer, markrgnidx)
end

-- Delete a tempo/time signature marker.
---@param markerindex number
---@return boolean 
function Project:delete_tempo_time_sig_marker(markerindex)
    return r.DeleteTempoTimeSigMarker(self.pointer, markerindex)
end

-- Open the tempo/time signature marker editor dialog.
---@param markerindex number
---@return boolean 
function Project:edit_tempo_time_sig_marker(markerindex)
    return r.EditTempoTimeSigMarker(self.pointer, markerindex)
end

-- Enumerate the data stored with the project for a specific extname. Returns false when there is no more data. See SetProjExtState, GetProjExtState.
---@param extname string
---@param idx number
---@return string, string 
function Project:enum_proj_ext_state(extname, idx)
    local retval, key, val = r.EnumProjExtState(self.pointer, extname, idx)
    if retval then
        return key, val
    end
end

---@param idx number
---@return boolean, number, number, string, number 
function Project:enum_project_markers2(idx)
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = r.EnumProjectMarkers2(self.pointer, idx)
    if retval then
        return isrgn, pos, rgnend, name, markrgnindexnumber
    end
end

---@param idx number
---@return boolean, number, number, string, number, number 
function Project:enum_project_markers3(idx)
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = r.EnumProjectMarkers3(self.pointer, idx)
    if retval then
        return isrgn, pos, rgnend, name, markrgnindexnumber, color
    end
end

-- Enumerate which tracks will be rendered within this region when using the region render matrix. When called with rendertrack==0, the function returns the first track that will be rendered (which may be the master track); rendertrack==1 will return the next track rendered, and so on. The function returns NULL when there are no more tracks that will be rendered within this region.
---@param regionindex number
---@param rendertrack number
---@return MediaTrack 
function Project:enum_region_render_matrix(regionindex, rendertrack)
    return r.EnumRegionRenderMatrix(self.pointer, regionindex, rendertrack)
end

-- returns false if there are no plugins on the track that support MIDI programs,or if all programs have been enumerated
---@param track MediaTrack
---@param program_number number
---@param program_name string
---@return string 
function Project:enum_track_m_i_d_i_program_names_ex(track, program_number, program_name)
    local retval, program_name_ = r.EnumTrackMIDIProgramNamesEx(self.pointer, track, program_number, program_name)
    if retval then
        return program_name_
    end
end

-- Find the tempo/time signature marker that falls at or before this time position (the marker that is in effect as of this time position).
---@param time number
---@return number 
function Project:find_tempo_time_sig_marker(time)
    return r.FindTempoTimeSigMarker(self.pointer, time)
end

-- returns the bitwise OR of all project play states (1=playing, 2=pause, 4=recording)
---@return number 
function Project:get_all_project_play_states()
    return r.GetAllProjectPlayStates(self.pointer)
end

-- edit cursor position
---@return number 
function Project:get_cursor_position_ex()
    return r.GetCursorPositionEx(self.pointer)
end

-- returns free disk space in megabytes, pathIdx 0 for normal, 1 for alternate.
---@param pathidx number
---@return number 
function Project:get_free_disk_space_for_record_path(pathidx)
    return r.GetFreeDiskSpaceForRecordPath(self.pointer, pathidx)
end

-- Get the last project marker before time, and/or the project region that includes time. markeridx and regionidx are returned not necessarily as the displayed marker/region index, but as the index that can be passed to EnumProjectMarkers. Either or both of markeridx and regionidx may be NULL. See EnumProjectMarkers.
---@param time number
---@return number, number 
function Project:get_last_marker_and_cur_region(time)
    return r.GetLastMarkerAndCurRegion(self.pointer, time)
end

---@return MediaTrack 
function Project:get_master_track()
    return r.GetMasterTrack(self.pointer)
end

-- get an item from a project by item count (zero-based) (proj=0 for active project)
---@param itemidx number
---@return MediaItem 
function Project:get_media_item(itemidx)
    return r.GetMediaItem(self.pointer, itemidx)
end

---@param guid_g_u_i_d string
---@return MediaItem_Take 
function Project:get_media_item_take_by_g_u_i_d(guid_g_u_i_d)
    return r.GetMediaItemTakeByGUID(self.pointer, guid_g_u_i_d)
end

-- returns position of next audio block being processed
---@return number 
function Project:get_play_position2_ex()
    return r.GetPlayPosition2Ex(self.pointer)
end

-- returns latency-compensated actual-what-you-hear position
---@return number 
function Project:get_play_position_ex()
    return r.GetPlayPositionEx(self.pointer)
end

-- &1=playing,&2=pause,&=4 is recording
---@return number 
function Project:get_play_state_ex()
    return r.GetPlayStateEx(self.pointer)
end

-- Get the value previously associated with this extname and key, the last time the project was saved. See SetProjExtState, EnumProjExtState.
---@param extname string
---@param key string
---@return string 
function Project:get_proj_ext_state(extname, key)
    local retval, val = r.GetProjExtState(self.pointer, extname, key)
    if retval then
        return val
    end
end

-- returns length of project (maximum of end of media item, markers, end of regions, tempo map
---@return number 
function Project:get_project_length()
    return r.GetProjectLength(self.pointer)
end

---@param buf string
---@return string 
function Project:get_project_name(buf)
    return r.GetProjectName(self.pointer, buf)
end

-- Get the project recording path.
---@param buf string
---@return string 
function Project:get_project_path_ex(buf)
    return r.GetProjectPathEx(self.pointer, buf)
end

-- returns an number that changes when the project state changes
---@return number 
function Project:get_project_state_change_count()
    return r.GetProjectStateChangeCount(self.pointer)
end

-- Gets project time offset in seconds (project settings - project start time). If rndframe is true, the offset is rounded to a multiple of the project frame size.
---@param rndframe boolean
---@return number 
function Project:get_project_time_offset(rndframe)
    return r.GetProjectTimeOffset(self.pointer, rndframe)
end

-- this does not reflect tempo envelopes but is purely what is set in the project settings.
---@return number, number 
function Project:get_project_time_signature2()
    return r.GetProjectTimeSignature2(self.pointer)
end

-- get the currently selected envelope, returns NULL/nil if no envelope is selected
---@return TrackEnvelope 
function Project:get_selected_envelope()
    return r.GetSelectedEnvelope(self.pointer)
end

-- get a selected item by selected item count (zero-based) (proj=0 for active project)
---@param selitem number
---@return MediaItem 
function Project:get_selected_media_item(selitem)
    return r.GetSelectedMediaItem(self.pointer, selitem)
end

-- Get a selected track from a project (proj=0 for active project) by selected track count (zero-based). This function ignores the master track, see GetSelectedTrack2.
---@param seltrackidx number
---@return MediaTrack 
function Project:get_selected_track(seltrackidx)
    return r.GetSelectedTrack(self.pointer, seltrackidx)
end

-- Get a selected track from a project (proj=0 for active project) by selected track count (zero-based).
---@param seltrackidx number
---@param wantmaster boolean
---@return MediaTrack 
function Project:get_selected_track2(seltrackidx, wantmaster)
    return r.GetSelectedTrack2(self.pointer, seltrackidx, wantmaster)
end

-- get the currently selected track envelope, returns NULL/nil if no envelope is selected
---@return TrackEnvelope 
function Project:get_selected_track_envelope()
    return r.GetSelectedTrackEnvelope(self.pointer)
end

-- Gets or sets the arrange view start/end time for screen coordinates. use screen_x_start=screen_x_end=0 to use the full arrange view's start/end time
---@param is_set boolean
---@param screen_x_start number
---@param screen_x_end number
---@return number, number 
function Project:get_set__arrange_view2(is_set, screen_x_start, screen_x_end)
    return r.GetSet_ArrangeView2(self.pointer, is_set, screen_x_start, screen_x_end)
end

---@param is_set boolean
---@param is_loop boolean
---@param start number
---@param end_ number
---@param allowautoseek boolean
---@return number, number 
function Project:get_set__loop_time_range2(is_set, is_loop, start, end_, allowautoseek)
    return r.GetSet_LoopTimeRange2(self.pointer, is_set, is_loop, start, end_, allowautoseek)
end

-- gets or sets project author, author_sz is ignored when setting
---@param set boolean
---@param author string
---@return string 
function Project:get_set_project_author(set, author)
    return r.GetSetProjectAuthor(self.pointer, set, author)
end

-- Get or set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note triplet, etc. swingmode can be 1 for swing enabled, swingamt is -1..1. swingmode can be 3 for measure-grid. Returns grid configuration flags
---@param set boolean
---@param division number
---@param swingmode number
---@param swingamt number
---@return number, number, number 
function Project:get_set_project_grid(set, division, swingmode, swingamt)
    local retval, division_, swingmode_, swingamt_ = r.GetSetProjectGrid(self.pointer, set, division, swingmode, swingamt)
    if retval then
        return division_, swingmode_, swingamt_
    end
end

---@param desc string
---@param value number
---@param is_set boolean
---@return number 
function Project:get_set_project_info(desc, value, is_set)
    return r.GetSetProjectInfo(self.pointer, desc, value, is_set)
end

--     "wave" "aiff" "iso " "ddp " "flac" "mp3l" "oggv" "OggS" "FFMP" "GIF " "LCF " "wvpk" 
---@param desc string
---@param valuestr_need_big string
---@param is_set boolean
---@return string 
function Project:get_set_project_info__string(desc, valuestr_need_big, is_set)
    local retval, valuestr_need_big_ = r.GetSetProjectInfo_String(self.pointer, desc, valuestr_need_big, is_set)
    if retval then
        return valuestr_need_big_
    end
end

-- gets or sets project notes, notesNeedBig_sz is ignored when setting
---@param set boolean
---@param notes string
---@return string 
function Project:get_set_project_notes(set, notes)
    return r.GetSetProjectNotes(self.pointer, set, notes)
end

-- -1 == query,0=clear,1=set,>1=toggle . returns new value
---@param val number
---@return number 
function Project:get_set_repeat_ex(val)
    return r.GetSetRepeatEx(self.pointer, val)
end

-- Get information about a specific FX parameter knob (see CountTCPFXParms).
---@param track MediaTrack
---@param index number
---@return number, number 
function Project:get_t_c_p_f_x_parm(track, index)
    local retval, fxindex, parmidx = r.GetTCPFXParm(self.pointer, track, index)
    if retval then
        return fxindex, parmidx
    end
end

-- Get information about a tempo/time signature marker. See CountTempoTimeSigMarkers, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@param ptidx number
---@return number, number, number, number, number, number, boolean 
function Project:get_tempo_time_sig_marker(ptidx)
    local retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo = r.GetTempoTimeSigMarker(self.pointer, ptidx)
    if retval then
        return timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo
    end
end

-- get a track from a project by track count (zero-based) (proj=0 for active project)
---@param trackidx number
---@return MediaTrack 
function Project:get_track(trackidx)
    return r.GetTrack(self.pointer, trackidx)
end

-- Get note/CC name. pitch 128 for CC0 name, 129 for CC1 name, etc. See SetTrackMIDINoteNameEx
---@param track MediaTrack
---@param pitch number
---@param chan number
---@return string 
function Project:get_track_m_i_d_i_note_name_ex(track, pitch, chan)
    return r.GetTrackMIDINoteNameEx(self.pointer, track, pitch, chan)
end

---@param track MediaTrack
---@return number, number 
function Project:get_track_m_i_d_i_note_range(track)
    return r.GetTrackMIDINoteRange(self.pointer, track)
end

-- Go to marker. If use_timeline_order==true, marker_index 1 refers to the first marker on the timeline.  If use_timeline_order==false, marker_index 1 refers to the first marker with the user-editable index of 1.
---@param marker_index number
---@param use_timeline_order boolean
function Project:go_to_marker(marker_index, use_timeline_order)
    return r.GoToMarker(self.pointer, marker_index, use_timeline_order)
end

-- Seek to region after current region finishes playing (smooth seek). If use_timeline_order==true, region_index 1 refers to the first region on the timeline.  If use_timeline_order==false, region_index 1 refers to the first region with the user-editable index of 1.
---@param region_index number
---@param use_timeline_order boolean
function Project:go_to_region(region_index, use_timeline_order)
    return r.GoToRegion(self.pointer, region_index, use_timeline_order)
end

-- returns name of track plugin that is supplying MIDI programs,or NULL if there is none
---@param track MediaTrack
---@return string 
function Project:has_track_m_i_d_i_programs_ex(track)
    return r.HasTrackMIDIProgramsEx(self.pointer, track)
end

-- Is the project dirty (needing save)? Always returns 0 if 'undo/prompt to save' is disabled in preferences.
---@return number 
function Project:is_project_dirty()
    return r.IsProjectDirty(self.pointer)
end

-- Move the loop selection left or right. Returns true if snap is enabled.
---@param direction number
---@return boolean 
function Project:loop__on_arrow(direction)
    return r.Loop_OnArrow(self.pointer, direction)
end

-- Save the project.
---@param force_save_as_in boolean
function Project:main__save_project(force_save_as_in)
    return r.Main_SaveProject(self.pointer, force_save_as_in)
end

-- Marks project as dirty (needing save) if 'undo/prompt to save' is enabled in preferences.
function Project:mark_project_dirty()
    return r.MarkProjectDirty(self.pointer)
end

---@return number 
function Project:master__get_play_rate()
    return r.Master_GetPlayRate(self.pointer)
end

-- direct way to simulate pause button hit
function Project:on_pause_button_ex()
    return r.OnPauseButtonEx(self.pointer)
end

-- direct way to simulate play button hit
function Project:on_play_button_ex()
    return r.OnPlayButtonEx(self.pointer)
end

-- direct way to simulate stop button hit
function Project:on_stop_button_ex()
    return r.OnStopButtonEx(self.pointer)
end

-- [S&M] Gets a take by GUID as string. The GUID must be enclosed in braces {}. To get take GUID as string, see BR_GetMediaItemTakeGUID
---@param guid string
---@return MediaItem_Take 
function Project:s_n_m__get_media_item_take_by_g_u_i_d(guid)
    return r.SNM_GetMediaItemTakeByGUID(self.pointer, guid)
end

-- [S&M] Gets a marker/region name. Returns true if marker/region found.
---@param num number
---@param isrgn boolean
---@param name WDL_FastString
---@param num number
---@return boolean 
function Project:s_n_m__get_project_marker_name(num, isrgn, name, num)
    return r.SNM_GetProjectMarkerName(self.pointer, num, isrgn, name, num)
end

-- [S&M] Deprecated, see SetProjectMarker4 -- Same function as SetProjectMarker3() except it can set empty names "".
---@param num number
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param color number
---@return boolean 
function Project:s_n_m__set_project_marker(num, isrgn, pos, rgnend, name, color)
    return r.SNM_SetProjectMarker(self.pointer, num, isrgn, pos, rgnend, name, color)
end

---@param selected boolean
function Project:select_all_media_items(selected)
    return r.SelectAllMediaItems(self.pointer, selected)
end

function Project:select_project_instance()
    return r.SelectProjectInstance(self.pointer)
end

-- set current BPM in project, set wantUndo=true to add undo point
---@param bpm number
---@param want_undo boolean
function Project:set_current_b_p_m(bpm, want_undo)
    return r.SetCurrentBPM(self.pointer, bpm, want_undo)
end

---@param time number
---@param moveview boolean
---@param seekplay boolean
function Project:set_edit_cur_pos2(time, moveview, seekplay)
    return r.SetEditCurPos2(self.pointer, time, moveview, seekplay)
end

-- Set the MIDI editor grid division. 0.25=quarter note, 1.0/3.0=half note tripet, etc.
---@param division number
function Project:set_m_i_d_i_editor_grid(division)
    return r.SetMIDIEditorGrid(self.pointer, division)
end

-- Save a key/value pair for a specific extension, to be restored the next time this specific project is loaded. Typically extname will be the name of a reascript or extension section. If key is NULL or "", all extended data for that extname will be deleted.  If val is NULL or "", the data previously associated with that key will be deleted. Returns the size of the state for this extname. See GetProjExtState, EnumProjExtState.
---@param extname string
---@param key string
---@param value string
---@return number 
function Project:set_proj_ext_state(extname, key, value)
    return r.SetProjExtState(self.pointer, extname, key, value)
end

-- Set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note triplet, etc.
---@param division number
function Project:set_project_grid(division)
    return r.SetProjectGrid(self.pointer, division)
end

---@param markrgnindexnumber number
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@return boolean 
function Project:set_project_marker2(markrgnindexnumber, isrgn, pos, rgnend, name)
    return r.SetProjectMarker2(self.pointer, markrgnindexnumber, isrgn, pos, rgnend, name)
end

---@param markrgnindexnumber number
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param color number
---@return boolean 
function Project:set_project_marker3(markrgnindexnumber, isrgn, pos, rgnend, name, color)
    return r.SetProjectMarker3(self.pointer, markrgnindexnumber, isrgn, pos, rgnend, name, color)
end

-- color should be 0 to not change, or ColorToNative(r,g,b)|0x1000000, flags&1 to clear name
---@param markrgnindexnumber number
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param color number
---@param flags number
---@return boolean 
function Project:set_project_marker4(markrgnindexnumber, isrgn, pos, rgnend, name, color, flags)
    return r.SetProjectMarker4(self.pointer, markrgnindexnumber, isrgn, pos, rgnend, name, color, flags)
end

-- See SetProjectMarkerByIndex2.
---@param markrgnidx number
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param i_dnumber number
---@param name string
---@param color number
---@return boolean 
function Project:set_project_marker_by_index(markrgnidx, isrgn, pos, rgnend, i_dnumber, name, color)
    return r.SetProjectMarkerByIndex(self.pointer, markrgnidx, isrgn, pos, rgnend, i_dnumber, name, color)
end

-- Differs from SetProjectMarker4 in that markrgnidx is 0 for the first marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than representing the displayed marker/region ID number (see SetProjectMarker3). Function will fail if attempting to set a duplicate ID number for a region (duplicate ID numbers for markers are OK). , flags&1 to clear name.
---@param markrgnidx number
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param i_dnumber number
---@param name string
---@param color number
---@param flags number
---@return boolean 
function Project:set_project_marker_by_index2(markrgnidx, isrgn, pos, rgnend, i_dnumber, name, color, flags)
    return r.SetProjectMarkerByIndex2(self.pointer, markrgnidx, isrgn, pos, rgnend, i_dnumber, name, color, flags)
end

-- Add (addorremove > 0) or remove (addorremove < 0) a track from this region when using the region render matrix.
---@param regionindex number
---@param track MediaTrack
---@param addorremove number
function Project:set_region_render_matrix(regionindex, track, addorremove)
    return r.SetRegionRenderMatrix(self.pointer, regionindex, track, addorremove)
end

-- Set parameters of a tempo/time signature marker. Provide either timepos (with measurepos=-1, beatpos=-1), or measurepos and beatpos (with timepos=-1). If timesig_num and timesig_denom are zero, the previous time signature will be used. ptidx=-1 will insert a new tempo/time signature marker. See CountTempoTimeSigMarkers, GetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@param ptidx number
---@param timepos number
---@param measurepos number
---@param beatpos number
---@param bpm number
---@param timesig_num number
---@param timesig_denom number
---@param lineartempo boolean
---@return boolean 
function Project:set_tempo_time_sig_marker(ptidx, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo)
    return r.SetTempoTimeSigMarker(self.pointer, ptidx, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo)
end

-- channel < 0 assigns note name to all channels. pitch 128 assigns name for CC0, pitch 129 for CC1, etc.
---@param track MediaTrack
---@param pitch number
---@param chan number
---@param name string
---@return boolean 
function Project:set_track_m_i_d_i_note_name_ex(track, pitch, chan, name)
    return r.SetTrackMIDINoteNameEx(self.pointer, track, pitch, chan, name)
end

---@param time_pos number
---@return number 
function Project:snap_to_grid(time_pos)
    return r.SnapToGrid(self.pointer, time_pos)
end

-- get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
---@param time number
---@return number 
function Project:time_map2__get_divided_bpm_at_time(time)
    return r.TimeMap2_GetDividedBpmAtTime(self.pointer, time)
end

-- when does the next time map (tempo or time sig) change occur
---@param time number
---@return number 
function Project:time_map2__get_next_change_time(time)
    return r.TimeMap2_GetNextChangeTime(self.pointer, time)
end

-- converts project QN position to time.
---@param qn number
---@return number 
function Project:time_map2__q_n_to_time(qn)
    return r.TimeMap2_QNToTime(self.pointer, qn)
end

-- convert a beat position (or optionally a beats+measures if measures is non-NULL) to time.
---@param tpos number
---@param measures_in number
---@return number 
function Project:time_map2_beats_to_time(tpos, measures_in)
    return r.TimeMap2_beatsToTime(self.pointer, tpos, measures_in)
end

-- if cdenom is non-NULL, will be set to the current time signature denominator.
---@param tpos number
---@return number, number, number, number 
function Project:time_map2_time_to_beats(tpos)
    local retval, measures, cml, fullbeats, cdenom = r.TimeMap2_timeToBeats(self.pointer, tpos)
    if retval then
        return measures, cml, fullbeats, cdenom
    end
end

-- converts project time position to QN position.
---@param tpos number
---@return number 
function Project:time_map2_time_to_q_n(tpos)
    return r.TimeMap2_timeToQN(self.pointer, tpos)
end

-- Get the QN position and time signature information for the start of a measure. Return the time in seconds of the measure start.
---@param measure number
---@return number, number, number, number, number 
function Project:time_map__get_measure_info(measure)
    local retval, qn_start, qn_end, timesig_num, timesig_denom, tempo = r.TimeMap_GetMeasureInfo(self.pointer, measure)
    if retval then
        return qn_start, qn_end, timesig_num, timesig_denom, tempo
    end
end

-- Fills in a string representing the active metronome pattern. For example, in a 7/8 measure divided 3+4, the pattern might be "1221222". The length of the string is the time signature numerator, and the function returns the time signature denominator.
---@param time number
---@param pattern string
---@return string 
function Project:time_map__get_metronome_pattern(time, pattern)
    local retval, pattern_ = r.TimeMap_GetMetronomePattern(self.pointer, time, pattern)
    if retval then
        return pattern_
    end
end

-- get the effective time signature and tempo
---@param time number
---@return number, number, number 
function Project:time_map__get_time_sig_at_time(time)
    return r.TimeMap_GetTimeSigAtTime(self.pointer, time)
end

-- Find which measure the given QN position falls in.
---@param qn number
---@return number, number 
function Project:time_map__q_n_to_measures(qn)
    local retval, qn_measure_start, qn_measure_end = r.TimeMap_QNToMeasures(self.pointer, qn)
    if retval then
        return qn_measure_start, qn_measure_end
    end
end

-- Converts project quarter note count (QN) to time. QN is counted from the start of the project, regardless of any partial measures. See TimeMap2_QNToTime
---@param qn number
---@return number 
function Project:time_map__q_n_to_time_abs(qn)
    return r.TimeMap_QNToTime_abs(self.pointer, qn)
end

-- Gets project framerate, and optionally whether it is drop-frame timecode
---@return boolean 
function Project:time_map_cur_frame_rate()
    local retval, drop_frame = r.TimeMap_curFrameRate(self.pointer)
    if retval then
        return drop_frame
    end
end

-- Converts project time position to quarter note count (QN). QN is counted from the start of the project, regardless of any partial measures. See TimeMap2_timeToQN
---@param tpos number
---@return number 
function Project:time_map_time_to_q_n_abs(tpos)
    return r.TimeMap_timeToQN_abs(self.pointer, tpos)
end

-- call to start a new block
function Project:undo__begin_block2()
    return r.Undo_BeginBlock2(self.pointer)
end

-- returns string of next action,if able,NULL if not
---@return string 
function Project:undo__can_redo2()
    return r.Undo_CanRedo2(self.pointer)
end

-- returns string of last action,if able,NULL if not
---@return string 
function Project:undo__can_undo2()
    return r.Undo_CanUndo2(self.pointer)
end

-- nonzero if success
---@return number 
function Project:undo__do_redo2()
    return r.Undo_DoRedo2(self.pointer)
end

-- nonzero if success
---@return number 
function Project:undo__do_undo2()
    return r.Undo_DoUndo2(self.pointer)
end

-- call to end the block,with extra flags if any,and a description
---@param descchange string
---@param extraflags number
function Project:undo__end_block2(descchange, extraflags)
    return r.Undo_EndBlock2(self.pointer, descchange, extraflags)
end

-- limited state change to items
---@param descchange string
function Project:undo__on_state_change2(descchange)
    return r.Undo_OnStateChange2(self.pointer, descchange)
end

---@param name string
---@param item MediaItem
function Project:undo__on_state_change__item(name, item)
    return r.Undo_OnStateChange_Item(self.pointer, name, item)
end

-- trackparm=-1 by default,or if updating one fx chain,you can specify track index
---@param descchange string
---@param which_states number
---@param trackparm number
function Project:undo__on_state_change_ex2(descchange, which_states, trackparm)
    return r.Undo_OnStateChangeEx2(self.pointer, descchange, which_states, trackparm)
end

-- Return true if the pointer is a valid object of the right type in proj (proj is ignored if pointer is itself a project). Supported types are: ReaProject*, MediaTrack*, MediaItem*, MediaItem_Take*, TrackEnvelope* and PCM_source*.
---@param pointer identifier
---@param ctypename string
---@return boolean 
function Project:validate_ptr2(pointer, ctypename)
    return r.ValidatePtr2(self.pointer, pointer, ctypename)
end

