-- @description Provide implementation for TakeFX functions.
-- @author NomadMonad
-- @license MIT

local r = reaper
local helpers = require('helpers')


local TakeFX = {}



--- Create new TakeFX instance.
-- @param take . The MediaItemTake object
-- @param fx_idx . The index of the FX
-- @return TakeFX table.
function TakeFX:new(take, fx_idx)
    local obj = {
        pointer_type = "TakeFX",
        take = take, 
        pointer = fx_idx
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- @section ReaWrap Custom Methods

--- Log messages with the TakeFX logger.
-- @param ... (varargs) Messages to log.
function TakeFX:log(...)
    local logger = helpers.log_func('TakeFX')
    logger(...)
    return nil
end


-- @section ReaScript API Methods



    
--- Add By Name. Wraps TakeFX_AddByName.
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
-- @param fx_name string
-- @param instantiate number
-- @return number
function TakeFX:add_by_name(fx_name, instantiate)
    return r.TakeFX_AddByName(self.take.pointer, fx_name, instantiate)
end

    
--- Copy To Take. Wraps TakeFX_CopyToTake.
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
-- @param dest_take table
-- @param dest_fx number
-- @param is_move boolean
function TakeFX:copy_to_take(dest_take, dest_fx, is_move)
    return r.TakeFX_CopyToTake(self.src_take.pointer, src_fx, dest_take, dest_fx, is_move)
end

    
--- Copy To Track. Wraps TakeFX_CopyToTrack.
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
-- @param dest_track table
-- @param dest_fx number
-- @param is_move boolean
function TakeFX:copy_to_track(dest_track, dest_fx, is_move)
    return r.TakeFX_CopyToTrack(self.src_take.pointer, src_fx, dest_track, dest_fx, is_move)
end

    
--- End Param Edit. Wraps TakeFX_EndParamEdit.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param param number
-- @return boolean
function TakeFX:end_param_edit(param)
    return r.TakeFX_EndParamEdit(self.take.pointer, fx, param)
end

    
--- Format Param Value. Wraps TakeFX_FormatParamValue.
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
-- @param param number
-- @param val number
-- @return buf string
function TakeFX:format_param_value(param, val)
    local ret_val, buf = r.TakeFX_FormatParamValue(self.take.pointer, fx, param, val)
    if ret_val then
        return buf
    else
        return nil
    end
end

    
--- Format Param Value Normalized. Wraps TakeFX_FormatParamValueNormalized.
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
-- @param param number
-- @param value number
-- @param buf string
-- @return buf string
function TakeFX:format_param_value_normalized(param, value, buf)
    local ret_val, buf = r.TakeFX_FormatParamValueNormalized(self.take.pointer, fx, param, value, buf)
    if ret_val then
        return buf
    else
        return nil
    end
end

    
--- Get Chain Visible. Wraps TakeFX_GetChainVisible.
-- returns index of effect visible in chain, or -1 for chain hidden, or -2 for
-- chain visible but no effect selected
-- @return number
function TakeFX:get_chain_visible()
    return r.TakeFX_GetChainVisible(self.take.pointer)
end

    
--- Get Enabled. Wraps TakeFX_GetEnabled.
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
-- @return boolean
function TakeFX:get_enabled()
    return r.TakeFX_GetEnabled(self.take.pointer, fx)
end

    
--- Get Envelope. Wraps TakeFX_GetEnvelope.
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
-- @param fxindex number
-- @param parameterindex number
-- @param create boolean
-- @return Envelope table
function TakeFX:get_envelope(fxindex, parameterindex, create)
    local Envelope = require('envelope')
    local result = r.TakeFX_GetEnvelope(self.take.pointer, fxindex, parameterindex, create)
    return Envelope:new(result)
end

    
--- Get Floating Window. Wraps TakeFX_GetFloatingWindow.
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
    return r.TakeFX_GetFloatingWindow(self.take.pointer, index)
end

    
--- Get Formatted Param Value. Wraps TakeFX_GetFormattedParamValue.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param param number
-- @return buf string
function TakeFX:get_formatted_param_value(param)
    local ret_val, buf = r.TakeFX_GetFormattedParamValue(self.take.pointer, fx, param)
    if ret_val then
        return buf
    else
        return nil
    end
end

    
--- Get Guid. Wraps TakeFX_GetFXGUID.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @return guid string
function TakeFX:get_guid()
    return r.TakeFX_GetFXGUID(self.take.pointer, fx)
end

    
--- Get Name. Wraps TakeFX_GetFXName.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @return buf string
function TakeFX:get_name()
    local ret_val, buf = r.TakeFX_GetFXName(self.take.pointer, fx)
    if ret_val then
        return buf
    else
        return nil
    end
end

    
--- Get Io Size. Wraps TakeFX_GetIOSize.
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
-- @return input_pins number
-- @return output_pins number
function TakeFX:get_io_size()
    local ret_val, input_pins, output_pins = r.TakeFX_GetIOSize(self.take.pointer, fx)
    if ret_val then
        return input_pins, output_pins
    else
        return nil
    end
end

    
--- Get Named Config Parm. Wraps TakeFX_GetNamedConfigParm.
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
-- @param parm_name string
-- @return buf string
function TakeFX:get_named_config_parm(parm_name)
    local ret_val, buf = r.TakeFX_GetNamedConfigParm(self.take.pointer, fx, parm_name)
    if ret_val then
        return buf
    else
        return nil
    end
end

    
--- Get Num Params. Wraps TakeFX_GetNumParams.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @return number
function TakeFX:get_num_params()
    return r.TakeFX_GetNumParams(self.take.pointer, fx)
end

    
--- Get Offline. Wraps TakeFX_GetOffline.
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
-- @return boolean
function TakeFX:get_offline()
    return r.TakeFX_GetOffline(self.take.pointer, fx)
end

    
--- Get Open. Wraps TakeFX_GetOpen.
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
-- @return boolean
function TakeFX:get_open()
    return r.TakeFX_GetOpen(self.take.pointer, fx)
end

    
--- Get Param. Wraps TakeFX_GetParam.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param param number
-- @return min_val number
-- @return max_val number
function TakeFX:get_param(param)
    local ret_val, min_val, max_val = r.TakeFX_GetParam(self.take.pointer, fx, param)
    if ret_val then
        return min_val, max_val
    else
        return nil
    end
end

    
--- Get Parameter Step Sizes. Wraps TakeFX_GetParameterStepSizes.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param param number
-- @return step number
-- @return smallstep number
-- @return largestep number
-- @return is_toggle boolean
function TakeFX:get_parameter_step_sizes(param)
    local ret_val, step, smallstep, largestep, is_toggle = r.TakeFX_GetParameterStepSizes(self.take.pointer, fx, param)
    if ret_val then
        return step, smallstep, largestep, is_toggle
    else
        return nil
    end
end

    
--- Get Param Ex. Wraps TakeFX_GetParamEx.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param param number
-- @return min_val number
-- @return max_val number
-- @return mid_val number
function TakeFX:get_param_ex(param)
    local ret_val, min_val, max_val, mid_val = r.TakeFX_GetParamEx(self.take.pointer, fx, param)
    if ret_val then
        return min_val, max_val, mid_val
    else
        return nil
    end
end

    
--- Get Param From Ident. Wraps TakeFX_GetParamFromIdent.
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
-- @param ident_str string
-- @return number
function TakeFX:get_param_from_ident(ident_str)
    return r.TakeFX_GetParamFromIdent(self.take.pointer, fx, ident_str)
end

    
--- Get Param Ident. Wraps TakeFX_GetParamIdent.
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
-- @param param number
-- @return buf string
function TakeFX:get_param_ident(param)
    local ret_val, buf = r.TakeFX_GetParamIdent(self.take.pointer, fx, param)
    if ret_val then
        return buf
    else
        return nil
    end
end

    
--- Get Param Name. Wraps TakeFX_GetParamName.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param param number
-- @return buf string
function TakeFX:get_param_name(param)
    local ret_val, buf = r.TakeFX_GetParamName(self.take.pointer, fx, param)
    if ret_val then
        return buf
    else
        return nil
    end
end

    
--- Get Param Normalized. Wraps TakeFX_GetParamNormalized.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param param number
-- @return number
function TakeFX:get_param_normalized(param)
    return r.TakeFX_GetParamNormalized(self.take.pointer, fx, param)
end

    
--- Get Pin Mappings. Wraps TakeFX_GetPinMappings.
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
-- @param is_output number
-- @param pin number
-- @return high32 number
function TakeFX:get_pin_mappings(is_output, pin)
    local ret_val, high32 = r.TakeFX_GetPinMappings(self.take.pointer, fx, is_output, pin)
    if ret_val then
        return high32
    else
        return nil
    end
end

    
--- Get Preset. Wraps TakeFX_GetPreset.
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
-- @return preset_name string
function TakeFX:get_preset()
    local ret_val, preset_name = r.TakeFX_GetPreset(self.take.pointer, fx)
    if ret_val then
        return preset_name
    else
        return nil
    end
end

    
--- Get Preset Index. Wraps TakeFX_GetPresetIndex.
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
-- @return number_of_presets number
function TakeFX:get_preset_index()
    local ret_val, number_of_presets = r.TakeFX_GetPresetIndex(self.take.pointer, fx)
    if ret_val then
        return number_of_presets
    else
        return nil
    end
end

    
--- Get User Preset Filename. Wraps TakeFX_GetUserPresetFilename.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @return fn string
function TakeFX:get_user_preset_filename()
    return r.TakeFX_GetUserPresetFilename(self.take.pointer, fx)
end

    
--- Navigate Presets. Wraps TakeFX_NavigatePresets.
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
-- @param presetmove number
-- @return boolean
function TakeFX:navigate_presets(presetmove)
    return r.TakeFX_NavigatePresets(self.take.pointer, fx, presetmove)
end

    
--- Set Enabled. Wraps TakeFX_SetEnabled.
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
-- @param enabled boolean
function TakeFX:set_enabled(enabled)
    return r.TakeFX_SetEnabled(self.take.pointer, fx, enabled)
end

    
--- Set Named Config Parm. Wraps TakeFX_SetNamedConfigParm.
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
-- @param parm_name string
-- @param value string
-- @return boolean
function TakeFX:set_named_config_parm(parm_name, value)
    return r.TakeFX_SetNamedConfigParm(self.take.pointer, fx, parm_name, value)
end

    
--- Set Offline. Wraps TakeFX_SetOffline.
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
-- @param offline boolean
function TakeFX:set_offline(offline)
    return r.TakeFX_SetOffline(self.take.pointer, fx, offline)
end

    
--- Set Open. Wraps TakeFX_SetOpen.
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
-- @param open boolean
function TakeFX:set_open(open)
    return r.TakeFX_SetOpen(self.take.pointer, fx, open)
end

    
--- Set Param. Wraps TakeFX_SetParam.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param param number
-- @param val number
-- @return boolean
function TakeFX:set_param(param, val)
    return r.TakeFX_SetParam(self.take.pointer, fx, param, val)
end

    
--- Set Param Normalized. Wraps TakeFX_SetParamNormalized.
--  FX indices can have 0x2000000 added to them, in which case they will be used to
-- address FX in containers. To address a container, the 1-based subitem is
-- multiplied by one plus the count of the FX chain and added to the 1-based
-- container item index. e.g. to address the third item in the container at the
-- second position of the track FX chain for tr, the index would be 0x2000000 +
-- 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using
-- TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER
-- v7.06+, you can use the much more convenient method to navigate hierarchies, see
-- TrackFX_GetNamedConfigParm with parent_container and container_item.X.
-- @param param number
-- @param value number
-- @return boolean
function TakeFX:set_param_normalized(param, value)
    return r.TakeFX_SetParamNormalized(self.take.pointer, fx, param, value)
end

    
--- Set Pin Mappings. Wraps TakeFX_SetPinMappings.
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
-- @param is_output number
-- @param pin number
-- @param low32bits number
-- @param hi32bits number
-- @return boolean
function TakeFX:set_pin_mappings(is_output, pin, low32bits, hi32bits)
    return r.TakeFX_SetPinMappings(self.take.pointer, fx, is_output, pin, low32bits, hi32bits)
end

    
--- Set Preset. Wraps TakeFX_SetPreset.
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
-- @param preset_name string
-- @return boolean
function TakeFX:set_preset(preset_name)
    return r.TakeFX_SetPreset(self.take.pointer, fx, preset_name)
end

    
--- Set Preset By Index. Wraps TakeFX_SetPresetByIndex.
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
-- @return boolean
function TakeFX:set_preset_by_index()
    return r.TakeFX_SetPresetByIndex(self.take.pointer, fx, idx)
end

    
--- Show. Wraps TakeFX_Show.
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
-- @param show_flag number
function TakeFX:show(show_flag)
    return r.TakeFX_Show(self.take.pointer, index, show_flag)
end

    
--- Get Fx Count. Wraps BR_GetTakeFXCount.
-- [BR] Returns FX count for supplied take
-- @return number
function TakeFX:get_fx_count()
    return r.BR_GetTakeFXCount(self.take.pointer)
end

    
--- Get Chain. Wraps CF_GetTakeFXChain.
-- Return a handle to the given take FX chain window. HACK: This temporarily
-- renames the take in order to disambiguate the take FX chain window from
-- similarily named takes.
-- @return FxChain
function TakeFX:get_chain()
    return r.CF_GetTakeFXChain(self.take.pointer)
end

    
--- Select. Wraps CF_SelectTakeFX.
-- Set which take effect is active in the take's FX chain. The FX chain window does
-- not have to be open.
-- @return boolean
function TakeFX:select()
    return r.CF_SelectTakeFX(self.take.pointer, index)
end

return TakeFX
