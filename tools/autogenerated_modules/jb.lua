-- @description JB: Provide implementation for JB functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local rea_project = require('rea_project')


local JB = {}



--- Create new JB instance.
-- @return JB table.
function JB:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the JB logger.
-- @param ... (varargs) Messages to log.
function JB:log(...)
    local logger = helpers.log_func('JB')
    logger(...)
    return nil
end

    
--- Get Sws Extra Project Notes.
-- @return string
function JB:get_sws_extra_project_notes()
    return r.JB_GetSWSExtraProjectNotes(self.pointer)
end

    
--- Set Sws Extra Project Notes.
-- @param str string
function JB:set_sws_extra_project_notes(str)
    return r.JB_SetSWSExtraProjectNotes(self.pointer, str)
end

return JB
