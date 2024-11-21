-- @description TrackFX: Provide implementation for TrackFX functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_item_take = require('media_item_take')
local media_track = require('media_track')


local TrackFX = {}



--- Create new TrackFX instance.
-- @return TrackFX table.
function TrackFX:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the TrackFX logger.
-- @param ... (varargs) Messages to log.
function TrackFX:log(...)
    local logger = helpers.log_func('TrackFX')
    logger(...)
    return nil
end

    
--- Add By Name.
-- Adds or queries the position of a named FX from the track FX chain (recFX=false)
-- or record input FX/monitoring FX (recFX=true, monitoring FX are on master
-- track). Specify a negative value for instantiate to always create a new effect,
-- 0 to only query the first instance of an effect, or a positive value to add an
-- instance if one is not found. If instantiate is <= -1000, it is used for the
-- insertion position (-1000 is first item in chain, -1001 is second, etc). fxname
-- can have prefix to specify type: VST3:,VST2:,VST:,AU:,JS:, or DX:, or FXADD:
-- which adds selected items from the currently-open FX browser, FXADD:2 to limit
-- to 2 FX added, or FXADD:2e to only succeed if exactly 2 FX are selected. Returns
-- -1 on failure or the new position in chain on success. FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fxname string
-- @param rec_fx boolean
-- @param instantiate integer
-- @return integer
function TrackFX:add_by_name(fxname, rec_fx, instantiate)
    return r.TrackFX_AddByName(self.pointer, fxname, rec_fx, instantiate)
end

    
--- Copy To Take.
-- Copies (or moves) FX from src_track to dest_take. src_fx can have 0x1000000 set
-- to reference input FX. FX indices for tracks can have 0x1000000 added to them in
-- order to reference record input FX (normal tracks) or hardware output FX (master
-- track). FX indices can have 0x2000000 added to them, in which case they will be
-- used to address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param src_fx integer
-- @param dest_fx integer
-- @param is__move boolean
function TrackFX:copy_to_take(src_fx, dest_fx, is__move)
    return r.TrackFX_CopyToTake(self.pointer, src_fx, dest_take, dest_fx, is__move)
end

    
--- Copy To Track.
-- Copies (or moves) FX from src_track to dest_track. Can be used with
-- src_track=dest_track to reorder, FX indices have 0x1000000 set to reference
-- input FX. FX indices for tracks can have 0x1000000 added to them in order to
-- reference record input FX (normal tracks) or hardware output FX (master track).
-- FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param src_fx integer
-- @param dest_fx integer
-- @param is__move boolean
function TrackFX:copy_to_track(src_fx, dest_fx, is__move)
    return r.TrackFX_CopyToTrack(self.pointer, src_fx, dest_track, dest_fx, is__move)
end

    
--- Delete.
-- Remove a FX from track chain (returns true on success) FX indices for tracks can
-- have 0x1000000 added to them in order to reference record input FX (normal
-- tracks) or hardware output FX (master track). FX indices can have 0x2000000
-- added to them, in which case they will be used to address FX in containers. To
-- address a container, the 1-based subitem is multiplied by one plus the count of
-- the FX chain and added to the 1-based container item index. e.g. to address the
-- third item in the container at the second position of the track FX chain for tr,
-- the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be
-- extended to sub-containers using TrackFX_GetNamedConfigParm with container_count
-- and similar logic. In REAPER v7.06+, you can use the much more convenient method
-- to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container
-- and container_item.X.
-- @param fx integer
-- @return boolean
function TrackFX:delete(fx)
    return r.TrackFX_Delete(self.pointer, fx)
end

    
--- End Param Edit.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @return boolean
function TrackFX:end_param_edit(fx, param)
    return r.TrackFX_EndParamEdit(self.pointer, fx, param)
end

    
--- Format Param Value.
-- Note: only works with FX that support Cockos VST extensions. FX indices for
-- tracks can have 0x1000000 added to them in order to reference record input FX
-- (normal tracks) or hardware output FX (master track). FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @param val number
-- @return buf string
function TrackFX:format_param_value(fx, param, val)
    local retval, buf = r.TrackFX_FormatParamValue(self.pointer, fx, param, val)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Format Param Value Normalized.
