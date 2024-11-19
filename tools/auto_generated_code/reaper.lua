-- Returns true if function_name exists in the REAPER API
-- @function_name string
-- @return boolean 
function Reaper:a_p_i_exists(function_name)
    return r.APIExists(function_name)
end

-- Displays a message window if the API was successfully called.
function Reaper:a_p_i_test()
    return r.APITest()
end

-- Add a ReaScript (return the new command ID, or 0 if failed) or remove a ReaScript (return >0 on success). Use commit==true when adding/removing a single script. When bulk adding/removing n scripts, you can optimize the n-1 first calls with commit==false and commit==true for the last call.
-- @add boolean
-- @section_i_d integer
-- @scriptfn string
-- @commit boolean
-- @return integer 
function Reaper:add_remove_rea_script(add, section_i_d, scriptfn, commit)
    return r.AddRemoveReaScript(add, section_i_d, scriptfn, commit)
end

-- forceset=0,doupd=true,centermode=-1 for default
-- @amt number
-- @forceset integer
-- @doupd boolean
-- @centermode integer
function Reaper:adjust_zoom(amt, forceset, doupd, centermode)
    return r.adjustZoom(amt, forceset, doupd, centermode)
end

-- arms a command (or disarms if 0 passed) in section sectionname (empty string for main)
-- @cmd integer
-- @sectionname string
function Reaper:arm_command(cmd, sectionname)
    return r.ArmCommand(cmd, sectionname)
end

