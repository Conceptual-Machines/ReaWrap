-- @description Track: Provide implementation for Track functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_track = require('media_track')


local Track = {}



--- Create new Track instance.
-- @return Track table.
function Track:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the Track logger.
-- @param ... (varargs) Messages to log.
function Track:log(...)
    local logger = helpers.log_func('Track')
    logger(...)
    return nil
end

    
--- Get Peak Hold Db.
-- Returns meter hold state, in dB*0.01 (0 = +0dB, -0.01 = -1dB, 0.02 = +2dB, etc).
-- If clear is set, clears the meter hold. If channel==1024 or channel==1025,
-- returns loudness values if this is the master track or this track's VU meters
-- are set to display loudness.
-- @param channel integer
-- @param clear boolean
-- @return number
function Track:get_peak_hold_db(channel, clear)
    return r.Track_GetPeakHoldDB(self.pointer, channel, clear)
end

    
--- Get Peak Info.
-- Returns peak meter value (1.0=+0dB, 0.0=-inf) for channel. If channel==1024 or
-- channel==1025, returns loudness values if this is the master track or this
-- track's VU meters are set to display loudness.
-- @param channel integer
-- @return number
function Track:get_peak_info(channel)
    return r.Track_GetPeakInfo(self.pointer, channel)
end

return Track
