-- [BR] Count envelope points in the envelope object allocated with BR_EnvAlloc.
-- @envelope BR_Envelope
-- @return integer 
function BR:env_count_points(envelope)
    return r.BR_EnvCountPoints(envelope)
end

-- [BR] Delete envelope point by index (zero-based) in the envelope object allocated with BR_EnvAlloc. Returns true on success.
-- @envelope BR_Envelope
-- @id integer
-- @return boolean 
function BR:env_delete_point(envelope, id)
    return r.BR_EnvDeletePoint(envelope, id)
end

-- [BR] Find envelope point at time position in the envelope object allocated with BR_EnvAlloc. Pass delta > 0 to search surrounding range - in that case the closest point to position within delta will be searched for. Returns envelope point id (zero-based) on success or -1 on failure.
-- @envelope BR_Envelope
-- @position number
-- @delta number
-- @return integer 
function BR:env_find(envelope, position, delta)
    return r.BR_EnvFind(envelope, position, delta)
end

-- [BR] Find next envelope point after time position in the envelope object allocated with BR_EnvAlloc. Returns envelope point id (zero-based) on success or -1 on failure.
-- @envelope BR_Envelope
-- @position number
-- @return integer 
function BR:env_find_next(envelope, position)
    return r.BR_EnvFindNext(envelope, position)
end

-- [BR] Find previous envelope point before time position in the envelope object allocated with BR_EnvAlloc. Returns envelope point id (zero-based) on success or -1 on failure.
-- @envelope BR_Envelope
-- @position number
-- @return integer 
function BR:env_find_previous(envelope, position)
    return r.BR_EnvFindPrevious(envelope, position)
end

-- [BR] Free envelope object allocated with BR_EnvAlloc and commit changes if needed. Returns true if changes were committed successfully. Note that when envelope object wasn't modified nothing will get committed even if commit = true - in that case function returns false.
-- @envelope BR_Envelope
-- @commit boolean
-- @return boolean 
function BR:env_free(envelope, commit)
    return r.BR_EnvFree(envelope, commit)
end

-- [BR] If envelope object allocated with BR_EnvAlloc is take envelope, returns parent media item take, otherwise NULL.
-- @envelope BR_Envelope
-- @return MediaItem_Take 
function BR:env_get_parent_take(envelope)
    return r.BR_EnvGetParentTake(envelope)
end

-- [BR] Get parent track of envelope object allocated with BR_EnvAlloc. If take envelope, returns NULL.
-- @envelope BR_Envelope
-- @return MediaTrack 
function BR:env_get_parent_track(envelope)
    return r.BR_EnvGetParentTrack(envelope)
end

-- [BR] Get envelope point by id (zero-based) from the envelope object allocated with BR_EnvAlloc. Returns true on success.
-- @envelope BR_Envelope
-- @id integer
-- @return number, number, number, boolean, number 
function BR:env_get_point(envelope, id)
    local retval, position, value, shape, selected, bezier = r.BR_EnvGetPoint(envelope, id)
    if retval then
        return position, value, shape, selected, bezier
    end
end

-- automationItemsOptions: -1->project default, &1=0->don't attach to underl. env., &1->attach to underl. env. on right side,  &2->attach to underl. env. on both sides, &4: bypass underl. env.
-- @envelope BR_Envelope
-- @return boolean, boolean, boolean, boolean, number, number, number, number, number, number, boolean, number 
function BR:env_get_properties(envelope)
    return r.BR_EnvGetProperties(envelope)
end

-- Returns true on success.
-- @envelope BR_Envelope
-- @id integer
-- @position number
-- @value number
-- @shape integer
-- @selected boolean
-- @bezier number
-- @return boolean 
function BR:env_set_point(envelope, id, position, value, shape, selected, bezier)
    return r.BR_EnvSetPoint(envelope, id, position, value, shape, selected, bezier)
end

