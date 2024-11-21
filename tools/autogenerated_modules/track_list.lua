-- @description TrackList: Provide implementation for TrackList functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local TrackList = {}



--- Create new TrackList instance.
-- @return TrackList table.
function TrackList:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the TrackList logger.
-- @param ... (varargs) Messages to log.
function TrackList:log(...)
    local logger = helpers.log_func('TrackList')
    logger(...)
    return nil
end

    
--- Adjust Windows.
-- @param is__minor boolean
function TrackList:adjust_windows(is__minor)
    return r.TrackList_AdjustWindows(is__minor)
end

    
--- Update All External Surfaces.
function TrackList:update_all_external_surfaces()
    return r.TrackList_UpdateAllExternalSurfaces()
end

return TrackList