-- Note: only works with FX that support Cockos VST extensions. FX indices for
-- tracks can have 0x1000000 added to them in order to reference record input FX
-- (normal tracks) or hardware output FX (master track). FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @param value number
-- @param buf string
-- @return buf string
function TrackFX:format_param_value_normalized(fx, param, value, buf)
    local retval, buf = r.TrackFX_FormatParamValueNormalized(self.pointer, fx, param, value, buf)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Chain Visible.
-- returns index of effect visible in chain, or -1 for chain hidden, or -2 for
-- chain visible but no effect selected
-- @return integer
function TrackFX:get_chain_visible()
    return r.TrackFX_GetChainVisible(self.pointer)
end

    
--- Get Count.
-- @return integer
function TrackFX:get_count()
    return r.TrackFX_GetCount(self.pointer)
end

    
--- Get Enabled.
-- See TrackFX_SetEnabled FX indices for tracks can have 0x1000000 added to them in
-- order to reference record input FX (normal tracks) or hardware output FX (master
-- track). FX indices can have 0x2000000 added to them, in which case they will be
-- used to address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer
-- @return boolean
function TrackFX:get_enabled(fx)
    return r.TrackFX_GetEnabled(self.pointer, fx)
end

    
--- Get Eq.
-- Get the index of ReaEQ in the track FX chain. If ReaEQ is not in the chain and
-- instantiate is true, it will be inserted. See TrackFX_GetInstrument,
-- TrackFX_GetByName.
-- @param instantiate boolean
-- @return integer
function TrackFX:get_eq(instantiate)
    return r.TrackFX_GetEQ(self.pointer, instantiate)
