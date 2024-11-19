-- For further manipulation see BR_EnvCountPoints, BR_EnvDeletePoint, BR_EnvFind, BR_EnvFindNext, BR_EnvFindPrevious, BR_EnvGetParentTake, BR_EnvGetParentTrack, BR_EnvGetPoint, BR_EnvGetProperties, BR_EnvSetPoint, BR_EnvSetProperties, BR_EnvValueAtPos.
-- @take_envelopes_use_project_time boolean
-- @return BR_Envelope 
function Envelope:b_r__env_alloc(take_envelopes_use_project_time)
    return r.BR_EnvAlloc(self.pointer, take_envelopes_use_project_time)
end

-- Returns the number of automation items on this envelope. See GetSetAutomationItemInfo
-- @return integer 
function Envelope:count_automation_items()
    return r.CountAutomationItems(self.pointer)
end

-- Returns the number of points in the envelope. See CountEnvelopePointsEx.
-- @return integer 
function Envelope:count_envelope_points()
    return r.CountEnvelopePoints(self.pointer)
end

-- See GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
-- @autoitem_idx integer
-- @return integer 
function Envelope:count_envelope_points_ex(autoitem_idx)
    return r.CountEnvelopePointsEx(self.pointer, autoitem_idx)
end

-- See CountEnvelopePointsEx, GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx.
-- @autoitem_idx integer
-- @ptidx integer
-- @return boolean 
function Envelope:delete_envelope_point_ex(autoitem_idx, ptidx)
    return r.DeleteEnvelopePointEx(self.pointer, autoitem_idx, ptidx)
end

-- Delete a range of envelope points. See DeleteEnvelopePointRangeEx, DeleteEnvelopePointEx.
-- @time_start number
-- @time_end number
-- @return boolean 
function Envelope:delete_envelope_point_range(time_start, time_end)
    return r.DeleteEnvelopePointRange(self.pointer, time_start, time_end)
end

-- Delete a range of envelope points. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
-- @autoitem_idx integer
-- @time_start number
-- @time_end number
-- @return boolean 
function Envelope:delete_envelope_point_range_ex(autoitem_idx, time_start, time_end)
    return r.DeleteEnvelopePointRangeEx(self.pointer, autoitem_idx, time_start, time_end)
end

-- Get the effective envelope value at a given time position. samplesRequested is how long the caller expects until the next call to Envelope_Evaluate (often, the buffer block size). The return value is how many samples beyond that time position that the returned values are valid. dVdS is the change in value per sample (first derivative), ddVdS is the second derivative, dddVdS is the third derivative. See GetEnvelopeScalingMode.
-- @time number
-- @samplerate number
-- @samples_requested integer
-- @return number, number, number, number 
function Envelope:evaluate(time, samplerate, samples_requested)
    local retval, value, d_vd_s, dd_vd_s, ddd_vd_s = r.Envelope_Evaluate(self.pointer, time, samplerate, samples_requested)
    if retval then
        return value, d_vd_s, dd_vd_s, ddd_vd_s
    end
end

-- Formats the value of an envelope to a user-readable form
-- @value number
-- @return string 
function Envelope:format_value(value)
    return r.Envelope_FormatValue(self.pointer, value)
end

-- @parmname string
-- @return number 
function Envelope:get_envelope_info__value(parmname)
    return r.GetEnvelopeInfo_Value(self.pointer, parmname)
end

-- @return string 
function Envelope:get_envelope_name()
    local retval, buf = r.GetEnvelopeName(self.pointer)
    if retval then
        return buf
    end
end

-- Get the attributes of an envelope point. See GetEnvelopePointEx.
-- @ptidx integer
-- @return number, number, number, number, boolean 
function Envelope:get_envelope_point(ptidx)
    local retval, time, value, shape, tension, selected = r.GetEnvelopePoint(self.pointer, ptidx)
    if retval then
        return time, value, shape, tension, selected
    end
end

