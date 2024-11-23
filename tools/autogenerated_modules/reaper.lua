-- @description Provide implementation for Reaper functions.
-- @author NomadMonad
-- @license MIT

local r = reaper
local helpers = require('helpers')


local Reaper = {}



--- Create new Reaper instance.
-- @return Reaper table.
function Reaper:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- @section ReaWrap Custom Methods

--- Log messages with the Reaper logger.
-- @param ... (varargs) Messages to log.
function Reaper:log(...)
    local logger = helpers.log_func('Reaper')
    logger(...)
    return nil
end


-- @section ReaScript API Methods



    
--- Add Remove Rea Script.
-- Add a ReaScript (return the new command ID, or 0 if failed) or remove a
-- ReaScript (return >0 on success). Use commit==true when adding/removing a single
-- script. When bulk adding/removing n scripts, you can optimize the n-1 first
-- calls with commit==false and commit==true for the last call.
-- @param add boolean
-- @param section_id number
-- @param scriptfn string
-- @param commit boolean
-- @return number
function Reaper:add_remove_rea_script(add, section_id, scriptfn, commit)
    return r.AddRemoveReaScript(add, section_id, scriptfn, commit)
end

    
--- Adjust Zoom.
-- forceset=0,doupd=true,centermode=-1 for default
-- @param amt number
-- @param forceset number
-- @param doupd boolean
-- @param centermode number
function Reaper:adjust_zoom(amt, forceset, doupd, centermode)
    return r.adjustZoom(amt, forceset, doupd, centermode)
end

    
--- Api Exists.
-- Returns true if function_name exists in the REAPER API
-- @param function_name string
-- @return boolean
function Reaper:api_exists(function_name)
    return r.APIExists(function_name)
end

    
--- Api Test.
-- Displays a message window if the API was successfully called.
function Reaper:api_test()
    return r.APITest()
end

    
--- Arm Command.
-- arms a command (or disarms if 0 passed) in section sectionname (empty string for
-- main)
-- @param cmd number
-- @param section_name string
function Reaper:arm_command(cmd, section_name)
    return r.ArmCommand(cmd, section_name)
end

    
--- Audio Init.
-- open all audio and MIDI devices, if not open
function Reaper:audio_init()
    return r.Audio_Init()
end

    
--- Audio Is Pre Buffer.
-- is in pre-buffer? threadsafe
-- @return number
function Reaper:audio_is_pre_buffer()
    return r.Audio_IsPreBuffer()
end

    
--- Audio Is Running.
-- is audio running at all? threadsafe
-- @return number
function Reaper:audio_is_running()
    return r.Audio_IsRunning()
end

    
--- Audio Quit.
-- close all audio and MIDI devices, if open
function Reaper:audio_quit()
    return r.Audio_Quit()
end

    
--- Bypass Fx All Tracks.
-- -1 = bypass all if not all bypassed,otherwise unbypass all
-- @param bypass number
function Reaper:bypass_fx_all_tracks(bypass)
    return r.BypassFxAllTracks(bypass)
end

    
--- Clear All Rec Armed.
function Reaper:clear_all_rec_armed()
    return r.ClearAllRecArmed()
end

    
--- Clear Console.
-- Clear the ReaScript console. See ShowConsoleMsg
function Reaper:clear_console()
    return r.ClearConsole()
end

    
--- Clear Peak Cache.
-- resets the global peak caches
function Reaper:clear_peak_cache()
    return r.ClearPeakCache()
end

    
--- Color From Native.
-- Extract RGB values from an OS dependent color. See ColorToNative.
-- @param col number
-- @return r number
-- @return g number
-- @return b number
function Reaper:color_from_native(col)
    return r.ColorFromNative(col)
end

    
--- Color To Native.
-- Make an OS dependent color from RGB values (e.g. RGB() macro on Windows). r,g
-- and b are in [0..255]. See ColorFromNative.
-- @param r number
-- @param g number
-- @param b number
-- @return number
function Reaper:color_to_native(r, g, b)
    return r.ColorToNative(r, g, b)
end

    
--- Count Action Shortcuts.
-- Returns the number of shortcuts that exist for the given command ID. see
-- GetActionShortcutDesc, DeleteActionShortcut, DoActionShortcutDialog.
-- @param section KbdSectionInfo
-- @param cmd_id number
-- @return number
function Reaper:count_action_shortcuts(section, cmd_id)
    return r.CountActionShortcuts(section, cmd_id)
end

    
--- Db2 Slider.
-- @param x number
-- @return number
function Reaper:db2_slider(x)
    return r.DB2SLIDER(x)
end

    
--- Delete Action Shortcut.
-- Delete the specific shortcut for the given command ID. See CountActionShortcuts,
-- GetActionShortcutDesc, DoActionShortcutDialog.
-- @param section KbdSectionInfo
-- @param cmd_id number
-- @param shortcut_idx number
-- @return boolean
function Reaper:delete_action_shortcut(section, cmd_id, shortcut_idx)
    return r.DeleteActionShortcut(section, cmd_id, shortcut_idx)
end

    
--- Delete Ext State.
-- Delete the extended state value for a specific section and key. persist=true
-- means the value should remain deleted the next time REAPER is opened. See
-- SetExtState, GetExtState, HasExtState.
-- @param section string
-- @param key string
-- @param persist boolean
function Reaper:delete_ext_state(section, key, persist)
    return r.DeleteExtState(section, key, persist)
end

    
--- Do Action Shortcut Dialog.
-- Open the action shortcut dialog to edit or add a shortcut for the given command
-- ID. If (shortcutidx >= 0 && shortcutidx < CountActionShortcuts()), that specific
-- shortcut will be replaced, otherwise a new shortcut will be added. See
-- CountActionShortcuts, GetActionShortcutDesc, DeleteActionShortcut.
-- @param hwnd HWND
-- @param section KbdSectionInfo
-- @param cmd_id number
-- @param shortcut_idx number
-- @return boolean
function Reaper:do_action_shortcut_dialog(hwnd, section, cmd_id, shortcut_idx)
    return r.DoActionShortcutDialog(hwnd, section, cmd_id, shortcut_idx)
end

    
--- Update Id.
-- updates preference for docker window ident_str to be in dock whichDock on next
-- open
-- @param ident_str string
-- @param which_dock number
function Reaper:update_id(ident_str, which_dock)
    return r.Dock_UpdateDockID(ident_str, which_dock)
end

    
--- Dock Get Position.
-- -1=not found, 0=bottom, 1=left, 2=top, 3=right, 4=floating
-- @param which_dock number
-- @return number
function Reaper:dock_get_position(which_dock)
    return r.DockGetPosition(which_dock)
end

    
--- Dock Is Child Of Dock.
-- returns dock index that contains hwnd, or -1
-- @param hwnd HWND
-- @return is_floating_docker boolean
function Reaper:dock_is_child_of_dock(hwnd)
    local ret_val, is_floating_docker = r.DockIsChildOfDock(hwnd)
    if ret_val then
        return is_floating_docker
    else
        return nil
    end
end

    
--- Dock Window Activate.
-- @param hwnd HWND
function Reaper:dock_window_activate(hwnd)
    return r.DockWindowActivate(hwnd)
end

    
--- Dock Window Add.
-- @param hwnd HWND
-- @param name string
-- @param pos number
-- @param allow_show boolean
function Reaper:dock_window_add(hwnd, name, pos, allow_show)
    return r.DockWindowAdd(hwnd, name, pos, allow_show)
end

    
--- Dock Window Add Ex.
-- @param hwnd HWND
-- @param name string
-- @param identstr string
-- @param allow_show boolean
function Reaper:dock_window_add_ex(hwnd, name, identstr, allow_show)
    return r.DockWindowAddEx(hwnd, name, identstr, allow_show)
end

    
--- Dock Window Refresh.
function Reaper:dock_window_refresh()
    return r.DockWindowRefresh()
end

    
--- Dock Window Refresh For Hwnd.
-- @param hwnd HWND
function Reaper:dock_window_refresh_for_hwnd(hwnd)
    return r.DockWindowRefreshForHWND(hwnd)
