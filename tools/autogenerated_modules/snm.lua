-- @description SNM: Provide implementation for SNM functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_item = require('media_item')
local media_item_take = require('media_item_take')
local media_track = require('media_track')
local rea_project = require('rea_project')


local SNM = {}



--- Create new SNM instance.
-- @return SNM table.
function SNM:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the SNM logger.
-- @param ... (varargs) Messages to log.
function SNM:log(...)
    local logger = helpers.log_func('SNM')
    logger(...)
    return nil
end

    
--- Add Tcpfx Parm.
-- [S&M] Add an FX parameter knob in the TCP. Returns false if nothing updated
-- (invalid parameters, knob already present, etc..)
-- @param fx_id integer
-- @param prm_id integer
-- @return boolean
function SNM:add_tcpfx_parm(fx_id, prm_id)
    return r.SNM_AddTCPFXParm(self.pointer, fx_id, prm_id)
end

    
--- Create Fast String.
-- [S&M] Instantiates a new "fast string". You must delete this string, see
-- SNM_DeleteFastString.
-- @param str string
-- @return WDL_FastString
function SNM:create_fast_string(str)
    return r.SNM_CreateFastString(str)
end

    
--- Delete Fast String.
-- [S&M] Deletes a "fast string" instance.
-- @param str WDL_FastString
function SNM:delete_fast_string(str)
    return r.SNM_DeleteFastString(str)
end

    
--- Get Double Config Var.
-- [S&M] Returns a floating-point preference (look in project prefs first, then in
-- general prefs). Returns errvalue if failed (e.g. varname not found).
-- @param varname string
-- @param errvalue number
-- @return number
function SNM:get_double_config_var(varname, errvalue)
    return r.SNM_GetDoubleConfigVar(varname, errvalue)
end

    
--- Get Double Config Var Ex.
-- [S&M] See SNM_GetDoubleConfigVar.
-- @param varname string
-- @param errvalue number
-- @return number
function SNM:get_double_config_var_ex(varname, errvalue)
    return r.SNM_GetDoubleConfigVarEx(self.pointer, varname, errvalue)
end

    
--- Get Fast String.
-- [S&M] Gets the "fast string" content.
-- @param str WDL_FastString
-- @return string
function SNM:get_fast_string(str)
    return r.SNM_GetFastString(str)
end

    
--- Get Fast String Length.
-- [S&M] Gets the "fast string" length.
-- @param str WDL_FastString
-- @return integer
function SNM:get_fast_string_length(str)
    return r.SNM_GetFastStringLength(str)
end

    
--- Get Int Config Var.
-- [S&M] Returns an integer preference (look in project prefs first, then in
-- general prefs). Returns errvalue if failed (e.g. varname not found).
-- @param varname string
-- @param errvalue integer
-- @return integer
function SNM:get_int_config_var(varname, errvalue)
    return r.SNM_GetIntConfigVar(varname, errvalue)
end

    
--- Get Int Config Var Ex.
-- [S&M] See SNM_GetIntConfigVar.
-- @param varname string
-- @param errvalue integer
-- @return integer
function SNM:get_int_config_var_ex(varname, errvalue)
    return r.SNM_GetIntConfigVarEx(self.pointer, varname, errvalue)
end

    
--- Get Long Config Var.
-- [S&M] Reads a 64-bit integer preference split in two 32-bit integers (look in
-- project prefs first, then in general prefs). Returns false if failed (e.g.
-- varname not found).
-- @param varname string
-- @return high integer
-- @return low integer
function SNM:get_long_config_var(varname)
    local retval, high, low = r.SNM_GetLongConfigVar(varname)
    if retval then
        return high, low
    else
        return nil
    end
end

    
--- Get Long Config Var Ex.
-- [S&M] See SNM_GetLongConfigVar.
-- @param varname string
-- @return high integer
-- @return low integer
function SNM:get_long_config_var_ex(varname)
    local retval, high, low = r.SNM_GetLongConfigVarEx(self.pointer, varname)
    if retval then
        return high, low
    else
        return nil
    end
end

    
--- Get Media Item Take By Guid.
-- [S&M] Gets a take by GUID as string. The GUID must be enclosed in braces {}. To
-- get take GUID as string, see BR_GetMediaItemTakeGUID
-- @param guid string
-- @return MediaItemTake table
function SNM:get_media_item_take_by_guid(guid)
    local result = r.SNM_GetMediaItemTakeByGUID(self.pointer, guid)
    return media_item_take.MediaItemTake:new(result)
end

    
--- Get Project Marker Name.
-- [S&M] Gets a marker/region name. Returns true if marker/region found.
-- @param num integer
-- @param is_rgn boolean
-- @param name WDL_FastString
-- @return boolean
function SNM:get_project_marker_name(num, is_rgn, name)
    return r.SNM_GetProjectMarkerName(self.pointer, num, is_rgn, name)
end

    
--- Get Set Object State.
-- [S&M] Gets or sets the state of a track, an item or an envelope. The state chunk
-- size is unlimited. Returns false if failed. When getting a track state (and when
-- you are not interested in FX data), you can use wantminimalstate=true to
-- radically reduce the length of the state. Do not set such minimal states back
-- though, this is for read-only applications! Note: unlike the native
-- GetSetObjectState, calling to FreeHeapPtr() is not required.
-- @param obj identifier
-- @param state WDL_FastString
-- @param setnewvalue boolean
-- @param wantminimalstate boolean
-- @return boolean
function SNM:get_set_object_state(obj, state, setnewvalue, wantminimalstate)
    return r.SNM_GetSetObjectState(obj, state, setnewvalue, wantminimalstate)
