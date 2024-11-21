-- @description TimeMap: Provide implementation for TimeMap functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local rea_project = require('rea_project')


local TimeMap = {}



--- Create new TimeMap instance.
-- @return TimeMap table.
function TimeMap:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the TimeMap logger.
-- @param ... (varargs) Messages to log.
function TimeMap:log(...)
    local logger = helpers.log_func('TimeMap')
    logger(...)
    return nil
end

    
--- Cur Frame Rate.
-- Gets project framerate, and optionally whether it is drop-frame timecode
-- @return drop_frame boolean
function TimeMap:cur_frame_rate()
    local retval, drop_frame = r.TimeMap_curFrameRate(self.pointer)
    if retval then
        return drop_frame
    else
        return nil
    end
end

    
--- Get Divided Bpm At Time.
-- get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
-- @param time number
-- @return number
function TimeMap:get_divided_bpm_at_time(time)
    return r.TimeMap_GetDividedBpmAtTime(time)
end

    
--- Get Measure Info.
-- Get the QN position and time signature information for the start of a measure.
-- Return the time in seconds of the measure start.
-- @param measure integer
-- @return qn_start number
-- @return qn_end number
-- @return timesig_num integer
-- @return timesig_denom integer
-- @return tempo number
function TimeMap:get_measure_info(measure)
    local retval, qn_start, qn_end, timesig_num, timesig_denom, tempo = r.TimeMap_GetMeasureInfo(self.pointer, measure)
    if retval then
        return qn_start, qn_end, timesig_num, timesig_denom, tempo
    else
        return nil
    end
end

    
--- Get Metronome Pattern.
-- Fills in a string representing the active metronome pattern. For example, in a
-- 7/8 measure divided 3+4, the pattern might be "1221222". The length of the
-- string is the time signature numerator, and the function returns the time
-- signature denominator.
-- @param time number
-- @param pattern string
-- @return pattern string
function TimeMap:get_metronome_pattern(time, pattern)
    local retval, pattern = r.TimeMap_GetMetronomePattern(self.pointer, time, pattern)
    if retval then
        return pattern
    else
        return nil
    end
end

    
--- Get Time Sig At Time.
-- get the effective time signature and tempo
-- @param time number
-- @return timesig_num integer
-- @return timesig_denom integer
-- @return tempo number
function TimeMap:get_time_sig_at_time(time)
    return r.TimeMap_GetTimeSigAtTime(self.pointer, time)
end

    
--- Qn To Measures.
-- Find which measure the given QN position falls in.
-- @param qn number
-- @return number qnMeasureStart
-- @return number qnMeasureEnd
function TimeMap:qn_to_measures(qn)
    local retval, number, number = r.TimeMap_QNToMeasures(self.pointer, qn)
    if retval then
        return number, number
    else
        return nil
    end
end

    
--- Qn To Time.
-- converts project QN position to time.
-- @param qn number
-- @return number
function TimeMap:qn_to_time(qn)
    return r.TimeMap_QNToTime(qn)
end

    
--- Qn To Timeabs.
-- Converts project quarter note count (QN) to time. QN is counted from the start
-- of the project, regardless of any partial measures. See TimeMap2_QNToTime
-- @param qn number
-- @return number
function TimeMap:qn_to_timeabs(qn)
    return r.TimeMap_QNToTime_abs(self.pointer, qn)
end

    
--- Time To Qn.
-- converts project QN position to time.
-- @param tpos number
-- @return number
function TimeMap:time_to_qn(tpos)
    return r.TimeMap_timeToQN(tpos)
end

    
--- Time To Q Nabs.
-- Converts project time position to quarter note count (QN). QN is counted from
-- the start of the project, regardless of any partial measures. See
-- TimeMap2_timeToQN
-- @param tpos number
-- @return number
function TimeMap:time_to_q_nabs(tpos)
    return r.TimeMap_timeToQN_abs(self.pointer, tpos)
end

return TimeMap
