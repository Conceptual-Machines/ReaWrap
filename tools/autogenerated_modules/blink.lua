-- @description Blink: Provide implementation for Blink functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local Blink = {}



--- Create new Blink instance.
-- @return Blink table.
function Blink:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the Blink logger.
-- @param ... (varargs) Messages to log.
function Blink:log(...)
    local logger = helpers.log_func('Blink')
    logger(...)
    return nil
end

    
--- Get Audio Buffer Timing Info.
-- Get audio buffer timing information. This is the length (size) of audio buffer
-- in samples, sample rate and 'latest audio buffer switch wall clock time' in
-- seconds.
-- @return len integer
-- @return srate number
-- @return time number
function Blink:get_audio_buffer_timing_info()
    return r.Blink_GetAudioBufferTimingInfo()
end

    
--- Get Beat At Time.
-- Get session beat value corresponding to given time for given quantum.
-- @param time number
-- @param quantum number
-- @return number
function Blink:get_beat_at_time(time, quantum)
    return r.Blink_GetBeatAtTime(time, quantum)
end

    
--- Get Clock Now.
-- Clock used by Blink.
-- @return number
function Blink:get_clock_now()
    return r.Blink_GetClockNow()
end

    
--- Get Enabled.
-- Is Blink currently enabled?
-- @return boolean
function Blink:get_enabled()
    return r.Blink_GetEnabled()
end

    
--- Get Master.
-- Is Blink Master?
-- @return boolean
function Blink:get_master()
    return r.Blink_GetMaster()
end

    
--- Get Num Peers.
-- How many peers are currently connected in Link session?
-- @return integer
function Blink:get_num_peers()
    return r.Blink_GetNumPeers()
end

    
--- Get Phase At Time.
-- Get session phase at given time for given quantum.
-- @param time number
-- @param quantum number
-- @return number
function Blink:get_phase_at_time(time, quantum)
    return r.Blink_GetPhaseAtTime(time, quantum)
end

    
--- Get Playing.
-- Is transport playing?
-- @return boolean
function Blink:get_playing()
    return r.Blink_GetPlaying()
end

    
--- Get Puppet.
-- Is Blink Puppet?
-- @return boolean
function Blink:get_puppet()
    return r.Blink_GetPuppet()
end

    
--- Get Quantum.
-- Get quantum.
-- @return number
function Blink:get_quantum()
    return r.Blink_GetQuantum()
end

    
--- Get Start Stop Sync Enabled.
-- Is start/stop synchronization enabled?
-- @return boolean
function Blink:get_start_stop_sync_enabled()
    return r.Blink_GetStartStopSyncEnabled()
end

    
--- Get Tempo.
-- Tempo of timeline, in quarter note Beats Per Minute.
-- @return number
function Blink:get_tempo()
    return r.Blink_GetTempo()
end

    
--- Get Time At Beat.
-- Get time at which given beat occurs for given quantum.
-- @param beat number
-- @param quantum number
-- @return number
function Blink:get_time_at_beat(beat, quantum)
    return r.Blink_GetTimeAtBeat(beat, quantum)
end

    
--- Get Time For Playing.
-- Get time at which transport start/stop occurs.
-- @return number
function Blink:get_time_for_playing()
    return r.Blink_GetTimeForPlaying()
end

    
--- Get Timeline Offset.
-- Get timeline offset. This is the offset between REAPER timeline and Link session
-- timeline.
-- @return number
function Blink:get_timeline_offset()
    return r.Blink_GetTimelineOffset()
end

    
--- Get Version.
-- Get Blink version.
-- @return number
function Blink:get_version()
    return r.Blink_GetVersion()
end

    
--- Set Beat At Start Playing Time Request.
-- Convenience function to attempt to map given beat to time when transport is
-- starting to play in context of given quantum. This function evaluates to a no-op
-- if GetPlaying() equals false.
-- @param beat number
-- @param quantum number
function Blink:set_beat_at_start_playing_time_request(beat, quantum)
    return r.Blink_SetBeatAtStartPlayingTimeRequest(beat, quantum)
