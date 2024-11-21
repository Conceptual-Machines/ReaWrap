-- @description Main: Provide implementation for Main functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local rea_project = require('rea_project')


local Main = {}



--- Create new Main instance.
-- @return Main table.
function Main:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the Main logger.
-- @param ... (varargs) Messages to log.
function Main:log(...)
    local logger = helpers.log_func('Main')
    logger(...)
    return nil
end

    
--- On Command.
-- See Main_OnCommandEx.
-- @param command integer
-- @param flag integer
function Main:on_command(command, flag)
    return r.Main_OnCommand(command, flag)
end

    
--- On Command Ex.
-- Performs an action belonging to the main action section. To perform non-native
-- actions (ReaScripts, custom or extension plugins' actions) safely, see
-- NamedCommandLookup().
-- @param command integer
-- @param flag integer
function Main:on_command_ex(command, flag)
    return r.Main_OnCommandEx(command, flag, proj)
end

    
--- Open Project.
-- opens a project. will prompt the user to save unless name is prefixed with
-- 'noprompt:'. If name is prefixed with 'template:', project file will be loaded
-- as a template. If passed a .RTrackTemplate file, adds the template to the
-- existing project.
-- @param name string
function Main:open_project(name)
    return r.Main_openProject(name)
end

    
--- Save Project.
-- Save the project.
-- @param force_save_as_in boolean
function Main:save_project(force_save_as_in)
    return r.Main_SaveProject(self.pointer, force_save_as_in)
end

    
--- Save Project Ex.
-- Save the project. options: &1=save selected tracks as track template, &2=include
-- media with track template, &4=include envelopes with track template. See
-- Main_openProject, Main_SaveProject.
-- @param filename string
-- @param options integer
function Main:save_project_ex(filename, options)
    return r.Main_SaveProjectEx(self.pointer, filename, options)
end

    
--- Update Loop Info.
-- @param ignoremask integer
function Main:update_loop_info(ignoremask)
    return r.Main_UpdateLoopInfo(ignoremask)
end

return Main