end

    
--- Dock Window Remove.
-- @param hwnd HWND
function Reaper:dock_window_remove(hwnd)
    return r.DockWindowRemove(hwnd)
end

    
--- Ensure Not Completely Offscreen.
-- call with a saved window rect for your window and it'll correct any positioning
-- info.
-- @param arg_0 integerr.left
-- @param arg_1 integerr.top
-- @param arg_2 integerr.right
-- @param arg_3 integerr.bot
-- @return integerr.left
-- @return integerr.top
-- @return integerr.right
-- @return integerr.bot
function Reaper:ensure_not_completely_offscreen(arg_0, arg_1, arg_2, arg_3)
    return r.EnsureNotCompletelyOffscreen(arg_0, arg_1, arg_2, arg_3)
end

    
--- Enumerate Files.
-- List the files in the "path" directory. Returns NULL/nil when all files have
-- been listed. Use fileindex = -1 to force re-read of directory (invalidate
-- cache). See EnumerateSubdirectories
-- @param path string
-- @param fileindex number
-- @return string
function Reaper:enumerate_files(path, fileindex)
    return r.EnumerateFiles(path, fileindex)
end

    
--- Enumerate Subdirectories.
-- List the subdirectories in the "path" directory. Use subdirindex = -1 to force
-- re-read of directory (invalidate cache). Returns NULL/nil when all
-- subdirectories have been listed. See EnumerateFiles
-- @param path string
-- @param subdirindex number
-- @return string
function Reaper:enumerate_subdirectories(path, subdirindex)
    return r.EnumerateSubdirectories(path, subdirindex)
end

    
--- Enum Installed Fx.
-- Enumerates installed FX. Returns true if successful, sets nameOut and identOut
-- to name and ident of FX at index.
-- @param index number
-- @return name string
-- @return ident string
function Reaper:enum_installed_fx(index)
    local ret_val, name, ident = r.EnumInstalledFX(index)
    if ret_val then
        return name, ident
    else
        return nil
    end
end

    
--- Enum Pitch Shift Modes.
-- Start querying modes at 0, returns FALSE when no more modes possible, sets
-- strOut to NULL if a mode is currently unsupported
-- @param mode number
-- @return str string
function Reaper:enum_pitch_shift_modes(mode)
    local ret_val, str = r.EnumPitchShiftModes(mode)
    if ret_val then
        return str
    else
        return nil
    end
end

    
--- Enum Pitch Shift Sub Modes.
-- Returns submode name, or NULL
-- @param mode number
-- @param submode number
-- @return string
function Reaper:enum_pitch_shift_sub_modes(mode, submode)
    return r.EnumPitchShiftSubModes(mode, submode)
end

    
--- Enum Project Markers.
-- @param idx number
-- @return is_rgn boolean
-- @return pos number
-- @return rgnend number
-- @return name string
-- @return markrgnindexnumber number
function Reaper:enum_project_markers(idx)
    local ret_val, is_rgn, pos, rgnend, name, markrgnindexnumber = r.EnumProjectMarkers(idx)
    if ret_val then
        return is_rgn, pos, rgnend, name, markrgnindexnumber
    else
        return nil
    end
end

    
--- Enum Projects.
-- idx=-1 for current project,projfn can be NULL if not interested in filename. use
-- idx 0x40000000 for currently rendering project, if any.
-- @param idx number
-- @return string projfn
function Reaper:enum_projects(idx)
    local ret_val, string = r.EnumProjects(idx)
    if ret_val then
        return string
    else
        return nil
    end
end

    
--- Enum Track Midi Program Names.
-- returns false if there are no plugins on the track that support MIDI programs,or
-- if all programs have been enumerated
-- @param track number
-- @param program_number number
-- @param program_name string
-- @return program_name string
function Reaper:enum_track_midi_program_names(track, program_number, program_name)
    local ret_val, program_name = r.EnumTrackMIDIProgramNames(track, program_number, program_name)
    if ret_val then
        return program_name
    else
        return nil
    end
end

    
--- Exec Process.
-- Executes command line, returns NULL on total failure, otherwise the return
-- value, a newline, and then the output of the command. If timeoutmsec is 0,
-- command will be allowed to run indefinitely (recommended for large amounts of
-- returned output). timeoutmsec is -1 for no wait/terminate, -2 for no wait and
-- minimize
-- @param cmdline string
-- @param timeoutmsec number
-- @return string
function Reaper:exec_process(cmdline, timeoutmsec)
    return r.ExecProcess(cmdline, timeoutmsec)
end

    
--- File Exists.
-- returns true if path points to a valid, readable file
-- @param path string
-- @return boolean
function Reaper:file_exists(path)
    return r.file_exists(path)
end

    
--- Format Timestr.
-- Format tpos (which is time in seconds) as hh:mm:ss.sss. See format_timestr_pos,
-- format_timestr_len.
-- @param tpos number
-- @param buf string
-- @return buf string
function Reaper:format_timestr(tpos, buf)
    return r.format_timestr(tpos, buf)
end

    
--- Format Timestr Len.
-- time formatting mode overrides: -1=proj default. 0=time 1=measures.beats + time
-- 2=measures.beats 3=seconds 4=samples 5=h:m:s:f offset is start of where the
-- length will be calculated from
-- @param tpos number
-- @param buf string
-- @param offset number
-- @param modeoverride number
-- @return buf string
function Reaper:format_timestr_len(tpos, buf, offset, modeoverride)
    return r.format_timestr_len(tpos, buf, offset, modeoverride)
end

    
--- Format Timestr Pos.
-- time formatting mode overrides: -1=proj default. 0=time 1=measures.beats + time
-- 2=measures.beats 3=seconds 4=samples 5=h:m:s:f
-- @param tpos number
-- @param buf string
-- @param modeoverride number
-- @return buf string
function Reaper:format_timestr_pos(tpos, buf, modeoverride)
    return r.format_timestr_pos(tpos, buf, modeoverride)
end

    
--- Gen Guid.
-- @param g_guid string
-- @return g_guid string
function Reaper:gen_guid(g_guid)
    return r.genGuid(g_guid)
end

    
--- Get Config Var String.
-- gets ini configuration variable value as string
-- @param name string
-- @return buf string
function Reaper:get_config_var_string(name)
    local ret_val, buf = r.get_config_var_string(name)
    if ret_val then
        return buf
    else
        return nil
    end
end

    
--- Get Ini File.
-- Get reaper.ini full filename.
-- @return string
function Reaper:get_ini_file()
    return r.get_ini_file()
end

    
--- Get Action Shortcut Desc.
-- Get the text description of a specific shortcut for the given command ID. See
-- CountActionShortcuts,DeleteActionShortcut,DoActionShortcutDialog.
-- @param section KbdSectionInfo
-- @param cmd_id number
-- @param shortcut_idx number
-- @return desc string
function Reaper:get_action_shortcut_desc(section, cmd_id, shortcut_idx)
    local ret_val, desc = r.GetActionShortcutDesc(section, cmd_id, shortcut_idx)
    if ret_val then
        return desc
    else
        return nil
    end
end

    
--- Get App Version.
-- Returns app version which may include an OS/arch signifier, such as: "6.17"
-- (windows 32-bit), "6.17/x64" (windows 64-bit), "6.17/OSX64" (macOS 64-bit
-- Intel), "6.17/OSX" (macOS 32-bit), "6.17/macOS-arm64", "6.17/linux-x86_64",
-- "6.17/linux-i686", "6.17/linux-aarch64", "6.17/linux-armv7l", etc
-- @return string
function Reaper:get_app_version()
    return r.GetAppVersion()
end

    
--- Get Armed Command.
-- gets the currently armed command and section name (returns 0 if nothing armed).
-- section name is empty-string for main section.
-- @return sec string
function Reaper:get_armed_command()
    local ret_val, sec = r.GetArmedCommand()
    if ret_val then
        return sec
    else
        return nil
    end
