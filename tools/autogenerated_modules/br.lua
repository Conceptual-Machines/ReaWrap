-- @description Provide implementation for BR functions.
-- @author NomadMonad
-- @license MIT

local r = reaper
local helpers = require('helpers')


local BR = {}



--- Create new BR instance.
-- @return BR table.
function BR:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- @section ReaWrap Custom Methods

--- Log messages with the BR logger.
-- @param ... (varargs) Messages to log.
function BR:log(...)
    local logger = helpers.log_func('BR')
    logger(...)
    return nil
end


-- @section ReaScript API Methods



    
--- Env Count Points. Wraps BR_EnvCountPoints.
-- [BR] Count envelope points in the envelope object allocated with BR_EnvAlloc.
-- @param envelope BR_Envelope
-- @return number
function BR:env_count_points(envelope)
    return r.BR_EnvCountPoints(envelope)
end

    
--- Env Delete Point. Wraps BR_EnvDeletePoint.
-- [BR] Delete envelope point by index (zero-based) in the envelope object
-- allocated with BR_EnvAlloc. Returns true on success.
-- @param envelope BR_Envelope
-- @param id number
-- @return boolean
function BR:env_delete_point(envelope, id)
    return r.BR_EnvDeletePoint(envelope, id)
end

    
--- Env Find. Wraps BR_EnvFind.
-- [BR] Find envelope point at time position in the envelope object allocated with
-- BR_EnvAlloc. Pass delta > 0 to search surrounding range - in that case the
-- closest point to position within delta will be searched for. Returns envelope
-- point id (zero-based) on success or -1 on failure.
-- @param envelope BR_Envelope
-- @param position number
-- @param delta number
-- @return number
function BR:env_find(envelope, position, delta)
    return r.BR_EnvFind(envelope, position, delta)
end

    
--- Env Find Next. Wraps BR_EnvFindNext.
-- [BR] Find next envelope point after time position in the envelope object
-- allocated with BR_EnvAlloc. Returns envelope point id (zero-based) on success or
-- -1 on failure.
-- @param envelope BR_Envelope
-- @param position number
-- @return number
function BR:env_find_next(envelope, position)
    return r.BR_EnvFindNext(envelope, position)
end

    
--- Env Find Previous. Wraps BR_EnvFindPrevious.
-- [BR] Find previous envelope point before time position in the envelope object
-- allocated with BR_EnvAlloc. Returns envelope point id (zero-based) on success or
-- -1 on failure.
-- @param envelope BR_Envelope
-- @param position number
-- @return number
function BR:env_find_previous(envelope, position)
    return r.BR_EnvFindPrevious(envelope, position)
end

    
--- Env Free. Wraps BR_EnvFree.
-- [BR] Free envelope object allocated with BR_EnvAlloc and commit changes if
-- needed. Returns true if changes were committed successfully. Note that when
-- envelope object wasn't modified nothing will get committed even if commit = true
-- - in that case function returns false.
-- @param envelope BR_Envelope
-- @param commit boolean
-- @return boolean
function BR:env_free(envelope, commit)
    return r.BR_EnvFree(envelope, commit)
end

    
--- Env Get Parent Take. Wraps BR_EnvGetParentTake.
-- [BR] If envelope object allocated with BR_EnvAlloc is take envelope, returns
-- parent media item take, otherwise NULL.
-- @param envelope BR_Envelope
-- @return Take table
function BR:env_get_parent_take(envelope)
    local Take = require('take')
    local result = r.BR_EnvGetParentTake(envelope)
    return Take:new(result)
end

    
--- Env Get Parent Track. Wraps BR_EnvGetParentTrack.
-- [BR] Get parent track of envelope object allocated with BR_EnvAlloc. If take
-- envelope, returns NULL.
-- @param envelope BR_Envelope
-- @return Track table
function BR:env_get_parent_track(envelope)
    local Track = require('track')
    local result = r.BR_EnvGetParentTrack(envelope)
    return Track:new(result)
