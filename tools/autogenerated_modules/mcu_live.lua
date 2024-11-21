-- @description MCULive: Provide implementation for MCULive functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local MCULive = {}



--- Create new MCULive instance.
-- @return MCULive table.
function MCULive:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the MCULive logger.
-- @param ... (varargs) Messages to log.
function MCULive:log(...)
    local logger = helpers.log_func('MCULive')
    logger(...)
    return nil
end

    
--- Get Button Value.
-- Get current button state.
-- @param device integer
-- @param button integer
-- @return integer
function MCULive:get_button_value(device, button)
    return r.MCULive_GetButtonValue(device, button)
end

    
--- Get Device.
-- Get MIDI input or output dev ID. type 0 is input dev, type 1 is output dev.
-- device < 0 returns number of MCULive devices.
-- @param device integer
-- @param type integer
-- @return integer
function MCULive:get_device(device, type)
    return r.MCULive_GetDevice(device, type)
end

    
--- Get Encoder Value.
-- Returns zero-indexed encoder parameter value. 0 = lastpos, 1 = lasttouch
-- @param device integer
-- @param enc__idx integer
-- @param param integer
-- @return number
function MCULive:get_encoder_value(device, enc__idx, param)
    return r.MCULive_GetEncoderValue(device, enc__idx, param)
end

    
--- Get Fader Value.
-- Returns zero-indexed fader parameter value. 0 = lastpos, 1 = lasttouch, 2 =
-- lastmove (any fader)
-- @param device integer
-- @param fader__idx integer
-- @param param integer
-- @return number
function MCULive:get_fader_value(device, fader__idx, param)
    return r.MCULive_GetFaderValue(device, fader__idx, param)
end

    
--- Get Midi Message.
-- Gets MIDI message from input buffer/queue. Gets (pops/pulls) indexed message
-- (status, data1, data2 and frame_offset) from queue and retval is total
-- size/length left in queue. E.g. continuously read all indiviual messages with
-- deferred script. Frame offset resolution is 1/1024000 seconds, not audio
-- samples. Long messages are returned as optional strings of byte characters.
-- msgIdx -1 returns size (length) of buffer. Read also non-MCU devices by creating
-- MCULive device with their input.
-- @param device integer
-- @param msg__idx integer
-- @return status integer
-- @return data1 integer
-- @return data2 integer
-- @return frame_offset integer
-- @return string msg
function MCULive:get_midi_message(device, msg__idx)
    local retval, status, data1, data2, frame_offset, string = r.MCULive_GetMIDIMessage(device, msg__idx)
    if retval then
        return status, data1, data2, frame_offset, string
    else
        return nil
    end
end

    
--- Map.
-- Maps MCU Live device# button# to REAPER command ID. E.g.
-- reaper.MCULive_Map(0,0x5b, 40340) maps MCU Rewind to "Track: Unsolo all tracks".
-- Or remap button to another button if your MCU button layout doesnt play nicely
-- with default MCULive mappings. By default range 0x00 .. 0x2d is in use. Button
-- numbers are second column (prefixed with 0x) e.g. '90 5e' 0x5e for 'transport :
-- play', roughly.
-- @param device integer
-- @param button integer
-- @param command_id integer
-- @param is__remap boolean
-- @return integer
function MCULive:map(device, button, command_id, is__remap)
    return r.MCULive_Map(device, button, command_id, is__remap)
end

    
--- Reset.
-- Reset device. device < 0 resets all and returns number of devices.
-- @param device integer
-- @return integer
function MCULive:reset(device)
    return r.MCULive_Reset(device)
end

    
--- Send Midi Message.
-- Sends MIDI message to device. If string is provided, individual bytes are not
-- sent. Returns number of sent bytes.
-- @param device integer
-- @param status integer
-- @param data1 integer
-- @param data2 integer
-- @param string msgIn optional
-- @return integer
function MCULive:send_midi_message(device, status, data1, data2, string)
    local string = string or nil
    return r.MCULive_SendMIDIMessage(device, status, data1, data2, string)
end

    
--- Set Button Passthrough.
-- Set button as MIDI passthrough.
-- @param device integer
-- @param button integer
-- @param is__set boolean
-- @return integer
function MCULive:set_button_passthrough(device, button, is__set)
    return r.MCULive_SetButtonPassthrough(device, button, is__set)
end

    
--- Set Button Press Only.
-- Buttons function as press only by default. Set false for press and release
-- function.
-- @param device integer
-- @param button integer
-- @param is__set boolean
-- @return integer
function MCULive:set_button_press_only(device, button, is__set)
    return r.MCULive_SetButtonPressOnly(device, button, is__set)
end

    
--- Set Button Value.
-- Set button led/mode/state. Value 0 = off,1 = blink, 0x7f = on, usually.
-- @param device integer
-- @param button integer
-- @param value integer
-- @return integer
function MCULive:set_button_value(device, button, value)
    return r.MCULive_SetButtonValue(device, button, value)
end

    
--- Set Default.
-- Enables/disables default out-of-the-box operation.
-- @param device integer
-- @param is__set boolean
function MCULive:set_default(device, is__set)
    return r.MCULive_SetDefault(device, is__set)
end

    
--- Set Display.
-- Write to display. 112 characters, 56 per row.
-- @param device integer
-- @param pos integer
-- @param message string
-- @param pad integer
function MCULive:set_display(device, pos, message, pad)
    return r.MCULive_SetDisplay(device, pos, message, pad)
end

    
--- Set Encoder Value.
-- Set encoder to value 0 ... 1.0. Type 0 = linear, 1 = track volume, 2 = pan.
-- Returns scaled value.
-- @param device integer
-- @param enc__idx integer
-- @param val number
-- @param type integer
-- @return integer
function MCULive:set_encoder_value(device, enc__idx, val, type)
    return r.MCULive_SetEncoderValue(device, enc__idx, val, type)
end

    
--- Set Fader Value.
-- Set fader to value 0 ... 1.0. Type 0 = linear, 1 = track volume, 2 = pan.
-- Returns scaled value.
-- @param device integer
-- @param fader__idx integer
-- @param val number
-- @param type integer
-- @return integer
function MCULive:set_fader_value(device, fader__idx, val, type)
    return r.MCULive_SetFaderValue(device, fader__idx, val, type)
end

    
--- Set Meter Value.
-- Set meter value 0 ... 1.0. Type 0 = linear, 1 = track volume (with decay).
-- @param device integer
-- @param meter__idx integer
-- @param val number
-- @param type integer
-- @return integer
function MCULive:set_meter_value(device, meter__idx, val, type)
    return r.MCULive_SetMeterValue(device, meter__idx, val, type)
end

    
--- Set Option.
-- 1 : surface split point device index  2 : 'mode-is-global' bitmask/flags, first
-- 6 bits
-- @param option integer
-- @param value integer
function MCULive:set_option(option, value)
    return r.MCULive_SetOption(option, value)
end

return MCULive
