---@description Provide implementation of the class Reaper
---@author NomadMonad

local helpers = require('modules.helpers')
local constants = require('modules.constants')

local r = reaper

Reaper = {}

-- New instance of class Reaper
function Reaper:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Reaper:_tostring()
    return 'ReaWrap'
end

--[[
    Print message(s) to Reaper console.
    Accepts a variable number of arguments that will be printed as a comma
    separated string.
--]]
---@param {...} string
function Reaper:print(...)
    printer = helpers:print_func()
    printer(...)
end

--[[
    Log messages(s) to Reaper console.
    Accepts a variable number of arguments that will be logged as a
    timestamped comma separated string.
--]]
---@param {...} variable number of arguments
function Reaper:log(...)
    logger = helpers.log_func('Reaper')
    logger(...)
end

-- Show a Message Box dialogue.
---@param msg string
---@param title string
---@param type number : Accepted values : constants.MsgBoxTypes
---@return number : Expected values : constants.MsgBoxReturnTypes
function Reaper:msg_box(msg, title, type)
	type = type or constants.MsgBoxTypes.OK
	return helpers.msg_box(msg, title, type)
end

-- Execute function within an undo context block
---@param description : string : a description of the action to undo
---@param func function : the function to call
---@param {...} : variable number of arguments to func
function Reaper:undo(description)
    return function(func, ...)
        self:undo_begin_block()
        func(...)
        self:undo_end_block(description, -1)
    end
end

-- Execute function within a prevent refresh context block
---@param func function : the function to call
---@param {...} : variable number of arguments to func
function Reaper:prevent_refresh()
    return function(func, ...)
        self:prevent_ui_refresh(1)
        func(...)
        self:prevent_ui_refresh(-1)
    end
end

-- Apply Track/Take FX to selected item.
--[[
        Accepted values:
        0 = stereo output (default)
        1 = mono output
        2 = multi output
        3 = MIDI
--]]
function Reaper:apply_fx(opt)
    opt = opt or 0
    if opt == 0 then
        self:main_on_command(40209, 0) -- stereo output
    elseif opt == 1 then
        self:main_on_command(40361, 0) -- mono output
    elseif opt == 2 then
        self:main_on_command(41993, 0) -- multi output
    elseif opt == 3 then
        self:main_on_command(40436, 0) -- MIDI output
    end
end

-- Wrapped ReaScript functions
--------------------------------------------------------------------------------

-- Returns true if function_name exists in the REAPER API
---@param function_name string
---@return boolean 
function Reaper:api_exists(function_name)
    return r.APIExists(function_name)
end

-- Displays a message window if the API was successfully called.
function Reaper:api_test()
    return r.APITest()
end

--[[
    Add a ReaScript (return the new command ID, or 0 if failed) or remove a ReaScript (return >0 on success).
    Use commit==true when adding/removing a single script. When bulk adding/removing n scripts,
    you can optimize the n-1 first calls with commit==false and commit==true for the last call.
--]]
---@param add boolean
---@param section_id number
---@param script_fn string
---@param commit boolean
---@return number 
function Reaper:add_remove_rea_script(add, section_id, script_fn, commit)
    return r.AddRemoveReaScript(add, section_id, script_fn, commit)
end

-- force_set=0,doupd=true,center_mode=-1 for default
---@param amt number
---@param force_set number
---@param doupd boolean
---@param center_mode number
function Reaper:adjust_zoom(amt, force_set, doupd, center_mode)
    return r.adjustZoom(amt, force_set, doupd, center_mode)
end

-- arms a command (or disarms if 0 passed) in section section_name (empty string for main)
---@param cmd number
---@param section_name string
function Reaper:arm_command(cmd, section_name)
	return r.ArmCommand(cmd, section_name)
end 

-- Adds code to be executed when the script finishes or is ended by the user.
-- Typically used to clean up after the user terminates defer() or runloop() code.
---@param retval function
function Reaper:atexit(retval)
    return r.atexit(retval)
end

-- open all audio and MIDI devices, if not open
function Reaper:audio_init()
    return r.Audio_Init()
end

-- is in pre-buffer? threadsafe
---@return number 
function Reaper:audio_is_pre_buffer()
    return r.Audio_IsPreBuffer()
end

-- is audio running at all? threadsafe
---@return number 
function Reaper:audio_is_running()
    return r.Audio_IsRunning()
end

-- close all audio and MIDI devices, if open
function Reaper:audio_quit()
    return r.Audio_Quit()
end

--[[
    Returns true if the underlying samples (track or media item take) have changed, but does not update the audio accessor,
    so the user can selectively call AudioAccessorValidateState only when needed.
    See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, GetAudioAccessorEndTime, GetAudioAccessorSamples.
--]]
---@param accessor userdata AudioAccessor
---@return boolean 
function Reaper:audio_accessor_state_changed(accessor)
    return r.AudioAccessorStateChanged(accessor)
end

--[[
    Force the accessor to reload its state from the underlying track or media item take.
    See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged,
    GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
--]]
---@param accessor userdata AudioAccessor
function Reaper:audio_accessor_update(accessor)
    return r.AudioAccessorUpdate(accessor)
end

-- Validates the current state of the audio accessor -- must ONLY call this from the main thread. Returns true if the state changed.
---@param accessor userdata AudioAccessor
---@return boolean 
function Reaper:audio_accessor_validate_state(accessor)
    return r.AudioAccessorValidateState(accessor)
end

-- -1 = bypass all if not all bypassed,otherwise unbypass all
---@param bypass number
function Reaper:bypass_fx_all_tracks(bypass)
    return r.BypassFxAllTracks(bypass)
end

-- call this to force flushing of the undo states after using CSurf_On*Change()
---@param force boolean
function Reaper:c_surf_flush_undo(force)
    return r.CSurf_FlushUndo(force)
end

function Reaper:c_surf_go_end()
    return r.CSurf_GoEnd()
end

function Reaper:c_surf_go_start()
    return r.CSurf_GoStart()
end

---@param mcp_view boolean
---@return number 
function Reaper:c_surf_num_tracks(mcp_view)
    return r.CSurf_NumTracks(mcp_view)
end

---@param which_dir number
---@param want_zoom boolean
function Reaper:c_surf_on_arrow(which_dir, want_zoom)
    return r.CSurf_OnArrow(which_dir, want_zoom)
end

---@param seek_play number
function Reaper:c_surf_on_fwd(seek_play)
    return r.CSurf_OnFwd(seek_play)
end

function Reaper:c_surf_on_pause()
    return r.CSurf_OnPause()
end

function Reaper:c_surf_on_play()
    return r.CSurf_OnPlay()
end

---@param play_rate number
function Reaper:c_surf_on_play_rate_change(play_rate)
    return r.CSurf_OnPlayRateChange(play_rate)
end

function Reaper:c_surf_on_record()
    return r.CSurf_OnRecord()
end

---@param seek_play number
function Reaper:c_surf_on_rew(seek_play)
    return r.CSurf_OnRew(seek_play)
end

---@param seek_play number
---@param dir number
function Reaper:c_surf_on_rew_fwd(seek_play, dir)
    return r.CSurf_OnRewFwd(seek_play, dir)
end

---@param x_dir number
---@param y_dir number
function Reaper:c_surf_on_scroll(x_dir, y_dir)
    return r.CSurf_OnScroll(x_dir, y_dir)
end

function Reaper:c_surf_on_stop()
    return r.CSurf_OnStop()
end

---@param bpm number
function Reaper:c_surf_on_tempo_change(bpm)
    return r.CSurf_OnTempoChange(bpm)
end

---@param x_dir number
---@param y_dir number
function Reaper:c_surf_on_zoom(x_dir, y_dir)
    return r.CSurf_OnZoom(x_dir, y_dir)
end

function Reaper:c_surf_reset_all_cached_vol_pan_states()
    return r.CSurf_ResetAllCachedVolPanStates()
end

---@param amt number
function Reaper:c_surf_scrub_amt(amt)
    return r.CSurf_ScrubAmt(amt)
