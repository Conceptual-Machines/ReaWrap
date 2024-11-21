-- @description Fab: Provide implementation for Fab functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local Fab = {}



--- Create new Fab instance.
-- @return Fab table.
function Fab:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the Fab logger.
-- @param ... (varargs) Messages to log.
function Fab:log(...)
    local logger = helpers.log_func('Fab')
    logger(...)
    return nil
end

    
--- Clear.
-- Clears ReaFab control map, optionally based on matching idString. Returns true
-- on success.
-- @param string idStringIn optional
-- @return boolean
function Fab:clear(string)
    local string = string or nil
    return r.Fab_Clear(string)
end

    
--- Do .
-- Runs ReaFab actions/commands. First parameter (command) is ReaFab command
-- number, e.g. 3 for 3rd encoder rotation. Second parameter (val) is MIDI CC
-- Relative value. Value 1 is increment of 1, 127 is decrement of 1. 2 is inc 2,
-- 126 is dec 2 and so on. For button press (commands 9-32) a value of 127 is
-- recommended.
-- @param command integer
-- @param val integer
-- @return boolean
function Fab:do_(command, val)
    return r.Fab_Do(command, val)
end

    
--- Dump.
-- Dumps current control mapping into .lua file under
-- ResourcePath/Scripts/reafab_dump-timestamp.lua
function Fab:dump()
    return r.Fab_Dump()
end

    
--- Get.
-- Returns target FX and parameter index for given ReaFab command in context of
-- selected track and ReaFab FX index. Valid command range 1 ... 24. Returns false
-- if no such command mapping is found. Returns param index -1 for ReaFab internal
-- band change command.
-- @param command integer
-- @return fx integer
-- @return param integer
function Fab:get(command)
    local retval, fx, param = r.Fab_Get(command)
    if retval then
        return fx, param
    else
        return nil
    end
end

    
--- Map.
-- Creates control mapping for ReaFab command. fxId e.g. "ReaComp". command 1-8 for
-- encoders, 9-24 for buttons. paramId e.g. "Ratio". control 1 = direct, 2 = band
-- selector, 3 = cycle, 4 = invert, 5 = force toggle, 6 = force range, 7 = 5 and 6,
-- 8 = force continuous. bands define, if target fx has multiple identical target
-- bands. In this case, paramId must include 00 placeholder, e.g. "Band 00 Gain".
-- step overrides built-in default step of ~0.001 for continuous parameters. accel
-- overrides built-in default control acceleration step of 1.0. minval & maxval
-- override default detected target param value range. Prefixing paramId with "-"
-- reverses direction; useful for creating separate next/previous mappings for
-- bands or list type value navigation.
-- @param fx_id string
-- @param command integer
-- @param param_id string
-- @param control integer
-- @param integer bandsIn optional
-- @param number stepIn optional
-- @param number accelIn optional
-- @param number minvalIn optional
-- @param number maxvalIn optional
-- @return boolean
function Fab:map(fx_id, command, param_id, control, integer, number, number, number, number)
    local integer = integer or nil
    local number = number or nil
    return r.Fab_Map(fx_id, command, param_id, control, integer, number, number, number, number)
end

return Fab