end

    
--- Env Get Point. Wraps BR_EnvGetPoint.
-- [BR] Get envelope point by id (zero-based) from the envelope object allocated
-- with BR_EnvAlloc. Returns true on success.
-- @param envelope BR_Envelope
-- @param id number
-- @return position number
-- @return value number
-- @return shape number
-- @return selected boolean
-- @return bezier number
function BR:env_get_point(envelope, id)
    local ret_val, position, value, shape, selected, bezier = r.BR_EnvGetPoint(envelope, id)
    if ret_val then
        return position, value, shape, selected, bezier
    else
        return nil
    end
end

    
--- Env Get Properties. Wraps BR_EnvGetProperties.
-- [BR] Get envelope properties for the envelope object allocated with BR_EnvAlloc.
-- @param envelope BR_Envelope
-- @return active boolean
-- @return visible boolean
-- @return armed boolean
-- @return in_lane boolean
-- @return lane_height number
-- @return default_shape number
-- @return min_value number
-- @return max_value number
-- @return center_value number
-- @return type number
-- @return fader_scaling boolean
-- @return integer automationItemsOptions
function BR:env_get_properties(envelope)
    return r.BR_EnvGetProperties(envelope)
end

    
--- Env Set Point. Wraps BR_EnvSetPoint.
-- [BR] Set envelope point by id (zero-based) in the envelope object allocated with
-- BR_EnvAlloc. To create point instead, pass id = -1. Note that if new point is
-- inserted or existing point's time position is changed, points won't
-- automatically get sorted. To do that, see BR_EnvSortPoints. Returns true on
-- success.
-- @param envelope BR_Envelope
-- @param id number
-- @param position number
-- @param value number
-- @param shape number
-- @param selected boolean
-- @param bezier number
-- @return boolean
function BR:env_set_point(envelope, id, position, value, shape, selected, bezier)
    return r.BR_EnvSetPoint(envelope, id, position, value, shape, selected, bezier)
end

    
--- Env Set Properties. Wraps BR_EnvSetProperties.
-- [BR] Set envelope properties for the envelope object allocated with BR_EnvAlloc.
-- For parameter description see BR_EnvGetProperties. Setting
-- automationItemsOptions requires REAPER 5.979+.
-- @param envelope BR_Envelope
-- @param active boolean
-- @param visible boolean
-- @param armed boolean
-- @param in_lane boolean
-- @param lane_height number
-- @param default_shape number
-- @param fader_scaling boolean
-- @param integer automationItemsOptionsIn Optional
function BR:env_set_properties(envelope, active, visible, armed, in_lane, lane_height, default_shape, fader_scaling, integer)
    local integer = integer or nil
    return r.BR_EnvSetProperties(envelope, active, visible, armed, in_lane, lane_height, default_shape, fader_scaling, integer)
end

    
--- Env Sort Points. Wraps BR_EnvSortPoints.
-- [BR] Sort envelope points by position. The only reason to call this is if sorted
-- points are explicitly needed after editing them with BR_EnvSetPoint. Note that
-- you do not have to call this before doing BR_EnvFree since it does handle
-- unsorted points too.
-- @param envelope BR_Envelope
function BR:env_sort_points(envelope)
    return r.BR_EnvSortPoints(envelope)
end

    
--- Env Value At Pos. Wraps BR_EnvValueAtPos.
-- [BR] Get envelope value at time position for the envelope object allocated with
-- BR_EnvAlloc.
-- @param envelope BR_Envelope
-- @param position number
-- @return number
function BR:env_value_at_pos(envelope, position)
    return r.BR_EnvValueAtPos(envelope, position)
end

    
--- Get Closest Grid Division. Wraps BR_GetClosestGridDivision.
-- [BR] Get closest grid division to position. Note that this functions is
-- different from SnapToGrid in two regards. SnapToGrid() needs snap enabled to
-- work and this one works always. Secondly, grid divisions are different from grid
-- lines because some grid lines may be hidden due to zoom level - this function
-- ignores grid line visibility and always searches for the closest grid division
-- at given position. For more grid division functions, see BR_GetNextGridDivision
-- and BR_GetPrevGridDivision.
-- @param position number
-- @return number
function BR:get_closest_grid_division(position)
    return r.BR_GetClosestGridDivision(position)