-- Setting automationItemsOptions requires REAPER 5.979+.
-- @envelope BR_Envelope
-- @active boolean
-- @visible boolean
-- @armed boolean
-- @in_lane boolean
-- @lane_height integer
-- @default_shape integer
-- @fader_scaling boolean
-- @automation_items_options_in number
function BR:env_set_properties(envelope, active, visible, armed, in_lane, lane_height, default_shape, fader_scaling, automation_items_options_in)
    return r.BR_EnvSetProperties(envelope, active, visible, armed, in_lane, lane_height, default_shape, fader_scaling, automation_items_options_in)
end

-- [BR] Sort envelope points by position. The only reason to call this is if sorted points are explicitly needed after editing them with BR_EnvSetPoint. Note that you do not have to call this before doing BR_EnvFree since it does handle unsorted points too.
-- @envelope BR_Envelope
function BR:env_sort_points(envelope)
    return r.BR_EnvSortPoints(envelope)
end

-- [BR] Get envelope value at time position for the envelope object allocated with BR_EnvAlloc.
-- @envelope BR_Envelope
-- @position number
-- @return number 
function BR:env_value_at_pos(envelope, position)
    return r.BR_EnvValueAtPos(envelope, position)
end

-- [BR] Get closest grid division to position. Note that this functions is different from SnapToGrid in two regards. SnapToGrid() needs snap enabled to work and this one works always. Secondly, grid divisions are different from grid lines because some grid lines may be hidden due to zoom level - this function ignores grid line visibility and always searches for the closest grid division at given position. For more grid division functions, see BR_GetNextGridDivision and BR_GetPrevGridDivision.
-- @position number
-- @return number 
function BR:get_closest_grid_division(position)
    return r.BR_GetClosestGridDivision(position)
end

-- [BR] Get current theme information. themePathOut is set to full theme path and themeNameOut is set to theme name excluding any path info and extension
-- @return string, string 
function BR:get_current_theme()
    return r.BR_GetCurrentTheme()
end

-- @return string, string, string 
function BR:get_mouse_cursor_context()
    return r.BR_GetMouseCursorContext()
end

-- [BR] Returns envelope that was captured with the last call to BR_GetMouseCursorContext. In case the envelope belongs to take, takeEnvelope will be true.
-- @return boolean 
function BR:get_mouse_cursor_context__envelope()
    local retval, take_envelope = r.BR_GetMouseCursorContext_Envelope()
    if retval then
        return take_envelope
    end
end

-- [BR] Returns item under mouse cursor that was captured with the last call to BR_GetMouseCursorContext. Note that the function will return item even if mouse cursor is over some other track lane element like stretch marker or envelope. This enables for easier identification of items when you want to ignore elements within the item.
-- @return MediaItem 
function BR:get_mouse_cursor_context__item()
    return r.BR_GetMouseCursorContext_Item()
end

-- Note: due to API limitations, if mouse is over inline MIDI editor with some note rows hidden, noteRow will be -1
-- @return boolean, number, number, number, number 
function BR:get_mouse_cursor_context__m_i_d_i()
    local retval, inline_editor, note_row, cc_lane, cc_lane_val, cc_lane_id = r.BR_GetMouseCursorContext_MIDI()
    if retval then
        return inline_editor, note_row, cc_lane, cc_lane_val, cc_lane_id
    end
end

-- [BR] Returns project time position in arrange/ruler/midi editor that was captured with the last call to BR_GetMouseCursorContext.
-- @return number 
function BR:get_mouse_cursor_context__position()
    return r.BR_GetMouseCursorContext_Position()
end

-- [BR] Returns id of a stretch marker under mouse cursor that was captured with the last call to BR_GetMouseCursorContext.
-- @return integer 
function BR:get_mouse_cursor_context__stretch_marker()
    return r.BR_GetMouseCursorContext_StretchMarker()
end

-- [BR] Returns take under mouse cursor that was captured with the last call to BR_GetMouseCursorContext.
-- @return MediaItem_Take 
function BR:get_mouse_cursor_context__take()
    return r.BR_GetMouseCursorContext_Take()