-- Returns the envelope point at or immediately prior to the given time position. See GetEnvelopePointByTimeEx.
-- @time number
-- @return integer 
function Envelope:get_envelope_point_by_time(time)
    return r.GetEnvelopePointByTime(self.pointer, time)
end

-- See GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
-- @autoitem_idx integer
-- @time number
-- @return integer 
function Envelope:get_envelope_point_by_time_ex(autoitem_idx, time)
    return r.GetEnvelopePointByTimeEx(self.pointer, autoitem_idx, time)
end

-- See CountEnvelopePointsEx, SetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
-- @autoitem_idx integer
-- @ptidx integer
-- @return number, number, number, number, boolean 
function Envelope:get_envelope_point_ex(autoitem_idx, ptidx)
    local retval, time, value, shape, tension, selected = r.GetEnvelopePointEx(self.pointer, autoitem_idx, ptidx)
    if retval then
        return time, value, shape, tension, selected
    end
end

-- Returns the envelope scaling mode: 0=no scaling, 1=fader scaling. All API functions deal with raw envelope point values, to convert raw from/to scaled values see ScaleFromEnvelopeMode, ScaleToEnvelopeMode.
-- @return integer 
function Envelope:get_envelope_scaling_mode()
    return r.GetEnvelopeScalingMode(self.pointer)
end

-- Gets the RPPXML state of an envelope, returns true if successful. Undo flag is a performance/caching hint.
-- @str string
-- @isundo boolean
-- @return string 
function Envelope:get_envelope_state_chunk(str, isundo)
    local retval, str_ = r.GetEnvelopeStateChunk(self.pointer, str, isundo)
    if retval then
        return str_
    end
end

-- If take envelope, gets the take from the envelope. If FX, indexOutOptional set to FX index, index2OutOptional set to parameter index, otherwise -1.
-- @return number, number 
function Envelope:get_parent_take()
    local retval, index, index2 = r.Envelope_GetParentTake(self.pointer)
    if retval then
        return index, index2
    end
end

-- If track envelope, gets the track from the envelope. If FX, indexOutOptional set to FX index, index2OutOptional set to parameter index, otherwise -1.
-- @return number, number 
function Envelope:get_parent_track()
    local retval, index, index2 = r.Envelope_GetParentTrack(self.pointer)
    if retval then
        return index, index2
    end
end

-- @autoitem_idx integer
-- @desc string
-- @value number
-- @is_set boolean
-- @return number 
function Envelope:get_set_automation_item_info(autoitem_idx, desc, value, is_set)
    return r.GetSetAutomationItemInfo(self.pointer, autoitem_idx, desc, value, is_set)
end

-- @autoitem_idx integer
-- @desc string
-- @valuestr_need_big string
-- @is_set boolean
-- @return string 
function Envelope:get_set_automation_item_info__string(autoitem_idx, desc, valuestr_need_big, is_set)
    local retval, valuestr_need_big_ = r.GetSetAutomationItemInfo_String(self.pointer, autoitem_idx, desc, valuestr_need_big, is_set)
    if retval then
        return valuestr_need_big_
    end
end

-- @parmname string
-- @string_need_big string
-- @set_new_value boolean
-- @return string 
function Envelope:get_set_envelope_info__string(parmname, string_need_big, set_new_value)
    local retval, string_need_big_ = r.GetSetEnvelopeInfo_String(self.pointer, parmname, string_need_big, set_new_value)
    if retval then
        return string_need_big_
    end
end

-- deprecated -- see SetEnvelopeStateChunk, GetEnvelopeStateChunk
-- @str string
-- @return string 
function Envelope:get_set_envelope_state(str)
    local retval, str_ = r.GetSetEnvelopeState(self.pointer, str)
    if retval then
        return str_
    end
end

-- deprecated -- see SetEnvelopeStateChunk, GetEnvelopeStateChunk
-- @str string
-- @isundo boolean
-- @return string 
function Envelope:get_set_envelope_state2(str, isundo)
    local retval, str_ = r.GetSetEnvelopeState2(self.pointer, str, isundo)
    if retval then
        return str_
    end
