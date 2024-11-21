-- @description Dock: Provide implementation for Dock functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local Dock = {}



--- Create new Dock instance.
-- @return Dock table.
function Dock:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the Dock logger.
-- @param ... (varargs) Messages to log.
function Dock:log(...)
    local logger = helpers.log_func('Dock')
    logger(...)
    return nil
end

    
--- Update Id.
-- updates preference for docker window ident_str to be in dock whichDock on next
-- open
-- @param ident_str string
-- @param which_dock integer
function Dock:update_id(ident_str, which_dock)
    return r.Dock_UpdateDockID(ident_str, which_dock)
end

return Dock