end

    
--- Get Audio Device Info.
-- get information about the currently open audio device. attribute can be MODE,
-- IDENT_IN, IDENT_OUT, BSIZE, SRATE, BPS. returns false if unknown attribute or
-- device not open.
-- @param attribute string
-- @return desc string
function Reaper:get_audio_device_info(attribute)
    local ret_val, desc = r.GetAudioDeviceInfo(attribute)
    if ret_val then
        return desc
    else
        return nil
    end
end

    
--- Get Config Wants Dock.
-- gets the dock ID desired by ident_str, if any
-- @param ident_str string
-- @return number
function Reaper:get_config_wants_dock(ident_str)
    return r.GetConfigWantsDock(ident_str)
end

    
--- Get Current Project In Load Save.
-- returns current project if in load/save (usually only used from
-- project_config_extension_t)
-- @return Project table
function Reaper:get_current_project_in_load_save()
    local Project = require('project')
    local result = r.GetCurrentProjectInLoadSave()
    return Project:new(result)
end

    
--- Get Cursor Context.
-- return the current cursor context: 0 if track panels, 1 if items, 2 if
-- envelopes, otherwise unknown
-- @return number
function Reaper:get_cursor_context()
    return r.GetCursorContext()
end

    
--- Get Cursor Context2.
-- 0 if track panels, 1 if items, 2 if envelopes, otherwise unknown (unlikely when
-- want_last_valid is true)
-- @param want_last_valid boolean
-- @return number
function Reaper:get_cursor_context2(want_last_valid)
    return r.GetCursorContext2(want_last_valid)
end

    
--- Get Cursor Position.
-- edit cursor position
-- @return number
function Reaper:get_cursor_position()
    return r.GetCursorPosition()
end

    
--- Get Exe Path.
-- returns path of REAPER.exe (not including EXE), i.e. C:\Program Files\REAPER
-- @return string
function Reaper:get_exe_path()
    return r.GetExePath()
end

    
--- Get Ext State.
-- Get the extended state value for a specific section and key. See SetExtState,
-- DeleteExtState, HasExtState.
-- @param section string
-- @param key string
-- @return string
function Reaper:get_ext_state(section, key)
    return r.GetExtState(section, key)
end

    
--- Get Global Automation Override.
-- return -1=no override, 0=trim/read, 1=read, 2=touch, 3=write, 4=latch, 5=bypass
-- @return number
function Reaper:get_global_automation_override()
    return r.GetGlobalAutomationOverride()
end

    
--- Get H Zoom Level.
-- returns pixels/second
-- @return number
function Reaper:get_h_zoom_level()
    return r.GetHZoomLevel()
end

    
--- Get Input Activity Level.
-- returns approximate input level if available, 0-511 mono inputs, |1024 for
-- stereo pairs, 4096+devidx*32 for MIDI devices
-- @param input_id number
-- @return number
function Reaper:get_input_activity_level(input_id)
    return r.GetInputActivityLevel(input_id)
end

    
--- Get Input Channel Name.
-- @param channel_index number
-- @return string
function Reaper:get_input_channel_name(channel_index)
    return r.GetInputChannelName(channel_index)
end

    
--- Get Input Output Latency.
-- Gets the audio device input/output latency in samples
-- @return inputlatency number
-- @return output_latency number
function Reaper:get_input_output_latency()
    return r.GetInputOutputLatency()
end

    
--- Get Item Editing Time2.
-- returns time of relevant edit, set which_item to the pcm_source (if applicable),
-- flags (if specified) will be set to 1 for edge resizing, 2 for fade change, 4
-- for item move, 8 for item slip edit (edit cursor time or start of item)
-- @return number
-- @return which_item userdata
-- @return flags number
function Reaper:get_item_editing_time2()
    local PCM_source = require('pcm_source')
    local result = r.GetItemEditingTime2()
    return PCM_source:new(result)
end

    
--- Get Item From Point.
-- Returns the first item at the screen coordinates specified. If allow_locked is
-- false, locked items are ignored. If takeOutOptional specified, returns the take
-- hit. See GetThingFromPoint.
-- @param screen_x number
-- @param screen_y number
-- @param allow_locked boolean
-- @return Item table
-- @return take Take table
function Reaper:get_item_from_point(screen_x, screen_y, allow_locked)
    local Take = require('take')
    local result = r.GetItemFromPoint(screen_x, screen_y, allow_locked)
    return Take:new(result)
end

    
--- Get Last Color Theme File.
-- @return string
function Reaper:get_last_color_theme_file()
    return r.GetLastColorThemeFile()
end

    
--- Get Last Touched Track.
-- @return Track table
function Reaper:get_last_touched_track()
    local Track = require('track')
    local result = r.GetLastTouchedTrack()
    return Track:new(result)
end

    
--- Get Main Hwnd.
-- @return HWND
function Reaper:get_main_hwnd()
    return r.GetMainHwnd()
end

    
--- Get Master Track Visibility.
-- returns &1 if the master track is visible in the TCP, &2 if NOT visible in the
-- mixer. See SetMasterTrackVisibility.
-- @return number
function Reaper:get_master_track_visibility()
    return r.GetMasterTrackVisibility()
end

    
--- Get Max Midi Inputs.
-- returns max dev for midi inputs/outputs
-- @return number
function Reaper:get_max_midi_inputs()
    return r.GetMaxMidiInputs()
end

    
--- Get Max Midi Outputs.
-- @return number
function Reaper:get_max_midi_outputs()
    return r.GetMaxMidiOutputs()
end

    
--- Get Midi Input Name.
-- returns true if device present
-- @param dev number
-- @param nameout string
-- @return nameout string
function Reaper:get_midi_input_name(dev, nameout)
    local ret_val, nameout = r.GetMIDIInputName(dev, nameout)
    if ret_val then
        return nameout
    else
        return nil
    end
end

    
--- Get Midi Output Name.
-- returns true if device present
-- @param dev number
-- @param nameout string
-- @return nameout string
function Reaper:get_midi_output_name(dev, nameout)
    local ret_val, nameout = r.GetMIDIOutputName(dev, nameout)
    if ret_val then
        return nameout
    else
        return nil
    end
end

    
--- Get Mixer Scroll.
-- Get the leftmost track visible in the mixer
-- @return Track table
function Reaper:get_mixer_scroll()
    local Track = require('track')
    local result = r.GetMixerScroll()
    return Track:new(result)
end

    
--- Get Mouse Modifier.
-- Get the current mouse modifier assignment for a specific modifier key
-- assignment, in a specific context. action will be filled in with the command ID
-- number for a built-in mouse modifier or built-in REAPER command ID, or the
-- custom action ID string. Note: the action string may have a space and 'c' or 'm'
-- appended to it to specify command ID vs mouse modifier ID. See SetMouseModifier
-- for more information.
-- @param context string
-- @param modifier_flag number
-- @return action string
function Reaper:get_mouse_modifier(context, modifier_flag)
    return r.GetMouseModifier(context, modifier_flag)
end

    
--- Get Mouse Position.
-- get mouse position in screen coordinates
-- @return x number
-- @return y number
function Reaper:get_mouse_position()
    return r.GetMousePosition()
end

    
--- Get Num Audio Inputs.
-- Return number of normal audio hardware inputs available
-- @return number
function Reaper:get_num_audio_inputs()
    return r.GetNumAudioInputs()
end

    
--- Get Num Audio Outputs.
-- Return number of normal audio hardware outputs available
-- @return number
function Reaper:get_num_audio_outputs()
    return r.GetNumAudioOutputs()
end

    
--- Get Num Midi Inputs.
-- returns max number of real midi hardware inputs
-- @return number
function Reaper:get_num_midi_inputs()
    return r.GetNumMIDIInputs()
end

    
--- Get Num Midi Outputs.
-- returns max number of real midi hardware outputs
-- @return number
function Reaper:get_num_midi_outputs()
    return r.GetNumMIDIOutputs()
end

    
--- Get Num Tracks.
-- Returns number of tracks in current project, see CountTracks()
-- @return number
function Reaper:get_num_tracks()
    return r.GetNumTracks()
