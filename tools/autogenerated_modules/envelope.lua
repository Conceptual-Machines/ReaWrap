-- @description Envelope: Provide implementation for Envelope functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local track_envelope = require('track_envelope')


local Envelope = {}



--- Create new Envelope instance.
-- @return Envelope table.
function Envelope:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the Envelope logger.
-- @param ... (varargs) Messages to log.
function Envelope:log(...)
    local logger = helpers.log_func('Envelope')
    logger(...)
    return nil
end

    
--- Evaluate.
-- Get the effective envelope value at a given time position. samplesRequested is
-- how long the caller expects until the next call to Envelope_Evaluate (often, the
-- buffer block size). The return value is how many samples beyond that time
-- position that the returned values are valid. dVdS is the change in value per
-- sample (first derivative), ddVdS is the second derivative, dddVdS is the third
-- derivative. See GetEnvelopeScalingMode.
-- @param time number
-- @param samplerate number
-- @param samples_requested integer
-- @return value number
-- @return d_vd_s number
-- @return dd_vd_s number
-- @return ddd_vd_s number
function Envelope:evaluate(time, samplerate, samples_requested)
    local retval, value, d_vd_s, dd_vd_s, ddd_vd_s = r.Envelope_Evaluate(self.pointer, time, samplerate, samples_requested)
    if retval then
        return value, d_vd_s, dd_vd_s, ddd_vd_s
    else
        return nil
    end
end

    
--- Format Value.
-- Formats the value of an envelope to a user-readable form
-- @param value number
-- @return buf string
function Envelope:format_value(value)
    return r.Envelope_FormatValue(self.pointer, value)
end

    
--- Get Parent Take.
-- If take envelope, gets the take from the envelope. If FX, indexOut set to FX
-- index, index2Out set to parameter index, otherwise -1.
-- @return index integer
-- @return index2 integer
function Envelope:get_parent_take()
    local retval, index, index2 = r.Envelope_GetParentTake(self.pointer)
    if retval then
        return index, index2
    else
        return nil
    end
end

    
--- Get Parent Track.
-- If track envelope, gets the track from the envelope. If FX, indexOut set to FX
-- index, index2Out set to parameter index, otherwise -1.
-- @return index integer
-- @return index2 integer
function Envelope:get_parent_track()
    local retval, index, index2 = r.Envelope_GetParentTrack(self.pointer)
    if retval then
        return index, index2
    else
        return nil
    end
end

    
--- Sort Points.
-- Sort envelope points by time. See SetEnvelopePoint, InsertEnvelopePoint.
-- @return boolean
function Envelope:sort_points()
    return r.Envelope_SortPoints(self.pointer)
end

    
--- Sort Points Ex.
-- Sort envelope points by time. autoitem_idx=-1 for the underlying envelope, 0 for
-- the first automation item on the envelope, etc. See SetEnvelopePoint,
-- InsertEnvelopePoint.
-- @param autoitem__idx integer
-- @return boolean
function Envelope:sort_points_ex(autoitem__idx)
    return r.Envelope_SortPointsEx(self.pointer, autoitem__idx)
end

return Envelope
