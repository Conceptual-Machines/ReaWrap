-- get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
-- @time number
-- @return number 
function TimeMap:get_divided_bpm_at_time(time)
    return r.TimeMap_GetDividedBpmAtTime(time)
end

-- converts project QN position to time.
-- @qn number
-- @return number 
function TimeMap:qn_to_time(qn)
    return r.TimeMap_QNToTime(qn)
end

-- converts project QN position to time.
-- @tpos number
-- @return number 
function TimeMap:time_to_qn(tpos)
    return r.TimeMap_timeToQN(tpos)
end