end

    
--- Get Os.
-- Returns "Win32", "Win64", "OSX32", "OSX64", "macOS-arm64", or "Other".
-- @return string
function Reaper:get_os()
    return r.GetOS()
end

    
--- Get Output Channel Name.
-- @param channel_index number
-- @return string
function Reaper:get_output_channel_name(channel_index)
    return r.GetOutputChannelName(channel_index)
end

    
--- Get Output Latency.
-- returns output latency in seconds
-- @return number
function Reaper:get_output_latency()
    return r.GetOutputLatency()
end

    
--- Get Peak File Name.
-- get the peak file name for a given file (can be either filename.reapeaks,or a
-- hashed filename in another path)
-- @param fn string
-- @return buf string
function Reaper:get_peak_file_name(fn)
    return r.GetPeakFileName(fn)
end

    
--- Get Peak File Name Ex.
-- get the peak file name for a given file (can be either filename.reapeaks,or a
-- hashed filename in another path)
-- @param fn string
-- @param buf string
-- @param for_write boolean
-- @return buf string
function Reaper:get_peak_file_name_ex(fn, buf, for_write)
    return r.GetPeakFileNameEx(fn, buf, for_write)
end

    
--- Get Peak File Name Ex2.
-- Like GetPeakFileNameEx, but you can specify peaksfileextension such as
-- ".reapeaks"
-- @param fn string
-- @param buf string
-- @param for_write boolean
-- @param peaksfileextension string
-- @return buf string
function Reaper:get_peak_file_name_ex2(fn, buf, for_write, peaksfileextension)
    return r.GetPeakFileNameEx2(fn, buf, for_write, peaksfileextension)
end

    
--- Get Play Position.
-- returns latency-compensated actual-what-you-hear position
-- @return number
function Reaper:get_play_position()
    return r.GetPlayPosition()
end

    
--- Get Play Position2.
-- returns position of next audio block being processed
-- @return number
function Reaper:get_play_position2()
    return r.GetPlayPosition2()
end

    
--- Get Play State.
-- &1=playing, &2=paused, &4=is recording
-- @return number
function Reaper:get_play_state()
    return r.GetPlayState()
end

    
--- Get Project Path.
-- Get the project recording path.
-- @return buf string
function Reaper:get_project_path()
    return r.GetProjectPath()
end

    
--- Get Resource Path.
-- returns path where ini files are stored, other things are in subdirectories.
-- @return string
function Reaper:get_resource_path()
    return r.GetResourcePath()
end

    
--- Get Set Loop Time Range.
-- @param is_set boolean
-- @param is_loop boolean
-- @param start number
-- @param end_ number
-- @param allowautoseek boolean
-- @return start number
-- @return end_ number
function Reaper:get_set_loop_time_range(is_set, is_loop, start, end_, allowautoseek)
    return r.GetSet_LoopTimeRange(is_set, is_loop, start, end_, allowautoseek)
end

    
--- Get Set Repeat.
-- -1 == query,0=clear,1=set,>1=toggle . returns new value
-- @param val number
-- @return number
function Reaper:get_set_repeat(val)
    return r.GetSetRepeat(val)
end

    
--- Get Theme Color.
-- Returns the theme color specified, or -1 on failure. If the low bit of flags is
-- set, the color as originally specified by the theme (before any transformations)
-- is returned, otherwise the current (possibly transformed and modified) color is
-- returned. See SetThemeColor for a list of valid ini_key.
-- @param ini_key string
-- @param flags number
-- @return number
function Reaper:get_theme_color(ini_key, flags)
    return r.GetThemeColor(ini_key, flags)
end

    
--- Get Thing From Point.
-- Hit tests a point in screen coordinates. Updates infoOut with information such
-- as "arrange", "fx_chain", "fx_0" (first FX in chain, floating), "spacer_0"
-- (spacer before first track). If a track panel is hit, string will begin with
-- "tcp" or "mcp" or "tcp.mute" etc (future versions may append additional
-- information). May return NULL with valid info string to indicate non-track
-- thing.
-- @param screen_x number
-- @param screen_y number
-- @return info string
function Reaper:get_thing_from_point(screen_x, screen_y)
    local ret_val, info = r.GetThingFromPoint(screen_x, screen_y)
    if ret_val then
        return info
    else
        return nil
    end
end

    
--- Get Toggle Command State.
-- See GetToggleCommandStateEx.
-- @param command_id number
-- @return number
function Reaper:get_toggle_command_state(command_id)
    return r.GetToggleCommandState(command_id)
end

    
--- Get Toggle Command State Ex.
-- For the main action context, the MIDI editor, or the media explorer, returns the
-- toggle state of the action. 0=off, 1=on, -1=NA because the action does not have
-- on/off states. For the MIDI editor, the action state for the most recently
-- focused window will be returned.
-- @param section_id number
-- @param command_id number
-- @return number
function Reaper:get_toggle_command_state_ex(section_id, command_id)
    return r.GetToggleCommandStateEx(section_id, command_id)
end

    
--- Get Tooltip Window.
-- gets a tooltip window,in case you want to ask it for font information. Can
-- return NULL.
-- @return HWND
function Reaper:get_tooltip_window()
    return r.GetTooltipWindow()
end

    
--- Get Touched Or Focused Fx.
-- mode can be 0 to query last touched parameter, or 1 to query currently focused
-- FX. Returns false if failed. If successful, trackIdxOut will be track index (-1
-- is master track, 0 is first track). itemidxOut will be 0-based item index if an
-- item, or -1 if not an item. takeidxOut will be 0-based take index. fxidxOut will
-- be FX index, potentially with 0x2000000 set to signify container-addressing, or
-- with 0x1000000 set to signify record-input FX. parmOut will be set to the
-- parameter index if querying last-touched. parmOut will have 1 set if querying
-- focused state and FX is no longer focused but still open.
-- @param mode number
-- @return track_idx number
-- @return item_idx number
-- @return take_idx number
-- @return fx_idx number
-- @return parm number
function Reaper:get_touched_or_focused_fx(mode)
    local ret_val, track_idx, item_idx, take_idx, fx_idx, parm = r.GetTouchedOrFocusedFX(mode)
    if ret_val then
        return track_idx, item_idx, take_idx, fx_idx, parm
    else
        return nil
    end
end

    
--- Get Track From Point.
-- Returns the track from the screen coordinates specified. If the screen
-- coordinates refer to a window associated to the track (such as FX), the track
-- will be returned. infoOutOptional will be set to 1 if it is likely an envelope,
-- 2 if it is likely a track FX. For a free item positioning or fixed lane track,
-- the second byte of infoOutOptional will be set to the (approximate, for fipm
-- tracks) item lane underneath the mouse. See GetThingFromPoint.
-- @param screen_x number
-- @param screen_y number
-- @return integer info
function Reaper:get_track_from_point(screen_x, screen_y)
    local ret_val, integer = r.GetTrackFromPoint(screen_x, screen_y)
    if ret_val then
        return integer
    else
        return nil
    end
end

    
--- Get Track Midi Note Name.
-- see GetTrackMIDINoteNameEx
-- @param track number
-- @param pitch number
-- @param chan number
-- @return string
function Reaper:get_track_midi_note_name(track, pitch, chan)
    return r.GetTrackMIDINoteName(track, pitch, chan)
end

    
--- Get Underrun Time.
-- retrieves the last timestamps of audio xrun (yellow-flash, if available), media
-- xrun (red-flash), and the current time stamp (all milliseconds)
-- @return audio_xrun number
-- @return media_xrun number
-- @return curtime number
function Reaper:get_underrun_time()
    return r.GetUnderrunTime()
end

    
--- Get User File Name For Read.
-- returns true if the user selected a valid file, false if the user canceled the
-- dialog
-- @param filename_need4096 string
-- @param title string
-- @param defext string
-- @return filename_need4096 string
function Reaper:get_user_file_name_for_read(filename_need4096, title, defext)
    local ret_val, filename_need4096 = r.GetUserFileNameForRead(filename_need4096, title, defext)
    if ret_val then
        return filename_need4096
    else
        return nil
    end
