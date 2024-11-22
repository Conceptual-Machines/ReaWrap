-- @description Provide implementation for TakeFX functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')
local media_item_take = require('media_item_take')
local media_track = require('media_track')


local TakeFX = {}



--- Create new TakeFX instance.
-- @param take MediaItemTake. The MediaItemTake object
-- @param fx_idx number. The index of the FX
-- @return TakeFX table.
function TakeFX:new(take, fx_idx)
    local obj = {
        take = take, 
        pointer = fx_idx
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the TakeFX logger.
-- @param ... (varargs) Messages to log.
function TakeFX:log(...)
    local logger = helpers.log_func('TakeFX')
    logger(...)
    return nil
end

    
--- Add By Name.
-- Adds or queries the position of a named FX in a take. See TrackFX_AddByName()
-- for information on fxname and instantiate. FX indices can have 0x2000000 added
-- to them, in which case they will be used to address FX in containers. To address
-- a container, the 1-based subitem is multiplied by one plus the count of the FX
-- chain and added to the 1-based container item index. e.g. to address the third
-- item in the container at the second position of the track FX chain for tr, the
-- index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended
-- to sub-containers using TrackFX_GetNamedConfigParm with container_count and
-- similar logic. In REAPER v7.06+, you can use the much more convenient method to
-- navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx_name string.
-- @param instantiate integer.
-- @return integer
function TakeFX:add_by_name(fx_name, instantiate)
    return r.TakeFX_AddByName(self.take.pointer, fx_name, instantiate)
end

    
--- Copy To Take.
-- Copies (or moves) FX from src_take to dest_take. Can be used with
-- src_take=dest_take to reorder. FX indices can have 0x2000000 added to them, in
-- which case they will be used to address FX in containers. To address a
-- container, the 1-based subitem is multiplied by one plus the count of the FX
-- chain and added to the 1-based container item index. e.g. to address the third
-- item in the container at the second position of the track FX chain for tr, the
-- index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended
-- to sub-containers using TrackFX_GetNamedConfigParm with container_count and
-- similar logic. In REAPER v7.06+, you can use the much more convenient method to
-- navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param dest_take MediaItemTake.
-- @param dest_fx integer.
-- @param is_move boolean.
function TakeFX:copy_to_take(dest_take, dest_fx, is_move)
    return r.TakeFX_CopyToTake(self.take.pointer, self.pointer, dest_take.pointer, dest_fx, is_move)
end

    
--- Copy To Track.
-- Copies (or moves) FX from src_take to dest_track. dest_fx can have 0x1000000 set
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
-- @param dest_track MediaTrack.
-- @param dest_fx integer.
-- @param is_move boolean.
function TakeFX:copy_to_track(dest_track, dest_fx, is_move)
    return r.TakeFX_CopyToTrack(self.take.pointer, self.pointer, dest_track.pointer, dest_fx, is_move)
end

    
--- Delete.
-- Remove a FX from take chain (returns true on success) FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer.
-- @return boolean
function TakeFX:delete(fx)
    return r.TakeFX_Delete(self.take.pointer, fx)
end

    
--- End Param Edit.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @return boolean
function TakeFX:end_param_edit(fx, param)
    return r.TakeFX_EndParamEdit(self.take.pointer, fx, param)
end

    
--- Format Param Value.
-- Note: only works with FX that support Cockos VST extensions. FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @param val number.
-- @return ret_val boolean
-- @return buf string
function TakeFX:format_param_value(fx, param, val)
    return r.TakeFX_FormatParamValue(self.take.pointer, fx, param, val)
end

    
--- Format Param Value Normalized.
-- Note: only works with FX that support Cockos VST extensions. FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @param value number.
-- @param buf string.
-- @return ret_val boolean
-- @return buf string
function TakeFX:format_param_value_normalized(fx, param, value, buf)
    return r.TakeFX_FormatParamValueNormalized(self.take.pointer, fx, param, value, buf)
end

    
--- Get Chain Visible.
-- returns index of effect visible in chain, or -1 for chain hidden, or -2 for
-- chain visible but no effect selected
-- @return integer
function TakeFX:get_chain_visible()
    return r.TakeFX_GetChainVisible(self.take.pointer)
end

    
--- Get Count.
-- @return integer
function TakeFX:get_count()
    return r.TakeFX_GetCount(self.take.pointer)
end

    
--- Get Enabled.
-- See TakeFX_SetEnabled FX indices can have 0x2000000 added to them, in which case
-- they will be used to address FX in containers. To address a container, the
-- 1-based subitem is multiplied by one plus the count of the FX chain and added to
-- the 1-based container item index. e.g. to address the third item in the
-- container at the second position of the track FX chain for tr, the index would
-- be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-
-- containers using TrackFX_GetNamedConfigParm with container_count and similar
-- logic. In REAPER v7.06+, you can use the much more convenient method to navigate
-- hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @return boolean
function TakeFX:get_enabled(fx)
    return r.TakeFX_GetEnabled(self.take.pointer, fx)
end

    
--- Get Envelope.
-- Returns the FX parameter envelope. If the envelope does not exist and
-- create=true, the envelope will be created. If the envelope already exists and is
-- bypassed and create=true, then the envelope will be unbypassed. FX indices can
-- have 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fxindex integer.
-- @param parameterindex integer.
-- @param create boolean.
-- @return TrackEnvelope table
function TakeFX:get_envelope(fxindex, parameterindex, create)
    local result = r.TakeFX_GetEnvelope(self.take.pointer, fxindex, parameterindex, create)
    return track_envelope.TrackEnvelope:new(result)
end

    
--- Get Floating Window.
-- returns HWND of floating window for effect index, if any FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @return HWND
function TakeFX:get_floating_window()
    return r.TakeFX_GetFloatingWindow(self.take.pointer, self.pointer)
end

    
--- Get Formatted Param Value.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @return ret_val boolean
-- @return buf string
function TakeFX:get_formatted_param_value(fx, param)
    return r.TakeFX_GetFormattedParamValue(self.take.pointer, fx, param)
end

    
--- Get Fxguid.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @return guid string
function TakeFX:get_fxguid(fx)
    return r.TakeFX_GetFXGUID(self.take.pointer, fx)
end

    
--- Get Fx Name.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @return ret_val boolean
-- @return buf string
function TakeFX:get_fx_name(fx)
    return r.TakeFX_GetFXName(self.take.pointer, fx)
end

    
--- Get Io Size.
-- Gets the number of input/output pins for FX if available, returns plug-in type
-- or -1 on error FX indices can have 0x2000000 added to them, in which case they
-- will be used to address FX in containers. To address a container, the 1-based
-- subitem is multiplied by one plus the count of the FX chain and added to the
-- 1-based container item index. e.g. to address the third item in the container at
-- the second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @return ret_val integer
-- @return input_pins integer
-- @return output_pins integer
function TakeFX:get_io_size(fx)
    return r.TakeFX_GetIOSize(self.take.pointer, fx)
end

    
--- Get Named Config Parm.
-- gets plug-in specific named configuration value (returns true on success). see
-- TrackFX_GetNamedConfigParm FX indices can have 0x2000000 added to them, in which
-- case they will be used to address FX in containers. To address a container, the
-- 1-based subitem is multiplied by one plus the count of the FX chain and added to
-- the 1-based container item index. e.g. to address the third item in the
-- container at the second position of the track FX chain for tr, the index would
-- be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-
-- containers using TrackFX_GetNamedConfigParm with container_count and similar
-- logic. In REAPER v7.06+, you can use the much more convenient method to navigate
-- hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @param parm_name string.
-- @return ret_val boolean
-- @return buf string
function TakeFX:get_named_config_parm(fx, parm_name)
    return r.TakeFX_GetNamedConfigParm(self.take.pointer, fx, parm_name)
end

    
--- Get Num Params.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @return integer
function TakeFX:get_num_params(fx)
    return r.TakeFX_GetNumParams(self.take.pointer, fx)
end

    
--- Get Offline.
-- See TakeFX_SetOffline FX indices can have 0x2000000 added to them, in which case
-- they will be used to address FX in containers. To address a container, the
-- 1-based subitem is multiplied by one plus the count of the FX chain and added to
-- the 1-based container item index. e.g. to address the third item in the
-- container at the second position of the track FX chain for tr, the index would
-- be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-
-- containers using TrackFX_GetNamedConfigParm with container_count and similar
-- logic. In REAPER v7.06+, you can use the much more convenient method to navigate
-- hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @return boolean
function TakeFX:get_offline(fx)
    return r.TakeFX_GetOffline(self.take.pointer, fx)
end

    
--- Get Open.
-- Returns true if this FX UI is open in the FX chain window or a floating window.
-- See TakeFX_SetOpen FX indices can have 0x2000000 added to them, in which case
-- they will be used to address FX in containers. To address a container, the
-- 1-based subitem is multiplied by one plus the count of the FX chain and added to
-- the 1-based container item index. e.g. to address the third item in the
-- container at the second position of the track FX chain for tr, the index would
-- be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-
-- containers using TrackFX_GetNamedConfigParm with container_count and similar
-- logic. In REAPER v7.06+, you can use the much more convenient method to navigate
-- hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @return boolean
function TakeFX:get_open(fx)
    return r.TakeFX_GetOpen(self.take.pointer, fx)
end

    
--- Get Param.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @return ret_val number
-- @return min_val number
-- @return max_val number
function TakeFX:get_param(fx, param)
    return r.TakeFX_GetParam(self.take.pointer, fx, param)
end

    
--- Get Parameter Step Sizes.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @return ret_val boolean
-- @return step number
-- @return smallstep number
-- @return largestep number
-- @return is_toggle boolean
function TakeFX:get_parameter_step_sizes(fx, param)
    return r.TakeFX_GetParameterStepSizes(self.take.pointer, fx, param)
end

    
--- Get Param Ex.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @return ret_val number
-- @return min_val number
-- @return max_val number
-- @return mid_val number
function TakeFX:get_param_ex(fx, param)
    return r.TakeFX_GetParamEx(self.take.pointer, fx, param)
end

    
--- Get Param From Ident.
-- gets the parameter index from an identifying string (:wet, :bypass, or a string
-- returned from GetParamIdent), or -1 if unknown. FX indices can have 0x2000000
-- added to them, in which case they will be used to address FX in containers. To
-- address a container, the 1-based subitem is multiplied by one plus the count of
-- the FX chain and added to the 1-based container item index. e.g. to address the
-- third item in the container at the second position of the track FX chain for tr,
-- the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be
-- extended to sub-containers using TrackFX_GetNamedConfigParm with container_count
-- and similar logic. In REAPER v7.06+, you can use the much more convenient method
-- to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container
-- and container_item.X.
-- @param fx integer.
-- @param ident_str string.
-- @return integer
function TakeFX:get_param_from_ident(fx, ident_str)
    return r.TakeFX_GetParamFromIdent(self.take.pointer, fx, ident_str)
end

    
--- Get Param Ident.
-- gets an identifying string for the parameter FX indices can have 0x2000000 added
-- to them, in which case they will be used to address FX in containers. To address
-- a container, the 1-based subitem is multiplied by one plus the count of the FX
-- chain and added to the 1-based container item index. e.g. to address the third
-- item in the container at the second position of the track FX chain for tr, the
-- index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended
-- to sub-containers using TrackFX_GetNamedConfigParm with container_count and
-- similar logic. In REAPER v7.06+, you can use the much more convenient method to
-- navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @param param integer.
-- @return ret_val boolean
-- @return buf string
function TakeFX:get_param_ident(fx, param)
    return r.TakeFX_GetParamIdent(self.take.pointer, fx, param)
end

    
--- Get Param Name.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @return ret_val boolean
-- @return buf string
function TakeFX:get_param_name(fx, param)
    return r.TakeFX_GetParamName(self.take.pointer, fx, param)
end

    
--- Get Param Normalized.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @return number
function TakeFX:get_param_normalized(fx, param)
    return r.TakeFX_GetParamNormalized(self.take.pointer, fx, param)
end

    
--- Get Pin Mappings.
-- gets the effective channel mapping bitmask for a particular pin. high32Out will
-- be set to the high 32 bits. Add 0x1000000 to pin index in order to access the
-- second 64 bits of mappings independent of the first 64 bits. FX indices can have
-- 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer.
-- @param is_output integer.
-- @param pin integer.
-- @return ret_val integer
-- @return high32 integer
function TakeFX:get_pin_mappings(fx, is_output, pin)
    return r.TakeFX_GetPinMappings(self.take.pointer, fx, is_output, pin)
end

    
--- Get Preset.
-- Get the name of the preset currently showing in the REAPER dropdown, or the full
-- path to a factory preset file for VST3 plug-ins (.vstpreset). See
-- TakeFX_SetPreset. FX indices can have 0x2000000 added to them, in which case
-- they will be used to address FX in containers. To address a container, the
-- 1-based subitem is multiplied by one plus the count of the FX chain and added to
-- the 1-based container item index. e.g. to address the third item in the
-- container at the second position of the track FX chain for tr, the index would
-- be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-
-- containers using TrackFX_GetNamedConfigParm with container_count and similar
-- logic. In REAPER v7.06+, you can use the much more convenient method to navigate
-- hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @return ret_val boolean
-- @return preset_name string
function TakeFX:get_preset(fx)
    return r.TakeFX_GetPreset(self.take.pointer, fx)
end

    
--- Get Preset Index.
-- Returns current preset index, or -1 if error. numberOfPresetsOut will be set to
-- total number of presets available. See TakeFX_SetPresetByIndex FX indices can
-- have 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer.
-- @return ret_val integer
-- @return number_of_presets integer
function TakeFX:get_preset_index(fx)
    return r.TakeFX_GetPresetIndex(self.take.pointer, fx)
end

    
--- Get User Preset Filename.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @return fn string
function TakeFX:get_user_preset_filename(fx)
    return r.TakeFX_GetUserPresetFilename(self.take.pointer, fx)
end

    
--- Navigate Presets.
-- presetmove==1 activates the next preset, presetmove==-1 activates the previous
-- preset, etc. FX indices can have 0x2000000 added to them, in which case they
-- will be used to address FX in containers. To address a container, the 1-based
-- subitem is multiplied by one plus the count of the FX chain and added to the
-- 1-based container item index. e.g. to address the third item in the container at
-- the second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param presetmove integer.
-- @return boolean
function TakeFX:navigate_presets(fx, presetmove)
    return r.TakeFX_NavigatePresets(self.take.pointer, fx, presetmove)
end

    
--- Set Enabled.
-- See TakeFX_GetEnabled FX indices can have 0x2000000 added to them, in which case
-- they will be used to address FX in containers. To address a container, the
-- 1-based subitem is multiplied by one plus the count of the FX chain and added to
-- the 1-based container item index. e.g. to address the third item in the
-- container at the second position of the track FX chain for tr, the index would
-- be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-
-- containers using TrackFX_GetNamedConfigParm with container_count and similar
-- logic. In REAPER v7.06+, you can use the much more convenient method to navigate
-- hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @param enabled boolean.
function TakeFX:set_enabled(fx, enabled)
    return r.TakeFX_SetEnabled(self.take.pointer, fx, enabled)
end

    
--- Set Named Config Parm.
-- gets plug-in specific named configuration value (returns true on success). see
-- TrackFX_SetNamedConfigParm FX indices can have 0x2000000 added to them, in which
-- case they will be used to address FX in containers. To address a container, the
-- 1-based subitem is multiplied by one plus the count of the FX chain and added to
-- the 1-based container item index. e.g. to address the third item in the
-- container at the second position of the track FX chain for tr, the index would
-- be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-
-- containers using TrackFX_GetNamedConfigParm with container_count and similar
-- logic. In REAPER v7.06+, you can use the much more convenient method to navigate
-- hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @param parm_name string.
-- @param value string.
-- @return boolean
function TakeFX:set_named_config_parm(fx, parm_name, value)
    return r.TakeFX_SetNamedConfigParm(self.take.pointer, fx, parm_name, value)
end

    
--- Set Offline.
-- See TakeFX_GetOffline FX indices can have 0x2000000 added to them, in which case
-- they will be used to address FX in containers. To address a container, the
-- 1-based subitem is multiplied by one plus the count of the FX chain and added to
-- the 1-based container item index. e.g. to address the third item in the
-- container at the second position of the track FX chain for tr, the index would
-- be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-
-- containers using TrackFX_GetNamedConfigParm with container_count and similar
-- logic. In REAPER v7.06+, you can use the much more convenient method to navigate
-- hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @param offline boolean.
function TakeFX:set_offline(fx, offline)
    return r.TakeFX_SetOffline(self.take.pointer, fx, offline)
end

    
--- Set Open.
-- Open this FX UI. See TakeFX_GetOpen FX indices can have 0x2000000 added to them,
-- in which case they will be used to address FX in containers. To address a
-- container, the 1-based subitem is multiplied by one plus the count of the FX
-- chain and added to the 1-based container item index. e.g. to address the third
-- item in the container at the second position of the track FX chain for tr, the
-- index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended
-- to sub-containers using TrackFX_GetNamedConfigParm with container_count and
-- similar logic. In REAPER v7.06+, you can use the much more convenient method to
-- navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @param open boolean.
function TakeFX:set_open(fx, open)
    return r.TakeFX_SetOpen(self.take.pointer, fx, open)
end

    
--- Set Param.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @param val number.
-- @return boolean
function TakeFX:set_param(fx, param, val)
    return r.TakeFX_SetParam(self.take.pointer, fx, param, val)
end

    
--- Set Param Normalized.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param param integer.
-- @param value number.
-- @return boolean
function TakeFX:set_param_normalized(fx, param, value)
    return r.TakeFX_SetParamNormalized(self.take.pointer, fx, param, value)
end

    
--- Set Pin Mappings.
-- sets the channel mapping bitmask for a particular pin. returns false if
-- unsupported (not all types of plug-ins support this capability). Add 0x1000000
-- to pin index in order to access the second 64 bits of mappings independent of
-- the first 64 bits. FX indices can have 0x2000000 added to them, in which case
-- they will be used to address FX in containers. To address a container, the
-- 1-based subitem is multiplied by one plus the count of the FX chain and added to
-- the 1-based container item index. e.g. to address the third item in the
-- container at the second position of the track FX chain for tr, the index would
-- be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-
-- containers using TrackFX_GetNamedConfigParm with container_count and similar
-- logic. In REAPER v7.06+, you can use the much more convenient method to navigate
-- hierarchies, see TrackFX_GetNamedConfigParm with parent_container and
-- container_item.X.
-- @param fx integer.
-- @param is_output integer.
-- @param pin integer.
-- @param low32bits integer.
-- @param hi32bits integer.
-- @return boolean
function TakeFX:set_pin_mappings(fx, is_output, pin, low32bits, hi32bits)
    return r.TakeFX_SetPinMappings(self.take.pointer, fx, is_output, pin, low32bits, hi32bits)
end

    
--- Set Preset.
-- Activate a preset with the name shown in the REAPER dropdown. Full paths to
-- .vstpreset files are also supported for VST3 plug-ins. See TakeFX_GetPreset. FX
-- indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param fx integer.
-- @param preset_name string.
-- @return boolean
function TakeFX:set_preset(fx, preset_name)
    return r.TakeFX_SetPreset(self.take.pointer, fx, preset_name)
end

    
--- Set Preset By Index.
-- Sets the preset idx, or the factory preset (idx==-2), or the default user preset
-- (idx==-1). Returns true on success. See TakeFX_GetPresetIndex. FX indices can
-- have 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param fx integer.
-- @return boolean
function TakeFX:set_preset_by_index(fx)
    return r.TakeFX_SetPresetByIndex(self.take.pointer, fx, self.pointer)
end

    
--- Show.
-- showflag=0 for hidechain, =1 for show chain(index valid), =2 for hide floating
-- window(index valid), =3 for show floating window (index valid) FX indices can
-- have 0x2000000 added to them, in which case they will be used to address FX in
-- containers. To address a container, the 1-based subitem is multiplied by one
-- plus the count of the FX chain and added to the 1-based container item index.
-- e.g. to address the third item in the container at the second position of the
-- track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1)
-- + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm
-- with container_count and similar logic. In REAPER v7.06+, you can use the much
-- more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm
-- with parent_container and container_item.X.
-- @param show_flag integer.
function TakeFX:show(show_flag)
    return r.TakeFX_Show(self.take.pointer, self.pointer, show_flag)
end

    
--- Br Get Count.
-- [BR] Returns FX count for supplied take
-- @return integer
function TakeFX:br_get_count()
    return r.BR_GetTakeFXCount(self.take.pointer)
end

    
--- Cf Get Chain.
-- Return a handle to the given take FX chain window. HACK: This temporarily
-- renames the take in order to disambiguate the take FX chain window from
-- similarily named takes.
-- @return FxChain
function TakeFX:cf_get_chain()
    return r.CF_GetTakeFXChain(self.take.pointer)
end

    
--- Cf Select.
-- Set which take effect is active in the take's FX chain. The FX chain window does
-- not have to be open.
-- @return boolean
function TakeFX:cf_select()
    return r.CF_SelectTakeFX(self.take.pointer, self.pointer)
end

return TakeFX
