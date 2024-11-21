-- @description HWND: Provide implementation for HWND functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local HWND = {}



--- Create new HWND instance.
-- @return HWND table.
function HWND:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the HWND logger.
-- @param ... (varargs) Messages to log.
function HWND:log(...)
    local logger = helpers.log_func('HWND')
    logger(...)
    return nil
end

    
--- Do Action Shortcut Dialog.
-- Open the action shortcut dialog to edit or add a shortcut for the given command
-- ID. If (shortcutidx >= 0 && shortcutidx < CountActionShortcuts()), that specific
-- shortcut will be replaced, otherwise a new shortcut will be added. See
-- CountActionShortcuts, GetActionShortcutDesc, DeleteActionShortcut.
-- @param section KbdSectionInfo
-- @param cmd_id integer
-- @param shortcut_idx integer
-- @return boolean
function HWND:do_action_shortcut_dialog(section, cmd_id, shortcut_idx)
    return r.DoActionShortcutDialog(self.pointer, section, cmd_id, shortcut_idx)
end

    
--- Dock Is Child Of Dock.
-- returns dock index that contains hwnd, or -1
-- @return is__floating_docker boolean
function HWND:dock_is_child_of_dock()
    local retval, is__floating_docker = r.DockIsChildOfDock(self.pointer)
    if retval then
        return is__floating_docker
    else
        return nil
    end
end

    
--- Dock Window Activate.
function HWND:dock_window_activate()
    return r.DockWindowActivate(self.pointer)
end

    
--- Dock Window Add.
-- @param name string
-- @param pos integer
-- @param allow_show boolean
function HWND:dock_window_add(name, pos, allow_show)
    return r.DockWindowAdd(self.pointer, name, pos, allow_show)
end

    
--- Dock Window Add Ex.
-- @param name string
-- @param identstr string
-- @param allow_show boolean
function HWND:dock_window_add_ex(name, identstr, allow_show)
    return r.DockWindowAddEx(self.pointer, name, identstr, allow_show)
end

    
--- Dock Window Refresh For.
function HWND:dock_window_refresh_for()
    return r.DockWindowRefreshForHWND(self.pointer)
end

    
--- Dock Window Remove.
function HWND:dock_window_remove()
    return r.DockWindowRemove(self.pointer)
end

    
--- Gr Select Color.
-- Runs the system color chooser dialog.  Returns 0 if the user cancels the dialog.
-- @return color integer
function HWND:gr_select_color()
    local retval, color = r.GR_SelectColor(self.pointer)
    if retval then
        return color
    else
        return nil
    end
end

return HWND
