-- @description NF: Provide implementation for NF functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_item = require('media_item')
local media_item_take = require('media_item_take')
local media_track = require('media_track')


local NF = {}



--- Create new NF instance.
-- @return NF table.
function NF:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the NF logger.
-- @param ... (varargs) Messages to log.
function NF:log(...)
    local logger = helpers.log_func('NF')
    logger(...)
    return nil
end

    
--- Analyze Media Item Peak And Rms.
-- This function combines all other NF_Peak/RMS functions in a single one and
-- additionally returns peak RMS positions. Lua example code here. Note: It's
-- recommended to use this function with ReaScript/Lua as it provides reaper.array
-- objects. If using this function with other scripting languages, you must provide
-- arrays in the reaper.array format.
-- @param window_size number
-- @param reaperarray_peaks identifier
-- @param reaperarray_peakpositions identifier
-- @param reaperarray_rm_ss identifier
-- @param reaperarray_rm_spositions identifier
-- @return boolean
function NF:analyze_media_item_peak_and_rms(window_size, reaperarray_peaks, reaperarray_peakpositions, reaperarray_rm_ss, reaperarray_rm_spositions)
    return r.NF_AnalyzeMediaItemPeakAndRMS(self.pointer, window_size, reaperarray_peaks, reaperarray_peakpositions, reaperarray_rm_ss, reaperarray_rm_spositions)
end

    
--- Analyze Take Loudness.
-- Full loudness analysis. retval: returns true on successful analysis, false on
-- MIDI take or when analysis failed for some reason. analyzeTruePeak=true: Also do
-- true peak analysis. Returns true peak value in dBTP and true peak position
-- (relative to item position). Considerably slower than without true peak analysis
-- (since it uses oversampling). Note: Short term uses a time window of 3 sec. for
-- calculation. So for items shorter than this shortTermMaxOut can't be calculated
-- correctly. Momentary uses a time window of 0.4 sec.
-- @param analyze_true_peak boolean
-- @return lufs_integrated number
-- @return range number
-- @return true_peak number
-- @return true_peak_pos number
-- @return short_term_max number
-- @return momentary_max number
function NF:analyze_take_loudness(analyze_true_peak)
    local retval, lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max = r.NF_AnalyzeTakeLoudness(self.pointer, analyze_true_peak)
    if retval then
        return lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max
    else
        return nil
    end
end

    
--- Analyze Take Loudness2.
-- Same as NF_AnalyzeTakeLoudness but additionally returns shortTermMaxPos and
-- momentaryMaxPos (in absolute project time). Note: shortTermMaxPos and
-- momentaryMaxPos indicate the beginning of time intervalls, (3 sec. and 0.4 sec.
-- resp.).
-- @param analyze_true_peak boolean
-- @return lufs_integrated number
-- @return range number
-- @return true_peak number
-- @return true_peak_pos number
-- @return short_term_max number
-- @return momentary_max number
-- @return short_term_max_pos number
-- @return momentary_max_pos number
function NF:analyze_take_loudness2(analyze_true_peak)
    local retval, lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max, short_term_max_pos, momentary_max_pos = r.NF_AnalyzeTakeLoudness2(self.pointer, analyze_true_peak)
    if retval then
        return lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max, short_term_max_pos, momentary_max_pos
    else
        return nil
    end
end

    
--- Analyze Take Loudness Integrated Only.
-- Does LUFS integrated analysis only. Faster than full loudness analysis
-- (NF_AnalyzeTakeLoudness) . Use this if only LUFS integrated is required. Take
-- vol. env. is taken into account. See: Signal flow
-- @return lufs_integrated number
function NF:analyze_take_loudness_integrated_only()
    local retval, lufs_integrated = r.NF_AnalyzeTakeLoudness_IntegratedOnly(self.pointer)
    if retval then
        return lufs_integrated
    else
        return nil
    end
end

    
--- Base64 Decode.
-- Returns true on success.
-- @param base64_str string
-- @return decoded_str string
function NF:base64_decode(base64_str)
    local retval, decoded_str = r.NF_Base64_Decode(base64_str)
    if retval then
        return decoded_str
    else
        return nil
    end
end

    
--- Base64 Encode.
-- Input string may contain null bytes in REAPER 6.44 or newer. Note: Doesn't allow
-- padding in the middle (e.g. concatenated encoded strings), doesn't allow
-- newlines.
-- @param str string
-- @param use_padding boolean
-- @return encoded_str string
function NF:base64_encode(str, use_padding)
    return r.NF_Base64_Encode(str, use_padding)
end

    
--- Clear Global Startup Action.
-- Returns true if global startup action was cleared successfully.
-- @return boolean
function NF:clear_global_startup_action()
    return r.NF_ClearGlobalStartupAction()
end

    
--- Clear Project Startup Action.
-- Returns true if project startup action was cleared successfully.
-- @return boolean
function NF:clear_project_startup_action()
    return r.NF_ClearProjectStartupAction()
end

    
--- Clear Project Track Selection Action.
-- Returns true if project track selection action was cleared successfully.
-- @return boolean
function NF:clear_project_track_selection_action()
    return r.NF_ClearProjectTrackSelectionAction()
