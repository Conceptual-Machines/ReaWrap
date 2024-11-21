-- @description CF: Provide implementation for CF functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_track = require('media_track')
local rea_project = require('rea_project')


local CF = {}



--- Create new CF instance.
-- @return CF table.
function CF:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the CF logger.
-- @param ... (varargs) Messages to log.
function CF:log(...)
    local logger = helpers.log_func('CF')
    logger(...)
    return nil
end

    
--- Enum Selected Fx.
-- Return the index of the next selected effect in the given FX chain. Start index
-- should be -1. Returns -1 if there are no more selected effects.
-- @param hwnd FxChain
-- @param index integer
-- @return integer
function CF:enum_selected_fx(hwnd, index)
    return r.CF_EnumSelectedFX(hwnd, index)
end

    
--- Get Clipboard.
-- Read the contents of the system clipboard.
-- @return text string
function CF:get_clipboard()
    return r.CF_GetClipboard()
end

    
--- Get Custom Color.
-- Get one of 16 SWS custom colors (0xBBGGRR on Windows, 0xRRGGBB everyhwere else).
-- Index is zero-based.
-- @param index integer
-- @return integer
function CF:get_custom_color(index)
    return r.CF_GetCustomColor(index)
end

    
--- Get Focused Fx Chain.
-- Return a handle to the currently focused FX chain window.
-- @return FxChain
function CF:get_focused_fx_chain()
    return r.CF_GetFocusedFXChain()
end

    
--- Get Sws Version.
-- Return the current SWS version number.
-- @return version string
function CF:get_sws_version()
    return r.CF_GetSWSVersion()
end

    
--- Locate In Explorer.
-- Select the given file in explorer/finder.
-- @param file string
-- @return boolean
function CF:locate_in_explorer(file)
    return r.CF_LocateInExplorer(file)
end

    
--- Normalize Utf8.
-- Apply Unicode normalization to the provided UTF-8 string.
-- @param input string
-- @param mode integer
-- @return normalized string
function CF:normalize_utf8(input, mode)
    return r.CF_NormalizeUTF8(input, mode)
end

    
--- Preview Get Output Track.
-- @param preview CF_Preview
-- @return MediaTrack table
function CF:preview_get_output_track(preview)
    local result = r.CF_Preview_GetOutputTrack(preview)
    return media_track.MediaTrack:new(result)
end

    
--- Preview Get Peak.
-- Return the maximum sample value played since the last read. Refresh speed
-- depends on buffer size.
-- @param preview CF_Preview
-- @param channel integer
-- @return peakvol number
function CF:preview_get_peak(preview, channel)
    local retval, peakvol = r.CF_Preview_GetPeak(preview, channel)
    if retval then
        return peakvol
    else
        return nil
    end
end

    
--- Preview Get Value.
-- Supported attributes: B_LOOP         seek to the beginning when reaching the end
-- of the source B_PPITCH       preserve pitch when changing playback rate
-- D_FADEINLEN    length in seconds of playback fade in D_FADEOUTLEN   length in
-- seconds of playback fade out D_LENGTH       (read only) length of the source *
-- playback rate D_MEASUREALIGN >0 = wait until the next bar before starting
-- playback (note: this causes playback to silently continue when project is paused
-- and previewing through a track) D_PAN          playback pan D_PITCH        pitch
-- adjustment in semitones D_PLAYRATE     playback rate (0.01..100) D_POSITION
-- current playback position D_VOLUME       playback volume I_OUTCHAN      first
-- hardware output channel (&1024=mono, reads -1 when playing through a track, see
-- CF_Preview_SetOutputTrack) I_PITCHMODE    highest 16 bits=pitch shift mode (see
-- EnumPitchShiftModes), lower 16 bits=pitch shift submode (see
-- EnumPitchShiftSubModes)
-- @param preview CF_Preview
-- @param name string
-- @return value number
function CF:preview_get_value(preview, name)
    local retval, value = r.CF_Preview_GetValue(preview, name)
    if retval then
        return value
    else
        return nil
    end
end

    
--- Preview Play.
-- Start playback of the configured preview object.
-- @param preview CF_Preview
-- @return boolean
function CF:preview_play(preview)
    return r.CF_Preview_Play(preview)
end

    
--- Preview Set Output Track.
-- @param preview CF_Preview
-- @return boolean
function CF:preview_set_output_track(preview)
    return r.CF_Preview_SetOutputTrack(preview, project, track)
end

    
--- Preview Set Value.
-- See CF_Preview_GetValue.
-- @param preview CF_Preview
-- @param name string
-- @param new_value number
-- @return boolean
function CF:preview_set_value(preview, name, new_value)
    return r.CF_Preview_SetValue(preview, name, new_value)
end

    
--- Preview Stop.
-- Stop and destroy a preview object.
-- @param preview CF_Preview
-- @return boolean
function CF:preview_stop(preview)
    return r.CF_Preview_Stop(preview)
end

    
--- Preview Stop All.
-- Stop and destroy all currently active preview objects.
function CF:preview_stop_all()
    return r.CF_Preview_StopAll()
end

    
--- Send Action Shortcut.
-- Run in the specified window the action command ID associated with the shortcut
-- key in the given section. See CF_EnumerateActions for common section IDs.
-- @param hwnd identifier
-- @param section integer
-- @param key integer
-- @param integer modifiersIn optional
-- @return boolean
function CF:send_action_shortcut(hwnd, section, key, integer)
    local integer = integer or nil
    return r.CF_SendActionShortcut(hwnd, section, key, integer)
end

    
--- Set Clipboard.
-- Write the given string into the system clipboard.
-- @param str string
function CF:set_clipboard(str)
    return r.CF_SetClipboard(str)
end

    
--- Set Custom Color.
-- Set one of 16 SWS custom colors (0xBBGGRR on Windows, 0xRRGGBB everyhwere else).
-- Index is zero-based.
-- @param index integer
-- @param color integer
function CF:set_custom_color(index, color)
    return r.CF_SetCustomColor(index, color)
end

    
--- Shell Execute.
-- Open the given file or URL in the default application. See also
-- CF_LocateInExplorer.
-- @param file string
-- @return boolean
function CF:shell_execute(file)
    return r.CF_ShellExecute(file)
end

return CF