end

---@param mode number
---@param ignore_surf userdata IReaperControlSurface
function Reaper:c_surf_set_auto_mode(mode, ignore_surf)
    return r.CSurf_SetAutoMode(mode, ignore_surf)
end

---@param play boolean
---@param pause boolean
---@param rec boolean
---@param ignore_surf userdata IReaperControlSurface
function Reaper:c_surf_set_play_state(play, pause, rec, ignore_surf)
    return r.CSurf_SetPlayState(play, pause, rec, ignore_surf)
end

---@param rep boolean
---@param ignore_surf userdata IReaperControlSurface
function Reaper:c_surf_set_repeat_state(rep, ignore_surf)
    return r.CSurf_SetRepeatState(rep, ignore_surf)
end

function Reaper:c_surf_set_track_list_change()
    return r.CSurf_SetTrackListChange()
end

---@param idx number
---@param mcp_view boolean
---@return userdata Track
function Reaper:c_surf_track_from_id(idx, mcp_view)
    return Track:new(r.CSurf_TrackFromID(idx, mcp_view))
end

function Reaper:clear_all_rec_armed()
    return r.ClearAllRecArmed()
end

-- Clear the ReaScript console. See ShowConsoleMsg
function Reaper:clear_console()
    return r.ClearConsole()
end

-- resets the global peak caches
function Reaper:clear_peak_cache()
    return r.ClearPeakCache()
end

-- Extract RGB values from an OS dependent color. See ColorToNative.
---@param col number
---@return number, number, number 
function Reaper:color_from_native(col)
    return r.ColorFromNative(col)
end

-- Make an OS dependent color from RGB values (e.g. RGB() macro on Windows). r,g and b are in [0..255]. See ColorFromNative.
---@param r number
---@param g number
---@param b number
---@return number 
function Reaper:color_to_native(r_, g, b)
    return r.ColorToNative(r_, g, b)
end

---@param x number
---@return number 
function Reaper:db2_slider(x)
    return r.DB2SLIDER(x)
end

-- Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input,
-- while the user does other tasks. Identical to runloop().
-- Note that no undo point will be automatically created when the script finishes, unless you create it explicitly.
---@param func function
function Reaper:defer(func)
    return r.defer(func)
end

-- Delete the extended state value for a specific section and key. persist=true means the value should remain deleted the next time REAPER is opened. See SetExtState, GetExtState, HasExtState.
---@param section string
---@param key string
---@param persist boolean
function Reaper:delete_ext_state(section, key, persist)
    return r.DeleteExtState(section, key, persist)
end

-- Destroy an audio accessor. Must only call from the main thread. 
-- See CreateTakeAudioAccessor, CreateTrackAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples. 
---@param accessor userdata AudioAccessor
function Reaper:destroy_audio_accessor(accessor)
    return r.DestroyAudioAccessor(accessor)
end

-- updates preference for docker window ident_str to be in dock whichDock on next open
---@param ident_str string
---@param which_dock number
function Reaper:dock_update_dock_id(ident_str, which_dock)
    return r.Dock_UpdateDockID(ident_str, which_dock)
end

-- -1=not found, 0=bottom, 1=left, 2=top, 3=right, 4=floating
---@param which_dock number
---@return number constants.DockPosition
function Reaper:dock_get_position(which_dock)
    return r.DockGetPosition(which_dock)
end

-- returns dock index that contains userdata HWND, or -1
---@param hwnd userdata HWND
---@return boolean 
function Reaper:dock_is_child_of_dock(hwnd)
    local retval, is_floating_docker = r.DockIsChildOfDock(hwnd)
    if retval then
        return is_floating_docker
    end
end

---@param hwnd userdata HWND
function Reaper:dock_window_activate(hwnd)
    return r.DockWindowActivate(hwnd)
end

---@param hwnd userdata HWND
---@param name string
---@param pos number
---@param allow_show boolean
function Reaper:dock_window_add(hwnd, name, pos, allow_show)
    return r.DockWindowAdd(hwnd, name, pos, allow_show)
end

---@param hwnd userdata HWND
---@param name string
---@param ident string
---@param allow_show boolean
function Reaper:dock_window_add_ex(hwnd, name, ident, allow_show)
    return r.DockWindowAddEx(hwnd, name, ident, allow_show)
end

function Reaper:dock_window_refresh()
    return r.DockWindowRefresh()
end

---@param hwnd userdata HWND
function Reaper:dock_window_refresh_for_hwnd(hwnd)
    return r.DockWindowRefreshForHWND(hwnd)
end

---@param hwnd userdata HWND
function Reaper:dock_window_remove(hwnd)
    return r.DockWindowRemove(hwnd)
end

-- call with a saved window rect for your window and it'll correct any positioning info.
---@param left number
---@param top number
---@param right number
---@return number, number, number, number
function Reaper:ensure_not_completely_offscreen(left, top, right, number)
    return r.EnsureNotCompletelyOffscreen(left, top, right, number)
end

-- Start querying modes at 0, returns FALSE when no more modes possible, sets strOut to NULL if a mode is currently unsupported
---@param mode number
---@return string 
function Reaper:enum_pitch_shift_modes(mode)
    local retval, str = r.EnumPitchShiftModes(mode)
    if retval then
        return str
    end
end

-- Returns submode name, or NULL
---@param mode number
---@param submode number
---@return string 
function Reaper:enum_pitch_shift_sub_modes(mode, submode)
    return r.EnumPitchShiftSubModes(mode, submode)
end

---@param idx number
---@return boolean, number, number, string, number 
function Reaper:enum_project_markers(idx)
    local retval, is_rgn, pos, rgn_end, name, mark_rgn_idx = r.EnumProjectMarkers(idx)
    if retval then
        return is_rgn, pos, rgn_end, name, mark_rgn_idx
    end
end

-- idx=-1 for current project,proj_fn can be NULL if not interested in filename. use idx 0x40000000 for currently rendering project, if any.
---@param idx number
---@return string 
function Reaper:enum_projects(idx)
    local retval, proj_fn = r.EnumProjects(idx)
    if retval then
        return proj_fn
    end
end

-- returns false if there are no plugins on the track that support MIDI programs,or if all programs have been enumerated
---@param track number
---@param program_number number
---@param program_name string
---@return boolean, string 
function Reaper:enum_track_midi_program_names(track, program_number, program_name)
    return r.EnumTrackMIDIProgramNames(
			track, program_number, program_name
	)
end

-- List the files in the "path" directory. Returns NULL/nil when all files have been listed. 
-- Use file_idx = -1 to force re-read of directory (invalidate cache). See EnumerateSubdirectories
---@param path string
---@param file_idx number
---@return string 
function Reaper:enumerate_files(path, file_idx)
    return r.EnumerateFiles(path, file_idx)
end

-- List the subdirectories in the "path" directory. Use subdir_idx = -1 to force re-read of directory (invalidate cache). 
-- Returns NULL/nil when all subdirectories have been listed. See EnumerateFiles
---@param path string
---@param subdir_idx number
---@return string 
function Reaper:enumerate_subdirectories(path, subdir_idx)
    return r.EnumerateSubdirectories(path, subdir_idx)
end

-- Executes command line, returns NULL on total failure, otherwise the return value, a newline, and then the output of the command. 
-- If timeout_msec is 0, command will be allowed to run indefinitely (recommended for large amounts of returned output). 
-- timeout_msec is -1 for no wait/terminate, -2 for no wait and minimize
---@param cmdline string
---@param timeout_msec number
---@return string 
function Reaper:exec_process(cmdline, timeout_msec)
    return r.ExecProcess(cmdline, timeout_msec)
end

-- [FNG] Add MIDI note to MIDI take
---@param midi_take userdata RprMidiTake
---@return RprMidiNote 
function Reaper:fng_add_midi_note(midi_take)
    return r.FNG_AddMidiNote(midi_take)
end

-- [FNG] Count of how many MIDI notes are in the MIDI take
---@param midi_take userdata RprMidiTake
---@return number 
function Reaper:fng_count_midi_notes(midi_take)
    return r.FNG_CountMidiNotes(midi_take)
