-- @description MRP: Provide implementation for MRP functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local track_envelope = require('track_envelope')


local MRP = {}



--- Create new MRP instance.
-- @return MRP table.
function MRP:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the MRP logger.
-- @param ... (varargs) Messages to log.
function MRP:log(...)
    local logger = helpers.log_func('MRP')
    logger(...)
    return nil
end

    
--- Calculate Envelope Hash.
-- This function isn't really correct... it calculates a 64 bit hash but returns it
-- as a 32 bit int. Should reimplement this. Or rather, even more confusingly : The
-- hash will be 32 bit when building for 32 bit architecture and 64 bit when
-- building for 64 bit architecture! It comes down to how size_t is of different
-- size between the 32 and 64 bit architectures.
-- @return integer
function MRP:calculate_envelope_hash()
    return r.MRP_CalculateEnvelopeHash(self.pointer)
end

    
--- Cast Double To Int.
-- add two numbers
-- @param n1 number
-- @param n2 number
-- @return integer
function MRP:cast_double_to_int(n1, n2)
    return r.MRP_CastDoubleToInt(n1, n2)
end

    
--- Create Array.
-- Create an array of 64 bit floating point numbers. Note that these will leak
-- memory if they are not later destroyed with MRP_DestroyArray!
-- @param size integer
-- @return MRP_Array
function MRP:create_array(size)
    return r.MRP_CreateArray(size)
end

    
--- Create Window.
-- Create window
-- @param title string
-- @return MRP_Window
function MRP:create_window(title)
    return r.MRP_CreateWindow(title)
end

    
--- Destroy Array.
-- Destroy a previously created MRP_Array
-- @param array MRP_Array
function MRP:destroy_array(array)
    return r.MRP_DestroyArray(array)
end

    
--- Destroy Window.
-- Destroy window
-- @param window MRP_Window
function MRP:destroy_window(window)
    return r.MRP_DestroyWindow(window)
end

    
--- Do Nothing.
-- do nothing, return null
function MRP:do_nothing()
    return r.MRP_DoNothing()
end

    
--- Double Pointer.
-- add two numbers
-- @param n1 number
-- @param n2 number
-- @return number
function MRP:double_pointer(n1, n2)
    return r.MRP_DoublePointer(n1, n2)
end

    
--- Double Pointer As Int.
-- add two numbers
-- @param n1 number
-- @param n2 number
-- @return integer
function MRP:double_pointer_as_int(n1, n2)
    return r.MRP_DoublePointerAsInt(n1, n2)
end

    
--- Generate Sine.
-- Generate a sine wave into a MRP_Array
-- @param array MRP_Array
-- @param samplerate number
-- @param frequency number
function MRP:generate_sine(array, samplerate, frequency)
    return r.MRP_GenerateSine(array, samplerate, frequency)
end

    
--- Get Array Value.
-- Get MRP_Array element value. No safety checks done for array or index validity,
-- so use at your own peril!
-- @param array MRP_Array
-- @param index integer
-- @return number
function MRP:get_array_value(array, index)
    return r.MRP_GetArrayValue(array, index)
end

    
--- Get Control Float Number.
-- Get a floating point number associated with control. Meaning of 'which' depends
-- on the control targeted.
-- @param window MRP_Window
-- @param controlname string
-- @param which integer
-- @return number
function MRP:get_control_float_number(window, controlname, which)
    return r.MRP_GetControlFloatNumber(window, controlname, which)
end

    
--- Get Control Int Number.
-- Get an integer point number associated with control. Meaning of 'which' depends
-- on the control targeted.
-- @param window MRP_Window
-- @param controlname string
-- @param which integer
-- @return integer
function MRP:get_control_int_number(window, controlname, which)
    return r.MRP_GetControlIntNumber(window, controlname, which)
end

    
--- Get Window Dirty.
-- Get window dirty state (ie, if something was changed in the window). which : 0
-- window size
-- @param window MRP_Window
-- @param whichdirty integer
-- @return boolean
function MRP:get_window_dirty(window, whichdirty)
    return r.MRP_GetWindowDirty(window, whichdirty)
end

    
--- Get Window Pos Size Value.
-- Get window geometry values. which : 0 x, 1 y, 2 w, 3 h
-- @param window MRP_Window
-- @param which integer
-- @return integer
function MRP:get_window_pos_size_value(window, which)
    return r.MRP_GetWindowPosSizeValue(window, which)
end

    
--- Int Pointer.
-- add two numbers
-- @param n1 integer
-- @param n2 integer
-- @return integer
function MRP:int_pointer(n1, n2)
    return r.MRP_IntPointer(n1, n2)
