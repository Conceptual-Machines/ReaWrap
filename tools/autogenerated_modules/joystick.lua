-- @description joystick: Provide implementation for joystick functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local joystick = {}



--- Create new joystick instance.
-- @return joystick table.
function joystick:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the joystick logger.
-- @param ... (varargs) Messages to log.
function joystick:log(...)
    local logger = helpers.log_func('joystick')
    logger(...)
    return nil
end

    
--- Create.
-- creates a joystick device
-- @param guid_guid string
-- @return joystick_device
function joystick:create(guid_guid)
    return r.joystick_create(guid_guid)
end

    
--- Destroy.
-- destroys a joystick device
-- @param device joystick_device
function joystick:destroy(device)
    return r.joystick_destroy(device)
end

    
--- Enum.
-- enumerates installed devices, returns GUID as a string
-- @param index integer
-- @return string namestr
function joystick:enum(index)
    local retval, string = r.joystick_enum(index)
    if retval then
        return string
    else
        return nil
    end
end

    
--- Getaxis.
-- returns axis value (-1..1)
-- @param dev joystick_device
-- @param axis integer
-- @return number
function joystick:getaxis(dev, axis)
    return r.joystick_getaxis(dev, axis)
end

    
--- Getbuttonmask.
-- returns button pressed mask, 1=first button, 2=second...
-- @param dev joystick_device
-- @return integer
function joystick:getbuttonmask(dev)
    return r.joystick_getbuttonmask(dev)
end

    
--- Getinfo.
-- returns button count
-- @param dev joystick_device
-- @return integer axes
-- @return integer povs
function joystick:getinfo(dev)
    local retval, integer, integer = r.joystick_getinfo(dev)
    if retval then
        return integer, integer
    else
        return nil
    end
end

    
--- Getpov.
-- returns POV value (usually 0..655.35, or 655.35 on error)
-- @param dev joystick_device
-- @param pov integer
-- @return number
function joystick:getpov(dev, pov)
    return r.joystick_getpov(dev, pov)
end

    
--- Update.
-- Updates joystick state from hardware, returns true if successful (joystick_get*
-- will not be valid until joystick_update() is called successfully)
-- @param dev joystick_device
-- @return boolean
function joystick:update(dev)
    return r.joystick_update(dev)
end

return joystick