end

    
--- Get Current Theme. Wraps BR_GetCurrentTheme.
-- [BR] Get current theme information. themePathOut is set to full theme path and
-- themeNameOut is set to theme name excluding any path info and extension
-- @return theme_path string
-- @return theme_name string
function BR:get_current_theme()
    return r.BR_GetCurrentTheme()
end

    
--- Get Mouse Cursor Context. Wraps BR_GetMouseCursorContext.
-- [BR] Get mouse cursor context. Each parameter returns information in a form of
-- string as specified in the table below.
-- @return window string
-- @return segment string
-- @return details string
function BR:get_mouse_cursor_context()
    return r.BR_GetMouseCursorContext()
end

    
--- Get Mouse Cursor Context Envelope. Wraps BR_GetMouseCursorContext_Envelope.
-- [BR] Returns envelope that was captured with the last call to
-- BR_GetMouseCursorContext. In case the envelope belongs to take, takeEnvelope
-- will be true.
-- @return take_envelope boolean
function BR:get_mouse_cursor_context_envelope()
    local ret_val, take_envelope = r.BR_GetMouseCursorContext_Envelope()
    if ret_val then
        return take_envelope
    else
        return nil
    end
end

    
--- Get Mouse Cursor Context Item. Wraps BR_GetMouseCursorContext_Item.
-- [BR] Returns item under mouse cursor that was captured with the last call to
-- BR_GetMouseCursorContext. Note that the function will return item even if mouse
-- cursor is over some other track lane element like stretch marker or envelope.
-- This enables for easier identification of items when you want to ignore elements
-- within the item.
-- @return Item table
function BR:get_mouse_cursor_context_item()
    local Item = require('item')
    local result = r.BR_GetMouseCursorContext_Item()
    return Item:new(result)
end

    
--- Get Mouse Cursor Context Midi. Wraps BR_GetMouseCursorContext_MIDI.
-- [BR] Returns midi editor under mouse cursor that was captured with the last call
-- to BR_GetMouseCursorContext.
-- @return inline_editor boolean
-- @return note_row number
-- @return cc_lane number
-- @return cc_lane_val number
-- @return cc_lane_id number
function BR:get_mouse_cursor_context_midi()
    local ret_val, inline_editor, note_row, cc_lane, cc_lane_val, cc_lane_id = r.BR_GetMouseCursorContext_MIDI()
    if ret_val then
        return inline_editor, note_row, cc_lane, cc_lane_val, cc_lane_id
    else
        return nil
    end
end

    
--- Get Mouse Cursor Context Position. Wraps BR_GetMouseCursorContext_Position.
-- [BR] Returns project time position in arrange/ruler/midi editor that was
-- captured with the last call to BR_GetMouseCursorContext.
-- @return number
function BR:get_mouse_cursor_context_position()
    return r.BR_GetMouseCursorContext_Position()
end

    
--- Get Mouse Cursor Context Stretch Marker. Wraps BR_GetMouseCursorContext_StretchMarker.
-- [BR] Returns id of a stretch marker under mouse cursor that was captured with
-- the last call to BR_GetMouseCursorContext.
-- @return number
function BR:get_mouse_cursor_context_stretch_marker()
    return r.BR_GetMouseCursorContext_StretchMarker()
end

    
--- Get Mouse Cursor Context Take. Wraps BR_GetMouseCursorContext_Take.
-- [BR] Returns take under mouse cursor that was captured with the last call to
-- BR_GetMouseCursorContext.
-- @return Take table
function BR:get_mouse_cursor_context_take()
    local Take = require('take')
    local result = r.BR_GetMouseCursorContext_Take()
    return Take:new(result)
end

    
--- Get Mouse Cursor Context Track. Wraps BR_GetMouseCursorContext_Track.
-- [BR] Returns track under mouse cursor that was captured with the last call to
-- BR_GetMouseCursorContext.
-- @return Track table
function BR:get_mouse_cursor_context_track()
    local Track = require('track')
    local result = r.BR_GetMouseCursorContext_Track()
    return Track:new(result)
end

    
--- Get Next Grid Division. Wraps BR_GetNextGridDivision.
-- [BR] Get next grid division after the time position. For more grid divisions
-- function, see BR_GetClosestGridDivision and BR_GetPrevGridDivision.
-- @param position number
-- @return number
function BR:get_next_grid_division(position)
    return r.BR_GetNextGridDivision(position)