end

    
--- Delete Take From Item.
-- Deletes a take from an item. takeIdx is zero-based. Returns true on success.
-- @param take__idx integer
-- @return boolean
function NF:delete_take_from_item(take__idx)
    return r.NF_DeleteTakeFromItem(self.pointer, take__idx)
end

    
--- Get Global Startup Action.
-- Gets action description and command ID number (for native actions) or named
-- command IDs / identifier strings (for extension actions /ReaScripts) if global
-- startup action is set, otherwise empty string. Returns false on failure.
-- @return desc string
-- @return cmd_id string
function NF:get_global_startup_action()
    local retval, desc, cmd_id = r.NF_GetGlobalStartupAction()
    if retval then
        return desc, cmd_id
    else
        return nil
    end
end

    
--- Get Media Item Average Rms.
-- Returns the average overall (non-windowed) dB RMS level of active channels of an
-- audio item active take, post item gain, post take volume envelope, post-fade,
-- pre fader, pre item FX.   Returns -150.0 if MIDI take or empty item.
-- @return number
function NF:get_media_item_average_rms()
    return r.NF_GetMediaItemAverageRMS(self.pointer)
end

    
--- Get Media Item Max Peak.
-- Returns the greatest max. peak value in dBFS of all active channels of an audio
-- item active take, post item gain, post take volume envelope, post-fade, pre
-- fader, pre item FX.   Returns -150.0 if MIDI take or empty item.
-- @return number
function NF:get_media_item_max_peak()
    return r.NF_GetMediaItemMaxPeak(self.pointer)
end

    
--- Get Media Item Max Peak And Max Peak Pos.
-- See NF_GetMediaItemMaxPeak, additionally returns maxPeakPos (relative to item
-- position).
-- @return max_peak_pos number
function NF:get_media_item_max_peak_and_max_peak_pos()
    local retval, max_peak_pos = r.NF_GetMediaItemMaxPeakAndMaxPeakPos(self.pointer)
    if retval then
        return max_peak_pos
    else
        return nil
    end
end

    
--- Get Media Item Peak Rms Non Windowed.
-- Returns the greatest overall (non-windowed) dB RMS peak level of all active
-- channels of an audio item active take, post item gain, post take volume
-- envelope, post-fade, pre fader, pre item FX.   Returns -150.0 if MIDI take or
-- empty item.
-- @return number
function NF:get_media_item_peak_rms_non_windowed()
    return r.NF_GetMediaItemPeakRMS_NonWindowed(self.pointer)
end

    
--- Get Media Item Peak Rms Windowed.
-- Returns the average dB RMS peak level of all active channels of an audio item
-- active take, post item gain, post take volume envelope, post-fade, pre fader,
-- pre item FX.   Obeys 'Window size for peak RMS' setting in 'SWS: Set RMS
-- analysis/normalize options' for calculation. Returns -150.0 if MIDI take or
-- empty item.
-- @return number
function NF:get_media_item_peak_rms_windowed()
    return r.NF_GetMediaItemPeakRMS_Windowed(self.pointer)
end

    
--- Get Project Startup Action.
-- Gets action description and command ID number (for native actions) or named
-- command IDs / identifier strings (for extension actions /ReaScripts) if project
-- startup action is set, otherwise empty string. Returns false on failure.
-- @return desc string
-- @return cmd_id string
function NF:get_project_startup_action()
    local retval, desc, cmd_id = r.NF_GetProjectStartupAction()
    if retval then
        return desc, cmd_id
    else
        return nil
    end
end

    
--- Get Project Track Selection Action.
-- Gets action description and command ID number (for native actions) or named
-- command IDs / identifier strings (for extension actions /ReaScripts) if project
-- track selection action is set, otherwise empty string. Returns false on failure.
-- @return desc string
-- @return cmd_id string
function NF:get_project_track_selection_action()
    local retval, desc, cmd_id = r.NF_GetProjectTrackSelectionAction()
    if retval then
        return desc, cmd_id
    else
        return nil
    end
end

    
--- Get Sws Marker Region Sub.
-- Returns SWS/S&M marker/region subtitle. markerRegionIdx: Refers to index that
-- can be passed to EnumProjectMarkers (not displayed marker/region index). Returns
-- empty string if marker/region with specified index not found or marker/region
-- subtitle not set. Lua code example here.
-- @param marker_region__idx integer
-- @return string
function NF:get_sws_marker_region_sub(marker_region__idx)
    return r.NF_GetSWSMarkerRegionSub(marker_region__idx)
end

    
--- Get Sws Track Notes.
-- @return string
function NF:get_sws_track_notes()
    return r.NF_GetSWSTrackNotes(self.pointer)
end

    
--- Get Swsrm Soptions.
-- Get SWS analysis/normalize options. See NF_SetSWS_RMSoptions.
-- @return target number
-- @return window_size number
function NF:get_swsrm_soptions()
    return r.NF_GetSWS_RMSoptions()
