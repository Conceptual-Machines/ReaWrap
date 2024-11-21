-- @description Menu: Provide implementation for Menu functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local Menu = {}



--- Create new Menu instance.
-- @return Menu table.
function Menu:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the Menu logger.
-- @param ... (varargs) Messages to log.
function Menu:log(...)
    local logger = helpers.log_func('Menu')
    logger(...)
    return nil
end

    
--- Get Hash.
-- Get a string that only changes when menu/toolbar entries are added or removed
-- (not re-ordered). Can be used to determine if a customized menu/toolbar differs
-- from the default, or if the default changed after a menu/toolbar was customized.
-- flag==0: current default menu/toolbar; flag==1: current customized menu/toolbar;
-- flag==2: default menu/toolbar at the time the current menu/toolbar was most
-- recently customized, if it was customized in REAPER v7.08 or later.
-- @param menuname string
-- @param flag integer
-- @return hash string
function Menu:get_hash(menuname, flag)
    local retval, hash = r.Menu_GetHash(menuname, flag)
    if retval then
        return hash
    else
        return nil
    end
end

return Menu