end

-- [BR] Returns track under mouse cursor that was captured with the last call to BR_GetMouseCursorContext.
-- @return MediaTrack 
function BR:get_mouse_cursor_context__track()
    return r.BR_GetMouseCursorContext_Track()
end

-- [BR] Get next grid division after the time position. For more grid divisions function, see BR_GetClosestGridDivision and BR_GetPrevGridDivision.
-- @position number
-- @return number 
function BR:get_next_grid_division(position)
    return r.BR_GetNextGridDivision(position)
end

-- [BR] Get previous grid division before the time position. For more grid division functions, see BR_GetClosestGridDivision and BR_GetNextGridDivision.
-- @position number
-- @return number 
function BR:get_prev_grid_division(position)
    return r.BR_GetPrevGridDivision(position)
end

-- [BR] Get media item under mouse cursor. Position is mouse cursor position in arrange.
-- @return number 
function BR:item_at_mouse_cursor()
    local retval, position = r.BR_ItemAtMouseCursor()
    if retval then
        return position
    end
end

-- [BR] Remove CC lane in midi editor. Top visible CC lane is laneId 0. Returns true on success
-- @midi_editor identifier
-- @lane_id integer
-- @return boolean 
function BR:m_i_d_i__c_c_lane_remove(midi_editor, lane_id)
    return r.BR_MIDI_CCLaneRemove(midi_editor, lane_id)
end

-- Valid CC lanes: CC0-127=CC, 0x100|(0-31)=14-bit CC, 0x200=velocity, 0x201=pitch, 0x202=program, 0x203=channel pressure, 0x204=bank/program select, 0x205=text, 0x206=sysex, 0x207
-- @midi_editor identifier
-- @lane_id integer
-- @new_c_c integer
-- @return boolean 
function BR:m_i_d_i__c_c_lane_replace(midi_editor, lane_id, new_c_c)
    return r.BR_MIDI_CCLaneReplace(midi_editor, lane_id, new_c_c)
end

-- [BR] Get position at mouse cursor. To check ruler along with arrange, pass checkRuler=true. Returns -1 if cursor is not over arrange/ruler.
-- @check_ruler boolean
-- @return number 
function BR:position_at_mouse_cursor(check_ruler)
    return r.BR_PositionAtMouseCursor(check_ruler)
end

-- [BR] Get take under mouse cursor. Position is mouse cursor position in arrange.
-- @return number 
function BR:take_at_mouse_cursor()
    local retval, position = r.BR_TakeAtMouseCursor()
    if retval then
        return position
    end
end

-- Position will hold mouse cursor position in arrange if applicable.
-- @return number, number 
function BR:track_at_mouse_cursor()
    local retval, context, position = r.BR_TrackAtMouseCursor()
    if retval then
        return context, position
    end
end

-- [BR] Equivalent to win32 API ComboBox_FindString().
-- @combo_box_hwnd identifier
-- @start_id integer
-- @string string
-- @return integer 
function BR:win32__c_b__find_string(combo_box_hwnd, start_id, string)
    return r.BR_Win32_CB_FindString(combo_box_hwnd, start_id, string)
end

-- [BR] Equivalent to win32 API ComboBox_FindStringExact().
-- @combo_box_hwnd identifier
-- @start_id integer
-- @string string
-- @return integer 
function BR:win32__c_b__find_string_exact(combo_box_hwnd, start_id, string)
    return r.BR_Win32_CB_FindStringExact(combo_box_hwnd, start_id, string)
end

-- [BR] Equivalent to win32 API ClientToScreen().
-- @hwnd identifier
-- @x_in integer
-- @y_in integer
-- @return number, number 
function BR:win32__client_to_screen(hwnd, x_in, y_in)
    return r.BR_Win32_ClientToScreen(hwnd, x_in, y_in)
end