end

    
--- Get User Inputs.
-- Get values from the user. If a caption begins with *, for example "*password",
-- the edit field will not display the input text. Maximum fields is 16. Values are
-- returned as a comma-separated string. Returns false if the user canceled the
-- dialog. You can supply special extra information via additional caption fields:
-- extrawidth=XXX to increase text field width, separator=X to use a different
-- separator for returned fields.
-- @param title string
-- @param num_inputs number
-- @param captions_csv string
-- @param retvals_csv string
-- @return retvals_csv string
function Reaper:get_user_inputs(title, num_inputs, captions_csv, retvals_csv)
    local ret_val, retvals_csv = r.GetUserInputs(title, num_inputs, captions_csv, retvals_csv)
    if ret_val then
        return retvals_csv
    else
        return nil
    end
end

    
--- Guid To String.
-- dest should be at least 64 chars long to be safe
-- @param g_guid string
-- @param dest_need64 string
-- @return dest_need64 string
function Reaper:guid_to_string(g_guid, dest_need64)
    return r.guidToString(g_guid, dest_need64)
end

    
--- Has Ext State.
-- Returns true if there exists an extended state value for a specific section and
-- key. See SetExtState, GetExtState, DeleteExtState.
-- @param section string
-- @param key string
-- @return boolean
function Reaper:has_ext_state(section, key)
    return r.HasExtState(section, key)
end

    
--- Has Track Midi Programs.
-- returns name of track plugin that is supplying MIDI programs,or NULL if there is
-- none
-- @param track number
-- @return string
function Reaper:has_track_midi_programs(track)
    return r.HasTrackMIDIPrograms(track)
end

    
--- Set.
-- @param helpstring string
-- @param is_temporary_help boolean
function Reaper:set(helpstring, is_temporary_help)
    return r.Help_Set(helpstring, is_temporary_help)
end

    
--- Image Resolve Fn.
-- @param in_ string
-- @param out string
-- @return out string
function Reaper:image_resolve_fn(in_, out)
    return r.image_resolve_fn(in_, out)
end

    
--- Insert Media.
-- mode: 0=add to current track, 1=add new track, 3=add to selected items as takes,
-- &4=stretch/loop to fit time sel, &8=try to match tempo 1x, &16=try to match
-- tempo 0.5x, &32=try to match tempo 2x, &64=don't preserve pitch when matching
-- tempo, &128=no loop/section if startpct/endpct set, &256=force loop regardless
-- of global preference for looping imported items, &512=use high word as absolute
-- track index if mode&3==0 or mode&2048, &1024=insert into reasamplomatic on a new
-- track (add 1 to insert on last selected track), &2048=insert into open
-- reasamplomatic instance (add 512 to use high word as absolute track index),
-- &4096=move to source preferred position (BWF start offset), &8192=reverse.
-- &16384=apply ripple according to project setting
-- @param file string
-- @param mode number
-- @return number
function Reaper:insert_media(file, mode)
    return r.InsertMedia(file, mode)
end

    
--- Insert Media Section.
-- See InsertMedia.
-- @param file string
-- @param mode number
-- @param startpct number
-- @param endpct number
-- @param pitchshift number
-- @return number
function Reaper:insert_media_section(file, mode, startpct, endpct, pitchshift)
    return r.InsertMediaSection(file, mode, startpct, endpct, pitchshift)
end

    
--- Insert Track At Index.
-- inserts a track at idx,of course this will be clamped to 0..GetNumTracks().
-- wantDefaults=TRUE for default envelopes/FX,otherwise no enabled fx/env.
-- Superseded, see InsertTrackInProject
-- @param idx number
-- @param want_defaults boolean
function Reaper:insert_track_at_index(idx, want_defaults)
    return r.InsertTrackAtIndex(idx, want_defaults)
end

    
--- Is Media Extension.
-- Tests a file extension (i.e. "wav" or "mid") to see if it's a media extension.
-- If wantOthers is set, then "RPP", "TXT" and other project-type formats will also
-- pass.
-- @param ext string
-- @param want_others boolean
-- @return boolean
function Reaper:is_media_extension(ext, want_others)
    return r.IsMediaExtension(ext, want_others)
end

    
--- Kbd Enumerate Actions.
-- @param section KbdSectionInfo
-- @param idx number
-- @return name string
function Reaper:kbd_enumerate_actions(section, idx)
    local ret_val, name = r.kbd_enumerateActions(section, idx)
    if ret_val then
        return name
    else
        return nil
    end
end

    
--- Kbd Get Text From Cmd.
-- @param cmd number
-- @param section KbdSectionInfo
-- @return string
function Reaper:kbd_get_text_from_cmd(cmd, section)
    return r.kbd_getTextFromCmd(cmd, section)
end

    
--- Localize String.
-- Returns a localized version of src_string, in section section. flags can have 1
-- set to only localize if sprintf-style formatting matches the original.
-- @param src_string string
-- @param section string
-- @param flags number
-- @return string
function Reaper:localize_string(src_string, section, flags)
    return r.LocalizeString(src_string, section, flags)
end

    
--- On Command.
-- See Main_OnCommandEx.
-- @param command number
-- @param flag number
function Reaper:on_command(command, flag)
    return r.Main_OnCommand(command, flag)