end

    
--- Get Prev Grid Division. Wraps BR_GetPrevGridDivision.
-- [BR] Get previous grid division before the time position. For more grid division
-- functions, see BR_GetClosestGridDivision and BR_GetNextGridDivision.
-- @param position number
-- @return number
function BR:get_prev_grid_division(position)
    return r.BR_GetPrevGridDivision(position)
end

    
--- Item At Mouse Cursor. Wraps BR_ItemAtMouseCursor.
-- [BR] Get media item under mouse cursor. Position is mouse cursor position in
-- arrange.
-- @return position number
function BR:item_at_mouse_cursor()
    local ret_val, position = r.BR_ItemAtMouseCursor()
    if ret_val then
        return position
    else
        return nil
    end
end

    
--- Midi Cc Lane Remove. Wraps BR_MIDI_CCLaneRemove.
-- [BR] Remove CC lane in midi editor. Top visible CC lane is laneId 0. Returns
-- true on success
-- @param midi_editor identifier
-- @param lane_id number
-- @return boolean
function BR:midi_cc_lane_remove(midi_editor, lane_id)
    return r.BR_MIDI_CCLaneRemove(midi_editor, lane_id)
end

    
--- Midi Cc Lane Replace. Wraps BR_MIDI_CCLaneReplace.
-- [BR] Replace CC lane in midi editor. Top visible CC lane is laneId 0. Returns
-- true on success. Valid CC lanes: CC0-127=CC, 0x100|(0-31)=14-bit CC,
-- 0x200=velocity, 0x201=pitch, 0x202=program, 0x203=channel pressure,
-- 0x204=bank/program select, 0x205=text, 0x206=sysex, 0x207
-- @param midi_editor identifier
-- @param lane_id number
-- @param new_cc number
-- @return boolean
function BR:midi_cc_lane_replace(midi_editor, lane_id, new_cc)
    return r.BR_MIDI_CCLaneReplace(midi_editor, lane_id, new_cc)
end

    
--- Position At Mouse Cursor. Wraps BR_PositionAtMouseCursor.
-- [BR] Get position at mouse cursor. To check ruler along with arrange, pass
-- checkRuler=true. Returns -1 if cursor is not over arrange/ruler.
-- @param check_ruler boolean
-- @return number
function BR:position_at_mouse_cursor(check_ruler)
    return r.BR_PositionAtMouseCursor(check_ruler)
end

    
--- Take At Mouse Cursor. Wraps BR_TakeAtMouseCursor.
-- [BR] Get take under mouse cursor. Position is mouse cursor position in arrange.
-- @return position number
function BR:take_at_mouse_cursor()
    local ret_val, position = r.BR_TakeAtMouseCursor()
    if ret_val then
        return position
    else
        return nil
    end
end

    
--- Track At Mouse Cursor. Wraps BR_TrackAtMouseCursor.
-- [BR] Get track under mouse cursor. Context signifies where the track was found:
-- 0 = TCP, 1 = MCP, 2 = Arrange. Position will hold mouse cursor position in
-- arrange if applicable.
-- @return context number
-- @return position number
function BR:track_at_mouse_cursor()
    local ret_val, context, position = r.BR_TrackAtMouseCursor()
    if ret_val then
        return context, position
    else
        return nil
    end
end

    
--- Win32 Cb Find String. Wraps BR_Win32_CB_FindString.
-- [BR] Equivalent to win32 API ComboBox_FindString().
-- @param combo_box_hwnd identifier
-- @param start_id number
-- @param string string
-- @return number
function BR:win32_cb_find_string(combo_box_hwnd, start_id, string)
    return r.BR_Win32_CB_FindString(combo_box_hwnd, start_id, string)
end

    
--- Win32 Cb Find String Exact. Wraps BR_Win32_CB_FindStringExact.
-- [BR] Equivalent to win32 API ComboBox_FindStringExact().
-- @param combo_box_hwnd identifier
-- @param start_id number
-- @param string string
-- @return number
function BR:win32_cb_find_string_exact(combo_box_hwnd, start_id, string)
    return r.BR_Win32_CB_FindStringExact(combo_box_hwnd, start_id, string)