-- [BR] Equivalent to win32 API FindWindowEx(). Since ReaScript doesn't allow passing NULL (None in Python, nil in Lua etc...) parameters, to search by supplied class or name set searchClass and searchName accordingly. HWND parameters should be passed as either "0" to signify NULL or as string obtained from BR_Win32_HwndToString.
-- @hwnd_parent string
-- @hwnd_child_after string
-- @class_name string
-- @window_name string
-- @search_class boolean
-- @search_name boolean
-- @return identifier 
function BR:win32__find_window_ex(hwnd_parent, hwnd_child_after, class_name, window_name, search_class, search_name)
    return r.BR_Win32_FindWindowEx(hwnd_parent, hwnd_child_after, class_name, window_name, search_class, search_name)
end

-- [BR] Equivalent to win32 API GET_X_LPARAM().
-- @l_param integer
-- @return integer 
function BR:win32__g_e_t__x__l_p_a_r_a_m(l_param)
    return r.BR_Win32_GET_X_LPARAM(l_param)
end

-- [BR] Equivalent to win32 API GET_Y_LPARAM().
-- @l_param integer
-- @return integer 
function BR:win32__g_e_t__y__l_p_a_r_a_m(l_param)
    return r.BR_Win32_GET_Y_LPARAM(l_param)
end

-- WS_MAXIMIZE, WS_OVERLAPPEDWINDOW
-- @constant_name string
-- @return integer 
function BR:win32__get_constant(constant_name)
    return r.BR_Win32_GetConstant(constant_name)
end

-- [BR] Equivalent to win32 API GetCursorPos().
-- @return number, number 
function BR:win32__get_cursor_pos()
    local retval, x, y = r.BR_Win32_GetCursorPos()
    if retval then
        return x, y
    end
end

-- [BR] Equivalent to win32 API GetFocus().
-- @return identifier 
function BR:win32__get_focus()
    return r.BR_Win32_GetFocus()
end

-- [BR] Equivalent to win32 API GetForegroundWindow().
-- @return identifier 
function BR:win32__get_foreground_window()
    return r.BR_Win32_GetForegroundWindow()
end

-- [BR] Alternative to GetMainHwnd. REAPER seems to have problems with extensions using HWND type for exported functions so all BR_Win32 functions use void* instead of HWND type
-- @return identifier 
function BR:win32__get_main_hwnd()
    return r.BR_Win32_GetMainHwnd()
end

-- [BR] Get mixer window HWND. isDockedOut will be set to true if mixer is docked
-- @return boolean 
function BR:win32__get_mixer_hwnd()
    local retval, is_docked = r.BR_Win32_GetMixerHwnd()
    if retval then
        return is_docked
    end
end

-- [BR] Get coordinates for screen which is nearest to supplied coordinates. Pass workingAreaOnly as true to get screen coordinates excluding taskbar (or menu bar on OSX).
-- @working_area_only boolean
-- @left_in integer
-- @top_in integer
-- @right_in integer
-- @bottom_in integer
-- @return number, number, number, number 
function BR:win32__get_monitor_rect_from_rect(working_area_only, left_in, top_in, right_in, bottom_in)
    return r.BR_Win32_GetMonitorRectFromRect(working_area_only, left_in, top_in, right_in, bottom_in)
end

-- [BR] Equivalent to win32 API GetParent().
-- @hwnd identifier
-- @return identifier 
function BR:win32__get_parent(hwnd)
    return r.BR_Win32_GetParent(hwnd)
end

-- [BR] Equivalent to win32 API GetPrivateProfileString(). For example, you can use this to get values from REAPER.ini
-- @section_name string
-- @key_name string
-- @default_string string
-- @file_path string
-- @return string 
function BR:win32__get_private_profile_string(section_name, key_name, default_string, file_path)
    local retval, string = r.BR_Win32_GetPrivateProfileString(section_name, key_name, default_string, file_path)
    if retval then
        return string
    end
end

