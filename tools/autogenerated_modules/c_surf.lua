-- @description CSurf: Provide implementation for CSurf functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_track = require('media_track')


local CSurf = {}



--- Create new CSurf instance.
-- @return CSurf table.
function CSurf:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the CSurf logger.
-- @param ... (varargs) Messages to log.
function CSurf:log(...)
    local logger = helpers.log_func('CSurf')
    logger(...)
    return nil
end

    
--- Flush Undo.
-- call this to force flushing of the undo states after using CSurf_On*Change()
-- @param force boolean
function CSurf:flush_undo(force)
    return r.CSurf_FlushUndo(force)
end

    
--- Get Touch State.
-- @param is__pan integer
-- @return boolean
function CSurf:get_touch_state(is__pan)
    return r.CSurf_GetTouchState(self.pointer, is__pan)
end

    
--- Go End.
function CSurf:go_end()
    return r.CSurf_GoEnd()
end

    
--- Go Start.
function CSurf:go_start()
    return r.CSurf_GoStart()
end

    
--- Num Tracks.
-- @param mcp_view boolean
-- @return integer
function CSurf:num_tracks(mcp_view)
    return r.CSurf_NumTracks(mcp_view)
end

    
--- On Arrow.
-- @param whichdir integer
-- @param wantzoom boolean
function CSurf:on_arrow(whichdir, wantzoom)
    return r.CSurf_OnArrow(whichdir, wantzoom)
end

    
--- On Fwd.
-- @param seekplay integer
function CSurf:on_fwd(seekplay)
    return r.CSurf_OnFwd(seekplay)
end

    
--- On Fx Change.
-- @param en integer
-- @return boolean
function CSurf:on_fx_change(en)
    return r.CSurf_OnFXChange(self.pointer, en)
end

    
--- On Input Monitor Change.
-- @param monitor integer
-- @return integer
function CSurf:on_input_monitor_change(monitor)
    return r.CSurf_OnInputMonitorChange(self.pointer, monitor)
end

    
--- On Input Monitor Change Ex.
-- @param monitor integer
-- @param allowgang boolean
-- @return integer
function CSurf:on_input_monitor_change_ex(monitor, allowgang)
    return r.CSurf_OnInputMonitorChangeEx(self.pointer, monitor, allowgang)
end

    
--- On Mute Change.
-- @param mute integer
-- @return boolean
function CSurf:on_mute_change(mute)
    return r.CSurf_OnMuteChange(self.pointer, mute)
end

    
--- On Mute Change Ex.
-- @param mute integer
-- @param allowgang boolean
-- @return boolean
function CSurf:on_mute_change_ex(mute, allowgang)
    return r.CSurf_OnMuteChangeEx(self.pointer, mute, allowgang)
end

    
--- On Pan Change.
-- @param pan number
-- @param relative boolean
-- @return number
function CSurf:on_pan_change(pan, relative)
    return r.CSurf_OnPanChange(self.pointer, pan, relative)
end

    
--- On Pan Change Ex.
-- @param pan number
-- @param relative boolean
-- @param allow_gang boolean
-- @return number
function CSurf:on_pan_change_ex(pan, relative, allow_gang)
    return r.CSurf_OnPanChangeEx(self.pointer, pan, relative, allow_gang)
end

    
--- On Pause.
function CSurf:on_pause()
    return r.CSurf_OnPause()
end

    
--- On Play.
function CSurf:on_play()
    return r.CSurf_OnPlay()
end

    
--- On Play Rate Change.
-- @param playrate number
function CSurf:on_play_rate_change(playrate)
    return r.CSurf_OnPlayRateChange(playrate)
end

    
--- On Rec Arm Change.
-- @param recarm integer
-- @return boolean
function CSurf:on_rec_arm_change(recarm)
    return r.CSurf_OnRecArmChange(self.pointer, recarm)