end

-- Insert a new automation item. pool_id < 0 collects existing envelope points into the automation item; if pool_id is >= 0 the automation item will be a new instance of that pool (which will be created as an empty instance if it does not exist). Returns the index of the item, suitable for passing to other automation item API functions. See GetSetAutomationItemInfo.
-- @pool_id integer
-- @position number
-- @length number
-- @return integer 
function Envelope:insert_automation_item(pool_id, position, length)
    return r.InsertAutomationItem(self.pointer, pool_id, position, length)
end

-- Insert an envelope point. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. See InsertEnvelopePointEx.
-- @time number
-- @value number
-- @shape integer
-- @tension number
-- @selected boolean
-- @no_sort_in boolean
-- @return boolean 
function Envelope:insert_envelope_point(time, value, shape, tension, selected, no_sort_in)
    return r.InsertEnvelopePoint(self.pointer, time, value, shape, tension, selected, no_sort_in)
end

-- See CountEnvelopePointsEx, GetEnvelopePointEx, SetEnvelopePointEx, DeleteEnvelopePointEx.
-- @autoitem_idx integer
-- @time number
-- @value number
-- @shape integer
-- @tension number
-- @selected boolean
-- @no_sort_in boolean
-- @return boolean 
function Envelope:insert_envelope_point_ex(autoitem_idx, time, value, shape, tension, selected, no_sort_in)
    return r.InsertEnvelopePointEx(self.pointer, autoitem_idx, time, value, shape, tension, selected, no_sort_in)
end

-- This function isn't really correct... it calculates a 64 bit hash but returns it as a 32 bit int. Should reimplement this. Or rather, even more confusingly : The hash will be 32 bit when building for 32 bit architecture and 64 bit when building for 64 bit architecture! It comes down to how size_t is of different size between the 32 and 64 bit architectures.
-- @return integer 
function Envelope:m_r_p__calculate_envelope_hash()
    return r.MRP_CalculateEnvelopeHash(self.pointer)
end

-- Set attributes of an envelope point. Values that are not supplied will be ignored. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. See SetEnvelopePointEx.
-- @ptidx integer
-- @time_in number
-- @value_in number
-- @shape_in number
-- @tension_in number
-- @selected_in boolean
-- @no_sort_in boolean
-- @return boolean 
function Envelope:set_envelope_point(ptidx, time_in, value_in, shape_in, tension_in, selected_in, no_sort_in)
    return r.SetEnvelopePoint(self.pointer, ptidx, time_in, value_in, shape_in, tension_in, selected_in, no_sort_in)
end

-- See CountEnvelopePointsEx, GetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
-- @autoitem_idx integer
-- @ptidx integer
-- @time_in number
-- @value_in number
-- @shape_in number
-- @tension_in number
-- @selected_in boolean
-- @no_sort_in boolean
-- @return boolean 
function Envelope:set_envelope_point_ex(autoitem_idx, ptidx, time_in, value_in, shape_in, tension_in, selected_in, no_sort_in)
    return r.SetEnvelopePointEx(self.pointer, autoitem_idx, ptidx, time_in, value_in, shape_in, tension_in, selected_in, no_sort_in)
end

-- Sets the RPPXML state of an envelope, returns true if successful. Undo flag is a performance/caching hint.
-- @str string
-- @isundo boolean
-- @return boolean 
function Envelope:set_envelope_state_chunk(str, isundo)
    return r.SetEnvelopeStateChunk(self.pointer, str, isundo)
end

-- Sort envelope points by time. See SetEnvelopePoint, InsertEnvelopePoint.
-- @return boolean 
function Envelope:sort_points()
    return r.Envelope_SortPoints(self.pointer)
end

-- Sort envelope points by time. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc. See SetEnvelopePoint, InsertEnvelopePoint.
-- @autoitem_idx integer
-- @return boolean 
function Envelope:sort_points_ex(autoitem_idx)
    return r.Envelope_SortPointsEx(self.pointer, autoitem_idx)
end

