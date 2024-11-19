-- add two numbers
-- @n1 number
-- @n2 number
-- @return integer 
function MRP:cast_double_to_int(n1, n2)
    return r.MRP_CastDoubleToInt(n1, n2)
end

-- Create an array of 64 bit floating point numbers. Note that these will leak memory if they are not later destroyed with MRP_DestroyArray!
-- @size integer
-- @return MRP_Array 
function MRP:create_array(size)
    return r.MRP_CreateArray(size)
end

-- Create window
-- @title string
-- @return MRP_Window 
function MRP:create_window(title)
    return r.MRP_CreateWindow(title)
end

-- Destroy a previously created MRP_Array
-- @array MRP_Array
function MRP:destroy_array(array)
    return r.MRP_DestroyArray(array)
end

-- Destroy window
-- @window MRP_Window
function MRP:destroy_window(window)
    return r.MRP_DestroyWindow(window)
end

-- do nothing, return null
function MRP:do_nothing()
    return r.MRP_DoNothing()
end

-- add two numbers
-- @n1 number
-- @n2 number
-- @return number 
function MRP:double_pointer(n1, n2)
    return r.MRP_DoublePointer(n1, n2)
end

-- add two numbers
-- @n1 number
-- @n2 number
-- @return integer 
function MRP:double_pointer_as_int(n1, n2)
    return r.MRP_DoublePointerAsInt(n1, n2)
end

-- Generate a sine wave into a MRP_Array
-- @array MRP_Array
-- @samplerate number
-- @frequency number
function MRP:generate_sine(array, samplerate, frequency)
    return r.MRP_GenerateSine(array, samplerate, frequency)
end

-- Get MRP_Array element value. No safety checks done for array or index validity, so use at your own peril!
-- @array MRP_Array
-- @index integer
-- @return number 
function MRP:get_array_value(array, index)
    return r.MRP_GetArrayValue(array, index)
end

-- Get a floating point number associated with control. Meaning of 'which' depends on the control targeted.
-- @window MRP_Window
-- @controlname string
-- @which integer
-- @return number 
function MRP:get_control_float_number(window, controlname, which)
    return r.MRP_GetControlFloatNumber(window, controlname, which)
end

-- Get an integer point number associated with control. Meaning of 'which' depends on the control targeted.
-- @window MRP_Window
-- @controlname string
-- @which integer
-- @return integer 
function MRP:get_control_int_number(window, controlname, which)
    return r.MRP_GetControlIntNumber(window, controlname, which)
end

-- Get window dirty state (ie, if something was changed in the window). which : 0 window size
-- @window MRP_Window
-- @whichdirty integer
-- @return boolean 
function MRP:get_window_dirty(window, whichdirty)
    return r.MRP_GetWindowDirty(window, whichdirty)
end

-- Get window geometry values. which : 0 x, 1 y, 2 w, 3 h
-- @window MRP_Window
-- @which integer
-- @return integer 
function MRP:get_window_pos_size_value(window, which)
    return r.MRP_GetWindowPosSizeValue(window, which)
end

-- add two numbers
-- @n1 integer
-- @n2 integer
-- @return integer 
function MRP:int_pointer(n1, n2)
    return r.MRP_IntPointer(n1, n2)
end

-- Multiply 2 MRP_Arrays of same length. Result is written to 3rd array.
-- @array_1 MRP_Array
-- @array_2 MRP_Array
-- @array_3 MRP_Array
-- @retval ReaType
function MRP:multiply_arrays(array_1, array_2, array_3, retval)
    return r.MRP_MultiplyArrays(array_1, array_2, array_3, retval)
end

-- Multiply 2 MRP_Arrays of same length. Result is written to 3rd array. Uses multiple threads.
-- @array_1 MRP_Array
-- @array_2 MRP_Array
-- @array_3 MRP_Array
-- @retval ReaType
function MRP:multiply_arrays_m_t(array_1, array_2, array_3, retval)
    return r.MRP_MultiplyArraysMT(array_1, array_2, array_3, retval)
end

-- return media item
-- @return MediaItem 
function MRP:return_media_item()
    return r.MRP_ReturnMediaItem()
end

-- Send a command message to control. Currently only the envelope control understands some messages.
-- @window MRP_Window
-- @controlname string
-- @commandtext string
function MRP:send_command_string(window, controlname, commandtext)
    return r.MRP_SendCommandString(window, controlname, commandtext)
end

-- Set MRP_Array element value. No safety checks done for array or index validity, so use at your own peril!
-- @array MRP_Array
-- @index integer
-- @value number
function MRP:set_array_value(array, index, value)
    return r.MRP_SetArrayValue(array, index, value)
end

-- Set MRP control position and size
-- @window MRP_Window
-- @name string
-- @x number
-- @y number
-- @w number
-- @h number
function MRP:set_control_bounds(window, name, x, y, w, h)
    return r.MRP_SetControlBounds(window, name, x, y, w, h)
end

-- Set a floating point number associated with control. Meaning of 'which' depends on the control targeted.
-- @window MRP_Window
-- @controlname string
-- @which integer
-- @value number
function MRP:set_control_float_number(window, controlname, which, value)
    return r.MRP_SetControlFloatNumber(window, controlname, which, value)
end

-- Set an integer point number associated with control. Meaning of 'which' depends on the control targeted.
-- @window MRP_Window
-- @controlname string
-- @which integer
-- @value integer
function MRP:set_control_int_number(window, controlname, which, value)
    return r.MRP_SetControlIntNumber(window, controlname, which, value)
end

-- Set a text property associated with control. Meaning of 'which' depends on the control targeted.
-- @window MRP_Window
-- @controlname string
-- @which integer
-- @text string
function MRP:set_control_string(window, controlname, which, text)
    return r.MRP_SetControlString(window, controlname, which, text)
end

-- Set window dirty state (ie, if something was changed in the controls)
-- @window MRP_Window
-- @which integer
-- @state boolean
function MRP:set_window_dirty(window, which, state)
    return r.MRP_SetWindowDirty(window, which, state)
end

-- Add a control to window. Controltypename is the type of control to create. Objectname must be a unique id
-- @window MRP_Window
-- @controltypename string
-- @objectname string
function MRP:window_add_control(window, controltypename, objectname)
    return r.MRP_WindowAddControl(window, controltypename, objectname)
end

-- Clears the dirty states of the controls in a window.
-- @window MRP_Window
function MRP:window_clear_dirty_controls(window)
    return r.MRP_WindowClearDirtyControls(window)
end

-- Returns if the window has been closed and the ReaScript defer loop should likely be exited
-- @window MRP_Window
-- @return boolean 
function MRP:window_is_closed(window)
    return r.MRP_WindowIsClosed(window)
end

-- Returns true if control was manipulated
-- @window MRP_Window
-- @controlname string
-- @return boolean 
function MRP:window_is_dirty_control(window, controlname)
    return r.MRP_WindowIsDirtyControl(window, controlname)
end

-- Set window title
-- @window MRP_Window
-- @title string
function MRP:window_set_title(window, title)
    return r.MRP_WindowSetTitle(window, title)
end

-- Write MRP_Array to disk as a 32 bit floating point mono wav file
-- @array MRP_Array
-- @filename string
-- @samplerate number
function MRP:write_array_to_file(array, filename, samplerate)
    return r.MRP_WriteArrayToFile(array, filename, samplerate)
end