end

    
--- On Rec Arm Change Ex.
-- @param recarm integer
-- @param allowgang boolean
-- @return boolean
function CSurf:on_rec_arm_change_ex(recarm, allowgang)
    return r.CSurf_OnRecArmChangeEx(self.pointer, recarm, allowgang)
end

    
--- On Record.
function CSurf:on_record()
    return r.CSurf_OnRecord()
end

    
--- On Recv Pan Change.
-- @param recv_index integer
-- @param pan number
-- @param relative boolean
-- @return number
function CSurf:on_recv_pan_change(recv_index, pan, relative)
    return r.CSurf_OnRecvPanChange(self.pointer, recv_index, pan, relative)
end

    
--- On Recv Volume Change.
-- @param recv_index integer
-- @param volume number
-- @param relative boolean
-- @return number
function CSurf:on_recv_volume_change(recv_index, volume, relative)
    return r.CSurf_OnRecvVolumeChange(self.pointer, recv_index, volume, relative)
end

    
--- On Rew.
-- @param seekplay integer
function CSurf:on_rew(seekplay)
    return r.CSurf_OnRew(seekplay)
end

    
--- On Rew Fwd.
-- @param seekplay integer
-- @param dir integer
function CSurf:on_rew_fwd(seekplay, dir)
    return r.CSurf_OnRewFwd(seekplay, dir)
end

    
--- On Scroll.
-- @param xdir integer
-- @param ydir integer
function CSurf:on_scroll(xdir, ydir)
    return r.CSurf_OnScroll(xdir, ydir)
end

    
--- On Selected Change.
-- @param selected integer
-- @return boolean
function CSurf:on_selected_change(selected)
    return r.CSurf_OnSelectedChange(self.pointer, selected)
end

    
--- On Send Pan Change.
-- @param send_index integer
-- @param pan number
-- @param relative boolean
-- @return number
function CSurf:on_send_pan_change(send_index, pan, relative)
    return r.CSurf_OnSendPanChange(self.pointer, send_index, pan, relative)
end

    
--- On Send Volume Change.
-- @param send_index integer
-- @param volume number
-- @param relative boolean
-- @return number
function CSurf:on_send_volume_change(send_index, volume, relative)
    return r.CSurf_OnSendVolumeChange(self.pointer, send_index, volume, relative)
end

    
--- On Solo Change.
-- @param solo integer
-- @return boolean
function CSurf:on_solo_change(solo)
    return r.CSurf_OnSoloChange(self.pointer, solo)
end

    
--- On Solo Change Ex.
-- @param solo integer
-- @param allowgang boolean
-- @return boolean
function CSurf:on_solo_change_ex(solo, allowgang)
    return r.CSurf_OnSoloChangeEx(self.pointer, solo, allowgang)
end

    
--- On Stop.
function CSurf:on_stop()
    return r.CSurf_OnStop()
end

    
--- On Tempo Change.
-- @param bpm number
function CSurf:on_tempo_change(bpm)
    return r.CSurf_OnTempoChange(bpm)
end

    
--- On Track Selection.
function CSurf:on_track_selection()
    return r.CSurf_OnTrackSelection(self.pointer)
end

    
--- On Volume Change.
-- @param volume number
-- @param relative boolean
-- @return number
function CSurf:on_volume_change(volume, relative)
    return r.CSurf_OnVolumeChange(self.pointer, volume, relative)
end

    
--- On Volume Change Ex.
-- @param volume number
-- @param relative boolean
-- @param allow_gang boolean
-- @return number
function CSurf:on_volume_change_ex(volume, relative, allow_gang)
    return r.CSurf_OnVolumeChangeEx(self.pointer, volume, relative, allow_gang)
end

    
--- On Width Change.
-- @param width number
-- @param relative boolean
-- @return number
function CSurf:on_width_change(width, relative)
    return r.CSurf_OnWidthChange(self.pointer, width, relative)
