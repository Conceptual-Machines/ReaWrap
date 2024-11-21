-- @description TakeFX: Provide implementation for TakeFX functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_item_take = require('media_item_take')
local media_track = require('media_track')


local TakeFX = {}



--- Create new TakeFX instance.
-- @return TakeFX table.
function TakeFX:new()
    local obj = {}
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
-- @param fxname string
-- @param instantiate integer
-- @return integer
function TakeFX:add_by_name(fxname, instantiate)
    return r.TakeFX_AddByName(self.pointer, fxname, instantiate)
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
-- @param src_fx integer
-- @param dest_fx integer
-- @param is__move boolean
function TakeFX:copy_to_take(src_fx, dest_fx, is__move)
    return r.TakeFX_CopyToTake(self.pointer, src_fx, dest_take, dest_fx, is__move)
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
-- @param src_fx integer
-- @param dest_fx integer
-- @param is__move boolean
function TakeFX:copy_to_track(src_fx, dest_fx, is__move)
    return r.TakeFX_CopyToTrack(self.pointer, src_fx, dest_track, dest_fx, is__move)
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
-- @param fx integer
-- @return boolean
function TakeFX:delete(fx)
    return r.TakeFX_Delete(self.pointer, fx)
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
-- @param fx integer
-- @param param integer
-- @return boolean
function TakeFX:end_param_edit(fx, param)
    return r.TakeFX_EndParamEdit(self.pointer, fx, param)
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
-- @param fx integer
-- @param param integer
-- @param val number
-- @return buf string
function TakeFX:format_param_value(fx, param, val)
    local retval, buf = r.TakeFX_FormatParamValue(self.pointer, fx, param, val)
    if retval then
        return buf
    else
        return nil
    end
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
-- @param fx integer
-- @param param integer
-- @param value number
-- @param buf string
-- @return buf string
function TakeFX:format_param_value_normalized(fx, param, value, buf)
    local retval, buf = r.TakeFX_FormatParamValueNormalized(self.pointer, fx, param, value, buf)
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
function TakeFX:get_chain_visible()
    return r.TakeFX_GetChainVisible(self.pointer)
