-- @description Llm: Provide implementation for Llm functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_track = require('media_track')


local Llm = {}



--- Create new Llm instance.
-- @return Llm table.
function Llm:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the Llm logger.
-- @param ... (varargs) Messages to log.
function Llm:log(...)
    local logger = helpers.log_func('Llm')
    logger(...)
    return nil
end

    
--- Do .
-- Do. Call this function to run one ReaLlm cycle. Use this function to run ReaLlm
-- on arbitrary time intervals e.g. from a deferred script.
function Llm:do_()
    return r.Llm_Do()
end

    
--- Get Paths.
-- Get paths. Returns a string of the form
-- "start:fx#1.fx#2...;track:fxs;...;end:fxs" where track is the track number and
-- fx is the fx index. The string is truncated to pathStringOut_sz. 1-based
-- indexing is used. If no MediaTrack* start is provided, all monitored input
-- tracks are used. If no MediaTrack* end is provided, all hardware output tracks
-- are used. If includeFx is true, the fx indices are included.
-- @param include_fx boolean
-- @return path_string string
function Llm:get_paths(include_fx)
    return r.Llm_GetPaths(include_fx, start_in, end_in)
end

    
--- Get Safed.
-- Get safed. Returns a string of the form "track:fx;track:fx;..." where track is
-- the track number and fx is the fx index. The string is truncated to
-- safeStringOut_sz. 1-based indexing is used. The string is followed by a |
-- delimited list of fx names that have been set safed.
-- @return safe_string string
function Llm:get_safed()
    return r.Llm_GetSafed()
end

    
--- Get Version.
-- Get version. Returns the version of the plugin as integers and the commit hash
-- as a string. The string is truncated to commitOut_sz.
-- @return major integer
-- @return minor integer
-- @return patch integer
-- @return build integer
-- @return commit string
function Llm:get_version()
    return r.Llm_GetVersion()
end

    
--- Set Clear Safe.
-- Set clear safe. Set clear_manually_safed_fx = true to clear manually safed fx
-- @param clear_manually_safed_fx boolean
function Llm:set_clear_safe(clear_manually_safed_fx)
    return r.Llm_SetClearSafe(clear_manually_safed_fx)
end

    
--- Set Keep Pdc.
-- Set keep pdc
-- @param enable boolean
function Llm:set_keep_pdc(enable)
    return r.Llm_SetKeepPdc(enable)
end

    
--- Set Monitoring Fx.
-- Set to include MonitoringFX. In REAPER land this means the fx on the master
-- track record fx chain. Indexed as fx# + 0x1000000, 0-based.
-- @param enable boolean
function Llm:set_monitoring_fx(enable)
    return r.Llm_SetMonitoringFX(enable)
end

    
--- Set Parameter Change.
-- Set parameter change. Set val1 = val2 to clear change. Set parameter_index =
-- -666 to clear all changes. Use this function to set parameter changes between
-- values val1 and val2 for fx_name and parameter_index instead of disabling the
-- effect. Use custom fx names to identify individual fx.
-- @param fx_name string
-- @param parameter_index integer
-- @param val1 number
-- @param val2 number
function Llm:set_parameter_change(fx_name, parameter_index, val1, val2)
    return r.Llm_SetParameterChange(fx_name, parameter_index, val1, val2)
end

    
--- Set Pdc Limit.
-- Set pdc limit as factor of audio buffer size.
-- @param pdc_factor number
function Llm:set_pdc_limit(pdc_factor)
    return r.Llm_SetPdcLimit(pdc_factor)
end

    
--- Set Safed.
-- Set safed. Set isSet = true to safe fx name. Set isSet = false to unsafe fx
-- name.
-- @param fx_name string
-- @param is__set boolean
-- @return fx_name string
function Llm:set_safed(fx_name, is__set)
    return r.Llm_SetSafed(fx_name, is__set)
end

return Llm