end

    
--- Win32 Client To Screen. Wraps BR_Win32_ClientToScreen.
-- [BR] Equivalent to win32 API ClientToScreen().
-- @param hwnd identifier
-- @param x_in number
-- @param y_in number
-- @return x number
-- @return y number
function BR:win32_client_to_screen(hwnd, x_in, y_in)
    return r.BR_Win32_ClientToScreen(hwnd, x_in, y_in)
end

    
--- Win32 Find Window Ex. Wraps BR_Win32_FindWindowEx.
-- [BR] Equivalent to win32 API FindWindowEx(). Since ReaScript doesn't allow
-- passing NULL (None in Python, nil in Lua etc...) parameters, to search by
-- supplied class or name set searchClass and searchName accordingly. HWND
-- parameters should be passed as either "0" to signify NULL or as string obtained
-- from BR_Win32_HwndToString.
-- @param hwnd_parent string
-- @param hwnd_child_after string
-- @param class_name string
-- @param window_name string
-- @param search_class boolean
-- @param search_name boolean
-- @return identifier
function BR:win32_find_window_ex(hwnd_parent, hwnd_child_after, class_name, window_name, search_class, search_name)
    return r.BR_Win32_FindWindowEx(hwnd_parent, hwnd_child_after, class_name, window_name, search_class, search_name)
end

    
--- Win32 Get X Lparam. Wraps BR_Win32_GET_X_LPARAM.
-- [BR] Equivalent to win32 API GET_X_LPARAM().
-- @param l_param number
-- @return number
function BR:win32_get_x_lparam(l_param)
    return r.BR_Win32_GET_X_LPARAM(l_param)
end

    
--- Win32 Get Y Lparam. Wraps BR_Win32_GET_Y_LPARAM.
-- [BR] Equivalent to win32 API GET_Y_LPARAM().
-- @param l_param number
-- @return number
function BR:win32_get_y_lparam(l_param)
    return r.BR_Win32_GET_Y_LPARAM(l_param)
end

    
--- Win32 Get Constant. Wraps BR_Win32_GetConstant.
-- [BR] Returns various constants needed for BR_Win32 functions. Supported
-- constants are: CB_ERR, CB_GETCOUNT, CB_GETCURSEL, CB_SETCURSEL EM_SETSEL
-- GW_CHILD, GW_HWNDFIRST, GW_HWNDLAST, GW_HWNDNEXT, GW_HWNDPREV, GW_OWNER
-- GWL_STYLE SW_HIDE, SW_MAXIMIZE, SW_SHOW, SW_SHOWMINIMIZED, SW_SHOWNA,
-- SW_SHOWNOACTIVATE, SW_SHOWNORMAL SWP_FRAMECHANGED, SWP_FRAMECHANGED, SWP_NOMOVE,
-- SWP_NOOWNERZORDER, SWP_NOSIZE, SWP_NOZORDER VK_DOWN, VK_UP WM_CLOSE, WM_KEYDOWN
-- WS_MAXIMIZE, WS_OVERLAPPEDWINDOW
-- @param constant_name string
-- @return number
function BR:win32_get_constant(constant_name)
    return r.BR_Win32_GetConstant(constant_name)
end

    
--- Win32 Get Cursor Pos. Wraps BR_Win32_GetCursorPos.
-- [BR] Equivalent to win32 API GetCursorPos().
-- @return x number
-- @return y number
function BR:win32_get_cursor_pos()
    local ret_val, x, y = r.BR_Win32_GetCursorPos()
    if ret_val then
        return x, y
    else
        return nil
    end
end

    
--- Win32 Get Focus. Wraps BR_Win32_GetFocus.
-- [BR] Equivalent to win32 API GetFocus().
-- @return identifier
function BR:win32_get_focus()
    return r.BR_Win32_GetFocus()
end

    
--- Win32 Get Foreground Window. Wraps BR_Win32_GetForegroundWindow.
-- [BR] Equivalent to win32 API GetForegroundWindow().
-- @return identifier
function BR:win32_get_foreground_window()
    return r.BR_Win32_GetForegroundWindow()
