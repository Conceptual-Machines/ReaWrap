-- [S&M] Instantiates a new "fast string". You must delete this string, see SNM_DeleteFastString.
-- @str string
-- @return WDL_FastString 
function SNM:create_fast_string(str)
    return r.SNM_CreateFastString(str)
end

-- [S&M] Deletes a "fast string" instance.
-- @str WDL_FastString
function SNM:delete_fast_string(str)
    return r.SNM_DeleteFastString(str)
end

-- [S&M] Returns a floating-point preference (look in project prefs first, then in general prefs). Returns errvalue if failed (e.g. varname not found).
-- @varname string
-- @errvalue number
-- @return number 
function SNM:get_double_config_var(varname, errvalue)
    return r.SNM_GetDoubleConfigVar(varname, errvalue)
end

-- [S&M] Gets the "fast string" content.
-- @str WDL_FastString
-- @return string 
function SNM:get_fast_string(str)
    return r.SNM_GetFastString(str)
end

-- [S&M] Gets the "fast string" length.
-- @str WDL_FastString
-- @return integer 
function SNM:get_fast_string_length(str)
    return r.SNM_GetFastStringLength(str)
end

-- [S&M] Returns an integer preference (look in project prefs first, then in general prefs). Returns errvalue if failed (e.g. varname not found).
-- @varname string
-- @errvalue integer
-- @return integer 
function SNM:get_int_config_var(varname, errvalue)
    return r.SNM_GetIntConfigVar(varname, errvalue)
end

-- [S&M] Reads a 64-bit integer preference split in two 32-bit integers (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found).
-- @varname string
-- @return number, number 
function SNM:get_long_config_var(varname)
    local retval, high, low = r.SNM_GetLongConfigVar(varname)
    if retval then
        return high, low
    end
end

-- Note: unlike the native GetSetObjectState, calling to FreeHeapPtr() is not required.
-- @identifier obj
-- @state WDL_FastString
-- @retval ReaType
-- @setnewvalue boolean
-- @wantminimalstate boolean
-- @return boolean 
function SNM:get_set_object_state(identifier, state, retval, setnewvalue, wantminimalstate)
    return r.SNM_GetSetObjectState(identifier, state, retval, setnewvalue, wantminimalstate)
end

-- [S&M] Reads a media file tag. Supported tags: "artist", "album", "genre", "comment", "title", "track" (track number) or "year". Returns false if tag was not found. See SNM_TagMediaFile.
-- @fn string
-- @tag string
-- @return string 
function SNM:read_media_file_tag(fn, tag)
    local retval, tagval = r.SNM_ReadMediaFileTag(fn, tag)
    if retval then
        return tagval
    end
end

-- [S&M] Select a bookmark of the Resources window. Returns the related bookmark id (or -1 if failed).
-- @name string
-- @return integer 
function SNM:select_resource_bookmark(name)
    return r.SNM_SelectResourceBookmark(name)
end

-- [S&M] Sets a floating-point preference (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found or newvalue out of range).
-- @varname string
-- @newvalue number
-- @return boolean 
function SNM:set_double_config_var(varname, newvalue)
    return r.SNM_SetDoubleConfigVar(varname, newvalue)
end

-- [S&M] Sets the "fast string" content. Returns str for facility.
-- @str WDL_FastString
-- @newstr string
-- @return WDL_FastString 
function SNM:set_fast_string(str, newstr)
    return r.SNM_SetFastString(str, newstr)
end

-- [S&M] Sets an integer preference (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found or newvalue out of range).
-- @varname string
-- @newvalue integer
-- @return boolean 
function SNM:set_int_config_var(varname, newvalue)
    return r.SNM_SetIntConfigVar(varname, newvalue)
end

-- [S&M] Sets a 64-bit integer preference from two 32-bit integers (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found).
-- @varname string
-- @new_high_value integer
-- @new_low_value integer
-- @return boolean 
function SNM:set_long_config_var(varname, new_high_value, new_low_value)
    return r.SNM_SetLongConfigVar(varname, new_high_value, new_low_value)
end

-- [S&M] Tags a media file thanks to TagLib. Supported tags: "artist", "album", "genre", "comment", "title", "track" (track number) or "year". Use an empty tagval to clear a tag. When a file is opened in REAPER, turn it offline before using this function. Returns false if nothing updated. See SNM_ReadMediaFileTag.
-- @fn string
-- @tag string
-- @tagval string
-- @return boolean 
function SNM:tag_media_file(fn, tag, tagval)
    return r.SNM_TagMediaFile(fn, tag, tagval)
end

-- [S&M] Attach Resources slot actions to a given bookmark.
-- @bookmark_id integer
function SNM:tie_resource_slot_actions(bookmark_id)
    return r.SNM_TieResourceSlotActions(bookmark_id)
end

