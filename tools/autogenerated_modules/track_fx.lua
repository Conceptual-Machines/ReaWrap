-- @description Provide implementation for TrackFX functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')
local media_item_take = require('media_item_take')
local media_track = require('media_track')
local rea_project = require('rea_project')


local TrackFX = {}



--- Create new TrackFX instance.
-- @param track MediaTrack. The MediaTrack object
-- @param fx_idx number. The index of the FX
-- @return TrackFX table.
function TrackFX:new(track, fx_idx)
    local obj = {
        track = track, 
        pointer = fx_idx
    }
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
-- @param fx_name string.
-- @param rec_fx boolean.
-- @param instantiate integer.
-- @return integer
function TrackFX:add_by_name(fx_name, rec_fx, instantiate)
    return r.TrackFX_AddByName(self.track.pointer, fx_name, rec_fx, instantiate)
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
-- @param dest_take MediaItemTake.
-- @param dest_fx integer.
-- @param is_move boolean.
function TrackFX:copy_to_take(dest_take, dest_fx, is_move)
    return r.TrackFX_CopyToTake(self.track.pointer, self.pointer, dest_take.pointer, dest_fx, is_move)
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
-- @param dest_track MediaTrack.
-- @param dest_fx integer.
-- @param is_move boolean.
function TrackFX:copy_to_track(dest_track, dest_fx, is_move)
    return r.TrackFX_CopyToTrack(self.track.pointer, self.pointer, dest_track.pointer, dest_fx, is_move)
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
-- @return boolean
function TrackFX:delete()
    return r.TrackFX_Delete(self.track.pointer, self.pointer)
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
-- @param param integer.
-- @return boolean
function TrackFX:end_param_edit(param)
    return r.TrackFX_EndParamEdit(self.track.pointer, self.pointer, param)
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
-- @param param integer.
-- @param val number.
-- @return ret_val boolean
-- @return buf string
function TrackFX:format_param_value(param, val)
    return r.TrackFX_FormatParamValue(self.track.pointer, self.pointer, param, val)
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
-- @param param integer.
-- @param value number.
-- @param buf string.
-- @return ret_val boolean
-- @return buf string
function TrackFX:format_param_value_normalized(param, value, buf)
    return r.TrackFX_FormatParamValueNormalized(self.track.pointer, self.pointer, param, value, buf)
end

    
--- Get Chain Visible.
-- returns index of effect visible in chain, or -1 for chain hidden, or -2 for
-- chain visible but no effect selected
-- @return integer
function TrackFX:get_chain_visible()
    return r.TrackFX_GetChainVisible(self.track.pointer)
end

    
--- Get Count.
-- @return integer
function TrackFX:get_count()
    return r.TrackFX_GetCount(self.track.pointer)
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
-- @return boolean
function TrackFX:get_enabled()
    return r.TrackFX_GetEnabled(self.track.pointer, self.pointer)
end

    
--- Get Eq.
-- Get the index of ReaEQ in the track FX chain. If ReaEQ is not in the chain and
-- instantiate is true, it will be inserted. See TrackFX_GetInstrument,
-- TrackFX_GetByName.
-- @param instantiate boolean.
-- @return integer
function TrackFX:get_eq(instantiate)
    return r.TrackFX_GetEQ(self.track.pointer, instantiate)