end

-- [FNG] Commit changes to MIDI take and free allocated memory
---@param midi_take userdata RprMidiTake
function Reaper:fng_free_midi_take(midi_take)
    return r.FNG_FreeMidiTake(midi_take)
end

-- [FNG] Get a MIDI note from a MIDI take at specified index
---@param midi_take userdata RprMidiTake
---@param index number
---@return userdata RprMidiNote 
function Reaper:fng_get_midi_note(midi_take, index)
    return r.FNG_GetMidiNote(midi_take, index)
end

-- [FNG] Get MIDI note property
---@param midi_note userdata RprMidiNote
---@param property string
---@return number 
function Reaper:fng_get_midi_note_int_property(midi_note, property)
    return r.FNG_GetMidiNoteIntProperty(midi_note, property)
end

-- [FNG] Set MIDI note property
---@param midi_note userdata RprMidiNote
---@param property string
---@param value number
function Reaper:fng_set_midi_note_int_property(midi_note, property, value)
    return r.FNG_SetMidiNoteIntProperty(midi_note, property, value)
end

-- returns true if path points to a valid, readable file
---@param path string
---@return boolean 
function Reaper:file_exists(path)
    return r.file_exists(path)
end

-- Format tpos (which is time in seconds) as hh:mm:ss.sss. See format_timestr_pos, format_timestr_len.
---@param tpos number
---@param buf string
---@return string 
function Reaper:format_timestr(tpos, buf)
    return r.format_timestr(tpos, buf)
end

-- offset is start of where the length will be calculated from
---@param tpos number
---@param buf string
---@param offset number
---@param modeoverride number
---@return string 
function Reaper:format_timestr_len(tpos, buf, offset, modeoverride)
    return r.format_timestr_len(tpos, buf, offset, modeoverride)
end

---@param tpos number
---@param buf string
---@param modeoverride number
---@return string 
function Reaper:format_timestr_pos(tpos, buf, modeoverride)
    return r.format_timestr_pos(tpos, buf, modeoverride)
end

-- Runs the system color chooser dialog.  Returns 0 if the user cancels the dialog.
---@param hwnd userdata HWND
---@return number 
function Reaper:g_r_select_color(hwnd)
    local retval, color = r.GR_SelectColor(hwnd)
    if retval then
        return color
    end
end

---@return string 
function Reaper:guid()
    return r.genGuid('')
end

-- is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()Returns contextual information about the script, typically MIDI/OSC input values.
function Reaper:get_action_context()
    return r.get_action_context()
end

-- Returns app version which may include an OS/arch signifier, such as: "6.17" (windows 32-bit), "6.17/x64" (windows 64-bit), "6.17/OSX64" (macOS 64-bit Intel), "6.17/OSX" (macOS 32-bit), "6.17/macOS-arm64", "6.17/linux-x86_64", "6.17/linux-i686", "6.17/linux-aarch64", "6.17/linux-armv7l", etc
---@return string 
function Reaper:get_app_version()
    return r.GetAppVersion()
end

-- gets the currently armed command and section name (returns 0 if nothing armed). section name is empty-string for main section.
---@return string 
function Reaper:get_armed_command()
    local retval, sec = r.GetArmedCommand()
    if retval then
        return sec
    end
end

-- Get the end time of the audio that can be returned from this accessor. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorSamples.
---@param accessor userdata AudioAccessor
---@return number 
function Reaper:get_audio_accessor_end_time(accessor)
    return r.GetAudioAccessorEndTime(accessor)
end

-- Deprecated. See AudioAccessorStateChanged instead.
---@param accessor userdata AudioAccessor
---@param hash_need128 string
---@return string 
function Reaper:get_audio_accessor_hash(accessor, hash_need128)
    return r.GetAudioAccessorHash(accessor, hash_need128)
end

---@param accessor userdata AudioAccessor
---@param samplerate number
---@param numchannels number
---@param starttime_sec number
---@param numsamplesperchannel number
---@param samplebuffer reaper.array
---@return number 
function Reaper:get_audio_accessor_samples(accessor, samplerate, numchannels, starttime_sec, numsamplesperchannel, samplebuffer)
    return r.GetAudioAccessorSamples(accessor, samplerate, numchannels, starttime_sec, numsamplesperchannel, samplebuffer)
end

-- Get the start time of the audio that can be returned from this accessor. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorEndTime, GetAudioAccessorSamples.
---@param accessor userdata AudioAccessor
---@return number 
function Reaper:get_audio_accessor_start_time(accessor)
    return r.GetAudioAccessorStartTime(accessor)
end

-- get information about the currently open audio device. attribute can be MODE, IDENT_IN, IDENT_OUT, BSIZE, SRATE, BPS. returns false if unknown attribute or device not open.
---@param attribute string
---@param desc string
---@return string 
function Reaper:get_audio_device_info(attribute, desc)
    local retval, desc_ = r.GetAudioDeviceInfo(attribute, desc)
    if retval then
        return desc_
    end
end

-- gets ini configuration variable value as string
---@param name string
---@return string 
function Reaper:get_config_var_string(name)
    local retval, buf = r.get_config_var_string(name)
    if retval then
        return buf
    end
end

-- gets the dock ID desired by ident_str, if any
---@param ident_str string
---@return number 
function Reaper:get_config_wants_dock(ident_str)
    return r.GetConfigWantsDock(ident_str)
end

-- returns current project if in load/save (usually only used from project_config_extension_t)
---@return userdata Project 
function Reaper:get_current_project_in_load_save()
    return r.GetCurrentProjectInLoadSave()
end

-- return the current cursor context: 0 if track panels, 1 if items, 2 if envelopes, otherwise unknown
---@return number 
function Reaper:get_cursor_context()
    return r.GetCursorContext()
end

-- 0 if track panels, 1 if items, 2 if envelopes, otherwise unknown (unlikely when want_last_valid is true)
---@param want_last_valid boolean
---@return number 
function Reaper:get_cursor_context2(want_last_valid)
    return r.GetCursorContext2(want_last_valid)
end

-- edit cursor position
---@return number 
function Reaper:get_cursor_position()
    return r.GetCursorPosition()
end

-- returns path of REAPER.exe (not including EXE), i.e. C:\Program Files\REAPER
---@return string 
function Reaper:get_exe_path()
    return r.GetExePath()
end

-- Get the extended state value for a specific section and key. See SetExtState, DeleteExtState, HasExtState.
---@param section string
---@param key string
---@return string 
function Reaper:get_ext_state(section, key)
    return r.GetExtState(section, key)
end

-- This function is deprecated (returns GetFocusedFX2()&3), see GetFocusedFX2.
---@return number, number, number 
function Reaper:get_focused_f_x()
    local retval, tracknumber, itemnumber, fxnumber = r.GetFocusedFX()
    if retval then
        return tracknumber, itemnumber, fxnumber
    end
end

-- Return value has 1 set if track FX, 2 if take/item FX, 4 set if FX is no longer focused but still open. tracknumber==0 means the master track, 1 means track 1, etc. itemnumber is zero-based (or -1 if not an item). For interpretation of fxnumber, see GetLastTouchedFX.
---@return number, number, number 
function Reaper:get_focused_f_x2()
    local retval, tracknumber, itemnumber, fxnumber = r.GetFocusedFX2()
    if retval then
        return tracknumber, itemnumber, fxnumber
    end
end

-- return -1=no override, 0=trim/read, 1=read, 2=touch, 3=write, 4=latch, 5=bypass
---@return number 
function Reaper:get_global_automation_override()
    return r.GetGlobalAutomationOverride()
end

-- returns pixels/second
---@return number 
function Reaper:get_h_zoom_level()
    return r.GetHZoomLevel()
end

-- Get reaper.ini full filename.
---@return string 
function Reaper:get_ini_file()
    return r.get_ini_file()
end

---@param channel_index number
---@return string 
function Reaper:get_input_channel_name(channel_index)
    return r.GetInputChannelName(channel_index)
end

