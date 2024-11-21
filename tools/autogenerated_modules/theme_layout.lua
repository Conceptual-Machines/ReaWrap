-- @description ThemeLayout: Provide implementation for ThemeLayout functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local ThemeLayout = {}



--- Create new ThemeLayout instance.
-- @return ThemeLayout table.
function ThemeLayout:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the ThemeLayout logger.
-- @param ... (varargs) Messages to log.
function ThemeLayout:log(...)
    local logger = helpers.log_func('ThemeLayout')
    logger(...)
    return nil
end

    
--- Get Layout.
-- Gets theme layout information. section can be 'global' for global layout
-- override, 'seclist' to enumerate a list of layout sections, otherwise a layout
-- section such as 'mcp', 'tcp', 'trans', etc. idx can be -1 to query the current
-- value, -2 to get the description of the section (if not global), -3 will return
-- the current context DPI-scaling (256=normal, 512=retina, etc), or 0..x. returns
-- false if failed.
-- @param section string
-- @param _idx integer
-- @return name string
function ThemeLayout:get_layout(section, _idx)
    local retval, name = r.ThemeLayout_GetLayout(section, _idx)
    if retval then
        return name
    else
        return nil
    end
end

    
--- Get Parameter.
-- returns theme layout parameter. return value is cfg-name, or nil/empty if out of
-- range.
-- @param wp integer
-- @return string desc
-- @return integer value
-- @return integer defValue
-- @return integer minValue
-- @return integer maxValue
function ThemeLayout:get_parameter(wp)
    local retval, string, integer, integer, integer, integer = r.ThemeLayout_GetParameter(wp)
    if retval then
        return string, integer, integer, integer, integer
    else
        return nil
    end
end

    
--- Refresh All.
-- Refreshes all layouts
function ThemeLayout:refresh_all()
    return r.ThemeLayout_RefreshAll()
end

    
--- Set Layout.
-- Sets theme layout override for a particular section -- section can be 'global'
-- or 'mcp' etc. If setting global layout, prefix a ! to the layout string to clear
-- any per-layout overrides. Returns false if failed.
-- @param section string
-- @param layout string
-- @return boolean
function ThemeLayout:set_layout(section, layout)
    return r.ThemeLayout_SetLayout(section, layout)
end

    
--- Set Parameter.
-- sets theme layout parameter to value. persist=true in order to have change
-- loaded on next theme load. note that the caller should update layouts via ??? to
-- make changes visible.
-- @param wp integer
-- @param value integer
-- @param persist boolean
-- @return boolean
function ThemeLayout:set_parameter(wp, value, persist)
    return r.ThemeLayout_SetParameter(wp, value, persist)
end

return ThemeLayout