end

    
--- Get Eq Band Enabled.
-- Returns true if the EQ band is enabled. Returns false if the band is disabled,
-- or if track/fxidx is not ReaEQ. Bandtype: -1=master gain, 0=hipass, 1=loshelf,
-- 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass. Bandidx
-- (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd
-- band matching bandtype, etc.
-- @param band_type integer.
-- @param band_idx integer.
-- @return boolean
function TrackFX:get_eq_band_enabled(band_type, band_idx)
    return r.TrackFX_GetEQBandEnabled(self.track.pointer, self.pointer, band_type, band_idx)
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
-- @param param_idx integer.
-- @return ret_val boolean
-- @return band_type integer
-- @return band_idx integer
-- @return param_type integer
-- @return norm_val number
function TrackFX:get_eq_param(param_idx)
    return r.TrackFX_GetEQParam(self.track.pointer, self.pointer, param_idx)
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
-- @return HWND
function TrackFX:get_floating_window()
    return r.TrackFX_GetFloatingWindow(self.track.pointer, self.pointer)
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
-- @param param integer.
-- @return ret_val boolean
-- @return buf string
function TrackFX:get_formatted_param_value(param)
    return r.TrackFX_GetFormattedParamValue(self.track.pointer, self.pointer, param)
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
-- @return guid string
function TrackFX:get_fxguid()
    return r.TrackFX_GetFXGUID(self.track.pointer, self.pointer)
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
-- @return ret_val boolean
-- @return buf string
function TrackFX:get_fx_name()
    return r.TrackFX_GetFXName(self.track.pointer, self.pointer)
end

    
--- Get Instrument.
-- Get the index of the first track FX insert that is a virtual instrument, or -1
-- if none. See TrackFX_GetEQ, TrackFX_GetByName.
-- @return integer
function TrackFX:get_instrument()
    return r.TrackFX_GetInstrument(self.track.pointer)
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
-- @return ret_val integer
-- @return input_pins integer
-- @return output_pins integer
function TrackFX:get_io_size()
    return r.TrackFX_GetIOSize(self.track.pointer, self.pointer)
end

    
--- Get Named Config Parm.
-- gets plug-in specific named configuration value (returns true on success).
-- @param parm_name string.
-- @return ret_val boolean
-- @return buf string
function TrackFX:get_named_config_parm(parm_name)
    return r.TrackFX_GetNamedConfigParm(self.track.pointer, self.pointer, parm_name)
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
-- @return integer
function TrackFX:get_num_params()
    return r.TrackFX_GetNumParams(self.track.pointer, self.pointer)
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
-- @return boolean
function TrackFX:get_offline()
    return r.TrackFX_GetOffline(self.track.pointer, self.pointer)
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
-- @return boolean
function TrackFX:get_open()
    return r.TrackFX_GetOpen(self.track.pointer, self.pointer)
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
-- @param param integer.
-- @return ret_val number
-- @return min_val number
-- @return max_val number
function TrackFX:get_param(param)
    return r.TrackFX_GetParam(self.track.pointer, self.pointer, param)
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
-- @param param integer.
-- @return ret_val boolean
-- @return step number
-- @return smallstep number
-- @return largestep number
-- @return is_toggle boolean
function TrackFX:get_parameter_step_sizes(param)
    return r.TrackFX_GetParameterStepSizes(self.track.pointer, self.pointer, param)
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
-- @param param integer.
-- @return ret_val number
-- @return min_val number
-- @return max_val number
-- @return mid_val number
function TrackFX:get_param_ex(param)
    return r.TrackFX_GetParamEx(self.track.pointer, self.pointer, param)
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
-- @param ident_str string.
-- @return integer
function TrackFX:get_param_from_ident(ident_str)
    return r.TrackFX_GetParamFromIdent(self.track.pointer, self.pointer, ident_str)
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
-- @param param integer.
-- @return ret_val boolean
-- @return buf string
function TrackFX:get_param_ident(param)
    return r.TrackFX_GetParamIdent(self.track.pointer, self.pointer, param)
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
-- @param param integer.
-- @return ret_val boolean
-- @return buf string
function TrackFX:get_param_name(param)
    return r.TrackFX_GetParamName(self.track.pointer, self.pointer, param)
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
-- @param param integer.
-- @return number
function TrackFX:get_param_normalized(param)
    return r.TrackFX_GetParamNormalized(self.track.pointer, self.pointer, param)
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
-- @param is_output integer.
-- @param pin integer.
-- @return ret_val integer
-- @return high32 integer
function TrackFX:get_pin_mappings(is_output, pin)
    return r.TrackFX_GetPinMappings(self.track.pointer, self.pointer, is_output, pin)
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
-- @return ret_val boolean
-- @return preset_name string
function TrackFX:get_preset()
    return r.TrackFX_GetPreset(self.track.pointer, self.pointer)
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
-- @return ret_val integer
-- @return number_of_presets integer
function TrackFX:get_preset_index()
    return r.TrackFX_GetPresetIndex(self.track.pointer, self.pointer)
end

    
--- Get Rec Chain Visible.
-- returns index of effect visible in record input chain, or -1 for chain hidden,
-- or -2 for chain visible but no effect selected
-- @return integer
function TrackFX:get_rec_chain_visible()
    return r.TrackFX_GetRecChainVisible(self.track.pointer)
end

    
--- Get Rec Count.
-- returns count of record input FX. To access record input FX, use a FX indices
-- [0x1000000..0x1000000+n). On the master track, this accesses monitoring FX
-- rather than record input FX.
-- @return integer
function TrackFX:get_rec_count()
    return r.TrackFX_GetRecCount(self.track.pointer)
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
-- @return fn string
function TrackFX:get_user_preset_filename()
    return r.TrackFX_GetUserPresetFilename(self.track.pointer, self.pointer)
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
-- @param presetmove integer.
-- @return boolean
function TrackFX:navigate_presets(presetmove)
    return r.TrackFX_NavigatePresets(self.track.pointer, self.pointer, presetmove)
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
-- @param enabled boolean.
function TrackFX:set_enabled(enabled)
    return r.TrackFX_SetEnabled(self.track.pointer, self.pointer, enabled)
end

    
--- Set Eq Band Enabled.
-- Enable or disable a ReaEQ band. Returns false if track/fxidx is not ReaEQ.
-- Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf,
-- 5=lopass, 6=bandpass, 7=parallel bandpass. Bandidx (ignored for master gain):
-- 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc.
-- @param band_type integer.
-- @param band_idx integer.
-- @param enable boolean.
-- @return boolean
function TrackFX:set_eq_band_enabled(band_type, band_idx, enable)
    return r.TrackFX_SetEQBandEnabled(self.track.pointer, self.pointer, band_type, band_idx, enable)
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
-- @param band_type integer.
-- @param band_idx integer.
-- @param param_type integer.
-- @param val number.
-- @param is_norm boolean.
-- @return boolean
function TrackFX:set_eq_param(band_type, band_idx, param_type, val, is_norm)
    return r.TrackFX_SetEQParam(self.track.pointer, self.pointer, band_type, band_idx, param_type, val, is_norm)
end

    
--- Set Named Config Parm.
-- sets plug-in specific named configuration value (returns true on success).
-- @param parm_name string.
-- @param value string.
-- @return boolean
function TrackFX:set_named_config_parm(parm_name, value)
    return r.TrackFX_SetNamedConfigParm(self.track.pointer, self.pointer, parm_name, value)
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
-- @param offline boolean.
function TrackFX:set_offline(offline)
    return r.TrackFX_SetOffline(self.track.pointer, self.pointer, offline)
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
-- @param open boolean.
function TrackFX:set_open(open)
    return r.TrackFX_SetOpen(self.track.pointer, self.pointer, open)
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
-- @param param integer.
-- @param val number.
-- @return boolean
function TrackFX:set_param(param, val)
    return r.TrackFX_SetParam(self.track.pointer, self.pointer, param, val)
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
-- @param param integer.
-- @param value number.
-- @return boolean
function TrackFX:set_param_normalized(param, value)
    return r.TrackFX_SetParamNormalized(self.track.pointer, self.pointer, param, value)
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
-- @param is_output integer.
-- @param pin integer.
-- @param low32bits integer.
-- @param hi32bits integer.
-- @return boolean
function TrackFX:set_pin_mappings(is_output, pin, low32bits, hi32bits)
    return r.TrackFX_SetPinMappings(self.track.pointer, self.pointer, is_output, pin, low32bits, hi32bits)
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
-- @param preset_name string.
-- @return boolean
function TrackFX:set_preset(preset_name)
    return r.TrackFX_SetPreset(self.track.pointer, self.pointer, preset_name)
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
-- @param preset_idx number. The index of the preset
-- @return boolean
function TrackFX:set_preset_by_index(preset_idx)
    return r.TrackFX_SetPresetByIndex(self.track.pointer, self.pointer, preset_idx)
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
-- @param show_flag integer.
function TrackFX:show(show_flag)
    return r.TrackFX_Show(self.track.pointer, self.pointer, show_flag)
end

    
--- Cf Get Chain.
-- Return a handle to the given track FX chain window.
-- @return FxChain
function TrackFX:cf_get_chain()
    return r.CF_GetTrackFXChain(self.track.pointer)
end

    
--- Cf Get Chain Ex.
-- Return a handle to the given track FX chain window. Set wantInputChain to get
-- the track's input/monitoring FX chain.
-- @param project ReaProject.
-- @param track MediaTrack.
-- @param want_input_chain boolean.
-- @return FxChain
function TrackFX:cf_get_chain_ex(project, track, want_input_chain)
    return r.CF_GetTrackFXChainEx(project, track.pointer, want_input_chain)
end

    
--- Cf Select.
-- Set which track effect is active in the track's FX chain. The FX chain window
-- does not have to be open.
-- @return boolean
function TrackFX:cf_select()
    return r.CF_SelectTrackFX(self.track.pointer, self.pointer)
end

return TrackFX