-- Gets the audio device input/output latency in samples
---@return number, number 
function Reaper:get_input_output_latency()
    return r.GetInputOutputLatency()
end

-- returns time of relevant edit, set which_item to the _source (if applicable), flags (if specified) will be set to 1 for edge resizing, 2 for fade change, 4 for item move, 8 for item slip edit (edit cursor time or start of item)
---@return PCM_source, number 
function Reaper:get_item_editing_time2()
    local retval, which_item, flags = r.GetItemEditingTime2()
    if retval then
        return which_item, flags
    end
end

-- Returns the first item at the screen coordinates specified. If allow_locked is false, locked items are ignored. If takeOutOptional specified, returns the take hit.
---@param screen_x number
---@param screen_y number
---@param allow_locked boolean
---@return MediaItem_Take 
function Reaper:get_item_from_point(screen_x, screen_y, allow_locked)
    local retval, take = r.GetItemFromPoint(screen_x, screen_y, allow_locked)
    if retval then
        return take
    end
end

---@return string 
function Reaper:get_last_color_theme_file()
    return r.GetLastColorThemeFile()
end
--[[
	Returns true if the last touched FX parameter is valid, false otherwise.
	The low word of tracknumber is the 1-based track index -- 0 means the master track, 1 means track 1, etc.
	If the high word of tracknumber is nonzero, it refers to the 1-based item index (1 is the first item on the track, etc).
	For track FX, the low 24 bits of fxnumber refer to the FX index in the chain, and if the next 8 bits are 01, then the FX is record FX.
	For item FX, the low word defines the FX index in the chain, and the high word defines the take number.
--]]
---@return number, number, number 
function Reaper:get_last_touched_fx()
    local retval, tracknumber, fxnumber, paramnumber = r.GetLastTouchedFX()
    if retval then
        return tracknumber, fxnumber, paramnumber
    end
end

---@return userdata Track
function Reaper:get_last_touched_track()
    return Track:new(r.GetLastTouchedTrack())
end

-- returns true if device present
---@param dev number
---@param nameout string
---@return string 
function Reaper:get_midi_input_name(dev, nameout)
    local retval, nameout_ = r.GetMIDIInputName(dev, nameout)
    if retval then
        return nameout_
    end
end

-- returns true if device present
---@param dev number
---@param nameout string
---@return string 
function Reaper:get_midi_output_name(dev, nameout)
    local retval, nameout_ = r.GetMIDIOutputName(dev, nameout)
    if retval then
        return nameout_
    end
end

---@return userdata HWND 
function Reaper:get_main_hwnd()
    return r.GetMainHWND()
end

-- &1=master mute,&2=master solo. This is deprecated as you can just query the master track as well.
---@return number 
function Reaper:get_master_mute_solo_flags()
    return r.GetMasterMuteSoloFlags()
end

-- returns &1 if the master track is visible in the TCP, &2 if NOT visible in the mixer. See SetMasterTrackVisibility.
---@return number 
function Reaper:get_master_track_visibility()
    return r.GetMasterTrackVisibility()
end

-- returns max dev for midi inputs/outputs
---@return number 
function Reaper:get_max_midi_inputs()
    return r.GetMaxMidiInputs()
end

---@return number 
function Reaper:get_max_midi_outputs()
    return r.GetMaxMidiOutputs()
end

-- Get the leftmost track visible in the mixer
---@return userdata Track
function Reaper:get_mixer_scroll()
    return Track:new(r.GetMixerScroll())
end

---@param context string
---@param modifier_flag number
---@param action string
---@return string 
function Reaper:get_mouse_modifier(context, modifier_flag, action)
    return r.GetMouseModifier(context, modifier_flag, action)
end

-- get mouse position in screen coordinates
---@return number, number 
function Reaper:get_mouse_position()
    return r.GetMousePosition()
end

-- Return number of normal audio hardware inputs available
---@return number 
function Reaper:get_num_audio_inputs()
    return r.GetNumAudioInputs()
end

-- Return number of normal audio hardware outputs available
---@return number 
function Reaper:get_num_audio_outputs()
    return r.GetNumAudioOutputs()
end

-- returns max number of real midi hardware inputs
---@return number 
function Reaper:get_num_midi_inputs()
    return r.GetNumMIDIInputs()
end

-- returns max number of real midi hardware outputs
---@return number 
function Reaper:get_num_midi_outputs()
    return r.GetNumMIDIOutputs()
end

---@return number 
function Reaper:get_num_tracks()
    return r.GetNumTracks()
end

-- Returns "Win32", "Win64", "OSX32", "OSX64", "macOS-arm64", or "Other".
---@return string
function Reaper:get_os()
    return r.GetOS()
end

---@param channel_index number
---@return string 
function Reaper:get_output_channel_name(channel_index)
    return r.GetOutputChannelName(channel_index)
end

-- returns output latency in seconds
---@return number 
function Reaper:get_output_latency()
    return r.GetOutputLatency()
end

-- get the peak file name for a given file (can be either filename.reapeaks,or a hashed filename in another path)
---@param fn string
---@return string 
function Reaper:get_peak_file_name(fn)
    return r.GetPeakFileName(fn, '')
end

-- get the peak file name for a given file (can be either filename.reapeaks,or a hashed filename in another path)
---@param fn string
---@param for_write boolean
---@return string 
function Reaper:get_peak_file_name_ex(fn, for_write)
    return r.GetPeakFileNameEx(fn, '', for_write)
end

-- Like GetPeakFileNameEx, but you can specify peaksfileextension such as ".reapeaks"
---@param fn string
---@param buf string
---@param for_write boolean
---@param peaksfileextension string
---@return string 
function Reaper:get_peak_file_name_ex2(fn, buf, for_write, peaksfileextension)
    return r.GetPeakFileNameEx2(fn, buf, for_write, peaksfileextension)
end

-- If `latency` is true, returns latency-compensated actual-what-you-hear position,
-- otherwise returns position of next audio block being processed.
---@return number 
function Reaper:get_play_position(latency)
	latency = latency or True
	if latency then
		return r.GetPlayPosition()
	else
		return r.GetPlayPosition2()
	end
end

-- &1=playing,&2=pause,&=4 is recording
---@return number 
function Reaper:get_play_state()
    return r.GetPlayState()
end

-- Get the project recording path.
---@param buf string
---@return string 
function Reaper:get_project_path(buf)
    return r.GetProjectPath(buf)
end

-- returns path where ini files are stored, other things are in subdirectories.
---@return string 
function Reaper:get_resource_path()
    return r.GetResourcePath()
end

---@param is_loop boolean
---@param start number
---@param end_ number
---@param allow_autoseek boolean
---@return number, number 
function Reaper:get_loop_time_range(is_loop, start, end_, allow_autoseek)
    return r.GetSet_LoopTimeRange(false, is_loop, start, end_, allow_autoseek)
end

---@param is_loop boolean
---@param start number
---@param end_ number
---@param allow_autoseek boolean
---@return number, number
function Reaper:set_loop_time_range(is_loop, start, end_, allow_autoseek)
    return r.GetSet_LoopTimeRange(true, is_loop, start, end_, allow_autoseek)
end

-- -1 == query,0=clear,1=set,>1=toggle . returns new value
---@param val number
---@return number 
function Reaper:get_set_repeat(val)
    return r.GetSetRepeat(val)
end


-- Returns the theme color specified, or -1 on failure. If the low bit of flags is set, the color as originally specified by the theme (before any transformations) is returned, otherwise the current (possibly transformed and modified) color is returned. See SetThemeColor for a list of valid ini_key.
---@param ini_key string
---@param flags number
---@return number 
function Reaper:get_theme_color(ini_key, flags)
    return r.GetThemeColor(ini_key, flags)
end

-- See GetToggleCommandStateEx.
---@param command_id number
---@return number 
function Reaper:get_toggle_command_state(command_id)
    return r.GetToggleCommandState(command_id)
end

