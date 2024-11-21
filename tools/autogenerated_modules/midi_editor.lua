-- @description MIDIEditor: Provide implementation for MIDIEditor functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local hwnd = require('hwnd')


local MIDIEditor = {}



--- Create new MIDIEditor instance.
-- @return MIDIEditor table.
function MIDIEditor:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the MIDIEditor logger.
-- @param ... (varargs) Messages to log.
function MIDIEditor:log(...)
    local logger = helpers.log_func('MIDIEditor')
    logger(...)
    return nil
end

    
--- Enum Takes.
-- list the takes that are currently being edited in this MIDI editor, starting
-- with the active take. See MIDIEditor_GetTake
-- @param takeindex integer
-- @param editable_only boolean
-- @return MediaItemTake table
function MIDIEditor:enum_takes(takeindex, editable_only)
    local result = r.MIDIEditor_EnumTakes(self.pointer, takeindex, editable_only)
    return media_item_take.MediaItemTake:new(result)
end

    
--- Get Active.
-- get a pointer to the focused MIDI editor window see MIDIEditor_GetMode,
-- MIDIEditor_OnCommand
-- @return HWND table
function MIDIEditor:get_active()
    local result = r.MIDIEditor_GetActive()
    return hwnd.HWND:new(result)
end

    
--- Get Mode.
-- get the mode of a MIDI editor (0=piano roll, 1=event list, -1=invalid editor)
-- see MIDIEditor_GetActive, MIDIEditor_OnCommand
-- @return integer
function MIDIEditor:get_mode()
    return r.MIDIEditor_GetMode(self.pointer)
end

    
--- Get Settingint.
-- Get settings from a MIDI editor. setting_desc can be: snap_enabled: returns 0 or
-- 1 active_note_row: returns 0-127 last_clicked_cc_lane: returns 0-127=CC,
-- 0x100|(0-31)=14-bit CC, 0x200=velocity, 0x201=pitch, 0x202=program,
-- 0x203=channel pressure, 0x204=bank/program select, 0x205=text, 0x206=sysex,
-- 0x207=off velocity, 0x208=notation events, 0x210=media item lane
-- default_note_vel: returns 0-127 default_note_chan: returns 0-15
-- default_note_len: returns default length in MIDI ticks scale_enabled: returns
-- 0-1 scale_root: returns 0-12 (0=C) list_cnt: if viewing list view, returns event
-- count if setting_desc is unsupported, the function returns -1. See
-- MIDIEditor_SetSetting_int, MIDIEditor_GetActive, MIDIEditor_GetSetting_str
-- @param setting_desc string
-- @return integer
function MIDIEditor:get_settingint(setting_desc)
    return r.MIDIEditor_GetSetting_int(self.pointer, setting_desc)
end

    
--- Get Settingstr.
-- Get settings from a MIDI editor. setting_desc can be: last_clicked_cc_lane:
-- returns text description ("velocity", "pitch", etc) scale: returns the scale
-- record, for example "102034050607" for a major scale list_X: if viewing list
-- view, returns string describing event at row X (0-based). String will have a
-- list of key=value pairs, e.g. 'pos=4.0 len=4.0 offvel=127 msg=90317F'. pos/len
-- times are in QN, len/offvel may not be present if event is not a note. other
-- keys which may be present include pos_pq/len_pq, sel, mute, ccval14, ccshape,
-- ccbeztension. if setting_desc is unsupported, the function returns false. See
-- MIDIEditor_GetActive, MIDIEditor_GetSetting_int
-- @param setting_desc string
-- @return buf string
function MIDIEditor:get_settingstr(setting_desc)
    local retval, buf = r.MIDIEditor_GetSetting_str(self.pointer, setting_desc)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Take.
-- get the take that is currently being edited in this MIDI editor. see
-- MIDIEditor_EnumTakes
-- @return MediaItemTake table
function MIDIEditor:get_take()
    local result = r.MIDIEditor_GetTake(self.pointer)
    return media_item_take.MediaItemTake:new(result)
end

    
--- Last Focused On Command.
-- Send an action command to the last focused MIDI editor. Returns false if there
-- is no MIDI editor open, or if the view mode (piano roll or event list) does not
-- match the input. see MIDIEditor_OnCommand
-- @param command_id integer
-- @param is_lis_tviewcommand boolean
-- @return boolean
function MIDIEditor:last_focused_on_command(command_id, is_lis_tviewcommand)
    return r.MIDIEditor_LastFocused_OnCommand(command_id, is_lis_tviewcommand)
end

    
--- On Command.
-- Send an action command to a MIDI editor. Returns false if the supplied MIDI
-- editor pointer is not valid (not an open MIDI editor). see MIDIEditor_GetActive,
-- MIDIEditor_LastFocused_OnCommand
-- @param command_id integer
-- @return boolean
function MIDIEditor:on_command(command_id)
    return r.MIDIEditor_OnCommand(self.pointer, command_id)
end

    
--- Set Settingint.
-- Set settings for a MIDI editor. setting_desc can be: active_note_row: 0-127 See
-- MIDIEditor_GetSetting_int
-- @param setting_desc string
-- @param setting integer
-- @return boolean
function MIDIEditor:set_settingint(setting_desc, setting)
    return r.MIDIEditor_SetSetting_int(self.pointer, setting_desc, setting)
end

return MIDIEditor