end

    
--- Multiply Arrays.
-- Multiply 2 MRP_Arrays of same length. Result is written to 3rd array.
-- @param array1 MRP_Array
-- @param array2 MRP_Array
-- @param array3 MRP_Array
function MRP:multiply_arrays(array1, array2, array3)
    return r.MRP_MultiplyArrays(array1, array2, array3)
end

    
--- Multiply Arrays Mt.
-- Multiply 2 MRP_Arrays of same length. Result is written to 3rd array. Uses
-- multiple threads.
-- @param array1 MRP_Array
-- @param array2 MRP_Array
-- @param array3 MRP_Array
function MRP:multiply_arrays_mt(array1, array2, array3)
    return r.MRP_MultiplyArraysMT(array1, array2, array3)
end

    
--- Return Media Item.
-- return media item
-- @return MediaItem table
function MRP:return_media_item()
    local result = r.MRP_ReturnMediaItem()
    return media_item.MediaItem:new(result)
end

    
--- Send Command String.
-- Send a command message to control. Currently only the envelope control
-- understands some messages.
-- @param window MRP_Window
-- @param controlname string
-- @param commandtext string
function MRP:send_command_string(window, controlname, commandtext)
    return r.MRP_SendCommandString(window, controlname, commandtext)
end

    
--- Set Array Value.
-- Set MRP_Array element value. No safety checks done for array or index validity,
-- so use at your own peril!
-- @param array MRP_Array
-- @param index integer
-- @param value number
function MRP:set_array_value(array, index, value)
    return r.MRP_SetArrayValue(array, index, value)
end

    
--- Set Control Bounds.
-- Set MRP control position and size
-- @param window MRP_Window
-- @param name string
-- @param x number
-- @param y number
-- @param w number
-- @param h number
function MRP:set_control_bounds(window, name, x, y, w, h)
    return r.MRP_SetControlBounds(window, name, x, y, w, h)
end

    
--- Set Control Float Number.
-- Set a floating point number associated with control. Meaning of 'which' depends
-- on the control targeted.
-- @param window MRP_Window
-- @param controlname string
-- @param which integer
-- @param value number
function MRP:set_control_float_number(window, controlname, which, value)
    return r.MRP_SetControlFloatNumber(window, controlname, which, value)
end

    
--- Set Control Int Number.
-- Set an integer point number associated with control. Meaning of 'which' depends
-- on the control targeted.
-- @param window MRP_Window
-- @param controlname string
-- @param which integer
-- @param value integer
function MRP:set_control_int_number(window, controlname, which, value)
    return r.MRP_SetControlIntNumber(window, controlname, which, value)
end

    
--- Set Control String.
-- Set a text property associated with control. Meaning of 'which' depends on the
-- control targeted.
-- @param window MRP_Window
-- @param controlname string
-- @param which integer
-- @param text string
function MRP:set_control_string(window, controlname, which, text)
    return r.MRP_SetControlString(window, controlname, which, text)
end

    
--- Set Window Dirty.
-- Set window dirty state (ie, if something was changed in the controls)
-- @param window MRP_Window
-- @param which integer
-- @param state boolean
function MRP:set_window_dirty(window, which, state)
    return r.MRP_SetWindowDirty(window, which, state)
end

    
--- Window Add Control.
-- Add a control to window. Controltypename is the type of control to create.
-- Objectname must be a unique id
-- @param window MRP_Window
-- @param controltypename string
-- @param objectname string
function MRP:window_add_control(window, controltypename, objectname)
    return r.MRP_WindowAddControl(window, controltypename, objectname)
end

    
--- Window Clear Dirty Controls.
-- Clears the dirty states of the controls in a window.
-- @param window MRP_Window
function MRP:window_clear_dirty_controls(window)
    return r.MRP_WindowClearDirtyControls(window)
end

    
--- Window Is Closed.
-- Returns if the window has been closed and the ReaScript defer loop should likely
-- be exited
-- @param window MRP_Window
-- @return boolean
function MRP:window_is_closed(window)
    return r.MRP_WindowIsClosed(window)
end

    
--- Window Is Dirty Control.
-- Returns true if control was manipulated
-- @param window MRP_Window
-- @param controlname string
-- @return boolean
function MRP:window_is_dirty_control(window, controlname)
    return r.MRP_WindowIsDirtyControl(window, controlname)
end

    
--- Window Set Title.
-- Set window title
-- @param window MRP_Window
-- @param title string
function MRP:window_set_title(window, title)
    return r.MRP_WindowSetTitle(window, title)
end

    
--- Write Array To File.
-- Write MRP_Array to disk as a 32 bit floating point mono wav file
-- @param array MRP_Array
-- @param filename string
-- @param samplerate number
function MRP:write_array_to_file(array, filename, samplerate)
    return r.MRP_WriteArrayToFile(array, filename, samplerate)
end

return MRP