end

    
--- Set Beat At Time Force.
-- Rudely re-map beat/time relationship for all peers in Link session.
-- @param bpm number
-- @param time number
-- @param quantum number
function Blink:set_beat_at_time_force(bpm, time, quantum)
    return r.Blink_SetBeatAtTimeForce(bpm, time, quantum)
end

    
--- Set Beat At Time Request.
-- Attempt to map given beat to given time in context of given quantum.
-- @param bpm number
-- @param time number
-- @param quantum number
function Blink:set_beat_at_time_request(bpm, time, quantum)
    return r.Blink_SetBeatAtTimeRequest(bpm, time, quantum)
end

    
--- Set Capture Transport Commands.
-- Captures REAPER Transport commands and 'Tempo: Increase/Decrease current project
-- tempo by' commands and broadcasts them into Link session. When used with Master
-- or Puppet mode enabled, provides better integration between REAPER and Link
-- session transport and tempos.
-- @param enable boolean
function Blink:set_capture_transport_commands(enable)
    return r.Blink_SetCaptureTransportCommands(enable)
end

    
--- Set Enabled.
-- Enable/disable Blink. In Blink methods transport, tempo and timeline refer to
-- Link session, not local REAPER instance.
-- @param enable boolean
function Blink:set_enabled(enable)
    return r.Blink_SetEnabled(enable)
end

    
--- Set Launch Offset.
-- Set launch offset. This is used to compensate for possible constant REAPER
-- transport launch delay, if such exists.
-- @param offset number
function Blink:set_launch_offset(offset)
    return r.Blink_SetLaunchOffset(offset)
end

    
--- Set Master.
-- Set Blink as Master. Puppet needs to be enabled first. Same as Puppet, but
-- possible beat offset is broadcast to Link session, effectively forcing local
-- REAPER timeline on peers. Only one, if any, Blink should be Master in Link
-- session.
-- @param enable boolean
function Blink:set_master(enable)
    return r.Blink_SetMaster(enable)
end

    
--- Set Playing.
-- Set if transport should be playing or stopped, taking effect at given time.
-- @param playing boolean
-- @param time number
function Blink:set_playing(playing, time)
    return r.Blink_SetPlaying(playing, time)
end

    
--- Set Playing And Beat At Time Request.
-- Convenience function to start or stop transport at given time and attempt to map
-- given beat to this time in context of given quantum.
-- @param playing boolean
-- @param time number
-- @param beat number
-- @param quantum number
function Blink:set_playing_and_beat_at_time_request(playing, time, beat, quantum)
    return r.Blink_SetPlayingAndBeatAtTimeRequest(playing, time, beat, quantum)
end

    
--- Set Puppet.
-- Set Blink as Puppet. When enabled, Blink attempts to synchronize local REAPER
-- tempo to Link session tempo by adjusting current active tempo/time signature
-- marker, or broadcasts local REAPER tempo changes into Link session, and attempts
-- to correct possible offset by adjusting REAPER playrate. Based on cumulative
-- single beat phase since Link session transport start, regardless of quantum.
-- @param enable boolean
function Blink:set_puppet(enable)
    return r.Blink_SetPuppet(enable)
end

    
--- Set Quantum.
-- Set quantum. Usually this is set to length of one measure/bar in quarter notes.
-- @param quantum number
function Blink:set_quantum(quantum)
    return r.Blink_SetQuantum(quantum)
end

    
--- Set Start Stop Sync Enabled.
-- Enable start/stop synchronization.
-- @param enable boolean
function Blink:set_start_stop_sync_enabled(enable)
    return r.Blink_SetStartStopSyncEnabled(enable)
end

    
--- Set Tempo.
-- Set timeline tempo to given bpm value.
-- @param bpm number
function Blink:set_tempo(bpm)
    return r.Blink_SetTempo(bpm)
end

    
--- Set Tempo At Time.
-- Set tempo to given bpm value, taking effect (heard from speakers)at given wall
-- clock time.
-- @param bpm number
-- @param time number
function Blink:set_tempo_at_time(bpm, time)
    return r.Blink_SetTempoAtTime(bpm, time)
end

    
--- Start Stop.
-- Transport start/stop.
function Blink:start_stop()
    return r.Blink_StartStop()
end

return Blink