end

    
--- Win32 Get Main Hwnd. Wraps BR_Win32_GetMainHwnd.
-- [BR] Alternative to GetMainHwnd. REAPER seems to have problems with extensions
-- using HWND type for exported functions so all BR_Win32 functions use void*
-- instead of HWND type
-- @return identifier
function BR:win32_get_main_hwnd()
    return r.BR_Win32_GetMainHwnd()
end

    
--- Win32 Get Mixer Hwnd. Wraps BR_Win32_GetMixerHwnd.
-- [BR] Get mixer window HWND. isDockedOut will be set to true if mixer is docked
-- @return is_docked boolean
function BR:win32_get_mixer_hwnd()
    local ret_val, is_docked = r.BR_Win32_GetMixerHwnd()
    if ret_val then
        return is_docked
    else
        return nil
    end
end

    
--- Win32 Get Monitor Rect From Rect. Wraps BR_Win32_GetMonitorRectFromRect.
-- [BR] Get coordinates for screen which is nearest to supplied coordinates. Pass
-- workingAreaOnly as true to get screen coordinates excluding taskbar (or menu bar
-- on OSX).
-- @param working_area_only boolean
-- @param left_in number
-- @param top_in number
-- @param right_in number
-- @param bottom_in number
-- @return left number
-- @return top number
-- @return right number
-- @return bottom number
function BR:win32_get_monitor_rect_from_rect(working_area_only, left_in, top_in, right_in, bottom_in)
    return r.BR_Win32_GetMonitorRectFromRect(working_area_only, left_in, top_in, right_in, bottom_in)
end

    
--- Win32 Get Parent. Wraps BR_Win32_GetParent.
-- [BR] Equivalent to win32 API GetParent().
-- @param hwnd identifier
-- @return identifier
function BR:win32_get_parent(hwnd)
    return r.BR_Win32_GetParent(hwnd)
end

    
--- Win32 Get Private Profile String. Wraps BR_Win32_GetPrivateProfileString.
-- [BR] Equivalent to win32 API GetPrivateProfileString(). For example, you can use
-- this to get values from REAPER.ini.
-- @param section_name string
-- @param key_name string
-- @param default_string string
-- @param file_path string
-- @return string string
function BR:win32_get_private_profile_string(section_name, key_name, default_string, file_path)
    local ret_val, string = r.BR_Win32_GetPrivateProfileString(section_name, key_name, default_string, file_path)
    if ret_val then
        return string
    else
        return nil
    end
end

    
--- Win32 Get Window. Wraps BR_Win32_GetWindow.
-- [BR] Equivalent to win32 API GetWindow().
-- @param hwnd identifier
-- @param cmd number
-- @return identifier
function BR:win32_get_window(hwnd, cmd)
    return r.BR_Win32_GetWindow(hwnd, cmd)
end

    
--- Win32 Get Window Long. Wraps BR_Win32_GetWindowLong.
-- [BR] Equivalent to win32 API GetWindowLong().
-- @param hwnd identifier
-- @param index number
-- @return number
function BR:win32_get_window_long(hwnd, index)
    return r.BR_Win32_GetWindowLong(hwnd, index)
end

    
--- Win32 Get Window Rect. Wraps BR_Win32_GetWindowRect.
-- [BR] Equivalent to win32 API GetWindowRect().
-- @param hwnd identifier
-- @return left number
-- @return top number
-- @return right number
-- @return bottom number
function BR:win32_get_window_rect(hwnd)
    local ret_val, left, top, right, bottom = r.BR_Win32_GetWindowRect(hwnd)
    if ret_val then
        return left, top, right, bottom
    else
        return nil
    end
end

    
--- Win32 Get Window Text. Wraps BR_Win32_GetWindowText.
-- [BR] Equivalent to win32 API GetWindowText().
-- @param hwnd identifier
-- @return text string
function BR:win32_get_window_text(hwnd)
    local ret_val, text = r.BR_Win32_GetWindowText(hwnd)
    if ret_val then
        return text
    else
        return nil
    end
end

    
--- Win32 Hibyte. Wraps BR_Win32_HIBYTE.
-- [BR] Equivalent to win32 API HIBYTE().
-- @param value number
-- @return number
function BR:win32_hibyte(value)
    return r.BR_Win32_HIBYTE(value)