end

    
--- On Width Change Ex.
-- @param width number
-- @param relative boolean
-- @param allow_gang boolean
-- @return number
function CSurf:on_width_change_ex(width, relative, allow_gang)
    return r.CSurf_OnWidthChangeEx(self.pointer, width, relative, allow_gang)
end

    
--- On Zoom.
-- @param xdir integer
-- @param ydir integer
function CSurf:on_zoom(xdir, ydir)
    return r.CSurf_OnZoom(xdir, ydir)
end

    
--- Reset All Cached Vol Pan States.
function CSurf:reset_all_cached_vol_pan_states()
    return r.CSurf_ResetAllCachedVolPanStates()
end

    
--- Scrub Amt.
-- @param amt number
function CSurf:scrub_amt(amt)
    return r.CSurf_ScrubAmt(amt)
end

    
--- Set Auto Mode.
-- @param mode integer
-- @param ignoresurf IReaperControlSurface
function CSurf:set_auto_mode(mode, ignoresurf)
    return r.CSurf_SetAutoMode(mode, ignoresurf)
end

    
--- Set Play State.
-- @param play boolean
-- @param pause boolean
-- @param rec boolean
-- @param ignoresurf IReaperControlSurface
function CSurf:set_play_state(play, pause, rec, ignoresurf)
    return r.CSurf_SetPlayState(play, pause, rec, ignoresurf)
end

    
--- Set Repeat State.
-- @param rep boolean
-- @param ignoresurf IReaperControlSurface
function CSurf:set_repeat_state(rep, ignoresurf)
    return r.CSurf_SetRepeatState(rep, ignoresurf)
end

    
--- Set Surface Mute.
-- @param mute boolean
-- @param ignoresurf IReaperControlSurface
function CSurf:set_surface_mute(mute, ignoresurf)
    return r.CSurf_SetSurfaceMute(self.pointer, mute, ignoresurf)
end

    
--- Set Surface Pan.
-- @param pan number
-- @param ignoresurf IReaperControlSurface
function CSurf:set_surface_pan(pan, ignoresurf)
    return r.CSurf_SetSurfacePan(self.pointer, pan, ignoresurf)
end

    
--- Set Surface Rec Arm.
-- @param recarm boolean
-- @param ignoresurf IReaperControlSurface
function CSurf:set_surface_rec_arm(recarm, ignoresurf)
    return r.CSurf_SetSurfaceRecArm(self.pointer, recarm, ignoresurf)
end

    
--- Set Surface Selected.
-- @param selected boolean
-- @param ignoresurf IReaperControlSurface
function CSurf:set_surface_selected(selected, ignoresurf)
    return r.CSurf_SetSurfaceSelected(self.pointer, selected, ignoresurf)
end

    
--- Set Surface Solo.
-- @param solo boolean
-- @param ignoresurf IReaperControlSurface
function CSurf:set_surface_solo(solo, ignoresurf)
    return r.CSurf_SetSurfaceSolo(self.pointer, solo, ignoresurf)
end

    
--- Set Surface Volume.
-- @param volume number
-- @param ignoresurf IReaperControlSurface
function CSurf:set_surface_volume(volume, ignoresurf)
    return r.CSurf_SetSurfaceVolume(self.pointer, volume, ignoresurf)
end

    
--- Set Track List Change.
function CSurf:set_track_list_change()
    return r.CSurf_SetTrackListChange()
end

    
--- Track From Id.
-- @param _idx integer
-- @param mcp_view boolean
-- @return MediaTrack table
function CSurf:track_from_id(_idx, mcp_view)
    local result = r.CSurf_TrackFromID(_idx, mcp_view)
    return media_track.MediaTrack:new(result)
end

    
--- Track To Id.
-- @param mcp_view boolean
-- @return integer
function CSurf:track_to_id(mcp_view)
    return r.CSurf_TrackToID(self.pointer, mcp_view)
end

return CSurf