-- For the main action context, the MIDI editor, or the media explorer, returns the toggle state of the action. 0=off, 1=on, -1=NA because the action does not have on/off states. For the MIDI editor, the action state for the most recently focused window will be returned.
---@param section_id number
---@param command_id number
---@return number 
function Reaper:get_toggle_command_state_ex(section_id, command_id)
    return r.GetToggleCommandStateEx(section_id, command_id)
end

-- gets a tooltip window,in case you want to ask it for font information. Can return NULL.
---@return userdata HWND 
function Reaper:get_tooltip_window()
    return r.GetTooltipWindow()
end

-- Returns the track from the screen coordinates specified. If the screen coordinates refer to a window associated to the track (such as FX), the track will be returned. infoOutOptional will be set to 1 if it is likely an envelope, 2 if it is likely a track FX.
---@param screen_x number
---@param screen_y number
---@return number 
function Reaper:get_track_from_point(screen_x, screen_y)
    local retval, info = r.GetTrackFromPoint(screen_x, screen_y)
    if retval then
        return info
    end
end

-- see GetTrackMIDINoteNameEx
---@param track number
---@param pitch number
---@param chan number
---@return string 
function Reaper:get_track_midi_note_name(track, pitch, chan)
    return r.GetTrackMIDINoteName(track, pitch, chan)
end

-- retrieves the last timestamps of audio xrun (yellow-flash, if available), media xrun (red-flash), and the current time stamp (all milliseconds)
---@return number, number, number 
function Reaper:get_underrun_time()
    return r.GetUnderrunTime()
end

-- returns true if the user selected a valid file, false if the user canceled the dialog
---@param filename string : need 4096
---@param title string
---@param defext string
---@return string 
function Reaper:get_user_file_name_for_read(filename, title, defext)
    local retval, filename_ = r.GetUserFileNameForRead(filename, title, defext)
    if retval then
        return filename_
    end
end

--[[
	Maximum fields is 16. Values are returned as a comma-separated string. Returns false if the user canceled the dialog. 
	You can supply special extra information via additional caption fields: extrawidth=XXX to increase text field width, 
	separator=X to use a different separator for returned fields.
--]]
---@param title string
---@param num_inputs number
---@param captions_csv string
---@param retvals_csv string
---@return string 
function Reaper:get_user_inputs(title, num_inputs, captions_csv, retvals_csv)
    local retval, retvals_csv_ = r.GetUserInputs(title, num_inputs, captions_csv, retvals_csv)
    if retval then
        return retvals_csv_
    end
end

-- Causes gmem_read()/gmem_write() to read EEL2/JSFX/Video shared memory segment named by parameter. Set to empty string to detach. 6.20+: returns previous shared memory segment name.
---@param retval sharedMemoryName
function Reaper:gmem_attach(retval)
    return r.gmem_attach(retval)
end

-- Read (number) value from shared memory attached-to by gmem_attach(). index can be [0..1<<25).
---@param retval number index
function Reaper:gmem_read(retval)
    return r.gmem_read(retval)
end

-- Write (number) value to shared memory attached-to by gmem_attach(). index can be [0..1<<25).
---@param retval number index
---@param retval value
function Reaper:gmem_write(retval, retval)
    return r.gmem_write(retval, retval)
end

-- dest should be at least 64 chars long to be safe
---@param g_g_u_id string
---@param dest_need64 string
---@return string 
function Reaper:guid_to_string(g_g_u_id, dest_need64)
    return r.guidToString(g_g_u_id, dest_need64)
end

-- Returns true if there exists an extended state value for a specific section and key. See SetExtState, GetExtState, DeleteExtState.
---@param section string
---@param key string
---@return boolean 
function Reaper:has_ext_state(section, key)
    return r.HasExtState(section, key)
end

-- returns name of track plugin that is supplying MIDI programs,or NULL if there is none
---@param track number
---@return string 
function Reaper:has_track_midi_programs(track)
    return r.HasTrackMIDIPrograms(track)
end

---@param helpstring string
---@param is_temporary_help boolean
function Reaper:help_set(helpstring, is_temporary_help)
    return r.Help_Set(helpstring, is_temporary_help)
end

---@param in_ string
---@param out string
---@return string 
function Reaper:image_resolve_fn(in_, out)
    return r.image_resolve_fn(in_, out)
end

---@param file string
---@param mode number : constants.MediaInsertModes
---@return number 
function Reaper:insert_media(file, mode)
    return r.InsertMedia(file, mode)
end

-- See InsertMedia.
---@param file string
---@param mode number : constants.MediaInsertModes
---@param startpct number
---@param endpct number
---@param pitchshift number
---@return number 
function Reaper:insert_media_section(file, mode, startpct, endpct, pitchshift)
    if MediaInsertModes[mode] == nil then
        error('Invalid param: ' .. mode)
    end
    return r.InsertMediaSection(file, mode, startpct, endpct, pitchshift)
end

-- inserts a track at idx,of course this will be clamped to 0..GetNumTracks(). wantDefaults=TRUE for default envelopes/FX,otherwise no enabled fx/env
---@param idx number
---@param want_defaults boolean
function Reaper:insert_track_at_index(idx, want_defaults)
    return r.InsertTrackAtIndex(idx, want_defaults)
end

-- If wantOthers is set, then "RPP", "TXT" and other project-type formats will also pass.
---@param ext string
---@param want_others boolean
---@return boolean 
function Reaper:is_media_extension(ext, want_others)
    return r.IsMediaExtension(ext, want_others)
end

-- creates a joystick device
---@param guid string
---@return userdata joystick_device 
function Reaper:joystick_create(guid)
    return r.joystick_create(guid)
end

-- destroys a joystick device
---@param device userdata joystick_device
function Reaper:joystick_destroy(device)
    return r.joystick_destroy(device)
end

-- enumerates installed devices, returns GUID as a string
---@param index number
---@return string 
function Reaper:joystick_enum(index)
    local retval, namestr = r.joystick_enum(index)
    if retval then
        return namestr
    end
end

-- returns axis value (-1..1)
---@param dev userdata joystick_device
---@param axis number
---@return number 
function Reaper:joystick_getaxis(dev, axis)
    return r.joystick_getaxis(dev, axis)
end

-- returns button pressed mask, 1=first button, 2=second...
---@param dev userdata joystick_device
---@return number 
function Reaper:joystick_getbuttonmask(dev)
    return r.joystick_getbuttonmask(dev)
end

-- returns button count
---@param dev userdata joystick_device
---@return number, number 
function Reaper:joystick_getinfo(dev)
    local retval, axes, povs = r.joystick_getinfo(dev)
    if retval then
        return axes, povs
    end
end

-- returns POV value (usually 0..655.35, or 655.35 on error)
---@param dev userdata joystick_device
---@param pov number
---@return number 
function Reaper:joystick_getpov(dev, pov)
    return r.joystick_getpov(dev, pov)
end

-- Updates joystick state from hardware, returns true if successful (joystick_get* will not be valid until joystick_update() is called successfully)
---@param dev userdata joystick_device
---@return boolean 
function Reaper:joystick_update(dev)
    return r.joystick_update(dev)
end

-- Returns false if the line is entirely offscreen.
---@param p_x1 number
---@param p_y1 number
---@param p_x2 number
---@param p_y2 number
---@param x_lo number
---@param y_lo number
---@param x_hi number
---@param y_hi number
---@return number, number, number, number 
function Reaper:l_i_c_e_clip_line(p_x1, p_y1, p_x2, p_y2, x_lo, y_lo, x_hi, y_hi)
    local retval, p_x1_, p_y1_, p_x2_, p_y2_ = r.LICE_ClipLine(p_x1, p_y1, p_x2, p_y2, x_lo, y_lo, x_hi, y_hi)
    if retval then
        return p_x1_, p_y1_, p_x2_, p_y2_
    end
end

-- Returns a localized version of src_string, in section section. flags can have 1 set to only localize if sprintf-style formatting matches the original.
---@param src_string string
---@param section string
---@param flags number
---@return string 
function Reaper:localize_string(src_string, section, flags)
    return r.LocalizeString(src_string, section, flags)
end