end

    
--- Win32 Hiword. Wraps BR_Win32_HIWORD.
-- [BR] Equivalent to win32 API HIWORD().
-- @param value number
-- @return number
function BR:win32_hiword(value)
    return r.BR_Win32_HIWORD(value)
end

    
--- Win32 Hwnd To String. Wraps BR_Win32_HwndToString.
-- [BR] Convert HWND to string. To convert string back to HWND, see
-- BR_Win32_StringToHwnd.
-- @param hwnd identifier
-- @return string string
function BR:win32_hwnd_to_string(hwnd)
    return r.BR_Win32_HwndToString(hwnd)
end

    
--- Win32 Is Window. Wraps BR_Win32_IsWindow.
-- [BR] Equivalent to win32 API IsWindow().
-- @param hwnd identifier
-- @return boolean
function BR:win32_is_window(hwnd)
    return r.BR_Win32_IsWindow(hwnd)
end

    
--- Win32 Is Window Visible. Wraps BR_Win32_IsWindowVisible.
-- [BR] Equivalent to win32 API IsWindowVisible().
-- @param hwnd identifier
-- @return boolean
function BR:win32_is_window_visible(hwnd)
    return r.BR_Win32_IsWindowVisible(hwnd)
end

    
--- Win32 Lobyte. Wraps BR_Win32_LOBYTE.
-- [BR] Equivalent to win32 API LOBYTE().
-- @param value number
-- @return number
function BR:win32_lobyte(value)
    return r.BR_Win32_LOBYTE(value)
end

    
--- Win32 Loword. Wraps BR_Win32_LOWORD.
-- [BR] Equivalent to win32 API LOWORD().
-- @param value number
-- @return number
function BR:win32_loword(value)
    return r.BR_Win32_LOWORD(value)
end

    
--- Win32 Makelong. Wraps BR_Win32_MAKELONG.
-- [BR] Equivalent to win32 API MAKELONG().
-- @param low number
-- @param high number
-- @return number
function BR:win32_makelong(low, high)
    return r.BR_Win32_MAKELONG(low, high)
end

    
--- Win32 Makelparam. Wraps BR_Win32_MAKELPARAM.
-- [BR] Equivalent to win32 API MAKELPARAM().
-- @param low number
-- @param high number
-- @return number
function BR:win32_makelparam(low, high)
    return r.BR_Win32_MAKELPARAM(low, high)
end

    
--- Win32 Makelresult. Wraps BR_Win32_MAKELRESULT.
-- [BR] Equivalent to win32 API MAKELRESULT().
-- @param low number
-- @param high number
-- @return number
function BR:win32_makelresult(low, high)
    return r.BR_Win32_MAKELRESULT(low, high)
end

    
--- Win32 Makeword. Wraps BR_Win32_MAKEWORD.
-- [BR] Equivalent to win32 API MAKEWORD().
-- @param low number
-- @param high number
-- @return number
function BR:win32_makeword(low, high)
    return r.BR_Win32_MAKEWORD(low, high)
end

    
--- Win32 Makewparam. Wraps BR_Win32_MAKEWPARAM.
-- [BR] Equivalent to win32 API MAKEWPARAM().
-- @param low number
-- @param high number
-- @return number
function BR:win32_makewparam(low, high)
    return r.BR_Win32_MAKEWPARAM(low, high)
end

    
--- Win32 Midi Editor Get Active. Wraps BR_Win32_MIDIEditor_GetActive.
-- [BR] Alternative to MIDIEditor_GetActive. REAPER seems to have problems with
-- extensions using HWND type for exported functions so all BR_Win32 functions use
-- void* instead of HWND type.
-- @return identifier
function BR:win32_midi_editor_get_active()
    return r.BR_Win32_MIDIEditor_GetActive()
end

    
--- Win32 Screen To Client. Wraps BR_Win32_ScreenToClient.
-- [BR] Equivalent to win32 API ClientToScreen().
-- @param hwnd identifier
-- @param x_in number
-- @param y_in number
-- @return x number
-- @return y number
function BR:win32_screen_to_client(hwnd, x_in, y_in)
    return r.BR_Win32_ScreenToClient(hwnd, x_in, y_in)
