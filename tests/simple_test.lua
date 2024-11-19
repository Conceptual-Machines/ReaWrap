local current_dir = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
local root_dir = current_dir:match('^(.+/)tests/')

-- Update package.path to include the root directory and models directory
package.path = package.path .. ';' .. root_dir .. '?.lua;'

-- Debugging paths
reaper.ShowConsoleMsg("Current script path: " .. current_dir .. "\n")
reaper.ShowConsoleMsg("Root path added: " .. root_dir .. "\n")
reaper.ShowConsoleMsg("Updated package.path: " .. package.path .. "\n")

-- Require ReaWrap
local ReaWrap = require('init')

-- Test ReaWrap
local rea_wrap = ReaWrap.reaper:new()
rea_wrap:log('Reaper version: ' .. rea_wrap:get_app_version())

local project = ReaWrap.project:new()

local function test_iter_tracks()
    for sel_track in project:iter_selected_tracks() do
        project:log(sel_track)
    end
end

test_iter_tracks()
