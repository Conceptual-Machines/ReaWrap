-- @description Master: Provide implementation for Master functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local rea_project = require('rea_project')


local Master = {}



--- Create new Master instance.
-- @return Master table.
function Master:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the Master logger.
-- @param ... (varargs) Messages to log.
function Master:log(...)
    local logger = helpers.log_func('Master')
    logger(...)
    return nil
end

    
--- Get Play Rate.
-- @return number
function Master:get_play_rate()
    return r.Master_GetPlayRate(self.pointer)
end

    
--- Get Play Rate At Time.
-- @param time_s number
-- @return number
function Master:get_play_rate_at_time(time_s)
    return r.Master_GetPlayRateAtTime(time_s, proj)
end

    
--- Get Tempo.
-- @return number
function Master:get_tempo()
    return r.Master_GetTempo()
end

    
--- Normalize Play Rate.
-- Convert play rate to/from a value between 0 and 1, representing the position on
-- the project playrate slider.
-- @param playrate number
-- @param is_normalized boolean
-- @return number
function Master:normalize_play_rate(playrate, is_normalized)
    return r.Master_NormalizePlayRate(playrate, is_normalized)
end

    
--- Normalize Tempo.
-- Convert the tempo to/from a value between 0 and 1, representing bpm in the range
-- of 40-296 bpm.
-- @param bpm number
-- @param is_normalized boolean
-- @return number
function Master:normalize_tempo(bpm, is_normalized)
    return r.Master_NormalizeTempo(bpm, is_normalized)
end

return Master