end

    
--- Win32 Send Message. Wraps BR_Win32_SendMessage.
-- [BR] Equivalent to win32 API SendMessage().
-- @param hwnd identifier
-- @param msg number
-- @param l_param number
-- @param w_param number
-- @return number
function BR:win32_send_message(hwnd, msg, l_param, w_param)
    return r.BR_Win32_SendMessage(hwnd, msg, l_param, w_param)
end

    
--- Win32 Set Focus. Wraps BR_Win32_SetFocus.
-- [BR] Equivalent to win32 API SetFocus().
-- @param hwnd identifier
-- @return identifier
function BR:win32_set_focus(hwnd)
    return r.BR_Win32_SetFocus(hwnd)
end

    
--- Win32 Set Foreground Window. Wraps BR_Win32_SetForegroundWindow.
-- [BR] Equivalent to win32 API SetForegroundWindow().
-- @param hwnd identifier
-- @return number
function BR:win32_set_foreground_window(hwnd)
    return r.BR_Win32_SetForegroundWindow(hwnd)
end

    
--- Win32 Set Window Long. Wraps BR_Win32_SetWindowLong.
-- [BR] Equivalent to win32 API SetWindowLong().
-- @param hwnd identifier
-- @param index number
-- @param new_long number
-- @return number
function BR:win32_set_window_long(hwnd, index, new_long)
    return r.BR_Win32_SetWindowLong(hwnd, index, new_long)
end

    
--- Win32 Set Window Pos. Wraps BR_Win32_SetWindowPos.
-- [BR] Equivalent to win32 API SetWindowPos(). hwndInsertAfter may be a string:
-- "HWND_BOTTOM", "HWND_NOTOPMOST", "HWND_TOP", "HWND_TOPMOST" or a string obtained
-- with BR_Win32_HwndToString.
-- @param hwnd identifier
-- @param hwnd_insert_after string
-- @param x number
-- @param y number
-- @param width number
-- @param height number
-- @param flags number
-- @return boolean
function BR:win32_set_window_pos(hwnd, hwnd_insert_after, x, y, width, height, flags)
    return r.BR_Win32_SetWindowPos(hwnd, hwnd_insert_after, x, y, width, height, flags)
end

    
--- Win32 Shell Execute. Wraps BR_Win32_ShellExecute.
-- [BR] Equivalent to win32 API ShellExecute() with HWND set to main window
-- @param operation string
-- @param file string
-- @param parameters string
-- @param directory string
-- @param show_flags number
-- @return number
function BR:win32_shell_execute(operation, file, parameters, directory, show_flags)
    return r.BR_Win32_ShellExecute(operation, file, parameters, directory, show_flags)
end

    
--- Win32 Show Window. Wraps BR_Win32_ShowWindow.
-- [BR] Equivalent to win32 API ShowWindow().
-- @param hwnd identifier
-- @param cmd_show number
-- @return boolean
function BR:win32_show_window(hwnd, cmd_show)
    return r.BR_Win32_ShowWindow(hwnd, cmd_show)
end

    
--- Win32 String To Hwnd. Wraps BR_Win32_StringToHwnd.
-- [BR] Convert string to HWND. To convert HWND back to string, see
-- BR_Win32_HwndToString.
-- @param string string
-- @return identifier
function BR:win32_string_to_hwnd(string)
    return r.BR_Win32_StringToHwnd(string)
end

    
--- Win32 Window From Point. Wraps BR_Win32_WindowFromPoint.
-- [BR] Equivalent to win32 API WindowFromPoint().
-- @param x number
-- @param y number
-- @return identifier
function BR:win32_window_from_point(x, y)
    return r.BR_Win32_WindowFromPoint(x, y)
end

    
--- Win32 Write Private Profile String. Wraps BR_Win32_WritePrivateProfileString.
-- [BR] Equivalent to win32 API WritePrivateProfileString(). For example, you can
-- use this to write to REAPER.ini. You can pass an empty string as value to delete
-- a key.
-- @param section_name string
-- @param key_name string
-- @param value string
-- @param file_path string
-- @return boolean
function BR:win32_write_private_profile_string(section_name, key_name, value, file_path)
    return r.BR_Win32_WritePrivateProfileString(section_name, key_name, value, file_path)
end

return BR