end

    
--- Get Theme Default Tcp Heights.
-- @return supercollapsed integer
-- @return collapsed integer
-- @return small integer
-- @return recarm integer
function NF:get_theme_default_tcp_heights()
    return r.NF_GetThemeDefaultTCPHeights()
end

    
--- Read Audio File Bitrate.
-- Returns the bitrate of an audio file in kb/s if available (0 otherwise). For
-- supported filetypes see TagLib::AudioProperties::bitrate.
-- @param fn string
-- @return integer
function NF:read_audio_file_bitrate(fn)
    return r.NF_ReadAudioFileBitrate(fn)
end

    
--- Scroll Horizontally By Percentage.
-- 100 means scroll one page. Negative values scroll left.
-- @param amount integer
function NF:scroll_horizontally_by_percentage(amount)
    return r.NF_ScrollHorizontallyByPercentage(amount)
end

    
--- Set Global Startup Action.
-- Returns true if global startup action was set successfully (i.e. valid action
-- ID). Note: For SWS / S&M actions and macros / scripts, you must use identifier
-- strings (e.g. "_SWS_ABOUT", "_f506bc780a0ab34b8fdedb67ed5d3649"), not command
-- IDs (e.g. "47145"). Tip: to copy such identifiers, right-click the action in the
-- Actions window > Copy selected action cmdID / identifier string. NOnly works for
-- actions / scripts from Main action section.
-- @param str string
-- @return boolean
function NF:set_global_startup_action(str)
    return r.NF_SetGlobalStartupAction(str)
end

    
--- Set Project Startup Action.
-- Returns true if project startup action was set successfully (i.e. valid action
-- ID). Note: For SWS / S&M actions and macros / scripts, you must use identifier
-- strings (e.g. "_SWS_ABOUT", "_f506bc780a0ab34b8fdedb67ed5d3649"), not command
-- IDs (e.g. "47145"). Tip: to copy such identifiers, right-click the action in the
-- Actions window > Copy selected action cmdID / identifier string. Only works for
-- actions / scripts from Main action section. Project must be saved after setting
-- project startup action to be persistent.
-- @param str string
-- @return boolean
function NF:set_project_startup_action(str)
    return r.NF_SetProjectStartupAction(str)
end

    
--- Set Project Track Selection Action.
-- Returns true if project track selection action was set successfully (i.e. valid
-- action ID). Note: For SWS / S&M actions and macros / scripts, you must use
-- identifier strings (e.g. "_SWS_ABOUT", "_f506bc780a0ab34b8fdedb67ed5d3649"), not
-- command IDs (e.g. "47145"). Tip: to copy such identifiers, right-click the
-- action in the Actions window > Copy selected action cmdID / identifier string.
-- Only works for actions / scripts from Main action section. Project must be saved
-- after setting project track selection action to be persistent.
-- @param str string
-- @return boolean
function NF:set_project_track_selection_action(str)
    return r.NF_SetProjectTrackSelectionAction(str)
end

    
--- Set Sws Marker Region Sub.
-- Set SWS/S&M marker/region subtitle. markerRegionIdx: Refers to index that can be
-- passed to EnumProjectMarkers (not displayed marker/region index). Returns true
-- if subtitle is set successfully (i.e. marker/region with specified index is
-- present in project). Lua code example here.
-- @param marker_region_sub string
-- @param marker_region__idx integer
-- @return boolean
function NF:set_sws_marker_region_sub(marker_region_sub, marker_region__idx)
    return r.NF_SetSWSMarkerRegionSub(marker_region_sub, marker_region__idx)
end

    
--- Set Sws Track Notes.
-- @param str string
function NF:set_sws_track_notes(str)
    return r.NF_SetSWSTrackNotes(self.pointer, str)
end

    
--- Set Swsrm Soptions.
-- Set SWS analysis/normalize options (same as running action 'SWS: Set RMS
-- analysis/normalize options'). targetLevel: target RMS normalize level (dB),
-- windowSize: window size for peak RMS (sec.)
-- @param target_level number
-- @param window_size number
-- @return boolean
function NF:set_swsrm_soptions(target_level, window_size)
    return r.NF_SetSWS_RMSoptions(target_level, window_size)
end

    
--- Update Sws Marker Region Sub Window.
-- Redraw the Notes window (call if you've changed a subtitle via
-- NF_SetSWSMarkerRegionSub which is currently displayed in the Notes window and
-- you want to appear the new subtitle immediately.)
function NF:update_sws_marker_region_sub_window()
    return r.NF_UpdateSWSMarkerRegionSubWindow()
end

    
--- Win32 Get System Metrics.
-- Equivalent to win32 API GetSystemMetrics(). Note: Only SM_C[XY]SCREEN,
-- SM_C[XY][HV]SCROLL and SM_CYMENU are currently supported on macOS and Linux as
-- of REAPER 6.68. Check the SWELL source code for up-to-date support information
-- (swell-wnd.mm, swell-wnd-generic.cpp).
-- @param n_index integer
-- @return integer
function NF:win32_get_system_metrics(n_index)
    return r.NF_Win32_GetSystemMetrics(n_index)
end

return NF