-- type 0=OK,1=OKCANCEL,2=ABORTRETRYIGNORE,3=YESNOCANCEL,4=YESNO,5=RETRYCANCEL : ret 1=OK,2=CANCEL,3=ABORT,4=RETRY,5=IGNORE,6=YES,7=NO
---@param msg string
---@param title string
---@param type number
---@return number 
function Reaper:mb(msg, title, type)
    return r.MB(msg, title, type)
end

-- see MIDIEditor_GetMode, MIDIEditor_OnCommand
---@return userdata HWND 
function Reaper:midi_editor_get_active()
    return r.MIDIEditor_GetActive()
end

-- see MIDIEditor_GetActive, MIDIEditor_OnCommand
---@param midieditor userdata HWND
---@return number 
function Reaper:midi_editor_get_mode(midieditor)
    return r.MIDIEditor_GetMode(midieditor)
end

---@param midieditor userdata HWND
---@param setting_desc string
---@return number 
function Reaper:midi_editor_get_setting_int(midieditor, setting_desc)
    return r.MIDIEditor_GetSetting_int(midieditor, setting_desc)
end

---@param midieditor userdata HWND
---@param setting_desc string
---@param buf string
---@return string 
function Reaper:midi_editor_get_setting_str(midieditor, setting_desc, buf)
    local retval, buf_ = r.MIDIEditor_GetSetting_str(midieditor, setting_desc, buf)
    if retval then
        return buf_
    end
end

-- get the take that is currently being edited in this MIDI editor
---@param midieditor userdata HWND
---@return MediaItem_Take 
function Reaper:midi_editor_get_take(midieditor)
    return r.MIDIEditor_GetTake(midieditor)
end

-- see MIDIEditor_OnCommand
---@param command_id number
---@param islistviewcommand boolean
---@return boolean 
function Reaper:midi_editor_last_focused_on_command(command_id, islistviewcommand)
    return r.MIDIEditor_LastFocused_OnCommand(command_id, islistviewcommand)
end

-- see MIDIEditor_GetActive, MIDIEditor_LastFocused_OnCommand
---@param midieditor userdata HWND
---@param command_id number
---@return boolean 
function Reaper:midi_editor_on_command(midieditor, command_id)
    return r.MIDIEditor_OnCommand(midieditor, command_id)
end

---@param midieditor userdata HWND
---@param setting_desc string
---@param setting number
---@return boolean 
function Reaper:midi_editor_set_setting_int(midieditor, setting_desc, setting)
    return r.MIDIEditor_SetSetting_int(midieditor, setting_desc, setting)
end

