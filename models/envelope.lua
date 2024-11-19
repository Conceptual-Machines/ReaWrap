--@ Module : envelope
--@ Description : Envelope model
--@ Author : J. 'Schlump' K.
--@ License : MIT
--@ Version : 1.0

local constants = require('ReaWrap.models.constants')
local helpers = require('ReaWrap.models.helpers')

local r = reaper

local envelope = {}

Envelope = {
    pointer_type = constants.PointerTypes.Envelope
}


function Envelope:new(pointer)
    local o = {
        pointer = pointer
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

-- String representation of Track object
-- @return string
function Envelope:__tostring()
    return ('<Envelope name=%s>').format(self:get_name())
end

function Envelope:log(...)
    local logger = helpers.log_func('Envelope')
    return helpers.logger(...)
end

function Envelope:get_name()
    local retval, buf = r.GetEnvelopeName(self.pointer)
    if retval then
        return buf
    end
end

function Envelope:add_point(time, value, shape, tension, selected, no_sort)
     r.InsertEnvelopePoint(self.pointer, time, value, shape, tension, selected, no_sort)
end

function Envelope:add_points_around_edges(start_pos, end_pos)
    self:add_point(start_pos, zero_db, 0, 0, false, false)
    self:add_point(start_pos, minus_inf, 0, 0, false, false)
    self:add_point(end_pos, minus_inf, 0, 0, false, false)
    self:add_point(end_pos, zero_db, 0, 0, false, false)
end


function Envelope:count_points()
     return r.CountEnvelopePoints(self.pointer)
end

function Envelope:get_point(pt_idx)
    local ret = { reaper.GetEnvelopePoint(self.pointer, pt_idx) }
    if ret[1] then
        return EnvelopePoint:new(
                self, pt_idx, ret[2], ret[3], ret[4], ret[5], ret[6]
        )
    end
end

function Envelope:get_points()
    local points = {}
    for i=0, self:count_points() - 1 do
        local point =  self:get_point(i)
        points[i+1] = point
    end
    return points
end

function Envelope:iter_points()
    return helpers.iter(self:get_points())
end


function Envelope:count_automation_items()
     return r.CountAutomationItems(self.pointer)
end

function Envelope:add_ai(pool_id, position, length)
    local idx = r.InsertAutomationItem(self.pointer, pool_id, position, length)
    return AutomationItem:new(self, idx)
end

-- @desc string : constants.AutomationItemInfo
function Envelope:get_ai_info_value(ai_idx, desc)
    return r.GetSetAutomationItemInfo(self.pointer, ai_idx, desc, 0, false)
end

-- @desc string : constants.AutomationItemInfo
-- @value number
function Envelope:set_ai_info_value(ai_idx, desc, value)
    return r.GetSetAutomationItemInfo(self.pointer, ai_idx, desc, value, true)
end

EnvelopePoint = {}

function EnvelopePoint:new(envelope, idx, time, value, shape, tension, selected)
    local o = {
        envelope = envelope,
        idx = idx,
        time = time,
        value = value,
        shape = shape,
        tension = tension,
        selected = selected
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function EnvelopePoint:__tostring()
    return string.format(
            '<EnvelopePoint idx=%s time=%s value=%s shape=%s tension=%s selected=%s>',
            self.idx,
            self.time,
            self.value,
            self.shape,
            self.tension,
            self.selected
    )
end

AutomationItem = {}

-- @envelope envelope.Envelope
-- @idx number
function AutomationItem:new(envelope, idx)
    local o = {
        envelope = envelope,
        idx = idx
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function AutomationItem:get_info_value(desc)
    return self.envelope:get_ai_info_value(self.idx, desc)
end


function AutomationItem:set_info_value(desc, value)
    return self.envelope:set_ai_info_value(self.idx, desc, value)
end

function AutomationItem:get_amplitude()
    return self:get_info_value(AutomationItemInfo.D_AMPLITUDE)
end

function AutomationItem:set_amplitude(value)
    return self:set_info_value(AutomationItemInfo.D_AMPLITUDE, value)
end

envelope.Envelope = Envelope
envelope.EnvelopePoint = EnvelopePoint
envelope.AutomationItem = AutomationItem

return envelope