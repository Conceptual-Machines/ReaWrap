--- Provide implementation for Project functions.
-- @author NomadMonad
-- @license MIT
-- @release 0.0.1

local r = reaper
local helpers = require("helpers")

-- @class Project
-- @field pointer_type string "ReaProject*"
-- @field pointer number The index of the project
local Project = {}

--- Create new Project instance.
--- @within ReaWrap Custom Methods
--- @param project_idx number Optional. The index of the project
--- @return table Project instance
function Project:new(project_idx)
	local project_idx = project_idx or 0
	local obj = {
		pointer_type = "ReaProject*",
		pointer = project_idx,
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

--- Log messages with the Project logger.
--- @within ReaWrap Custom Methods
--- @param ... (varargs) Messages to log.
function Project:log(...)
	local logger = helpers.log_func("Project")
	logger(...)
	return nil
end

--- String representation of the Project instance.
--- @within ReaWrap Custom Methods
--- @return string
function Project:__tostring()
	return string.format("<Project name=%s>", self:get_name())
end

--- Get all selected tracks.
--- @within ReaWrap Custom Methods
--- @param master boolean Whether to include the master track. Optional (Default is false).
--- @return table array<Track>
function Project:get_selected_tracks(master)
	master = master or false
	local tracks = {}
	local count = self:count_selected_tracks(master)
	for i = 0, count - 1 do
		local track = self:get_selected_track(i, master)
		tracks[i + 1] = track
	end
	return tracks
end

--- Iterate over selected tracks.
--- @within ReaWrap Custom Methods
--- @param master boolean Whether to include the master track. Optional (Default is false).
--- @return function iterator
function Project:iter_selected_tracks(master)
	master = master or false
	return helpers.iter(self:get_selected_tracks(master))
end

--- Whether there is at least one selected track.
--- @within ReaWrap Custom Methods
--- @param master boolean Whether to include the master track. Optional (Default is false).
---@return boolean
function Project:has_selected_tracks(master)
	master = master or false
	return self:count_selected_tracks(master) > 0
end

--- Get all selected media items.
--- @within ReaWrap Custom Methods
--- @return table array of Item objects
function Project:get_selected_media_items()
	local selected_media_items = {}
	for i = 0, self:count_selected_media_items() - 1 do
		local media_item = self:get_selected_media_item(i)
		selected_media_items[i + 1] = media_item
	end
	return selected_media_items
end

--- Iterate over selected media items.
--- @within ReaWrap Custom Methods
--- @return function iterator
function Project:iter_selected_media_items()
	return helpers.iter(self:get_selected_media_items())
end

--- Whether there are any selected media items.
--- @within ReaWrap Custom Methods
--- @return boolean
function Project:has_selected_media_items()
	return self:count_selected_media_items() > 0
end

--- Get all tracks in the project.
--- @within ReaWrap Custom Methods
--- @return table array of Track objects
function Project:get_tracks()
	local tracks = {}
	for i = 0, self:count_tracks() - 1 do
		local track = self:get_track(i)
		tracks[i + 1] = track
	end
	return tracks
end

--- Iterate over all tracks in the project.
--- @within ReaWrap Custom Methods
--- @return function iterator
function Project:iter_tracks()
	return helpers.iter(self:get_tracks())
end

--- Whether there is at least one track in the project.
--- @within ReaWrap Custom Methods
--- @return boolean
function Project:has_tracks()
	return self:count_tracks() > 0
end

--- Get all TCP FX params.
--- @within ReaWrap Custom Methods
--- @return table array
function Project:get_tcp_fx_params()
	local tcp_fx_params = {}
	for i = 0, self:count_tcp_fx_params() - 1 do
		local fx_idx, param_idx = self:get_tcp_fx_param(i)
		tcp_fx_params[i + 1] = { fx_idx, param_idx }
	end
	return tcp_fx_params
end

--- Iterate over all TCP FX params in the project.
--- @within ReaWrap Custom Methods
--- @return function iterator
function Project:iter_tcp_fx_params()
	return helpers.iter(self:get_tcp_fx_params())
end

--- Whether there is at least one TCP FX Param in the project.
--- @within ReaWrap Custom Methods
--- @return boolean
function Project:has_tcp_fx_params()
	return self:count_tcp_fx_params() > 0
end

--- Add Project Marker. Wraps AddProjectMarker2.
-- Returns the index of the created marker/region, or -1 on failure. Supply
-- want_idx>=0 if you want a particular index number, but you'll get a different
-- index number a region and want_idx is already in use. color should be 0 (default
-- color), or ColorToNative(r,g,b)|0x1000000
--- @within ReaScript Wrapped Methods
--- @param is_rgn boolean
--- @param pos number
--- @param rgn_end number
--- @param name string
--- @param want_idx number
--- @param color number
--- @return number
function Project:add_project_marker(is_rgn, pos, rgn_end, name, want_idx, color)
	return r.AddProjectMarker2(self.pointer, is_rgn, pos, rgn_end, name, want_idx, color)
end

--- Any Track Solo. Wraps AnyTrackSolo.
--- @within ReaScript Wrapped Methods
--- @return boolean
function Project:any_track_solo()
	return r.AnyTrackSolo(self.pointer)
end

--- Project.NudgeConstants: A table of constants for nudge operations.
--- @within ReaScript Wrapped Methods
--- @field FLAG table<#string, #number> Flags for nudge operations.
--- @field WHAT table<#string, #number> Targets for nudge operations.
--- @field UNIT table<#string, #number> Units for nudge operations.
Project.NudgeConstants = {}

--- Flags for nudge operations.
--- @within Constants
--- @field SET_TO_VALUE number The "Set to value" flag.
--- @field SNAP number The "Snap" flag.
Project.NudgeConstants.FLAG = {
	SET_TO_VALUE = 1,
	SNAP = 2,
}
--- Targets for nudge operations.
--- @within Constants
--- @field POSITION number The position target.
--- @field LEFT_TRIM number The left trim target.
--- @field LEFT_EDGE number The left edge target.
--- @field RIGHT_EDGE number The right edge target.
--- @field CONTENTS number The contents target.
--- @field DUPLICATE number The duplicate target.
--- @field EDIT_CURSOR number The edit cursor target.
Project.NudgeConstants.WHAT = {
	POSITION = 0,
	LEFT_TRIM = 1,
	LEFT_EDGE = 2,
	RIGHT_EDGE = 3,
	CONTENTS = 4,
	DUPLICATE = 5,
	EDIT_CURSOR = 6,
}
--- Units for nudge operations.
--- @within Constants
--- @field MS number Milliseconds unit.
--- @field SECONDS number Seconds unit.
--- @field GRID number Grid unit.
--- @field _256TH_NOTES number 256th notes unit.
--- @field _1 number Whole note unit.
--- @field MEASURES_BEATS number Measures and beats unit.
--- @field SAMPLES number Samples unit.
--- @field FRAMES number Frames unit.
--- @field PIXELS number Pixels unit.
--- @field ITEM_LENGTHS number Item lengths unit.
--- @field ITEM_SELECTIONS number Item selections unit.
Project.NudgeConstants.UNIT = {
	MS = 0,
	SECONDS = 1,
	GRID = 2,
	_256TH_NOTES = 3,
	_1 = 15,
	MEASURES_BEATS = 16,
	SAMPLES = 17,
	FRAMES = 18,
	PIXELS = 19,
	ITEM_LENGTHS = 20,
	ITEM_SELECTIONS = 21,
}

--- Apply Nudge. Wraps ApplyNudge.
--- @within ReaScript Wrapped Methods
--- @param nudge_flag number Project.NudgeConstants.FLAG
--- @param nudge_what number Project.NudgeConstants.WHAT.
--- @param nudge_units number Project.NudgeConstants.UNIT.
--- @param value number
--- @param reverse boolean
--- @param copies number
--- @return boolean
--- @see Project.NudgeConstants.FLAG
--- @see Project.NudgeConstants.WHAT
--- @see Project.NudgeConstants.UNIT
function Project:apply_nudge(nudge_flag, nudge_what, nudge_units, value, reverse, copies)
	return r.ApplyNudge(self.pointer, nudge_flag, nudge_what, nudge_units, value, reverse, copies)
end

--- Count Media Items. Wraps CountMediaItems.
-- count the number of items in the project (proj=0 for active project)
--- @within ReaScript Wrapped Methods
--- @return number
function Project:count_media_items()
	return r.CountMediaItems(self.pointer)
end

--- Count Project Markers. Wraps CountProjectMarkers.
-- num_markersOut and num_regionsOut may be NULL.
--- @within ReaScript Wrapped Methods
--- @return number num_markers
--- @return number num_regions
function Project:count_project_markers()
	local ret_val, num_markers, num_regions = r.CountProjectMarkers(self.pointer)
	if ret_val then
		return num_markers, num_regions
	else
		error("Error in CountProjectMarkers")
	end
end

--- Count Selected Tracks. Wraps CountSelectedTracks2.
-- Count the number of selected tracks in the project (proj=0 for active project).
--- @within ReaScript Wrapped Methods
--- @param want_master boolean Optional
--- @return number
function Project:count_selected_tracks(want_master)
	local want_master = want_master or false
	return r.CountSelectedTracks2(self.pointer, want_master)
end

--- Count TCP FX Params. Wraps CountTCPFXParms.
-- Count the number of FX parameter knobs displayed on the track control panel.
--- @within ReaScript Wrapped Methods
--- @param track table Track object
--- @return number
function Project:count_tcp_fx_params(track)
	return r.CountTCPFXParms(self.pointer, track.pointer)
end

--- Count Tempo Time Sig Markers. Wraps CountTempoTimeSigMarkers.
-- Count the number of tempo/time signature markers in the project. See
-- GetTempoTimeSigMarker, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
--- @within ReaScript Wrapped Methods
--- @return number
function Project:count_tempo_time_sig_markers()
	return r.CountTempoTimeSigMarkers(self.pointer)
end

--- Count Tracks. Wraps CountTracks.
-- count the number of tracks in the project (proj=0 for active project)
--- @within ReaScript Wrapped Methods
--- @return number
function Project:count_tracks()
	return r.CountTracks(self.pointer)
end

--- Delete Track. Wraps DeleteTrack.
-- Deletes a track.
--- @within ReaScript Wrapped Methods
--- @param track_idx number
function Project:delete_track(track_idx)
	return r.DeleteTrack(track_idx)
end

--- Delete Project Marker. Wraps DeleteProjectMarker.
-- Delete a marker.  proj==NULL for the active project.
--- @within ReaScript Wrapped Methods
--- @param mark_rgn_idx number
--- @param is_rgn boolean
--- @return boolean
function Project:delete_project_marker(mark_rgn_idx, is_rgn)
	return r.DeleteProjectMarker(self.pointer, mark_rgn_idx, is_rgn)
end

--- Delete Project Marker By Index. Wraps DeleteProjectMarkerByIndex.
-- Differs from DeleteProjectMarker only in that mark_rgn_idx is 0 for the first
-- marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than
-- representing the displayed marker/region ID number (see SetProjectMarker4).
--- @within ReaScript Wrapped Methods
--- @param mark_rgn_idx number
--- @return boolean
function Project:delete_project_marker_by_index(mark_rgn_idx)
	return r.DeleteProjectMarkerByIndex(self.pointer, mark_rgn_idx)
end

--- Delete Tempo Time Sig Marker. Wraps DeleteTempoTimeSigMarker.
-- Delete a tempo/time signature marker.
--- @within ReaScript Wrapped Methods
--- @param marker_idx number
--- @return boolean
function Project:delete_tempo_time_sig_marker(marker_idx)
	return r.DeleteTempoTimeSigMarker(self.pointer, marker_idx)
end

--- Edit Tempo Time Sig Marker. Wraps EditTempoTimeSigMarker.
-- Open the tempo/time signature marker editor dialog.
--- @within ReaScript Wrapped Methods
--- @param marker_idx number
--- @return boolean
function Project:edit_tempo_time_sig_marker(marker_idx)
	return r.EditTempoTimeSigMarker(self.pointer, marker_idx)
end

--- Enum Project Markers. Wraps EnumProjectMarkers3.
--- @within ReaScript Wrapped Methods
--- @param idx number
--- @return boolean is_rgn
--- @return number pos
--- @return number rgn_end
--- @return string name
--- @return number mark_rgn_idx
--- @return number color
function Project:enum_project_markers(idx)
	local ret_val, is_rgn, pos, rgn_end, name, mark_rgn_idx, color = r.EnumProjectMarkers3(self.pointer, idx)
	if ret_val then
		return is_rgn, pos, rgn_end, name, mark_rgn_idx, color
	else
		error("Error in EnumProjectMarkers3")
	end
end

--- Enum Proj Ext State. Wraps EnumProjExtState.
-- Enumerate the data stored with the project for a specific extname. Returns false
-- when there is no more data. See SetProjExtState, GetProjExtState.
--- @within ReaScript Wrapped Methods
--- @param ext_name string
--- @param idx number
--- @return string key
--- @return string val
function Project:enum_proj_ext_state(ext_name, idx)
	local ret_val, key, val = r.EnumProjExtState(self.pointer, ext_name, idx)
	if ret_val then
		return key, val
	else
		error("Error in EnumProjExtState")
	end
end

--- Enum Region Render Matrix. Wraps EnumRegionRenderMatrix.
-- Enumerate which tracks will be rendered within this region when using the region
-- render matrix. When called with render_track==0, the function returns the first
-- track that will be rendered (which may be the master track); render_track==1 will
-- return the next track rendered, and so on. The function returns NULL when there
-- are no more tracks that will be rendered within this region.
--- @within ReaScript Wrapped Methods
--- @param region_idx number
--- @param render_track number
--- @return table Track object
function Project:enum_region_render_matrix(region_idx, render_track)
	local Track = require("track")
	local result = r.EnumRegionRenderMatrix(self.pointer, region_idx, render_track)
	return Track:new(result)
end

--- Enum Track Midi Program Names Ex. Wraps EnumTrackMIDIProgramNamesEx.
-- returns false if there are no plugins on the track that support MIDI programs,or
-- if all programs have been enumerated
--- @within ReaScript Wrapped Methods
--- @param track table Track object
--- @param program_number number
--- @param program_name string
--- @return string program_name
function Project:enum_track_midi_program_names_ex(track, program_number, program_name)
	local ret_val, program_name =
		r.EnumTrackMIDIProgramNamesEx(self.pointer, track.pointer, program_number, program_name)
	if ret_val then
		return program_name
	else
		error("Error in EnumTrackMIDIProgramNamesEx")
	end
end

--- Find Tempo Time Sig Marker. Wraps FindTempoTimeSigMarker.
-- Find the tempo/time signature marker that falls at or before this time position
-- (the marker that is in effect as of this time position).
--- @within ReaScript Wrapped Methods
--- @param time number
--- @return number
function Project:find_tempo_time_sig_marker(time)
	return r.FindTempoTimeSigMarker(self.pointer, time)
end

--- Get All Project Play States. Wraps GetAllProjectPlayStates.
-- returns the bitwise OR of all project play states (1=playing, 2=pause,
-- 4=recording)
--- @within ReaScript Wrapped Methods
--- @return number
function Project:get_all_project_play_states()
	return r.GetAllProjectPlayStates(self.pointer)
end

--- Get Cursor Position Ex. Wraps GetCursorPositionEx.
-- edit cursor position
--- @within ReaScript Wrapped Methods
--- @return number
function Project:get_cursor_position_ex()
	return r.GetCursorPositionEx(self.pointer)
end

--- Get Free Disk Space For Record Path. Wraps GetFreeDiskSpaceForRecordPath.
-- returns free disk space in megabytes, pathIdx 0 for normal, 1 for alternate.
--- @within ReaScript Wrapped Methods
--- @param path_idx number
--- @return number
function Project:get_free_disk_space_for_record_path(path_idx)
	return r.GetFreeDiskSpaceForRecordPath(self.pointer, path_idx)
end

--- Get Last Marker And Cur Region. Wraps GetLastMarkerAndCurRegion.
-- Get the last project marker before time, and/or the project region that includes
-- time. marker_idx and region_idx are returned not necessarily as the displayed
-- marker/region index, but as the index that can be passed to EnumProjectMarkers.
-- Either or both of marker_idx and region_idx may be NULL. See EnumProjectMarkers.
--- @within ReaScript Wrapped Methods
--- @param time number
--- @return number marker_idx
--- @return number region_idx
function Project:get_last_marker_and_cur_region(time)
	return r.GetLastMarkerAndCurRegion(self.pointer, time)
end

--- Get Master Track. Wraps GetMasterTrack.
--- @within ReaScript Wrapped Methods
--- @return table Track object
function Project:get_master_track()
	local Track = require("track")
	local result = r.GetMasterTrack(self.pointer)
	return Track:new(result)
end

--- Get Media Item. Wraps GetMediaItem.
-- get an item from a project by item count (zero-based) (proj=0 for active
-- project)
--- @within ReaScript Wrapped Methods
--- @param item_idx number
--- @return table Item object
function Project:get_media_item(item_idx)
	local Item = require("item")
	local result = r.GetMediaItem(self.pointer, item_idx)
	return Item:new(result)
end

--- Get Media Item Take By Guid. Wraps GetMediaItemTakeByGUID.
--- @within ReaScript Wrapped Methods
--- @param guid string
--- @return table Take object
function Project:get_media_item_take_by_guid(guid)
	local Take = require("take")
	local result = r.GetMediaItemTakeByGUID(self.pointer, guid)
	return Take:new(result)
end

--- Get Play Position. Wraps GetPlayPosition2Ex.
-- returns position of next audio block being processed
--- @within ReaScript Wrapped Methods
--- @return number
function Project:get_play_position()
	return r.GetPlayPosition2Ex(self.pointer)
end

--- Get Play Position Lat Comp. Wraps GetPlayPositionEx.
-- returns latency-compensated actual-what-you-hear position
--- @within ReaScript Wrapped Methods
--- @return number
function Project:get_play_position_lat_comp()
	return r.GetPlayPositionEx(self.pointer)
end

--- Get Play State Ex. Wraps GetPlayStateEx.
-- &1=playing, &2=paused, &4=is recording
--- @within ReaScript Wrapped Methods
--- @return number
function Project:get_play_state_ex()
	return r.GetPlayStateEx(self.pointer)
end

--- Get Project Length. Wraps GetProjectLength.
-- returns length of project (maximum of end of media item, markers, end of
-- regions, tempo map
--- @within ReaScript Wrapped Methods
--- @return number
function Project:get_project_length()
	return r.GetProjectLength(self.pointer)
end

--- Get Name. Wraps GetProjectName.
--- @within ReaScript Wrapped Methods
--- @return string name
function Project:get_name()
	return r.GetProjectName(self.pointer)
end

--- Get Project Path Ex. Wraps GetProjectPathEx.
-- Get the project recording path.
--- @within ReaScript Wrapped Methods
--- @return string path
function Project:get_project_path_ex()
	return r.GetProjectPathEx(self.pointer)
end

--- Get Project State Change Count. Wraps GetProjectStateChangeCount.
-- returns an integer that changes when the project state changes
--- @within ReaScript Wrapped Methods
--- @return number
function Project:get_project_state_change_count()
	return r.GetProjectStateChangeCount(self.pointer)
end

--- Get Project Time Offset. Wraps GetProjectTimeOffset.
-- Gets project time offset in seconds (project settings - project start time). If
-- rnd_frame is true, the offset is rounded to a multiple of the project frame size.
--- @within ReaScript Wrapped Methods
--- @param rnd_frame boolean
--- @return number
function Project:get_project_time_offset(rnd_frame)
	return r.GetProjectTimeOffset(self.pointer, rnd_frame)
end

--- Get Project Time Signature. Wraps GetProjectTimeSignature2.
-- Gets basic time signature (beats per minute, numerator of time signature in bpi)
-- this does not reflect tempo envelopes but is purely what is set in the project
-- settings.
--- @within ReaScript Wrapped Methods
--- @return number bpm
--- @return number bpi
function Project:get_project_time_signature()
	return r.GetProjectTimeSignature2(self.pointer)
end

--- Get Proj Ext State. Wraps GetProjExtState.
-- Get the value previously associated with this extname and key, the last time the
-- project was saved. See SetProjExtState, EnumProjExtState.
--- @within ReaScript Wrapped Methods
--- @param ext_name string
--- @param key string
--- @return string value
function Project:get_proj_ext_state(ext_name, key)
	local ret_val, val = r.GetProjExtState(self.pointer, ext_name, key)
	if ret_val then
		return val
	else
		error("Error in GetProjExtState")
	end
end

--- Get Selected Envelope. Wraps GetSelectedEnvelope.
-- Get the currently selected envelope, returns NULL/nil if no envelope is selected.
--- @within ReaScript Wrapped Methods
--- @return table Envelope object
function Project:get_selected_envelope()
	local Envelope = require("envelope")
	local result = r.GetSelectedEnvelope(self.pointer)
	return Envelope:new(result)
end

--- Get Selected Track. Wraps GetSelectedTrack2.
-- Get a selected track from a project (proj=0 for active project) by selected
-- track count (zero-based).
--- @within ReaScript Wrapped Methods
--- @param seltrack_idx number
--- @param want_master boolean Optional
--- @return table Track object
function Project:get_selected_track(seltrack_idx, want_master)
	local want_master = want_master or false
	local Track = require("track")
	local result = r.GetSelectedTrack2(self.pointer, seltrack_idx, want_master)
	return Track:new(result)
end

--- Get Selected Track Envelope. Wraps GetSelectedTrackEnvelope.
-- get the currently selected track envelope, returns NULL/nil if no envelope is
-- selected
--- @within ReaScript Wrapped Methods
--- @return table Envelope object
function Project:get_selected_track_envelope()
	local Envelope = require("envelope")
	local result = r.GetSelectedTrackEnvelope(self.pointer)
	return Envelope:new(result)
end

--- Get Set Arrange View2. Wraps GetSet_ArrangeView2.
-- Gets or sets the arrange view start/end time for screen coordinates. use
-- screen_x_start=screen_x_end=0 to use the full arrange view's start/end time
--- @within ReaScript Wrapped Methods
--- @param is_set boolean
--- @param screen_x_start number
--- @param screen_x_end number
--- @param start_time number
--- @param end_time number
--- @return number start_time
--- @return number end_time
function Project:get_set_arrange_view2(is_set, screen_x_start, screen_x_end, start_time, end_time)
	return r.GetSet_ArrangeView2(self.pointer, is_set, screen_x_start, screen_x_end, start_time, end_time)
end

--- Get Set Loop Time Range2. Wraps GetSet_LoopTimeRange2.
--- @within ReaScript Wrapped Methods
--- @param is_set boolean
--- @param is_loop boolean
--- @param start number
--- @param end_ number
--- @param allowautoseek boolean
--- @return number start
--- @return number end_
function Project:get_set_loop_time_range2(is_set, is_loop, start, end_, allowautoseek)
	return r.GetSet_LoopTimeRange2(self.pointer, is_set, is_loop, start, end_, allowautoseek)
end

--- Get Set Project Grid. Wraps GetSetProjectGrid.
-- Get or set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note
-- triplet, etc. swingmode can be 1 for swing enabled, swingamt is -1..1. swingmode
-- can be 3 for measure-grid. Returns grid configuration flags
--- @within ReaScript Wrapped Methods
--- @param set boolean
--- @param division number Optional
--- @param swingmode integer  Optional
--- @param swingamt number Optional
--- @return number division
--- @return integer swingmode
--- @return number swingamt
function Project:get_set_project_grid(set, division, swingmode, swingamt)
	local division = division or nil
	local swingmode = swingmode or nil
	local swingamt = swingamt or nil
	local ret_val, division, swingmode, swingamt = r.GetSetProjectGrid(self.pointer, set, division, swingmode, swingamt)
	if ret_val then
		return division, swingmode, swingamt
	else
		error("Error in GetSetProjectGrid")
	end
end

--- Constants for Project:get_set_project_info.
--- @within Constants
--- @field RENDER_SETTINGS &(1|2)=0: master mix, &1=stems+master mix, &2=stems only, &4=multichannel tracks to multichannel files, &8=use render matrix, &16=tracks with only mono media to mono files, &32=selected media items, &64=selected media items via master, &128=selected tracks via master, &256=embed transients if format supports, &512=embed metadata if format supports, &1024=embed take markers if format supports, &2048=2nd pass render
--- @field RENDER_BOUNDSFLAG any: 0=custom time bounds, 1=entire project, 2=time selection, 3=all project regions, 4=selected media items, 5=selected project regions, 6=all project markers, 7=selected project markers
--- @field RENDER_CHANNELS number: number of channels in rendered file
--- @field RENDER_SRATE any: sample rate of rendered file (or 0 for project sample rate)
--- @field RENDER_STARTPOS any: render start time when RENDER_BOUNDSFLAG=0
--- @field RENDER_ENDPOS any: render end time when RENDER_BOUNDSFLAG=0
--- @field RENDER_TAILFLAG apply render tail setting when rendering: &1=custom time bounds, &2=entire project, &4=time selection, &8=all project markers/regions, &16=selected media items, &32=selected project markers/regions
--- @field RENDER_TAILMS any: tail length in ms to render (only used if RENDER_BOUNDSFLAG and RENDER_TAILFLAG are set)
--- @field RENDER_ADDTOPROJ any: &1=add rendered files to project, &2=do not render files that are likely silent
--- @field RENDER_DITHER any: &1=dither, &2=noise shaping, &4=dither stems, &8=noise shaping on stems
--- @field RENDER_NORMALIZE any: &1=enable, (&14==0)=LUFS-I, (&14==2)=RMS, (&14==4)=peak, (&14==6)=true peak, (&14==8)=LUFS-M max, (&14==10)=LUFS-S max, (&4128==32)=normalize stems to common gain based on master, &64=enable brickwall limit, &128=brickwall limit true peak, (&2304==256)=only normalize files that are too loud, (&2304==2048)=only normalize files that are too quiet, &512=apply fade-in, &1024=apply fade-out, (&4128==4096)=normalize to loudest file, (&4128==4128)=normalize as if one long file, &8192=adjust mono media additional -3dB
--- @field RENDER_NORMALIZE_TARGET any: render normalization target as amplitude, so 0.5 means -6.02dB, 0.25 means -12.04dB, etc
--- @field RENDER_BRICKWALL any: render brickwall limit as amplitude, so 0.5 means -6.02dB, 0.25 means -12.04dB, etc
--- @field RENDER_FADEIN any: render fade-in (0.001 means 1 ms, requires RENDER_NORMALIZE&512)
--- @field RENDER_FADEOUT any: render fade-out (0.001 means 1 ms, requires RENDER_NORMALIZE&1024)
--- @field RENDER_FADEINSHAPE any: render fade-in shape
--- @field RENDER_FADEOUTSHAPE any: render fade-out shape
--- @field PROJECT_SRATE any: sample rate (ignored unless PROJECT_SRATE_USE set)
--- @field PROJECT_SRATE_USE any: set to 1 if project sample rate is used
Project.GetSetProjectInfoConstants = {
	RENDER_SETTINGS = "RENDER_SETTINGS",
	RENDER_BOUNDSFLAG = "RENDER_BOUNDSFLAG",
	RENDER_CHANNELS = "RENDER_CHANNELS",
	RENDER_SRATE = "RENDER_SRATE",
	RENDER_STARTPOS = "RENDER_STARTPOS",
	RENDER_ENDPOS = "RENDER_ENDPOS",
	RENDER_TAILFLAG = "RENDER_TAILFLAG",
	RENDER_TAILMS = "RENDER_TAILMS",
	RENDER_ADDTOPROJ = "RENDER_ADDTOPROJ",
	RENDER_DITHER = "RENDER_DITHER",
	RENDER_NORMALIZE = "RENDER_NORMALIZE",
	RENDER_NORMALIZE_TARGET = "RENDER_NORMALIZE_TARGET",
	RENDER_BRICKWALL = "RENDER_BRICKWALL",
	RENDER_FADEIN = "RENDER_FADEIN",
	RENDER_FADEOUT = "RENDER_FADEOUT",
	RENDER_FADEINSHAPE = "RENDER_FADEINSHAPE",
	RENDER_FADEOUTSHAPE = "RENDER_FADEOUTSHAPE",
	PROJECT_SRATE = "PROJECT_SRATE",
	PROJECT_SRATE_USE = "PROJECT_SRATE_USE",
}

--- Get Set Project Info. Wraps GetSetProjectInfo.
-- Get or set project information.
--- @within ReaScript Wrapped Methods
--- @param desc string Project.GetSetProjectInfoConstants
--- @param value number
--- @param is_set boolean
--- @return number
function Project:get_set_project_info(desc, value, is_set)
	return r.GetSetProjectInfo(self.pointer, desc, value, is_set)
end

--- Constants for Project:get_set_project_info_string.
--- @within Constants
--- @field PROJECT_NAME any: project file name (read-only, is_set will be ignored)
--- @field PROJECT_TITLE any: title field from Project Settings/Notes dialog
--- @field PROJECT_AUTHOR any: author field from Project Settings/Notes dialog
--- @field TRACK_GROUP_NAME X: track group name, X should be 1..64
--- @field MARKER_GUID X: get the GUID (unique ID) of the marker or region with index X, where X is the index passed to EnumProjectMarkers, not necessarily the displayed number (read-only)
--- @field MARKER_INDEX_FROM_GUID {GUID}: get the GUID index of the marker or region with GUID {GUID} (read-only)
--- @field OPENCOPY_CFGIDX any: integer for the configuration of format to use when creating copies/applying FX. 0=wave (auto-depth), 1=APPLYFX_FORMAT, 2=RECORD_FORMAT
--- @field RECORD_PATH any: recording directory -- may be blank or a relative path, to get the effective path see
--- @field RECORD_PATH_SECONDARY any: secondary recording directory
--- @field RECORD_FORMAT string: base64-encoded sink configuration (see project files, etc). Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type.
--- @field APPLYFX_FORMAT string: base64-encoded sink configuration (see project files, etc). Used only if RECFMT_OPENCOPY is set to 1. Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type.
--- @field RENDER_FILE any: render directory
--- @field RENDER_PATTERN any: render file name (may contain wildcards)
--- @field RENDER_METADATA get or set the metadata saved with the project (not metadata embedded in project media). Example, ID3 album name metadata: get or set the metadata saved with the project (not metadata embedded in project media). Example, ID3 album name metadatavaluestr="ID3TALB" to get, valuestr="ID3TALB|my album name" to set. Call with valuestr="" and is_set=false to get a semicolon-separated list of defined project metadata identifiers.
--- @field RENDER_TARGETS any: semicolon separated list of files that would be written if the project is rendered using the most recent render settings
--- @field RENDER_STATS any: (read-only) semicolon separated list of statistics for the most recently rendered files. call with valuestr="XXX" to run an action (for example, "42437"=dry run render selected items) before returning statistics.
--- @field RENDER_FORMAT string: base64-encoded sink configuration (see project files, etc). Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type.
Project.GetSetProjectInfoStringConstants = {
	PROJECT_NAME = "PROJECT_NAME",
	PROJECT_TITLE = "PROJECT_TITLE",
	PROJECT_AUTHOR = "PROJECT_AUTHOR",
	TRACK_GROUP_NAME = "TRACK_GROUP_NAME",
	MARKER_GUID = "MARKER_GUID",
	MARKER_INDEX_FROM_GUID = "MARKER_INDEX_FROM_GUID",
	OPENCOPY_CFGIDX = "OPENCOPY_CFGIDX",
	RECORD_PATH = "RECORD_PATH",
	RECORD_PATH_SECONDARY = "RECORD_PATH_SECONDARY",
	RECORD_FORMAT = "RECORD_FORMAT",
	APPLYFX_FORMAT = "APPLYFX_FORMAT",
	RENDER_FILE = "RENDER_FILE",
	RENDER_PATTERN = "RENDER_PATTERN",
	RENDER_METADATA = "RENDER_METADATA",
	RENDER_TARGETS = "RENDER_TARGETS",
	RENDER_STATS = "RENDER_STATS",
	RENDER_FORMAT = "RENDER_FORMAT",
}

--- Get Set Project Info String. Wraps GetSetProjectInfo_String.
-- Get or set project information.GetProjectPathEx()RENDER_FORMAT2 : base64-encoded
-- secondary sink configuration. Callers can also pass a simple 4-byte string (non-
-- base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink
-- type, or "" to disable secondary render.Formats available on this machine:"wave"
-- "aiff" "caff" "raw " "iso " "ddp " "flac" "mp3l" "oggv" "OggS" "FFMP" "WMF "
-- "GIF " "LCF " "wvpk"
--- @within ReaScript Wrapped Methods
--- @param desc string Project.GetSetProjectInfoStringConstants
--- @param valuestr string
--- @param is_set boolean
--- @return string valuestr
function Project:get_set_project_info_string(desc, valuestr, is_set)
	local ret_val, valuestr = r.GetSetProjectInfo_String(self.pointer, desc, valuestr, is_set)
	if ret_val then
		return valuestr
	else
		error("Error in GetSetProjectInfo_String")
	end
end

--- Get Set Project Notes. Wraps GetSetProjectNotes.
-- gets or sets project notes, notesNeedBig_sz is ignored when setting
--- @within ReaScript Wrapped Methods
--- @param is_set boolean
--- @param notes string
--- @return string
function Project:get_set_project_notes(is_set, notes)
	return r.GetSetProjectNotes(self.pointer, is_set, notes)
end

--- Get Set Repeat Ex. Wraps GetSetRepeatEx.
-- -1 == query,0=clear,1=set,>1=toggle . returns new value
--- @within ReaScript Wrapped Methods
--- @param val number
--- @return number
function Project:get_set_repeat_ex(val)
	return r.GetSetRepeatEx(self.pointer, val)
end

--- Get Set Tempo Time Sig Marker Flag. Wraps GetSetTempoTimeSigMarkerFlag.
-- Gets or sets the attribute flag of a tempo/time signature marker. flag &1=sets
-- time signature and starts new measure, &2=does not set tempo, &4=allow previous
-- partial measure if starting new measure, &8=set new metronome pattern if
-- starting new measure, &16=reset ruler grid if starting new measure
--- @within ReaScript Wrapped Methods
--- @param point_index number
--- @param flag number
--- @param is_set boolean
--- @return number
function Project:get_set_tempo_time_sig_marker_flag(point_index, flag, is_set)
	return r.GetSetTempoTimeSigMarkerFlag(self.pointer, point_index, flag, is_set)
end

--- Get TCP FX Param. Wraps GetTCPFXParm.
-- Get information about a specific FX parameter knob (see CountTCPFXParms).
--- @within ReaScript Wrapped Methods
--- @param track table Track object
--- @param index number
--- @return number fx_idx
--- @return number param_idx
function Project:get_tcp_fx_param(track, index)
	local ret_val, fx_idx, param_idx = r.GetTCPFXParm(self.pointer, track.pointer, index)
	if ret_val then
		return fx_idx, param_idx
	else
		error("Error in GetTCPFXParm")
	end
end

--- Get Tempo Time Sig Marker. Wraps GetTempoTimeSigMarker.
-- Get information about a tempo/time signature marker. See
-- CountTempoTimeSigMarkers, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
--- @within ReaScript Wrapped Methods
--- @param pt_idx number
--- @return number time_pos
--- @return number measure_pos
--- @return number beat_pos
--- @return number bpm
--- @return number time_sig_num
--- @return number time_sig_denom
--- @return boolean linear_tempo
function Project:get_tempo_time_sig_marker(pt_idx)
	local ret_val, time_pos, measure_pos, beat_pos, bpm, time_sig_num, time_sig_denom, linear_tempo =
		r.GetTempoTimeSigMarker(self.pointer, pt_idx)
	if ret_val then
		return time_pos, measure_pos, beat_pos, bpm, time_sig_num, time_sig_denom, linear_tempo
	else
		error("Error in GetTempoTimeSigMarker")
	end
end

--- Get Track. Wraps GetTrack.
-- get a track from a project by track count (zero-based) (proj=0 for active
-- project)
--- @within ReaScript Wrapped Methods
--- @param track_idx number
--- @return table Track object
function Project:get_track(track_idx)
	local Track = require("track")
	local result = r.GetTrack(self.pointer, track_idx)
	return Track:new(result)
end

--- Get Track Midi Note Name Ex. Wraps GetTrackMIDINoteNameEx.
-- Get note/CC name. pitch 128 for CC0 name, 129 for CC1 name, etc. See
-- SetTrackMIDINoteNameEx
--- @within ReaScript Wrapped Methods
--- @param track table Track object
--- @param pitch number
--- @param chan number
--- @return string
function Project:get_track_midi_note_name_ex(track, pitch, chan)
	return r.GetTrackMIDINoteNameEx(self.pointer, track.pointer, pitch, chan)
end

--- Get Track Midi Note Range. Wraps GetTrackMIDINoteRange.
--- @within ReaScript Wrapped Methods
--- @param track table Track object
--- @return number note_lo
--- @return number note_hi
function Project:get_track_midi_note_range(track)
	return r.GetTrackMIDINoteRange(self.pointer, track.pointer)
end

--- Go To Marker. Wraps GoToMarker.
-- Go to marker. If use_timeline_order==true, marker_index 1 refers to the first
-- marker on the timeline.  If use_timeline_order==false, marker_index 1 refers to
-- the first marker with the user-editable index of 1.
--- @within ReaScript Wrapped Methods
--- @param marker_index number
--- @param use_timeline_order boolean
function Project:go_to_marker(marker_index, use_timeline_order)
	return r.GoToMarker(self.pointer, marker_index, use_timeline_order)
end

--- Go To Region. Wraps GoToRegion.
-- Seek to region after current region finishes playing (smooth seek). If
-- use_timeline_order==true, region_index 1 refers to the first region on the
-- timeline.  If use_timeline_order==false, region_index 1 refers to the first
-- region with the user-editable index of 1.
--- @within ReaScript Wrapped Methods
--- @param region_index number
--- @param use_timeline_order boolean
function Project:go_to_region(region_index, use_timeline_order)
	return r.GoToRegion(self.pointer, region_index, use_timeline_order)
end

--- Has Track Midi Programs. Wraps HasTrackMIDIProgramsEx.
-- returns name of track plugin that is supplying MIDI programs,or NULL if there is none
--- @within ReaScript Wrapped Methods
--- @param track table Track object
--- @return string
function Project:has_track_midi_programs(track)
	return r.HasTrackMIDIProgramsEx(self.pointer, track.pointer)
end

--- Insert Track In Project. Wraps InsertTrackInProject.
-- inserts a track in project proj at idx, this will be clamped to
-- 0..CountTracks(proj). flags&1 for default envelopes/FX, otherwise no enabled
-- fx/envelopes will be added.
--- @within ReaScript Wrapped Methods
--- @param idx number
--- @param flags number
function Project:insert_track_in_project(idx, flags)
	return r.InsertTrackInProject(self.pointer, idx, flags)
end

--- Is Project Dirty. Wraps IsProjectDirty.
-- Is the project dirty (needing save)? Always returns 0 if 'undo/prompt to save'
-- is disabled in preferences.
--- @within ReaScript Wrapped Methods
--- @return number
function Project:is_project_dirty()
	return r.IsProjectDirty(self.pointer)
end

--- On Arrow. Wraps Loop_OnArrow.
-- Move the loop selection left or right. Returns true if snap is enabled.
--- @within ReaScript Wrapped Methods
--- @param direction number
--- @return boolean
function Project:on_arrow(direction)
	return r.Loop_OnArrow(self.pointer, direction)
end

--- Save Project. Wraps Main_SaveProject.
-- Save the project.
--- @within ReaScript Wrapped Methods
--- @param force_save_as_in boolean
function Project:save_project(force_save_as_in)
	return r.Main_SaveProject(self.pointer, force_save_as_in)
end

--- Save Project Ex. Wraps Main_SaveProjectEx.
-- Save the project. options: &1=save selected tracks as track template, &2=include
-- media with track template, &4=include envelopes with track template. See
-- Main_openProject, Main_SaveProject.
--- @within ReaScript Wrapped Methods
--- @param file_name string
--- @param options number
function Project:save_project_ex(file_name, options)
	return r.Main_SaveProjectEx(self.pointer, file_name, options)
end

--- Mark Project Dirty. Wraps MarkProjectDirty.
-- Marks project as dirty (needing save) if 'undo/prompt to save' is enabled in preferences.
--- @within ReaScript Wrapped Methods
function Project:mark_project_dirty()
	return r.MarkProjectDirty(self.pointer)
end

--- Get Play Rate. Wraps Master_GetPlayRate.
--- @within ReaScript Wrapped Methods
--- @return number
function Project:get_play_rate()
	return r.Master_GetPlayRate(self.pointer)
end

--- On Pause Button Ex. Wraps OnPauseButtonEx.
-- direct way to simulate pause button hit
--- @within ReaScript Wrapped Methods
function Project:on_pause_button_ex()
	return r.OnPauseButtonEx(self.pointer)
end

--- On Play Button Ex. Wraps OnPlayButtonEx.
-- direct way to simulate play button hit
--- @within ReaScript Wrapped Methods
function Project:on_play_button_ex()
	return r.OnPlayButtonEx(self.pointer)
end

--- On Stop Button Ex. Wraps OnStopButtonEx.
-- direct way to simulate stop button hit
--- @within ReaScript Wrapped Methods
function Project:on_stop_button_ex()
	return r.OnStopButtonEx(self.pointer)
end

--- Select All Media Items. Wraps SelectAllMediaItems.
--- @within ReaScript Wrapped Methods
--- @param selected boolean
function Project:select_all_media_items(selected)
	return r.SelectAllMediaItems(self.pointer, selected)
end

--- Select Project Instance. Wraps SelectProjectInstance.
--- @within ReaScript Wrapped Methods
function Project:select_project_instance()
	return r.SelectProjectInstance(self.pointer)
end

--- Set Current Bpm. Wraps SetCurrentBPM.
-- set current BPM in project, set wantUndo=true to add undo point
--- @within ReaScript Wrapped Methods
--- @param bpm number
--- @param want_undo boolean
function Project:set_current_bpm(bpm, want_undo)
	return r.SetCurrentBPM(self.pointer, bpm, want_undo)
end

--- Set Edit Cur Pos2. Wraps SetEditCurPos2.
--- @within ReaScript Wrapped Methods
--- @param time number
--- @param moveview boolean
--- @param seekplay boolean
function Project:set_edit_cur_pos2(time, moveview, seekplay)
	return r.SetEditCurPos2(self.pointer, time, moveview, seekplay)
end

--- Set Midi Editor Grid. Wraps SetMIDIEditorGrid.
-- Set the MIDI editor grid division. 0.25=quarter note, 1.0/3.0=half note tripet,
-- etc.
--- @within ReaScript Wrapped Methods
--- @param division number
function Project:set_midi_editor_grid(division)
	return r.SetMIDIEditorGrid(self.pointer, division)
end

--- Set Project Grid. Wraps SetProjectGrid.
-- Set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note
-- triplet, etc.
--- @within ReaScript Wrapped Methods
--- @param division number
function Project:set_project_grid(division)
	return r.SetProjectGrid(self.pointer, division)
end

--- Set Project Marker2. Wraps SetProjectMarker2.
-- Note: this function can't clear a marker's name (an empty string will leave the
-- name unchanged), see SetProjectMarker4.
--- @within ReaScript Wrapped Methods
--- @param markr_rgn_idx number
--- @param is_rgn boolean
--- @param pos number
--- @param rgn_end number
--- @param name string
--- @return boolean
function Project:set_project_marker2(markr_rgn_idx, is_rgn, pos, rgn_end, name)
	return r.SetProjectMarker2(self.pointer, markr_rgn_idx, is_rgn, pos, rgn_end, name)
end

--- Set Project Marker3. Wraps SetProjectMarker3.
-- Note: this function can't clear a marker's name (an empty string will leave the
-- name unchanged), see SetProjectMarker4.
--- @within ReaScript Wrapped Methods
--- @param markr_rgn_idx number
--- @param is_rgn boolean
--- @param pos number
--- @param rgn_end number
--- @param name string
--- @param color number
--- @return boolean
function Project:set_project_marker3(markr_rgn_idx, is_rgn, pos, rgn_end, name, color)
	return r.SetProjectMarker3(self.pointer, markr_rgn_idx, is_rgn, pos, rgn_end, name, color)
end

--- Set Project Marker4. Wraps SetProjectMarker4.
-- color should be 0 to not change, or ColorToNative(r,g,b)|0x1000000, flags&1 to
-- clear name
--- @within ReaScript Wrapped Methods
--- @param markr_rgn_idx number
--- @param is_rgn boolean
--- @param pos number
--- @param rgn_end number
--- @param name string
--- @param color number
--- @param flags number
--- @return boolean
function Project:set_project_marker4(markr_rgn_idx, is_rgn, pos, rgn_end, name, color, flags)
	return r.SetProjectMarker4(self.pointer, markr_rgn_idx, is_rgn, pos, rgn_end, name, color, flags)
end

--- Set Project Marker By Index. Wraps SetProjectMarkerByIndex.
-- See SetProjectMarkerByIndex2.
--- @within ReaScript Wrapped Methods
--- @param mark_rgn_idx number
--- @param is_rgn boolean
--- @param pos number
--- @param rgn_end number
--- @param id_num number
--- @param name string
--- @param color number
--- @return boolean
function Project:set_project_marker_by_index(mark_rgn_idx, is_rgn, pos, rgn_end, id_num, name, color)
	return r.SetProjectMarkerByIndex(self.pointer, mark_rgn_idx, is_rgn, pos, rgn_end, id_num, name, color)
end

--- Set Project Marker By Index2. Wraps SetProjectMarkerByIndex2.
-- Differs from SetProjectMarker4 in that mark_rgn_idx is 0 for the first
-- marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than
-- representing the displayed marker/region ID number (see SetProjectMarker3).
-- Function will fail if attempting to set a duplicate ID number for a region
-- (duplicate ID numbers for markers are OK).flags&1 to clear name. If flags&2,
-- markers will not be re-sorted, and after making updates, you MUST call
-- SetProjectMarkerByIndex2 with mark_rgn_idx=-1 and flags&2 to force re-sort/UI
-- updates.
--- @within ReaScript Wrapped Methods
--- @param mark_rgn_idx number
--- @param is_rgn boolean
--- @param pos number
--- @param rgn_end number
--- @param id_num number
--- @param name string
--- @param color number
--- @param flags number
--- @return boolean
function Project:set_project_marker_by_index2(mark_rgn_idx, is_rgn, pos, rgn_end, id_num, name, color, flags)
	return r.SetProjectMarkerByIndex2(self.pointer, mark_rgn_idx, is_rgn, pos, rgn_end, id_num, name, color, flags)
end

--- Set Proj Ext State. Wraps SetProjExtState.
-- Save a key/value pair for a specific extension, to be restored the next time
-- this specific project is loaded. Typically extname will be the name of a
-- reascript or extension section. If key is NULL or "", all extended data for that
-- extname will be deleted.  If val is NULL or "", the data previously associated
-- with that key will be deleted. Returns the size of the state for this extname.
-- See GetProjExtState, EnumProjExtState.
--- @within ReaScript Wrapped Methods
--- @param ext_name string
--- @param key string
--- @param value string
--- @return number
function Project:set_proj_ext_state(ext_name, key, value)
	return r.SetProjExtState(self.pointer, ext_name, key, value)
end

--- Set Region Render Matrix. Wraps SetRegionRenderMatrix.
-- Add (flag > 0) or remove (flag < 0) a track from this region when using the
-- region render matrix. If adding, flag==2 means force mono, flag==4 means force
-- stereo, flag==N means force N/2 channels.
--- @within ReaScript Wrapped Methods
--- @param region_idx number
--- @param track table Track object
--- @param flag number
function Project:set_region_render_matrix(region_idx, track, flag)
	return r.SetRegionRenderMatrix(self.pointer, region_idx, track.pointer, flag)
end

--- Set Tempo Time Sig Marker. Wraps SetTempoTimeSigMarker.
-- Set parameters of a tempo/time signature marker. Provide either time_pos (with
-- measure_pos=-1, beat_pos=-1), or measure_pos and beat_pos (with time_pos=-1). If
-- time_sig_num and time_sig_denom are zero, the previous time signature will be
-- used. pt_idx=-1 will insert a new tempo/time signature marker. See
-- CountTempoTimeSigMarkers, GetTempoTimeSigMarker, AddTempoTimeSigMarker.
--- @within ReaScript Wrapped Methods
--- @param pt_idx number
--- @param time_pos number
--- @param measure_pos number
--- @param beat_pos number
--- @param bpm number
--- @param time_sig_num number
--- @param time_sig_denom number
--- @param linear_tempo boolean
--- @return boolean
function Project:set_tempo_time_sig_marker(
	pt_idx,
	time_pos,
	measure_pos,
	beat_pos,
	bpm,
	time_sig_num,
	time_sig_denom,
	linear_tempo
)
	return r.SetTempoTimeSigMarker(
		self.pointer,
		pt_idx,
		time_pos,
		measure_pos,
		beat_pos,
		bpm,
		time_sig_num,
		time_sig_denom,
		linear_tempo
	)
end

--- Set Track Midi Note Name Ex. Wraps SetTrackMIDINoteNameEx.
-- channel < 0 assigns note name to all channels. pitch 128 assigns name for CC0,
-- pitch 129 for CC1, etc.
--- @within ReaScript Wrapped Methods
--- @param track table Track object
--- @param pitch number
--- @param chan number
--- @param name string
--- @return boolean
function Project:set_track_midi_note_name_ex(track, pitch, chan, name)
	return r.SetTrackMIDINoteNameEx(self.pointer, track.pointer, pitch, chan, name)
end

--- Snap To Grid. Wraps SnapToGrid.
--- @within ReaScript Wrapped Methods
--- @param time_pos number
--- @return number
function Project:snap_to_grid(time_pos)
	return r.SnapToGrid(self.pointer, time_pos)
end

--- Beats To Time. Wraps TimeMap2_beatsToTime.
-- convert a beat position (or optionally a beats+measures if measures is non-NULL)
-- to time.
--- @within ReaScript Wrapped Methods
--- @param tpos number
--- @param measures integer Optional
--- @return number
function Project:beats_to_time(tpos, measures)
	local measures = measures or nil
	return r.TimeMap2_beatsToTime(self.pointer, tpos, measures)
end

--- Get Divided Bpm At Time. Wraps TimeMap2_GetDividedBpmAtTime.
-- get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
--- @within ReaScript Wrapped Methods
--- @param time number
--- @return number
function Project:get_divided_bpm_at_time(time)
	return r.TimeMap2_GetDividedBpmAtTime(self.pointer, time)
end

--- Get Next Change Time. Wraps TimeMap2_GetNextChangeTime.
-- when does the next time map (tempo or time sig) change occur
--- @within ReaScript Wrapped Methods
--- @param time number
--- @return number
function Project:get_next_change_time(time)
	return r.TimeMap2_GetNextChangeTime(self.pointer, time)
end

--- Qn To Time. Wraps TimeMap2_QNToTime.
-- converts project QN position to time.
--- @within ReaScript Wrapped Methods
--- @param qn number
--- @return number
function Project:qn_to_time(qn)
	return r.TimeMap2_QNToTime(self.pointer, qn)
end

--- Time To Beats. Wraps TimeMap2_timeToBeats.
-- convert a time into beats. if measures is non-NULL, measures will be set to the
-- measure count, return value will be beats since measure. if cml is non-NULL,
-- will be set to current measure length in beats (i.e. time signature numerator)
-- if full_beats is non-NULL, and measures is non-NULL, full_bats will get the full
-- beat count (same value returned if measures is NULL). if cdenom is non-NULL,
-- will be set to the current time signature denominator.
--- @within ReaScript Wrapped Methods
--- @param tpos number
--- @return number measures
--- @return number cml
--- @return number full_beats
--- @return number cdenom
function Project:time_to_beats(tpos)
	local ret_val, measures, cml, full_beats, cdenom = r.TimeMap2_timeToBeats(self.pointer, tpos)
	if ret_val then
		return measures, cml, full_beats, cdenom
	else
		error("Error in Project:time_to_beats")
	end
end

--- Time To Qn. Wraps TimeMap2_timeToQN.
-- converts project time position to QN position.
--- @within ReaScript Wrapped Methods
--- @param tpos number
--- @return number
function Project:time_to_qn(tpos)
	return r.TimeMap2_timeToQN(self.pointer, tpos)
end

--- Cur Frame Rate. Wraps TimeMap_curFrameRate.
-- Gets project framerate, and optionally whether it is drop-frame timecode
--- @within ReaScript Wrapped Methods
--- @return boolean drop_frame
function Project:cur_frame_rate()
	local ret_val, drop_frame = r.TimeMap_curFrameRate(self.pointer)
	if ret_val then
		return drop_frame
	else
		error("Error in Project:cur_frame_rate")
	end
end

--- Get Measure Info. Wraps TimeMap_GetMeasureInfo.
-- Get the QN position and time signature information for the start of a measure.
-- Return the time in seconds of the measure start.
--- @within ReaScript Wrapped Methods
--- @param measure number
--- @return number qn_start
--- @return number qn_end
--- @return number num
--- @return number time_sig_denom
--- @return number tempo
function Project:get_measure_info(measure)
	local ret_val, qn_start, qn_end, num, time_sig_denom, tempo = r.TimeMap_GetMeasureInfo(self.pointer, measure)
	if ret_val then
		return qn_start, qn_end, num, time_sig_denom, tempo
	else
		error("Error in Project:get_measure_info")
	end
end

--- Get Metronome Pattern. Wraps TimeMap_GetMetronomePattern.
-- Fills in a string representing the active metronome pattern. For example, in a
-- 7/8 measure divided 3+4, the pattern might be "1221222". The length of the
-- string is the time signature numerator, and the function returns the time
-- signature denominator.
--- @within ReaScript Wrapped Methods
--- @param time number
--- @param pattern string
--- @return string pattern
function Project:get_metronome_pattern(time, pattern)
	local ret_val, pattern = r.TimeMap_GetMetronomePattern(self.pointer, time, pattern)
	if ret_val then
		return pattern
	else
		error("Error in Project:get_metronome_pattern")
	end
end

--- Get Time Sig At Time. Wraps TimeMap_GetTimeSigAtTime.
-- get the effective time signature and tempo
--- @within ReaScript Wrapped Methods
--- @param time number
--- @return number num
--- @return number time_sig_denom
--- @return number tempo
function Project:get_time_sig_at_time(time)
	return r.TimeMap_GetTimeSigAtTime(self.pointer, time)
end

--- Qn To Measures. Wraps TimeMap_QNToMeasures.
-- Find which measure the given QN position falls in.
--- @within ReaScript Wrapped Methods
--- @param qn number
--- @return number qn_measure_start
--- @return number qn_measure_end
function Project:qn_to_measures(qn)
	local ret_val, qn_measure_start, qn_measure_end = r.TimeMap_QNToMeasures(self.pointer, qn)
	if ret_val then
		return qn_measure_start, qn_measure_end
	else
		error("Error in Project:qn_to_measures")
	end
end

--- Qn To Time Abs. Wraps TimeMap_QNToTime_abs.
-- Converts project quarter note count (QN) to time. QN is counted from the start
-- of the project, regardless of any partial measures. See TimeMap2_QNToTime
--- @within ReaScript Wrapped Methods
--- @param qn number
--- @return number
function Project:qn_to_time_abs(qn)
	return r.TimeMap_QNToTime_abs(self.pointer, qn)
end

--- Time To Qn Abs. Wraps TimeMap_timeToQN_abs.
-- Converts project time position to quarter note count (QN). QN is counted from
-- the start of the project, regardless of any partial measures. See
-- TimeMap2_timeToQN
--- @within ReaScript Wrapped Methods
--- @param tpos number
--- @return number
function Project:time_to_qn_abs(tpos)
	return r.TimeMap_timeToQN_abs(self.pointer, tpos)
end

--- Undo Begin Block2. Wraps Undo_BeginBlock2.
-- call to start a new block
--- @within ReaScript Wrapped Methods
function Project:undo_begin_block2()
	return r.Undo_BeginBlock2(self.pointer)
end

--- Undo Can Redo2. Wraps Undo_CanRedo2.
-- returns string of next action,if able, NULL if not
--- @within ReaScript Wrapped Methods
--- @return string
function Project:undo_can_redo2()
	return r.Undo_CanRedo2(self.pointer)
end

--- Undo Can Undo2. Wraps Undo_CanUndo2.
-- returns string of last action,if able,NULL if not
--- @within ReaScript Wrapped Methods
--- @return string
function Project:undo_can_undo2()
	return r.Undo_CanUndo2(self.pointer)
end

--- Undo Do Redo2. Wraps Undo_DoRedo2.
-- nonzero if success
--- @within ReaScript Wrapped Methods
--- @return number
function Project:undo_do_redo2()
	return r.Undo_DoRedo2(self.pointer)
end

--- Undo Do Undo2. Wraps Undo_DoUndo2.
-- nonzero if success
--- @within ReaScript Wrapped Methods
--- @return number
function Project:undo_do_undo2()
	return r.Undo_DoUndo2(self.pointer)
end

--- Undo End Block2. Wraps Undo_EndBlock2.
-- call to end the block,with extra flags if any,and a description
--- @within ReaScript Wrapped Methods
--- @param desc_change string
--- @param extraflags number
function Project:undo_end_block2(desc_change, extraflags)
	return r.Undo_EndBlock2(self.pointer, desc_change, extraflags)
end

--- Undo On State Change2. Wraps Undo_OnStateChange2.
-- limited state change to items
--- @within ReaScript Wrapped Methods
--- @param desc_change string
function Project:undo_on_state_change2(desc_change)
	return r.Undo_OnStateChange2(self.pointer, desc_change)
end

--- Undo On State Change Item. Wraps Undo_OnStateChange_Item.
--- @within ReaScript Wrapped Methods
--- @param name string
--- @param item table Item object
function Project:undo_on_state_change_item(name, item)
	return r.Undo_OnStateChange_Item(self.pointer, name, item.pointer)
end

--- Undo On State Change Ex2. Wraps Undo_OnStateChangeEx2.
-- track_param=-1 by default,or if updating one fx chain,you can specify track index
--- @within ReaScript Wrapped Methods
--- @param desc_change string
--- @param which_state number
--- @param track_param number
function Project:undo_on_state_change_ex2(desc_change, which_state, track_param)
	return r.Undo_OnStateChangeEx2(self.pointer, desc_change, which_state, track_param)
end

--- Update Item Lanes. Wraps UpdateItemLanes.
-- Recalculate lane arrangement for fixed lane tracks, including auto-removing
-- empty lanes at the bottom of the track
--- @within ReaScript Wrapped Methods
--- @return boolean
function Project:update_item_lanes()
	return r.UpdateItemLanes(self.pointer)
end

--- Validate Pointer. Wraps ValidatePtr2.
-- Return true if the pointer is a valid object of the right type in proj (proj is
-- ignored if pointer is itself a project). Supported types are: ReaProject*,
-- MediaTrack*, MediaItem*, MediaItem_Take*, TrackEnvelope* and PCM_source*.
--- @within ReaScript Wrapped Methods
--- @param identifier userdata
--- @param ctype_name string
--- @return boolean
function Project:validate_ptr(identifier, ctype_name)
	return r.ValidatePtr2(self.pointer, identifier, ctype_name)
end

--- Get Media Item By Guid. Wraps BR_GetMediaItemByGUID.
-- [BR] Get media item from GUID string. Note that the GUID must be enclosed in
-- braces {}. To get item's GUID as a string, see BR_GetMediaItemGUID.
--- @within ReaScript Wrapped Methods
--- @param guid_string_in string
--- @return table Item object
function Project:get_media_item_by_guid(guid_string_in)
	local Item = require("item")
	local result = r.BR_GetMediaItemByGUID(self.pointer, guid_string_in)
	return Item:new(result)
end

--- Get Media Track By Guid. Wraps BR_GetMediaTrackByGUID.
-- [BR] Get media track from GUID string. Note that the GUID must be enclosed in
-- braces {}. To get track's GUID as a string, see GetSetMediaTrackInfo_String.
--- @within ReaScript Wrapped Methods
--- @param guid_string_in string
--- @return table Track object
function Project:get_media_track_by_guid(guid_string_in)
	local Track = require("track")
	local result = r.BR_GetMediaTrackByGUID(self.pointer, guid_string_in)
	return Track:new(result)
end

--- Get Sws Extra Project Notes. Wraps JB_GetSWSExtraProjectNotes.
--- @within ReaScript Wrapped Methods
--- @return string
function Project:get_sws_extra_project_notes()
	return r.JB_GetSWSExtraProjectNotes(self.pointer)
end

--- Set Sws Extra Project Notes. Wraps JB_SetSWSExtraProjectNotes.
--- @within ReaScript Wrapped Methods
--- @param str string
function Project:set_sws_extra_project_notes(str)
	return r.JB_SetSWSExtraProjectNotes(self.pointer, str)
end

--- Get Double Config Var Ex. Wraps SNM_GetDoubleConfigVarEx.
-- [S&M] See SNM_GetDoubleConfigVar.
--- @within ReaScript Wrapped Methods
--- @param var_name string
--- @param err_value number
--- @return number
function Project:get_double_config_var_ex(var_name, err_value)
	return r.SNM_GetDoubleConfigVarEx(self.pointer, var_name, err_value)
end

--- Get Int Config Var Ex. Wraps SNM_GetIntConfigVarEx.
-- [S&M] See SNM_GetIntConfigVar.
--- @within ReaScript Wrapped Methods
--- @param var_name string
--- @param err_value number
--- @return number
function Project:get_int_config_var_ex(var_name, err_value)
	return r.SNM_GetIntConfigVarEx(self.pointer, var_name, err_value)
end

--- Get Long Config Var Ex. Wraps SNM_GetLongConfigVarEx.
-- [S&M] See SNM_GetLongConfigVar.
--- @within ReaScript Wrapped Methods
--- @param var_name string
--- @return number high
--- @return number low
function Project:get_long_config_var_ex(var_name)
	local ret_val, high, low = r.SNM_GetLongConfigVarEx(self.pointer, var_name)
	if ret_val then
		return high, low
	else
		error("Error in GetLongConfigVarEx")
	end
end

--- Get Project Marker Name. Wraps SNM_GetProjectMarkerName.
-- [S&M] Gets a marker/region name. Returns true if marker/region found.
--- @within ReaScript Wrapped Methods
--- @param num number
--- @param is_rgn boolean
--- @param name userdata WDL_FastString
--- @return boolean
function Project:get_project_marker_name(num, is_rgn, name)
	return r.SNM_GetProjectMarkerName(self.pointer, num, is_rgn, name)
end

--- Set Double Config Var Ex. Wraps SNM_SetDoubleConfigVarEx.
-- [S&M] See SNM_SetDoubleConfigVar.
--- @within ReaScript Wrapped Methods
--- @param var_name string
--- @param new_value number
--- @return boolean
function Project:set_double_config_var_ex(var_name, new_value)
	return r.SNM_SetDoubleConfigVarEx(self.pointer, var_name, new_value)
end

--- Set Int Config Var Ex. Wraps SNM_SetIntConfigVarEx.
-- [S&M] See SNM_SetIntConfigVar.
--- @within ReaScript Wrapped Methods
--- @param var_name string
--- @param new_value number
--- @return boolean
function Project:set_int_config_var_ex(var_name, new_value)
	return r.SNM_SetIntConfigVarEx(self.pointer, var_name, new_value)
end

--- Set Long Config Var Ex. Wraps SNM_SetLongConfigVarEx.
-- [S&M] SNM_SetLongConfigVar.
--- @within ReaScript Wrapped Methods
--- @param var_name string
--- @param new_high_value number
--- @param new_low_value number
--- @return boolean
function Project:set_long_config_var_ex(var_name, new_high_value, new_low_value)
	return r.SNM_SetLongConfigVarEx(self.pointer, var_name, new_high_value, new_low_value)
end

return Project