-- Performs an action belonging to the main action section. To perform non-native actions (ReaScripts, custom or extension plugins' actions) safely, see NamedCommandLookup().
-- See Main_OnCommandEx.
---@param command number
---@param flag number
function Reaper:main_on_command(command, flag)
    return r.Main_OnCommand(command, flag)
end

-- Performs an action belonging to the main action section. To perform non-native actions (ReaScripts, custom or extension plugins' actions) safely, see NamedCommandLookup().
---@param command number
---@param flag number
---@param proj ReaProject
function Reaper:main_on_command_ex(command, flag, proj)
    return r.Main_OnCommandEx(command, flag, proj)
end

---@param ignore_mask number
function Reaper:main_update_loop_info(ignore_mask)
    return r.Main_UpdateLoopInfo(ignore_mask)
end

-- If passed a .RTrackTemplate file, adds the template to the existing project.
---@param name string
function Reaper:main_open_project(name)
    return r.Main_openProject(name)
end

---@param time_s number
---@param proj ReaProject
---@return number 
function Reaper:master_get_play_rate_at_time(time_s, proj)
    return r.Master_GetPlayRateAtTime(time_s, proj)
end

---@return number 
function Reaper:master_get_tempo()
    return r.Master_GetTempo()
end

-- Convert play rate to/from a value between 0 and 1, representing the position on the project play_rate slider.
---@param play_rate number
---@param isnormalized boolean
---@return number 
function Reaper:master_normalize_play_rate(play_rate, isnormalized)
    return r.Master_NormalizePlayRate(play_rate, isnormalized)
end

-- Convert the tempo to/from a value between 0 and 1, representing bpm in the range of 40-296 bpm.
---@param bpm number
---@param isnormalized boolean
---@return number 
function Reaper:master_normalize_tempo(bpm, isnormalized)
    return r.Master_NormalizeTempo(bpm, isnormalized)
end

-- Reset all MIDI devices
function Reaper:midi_reinit()
    return r.midi_reinit()
end

---@param str_need64 string
---@param pan number
---@return string 
function Reaper:mkpanstr(str_need64, pan)
    return r.mkpanstr(str_need64, pan)
end

---@param str_need64 string
---@param vol number
---@param pan number
---@return string 
function Reaper:mkvolpanstr(str_need64, vol, pan)
    return r.mkvolpanstr(str_need64, vol, pan)
end

---@param str_need64 string
---@param vol number
---@return string 
function Reaper:mkvolstr(str_need64, vol)
    return r.mkvolstr(str_need64, vol)
end

---@param adjamt number
---@param dosel boolean
function Reaper:move_edit_cursor(adjamt, dosel)
    return r.MoveEditCursor(adjamt, dosel)
end

---@param mute boolean
function Reaper:mute_all_tracks(mute)
    return r.MuteAllTracks(mute)
end

---@param left number
---@param top number
---@param right number
---@param bot number
---@param sr_left number
---@param sr_top number
---@param sr_right number
---@param sr_bot number
---@param want_work_area boolean
function Reaper:my_get_viewport(left, top, right, bot, sr_left, sr_top, sr_right, sr_bot, want_work_area)
    r.my_getViewport(left, top, right, bot, sr_left, sr_top, sr_right, sr_bot, want_work_area)
end

-- Get the command ID number for named command that was registered by an extension 
-- such as "_SWS_ABOUT" or "_113088d11ae641c193a2b7ede3041ad5" for a ReaScript or a custom action.
---@param command_name string
---@return number 
function Reaper:named_command_lookup(command_name)
    return r.NamedCommandLookup(command_name)
end

-- Creates a new reaper.array object of maximum and initial size size, if specified, or from the size/values of a table/array. Both size and table/array can be specified, the size parameter will override the table/array size.
---@param retval [table|array][size]
function Reaper:new_array(retval)
    return r.new_array(retval)
end

-- direct way to simulate pause button hit
function Reaper:on_pause_button()
    return r.OnPauseButton()
end

-- direct way to simulate play button hit
function Reaper:on_play_button()
    return r.OnPlayButton()
end

-- direct way to simulate stop button hit
function Reaper:on_stop_button()
    return r.OnStopButton()
end

---@param fn string
---@return boolean 
function Reaper:open_color_theme_file(fn)
    return r.OpenColorThemeFile(fn)
end

-- Opens mediafn in the Media Explorer, play=true will play the file immediately (or toggle playback if mediafn was already open), =false will just select it.
---@param mediafn string
---@param play boolean
---@return userdata HWND 
function Reaper:open_media_explorer(mediafn, play)
    return r.OpenMediaExplorer(mediafn, play)
end

-- Send an OSC message directly to REAPER. The value argument may be NULL. The message will be matched against the default OSC patterns. Only supported if control surface support was enabled when installing REAPER.
---@param message string
---@param value_in number
function Reaper:osc_local_message_to_host(message, value_in)
    return r.OscLocalMessageToHost(message, value_in)
end

---@param idx number
---@return string 
function Reaper:pcm_sink_enum(idx)
    local retval, descstr = r.PCM_Sink_Enum(idx)
    if retval then
        return descstr
    end
end

---@param data string
---@return string 
function Reaper:pcm_sink_get_extension(data)
    return r.PCM_Sink_GetExtension(data)
end

---@param cfg string
---@param hwnd_parent userdata HWND
---@return userdata HWND 
function Reaper:pcm_sink_show_config(cfg, hwnd_parent)
    return r.PCM_Sink_ShowConfig(cfg, hwnd_parent)
end

-- See PCM_Source_CreateFromFileEx.
---@param filename string
---@return PCM_source 
function Reaper:pcm_source_create_from_file(filename)
    return r.PCM_Source_CreateFromFile(filename)
end

-- Create a PCM_source from filename, and override pref of MIDI files being imported as in-project MIDI events.
---@param filename string
---@param forceno_midi_imp boolean
---@return PCM_source 
function Reaper:pcm_source_create_from_file_ex(filename, forceno_midi_imp)
    return r.PCM_Source_CreateFromFileEx(filename, forceno_midi_imp)
end

-- Valid types include "WAVE", "MIDI", or whatever plug-ins define as well.
---@param sourcetype string
---@return PCM_source 
function Reaper:pcm_source_create_from_type(sourcetype)
    return r.PCM_Source_CreateFromType(sourcetype)
end

-- Parse hh:mm:ss.sss time string, return time in seconds (or 0.0 on error). See parse_timestr_pos, parse_timestr_len.
---@param buf string
---@return number 
function Reaper:parse_timestr(buf)
    return r.parse_timestr(buf)
end

---@param buf string
---@param offset number
---@param modeoverride number
---@return number 
function Reaper:parse_timestr_len(buf, offset, modeoverride)
    return r.parse_timestr_len(buf, offset, modeoverride)
end

---@param buf string
---@param modeoverride number
---@return number 
function Reaper:parse_timestr_pos(buf, modeoverride)
    return r.parse_timestr_pos(buf, modeoverride)
end

---@param str string
---@return number 
function Reaper:parsepanstr(str)
    return r.parsepanstr(str)
end

---@param amt number
function Reaper:plugin_wants_always_run_fx(amt)
    return r.PluginWantsAlwaysRunFx(amt)
end

-- adds prevent_count to the UI refresh prevention state; always add then remove the same amount, or major disfunction will occur
---@param prevent_count number
function Reaper:prevent_ui_refresh(prevent_count)
    return r.PreventUIRefresh(prevent_count)
end

-- Uses the action list to choose an action. Call with session_mode=1 to create a session (init_id will be the initial action to select, or 0), then poll with session_mode=0, checking return value for user-selected action (will return 0 if no action selected yet, or -1 if the action window is no longer available). When finished, call with session_mode=-1.
---@param session_mode number
---@param init_id number
---@param section_id number
---@return number 
function Reaper:prompt_for_action(session_mode, init_id, section_id)
    return r.PromptForAction(session_mode, init_id, section_id)
end

-- Causes REAPER to display the error message after the current ReaScript finishes. If called within a Lua context and errmsg has a ! prefix, script execution will be terminated.
---@param errmsg string
function Reaper:rea_script_error(errmsg)
    return r.ReaScriptError(errmsg)
end

-- returns positive value on success, 0 on failure.
---@param path string
---@param ignored number
---@return number 
function Reaper:recursive_create_directory(path, ignored)
    return r.RecursiveCreateDirectory(path, ignored)
end

-- garbage-collects extra open files and closes them. if flags has 1 set, this is done incrementally (call this from a regular timer, if desired). if flags has 2 set, files are aggressively closed (they may need to be re-opened very soon). returns number of files closed by this call.
---@param flags number
---@return number 
function Reaper:reduce_open_files(flags)
    return r.reduce_open_files(flags)
end

-- See RefreshToolbar2.
---@param command_id number
function Reaper:refresh_toolbar(command_id)
    return r.RefreshToolbar(command_id)
end

-- Refresh the toolbar button states of a toggle action.
---@param section_id number
---@param command_id number
function Reaper:refresh_toolbar2(section_id, command_id)
    return r.RefreshToolbar2(section_id, command_id)
end

-- Makes a filename "in" relative to the current project, if any.
---@param in_ string
---@param out string
---@return string 
function Reaper:relative_fn(in_, out)
    return r.relative_fn(in_, out)
end

-- Not available while playing back.
---@param source_filename string
---@param target_filename string
---@param start_percent number
---@param end_percent number
---@param play_rate number
---@return boolean 
function Reaper:render_file_section(source_filename, target_filename, start_percent, end_percent, play_rate)
    return r.RenderFileSection(source_filename, target_filename, start_percent, end_percent, play_rate)
end

-- Moves all selected tracks to immediately above track specified by index beforeTrackIdx, returns false if no tracks were selected. makePrevFolder=0 for normal, 1 = as child of track preceding track specified by beforeTrackIdx, 2 = if track preceding track specified by beforeTrackIdx is last track in folder, extend folder
---@param before_track_idx number
---@param make_prev_folder number
---@return boolean 
function Reaper:reorder_selected_tracks(before_track_idx, make_prev_folder)
    return r.ReorderSelectedTracks(before_track_idx, make_prev_folder)
end

---@param mode number
---@return string 
function Reaper:resample_enum_modes(mode)
    return r.Resample_EnumModes(mode)
end

-- See resolve_fn2.
---@param in_ string
---@param out string
---@return string 
function Reaper:resolve_fn(in_, out)
    return r.resolve_fn(in_, out)
end

-- Resolves a filename "in" by using project settings etc. If no file found, out will be a copy of in.
---@param in_ string
---@param out string
---@param check_sub_dir string
---@return string 
function Reaper:resolve_fn2(in_, out, check_sub_dir)
    return r.resolve_fn2(in_, out, check_sub_dir)
end

-- Get the named command for the given command ID. The returned string will not start with '_' (e.g. it will return "SWS_ABOUT"), it will be NULL if command_id is a native action.
---@param command_id number
---@return string 
function Reaper:reverse_named_command_lookup(command_id)
    return r.ReverseNamedCommandLookup(command_id)
end

-- Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input, while the user does other tasks. Identical to defer().Note that no undo point will be automatically created when the script finishes, unless you create it explicitly.
---@param retval function
function Reaper:run_loop(retval)
    return r.run_loop(retval)
end

---@param y number
---@return number 
function Reaper:slider2db(y)
    return r.SLIDER2DB(y)
end

-- Focuses the active/open MIDI editor.
function Reaper:sn_focus_midi_editor()
    return r.SN_FocusMIDIEditor()
end

-- See GetEnvelopeScalingMode.
---@param scaling_mode number
---@param val number
---@return number 
function Reaper:scale_from_envelope_mode(scaling_mode, val)
    return r.ScaleFromEnvelopeMode(scaling_mode, val)
end

-- See GetEnvelopeScalingMode.
---@param scaling_mode number
---@param val number
---@return number 
function Reaper:scale_to_envelope_mode(scaling_mode, val)
    return r.ScaleToEnvelopeMode(scaling_mode, val)
end

-- sets all or selected tracks to mode.
---@param mode number
---@param only_sel boolean
function Reaper:set_automation_mode(mode, only_sel)
    return r.SetAutomationMode(mode, only_sel)
end

-- You must use this to change the focus programmatically. mode=0 to focus track panels, 1 to focus the arrange window, 2 to focus the arrange window and select env (or env==NULL to clear the current track/take envelope selection)
---@param mode number
---@param env_in TrackEnvelope
function Reaper:set_cursor_context(mode, env_in)
    return r.SetCursorContext(mode, env_in)
end

---@param time number
---@param moveview boolean
---@param seek_play boolean
function Reaper:set_edit_cur_pos(time, moveview, seek_play)
    return r.SetEditCurPos(time, moveview, seek_play)
end

-- Set the extended state value for a specific section and key. persist=true means the value should be stored and reloaded the next time REAPER is opened. See GetExtState, DeleteExtState, HasExtState.
---@param section string
---@param key string
---@param value string
---@param persist boolean
function Reaper:set_ext_state(section, key, value, persist)
    return r.SetExtState(section, key, value, persist)
end

-- mode: see GetGlobalAutomationOverride
---@param mode number
function Reaper:set_global_automation_override(mode)
    return r.SetGlobalAutomationOverride(mode)
end

-- set &1 to show the master track in the TCP, &2 to HIDE in the mixer. Returns the previous visibility state. See GetMasterTrackVisibility.
---@param flag number
---@return number 
function Reaper:set_master_track_visibility(flag)
    return r.SetMasterTrackVisibility(flag)
end

---@param context string
---@param modifier_flag number
---@param action string
function Reaper:set_mouse_modifier(context, modifier_flag, action)
    return r.SetMouseModifier(context, modifier_flag, action)
end

---@param mark_rgn_idx number
---@param is_rgn boolean
---@param pos number
---@param rgn_end number
---@param name string
---@return boolean 
function Reaper:set_project_marker(mark_rgn_idx, is_rgn, pos, rgn_end, name)
    return r.SetProjectMarker(mark_rgn_idx, is_rgn, pos, rgn_end, name)
end

---@param ini_key string
---@param color number
---@param flags number
---@return number 
function Reaper:set_theme_color(ini_key, color, flags)
    return r.SetThemeColor(ini_key, color, flags)
end

-- Updates the toggle state of an action, returns true if succeeded.
-- Only ReaScripts can have their toggle states changed programmatically. See RefreshToolbar2.
---@param section_id number
---@param command_id number
---@param state number
---@return boolean 
function Reaper:set_toggle_command_state(section_id, command_id, state)
    return r.SetToggleCommandState(section_id, command_id, state)
end

-- channel < 0 assigns these note names to all channels.
---@param track number
---@param pitch number
---@param chan number
---@param name string
---@return boolean 
function Reaper:set_track_midi_note_name(track, pitch, chan, name)
    return r.SetTrackMIDINoteName(track, pitch, chan, name)
end

---@param caller KbdSectionInfo
---@param caller_wnd userdata HWND
function Reaper:show_action_list(caller, caller_wnd)
    return r.ShowActionList(caller, caller_wnd)
end

-- Show a message to the user (also useful for debugging). Send "\n" for newline, "" to clear the console. See ClearConsole
---@param msg string
function Reaper:show_console_msg(msg)
    return r.ShowConsoleMsg(msg)
end

-- type 0=OK,1=OKCANCEL,2=ABORTRETRYIGNORE,3=YESNOCANCEL,4=YESNO,5=RETRYCANCEL : ret 1=OK,2=CANCEL,3=ABORT,4=RETRY,5=IGNORE,6=YES,7=NO
---@param msg string
---@param title string
---@param type number
---@return number 
function Reaper:show_message_box(msg, title, type)
    return r.ShowMessageBox(msg, title, type)
end

-- shows a context menu, valid names include: track_input, track_panel, track_area, track_routing, item, ruler, envelope, envelope_point, envelope_item. ctxOptional can be a track pointer for track_*, item pointer for item* (but is optional). for envelope_point, ctx2Optional has point index, ctx3Optional has item index (0=main envelope, 1=first AI). for envelope_item, ctx2Optional has AI index (1=first AI)
---@param name string
---@param x number
---@param y number
---@param hwnd_parent userdata
---@param ctx identifier
---@param ctx2 number
---@param ctx3 number
function Reaper:show_popup_menu(name, x, y, hwnd_parent, ctx, ctx2, ctx3)
    return r.ShowPopupMenu(name, x, y, hwnd_parent, ctx, ctx2, ctx3)
end

-- solo=2 for SIP
---@param solo number
function Reaper:solo_all_tracks(solo)
    return r.SoloAllTracks(solo)
end

-- gets the splash window, in case you want to display a message over it. Returns NULL when the sphah window is not displayed.
---@return userdata HWND 
function Reaper:splash_get_wnd()
    return r.Splash_GetWnd()
end

---@param str string
---@param g_g_u_id string
---@return string 
function Reaper:string_to_guid(str, g_g_u_id)
    return r.stringToGuid(str, g_g_u_id)
end

-- Stuffs a 3 byte MIDI message into either the Virtual MIDI Keyboard queue, or the MIDI-as-control input queue, or sends to a MIDI hardware output. mode=0 for VKB, 1 for control (actions map etc), 2 for VKB-on-current-channel; 16 for external MIDI device 0, 17 for external MIDI device 1, etc; see GetNumMIDIOutputs, GetMIDIOutputName.
---@param mode number
---@param msg1 number
---@param msg2 number
---@param msg3 number
function Reaper:stuff_midi_message(mode, msg1, msg2, msg3)
    return r.StuffMIDIMessage(mode, msg1, msg2, msg3)
end

-- Gets theme layout information. section can be 'global' for global layout override, 'seclist' to enumerate a list of layout sections, otherwise a layout section such as 'mcp', 'tcp', 'trans', etc. idx can be -1 to query the current value, -2 to get the description of the section (if not global), -3 will return the current context DPI-scaling (256=normal, 512=retina, etc), or 0..x. returns false if failed.
---@param section string
---@param idx number
---@return string 
function Reaper:theme_layout_get_layout(section, idx)
    local retval, name = r.ThemeLayout_GetLayout(section, idx)
    if retval then
        return name
    end
end

-- returns theme layout parameter. return value is cfg-name, or nil/empty if out of range.
---@param wp number
---@return string, number, number, number, number 
function Reaper:theme_layout_get_parameter(wp)
    local retval, desc, value, def_value, min_value, max_value = r.ThemeLayout_GetParameter(wp)
    if retval then
        return desc, value, def_value, min_value, max_value
    end
end

-- Refreshes all layouts
function Reaper:theme_layout_refresh_all()
    return r.ThemeLayout_RefreshAll()
end

-- Sets theme layout override for a particular section -- section can be 'global' or 'mcp' etc. If setting global layout, prefix a ! to the layout string to clear any per-layout overrides. Returns false if failed.
---@param section string
---@param layout string
---@return boolean 
function Reaper:theme_layout_set_layout(section, layout)
    return r.ThemeLayout_SetLayout(section, layout)
end

-- sets theme layout parameter to value. persist=true in order to have change loaded on next theme load. note that the caller should update layouts via ??? to make changes visible.
---@param wp number
---@param value number
---@param persist boolean
---@return boolean 
function Reaper:theme_layout_set_parameter(wp, value, persist)
    return r.ThemeLayout_SetParameter(wp, value, persist)
end

-- Gets a precise system timestamp in seconds
---@return number 
function Reaper:time_precise()
    return r.time_precise()
end

-- displays tooltip at location, or removes if empty string
---@param fmt string
---@param xpos number
---@param ypos number
---@param topmost boolean
function Reaper:track_ctl_set_tool_tip(fmt, xpos, ypos, topmost)
    return r.TrackCtl_SetToolTip(fmt, xpos, ypos, topmost)
end

-- call to start a new block
function Reaper:undo_begin_block()
    return r.Undo_BeginBlock()
end

-- call to end the block,with extra flags if any,and a description
---@param desc_change string
---@param extra_flags number
function Reaper:undo_end_block(desc_change, extra_flags)
    return r.Undo_EndBlock(desc_change, extra_flags)
end

-- limited state change to items
---@param desc_change string
function Reaper:undo_on_state_change(desc_change)
    return r.Undo_OnStateChange(desc_change)
end

-- param=-1 by default,or if updating one fx chain,you can specify track index
---@param desc_change string
---@param which_states number
---@param param number
function Reaper:undo_on_state_change_ex(desc_change, which_states, param)
    return r.Undo_OnStateChangeEx(desc_change, which_states, param)
end

-- Redraw the arrange view
function Reaper:update_arrange()
    return r.UpdateArrange()
end

-- Redraw the arrange view and ruler
function Reaper:update_timeline()
    return r.UpdateTimeline()
end

--[[
    Return true if the pointer is a valid object of the right type in proj.
    @pointer Userdata
    @type_name string

    Supported types: constants.PointerTypes
--]]
function Reaper:is_valid_pointer(pointer, type_name)
    return r.ValidatePtr(pointer, type_name)
end

-- Opens the prefs to a page, use pageByName if page is 0.
---@param page number
---@param page_by_name string
function Reaper:view_prefs(page, page_by_name)
    return r.ViewPrefs(page, page_by_name)
end

return Reaper