end

    
--- Get Count.
-- @return integer
function TakeFX:get_count()
    return r.TakeFX_GetCount(self.pointer)
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
-- @param fx integer
-- @return boolean
function TakeFX:get_enabled(fx)
    return r.TakeFX_GetEnabled(self.pointer, fx)
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
-- @param fxindex integer
-- @param parameterindex integer
-- @param create boolean
-- @return TrackEnvelope table
function TakeFX:get_envelope(fxindex, parameterindex, create)
    local result = r.TakeFX_GetEnvelope(self.pointer, fxindex, parameterindex, create)
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
-- @param index integer
-- @return HWND table
function TakeFX:get_floating_window(index)
    local result = r.TakeFX_GetFloatingWindow(self.pointer, index)
    return hwnd.HWND:new(result)
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
-- @param fx integer
-- @param param integer
-- @return buf string
function TakeFX:get_formatted_param_value(fx, param)
    local retval, buf = r.TakeFX_GetFormattedParamValue(self.pointer, fx, param)
    if retval then
        return buf
    else
        return nil
    end
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
-- @param fx integer
-- @return guid string
function TakeFX:get_fxguid(fx)
    return r.TakeFX_GetFXGUID(self.pointer, fx)
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
-- @param fx integer
-- @return buf string
function TakeFX:get_fx_name(fx)
    local retval, buf = r.TakeFX_GetFXName(self.pointer, fx)
    if retval then
        return buf
    else
        return nil
    end
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
-- @param fx integer
-- @return input_pins integer
-- @return output_pins integer
function TakeFX:get_io_size(fx)
    local retval, input_pins, output_pins = r.TakeFX_GetIOSize(self.pointer, fx)
    if retval then
        return input_pins, output_pins
    else
        return nil
    end
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
-- @param fx integer
-- @param parmname string
-- @return buf string
function TakeFX:get_named_config_parm(fx, parmname)
    local retval, buf = r.TakeFX_GetNamedConfigParm(self.pointer, fx, parmname)
    if retval then
        return buf
    else
        return nil
    end
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
-- @param fx integer
-- @return integer
function TakeFX:get_num_params(fx)
    return r.TakeFX_GetNumParams(self.pointer, fx)
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
-- @param fx integer
-- @return boolean
function TakeFX:get_offline(fx)
    return r.TakeFX_GetOffline(self.pointer, fx)
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
-- @param fx integer
-- @return boolean
function TakeFX:get_open(fx)
    return r.TakeFX_GetOpen(self.pointer, fx)
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
-- @param fx integer
-- @param param integer
-- @return minval number
-- @return maxval number
function TakeFX:get_param(fx, param)
    local retval, minval, maxval = r.TakeFX_GetParam(self.pointer, fx, param)
    if retval then
        return minval, maxval
    else
        return nil
    end
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
-- @param fx integer
-- @param param integer
-- @return step number
-- @return smallstep number
-- @return largestep number
-- @return is_toggle boolean
function TakeFX:get_parameter_step_sizes(fx, param)
    local retval, step, smallstep, largestep, is_toggle = r.TakeFX_GetParameterStepSizes(self.pointer, fx, param)
    if retval then
        return step, smallstep, largestep, is_toggle
    else
        return nil
    end
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
-- @param fx integer
-- @param param integer
-- @return minval number
-- @return maxval number
-- @return midval number
function TakeFX:get_param_ex(fx, param)
    local retval, minval, maxval, midval = r.TakeFX_GetParamEx(self.pointer, fx, param)
    if retval then
        return minval, maxval, midval
    else
        return nil
    end
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
-- @param fx integer
-- @param ident_str string
-- @return integer
function TakeFX:get_param_from_ident(fx, ident_str)
    return r.TakeFX_GetParamFromIdent(self.pointer, fx, ident_str)
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
-- @param fx integer
-- @param param integer
-- @return buf string
function TakeFX:get_param_ident(fx, param)
    local retval, buf = r.TakeFX_GetParamIdent(self.pointer, fx, param)
    if retval then
        return buf
    else
        return nil
    end
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
-- @param fx integer
-- @param param integer
-- @return buf string
function TakeFX:get_param_name(fx, param)
    local retval, buf = r.TakeFX_GetParamName(self.pointer, fx, param)
    if retval then
        return buf
    else
        return nil
    end
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
-- @param fx integer
-- @param param integer
-- @return number
function TakeFX:get_param_normalized(fx, param)
    return r.TakeFX_GetParamNormalized(self.pointer, fx, param)
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
-- @param fx integer
-- @param is_output integer
-- @param pin integer
-- @return high32 integer
function TakeFX:get_pin_mappings(fx, is_output, pin)
    local retval, high32 = r.TakeFX_GetPinMappings(self.pointer, fx, is_output, pin)
    if retval then
        return high32
    else
        return nil
    end
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
-- @param fx integer
-- @return presetname string
function TakeFX:get_preset(fx)
    local retval, presetname = r.TakeFX_GetPreset(self.pointer, fx)
    if retval then
        return presetname
    else
        return nil
    end
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
-- @param fx integer
-- @return number_of_presets integer
function TakeFX:get_preset_index(fx)
    local retval, number_of_presets = r.TakeFX_GetPresetIndex(self.pointer, fx)
    if retval then
        return number_of_presets
    else
        return nil
    end
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
-- @param fx integer
-- @return fn string
function TakeFX:get_user_preset_filename(fx)
    return r.TakeFX_GetUserPresetFilename(self.pointer, fx)
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
-- @param fx integer
-- @param presetmove integer
-- @return boolean
function TakeFX:navigate_presets(fx, presetmove)
    return r.TakeFX_NavigatePresets(self.pointer, fx, presetmove)
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
-- @param fx integer
-- @param enabled boolean
function TakeFX:set_enabled(fx, enabled)
    return r.TakeFX_SetEnabled(self.pointer, fx, enabled)
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
-- @param fx integer
-- @param parmname string
-- @param value string
-- @return boolean
function TakeFX:set_named_config_parm(fx, parmname, value)
    return r.TakeFX_SetNamedConfigParm(self.pointer, fx, parmname, value)
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
-- @param fx integer
-- @param offline boolean
function TakeFX:set_offline(fx, offline)
    return r.TakeFX_SetOffline(self.pointer, fx, offline)
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
-- @param fx integer
-- @param open boolean
function TakeFX:set_open(fx, open)
    return r.TakeFX_SetOpen(self.pointer, fx, open)
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
-- @param fx integer
-- @param param integer
-- @param val number
-- @return boolean
function TakeFX:set_param(fx, param, val)
    return r.TakeFX_SetParam(self.pointer, fx, param, val)
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
-- @param fx integer
-- @param param integer
-- @param value number
-- @return boolean
function TakeFX:set_param_normalized(fx, param, value)
    return r.TakeFX_SetParamNormalized(self.pointer, fx, param, value)
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
-- @param fx integer
-- @param is_output integer
-- @param pin integer
-- @param low32bits integer
-- @param hi32bits integer
-- @return boolean
function TakeFX:set_pin_mappings(fx, is_output, pin, low32bits, hi32bits)
    return r.TakeFX_SetPinMappings(self.pointer, fx, is_output, pin, low32bits, hi32bits)
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
-- @param fx integer
-- @param presetname string
-- @return boolean
function TakeFX:set_preset(fx, presetname)
    return r.TakeFX_SetPreset(self.pointer, fx, presetname)
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
-- @param fx integer
-- @param _idx integer
-- @return boolean
function TakeFX:set_preset_by_index(fx, _idx)
    return r.TakeFX_SetPresetByIndex(self.pointer, fx, _idx)
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
-- @param index integer
-- @param show_flag integer
function TakeFX:show(index, show_flag)
    return r.TakeFX_Show(self.pointer, index, show_flag)
end

return TakeFX
