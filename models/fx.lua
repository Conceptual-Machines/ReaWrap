---@description Provide implementation of TrackFX and TakeFX
---@author NomadMonad

local constants = require('ReaWrap.models.constants')
local helpers = require('ReaWrap.models.helpers')

local r = reaper

local fx = {}

TrackFX = {}

function TrackFX:new(track, idx)
    local o = {
        track = track,
        idx = idx
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function TrackFX:__tostring()
    return string.format(
            '<FX idx=%s, name=%s>',
            self.idx,
            self:get_name()
    )
end

---class logger
function TrackFX:log(...)
    logger = helpers.log_func('TrackFX')
    logger(...)
end


---Delete FX
function TrackFX:delete()
    r.TrackFX_Delete(self.track.pointer, self.idx)
end


---Get FX Name
---@return string
function TrackFX:get_name()
    local retval, name = r.TrackFX_GetFXName(self.track.pointer, self.idx, '')
    if retval then
        return name
    else
        return nil
    end
end


---Whether FX is enabled
---@return boolean
function TrackFX:is_enabled()
    return r.TrackFX_GetEnabled(self.track.pointer, self.idx)
end


---Whether FX is offline
---@return boolean
function TrackFX:is_offline()
    return r.TrackFX_GetOffline(self.track.pointer, self.idx)
end


---Whether FX is a virtual instrument
---@return boolean
function TrackFX:is_instrument()
    local inst_idx = r.TrackFX_GetInstrument(self.track.pointer)
    if inst_idx == -1 then
        return false
    elseif inst_idx == self.idx then
        return true
    end
    local patterns = { 'VSTi', 'VST3i', 'AUi' }
    local name = self:get_name()
    if name ~= nil then
        for _, p in pairs(patterns) do
            if name:find(p) then
                return true
            end
        end
    end
    return false
end


---Set FX Enable
function TrackFX:set_enabled(enabled)
    r.TrackFX_SetEnabled(self.track.pointer, self.idx, enabled)
end


---Enable FX
function TrackFX:enable()
    self:set_enabled(true)
end


---Disable FX
function TrackFX:disable()
    self:set_enabled(false)
end


---FX globally unique identifier
---@return string
function TrackFX:GUID()
    return r.TrackFX_GetFXGUID(self.track.pointer, self.idx)
end


---Set FX key-value store
function TrackFX:set_key_value(key, value, persist)
    r.SetExtState(self:GUID(), key, value, persist)
end


--Get FX key-value store
--@key string
function TrackFX:get_key_value(key)
    return r.GetExtState(self:GUID(), key)
end


--Copy FX to track
--@dest_track Track
--@dest_index number
function TrackFX:copy_to_track(dest_track, dest_index)
    r.TrackFX_CopyToTrack(self.track.pointer, self.idx, dest_track.pointer, dest_index, false)
end


---Move FX to track
function TrackFX:move_to_track(dest_track, dest_index)
    r.TrackFX_CopyToTrack(self.track.pointer, self.idx, dest_track.pointer, dest_index, true)
end


---Delete FX from track
function TrackFX:delete()
    r.TrackFX_Delete(self.track.pointer, self.idx)
end

function TrackFX:get_num_params()
    return r.TrackFX_GetNumParams(self.track.pointer, self.idx)
end


function TrackFX:get_param_name(param_idx)
    local retval, buf = r.TrackFX_GetParamName(
            self.track.pointer, self.idx, param_idx, ''
    )
    if retval then
        return buf
    end
end

function TrackFX:get_param_range(param_idx)
    local retval, minval, maxval, midval = reaper.TrackFX_GetParamEx(
            self.track.pointer, self.idx, param_idx
    )
    if retval then
        return minval, midval, maxval
    end
end

function TrackFX:get_param_value(param_idx)
     return r.TrackFX_GetParamNormalized(self.track.pointer, self.idx, param_idx)
end

function TrackFX:get_param_step_size(param_idx)
     local retval, step, small, large, is_toggle = r.TrackFX_GetParameterStepSizes(
             self.track.pointer, self.idx, param_idx
     )
    if retval then
        return { step, small, large }
    else
        return {}
    end
end

function TrackFX:get_params()
    local params = {}
    for i = 0, self:get_num_params() do
        local param = FXParam:new(self, i)
        params[i + 1] = param
    end
    return params
end

function TrackFX:iter_params()
    return helpers.iter(self:get_params())
end

function TrackFX:get_named_config_params(param)
    local retval, buf = r.TrackFX_GetNamedConfigParm(self.track.pointer, self.idx, param)
    if retval then
        return buf
    end
end

function TrackFX:get_pdc_latency()
    return self:get_named_config_params('pdc')
end

---Get the number of input/output pins for FX. Returns nil if not available.
--@return number, number
function TrackFX:get_io_size()
    local retval, input_pins, output_pins = r.TrackFX_GetIOSize(self.track.pointer, self.idx)
    if retval then
        return input_pins, output_pins
    end
end

---Whether TrackFX has inputs
function TrackFX:has_inputs()
    local input_pins, output_pins = self:get_io_size()
    return input_pins ~= 0
end

---gets the effective channel mapping bitmask for a particular pin.
---high32OutOptional will be set to the high 32 bits
function TrackFX:get_pin_mappings(io, pin)
    local io_map = {
        i = 0,
        o = 1
    }
    local bitmask = r.TrackFX_GetPinMappings(
            self.track.pointer, self.idx, io_map[io], pin
    )
    return Binary:from_decimal(bitmask)
end

function TrackFX:get_input_pins()
    local ins, _ = self:get_io_size()
    local pins = {}
    for i = 0, ins - 1 do
        pins[i + 1] = InputPin:new(self, i)
    end
    return pins
end

function TrackFX:get_output_pins()
    local _, outs = self:get_io_size()
    local pins = {}
    for i = 0, outs - 1 do
        pins[i + 1] = OutputPin:new(self, i)
    end
    return pins
end

function TrackFX:iter_input_pins()
    return helpers.iter(self:get_input_pins())
end

function TrackFX:iter_output_pins()
    return helpers.iter(self:get_output_pins())
end

---Show/Hide FX chain and floating window
---@flag number : Accepted values : constants.TrackFXShowFlags
function TrackFX:show(flag)
    r.TrackFX_Show(self.track.pointer, self.idx, flag)
end


--[[
    Adds or queries the position of a named FX from the track FX chain (recFX=false)
    or record input FX/monitoring FX (recFX=true, monitoring FX are on master track).
    Specify a negative value for instantiate to always create a new effect,
    0 to only query the first instance of an effect,
    or a positive value to add an instance if one is not found.
    If instantiate is <= -1000, it is used for the insertion position
    (-1000 is first item in chain, -1001 is second, etc).
    FX name can have prefix to specify type: VST3:,VST2:,VST:,AU:,JS:, or DX:,
    or FXADD: which adds selected items from the currently-open FX browser,
    FXADD:2 to limit to 2 FX added, or
    FXADD:2e to only succeed if exactly 2 FX are selected.
    Returns -1 on failure or the new position in chain on success.

    @fxname string
    @rec_fx Whether FX is monitoring FX
--]]
function TrackFX:add_by_name(fx_name, rec_fx, instantiate)
     return r.TrackFX_AddByName(self.track.pointer, fx_name, rec_fx, instantiate)
end


InputPin = {}

function InputPin:new(fx, idx)
    local o = {
        fx = fx,
        idx = idx
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function InputPin:__tostring()
    return string.format(
            '<InputPin name=%s idx=%s>',
            self:get_name(),
            self.idx
    )
end

function InputPin:get_name()
    param = 'in_pin_' .. tostring(self.idx)
    return self.fx:get_named_config_params(param)
end

function InputPin:get_mappings()
    return self.fx:get_pin_mappings('i', self.idx)
end

OutputPin = {}

function OutputPin:new(fx, idx)
    local o = {
        fx = fx,
        idx = idx
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function OutputPin:__tostring()
    return string.format(
            '<OutputPin name=%s idx=%s>',
            self:get_name(),
            self.idx
    )
end

function OutputPin:get_name()
    param = 'out_pin_' .. tostring(self.idx)
    return self.fx:get_named_config_params(param)
end

function OutputPin:get_mappings()
    return self.fx:get_pin_mappings('o', self.idx)
end

FXParam = {}

function FXParam:new(fx, idx)
    local o = {
        fx = fx,
        idx = idx
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function FXParam:__tostring()
    return string.format(
            '<FXParam name=%s idx=%s>',
            self:get_name(),
            self.idx
    )
end

function FXParam:get_name()
    return self.fx:get_param_name(self.idx)
end

function FXParam:get_range()
    return self.fx:get_param_ex(self.idx)
end

function FXParam:get_value()
    return self.fx:get_param_value(self.idx)
end

function FXParam:get_step_size()
    return self.fx:get_param_step_size(self.idx)
end

fx.TrackFX = TrackFX
fx.InputPin = InputPin
fx.OutputPin = OutputPin
fx.FXParam = FXParam

return fx