end

    
--- On Command Ex.
-- Performs an action belonging to the main action section. To perform non-native
-- actions (ReaScripts, custom or extension plugins' actions) safely, see
-- NamedCommandLookup().
-- @param command number
-- @param flag number
function Reaper:on_command_ex(command, flag)
    return r.Main_OnCommandEx(command, flag, proj)
end

    
--- Open Project.
-- opens a project. will prompt the user to save unless name is prefixed with
-- 'noprompt:'. If name is prefixed with 'template:', project file will be loaded
-- as a template. If passed a .RTrackTemplate file, adds the template to the
-- existing project.
-- @param name string
function Reaper:open_project(name)
    return r.Main_openProject(name)
end

    
--- Update Loop Info.
-- @param ignoremask number
function Reaper:update_loop_info(ignoremask)
    return r.Main_UpdateLoopInfo(ignoremask)
end

    
--- Get Play Rate At Time.
-- @param time_s number
-- @return number
function Reaper:get_play_rate_at_time(time_s)
    return r.Master_GetPlayRateAtTime(time_s, proj)
end

    
--- Get Tempo.
-- @return number
function Reaper:get_tempo()
    return r.Master_GetTempo()
end

    
--- Normalize Play Rate.
-- Convert play rate to/from a value between 0 and 1, representing the position on
-- the project playrate slider.
-- @param playrate number
-- @param is_normalized boolean
-- @return number
function Reaper:normalize_play_rate(playrate, is_normalized)
    return r.Master_NormalizePlayRate(playrate, is_normalized)
end

    
--- Normalize Tempo.
-- Convert the tempo to/from a value between 0 and 1, representing bpm in the range
-- of 40-296 bpm.
-- @param bpm number
-- @param is_normalized boolean
-- @return number
function Reaper:normalize_tempo(bpm, is_normalized)
    return r.Master_NormalizeTempo(bpm, is_normalized)
end

    
--- Mb.
-- type 0=OK,1=OKCANCEL,2=ABORTRETRYIGNORE,3=YESNOCANCEL,4=YESNO,5=RETRYCANCEL :
-- ret 1=OK,2=CANCEL,3=ABORT,4=RETRY,5=IGNORE,6=YES,7=NO
-- @param msg string
-- @param title string
-- @param type number
-- @return number
function Reaper:mb(msg, title, type)
    return r.MB(msg, title, type)
end

    
--- Menu Get Hash.
-- Get a string that only changes when menu/toolbar entries are added or removed
-- (not re-ordered). Can be used to determine if a customized menu/toolbar differs
-- from the default, or if the default changed after a menu/toolbar was customized.
-- flag==0: current default menu/toolbar; flag==1: current customized menu/toolbar;
-- flag==2: default menu/toolbar at the time the current menu/toolbar was most
-- recently customized, if it was customized in REAPER v7.08 or later.
-- @param menu_name string
-- @param flag number
-- @return hash string
function Reaper:menu_get_hash(menu_name, flag)
    local ret_val, hash = r.Menu_GetHash(menu_name, flag)
    if ret_val then
        return hash
    else
        return nil
    end
end

    
--- Mkpanstr.
-- @param str_need64 string
-- @param pan number
-- @return str_need64 string
function Reaper:mkpanstr(str_need64, pan)
    return r.mkpanstr(str_need64, pan)
end

    
--- Mkvolpanstr.
-- @param str_need64 string
-- @param vol number
-- @param pan number
-- @return str_need64 string
function Reaper:mkvolpanstr(str_need64, vol, pan)
    return r.mkvolpanstr(str_need64, vol, pan)
end

    
--- Mkvolstr.
-- @param str_need64 string
-- @param vol number
-- @return str_need64 string
function Reaper:mkvolstr(str_need64, vol)
    return r.mkvolstr(str_need64, vol)
end

    
--- Move Edit Cursor.
-- @param adjamt number
-- @param dosel boolean
function Reaper:move_edit_cursor(adjamt, dosel)
    return r.MoveEditCursor(adjamt, dosel)
end

    
--- Mute All Tracks.
-- @param mute boolean
function Reaper:mute_all_tracks(mute)
    return r.MuteAllTracks(mute)
end

    
--- My Get Viewport.
-- @param arg_0 integerr.left
-- @param arg_1 integerr.top
-- @param arg_2 integerr.right
-- @param arg_3 integerr.bot
-- @param srleft number
-- @param srtop number
-- @param srright number
-- @param srbot number
-- @param want_work_area boolean
function Reaper:my_get_viewport(arg_0, arg_1, arg_2, arg_3, srleft, srtop, srright, srbot, want_work_area)
    return r.my_getViewport(arg_0, arg_1, arg_2, arg_3, srleft, srtop, srright, srbot, want_work_area)
end

    
--- Named Command Lookup.
-- Get the command ID number for named command that was registered by an extension
-- such as "_SWS_ABOUT" or "_113088d11ae641c193a2b7ede3041ad5" for a ReaScript or a
-- custom action.
-- @param command_name string
-- @return number
function Reaper:named_command_lookup(command_name)
    return r.NamedCommandLookup(command_name)
end

    
--- On Pause Button.
-- direct way to simulate pause button hit
function Reaper:on_pause_button()
    return r.OnPauseButton()
end

    
--- On Play Button.
-- direct way to simulate play button hit
function Reaper:on_play_button()
    return r.OnPlayButton()
end

    
--- On Stop Button.
-- direct way to simulate stop button hit
function Reaper:on_stop_button()
    return r.OnStopButton()
end

    
--- Open Color Theme File.
-- @param fn string
-- @return boolean
function Reaper:open_color_theme_file(fn)
    return r.OpenColorThemeFile(fn)
end

    
--- Open Media Explorer.
-- Opens mediafn in the Media Explorer, play=true will play the file immediately
-- (or toggle playback if mediafn was already open), =false will just select it.
-- @param mediafn string
-- @param play boolean
-- @return HWND
function Reaper:open_media_explorer(mediafn, play)
    return r.OpenMediaExplorer(mediafn, play)
end

    
--- Osc Local Message To Host.
-- Send an OSC message directly to REAPER. The value argument may be NULL. The
-- message will be matched against the default OSC patterns.
-- @param message string
-- @param number valueIn Optional
function Reaper:osc_local_message_to_host(message, number)
    local number = number or nil
    return r.OscLocalMessageToHost(message, number)
end

    
--- Parse Timestr.
-- Parse hh:mm:ss.sss time string, return time in seconds (or 0.0 on error). See
-- parse_timestr_pos, parse_timestr_len.
-- @param buf string
-- @return number
function Reaper:parse_timestr(buf)
    return r.parse_timestr(buf)
end

    
--- Parse Timestr Len.
-- time formatting mode overrides: -1=proj default. 0=time 1=measures.beats + time
-- 2=measures.beats 3=seconds 4=samples 5=h:m:s:f
-- @param buf string
-- @param offset number
-- @param modeoverride number
-- @return number
function Reaper:parse_timestr_len(buf, offset, modeoverride)
    return r.parse_timestr_len(buf, offset, modeoverride)
end

    
--- Parse Timestr Pos.
-- Parse time string, time formatting mode overrides: -1=proj default. 0=time
-- 1=measures.beats + time 2=measures.beats 3=seconds 4=samples 5=h:m:s:f
-- @param buf string
-- @param modeoverride number
-- @return number
function Reaper:parse_timestr_pos(buf, modeoverride)
    return r.parse_timestr_pos(buf, modeoverride)
end

    
--- Parsepanstr.
-- @param str string
-- @return number
function Reaper:parsepanstr(str)
    return r.parsepanstr(str)
end

    
--- Plugin Wants Always Run Fx.
-- @param amt number
function Reaper:plugin_wants_always_run_fx(amt)
    return r.PluginWantsAlwaysRunFx(amt)
end

    
--- Prevent Ui Refresh.
-- adds prevent_count to the UI refresh prevention state; always add then remove
-- the same amount, or major disfunction will occur
-- @param prevent_count number
function Reaper:prevent_ui_refresh(prevent_count)
    return r.PreventUIRefresh(prevent_count)
end

    
--- Prompt For Action.
-- Uses the action list to choose an action. Call with session_mode=1 to create a
-- session (init_id will be the initial action to select, or 0), then poll with
-- session_mode=0, checking return value for user-selected action (will return 0 if
-- no action selected yet, or -1 if the action window is no longer available). When
-- finished, call with session_mode=-1.
-- @param session_mode number
-- @param init_id number
-- @param section_id number
-- @return number
function Reaper:prompt_for_action(session_mode, init_id, section_id)
    return r.PromptForAction(session_mode, init_id, section_id)
end

    
--- Rea Script Error.
-- Causes REAPER to display the error message after the current ReaScript finishes.
-- If called within a Lua context and errmsg has a ! prefix, script execution will
-- be terminated.
-- @param errmsg string
function Reaper:rea_script_error(errmsg)
    return r.ReaScriptError(errmsg)
end

    
--- Recursive Create Directory.
-- returns positive value on success, 0 on failure.
-- @param path string
-- @param ignored number
-- @return number
function Reaper:recursive_create_directory(path, ignored)
    return r.RecursiveCreateDirectory(path, ignored)
end

    
--- Reduce Open Files.
-- garbage-collects extra open files and closes them. if flags has 1 set, this is
-- done incrementally (call this from a regular timer, if desired). if flags has 2
-- set, files are aggressively closed (they may need to be re-opened very soon).
-- returns number of files closed by this call.
-- @param flags number
-- @return number
function Reaper:reduce_open_files(flags)
    return r.reduce_open_files(flags)
end

    
--- Refresh Toolbar.
-- See RefreshToolbar2.
-- @param command_id number
function Reaper:refresh_toolbar(command_id)
    return r.RefreshToolbar(command_id)
end

    
--- Refresh Toolbar2.
-- Refresh the toolbar button states of a toggle action.
-- @param section_id number
-- @param command_id number
function Reaper:refresh_toolbar2(section_id, command_id)
    return r.RefreshToolbar2(section_id, command_id)
end

    
--- Relative Fn.
-- Makes a filename "in" relative to the current project, if any.
-- @param in_ string
-- @param out string
-- @return out string
function Reaper:relative_fn(in_, out)
    return r.relative_fn(in_, out)
end

    
--- Render File Section.
-- Not available while playing back.
-- @param source_file_name string
-- @param target_file_name string
-- @param start_percent number
-- @param end_percent number
-- @param playrate number
-- @return boolean
function Reaper:render_file_section(source_file_name, target_file_name, start_percent, end_percent, playrate)
    return r.RenderFileSection(source_file_name, target_file_name, start_percent, end_percent, playrate)
end

    
--- Reorder Selected Tracks.
-- Moves all selected tracks to immediately above track specified by index
-- beforeTrackIdx, returns false if no tracks were selected. makePrevFolder=0 for
-- normal, 1 = as child of track preceding track specified by beforeTrackIdx, 2 =
-- if track preceding track specified by beforeTrackIdx is last track in folder,
-- extend folder
-- @param before_track_idx number
-- @param make_prev_folder number
-- @return boolean
function Reaper:reorder_selected_tracks(before_track_idx, make_prev_folder)
    return r.ReorderSelectedTracks(before_track_idx, make_prev_folder)
end

    
--- Enum Modes.
-- @param mode number
-- @return string
function Reaper:enum_modes(mode)
    return r.Resample_EnumModes(mode)
end

    
--- Resolve Fn.
-- See resolve_fn2.
-- @param in_ string
-- @param out string
-- @return out string
function Reaper:resolve_fn(in_, out)
    return r.resolve_fn(in_, out)
end

    
--- Resolve Fn2.
-- Resolves a filename "in" by using project settings etc. If no file found, out
-- will be a copy of in.
-- @param in_ string
-- @param out string
-- @param string checkSubDir Optional
-- @return out string
function Reaper:resolve_fn2(in_, out, string)
    local string = string or nil
    return r.resolve_fn2(in_, out, string)
end

    
--- Reverse Named Command Lookup.
-- Get the named command for the given command ID. The returned string will not
-- start with '_' (e.g. it will return "SWS_ABOUT"), it will be NULL if command_id
-- is a native action.
-- @param command_id number
-- @return string
function Reaper:reverse_named_command_lookup(command_id)
    return r.ReverseNamedCommandLookup(command_id)
end

    
--- Scale From Envelope Mode.
-- See GetEnvelopeScalingMode.
-- @param scaling_mode number
-- @param val number
-- @return number
function Reaper:scale_from_envelope_mode(scaling_mode, val)
    return r.ScaleFromEnvelopeMode(scaling_mode, val)
end

    
--- Scale To Envelope Mode.
-- See GetEnvelopeScalingMode.
-- @param scaling_mode number
-- @param val number
-- @return number
function Reaper:scale_to_envelope_mode(scaling_mode, val)
    return r.ScaleToEnvelopeMode(scaling_mode, val)
end

    
--- Section From Unique Id.
-- @param unique_id number
-- @return KbdSectionInfo
function Reaper:section_from_unique_id(unique_id)
    return r.SectionFromUniqueID(unique_id)
end

    
--- Send Midi Message To Hardware.
-- Sends a MIDI message to output device specified by output. Message is sent in
-- immediate mode. Lua example of how to pack the message string: sysex = { 0xF0,
-- 0x00, 0xF7 } msg = "" for i=1, #sysex do msg = msg .. string.char(sysex[i]) end
-- @param output number
-- @param msg string
function Reaper:send_midi_message_to_hardware(output, msg)
    return r.SendMIDIMessageToHardware(output, msg)
end

    
--- Set Automation Mode.
-- sets all or selected tracks to mode.
-- @param mode number
-- @param only_sel boolean
function Reaper:set_automation_mode(mode, only_sel)
    return r.SetAutomationMode(mode, only_sel)
end

    
--- Set Cursor Context.
-- You must use this to change the focus programmatically. mode=0 to focus track
-- panels, 1 to focus the arrange window, 2 to focus the arrange window and select
-- env (or env==NULL to clear the current track/take envelope selection)
-- @param mode number
function Reaper:set_cursor_context(mode)
    return r.SetCursorContext(mode, env_in)
end

    
--- Set Edit Cur Pos.
-- @param time number
-- @param moveview boolean
-- @param seekplay boolean
function Reaper:set_edit_cur_pos(time, moveview, seekplay)
    return r.SetEditCurPos(time, moveview, seekplay)
end

    
--- Set Ext State.
-- Set the extended state value for a specific section and key. persist=true means
-- the value should be stored and reloaded the next time REAPER is opened. See
-- GetExtState, DeleteExtState, HasExtState.
-- @param section string
-- @param key string
-- @param value string
-- @param persist boolean
function Reaper:set_ext_state(section, key, value, persist)
    return r.SetExtState(section, key, value, persist)
end

    
--- Set Global Automation Override.
-- mode: see GetGlobalAutomationOverride
-- @param mode number
function Reaper:set_global_automation_override(mode)
    return r.SetGlobalAutomationOverride(mode)
end

    
--- Set Master Track Visibility.
-- set &1 to show the master track in the TCP, &2 to HIDE in the mixer. Returns the
-- previous visibility state. See GetMasterTrackVisibility.
-- @param flag number
-- @return number
function Reaper:set_master_track_visibility(flag)
    return r.SetMasterTrackVisibility(flag)
end

    
--- Set Mouse Modifier.
-- Set the mouse modifier assignment for a specific modifier key assignment, in a
-- specific context. Context is a string like "MM_CTX_ITEM" (see reaper-mouse.ini)
-- or "Media item left drag" (unlocalized). Modifier flag is a number from 0 to 15:
-- add 1 for shift, 2 for control, 4 for alt, 8 for win. (macOS: add 1 for shift, 2
-- for command, 4 for opt, 8 for control.) For left-click and double-click
-- contexts, the action can be any built-in command ID number or any custom action
-- ID string. Find built-in command IDs in the REAPER actions window (enable "show
-- command IDs" in the context menu), and find custom action ID strings in reaper-
-- kb.ini. The action string may be a mouse modifier ID (see reaper-mouse.ini) with
-- " m" appended to it, or (for click/double-click contexts) a command ID with " c"
-- appended to it, or the text that appears in the mouse modifiers preferences
-- dialog, like "Move item" (unlocalized). For example,
-- SetMouseModifier("MM_CTX_ITEM", 0, "1 m") and SetMouseModifier("Media item left
-- drag", 0, "Move item") are equivalent. SetMouseModifier(context, modifier_flag,
-- -1) will reset that mouse modifier to default. SetMouseModifier(context, -1, -1)
-- will reset the entire context to default. SetMouseModifier(-1, -1, -1) will
-- reset all contexts to default. See GetMouseModifier.
-- @param context string
-- @param modifier_flag number
-- @param action string
function Reaper:set_mouse_modifier(context, modifier_flag, action)
    return r.SetMouseModifier(context, modifier_flag, action)
end

    
--- Set Project Marker.
-- Note: this function can't clear a marker's name (an empty string will leave the
-- name unchanged), see SetProjectMarker4.
-- @param markrgnindexnumber number
-- @param is_rgn boolean
-- @param pos number
-- @param rgnend number
-- @param name string
-- @return boolean
function Reaper:set_project_marker(markrgnindexnumber, is_rgn, pos, rgnend, name)
    return r.SetProjectMarker(markrgnindexnumber, is_rgn, pos, rgnend, name)
end

    
--- Set Theme Color.
-- Temporarily updates the theme color to the color specified (or the theme default
-- color if -1 is specified). Returns -1 on failure, otherwise returns the color
-- (or transformed-color). Note that the UI is not updated by this, the caller
-- should call UpdateArrange() etc as necessary. If the low bit of flags is set,
-- any color transformations are bypassed. To read a value see
-- GetThemeColor.Currently valid ini_keys:
-- @param ini_key string
-- @param color number
-- @param flags number
-- @return number
function Reaper:set_theme_color(ini_key, color, flags)
    return r.SetThemeColor(ini_key, color, flags)
end

    
--- Set Toggle Command State.
-- Updates the toggle state of an action, returns true if succeeded. Only
-- ReaScripts can have their toggle states changed programmatically. See
-- RefreshToolbar2.
-- @param section_id number
-- @param command_id number
-- @param state number
-- @return boolean
function Reaper:set_toggle_command_state(section_id, command_id, state)
    return r.SetToggleCommandState(section_id, command_id, state)
end

    
--- Set Track Midi Note Name.
-- channel < 0 assigns these note names to all channels.
-- @param track number
-- @param pitch number
-- @param chan number
-- @param name string
-- @return boolean
function Reaper:set_track_midi_note_name(track, pitch, chan, name)
    return r.SetTrackMIDINoteName(track, pitch, chan, name)
end

    
--- Show Action List.
-- @param section KbdSectionInfo
-- @param caller_wnd HWND
function Reaper:show_action_list(section, caller_wnd)
    return r.ShowActionList(section, caller_wnd)
end

    
--- Show Console Msg.
-- Show a message to the user (also useful for debugging). Send "\n" for newline,
-- "" to clear the console. Prefix string with "!SHOW:" and text will be added to
-- console without opening the window. See ClearConsole
-- @param msg string
function Reaper:show_console_msg(msg)
    return r.ShowConsoleMsg(msg)
end

    
--- Show Message Box.
-- type 0=OK,1=OKCANCEL,2=ABORTRETRYIGNORE,3=YESNOCANCEL,4=YESNO,5=RETRYCANCEL :
-- ret 1=OK,2=CANCEL,3=ABORT,4=RETRY,5=IGNORE,6=YES,7=NO
-- @param msg string
-- @param title string
-- @param type number
-- @return number
function Reaper:show_message_box(msg, title, type)
    return r.ShowMessageBox(msg, title, type)
end

    
--- Show Popup Menu.
-- shows a context menu, valid names include: track_input, track_panel, track_area,
-- track_routing, item, ruler, envelope, envelope_point, envelope_item. ctxOptional
-- can be a track pointer for track_*, item pointer for item* (but is optional).
-- for envelope_point, ctx2Optional has point index, ctx3Optional has item index
-- (0=main envelope, 1=first AI). for envelope_item, ctx2Optional has AI index
-- (1=first AI)
-- @param name string
-- @param x number
-- @param y number
-- @param hwnd_parent HWND
-- @param ctx identifier
-- @param ctx2 number
-- @param ctx3 number
function Reaper:show_popup_menu(name, x, y, hwnd_parent, ctx, ctx2, ctx3)
    return r.ShowPopupMenu(name, x, y, hwnd_parent, ctx, ctx2, ctx3)
end

    
--- Slider2 Db.
-- @param y number
-- @return number
function Reaper:slider2_db(y)
    return r.SLIDER2DB(y)
end

    
--- Solo All Tracks.
-- solo=2 for SIP
-- @param solo number
function Reaper:solo_all_tracks(solo)
    return r.SoloAllTracks(solo)
end

    
--- Splash Get Wnd.
-- gets the splash window, in case you want to display a message over it. Returns
-- NULL when the splash window is not displayed.
-- @return HWND
function Reaper:splash_get_wnd()
    return r.Splash_GetWnd()
end

    
--- String To Guid.
-- @param str string
-- @param g_guid string
-- @return g_guid string
function Reaper:string_to_guid(str, g_guid)
    return r.stringToGuid(str, g_guid)
end

    
--- Stuff Midi Message.
-- Stuffs a 3 byte MIDI message into either the Virtual MIDI Keyboard queue, or the
-- MIDI-as-control input queue, or sends to a MIDI hardware output. mode=0 for VKB,
-- 1 for control (actions map etc), 2 for VKB-on-current-channel; 16 for external
-- MIDI device 0, 17 for external MIDI device 1, etc; see GetNumMIDIOutputs,
-- GetMIDIOutputName.
-- @param mode number
-- @param msg1 number
-- @param msg2 number
-- @param msg3 number
function Reaper:stuff_midi_message(mode, msg1, msg2, msg3)
    return r.StuffMIDIMessage(mode, msg1, msg2, msg3)
end

    
--- Theme Layout Get Layout.
-- Gets theme layout information. section can be 'global' for global layout
-- override, 'seclist' to enumerate a list of layout sections, otherwise a layout
-- section such as 'mcp', 'tcp', 'trans', etc. idx can be -1 to query the current
-- value, -2 to get the description of the section (if not global), -3 will return
-- the current context DPI-scaling (256=normal, 512=retina, etc), or 0..x. returns
-- false if failed.
-- @param section string
-- @param idx number
-- @return name string
function Reaper:theme_layout_get_layout(section, idx)
    local ret_val, name = r.ThemeLayout_GetLayout(section, idx)
    if ret_val then
        return name
    else
        return nil
    end
end

    
--- Theme Layout Get Parameter.
-- returns theme layout parameter. return value is cfg-name, or nil/empty if out of
-- range.
-- @param wp number
-- @return string desc
-- @return integer value
-- @return integer defValue
-- @return integer minValue
-- @return integer maxValue
function Reaper:theme_layout_get_parameter(wp)
    local ret_val, string, integer, integer, integer, integer = r.ThemeLayout_GetParameter(wp)
    if ret_val then
        return string, integer, integer, integer, integer
    else
        return nil
    end
end

    
--- Theme Layout Refresh All.
-- Refreshes all layouts
function Reaper:theme_layout_refresh_all()
    return r.ThemeLayout_RefreshAll()
end

    
--- Theme Layout Set Layout.
-- Sets theme layout override for a particular section -- section can be 'global'
-- or 'mcp' etc. If setting global layout, prefix a ! to the layout string to clear
-- any per-layout overrides. Returns false if failed.
-- @param section string
-- @param layout string
-- @return boolean
function Reaper:theme_layout_set_layout(section, layout)
    return r.ThemeLayout_SetLayout(section, layout)
end

    
--- Theme Layout Set Parameter.
-- sets theme layout parameter to value. persist=true in order to have change
-- loaded on next theme load. note that the caller should update layouts via ??? to
-- make changes visible.
-- @param wp number
-- @param value number
-- @param persist boolean
-- @return boolean
function Reaper:theme_layout_set_parameter(wp, value, persist)
    return r.ThemeLayout_SetParameter(wp, value, persist)
end

    
--- Time Precise.
-- Gets a precise system timestamp in seconds
-- @return number
function Reaper:time_precise()
    return r.time_precise()
end

    
--- Get Divided Bpm At Time.
-- get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
-- @param time number
-- @return number
function Reaper:get_divided_bpm_at_time(time)
    return r.TimeMap_GetDividedBpmAtTime(time)
end

    
--- Qn To Time.
-- converts project QN position to time.
-- @param qn number
-- @return number
function Reaper:qn_to_time(qn)
    return r.TimeMap_QNToTime(qn)
end

    
--- Time To Qn.
-- converts project QN position to time.
-- @param tpos number
-- @return number
function Reaper:time_to_qn(tpos)
    return r.TimeMap_timeToQN(tpos)
end

    
--- Undo Begin Block.
-- call to start a new block
function Reaper:undo_begin_block()
    return r.Undo_BeginBlock()
end

    
--- Undo End Block.
-- call to end the block,with extra flags if any,and a description
-- @param descchange string
-- @param extraflags number
function Reaper:undo_end_block(descchange, extraflags)
    return r.Undo_EndBlock(descchange, extraflags)
end

    
--- Undo On State Change.
-- limited state change to items
-- @param descchange string
function Reaper:undo_on_state_change(descchange)
    return r.Undo_OnStateChange(descchange)
end

    
--- Undo On State Change Ex.
-- trackparm=-1 by default,or if updating one fx chain,you can specify track index
-- @param descchange string
-- @param which_states number
-- @param trackparm number
function Reaper:undo_on_state_change_ex(descchange, which_states, trackparm)
    return r.Undo_OnStateChangeEx(descchange, which_states, trackparm)
end

    
--- Update Arrange.
-- Redraw the arrange view
function Reaper:update_arrange()
    return r.UpdateArrange()
end

    
--- Update Timeline.
-- Redraw the arrange view and ruler
function Reaper:update_timeline()
    return r.UpdateTimeline()
end

    
--- Validate Ptr.
-- see ValidatePtr2
-- @param pointer identifier
-- @param ctype_name string
-- @return boolean
function Reaper:validate_ptr(pointer, ctype_name)
    return r.ValidatePtr(pointer, ctype_name)
end

    
--- View Prefs.
-- Opens the prefs to a page, use pageByName if page is 0.
-- @param page number
-- @param page_by_name string
function Reaper:view_prefs(page, page_by_name)
    return r.ViewPrefs(page, page_by_name)
end

return Reaper