-- Sets the value of zero or more items in the array. If value not specified, 0.0 is used. offset is 1-based, if size omitted then the maximum amount available will be set.
-- @retval [value
-- @retval offset
-- @retval size]
-- @return { 
function Reaper:array_clear(retval, retval, retval)
    return r.clear(retval, retval, retval)
end

-- Convolves complex value pairs from reaper.array, starting at 1-based srcoffs, reading/writing to 1-based destoffs. size is in normal items (so it must be even)
-- @retval [src
-- @retval srcoffs
-- @retval size
-- @retval destoffs]
-- @return { 
function Reaper:array_convolve(retval, retval, retval, retval)
    return r.convolve(retval, retval, retval, retval)
end

-- Copies values from reaper.array or table, starting at 1-based srcoffs, writing to 1-based destoffs.
-- @retval [src
-- @retval srcoffs
-- @retval size
-- @retval destoffs]
-- @return { 
function Reaper:array_copy(retval, retval, retval, retval)
    return r.copy(retval, retval, retval, retval)
end

-- Performs a forward FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled following the FFT to be in normal order.
-- @retval size[
-- @retval permute
-- @retval offset]
-- @return { 
function Reaper:array_fft(retval, retval, retval)
    return r.fft(retval, retval, retval)
end

-- Performs a forward real->complex FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled following the FFT to be in normal order.
-- @retval size[
-- @retval permute
-- @retval offset]
-- @return { 
function Reaper:array_fft_real(retval, retval, retval)
    return r.fft_real(retval, retval, retval)
end

-- Returns the maximum (allocated) size of the array.
-- @return { 
function Reaper:array_get_alloc()
    return r.get_alloc()
end

-- Performs a backwards FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled before the IFFT to be in fft-order.
-- @retval size[
-- @retval permute
-- @retval offset]
-- @return { 
function Reaper:array_ifft(retval, retval, retval)
    return r.ifft(retval, retval, retval)
end

-- Performs a backwards complex->real FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled before the IFFT to be in fft-order.
-- @retval size[
-- @retval permute
-- @retval offset]
-- @return { 
function Reaper:array_ifft_real(retval, retval, retval)
    return r.ifft_real(retval, retval, retval)
end

-- Multiplies values from reaper.array, starting at 1-based srcoffs, reading/writing to 1-based destoffs.
-- @retval [src
-- @retval srcoffs
-- @retval size
-- @retval destoffs]
-- @return { 
function Reaper:array_multiply(retval, retval, retval, retval)
    return r.multiply(retval, retval, retval, retval)
end

-- Resizes an array object to size. size must be [0..max_size].
-- @retval size
-- @return { 
function Reaper:array_resize(retval)
    return r.resize(retval)
end

-- Returns a new table with values from items in the array. Offset is 1-based and if size is omitted all available values are used.
-- @retval [offset
-- @retval size]
-- @return { 
function Reaper:array_table(retval, retval)
    return r.table(retval, retval)
end

-- Adds code to be executed when the script finishes or is ended by the user. Typically used to clean up after the user terminates defer() or runloop() code.
-- @retval function
function Reaper:atexit(retval)
    return r.atexit(retval)
end

-- open all audio and MIDI devices, if not open
function Reaper:audio__init()
    return r.Audio_Init()
end

-- is in pre-buffer? threadsafe
-- @return integer 
function Reaper:audio__is_pre_buffer()
    return r.Audio_IsPreBuffer()
end

-- is audio running at all? threadsafe
-- @return integer 
function Reaper:audio__is_running()
    return r.Audio_IsRunning()
end

-- close all audio and MIDI devices, if open
function Reaper:audio__quit()
    return r.Audio_Quit()
end

-- Returns true if the underlying samples (track or media item take) have changed, but does not update the audio accessor, so the user can selectively call AudioAccessorValidateState only when needed. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, GetAudioAccessorEndTime, GetAudioAccessorSamples.
-- @accessor AudioAccessor
-- @return boolean 
function Reaper:audio_accessor_state_changed(accessor)
    return r.AudioAccessorStateChanged(accessor)
end

-- Force the accessor to reload its state from the underlying track or media item take. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
-- @accessor AudioAccessor
function Reaper:audio_accessor_update(accessor)
    return r.AudioAccessorUpdate(accessor)
end

-- Validates the current state of the audio accessor -- must ONLY call this from the main thread. Returns true if the state changed.
-- @accessor AudioAccessor
-- @return boolean 
function Reaper:audio_accessor_validate_state(accessor)
    return r.AudioAccessorValidateState(accessor)
end

-- -1 = bypass all if not all bypassed,otherwise unbypass all
-- @bypass integer
function Reaper:bypass_fx_all_tracks(bypass)
    return r.BypassFxAllTracks(bypass)
end

-- call this to force flushing of the undo states after using CSurf_On*Change()
-- @force boolean
function Reaper:c_surf__flush_undo(force)
    return r.CSurf_FlushUndo(force)
end

function Reaper:c_surf__go_end()
    return r.CSurf_GoEnd()
end

function Reaper:c_surf__go_start()
    return r.CSurf_GoStart()
end

-- @mcp_view boolean
-- @return integer 
function Reaper:c_surf__num_tracks(mcp_view)
    return r.CSurf_NumTracks(mcp_view)
end

-- @whichdir integer
-- @wantzoom boolean
function Reaper:c_surf__on_arrow(whichdir, wantzoom)
    return r.CSurf_OnArrow(whichdir, wantzoom)
end

-- @seekplay integer
function Reaper:c_surf__on_fwd(seekplay)
    return r.CSurf_OnFwd(seekplay)
end

function Reaper:c_surf__on_pause()
    return r.CSurf_OnPause()
end

function Reaper:c_surf__on_play()
    return r.CSurf_OnPlay()
end

-- @playrate number
function Reaper:c_surf__on_play_rate_change(playrate)
    return r.CSurf_OnPlayRateChange(playrate)
end

function Reaper:c_surf__on_record()
    return r.CSurf_OnRecord()
end

-- @seekplay integer
function Reaper:c_surf__on_rew(seekplay)
    return r.CSurf_OnRew(seekplay)
end

-- @seekplay integer
-- @dir integer
function Reaper:c_surf__on_rew_fwd(seekplay, dir)
    return r.CSurf_OnRewFwd(seekplay, dir)
end

-- @xdir integer
-- @ydir integer
function Reaper:c_surf__on_scroll(xdir, ydir)
    return r.CSurf_OnScroll(xdir, ydir)
end

function Reaper:c_surf__on_stop()
    return r.CSurf_OnStop()
end

-- @bpm number
function Reaper:c_surf__on_tempo_change(bpm)
    return r.CSurf_OnTempoChange(bpm)
end

-- @xdir integer
-- @ydir integer
function Reaper:c_surf__on_zoom(xdir, ydir)
    return r.CSurf_OnZoom(xdir, ydir)
end

function Reaper:c_surf__reset_all_cached_vol_pan_states()
    return r.CSurf_ResetAllCachedVolPanStates()
end

-- @amt number
function Reaper:c_surf__scrub_amt(amt)
    return r.CSurf_ScrubAmt(amt)
end

-- @mode integer
-- @ignoresurf IReaperControlSurface
function Reaper:c_surf__set_auto_mode(mode, ignoresurf)
    return r.CSurf_SetAutoMode(mode, ignoresurf)
end

-- @play boolean
-- @pause boolean
-- @rec boolean
-- @ignoresurf IReaperControlSurface
function Reaper:c_surf__set_play_state(play, pause, rec, ignoresurf)
    return r.CSurf_SetPlayState(play, pause, rec, ignoresurf)
end

-- @rep boolean
-- @ignoresurf IReaperControlSurface
function Reaper:c_surf__set_repeat_state(rep, ignoresurf)
    return r.CSurf_SetRepeatState(rep, ignoresurf)
end

function Reaper:c_surf__set_track_list_change()
    return r.CSurf_SetTrackListChange()
end

-- @idx integer
-- @mcp_view boolean
-- @return MediaTrack 
function Reaper:c_surf__track_from_i_d(idx, mcp_view)
    return r.CSurf_TrackFromID(idx, mcp_view)
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
-- @col integer
-- @return number, number, number 
function Reaper:color_from_native(col)
    return r.ColorFromNative(col)
end

-- Make an OS dependent color from RGB values (e.g. RGB() macro on Windows). r,g and b are in [0..255]. See ColorFromNative.
-- @r integer
-- @g integer
-- @b integer
-- @return integer 
function Reaper:color_to_native(r, g, b)
    return r.ColorToNative(r, g, b)
end

-- @x number
-- @return number 
function Reaper:d_b2_s_l_i_d_e_r(x)
    return r.DB2SLIDER(x)
end

-- Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input, while the user does other tasks. Identical to runloop().Note that no undo point will be automatically created when the script finishes, unless you create it explicitly.
-- @retval function
function Reaper:defer(retval)
    return r.defer(retval)
end

-- Delete the extended state value for a specific section and key. persist=true means the value should remain deleted the next time REAPER is opened. See SetExtState, GetExtState, HasExtState.
-- @section string
-- @key string
-- @persist boolean
function Reaper:delete_ext_state(section, key, persist)
    return r.DeleteExtState(section, key, persist)
end

-- Destroy an audio accessor. Must only call from the main thread. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples. 
-- @accessor AudioAccessor
function Reaper:destroy_audio_accessor(accessor)
    return r.DestroyAudioAccessor(accessor)
end

-- updates preference for docker window ident_str to be in dock whichDock on next open
-- @ident_str string
-- @which_dock integer
function Reaper:dock__update_dock_i_d(ident_str, which_dock)
    return r.Dock_UpdateDockID(ident_str, which_dock)
end

-- -1=not found, 0=bottom, 1=left, 2=top, 3=right, 4=floating
-- @which_dock integer
-- @return integer 
function Reaper:dock_get_position(which_dock)
    return r.DockGetPosition(which_dock)
end

-- returns dock index that contains hwnd, or -1
-- @hwnd HWND
-- @return boolean 
function Reaper:dock_is_child_of_dock(hwnd)
    local retval, is_floating_docker = r.DockIsChildOfDock(hwnd)
    if retval then
        return is_floating_docker
    end
end

-- @hwnd HWND
function Reaper:dock_window_activate(hwnd)
    return r.DockWindowActivate(hwnd)
end

-- @hwnd HWND
-- @name string
-- @pos integer
-- @allow_show boolean
function Reaper:dock_window_add(hwnd, name, pos, allow_show)
    return r.DockWindowAdd(hwnd, name, pos, allow_show)
end

-- @hwnd HWND
-- @name string
-- @identstr string
-- @allow_show boolean
function Reaper:dock_window_add_ex(hwnd, name, identstr, allow_show)
    return r.DockWindowAddEx(hwnd, name, identstr, allow_show)
end

function Reaper:dock_window_refresh()
    return r.DockWindowRefresh()
end

-- @hwnd HWND
function Reaper:dock_window_refresh_for_h_w_n_d(hwnd)
    return r.DockWindowRefreshForHWND(hwnd)
end

-- @hwnd HWND
function Reaper:dock_window_remove(hwnd)
    return r.DockWindowRemove(hwnd)
end

-- call with a saved window rect for your window and it'll correct any positioning info.
-- @retval numberr.left
-- @retval numberr.top
-- @retval numberr.right
-- @retval numberr.bot
-- @return numberr.left, numberr.top, numberr.right, numberr.bot 
function Reaper:ensure_not_completely_offscreen(retval, retval, retval, retval)
    return r.EnsureNotCompletelyOffscreen(retval, retval, retval, retval)
end

-- Start querying modes at 0, returns FALSE when no more modes possible, sets strOut to NULL if a mode is currently unsupported
-- @mode integer
-- @return string 
function Reaper:enum_pitch_shift_modes(mode)
    local retval, str = r.EnumPitchShiftModes(mode)
    if retval then
        return str
    end
end

-- Returns submode name, or NULL
-- @mode integer
-- @submode integer
-- @return string 
function Reaper:enum_pitch_shift_sub_modes(mode, submode)
    return r.EnumPitchShiftSubModes(mode, submode)
end

-- @idx integer
-- @return boolean, number, number, string, number 
function Reaper:enum_project_markers(idx)
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = r.EnumProjectMarkers(idx)
    if retval then
        return isrgn, pos, rgnend, name, markrgnindexnumber
    end
end

-- idx=-1 for current project,projfn can be NULL if not interested in filename. use idx 0x40000000 for currently rendering project, if any.
-- @idx integer
-- @return string 
function Reaper:enum_projects(idx)
    local retval, projfn = r.EnumProjects(idx)
    if retval then
        return projfn
    end
end

-- returns false if there are no plugins on the track that support MIDI programs,or if all programs have been enumerated
-- @track integer
-- @program_number integer
-- @program_name string
-- @return string 
function Reaper:enum_track_m_i_d_i_program_names(track, program_number, program_name)
    local retval, program_name_ = r.EnumTrackMIDIProgramNames(track, program_number, program_name)
    if retval then
        return program_name_
    end
end

-- List the files in the "path" directory. Returns NULL/nil when all files have been listed. Use fileindex = -1 to force re-read of directory (invalidate cache). See EnumerateSubdirectories
-- @path string
-- @fileindex integer
-- @return string 
function Reaper:enumerate_files(path, fileindex)
    return r.EnumerateFiles(path, fileindex)
end

-- List the subdirectories in the "path" directory. Use subdirindex = -1 to force re-read of directory (invalidate cache). Returns NULL/nil when all subdirectories have been listed. See EnumerateFiles
-- @path string
-- @subdirindex integer
-- @return string 
function Reaper:enumerate_subdirectories(path, subdirindex)
    return r.EnumerateSubdirectories(path, subdirindex)
end

-- Executes command line, returns NULL on total failure, otherwise the return value, a newline, and then the output of the command. If timeoutmsec is 0, command will be allowed to run indefinitely (recommended for large amounts of returned output). timeoutmsec is -1 for no wait/terminate, -2 for no wait and minimize
-- @cmdline string
-- @timeoutmsec integer
-- @return string 
function Reaper:exec_process(cmdline, timeoutmsec)
    return r.ExecProcess(cmdline, timeoutmsec)
end

-- [FNG] Add MIDI note to MIDI take
-- @midi_take RprMidiTake
-- @return RprMidiNote 
function Reaper:f_n_g__add_midi_note(midi_take)
    return r.FNG_AddMidiNote(midi_take)
end

-- [FNG] Count of how many MIDI notes are in the MIDI take
-- @midi_take RprMidiTake
-- @return integer 
function Reaper:f_n_g__count_midi_notes(midi_take)
    return r.FNG_CountMidiNotes(midi_take)
end

-- [FNG] Commit changes to MIDI take and free allocated memory
-- @midi_take RprMidiTake
function Reaper:f_n_g__free_midi_take(midi_take)
    return r.FNG_FreeMidiTake(midi_take)
end

-- [FNG] Get a MIDI note from a MIDI take at specified index
-- @midi_take RprMidiTake
-- @index integer
-- @return RprMidiNote 
function Reaper:f_n_g__get_midi_note(midi_take, index)
    return r.FNG_GetMidiNote(midi_take, index)
end

-- [FNG] Get MIDI note property
-- @midi_note RprMidiNote
-- @property string
-- @return integer 
function Reaper:f_n_g__get_midi_note_int_property(midi_note, property)
    return r.FNG_GetMidiNoteIntProperty(midi_note, property)
end

-- [FNG] Set MIDI note property
-- @midi_note RprMidiNote
-- @property string
-- @value integer
function Reaper:f_n_g__set_midi_note_int_property(midi_note, property, value)
    return r.FNG_SetMidiNoteIntProperty(midi_note, property, value)
end

-- returns true if path points to a valid, readable file
-- @path string
-- @return boolean 
function Reaper:file_exists(path)
    return r.file_exists(path)
end

-- Format tpos (which is time in seconds) as hh:mm:ss.sss. See format_timestr_pos, format_timestr_len.
-- @tpos number
-- @buf string
-- @return string 
function Reaper:format_timestr(tpos, buf)
    return r.format_timestr(tpos, buf)
end

-- offset is start of where the length will be calculated from
-- @tpos number
-- @buf string
-- @offset number
-- @modeoverride integer
-- @return string 
function Reaper:format_timestr_len(tpos, buf, offset, modeoverride)
    return r.format_timestr_len(tpos, buf, offset, modeoverride)
end

-- @tpos number
-- @buf string
-- @modeoverride integer
-- @return string 
function Reaper:format_timestr_pos(tpos, buf, modeoverride)
    return r.format_timestr_pos(tpos, buf, modeoverride)
end

-- Runs the system color chooser dialog.  Returns 0 if the user cancels the dialog.
-- @hwnd HWND
-- @return number 
function Reaper:g_r__select_color(hwnd)
    local retval, color = r.GR_SelectColor(hwnd)
    if retval then
        return color
    end
end

-- @g_g_u_i_d string
-- @return string 
function Reaper:gen_guid(g_g_u_i_d)
    return r.genGuid(g_g_u_i_d)
end

-- is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()Returns contextual information about the script, typically MIDI/OSC input values.
function Reaper:get_action_context()
    return r.get_action_context()
end

-- Returns app version which may include an OS/arch signifier, such as: "6.17" (windows 32-bit), "6.17/x64" (windows 64-bit), "6.17/OSX64" (macOS 64-bit Intel), "6.17/OSX" (macOS 32-bit), "6.17/macOS-arm64", "6.17/linux-x86_64", "6.17/linux-i686", "6.17/linux-aarch64", "6.17/linux-armv7l", etc
-- @return string 
function Reaper:get_app_version()
    return r.GetAppVersion()
end

-- gets the currently armed command and section name (returns 0 if nothing armed). section name is empty-string for main section.
-- @return string 
function Reaper:get_armed_command()
    local retval, sec = r.GetArmedCommand()
    if retval then
        return sec
    end
end

-- Get the end time of the audio that can be returned from this accessor. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorSamples.
-- @accessor AudioAccessor
-- @return number 
function Reaper:get_audio_accessor_end_time(accessor)
    return r.GetAudioAccessorEndTime(accessor)
end

-- Deprecated. See AudioAccessorStateChanged instead.
-- @accessor AudioAccessor
-- @hash_need128 string
-- @return string 
function Reaper:get_audio_accessor_hash(accessor, hash_need128)
    return r.GetAudioAccessorHash(accessor, hash_need128)
end

-- @accessor AudioAccessor
-- @samplerate integer
-- @numchannels integer
-- @starttime_sec number
-- @numsamplesperchannel integer
-- @samplebuffer reaper.array
-- @return integer 
function Reaper:get_audio_accessor_samples(accessor, samplerate, numchannels, starttime_sec, numsamplesperchannel, samplebuffer)
    return r.GetAudioAccessorSamples(accessor, samplerate, numchannels, starttime_sec, numsamplesperchannel, samplebuffer)
end

-- Get the start time of the audio that can be returned from this accessor. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorEndTime, GetAudioAccessorSamples.
-- @accessor AudioAccessor
-- @return number 
function Reaper:get_audio_accessor_start_time(accessor)
    return r.GetAudioAccessorStartTime(accessor)
end

-- get information about the currently open audio device. attribute can be MODE, IDENT_IN, IDENT_OUT, BSIZE, SRATE, BPS. returns false if unknown attribute or device not open.
-- @attribute string
-- @desc string
-- @return string 
function Reaper:get_audio_device_info(attribute, desc)
    local retval, desc_ = r.GetAudioDeviceInfo(attribute, desc)
    if retval then
        return desc_
    end
end

-- gets ini configuration variable value as string
-- @name string
-- @return string 
function Reaper:get_config_var_string(name)
    local retval, buf = r.get_config_var_string(name)
    if retval then
        return buf
    end
end

-- gets the dock ID desired by ident_str, if any
-- @ident_str string
-- @return integer 
function Reaper:get_config_wants_dock(ident_str)
    return r.GetConfigWantsDock(ident_str)
end

-- returns current project if in load/save (usually only used from project_config_extension_t)
-- @return ReaProject 
function Reaper:get_current_project_in_load_save()
    return r.GetCurrentProjectInLoadSave()
end

-- return the current cursor context: 0 if track panels, 1 if items, 2 if envelopes, otherwise unknown
-- @return integer 
function Reaper:get_cursor_context()
    return r.GetCursorContext()
end

-- 0 if track panels, 1 if items, 2 if envelopes, otherwise unknown (unlikely when want_last_valid is true)
-- @want_last_valid boolean
-- @return integer 
function Reaper:get_cursor_context2(want_last_valid)
    return r.GetCursorContext2(want_last_valid)
end

-- edit cursor position
-- @return number 
function Reaper:get_cursor_position()
    return r.GetCursorPosition()
end

-- returns path of REAPER.exe (not including EXE), i.e. C:\Program Files\REAPER
-- @return string 
function Reaper:get_exe_path()
    return r.GetExePath()
end

-- Get the extended state value for a specific section and key. See SetExtState, DeleteExtState, HasExtState.
-- @section string
-- @key string
-- @return string 
function Reaper:get_ext_state(section, key)
    return r.GetExtState(section, key)
end

-- This function is deprecated (returns GetFocusedFX2()&3), see GetFocusedFX2.
-- @return number, number, number 
function Reaper:get_focused_f_x()
    local retval, tracknumber, itemnumber, fxnumber = r.GetFocusedFX()
    if retval then
        return tracknumber, itemnumber, fxnumber
    end
end

-- Return value has 1 set if track FX, 2 if take/item FX, 4 set if FX is no longer focused but still open. tracknumber==0 means the master track, 1 means track 1, etc. itemnumber is zero-based (or -1 if not an item). For interpretation of fxnumber, see GetLastTouchedFX.
-- @return number, number, number 
function Reaper:get_focused_f_x2()
    local retval, tracknumber, itemnumber, fxnumber = r.GetFocusedFX2()
    if retval then
        return tracknumber, itemnumber, fxnumber
    end
end

-- return -1=no override, 0=trim/read, 1=read, 2=touch, 3=write, 4=latch, 5=bypass
-- @return integer 
function Reaper:get_global_automation_override()
    return r.GetGlobalAutomationOverride()
end

-- returns pixels/second
-- @return number 
function Reaper:get_h_zoom_level()
    return r.GetHZoomLevel()
end

-- Get reaper.ini full filename.
-- @return string 
function Reaper:get_ini_file()
    return r.get_ini_file()
end

-- @channel_index integer
-- @return string 
function Reaper:get_input_channel_name(channel_index)
    return r.GetInputChannelName(channel_index)
end

-- Gets the audio device input/output latency in samples
-- @return number, number 
function Reaper:get_input_output_latency()
    return r.GetInputOutputLatency()
end

-- returns time of relevant edit, set which_item to the pcm_source (if applicable), flags (if specified) will be set to 1 for edge resizing, 2 for fade change, 4 for item move, 8 for item slip edit (edit cursor time or start of item)
-- @return PCM_source, number 
function Reaper:get_item_editing_time2()
    local retval, which_item, flags = r.GetItemEditingTime2()
    if retval then
        return which_item, flags
    end
end

-- Returns the first item at the screen coordinates specified. If allow_locked is false, locked items are ignored. If takeOutOptional specified, returns the take hit.
-- @screen_x integer
-- @screen_y integer
-- @allow_locked boolean
-- @return MediaItem_Take 
function Reaper:get_item_from_point(screen_x, screen_y, allow_locked)
    local retval, take = r.GetItemFromPoint(screen_x, screen_y, allow_locked)
    if retval then
        return take
    end
end

-- @return string 
function Reaper:get_last_color_theme_file()
    return r.GetLastColorThemeFile()
end

-- Returns true if the last touched FX parameter is valid, false otherwise. The low word of tracknumber is the 1-based track index -- 0 means the master track, 1 means track 1, etc. If the high word of tracknumber is nonzero, it refers to the 1-based item index (1 is the first item on the track, etc). For track FX, the low 24 bits of fxnumber refer to the FX index in the chain, and if the next 8 bits are 01, then the FX is record FX. For item FX, the low word defines the FX index in the chain, and the high word defines the take number.
-- @return number, number, number 
function Reaper:get_last_touched_f_x()
    local retval, tracknumber, fxnumber, paramnumber = r.GetLastTouchedFX()
    if retval then
        return tracknumber, fxnumber, paramnumber
    end
end

-- @return MediaTrack 
function Reaper:get_last_touched_track()
    return r.GetLastTouchedTrack()
end

-- returns true if device present
-- @dev integer
-- @nameout string
-- @return string 
function Reaper:get_m_i_d_i_input_name(dev, nameout)
    local retval, nameout_ = r.GetMIDIInputName(dev, nameout)
    if retval then
        return nameout_
    end
end

-- returns true if device present
-- @dev integer
-- @nameout string
-- @return string 
function Reaper:get_m_i_d_i_output_name(dev, nameout)
    local retval, nameout_ = r.GetMIDIOutputName(dev, nameout)
    if retval then
        return nameout_
    end
end

-- @return HWND 
function Reaper:get_main_hwnd()
    return r.GetMainHwnd()
end

-- &1=master mute,&2=master solo. This is deprecated as you can just query the master track as well.
-- @return integer 
function Reaper:get_master_mute_solo_flags()
    return r.GetMasterMuteSoloFlags()
end

-- returns &1 if the master track is visible in the TCP, &2 if NOT visible in the mixer. See SetMasterTrackVisibility.
-- @return integer 
function Reaper:get_master_track_visibility()
    return r.GetMasterTrackVisibility()
end

-- returns max dev for midi inputs/outputs
-- @return integer 
function Reaper:get_max_midi_inputs()
    return r.GetMaxMidiInputs()
end

-- @return integer 
function Reaper:get_max_midi_outputs()
    return r.GetMaxMidiOutputs()
end

-- Get the leftmost track visible in the mixer
-- @return MediaTrack 
function Reaper:get_mixer_scroll()
    return r.GetMixerScroll()
end

-- @context string
-- @modifier_flag integer
-- @action string
-- @return string 
function Reaper:get_mouse_modifier(context, modifier_flag, action)
    return r.GetMouseModifier(context, modifier_flag, action)
end

-- get mouse position in screen coordinates
-- @return number, number 
function Reaper:get_mouse_position()
    return r.GetMousePosition()
end

-- Return number of normal audio hardware inputs available
-- @return integer 
function Reaper:get_num_audio_inputs()
    return r.GetNumAudioInputs()
end

-- Return number of normal audio hardware outputs available
-- @return integer 
function Reaper:get_num_audio_outputs()
    return r.GetNumAudioOutputs()
end

-- returns max number of real midi hardware inputs
-- @return integer 
function Reaper:get_num_m_i_d_i_inputs()
    return r.GetNumMIDIInputs()
end

-- returns max number of real midi hardware outputs
-- @return integer 
function Reaper:get_num_m_i_d_i_outputs()
    return r.GetNumMIDIOutputs()
end

-- @return integer 
function Reaper:get_num_tracks()
    return r.GetNumTracks()
end

-- Returns "Win32", "Win64", "OSX32", "OSX64", "macOS-arm64", or "Other".
-- @return string 
function Reaper:get_o_s()
    return r.GetOS()
end

-- @channel_index integer
-- @return string 
function Reaper:get_output_channel_name(channel_index)
    return r.GetOutputChannelName(channel_index)
end

-- returns output latency in seconds
-- @return number 
function Reaper:get_output_latency()
    return r.GetOutputLatency()
end

-- get the peak file name for a given file (can be either filename.reapeaks,or a hashed filename in another path)
-- @fn string
-- @buf string
-- @return string 
function Reaper:get_peak_file_name(fn, buf)
    return r.GetPeakFileName(fn, buf)
end

-- get the peak file name for a given file (can be either filename.reapeaks,or a hashed filename in another path)
-- @fn string
-- @buf string
-- @for_write boolean
-- @return string 
function Reaper:get_peak_file_name_ex(fn, buf, for_write)
    return r.GetPeakFileNameEx(fn, buf, for_write)
end

-- Like GetPeakFileNameEx, but you can specify peaksfileextension such as ".reapeaks"
-- @fn string
-- @buf string
-- @for_write boolean
-- @peaksfileextension string
-- @return string 
function Reaper:get_peak_file_name_ex2(fn, buf, for_write, peaksfileextension)
    return r.GetPeakFileNameEx2(fn, buf, for_write, peaksfileextension)
end

-- returns latency-compensated actual-what-you-hear position
-- @return number 
function Reaper:get_play_position()
    return r.GetPlayPosition()
end

-- returns position of next audio block being processed
-- @return number 
function Reaper:get_play_position2()
    return r.GetPlayPosition2()
end

-- &1=playing,&2=pause,&=4 is recording
-- @return integer 
function Reaper:get_play_state()
    return r.GetPlayState()
end

-- Get the project recording path.
-- @buf string
-- @return string 
function Reaper:get_project_path(buf)
    return r.GetProjectPath(buf)
end

-- deprecated
-- @return number, number 
function Reaper:get_project_time_signature()
    return r.GetProjectTimeSignature()
end

-- returns path where ini files are stored, other things are in subdirectories.
-- @return string 
function Reaper:get_resource_path()
    return r.GetResourcePath()
end

-- @is_set boolean
-- @is_loop boolean
-- @start number
-- @end_ number
-- @allowautoseek boolean
-- @return number, number 
function Reaper:get_set__loop_time_range(is_set, is_loop, start, end_, allowautoseek)
    return r.GetSet_LoopTimeRange(is_set, is_loop, start, end_, allowautoseek)
end

-- -1 == query,0=clear,1=set,>1=toggle . returns new value
-- @val integer
-- @return integer 
function Reaper:get_set_repeat(val)
    return r.GetSetRepeat(val)
end

-- Returns the theme color specified, or -1 on failure. If the low bit of flags is set, the color as originally specified by the theme (before any transformations) is returned, otherwise the current (possibly transformed and modified) color is returned. See SetThemeColor for a list of valid ini_key.
-- @ini_key string
-- @flags integer
-- @return integer 
function Reaper:get_theme_color(ini_key, flags)
    return r.GetThemeColor(ini_key, flags)
end

-- See GetToggleCommandStateEx.
-- @command_id integer
-- @return integer 
function Reaper:get_toggle_command_state(command_id)
    return r.GetToggleCommandState(command_id)
end

-- For the main action context, the MIDI editor, or the media explorer, returns the toggle state of the action. 0=off, 1=on, -1=NA because the action does not have on/off states. For the MIDI editor, the action state for the most recently focused window will be returned.
-- @section_id integer
-- @command_id integer
-- @return integer 
function Reaper:get_toggle_command_state_ex(section_id, command_id)
    return r.GetToggleCommandStateEx(section_id, command_id)
end

-- gets a tooltip window,in case you want to ask it for font information. Can return NULL.
-- @return HWND 
function Reaper:get_tooltip_window()
    return r.GetTooltipWindow()
end

-- Returns the track from the screen coordinates specified. If the screen coordinates refer to a window associated to the track (such as FX), the track will be returned. infoOutOptional will be set to 1 if it is likely an envelope, 2 if it is likely a track FX.
-- @screen_x integer
-- @screen_y integer
-- @return number 
function Reaper:get_track_from_point(screen_x, screen_y)
    local retval, info = r.GetTrackFromPoint(screen_x, screen_y)
    if retval then
        return info
    end
end

-- see GetTrackMIDINoteNameEx
-- @track integer
-- @pitch integer
-- @chan integer
-- @return string 
function Reaper:get_track_m_i_d_i_note_name(track, pitch, chan)
    return r.GetTrackMIDINoteName(track, pitch, chan)
end

-- retrieves the last timestamps of audio xrun (yellow-flash, if available), media xrun (red-flash), and the current time stamp (all milliseconds)
-- @return number, number, number 
function Reaper:get_underrun_time()
    return r.GetUnderrunTime()
end

-- returns true if the user selected a valid file, false if the user canceled the dialog
-- @filename_need4096 string
-- @title string
-- @defext string
-- @return string 
function Reaper:get_user_file_name_for_read(filename_need4096, title, defext)
    local retval, filename_need4096_ = r.GetUserFileNameForRead(filename_need4096, title, defext)
    if retval then
        return filename_need4096_
    end
end

-- Maximum fields is 16. Values are returned as a comma-separated string. Returns false if the user canceled the dialog. You can supply special extra information via additional caption fields: extrawidth=XXX to increase text field width, separator=X to use a different separator for returned fields.
-- @title string
-- @num_inputs integer
-- @captions_csv string
-- @retvals_csv string
-- @return string 
function Reaper:get_user_inputs(title, num_inputs, captions_csv, retvals_csv)
    local retval, retvals_csv_ = r.GetUserInputs(title, num_inputs, captions_csv, retvals_csv)
    if retval then
        return retvals_csv_
    end
end

-- Causes gmem_read()/gmem_write() to read EEL2/JSFX/Video shared memory segment named by parameter. Set to empty string to detach. 6.20+: returns previous shared memory segment name.
-- @retval sharedMemoryName
function Reaper:gmem_attach(retval)
    return r.gmem_attach(retval)
end

-- Read (number) value from shared memory attached-to by gmem_attach(). index can be [0..1<<25).
-- @retval index
function Reaper:gmem_read(retval)
    return r.gmem_read(retval)
end

-- Write (number) value to shared memory attached-to by gmem_attach(). index can be [0..1<<25).
-- @retval index
-- @retval value
function Reaper:gmem_write(retval, retval)
    return r.gmem_write(retval, retval)
end

-- dest should be at least 64 chars long to be safe
-- @g_g_u_i_d string
-- @dest_need64 string
-- @return string 
function Reaper:guid_to_string(g_g_u_i_d, dest_need64)
    return r.guidToString(g_g_u_i_d, dest_need64)
end

-- Returns true if there exists an extended state value for a specific section and key. See SetExtState, GetExtState, DeleteExtState.
-- @section string
-- @key string
-- @return boolean 
function Reaper:has_ext_state(section, key)
    return r.HasExtState(section, key)
end

-- returns name of track plugin that is supplying MIDI programs,or NULL if there is none
-- @track integer
-- @return string 
function Reaper:has_track_m_i_d_i_programs(track)
    return r.HasTrackMIDIPrograms(track)
end

-- @helpstring string
-- @is_temporary_help boolean
function Reaper:help__set(helpstring, is_temporary_help)
    return r.Help_Set(helpstring, is_temporary_help)
end

-- @in_ string
-- @out string
-- @return string 
function Reaper:image_resolve_fn(in_, out)
    return r.image_resolve_fn(in_, out)
end

-- mode: 0=add to current track, 1=add new track, 3=add to selected items as takes, &4=stretch/loop to fit time sel, &8=try to match tempo 1x, &16=try to match tempo 0.5x, &32=try to match tempo 2x, &64=don't preserve pitch when matching tempo, &128=no loop/section if startpct/endpct set, &256=force loop regardless of global preference for looping imported items, &512=use high word as absolute track index if mode&3==0, &1024=insert into reasamplomatic on a new track, &2048=insert into open reasamplomatic instance, &4096=move to source preferred position (BWF start offset), &8192=reverse
-- @file string
-- @mode integer
-- @return integer 
function Reaper:insert_media(file, mode)
    return r.InsertMedia(file, mode)
end

-- See InsertMedia.
-- @file string
-- @mode integer
-- @startpct number
-- @endpct number
-- @pitchshift number
-- @return integer 
function Reaper:insert_media_section(file, mode, startpct, endpct, pitchshift)
    return r.InsertMediaSection(file, mode, startpct, endpct, pitchshift)
end

-- inserts a track at idx,of course this will be clamped to 0..GetNumTracks(). wantDefaults=TRUE for default envelopes/FX,otherwise no enabled fx/env
-- @idx integer
-- @want_defaults boolean
function Reaper:insert_track_at_index(idx, want_defaults)
    return r.InsertTrackAtIndex(idx, want_defaults)
end

-- If wantOthers is set, then "RPP", "TXT" and other project-type formats will also pass.
-- @ext string
-- @want_others boolean
-- @return boolean 
function Reaper:is_media_extension(ext, want_others)
    return r.IsMediaExtension(ext, want_others)
end

-- creates a joystick device
-- @guid_g_u_i_d string
-- @return joystick_device 
function Reaper:joystick_create(guid_g_u_i_d)
    return r.joystick_create(guid_g_u_i_d)
end

-- destroys a joystick device
-- @device joystick_device
function Reaper:joystick_destroy(device)
    return r.joystick_destroy(device)
end

-- enumerates installed devices, returns GUID as a string
-- @index integer
-- @return string 
function Reaper:joystick_enum(index)
    local retval, namestr = r.joystick_enum(index)
    if retval then
        return namestr
    end
end

-- returns axis value (-1..1)
-- @dev joystick_device
-- @axis integer
-- @return number 
function Reaper:joystick_getaxis(dev, axis)
    return r.joystick_getaxis(dev, axis)
end

-- returns button pressed mask, 1=first button, 2=second...
-- @dev joystick_device
-- @return integer 
function Reaper:joystick_getbuttonmask(dev)
    return r.joystick_getbuttonmask(dev)
end

-- returns button count
-- @dev joystick_device
-- @return number, number 
function Reaper:joystick_getinfo(dev)
    local retval, axes, povs = r.joystick_getinfo(dev)
    if retval then
        return axes, povs
    end
end

-- returns POV value (usually 0..655.35, or 655.35 on error)
-- @dev joystick_device
-- @pov integer
-- @return number 
function Reaper:joystick_getpov(dev, pov)
    return r.joystick_getpov(dev, pov)
end

-- Updates joystick state from hardware, returns true if successful (joystick_get* will not be valid until joystick_update() is called successfully)
-- @dev joystick_device
-- @return boolean 
function Reaper:joystick_update(dev)
    return r.joystick_update(dev)
end

-- Returns false if the line is entirely offscreen.
-- @p_x1 number
-- @p_y1 number
-- @p_x2 number
-- @p_y2 number
-- @x_lo integer
-- @y_lo integer
-- @x_hi integer
-- @y_hi integer
-- @return number, number, number, number 
function Reaper:l_i_c_e__clip_line(p_x1, p_y1, p_x2, p_y2, x_lo, y_lo, x_hi, y_hi)
    local retval, p_x1_, p_y1_, p_x2_, p_y2_ = r.LICE_ClipLine(p_x1, p_y1, p_x2, p_y2, x_lo, y_lo, x_hi, y_hi)
    if retval then
        return p_x1_, p_y1_, p_x2_, p_y2_
    end
end

-- Returns a localized version of src_string, in section section. flags can have 1 set to only localize if sprintf-style formatting matches the original.
-- @src_string string
-- @section string
-- @flags integer
-- @return string 
function Reaper:localize_string(src_string, section, flags)
    return r.LocalizeString(src_string, section, flags)
end

-- type 0=OK,1=OKCANCEL,2=ABORTRETRYIGNORE,3=YESNOCANCEL,4=YESNO,5=RETRYCANCEL : ret 1=OK,2=CANCEL,3=ABORT,4=RETRY,5=IGNORE,6=YES,7=NO
-- @msg string
-- @title string
-- @type integer
-- @return integer 
function Reaper:m_b(msg, title, type)
    return r.MB(msg, title, type)
end

-- see MIDIEditor_GetMode, MIDIEditor_OnCommand
-- @return HWND 
function Reaper:m_i_d_i_editor__get_active()
    return r.MIDIEditor_GetActive()
end

-- see MIDIEditor_GetActive, MIDIEditor_OnCommand
-- @midieditor HWND
-- @return integer 
function Reaper:m_i_d_i_editor__get_mode(midieditor)
    return r.MIDIEditor_GetMode(midieditor)
end

-- @midieditor HWND
-- @setting_desc string
-- @return integer 
function Reaper:m_i_d_i_editor__get_setting_int(midieditor, setting_desc)
    return r.MIDIEditor_GetSetting_int(midieditor, setting_desc)
end

-- @midieditor HWND
-- @setting_desc string
-- @buf string
-- @return string 
function Reaper:m_i_d_i_editor__get_setting_str(midieditor, setting_desc, buf)
    local retval, buf_ = r.MIDIEditor_GetSetting_str(midieditor, setting_desc, buf)
    if retval then
        return buf_
    end
end

-- get the take that is currently being edited in this MIDI editor
-- @midieditor HWND
-- @return MediaItem_Take 
function Reaper:m_i_d_i_editor__get_take(midieditor)
    return r.MIDIEditor_GetTake(midieditor)
end

-- see MIDIEditor_OnCommand
-- @command_id integer
-- @islistviewcommand boolean
-- @return boolean 
function Reaper:m_i_d_i_editor__last_focused__on_command(command_id, islistviewcommand)
    return r.MIDIEditor_LastFocused_OnCommand(command_id, islistviewcommand)
end

-- see MIDIEditor_GetActive, MIDIEditor_LastFocused_OnCommand
-- @midieditor HWND
-- @command_id integer
-- @return boolean 
function Reaper:m_i_d_i_editor__on_command(midieditor, command_id)
    return r.MIDIEditor_OnCommand(midieditor, command_id)
end

-- @midieditor HWND
-- @setting_desc string
-- @setting integer
-- @return boolean 
function Reaper:m_i_d_i_editor__set_setting_int(midieditor, setting_desc, setting)
    return r.MIDIEditor_SetSetting_int(midieditor, setting_desc, setting)
end

-- See Main_OnCommandEx.
-- @command integer
-- @flag integer
function Reaper:main__on_command(command, flag)
    return r.Main_OnCommand(command, flag)
end

-- Performs an action belonging to the main action section. To perform non-native actions (ReaScripts, custom or extension plugins' actions) safely, see NamedCommandLookup().
-- @command integer
-- @flag integer
-- @proj ReaProject
function Reaper:main__on_command_ex(command, flag, proj)
    return r.Main_OnCommandEx(command, flag, proj)
end

-- @ignoremask integer
function Reaper:main__update_loop_info(ignoremask)
    return r.Main_UpdateLoopInfo(ignoremask)
end

-- If passed a .RTrackTemplate file, adds the template to the existing project.
-- @name string
function Reaper:main_open_project(name)
    return r.Main_openProject(name)
end

-- @time_s number
-- @proj ReaProject
-- @return number 
function Reaper:master__get_play_rate_at_time(time_s, proj)
    return r.Master_GetPlayRateAtTime(time_s, proj)
end

-- @return number 
function Reaper:master__get_tempo()
    return r.Master_GetTempo()
end

-- Convert play rate to/from a value between 0 and 1, representing the position on the project playrate slider.
-- @playrate number
-- @isnormalized boolean
-- @return number 
function Reaper:master__normalize_play_rate(playrate, isnormalized)
    return r.Master_NormalizePlayRate(playrate, isnormalized)
end

-- Convert the tempo to/from a value between 0 and 1, representing bpm in the range of 40-296 bpm.
-- @bpm number
-- @isnormalized boolean
-- @return number 
function Reaper:master__normalize_tempo(bpm, isnormalized)
    return r.Master_NormalizeTempo(bpm, isnormalized)
end

-- Reset all MIDI devices
function Reaper:midi_reinit()
    return r.midi_reinit()
end

-- @str_need64 string
-- @pan number
-- @return string 
function Reaper:mkpanstr(str_need64, pan)
    return r.mkpanstr(str_need64, pan)
end

-- @str_need64 string
-- @vol number
-- @pan number
-- @return string 
function Reaper:mkvolpanstr(str_need64, vol, pan)
    return r.mkvolpanstr(str_need64, vol, pan)
end

-- @str_need64 string
-- @vol number
-- @return string 
function Reaper:mkvolstr(str_need64, vol)
    return r.mkvolstr(str_need64, vol)
end

-- @adjamt number
-- @dosel boolean
function Reaper:move_edit_cursor(adjamt, dosel)
    return r.MoveEditCursor(adjamt, dosel)
end

-- @mute boolean
function Reaper:mute_all_tracks(mute)
    return r.MuteAllTracks(mute)
end

-- @retval numberr.left
-- @retval numberr.top
-- @retval numberr.right
-- @retval numberr.bot
-- @sr_left number
-- @sr_top number
-- @sr_right number
-- @sr_bot number
-- @want_work_area boolean
function Reaper:my_get_viewport(retval, retval, retval, retval, sr_left, sr_top, sr_right, sr_bot, want_work_area)
    return r.my_getViewport(retval, retval, retval, retval, sr_left, sr_top, sr_right, sr_bot, want_work_area)
end

-- Get the command ID number for named command that was registered by an extension such as "_SWS_ABOUT" or "_113088d11ae641c193a2b7ede3041ad5" for a ReaScript or a custom action.
-- @command_name string
-- @return integer 
function Reaper:named_command_lookup(command_name)
    return r.NamedCommandLookup(command_name)
end

-- Creates a new reaper.array object of maximum and initial size size, if specified, or from the size/values of a table/array. Both size and table/array can be specified, the size parameter will override the table/array size.
-- @retval [table|array][size]
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

-- @fn string
-- @return boolean 
function Reaper:open_color_theme_file(fn)
    return r.OpenColorThemeFile(fn)
end

-- Opens mediafn in the Media Explorer, play=true will play the file immediately (or toggle playback if mediafn was already open), =false will just select it.
-- @mediafn string
-- @play boolean
-- @return HWND 
function Reaper:open_media_explorer(mediafn, play)
    return r.OpenMediaExplorer(mediafn, play)
end

-- Send an OSC message directly to REAPER. The value argument may be NULL. The message will be matched against the default OSC patterns. Only supported if control surface support was enabled when installing REAPER.
-- @message string
-- @value_in number
function Reaper:osc_local_message_to_host(message, value_in)
    return r.OscLocalMessageToHost(message, value_in)
end

-- @idx integer
-- @return string 
function Reaper:p_c_m__sink__enum(idx)
    local retval, descstr = r.PCM_Sink_Enum(idx)
    if retval then
        return descstr
    end
end

-- @data string
-- @return string 
function Reaper:p_c_m__sink__get_extension(data)
    return r.PCM_Sink_GetExtension(data)
end

-- @cfg string
-- @hwnd_parent HWND
-- @return HWND 
function Reaper:p_c_m__sink__show_config(cfg, hwnd_parent)
    return r.PCM_Sink_ShowConfig(cfg, hwnd_parent)
end

-- See PCM_Source_CreateFromFileEx.
-- @filename string
-- @return PCM_source 
function Reaper:p_c_m__source__create_from_file(filename)
    return r.PCM_Source_CreateFromFile(filename)
end

-- Create a PCM_source from filename, and override pref of MIDI files being imported as in-project MIDI events.
-- @filename string
-- @forceno_midi_imp boolean
-- @return PCM_source 
function Reaper:p_c_m__source__create_from_file_ex(filename, forceno_midi_imp)
    return r.PCM_Source_CreateFromFileEx(filename, forceno_midi_imp)
end

-- Valid types include "WAVE", "MIDI", or whatever plug-ins define as well.
-- @sourcetype string
-- @return PCM_source 
function Reaper:p_c_m__source__create_from_type(sourcetype)
    return r.PCM_Source_CreateFromType(sourcetype)
end

-- Parse hh:mm:ss.sss time string, return time in seconds (or 0.0 on error). See parse_timestr_pos, parse_timestr_len.
-- @buf string
-- @return number 
function Reaper:parse_timestr(buf)
    return r.parse_timestr(buf)
end

-- @buf string
-- @offset number
-- @modeoverride integer
-- @return number 
function Reaper:parse_timestr_len(buf, offset, modeoverride)
    return r.parse_timestr_len(buf, offset, modeoverride)
end

-- @buf string
-- @modeoverride integer
-- @return number 
function Reaper:parse_timestr_pos(buf, modeoverride)
    return r.parse_timestr_pos(buf, modeoverride)
end

-- @str string
-- @return number 
function Reaper:parsepanstr(str)
    return r.parsepanstr(str)
end

-- @amt integer
function Reaper:plugin_wants_always_run_fx(amt)
    return r.PluginWantsAlwaysRunFx(amt)
end

-- adds prevent_count to the UI refresh prevention state; always add then remove the same amount, or major disfunction will occur
-- @prevent_count integer
function Reaper:prevent_u_i_refresh(prevent_count)
    return r.PreventUIRefresh(prevent_count)
end

-- Uses the action list to choose an action. Call with session_mode=1 to create a session (init_id will be the initial action to select, or 0), then poll with session_mode=0, checking return value for user-selected action (will return 0 if no action selected yet, or -1 if the action window is no longer available). When finished, call with session_mode=-1.
-- @session_mode integer
-- @init_id integer
-- @section_id integer
-- @return integer 
function Reaper:prompt_for_action(session_mode, init_id, section_id)
    return r.PromptForAction(session_mode, init_id, section_id)
end

-- Causes REAPER to display the error message after the current ReaScript finishes. If called within a Lua context and errmsg has a ! prefix, script execution will be terminated.
-- @errmsg string
function Reaper:rea_script_error(errmsg)
    return r.ReaScriptError(errmsg)
end

-- returns positive value on success, 0 on failure.
-- @path string
-- @ignored integer
-- @return integer 
function Reaper:recursive_create_directory(path, ignored)
    return r.RecursiveCreateDirectory(path, ignored)
end

-- garbage-collects extra open files and closes them. if flags has 1 set, this is done incrementally (call this from a regular timer, if desired). if flags has 2 set, files are aggressively closed (they may need to be re-opened very soon). returns number of files closed by this call.
-- @flags integer
-- @return integer 
function Reaper:reduce_open_files(flags)
    return r.reduce_open_files(flags)
end

-- See RefreshToolbar2.
-- @command_id integer
function Reaper:refresh_toolbar(command_id)
    return r.RefreshToolbar(command_id)
end

-- Refresh the toolbar button states of a toggle action.
-- @section_id integer
-- @command_id integer
function Reaper:refresh_toolbar2(section_id, command_id)
    return r.RefreshToolbar2(section_id, command_id)
end

-- Makes a filename "in" relative to the current project, if any.
-- @in_ string
-- @out string
-- @return string 
function Reaper:relative_fn(in_, out)
    return r.relative_fn(in_, out)
end

-- Not available while playing back.
-- @source_filename string
-- @target_filename string
-- @start_percent number
-- @end_percent number
-- @playrate number
-- @return boolean 
function Reaper:render_file_section(source_filename, target_filename, start_percent, end_percent, playrate)
    return r.RenderFileSection(source_filename, target_filename, start_percent, end_percent, playrate)
end

-- Moves all selected tracks to immediately above track specified by index beforeTrackIdx, returns false if no tracks were selected. makePrevFolder=0 for normal, 1 = as child of track preceding track specified by beforeTrackIdx, 2 = if track preceding track specified by beforeTrackIdx is last track in folder, extend folder
-- @before_track_idx integer
-- @make_prev_folder integer
-- @return boolean 
function Reaper:reorder_selected_tracks(before_track_idx, make_prev_folder)
    return r.ReorderSelectedTracks(before_track_idx, make_prev_folder)
end

-- @mode integer
-- @return string 
function Reaper:resample__enum_modes(mode)
    return r.Resample_EnumModes(mode)
end

-- See resolve_fn2.
-- @in_ string
-- @out string
-- @return string 
function Reaper:resolve_fn(in_, out)
    return r.resolve_fn(in_, out)
end

-- Resolves a filename "in" by using project settings etc. If no file found, out will be a copy of in.
-- @in_ string
-- @out string
-- @check_sub_dir string
-- @return string 
function Reaper:resolve_fn2(in_, out, check_sub_dir)
    return r.resolve_fn2(in_, out, check_sub_dir)
end

-- Get the named command for the given command ID. The returned string will not start with '_' (e.g. it will return "SWS_ABOUT"), it will be NULL if command_id is a native action.
-- @command_id integer
-- @return string 
function Reaper:reverse_named_command_lookup(command_id)
    return r.ReverseNamedCommandLookup(command_id)
end

-- Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input, while the user does other tasks. Identical to defer().Note that no undo point will be automatically created when the script finishes, unless you create it explicitly.
-- @retval function
function Reaper:runloop(retval)
    return r.runloop(retval)
end

-- @y number
-- @return number 
function Reaper:s_l_i_d_e_r2_d_b(y)
    return r.SLIDER2DB(y)
end

-- Focuses the active/open MIDI editor.
function Reaper:s_n__focus_m_i_d_i_editor()
    return r.SN_FocusMIDIEditor()
end

-- See GetEnvelopeScalingMode.
-- @scaling_mode integer
-- @val number
-- @return number 
function Reaper:scale_from_envelope_mode(scaling_mode, val)
    return r.ScaleFromEnvelopeMode(scaling_mode, val)
end

-- See GetEnvelopeScalingMode.
-- @scaling_mode integer
-- @val number
-- @return number 
function Reaper:scale_to_envelope_mode(scaling_mode, val)
    return r.ScaleToEnvelopeMode(scaling_mode, val)
end

-- sets all or selected tracks to mode.
-- @mode integer
-- @only_sel boolean
function Reaper:set_automation_mode(mode, only_sel)
    return r.SetAutomationMode(mode, only_sel)
end

-- You must use this to change the focus programmatically. mode=0 to focus track panels, 1 to focus the arrange window, 2 to focus the arrange window and select env (or env==NULL to clear the current track/take envelope selection)
-- @mode integer
-- @env_in TrackEnvelope
function Reaper:set_cursor_context(mode, env_in)
    return r.SetCursorContext(mode, env_in)
end

-- @time number
-- @moveview boolean
-- @seekplay boolean
function Reaper:set_edit_cur_pos(time, moveview, seekplay)
    return r.SetEditCurPos(time, moveview, seekplay)
end

-- Set the extended state value for a specific section and key. persist=true means the value should be stored and reloaded the next time REAPER is opened. See GetExtState, DeleteExtState, HasExtState.
-- @section string
-- @key string
-- @value string
-- @persist boolean
function Reaper:set_ext_state(section, key, value, persist)
    return r.SetExtState(section, key, value, persist)
end

-- mode: see GetGlobalAutomationOverride
-- @mode integer
function Reaper:set_global_automation_override(mode)
    return r.SetGlobalAutomationOverride(mode)
end

-- set &1 to show the master track in the TCP, &2 to HIDE in the mixer. Returns the previous visibility state. See GetMasterTrackVisibility.
-- @flag integer
-- @return integer 
function Reaper:set_master_track_visibility(flag)
    return r.SetMasterTrackVisibility(flag)
end

-- @context string
-- @modifier_flag integer
-- @action string
function Reaper:set_mouse_modifier(context, modifier_flag, action)
    return r.SetMouseModifier(context, modifier_flag, action)
end

-- @markrgnindexnumber integer
-- @isrgn boolean
-- @pos number
-- @rgnend number
-- @name string
-- @return boolean 
function Reaper:set_project_marker(markrgnindexnumber, isrgn, pos, rgnend, name)
    return r.SetProjectMarker(markrgnindexnumber, isrgn, pos, rgnend, name)
end

-- @ini_key string
-- @color integer
-- @flags integer
-- @return integer 
function Reaper:set_theme_color(ini_key, color, flags)
    return r.SetThemeColor(ini_key, color, flags)
end

-- Updates the toggle state of an action, returns true if succeeded. Only ReaScripts can have their toggle states changed programmatically. See RefreshToolbar2.
-- @section_id integer
-- @command_id integer
-- @state integer
-- @return boolean 
function Reaper:set_toggle_command_state(section_id, command_id, state)
    return r.SetToggleCommandState(section_id, command_id, state)
end

-- channel < 0 assigns these note names to all channels.
-- @track integer
-- @pitch integer
-- @chan integer
-- @name string
-- @return boolean 
function Reaper:set_track_m_i_d_i_note_name(track, pitch, chan, name)
    return r.SetTrackMIDINoteName(track, pitch, chan, name)
end

-- @caller KbdSectionInfo
-- @caller_wnd HWND
function Reaper:show_action_list(caller, caller_wnd)
    return r.ShowActionList(caller, caller_wnd)
end

-- Show a message to the user (also useful for debugging). Send "\n" for newline, "" to clear the console. See ClearConsole
-- @msg string
function Reaper:show_console_msg(msg)
    return r.ShowConsoleMsg(msg)
end

-- type 0=OK,1=OKCANCEL,2=ABORTRETRYIGNORE,3=YESNOCANCEL,4=YESNO,5=RETRYCANCEL : ret 1=OK,2=CANCEL,3=ABORT,4=RETRY,5=IGNORE,6=YES,7=NO
-- @msg string
-- @title string
-- @type integer
-- @return integer 
function Reaper:show_message_box(msg, title, type)
    return r.ShowMessageBox(msg, title, type)
end

-- shows a context menu, valid names include: track_input, track_panel, track_area, track_routing, item, ruler, envelope, envelope_point, envelope_item. ctxOptional can be a track pointer for track_*, item pointer for item* (but is optional). for envelope_point, ctx2Optional has point index, ctx3Optional has item index (0=main envelope, 1=first AI). for envelope_item, ctx2Optional has AI index (1=first AI)
-- @name string
-- @x integer
-- @y integer
-- @hwnd_parent HWND
-- @ctx identifier
-- @ctx2 integer
-- @ctx3 integer
function Reaper:show_popup_menu(name, x, y, hwnd_parent, ctx, ctx2, ctx3)
    return r.ShowPopupMenu(name, x, y, hwnd_parent, ctx, ctx2, ctx3)
end

-- solo=2 for SIP
-- @solo integer
function Reaper:solo_all_tracks(solo)
    return r.SoloAllTracks(solo)
end

-- gets the splash window, in case you want to display a message over it. Returns NULL when the sphah window is not displayed.
-- @return HWND 
function Reaper:splash__get_wnd()
    return r.Splash_GetWnd()
end

-- @str string
-- @g_g_u_i_d string
-- @return string 
function Reaper:string_to_guid(str, g_g_u_i_d)
    return r.stringToGuid(str, g_g_u_i_d)
end

-- Stuffs a 3 byte MIDI message into either the Virtual MIDI Keyboard queue, or the MIDI-as-control input queue, or sends to a MIDI hardware output. mode=0 for VKB, 1 for control (actions map etc), 2 for VKB-on-current-channel; 16 for external MIDI device 0, 17 for external MIDI device 1, etc; see GetNumMIDIOutputs, GetMIDIOutputName.
-- @mode integer
-- @msg1 integer
-- @msg2 integer
-- @msg3 integer
function Reaper:stuff_m_i_d_i_message(mode, msg1, msg2, msg3)
    return r.StuffMIDIMessage(mode, msg1, msg2, msg3)
end

-- Gets theme layout information. section can be 'global' for global layout override, 'seclist' to enumerate a list of layout sections, otherwise a layout section such as 'mcp', 'tcp', 'trans', etc. idx can be -1 to query the current value, -2 to get the description of the section (if not global), -3 will return the current context DPI-scaling (256=normal, 512=retina, etc), or 0..x. returns false if failed.
-- @section string
-- @idx integer
-- @return string 
function Reaper:theme_layout__get_layout(section, idx)
    local retval, name = r.ThemeLayout_GetLayout(section, idx)
    if retval then
        return name
    end
end

-- returns theme layout parameter. return value is cfg-name, or nil/empty if out of range.
-- @wp integer
-- @return string, number, number, number, number 
function Reaper:theme_layout__get_parameter(wp)
    local retval, desc, value, def_value, min_value, max_value = r.ThemeLayout_GetParameter(wp)
    if retval then
        return desc, value, def_value, min_value, max_value
    end
end

-- Refreshes all layouts
function Reaper:theme_layout__refresh_all()
    return r.ThemeLayout_RefreshAll()
end

-- Sets theme layout override for a particular section -- section can be 'global' or 'mcp' etc. If setting global layout, prefix a ! to the layout string to clear any per-layout overrides. Returns false if failed.
-- @section string
-- @layout string
-- @return boolean 
function Reaper:theme_layout__set_layout(section, layout)
    return r.ThemeLayout_SetLayout(section, layout)
end

-- sets theme layout parameter to value. persist=true in order to have change loaded on next theme load. note that the caller should update layouts via ??? to make changes visible.
-- @wp integer
-- @value integer
-- @persist boolean
-- @return boolean 
function Reaper:theme_layout__set_parameter(wp, value, persist)
    return r.ThemeLayout_SetParameter(wp, value, persist)
end

-- Gets a precise system timestamp in seconds
-- @return number 
function Reaper:time_precise()
    return r.time_precise()
end

-- displays tooltip at location, or removes if empty string
-- @fmt string
-- @xpos integer
-- @ypos integer
-- @topmost boolean
function Reaper:track_ctl__set_tool_tip(fmt, xpos, ypos, topmost)
    return r.TrackCtl_SetToolTip(fmt, xpos, ypos, topmost)
end

-- call to start a new block
function Reaper:undo__begin_block()
    return r.Undo_BeginBlock()
end

-- call to end the block,with extra flags if any,and a description
-- @descchange string
-- @extraflags integer
function Reaper:undo__end_block(descchange, extraflags)
    return r.Undo_EndBlock(descchange, extraflags)
end

-- limited state change to items
-- @descchange string
function Reaper:undo__on_state_change(descchange)
    return r.Undo_OnStateChange(descchange)
end

-- trackparm=-1 by default,or if updating one fx chain,you can specify track index
-- @descchange string
-- @which_states integer
-- @trackparm integer
function Reaper:undo__on_state_change_ex(descchange, which_states, trackparm)
    return r.Undo_OnStateChangeEx(descchange, which_states, trackparm)
end

-- Redraw the arrange view
function Reaper:update_arrange()
    return r.UpdateArrange()
end

-- Redraw the arrange view and ruler
function Reaper:update_timeline()
    return r.UpdateTimeline()
end

-- see ValidatePtr2
-- @pointer identifier
-- @ctypename string
-- @return boolean 
function Reaper:validate_ptr(pointer, ctypename)
    return r.ValidatePtr(pointer, ctypename)
end

-- Opens the prefs to a page, use pageByName if page is 0.
-- @page integer
-- @page_by_name string
function Reaper:view_prefs(page, page_by_name)
    return r.ViewPrefs(page, page_by_name)
end