end

    
--- Get Eq Band Enabled.
-- Returns true if the EQ band is enabled. Returns false if the band is disabled,
-- or if track/fxidx is not ReaEQ. Bandtype: -1=master gain, 0=hipass, 1=loshelf,
-- 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass. Bandidx
-- (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd
-- band matching bandtype, etc.
-- @param fx_idx integer
-- @param bandtype integer
-- @param band_idx integer
-- @return boolean
function TrackFX:get_eq_band_enabled(fx_idx, bandtype, band_idx)
    return r.TrackFX_GetEQBandEnabled(self.pointer, fx_idx, bandtype, band_idx)
end

    
--- Get Eq Param.
-- Returns false if track/fxidx is not ReaEQ. Bandtype: -1=master gain, 0=hipass,
-- 1=loshelf, 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel
-- bandpass. Bandidx (ignored for master gain): 0=target first band matching
-- bandtype, 1=target 2nd band matching bandtype, etc. Paramtype (ignored for
-- master gain): 0=freq, 1=gain, 2=Q. See TrackFX_GetEQ, TrackFX_SetEQParam,
-- TrackFX_GetEQBandEnabled, TrackFX_SetEQBandEnabled. FX indices for tracks can
-- have 0x1000000 added to them in order to reference record input FX (normal
-- tracks) or hardware output FX (master track). FX indices can have 0x2000000
-- added to them, in which case they will be used to address FX in containers. To
-- address a container, the 1-based subitem is multiplied by one plus the count of
-- the FX chain and added to the 1-based container item index. e.g. to address the
-- third item in the container at the second position of the track FX chain for tr,
-- the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be
-- extended to sub-containers using TrackFX_GetNamedConfigParm with container_count
-- and similar logic. In REAPER v7.06+, you can use the much more convenient method
-- to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container
-- and container_item.X.
-- @param fx_idx integer
-- @param param_idx integer
-- @return bandtype integer
-- @return band_idx integer
-- @return paramtype integer
-- @return normval number
function TrackFX:get_eq_param(fx_idx, param_idx)
    local retval, bandtype, band_idx, paramtype, normval = r.TrackFX_GetEQParam(self.pointer, fx_idx, param_idx)
    if retval then
        return bandtype, band_idx, paramtype, normval
    else
        return nil
    end
end

    
--- Get Floating Window.
-- returns HWND of floating window for effect index, if any FX indices for tracks
-- can have 0x1000000 added to them in order to reference record input FX (normal
-- tracks) or hardware output FX (master track). FX indices can have 0x2000000
-- added to them, in which case they will be used to address FX in containers. To
-- address a container, the 1-based subitem is multiplied by one plus the count of
-- the FX chain and added to the 1-based container item index. e.g. to address the
-- third item in the container at the second position of the track FX chain for tr,
-- the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be
-- extended to sub-containers using TrackFX_GetNamedConfigParm with container_count
-- and similar logic. In REAPER v7.06+, you can use the much more convenient method
-- to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container
-- and container_item.X.
-- @param index integer
-- @return HWND table
function TrackFX:get_floating_window(index)
    local result = r.TrackFX_GetFloatingWindow(self.pointer, index)
    return hwnd.HWND:new(result)
end

    
--- Get Formatted Param Value.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @return buf string
function TrackFX:get_formatted_param_value(fx, param)
    local retval, buf = r.TrackFX_GetFormattedParamValue(self.pointer, fx, param)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Fxguid.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @return guid string
function TrackFX:get_fxguid(fx)
    return r.TrackFX_GetFXGUID(self.pointer, fx)
end

    
--- Get Fx Name.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @return buf string
function TrackFX:get_fx_name(fx)
    local retval, buf = r.TrackFX_GetFXName(self.pointer, fx)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Instrument.
-- Get the index of the first track FX insert that is a virtual instrument, or -1
-- if none. See TrackFX_GetEQ, TrackFX_GetByName.
-- @return integer
function TrackFX:get_instrument()
    return r.TrackFX_GetInstrument(self.pointer)
end

    
--- Get Io Size.
-- Gets the number of input/output pins for FX if available, returns plug-in type
-- or -1 on error FX indices for tracks can have 0x1000000 added to them in order
-- to reference record input FX (normal tracks) or hardware output FX (master
-- track). FX indices can have 0x2000000 added to them, in which case they will be
-- used to address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer
-- @return input_pins integer
-- @return output_pins integer
function TrackFX:get_io_size(fx)
    local retval, input_pins, output_pins = r.TrackFX_GetIOSize(self.pointer, fx)
    if retval then
        return input_pins, output_pins
    else
        return nil
    end
end

    
--- Get Named Config Parm.
-- gets plug-in specific named configuration value (returns true on success).
-- @param fx integer
-- @param parmname string
-- @return buf string
function TrackFX:get_named_config_parm(fx, parmname)
    local retval, buf = r.TrackFX_GetNamedConfigParm(self.pointer, fx, parmname)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Num Params.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @return integer
function TrackFX:get_num_params(fx)
    return r.TrackFX_GetNumParams(self.pointer, fx)
end

    
--- Get Offline.
-- See TrackFX_SetOffline FX indices for tracks can have 0x1000000 added to them in
-- order to reference record input FX (normal tracks) or hardware output FX (master
-- track). FX indices can have 0x2000000 added to them, in which case they will be
-- used to address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer
-- @return boolean
function TrackFX:get_offline(fx)
    return r.TrackFX_GetOffline(self.pointer, fx)
end

    
--- Get Open.
-- Returns true if this FX UI is open in the FX chain window or a floating window.
-- See TrackFX_SetOpen FX indices for tracks can have 0x1000000 added to them in
-- order to reference record input FX (normal tracks) or hardware output FX (master
-- track). FX indices can have 0x2000000 added to them, in which case they will be
-- used to address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer
-- @return boolean
function TrackFX:get_open(fx)
    return r.TrackFX_GetOpen(self.pointer, fx)
end

    
--- Get Param.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @return minval number
-- @return maxval number
function TrackFX:get_param(fx, param)
    local retval, minval, maxval = r.TrackFX_GetParam(self.pointer, fx, param)
    if retval then
        return minval, maxval
    else
        return nil
    end
end

    
--- Get Parameter Step Sizes.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @return step number
-- @return smallstep number
-- @return largestep number
-- @return is_toggle boolean
function TrackFX:get_parameter_step_sizes(fx, param)
    local retval, step, smallstep, largestep, is_toggle = r.TrackFX_GetParameterStepSizes(self.pointer, fx, param)
    if retval then
        return step, smallstep, largestep, is_toggle
    else
        return nil
    end
end

    
--- Get Param Ex.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @return minval number
-- @return maxval number
-- @return midval number
function TrackFX:get_param_ex(fx, param)
    local retval, minval, maxval, midval = r.TrackFX_GetParamEx(self.pointer, fx, param)
    if retval then
        return minval, maxval, midval
    else
        return nil
    end
end

    
--- Get Param From Ident.
-- gets the parameter index from an identifying string (:wet, :bypass, :delta, or a
-- string returned from GetParamIdent), or -1 if unknown. FX indices for tracks can
-- have 0x1000000 added to them in order to reference record input FX (normal
-- tracks) or hardware output FX (master track). FX indices can have 0x2000000
-- added to them, in which case they will be used to address FX in containers. To
-- address a container, the 1-based subitem is multiplied by one plus the count of
-- the FX chain and added to the 1-based container item index. e.g. to address the
-- third item in the container at the second position of the track FX chain for tr,
-- the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be
-- extended to sub-containers using TrackFX_GetNamedConfigParm with container_count
-- and similar logic. In REAPER v7.06+, you can use the much more convenient method
-- to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container
-- and container_item.X.
-- @param fx integer
-- @param ident_str string
-- @return integer
function TrackFX:get_param_from_ident(fx, ident_str)
    return r.TrackFX_GetParamFromIdent(self.pointer, fx, ident_str)
end

    
--- Get Param Ident.
-- gets an identifying string for the parameter FX indices for tracks can have
-- 0x1000000 added to them in order to reference record input FX (normal tracks) or
-- hardware output FX (master track). FX indices can have 0x2000000 added to them,
-- in which case they will be used to address FX in containers. To address a
-- container, the 1-based subitem is multiplied by one plus the count of the FX
-- chain and added to the 1-based container item index. e.g. to address the third
-- item in the container at the second position of the track FX chain for tr, the
-- index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended
-- to sub-containers using TrackFX_GetNamedConfigParm with container_count and
-- similar logic. In REAPER v7.06+, you can use the much more convenient method to
-- navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer
-- @param param integer
-- @return buf string
function TrackFX:get_param_ident(fx, param)
    local retval, buf = r.TrackFX_GetParamIdent(self.pointer, fx, param)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Param Name.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @return buf string
function TrackFX:get_param_name(fx, param)
    local retval, buf = r.TrackFX_GetParamName(self.pointer, fx, param)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- Get Param Normalized.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @return number
function TrackFX:get_param_normalized(fx, param)
    return r.TrackFX_GetParamNormalized(self.pointer, fx, param)
end

    
--- Get Pin Mappings.
-- gets the effective channel mapping bitmask for a particular pin. high32Out will
-- be set to the high 32 bits. Add 0x1000000 to pin index in order to access the
-- second 64 bits of mappings independent of the first 64 bits. FX indices for
-- tracks can have 0x1000000 added to them in order to reference record input FX
-- (normal tracks) or hardware output FX (master track). FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param is_output integer
-- @param pin integer
-- @return high32 integer
function TrackFX:get_pin_mappings(fx, is_output, pin)
    local retval, high32 = r.TrackFX_GetPinMappings(self.pointer, fx, is_output, pin)
    if retval then
        return high32
    else
        return nil
    end
end

    
--- Get Preset.
-- Get the name of the preset currently showing in the REAPER dropdown, or the full
-- path to a factory preset file for VST3 plug-ins (.vstpreset). See
-- TrackFX_SetPreset. FX indices for tracks can have 0x1000000 added to them in
-- order to reference record input FX (normal tracks) or hardware output FX (master
-- track). FX indices can have 0x2000000 added to them, in which case they will be
-- used to address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer
-- @return presetname string
function TrackFX:get_preset(fx)
    local retval, presetname = r.TrackFX_GetPreset(self.pointer, fx)
    if retval then
        return presetname
    else
        return nil
    end
end

    
--- Get Preset Index.
-- Returns current preset index, or -1 if error. numberOfPresetsOut will be set to
-- total number of presets available. See TrackFX_SetPresetByIndex FX indices for
-- tracks can have 0x1000000 added to them in order to reference record input FX
-- (normal tracks) or hardware output FX (master track). FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @return number_of_presets integer
function TrackFX:get_preset_index(fx)
    local retval, number_of_presets = r.TrackFX_GetPresetIndex(self.pointer, fx)
    if retval then
        return number_of_presets
    else
        return nil
    end
end

    
--- Get Rec Chain Visible.
-- returns index of effect visible in record input chain, or -1 for chain hidden,
-- or -2 for chain visible but no effect selected
-- @return integer
function TrackFX:get_rec_chain_visible()
    return r.TrackFX_GetRecChainVisible(self.pointer)
end

    
--- Get Rec Count.
-- returns count of record input FX. To access record input FX, use a FX indices
-- [0x1000000..0x1000000+n). On the master track, this accesses monitoring FX
-- rather than record input FX.
-- @return integer
function TrackFX:get_rec_count()
    return r.TrackFX_GetRecCount(self.pointer)
end

    
--- Get User Preset Filename.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @return fn string
function TrackFX:get_user_preset_filename(fx)
    return r.TrackFX_GetUserPresetFilename(self.pointer, fx)
end

    
--- Navigate Presets.
-- presetmove==1 activates the next preset, presetmove==-1 activates the previous
-- preset, etc. FX indices for tracks can have 0x1000000 added to them in order to
-- reference record input FX (normal tracks) or hardware output FX (master track).
-- FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer
-- @param presetmove integer
-- @return boolean
function TrackFX:navigate_presets(fx, presetmove)
    return r.TrackFX_NavigatePresets(self.pointer, fx, presetmove)
end

    
--- Set Enabled.
-- See TrackFX_GetEnabled FX indices for tracks can have 0x1000000 added to them in
-- order to reference record input FX (normal tracks) or hardware output FX (master
-- track). FX indices can have 0x2000000 added to them, in which case they will be
-- used to address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer
-- @param enabled boolean
function TrackFX:set_enabled(fx, enabled)
    return r.TrackFX_SetEnabled(self.pointer, fx, enabled)
end

    
--- Set Eq Band Enabled.
-- Enable or disable a ReaEQ band. Returns false if track/fxidx is not ReaEQ.
-- Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf,
-- 5=lopass, 6=bandpass, 7=parallel bandpass. Bandidx (ignored for master gain):
-- 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc.
-- @param fx_idx integer
-- @param bandtype integer
-- @param band_idx integer
-- @param enable boolean
-- @return boolean
function TrackFX:set_eq_band_enabled(fx_idx, bandtype, band_idx, enable)
    return r.TrackFX_SetEQBandEnabled(self.pointer, fx_idx, bandtype, band_idx, enable)
end

    
--- Set Eq Param.
-- Returns false if track/fxidx is not ReaEQ. Targets a band matching bandtype.
-- Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf,
-- 5=lopass, 6=bandpass, 7=parallel bandpass. Bandidx (ignored for master gain):
-- 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc.
-- Paramtype (ignored for master gain): 0=freq, 1=gain, 2=Q. See TrackFX_GetEQ,
-- TrackFX_GetEQParam, TrackFX_GetEQBandEnabled, TrackFX_SetEQBandEnabled. FX
-- indices for tracks can have 0x1000000 added to them in order to reference record
-- input FX (normal tracks) or hardware output FX (master track). FX indices can
-- have 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx_idx integer
-- @param bandtype integer
-- @param band_idx integer
-- @param paramtype integer
-- @param val number
-- @param is_norm boolean
-- @return boolean
function TrackFX:set_eq_param(fx_idx, bandtype, band_idx, paramtype, val, is_norm)
    return r.TrackFX_SetEQParam(self.pointer, fx_idx, bandtype, band_idx, paramtype, val, is_norm)
end

    
--- Set Named Config Parm.
-- sets plug-in specific named configuration value (returns true on success).
-- @param fx integer
-- @param parmname string
-- @param value string
-- @return boolean
function TrackFX:set_named_config_parm(fx, parmname, value)
    return r.TrackFX_SetNamedConfigParm(self.pointer, fx, parmname, value)
end

    
--- Set Offline.
-- See TrackFX_GetOffline FX indices for tracks can have 0x1000000 added to them in
-- order to reference record input FX (normal tracks) or hardware output FX (master
-- track). FX indices can have 0x2000000 added to them, in which case they will be
-- used to address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer
-- @param offline boolean
function TrackFX:set_offline(fx, offline)
    return r.TrackFX_SetOffline(self.pointer, fx, offline)
end

    
--- Set Open.
-- Open this FX UI. See TrackFX_GetOpen FX indices for tracks can have 0x1000000
-- added to them in order to reference record input FX (normal tracks) or hardware
-- output FX (master track). FX indices can have 0x2000000 added to them, in which
-- case they will be used to address FX in containers. To address a container, the
-- 1-based subitem is multiplied by one plus the count of the FX chain and added to
-- the 1-based container item index. e.g. to address the third item in the
-- container at the second position of the track FX chain for tr, the index would
-- be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-
-- containers using TrackFX_GetNamedConfigParm with container_count and similar
-- logic. In REAPER v7.06+, you can use the much more convenient method to navigate
-- hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer
-- @param open boolean
function TrackFX:set_open(fx, open)
    return r.TrackFX_SetOpen(self.pointer, fx, open)
end

    
--- Set Param.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @param val number
-- @return boolean
function TrackFX:set_param(fx, param, val)
    return r.TrackFX_SetParam(self.pointer, fx, param, val)
end

    
--- Set Param Normalized.
--  FX indices for tracks can have 0x1000000 added to them in order to reference
-- record input FX (normal tracks) or hardware output FX (master track). FX indices
-- can have 0x2000000 added to them, in which case they will be used to address FX
-- in containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param param integer
-- @param value number
-- @return boolean
function TrackFX:set_param_normalized(fx, param, value)
    return r.TrackFX_SetParamNormalized(self.pointer, fx, param, value)
end

    
--- Set Pin Mappings.
-- sets the channel mapping bitmask for a particular pin. returns false if
-- unsupported (not all types of plug-ins support this capability). Add 0x1000000
-- to pin index in order to access the second 64 bits of mappings independent of
-- the first 64 bits. FX indices for tracks can have 0x1000000 added to them in
-- order to reference record input FX (normal tracks) or hardware output FX (master
-- track). FX indices can have 0x2000000 added to them, in which case they will be
-- used to address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer
-- @param is_output integer
-- @param pin integer
-- @param low32bits integer
-- @param hi32bits integer
-- @return boolean
function TrackFX:set_pin_mappings(fx, is_output, pin, low32bits, hi32bits)
    return r.TrackFX_SetPinMappings(self.pointer, fx, is_output, pin, low32bits, hi32bits)
end

    
--- Set Preset.
-- Activate a preset with the name shown in the REAPER dropdown. Full paths to
-- .vstpreset files are also supported for VST3 plug-ins. See TrackFX_GetPreset. FX
-- indices for tracks can have 0x1000000 added to them in order to reference record
-- input FX (normal tracks) or hardware output FX (master track). FX indices can
-- have 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param presetname string
-- @return boolean
function TrackFX:set_preset(fx, presetname)
    return r.TrackFX_SetPreset(self.pointer, fx, presetname)
end

    
--- Set Preset By Index.
-- Sets the preset idx, or the factory preset (idx==-2), or the default user preset
-- (idx==-1). Returns true on success. See TrackFX_GetPresetIndex. FX indices for
-- tracks can have 0x1000000 added to them in order to reference record input FX
-- (normal tracks) or hardware output FX (master track). FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer
-- @param _idx integer
-- @return boolean
function TrackFX:set_preset_by_index(fx, _idx)
    return r.TrackFX_SetPresetByIndex(self.pointer, fx, _idx)
end

    
--- Show.
-- showflag=0 for hidechain, =1 for show chain(index valid), =2 for hide floating
-- window(index valid), =3 for show floating window (index valid) FX indices for
-- tracks can have 0x1000000 added to them in order to reference record input FX
-- (normal tracks) or hardware output FX (master track). FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param index integer
-- @param show_flag integer
function TrackFX:show(index, show_flag)
    return r.TrackFX_Show(self.pointer, index, show_flag)
end

return TrackFX
