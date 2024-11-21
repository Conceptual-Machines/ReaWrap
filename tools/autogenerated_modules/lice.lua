-- @description LICE: Provide implementation for LICE functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local LICE = {}



--- Create new LICE instance.
-- @return LICE table.
function LICE:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the LICE logger.
-- @param ... (varargs) Messages to log.
function LICE:log(...)
    local logger = helpers.log_func('LICE')
    logger(...)
    return nil
end

    
--- Clip Line.
-- Returns false if the line is entirely offscreen.
-- @param p_x1 integer
-- @param p_y1 integer
-- @param p_x2 integer
-- @param p_y2 integer
-- @param x_lo integer
-- @param y_lo integer
-- @param x_hi integer
-- @param y_hi integer
-- @return p_x1 integer
-- @return p_y1 integer
-- @return p_x2 integer
-- @return p_y2 integer
function LICE:clip_line(p_x1, p_y1, p_x2, p_y2, x_lo, y_lo, x_hi, y_hi)
    local retval, p_x1, p_y1, p_x2, p_y2 = r.LICE_ClipLine(p_x1, p_y1, p_x2, p_y2, x_lo, y_lo, x_hi, y_hi)
    if retval then
        return p_x1, p_y1, p_x2, p_y2
    else
        return nil
    end
end

return LICE
