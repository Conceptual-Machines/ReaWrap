--- Mock REAPER API for unit testing outside of REAPER.
-- This module provides a fake `reaper` global that simulates enough
-- of the REAPER API to test ReaWrap modules without running REAPER.
--
-- Usage:
--   require("tests.mock.reaper")  -- Sets global `reaper`
--
-- @module mock.reaper
-- @author Nomad Monad
-- @license MIT

local M = {}

--------------------------------------------------------------------------------
-- Internal State
--------------------------------------------------------------------------------

local state = {
    tracks = {},
    items = {},
    takes = {},
    project = nil,
    console_output = {},
}

--- Reset all mock state (call between tests)
function M._reset()
    state = {
        tracks = {},
        items = {},
        takes = {},
        project = nil,
        console_output = {},
    }
end

--- Get console output (for assertions)
function M._get_console_output()
    return table.concat(state.console_output, "")
end

--- Add a mock track
function M._add_track(track_data)
    local track = {
        pointer = #state.tracks,
        name = track_data.name or "Track " .. (#state.tracks + 1),
        volume = track_data.volume or 1.0,
        pan = track_data.pan or 0.0,
        mute = track_data.mute or false,
        solo = track_data.solo or false,
        fx = track_data.fx or {},
        items = track_data.items or {},
        selected = track_data.selected or false,
    }
    table.insert(state.tracks, track)
    return track.pointer
end

--------------------------------------------------------------------------------
-- Console / Debug
--------------------------------------------------------------------------------

function M.ShowConsoleMsg(msg)
    table.insert(state.console_output, tostring(msg))
end

function M.ClearConsole()
    state.console_output = {}
end

--------------------------------------------------------------------------------
-- Project Functions
--------------------------------------------------------------------------------

function M.EnumProjects(idx, projfn)
    if idx == 0 then
        return 0 -- Return project pointer (0 = current project)
    end
    return nil
end

function M.GetProjectName(proj)
    return "MockProject"
end

function M.GetProjectPath()
    return "/mock/project/path"
end

--------------------------------------------------------------------------------
-- Track Functions
--------------------------------------------------------------------------------

function M.CountTracks(proj)
    return #state.tracks
end

function M.GetTrack(proj, idx)
    if idx >= 0 and idx < #state.tracks then
        return state.tracks[idx + 1] -- Convert 0-based to 1-based
    end
    return nil
end

function M.GetSelectedTrack(proj, idx)
    local selected_idx = 0
    for _, track in ipairs(state.tracks) do
        if track.selected then
            if selected_idx == idx then
                return track
            end
            selected_idx = selected_idx + 1
        end
    end
    return nil
end

function M.CountSelectedTracks(proj)
    local count = 0
    for _, track in ipairs(state.tracks) do
        if track.selected then
            count = count + 1
        end
    end
    return count
end

function M.GetTrackName(track)
    if not track then return false, "" end
    return true, track.name or "Track"
end

function M.GetSetMediaTrackInfo_String(track, param, value, is_set)
    if not track then return false, "" end

    if param == "P_NAME" then
        if is_set then
            track.name = value
            return true
        else
            return true, track.name
        end
    end
    return false, ""
end

function M.GetMediaTrackInfo_Value(track, param)
    if not track then return 0 end

    local params = {
        I_TCPH = 0,
        I_TCPY = 0,
        I_WNDH = 100,
        I_FOLDERDEPTH = 0,
        I_FOLDERCOMPACT = 0,
        B_MUTE = track.mute and 1 or 0,
        I_SOLO = track.solo and 1 or 0,
        D_VOL = track.volume,
        D_PAN = track.pan,
        IP_TRACKNUMBER = track.pointer + 1,
    }
    return params[param] or 0
end

function M.SetMediaTrackInfo_Value(track, param, value)
    if not track then return false end

    if param == "B_MUTE" then
        track.mute = value ~= 0
    elseif param == "I_SOLO" then
        track.solo = value ~= 0
    elseif param == "D_VOL" then
        track.volume = value
    elseif param == "D_PAN" then
        track.pan = value
    end
    return true
end

function M.InsertTrackInProject(proj, idx, want_defaults)
    local track = {
        pointer = #state.tracks,
        name = "Track " .. (#state.tracks + 1),
        volume = 1.0,
        pan = 0.0,
        mute = false,
        solo = false,
        fx = {},
        items = {},
        selected = false,
    }
    if idx == -1 then
        table.insert(state.tracks, track)
    else
        table.insert(state.tracks, idx + 1, track)
    end
end

function M.DeleteTrack(track)
    for i, t in ipairs(state.tracks) do
        if t == track then
            table.remove(state.tracks, i)
            return
        end
    end
end

--------------------------------------------------------------------------------
-- Track FX Functions
--------------------------------------------------------------------------------

function M.TrackFX_GetCount(track)
    if not track then return 0 end
    return #(track.fx or {})
end

function M.TrackFX_GetFXName(track, fx_idx)
    if not track or not track.fx then return false, "" end
    local fx = track.fx[fx_idx + 1]
    if fx then
        return true, fx.name or "Unknown FX"
    end
    return false, ""
end

function M.TrackFX_GetNamedConfigParm(track, fx_idx, param_name)
    if not track or not track.fx then return false, "" end
    local fx = track.fx[fx_idx + 1]
    if fx and fx.config and fx.config[param_name] then
        return true, tostring(fx.config[param_name])
    end
    return false, ""
end

function M.TrackFX_SetNamedConfigParm(track, fx_idx, param_name, value)
    if not track or not track.fx then return false end
    local fx = track.fx[fx_idx + 1]
    if fx then
        fx.config = fx.config or {}
        fx.config[param_name] = value
        return true
    end
    return false
end

function M.TrackFX_AddByName(track, name, is_rec_fx, insert_idx)
    if not track then return -1 end
    track.fx = track.fx or {}

    local fx = {
        name = name,
        enabled = true,
        params = {},
        config = {},
    }

    -- Handle container
    if name == "Container" then
        fx.config.container_count = "0"
    end

    if insert_idx == -1 then
        table.insert(track.fx, fx)
        return #track.fx - 1
    else
        table.insert(track.fx, insert_idx + 1, fx)
        return insert_idx
    end
end

function M.TrackFX_Delete(track, fx_idx)
    if not track or not track.fx then return false end
    if fx_idx >= 0 and fx_idx < #track.fx then
        table.remove(track.fx, fx_idx + 1)
        return true
    end
    return false
end

function M.TrackFX_GetEnabled(track, fx_idx)
    if not track or not track.fx then return false end
    local fx = track.fx[fx_idx + 1]
    return fx and fx.enabled or false
end

function M.TrackFX_SetEnabled(track, fx_idx, enabled)
    if not track or not track.fx then return end
    local fx = track.fx[fx_idx + 1]
    if fx then
        fx.enabled = enabled
    end
end

function M.TrackFX_GetNumParams(track, fx_idx)
    if not track or not track.fx then return 0 end
    local fx = track.fx[fx_idx + 1]
    return fx and #(fx.params or {}) or 0
end

function M.TrackFX_GetParam(track, fx_idx, param_idx)
    if not track or not track.fx then return 0, 0, 0 end
    local fx = track.fx[fx_idx + 1]
    if fx and fx.params then
        local param = fx.params[param_idx + 1]
        if param then
            return param.value or 0, param.min or 0, param.max or 1
        end
    end
    return 0, 0, 1
end

function M.TrackFX_SetParam(track, fx_idx, param_idx, value)
    if not track or not track.fx then return false end
    local fx = track.fx[fx_idx + 1]
    if fx then
        fx.params = fx.params or {}
        fx.params[param_idx + 1] = fx.params[param_idx + 1] or {}
        fx.params[param_idx + 1].value = value
        return true
    end
    return false
end

function M.TrackFX_GetParamNormalized(track, fx_idx, param_idx)
    local val, min, max = M.TrackFX_GetParam(track, fx_idx, param_idx)
    if max - min == 0 then return 0 end
    return (val - min) / (max - min)
end

function M.TrackFX_SetParamNormalized(track, fx_idx, param_idx, value)
    if not track or not track.fx then return false end
    local fx = track.fx[fx_idx + 1]
    if fx and fx.params then
        local param = fx.params[param_idx + 1]
        if param then
            local min = param.min or 0
            local max = param.max or 1
            param.value = min + value * (max - min)
            return true
        end
    end
    return false
end

function M.TrackFX_GetInstrument(track)
    -- Return -1 (no instrument) by default
    return -1
end

function M.TrackFX_CopyToTrack(src_track, src_fx, dest_track, dest_fx, is_move)
    -- Simplified mock - just return true
    return true
end

function M.TrackFX_SetFXName(track, fx_idx, name)
    if not track or not track.fx then return false end
    local fx = track.fx[fx_idx + 1]
    if fx then
        fx.name = name
        return true
    end
    return false
end

function M.TrackFX_SetPinMappings(track, fx_idx, is_output, pin, low32, hi32)
    return true
end

function M.TrackFX_GetOpen(track, fx_idx)
    return false
end

function M.TrackFX_SetOpen(track, fx_idx, is_open)
    return
end

--------------------------------------------------------------------------------
-- Media Item Functions
--------------------------------------------------------------------------------

function M.CountMediaItems(proj)
    local count = 0
    for _, track in ipairs(state.tracks) do
        count = count + #(track.items or {})
    end
    return count
end

function M.GetMediaItem(proj, idx)
    local current = 0
    for _, track in ipairs(state.tracks) do
        for _, item in ipairs(track.items or {}) do
            if current == idx then
                return item
            end
            current = current + 1
        end
    end
    return nil
end

function M.CountTrackMediaItems(track)
    if not track then return 0 end
    return #(track.items or {})
end

function M.GetTrackMediaItem(track, idx)
    if not track or not track.items then return nil end
    return track.items[idx + 1]
end

function M.AddMediaItemToTrack(track)
    if not track then return nil end
    track.items = track.items or {}
    local item = {
        position = 0,
        length = 1,
        takes = {},
    }
    table.insert(track.items, item)
    return item
end

function M.GetMediaItemInfo_Value(item, param)
    if not item then return 0 end
    if param == "D_POSITION" then return item.position or 0 end
    if param == "D_LENGTH" then return item.length or 1 end
    return 0
end

function M.SetMediaItemInfo_Value(item, param, value)
    if not item then return false end
    if param == "D_POSITION" then item.position = value; return true end
    if param == "D_LENGTH" then item.length = value; return true end
    return false
end

function M.SetMediaItemPosition(item, pos, refresh)
    if not item then return false end
    item.position = pos
    return true
end

function M.SetMediaItemLength(item, length, refresh)
    if not item then return false end
    item.length = length
    return true
end

--------------------------------------------------------------------------------
-- Utility / Misc Functions
--------------------------------------------------------------------------------

function M.get_action_context()
    return true, "/mock/script/path/script.lua", 0, 0, 0, 0, 0
end

function M.GetAppVersion()
    return "7.0/mock"
end

function M.GetExePath()
    return "/Applications/REAPER.app/Contents/MacOS"
end

function M.GetResourcePath()
    return "/Users/mock/Library/Application Support/REAPER"
end

function M.Undo_BeginBlock()
end

function M.Undo_EndBlock(desc, flags)
end

function M.UpdateArrange()
end

function M.defer(func)
    -- In mock, just call immediately (no defer loop)
    func()
end

function M.runloop(func)
    func()
end

--------------------------------------------------------------------------------
-- ImGui Stubs (return nil/false for most)
--------------------------------------------------------------------------------

function M.ImGui_CreateContext(name)
    return {}
end

function M.ImGui_DestroyContext(ctx)
end

function M.ImGui_GetVersion()
    return "0.0.0-mock"
end

--------------------------------------------------------------------------------
-- Set global `reaper`
--------------------------------------------------------------------------------

-- Only set if not already defined (i.e., not running in REAPER)
if not reaper then
    reaper = M
end

return M
