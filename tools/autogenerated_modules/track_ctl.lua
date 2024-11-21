-- @description TrackCtl: Provide implementation for TrackCtl functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local TrackCtl = {}



--- Create new TrackCtl instance.
-- @return TrackCtl table.
function TrackCtl:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the TrackCtl logger.
-- @param ... (varargs) Messages to log.
function TrackCtl:log(...)
    local logger = helpers.log_func('TrackCtl')
    logger(...)
    return nil
end

    
--- Set Tool Tip.
-- displays tooltip at location, or removes if empty string
-- @param fmt string
-- @param xpos integer
-- @param ypos integer
-- @param topmost boolean
function TrackCtl:set_tool_tip(fmt, xpos, ypos, topmost)
    return r.TrackCtl_SetToolTip(fmt, xpos, ypos, topmost)
end

return TrackCtl