end

    
--- Get Set Source State.
-- [S&M] Gets or sets a take source state. Returns false if failed. Use takeidx=-1
-- to get/alter the active take. Note: this function does not use a MediaItem_Take*
-- param in order to manage empty takes (i.e. takes with MediaItem_Take*==NULL),
-- see SNM_GetSetSourceState2.
-- @param take_idx integer
-- @param state WDL_FastString
-- @param setnewvalue boolean
-- @return boolean
function SNM:get_set_source_state(take_idx, state, setnewvalue)
    return r.SNM_GetSetSourceState(self.pointer, take_idx, state, setnewvalue)
end

    
--- Get Set Source State2.
-- [S&M] Gets or sets a take source state. Returns false if failed. Note: this
-- function cannot deal with empty takes, see SNM_GetSetSourceState.
-- @param state WDL_FastString
-- @param setnewvalue boolean
-- @return boolean
function SNM:get_set_source_state2(state, setnewvalue)
    return r.SNM_GetSetSourceState2(self.pointer, state, setnewvalue)
end

    
--- Read Media File Tag.
-- [S&M] Reads a media file tag. Supported tags: "artist", "album", "genre",
-- "comment", "title", "track" (track number) or "year". Returns false if tag was
-- not found. See SNM_TagMediaFile.
-- @param fn string
-- @param tag string
-- @return tagval string
function SNM:read_media_file_tag(fn, tag)
    local retval, tagval = r.SNM_ReadMediaFileTag(fn, tag)
    if retval then
        return tagval
    else
        return nil
    end
end

    
--- Remove Receives From.
-- [S&M] Removes all receives from srctr. Returns false if nothing updated.
-- @return boolean
function SNM:remove_receives_from()
    return r.SNM_RemoveReceivesFrom(self.pointer, srctr)
end

    
--- Select Resource Bookmark.
-- [S&M] Select a bookmark of the Resources window. Returns the related bookmark id
-- (or -1 if failed).
-- @param name string
-- @return integer
function SNM:select_resource_bookmark(name)
    return r.SNM_SelectResourceBookmark(name)
end

    
--- Set Double Config Var.
-- [S&M] Sets a floating-point preference (look in project prefs first, then in
-- general prefs). Returns false if failed (e.g. varname not found or newvalue out
-- of range).
-- @param varname string
-- @param newvalue number
-- @return boolean
function SNM:set_double_config_var(varname, newvalue)
    return r.SNM_SetDoubleConfigVar(varname, newvalue)
end

    
--- Set Double Config Var Ex.
-- [S&M] See SNM_SetDoubleConfigVar.
-- @param varname string
-- @param newvalue number
-- @return boolean
function SNM:set_double_config_var_ex(varname, newvalue)
    return r.SNM_SetDoubleConfigVarEx(self.pointer, varname, newvalue)
end

    
--- Set Fast String.
-- [S&M] Sets the "fast string" content. Returns str for facility.
-- @param str WDL_FastString
-- @param newstr string
-- @return WDL_FastString
function SNM:set_fast_string(str, newstr)
    return r.SNM_SetFastString(str, newstr)
end

    
--- Set Int Config Var.
-- [S&M] Sets an integer preference (look in project prefs first, then in general
-- prefs). Returns false if failed (e.g. varname not found or newvalue out of
-- range).
-- @param varname string
-- @param newvalue integer
-- @return boolean
function SNM:set_int_config_var(varname, newvalue)
    return r.SNM_SetIntConfigVar(varname, newvalue)
end

    
--- Set Int Config Var Ex.
-- [S&M] See SNM_SetIntConfigVar.
-- @param varname string
-- @param newvalue integer
-- @return boolean
function SNM:set_int_config_var_ex(varname, newvalue)
    return r.SNM_SetIntConfigVarEx(self.pointer, varname, newvalue)
end

    
--- Set Long Config Var.
-- [S&M] Sets a 64-bit integer preference from two 32-bit integers (look in project
-- prefs first, then in general prefs). Returns false if failed (e.g. varname not
-- found).
-- @param varname string
-- @param new_high_value integer
-- @param new_low_value integer
-- @return boolean
function SNM:set_long_config_var(varname, new_high_value, new_low_value)
    return r.SNM_SetLongConfigVar(varname, new_high_value, new_low_value)
end

    
--- Set Long Config Var Ex.
-- [S&M] SNM_SetLongConfigVar.
-- @param varname string
-- @param new_high_value integer
-- @param new_low_value integer
-- @return boolean
function SNM:set_long_config_var_ex(varname, new_high_value, new_low_value)
    return r.SNM_SetLongConfigVarEx(self.pointer, varname, new_high_value, new_low_value)
end

    
--- Set String Config Var.
-- [S&M] Sets a string preference (general prefs only). Returns false if failed
-- (e.g. varname not found or value too long). See get_config_var_string.
-- @param varname string
-- @param newvalue string
-- @return boolean
function SNM:set_string_config_var(varname, newvalue)
    return r.SNM_SetStringConfigVar(varname, newvalue)
end

    
--- Tag Media File.
-- [S&M] Tags a media file thanks to TagLib. Supported tags: "artist", "album",
-- "genre", "comment", "title", "track" (track number) or "year". Use an empty
-- tagval to clear a tag. When a file is opened in REAPER, turn it offline before
-- using this function. Returns false if nothing updated. See SNM_ReadMediaFileTag.
-- @param fn string
-- @param tag string
-- @param tagval string
-- @return boolean
function SNM:tag_media_file(fn, tag, tagval)
    return r.SNM_TagMediaFile(fn, tag, tagval)
end

    
--- Tie Resource Slot Actions.
-- [S&M] Attach Resources slot actions to a given bookmark.
-- @param bookmark_id integer
function SNM:tie_resource_slot_actions(bookmark_id)
    return r.SNM_TieResourceSlotActions(bookmark_id)
end

return SNM