-- [BR] Equivalent to win32 API GetWindow().
-- @hwnd identifier
-- @cmd integer
-- @return identifier 
function BR:win32__get_window(hwnd, cmd)
    return r.BR_Win32_GetWindow(hwnd, cmd)
end

-- [BR] Equivalent to win32 API GetWindowLong().
-- @hwnd identifier
-- @index integer
-- @return integer 
function BR:win32__get_window_long(hwnd, index)
    return r.BR_Win32_GetWindowLong(hwnd, index)
end

-- [BR] Equivalent to win32 API GetWindowRect().
-- @hwnd identifier
-- @return number, number, number, number 
function BR:win32__get_window_rect(hwnd)
    local retval, left, top, right, bottom = r.BR_Win32_GetWindowRect(hwnd)
    if retval then
        return left, top, right, bottom
    end
end

-- [BR] Equivalent to win32 API GetWindowText().
-- @hwnd identifier
-- @return string 
function BR:win32__get_window_text(hwnd)
    local retval, text = r.BR_Win32_GetWindowText(hwnd)
    if retval then
        return text
    end
end

-- [BR] Equivalent to win32 API HIBYTE().
-- @value integer
-- @return integer 
function BR:win32__h_i_b_y_t_e(value)
    return r.BR_Win32_HIBYTE(value)
end

-- [BR] Equivalent to win32 API HIWORD().
-- @value integer
-- @return integer 
function BR:win32__h_i_w_o_r_d(value)
    return r.BR_Win32_HIWORD(value)
end

-- [BR] Convert HWND to string. To convert string back to HWND, see BR_Win32_StringToHwnd.
-- @hwnd identifier
-- @return string 
function BR:win32__hwnd_to_string(hwnd)
    return r.BR_Win32_HwndToString(hwnd)
end

-- [BR] Equivalent to win32 API IsWindow().
-- @hwnd identifier
-- @return boolean 
function BR:win32__is_window(hwnd)
    return r.BR_Win32_IsWindow(hwnd)
end

-- [BR] Equivalent to win32 API IsWindowVisible().
-- @hwnd identifier
-- @return boolean 
function BR:win32__is_window_visible(hwnd)
    return r.BR_Win32_IsWindowVisible(hwnd)
end

-- [BR] Equivalent to win32 API LOBYTE().
-- @value integer
-- @return integer 
function BR:win32__l_o_b_y_t_e(value)
    return r.BR_Win32_LOBYTE(value)
end

-- [BR] Equivalent to win32 API LOWORD().
-- @value integer
-- @return integer 
function BR:win32__l_o_w_o_r_d(value)
    return r.BR_Win32_LOWORD(value)
end

-- [BR] Equivalent to win32 API MAKELONG().
-- @low integer
-- @high integer
-- @return integer 
function BR:win32__m_a_k_e_l_o_n_g(low, high)
    return r.BR_Win32_MAKELONG(low, high)
end

-- [BR] Equivalent to win32 API MAKELPARAM().
-- @low integer
-- @high integer
-- @return integer 
function BR:win32__m_a_k_e_l_p_a_r_a_m(low, high)
    return r.BR_Win32_MAKELPARAM(low, high)
end

-- [BR] Equivalent to win32 API MAKELRESULT().
-- @low integer
-- @high integer
-- @return integer 
function BR:win32__m_a_k_e_l_r_e_s_u_l_t(low, high)
    return r.BR_Win32_MAKELRESULT(low, high)
end

-- [BR] Equivalent to win32 API MAKEWORD().
-- @low integer
-- @high integer
-- @return integer 
function BR:win32__m_a_k_e_w_o_r_d(low, high)
    return r.BR_Win32_MAKEWORD(low, high)
end

-- [BR] Equivalent to win32 API MAKEWPARAM().
-- @low integer
-- @high integer
-- @return integer 
function BR:win32__m_a_k_e_w_p_a_r_a_m(low, high)
    return r.BR_Win32_MAKEWPARAM(low, high)
end

-- [BR] Alternative to MIDIEditor_GetActive. REAPER seems to have problems with extensions using HWND type for exported functions so all BR_Win32 functions use void* instead of HWND type.
-- @return identifier 
function BR:win32__m_i_d_i_editor__get_active()
    return r.BR_Win32_MIDIEditor_GetActive()
end

-- [BR] Equivalent to win32 API ClientToScreen().
-- @hwnd identifier
-- @x_in integer
-- @y_in integer
-- @return number, number 
function BR:win32__screen_to_client(hwnd, x_in, y_in)
    return r.BR_Win32_ScreenToClient(hwnd, x_in, y_in)
end

-- [BR] Equivalent to win32 API SendMessage().
-- @hwnd identifier
-- @msg integer
-- @l_param integer
-- @w_param integer
-- @return integer 
function BR:win32__send_message(hwnd, msg, l_param, w_param)
    return r.BR_Win32_SendMessage(hwnd, msg, l_param, w_param)
end

-- [BR] Equivalent to win32 API SetFocus().
-- @hwnd identifier
-- @return identifier 
function BR:win32__set_focus(hwnd)
    return r.BR_Win32_SetFocus(hwnd)
end

-- [BR] Equivalent to win32 API SetForegroundWindow().
-- @hwnd identifier
-- @return integer 
function BR:win32__set_foreground_window(hwnd)
    return r.BR_Win32_SetForegroundWindow(hwnd)
end

-- [BR] Equivalent to win32 API SetWindowLong().
-- @hwnd identifier
-- @index integer
-- @new_long integer
-- @return integer 
function BR:win32__set_window_long(hwnd, index, new_long)
    return r.BR_Win32_SetWindowLong(hwnd, index, new_long)
end

-- hwndInsertAfter may be a string: "HWND_BOTTOM", "HWND_NOTOPMOST", "HWND_TOP", "HWND_TOPMOST" or a string obtained with BR_Win32_HwndToString.
-- @hwnd identifier
-- @hwnd_insert_after string
-- @x integer
-- @y integer
-- @width integer
-- @height integer
-- @flags integer
-- @return boolean 
function BR:win32__set_window_pos(hwnd, hwnd_insert_after, x, y, width, height, flags)
    return r.BR_Win32_SetWindowPos(hwnd, hwnd_insert_after, x, y, width, height, flags)
end

-- [BR] Equivalent to win32 API ShellExecute() with HWND set to main window
-- @operation string
-- @file string
-- @parameters string
-- @directory string
-- @show_flags integer
-- @return integer 
function BR:win32__shell_execute(operation, file, parameters, directory, show_flags)
    return r.BR_Win32_ShellExecute(operation, file, parameters, directory, show_flags)
end

-- [BR] Equivalent to win32 API ShowWindow().
-- @hwnd identifier
-- @cmd_show integer
-- @return boolean 
function BR:win32__show_window(hwnd, cmd_show)
    return r.BR_Win32_ShowWindow(hwnd, cmd_show)
end

-- [BR] Convert string to HWND. To convert HWND back to string, see BR_Win32_HwndToString.
-- @string string
-- @return identifier 
function BR:win32__string_to_hwnd(string)
    return r.BR_Win32_StringToHwnd(string)
end

-- [BR] Equivalent to win32 API WindowFromPoint().
-- @x integer
-- @y integer
-- @return identifier 
function BR:win32__window_from_point(x, y)
    return r.BR_Win32_WindowFromPoint(x, y)
end

-- [BR] Equivalent to win32 API WritePrivateProfileString(). For example, you can use this to write to REAPER.ini
-- @section_name string
-- @key_name string
-- @value string
-- @file_path string
-- @return boolean 
function BR:win32__write_private_profile_string(section_name, key_name, value, file_path)
    return r.BR_Win32_WritePrivateProfileString(section_name, key_name, value, file_path)
end

