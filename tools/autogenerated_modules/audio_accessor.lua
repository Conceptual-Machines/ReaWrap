-- @description Provide implementation for AudioAccessor functions.
-- @author NomadMonad
-- @license MIT

local r = reaper
local helpers = require('helpers')


local AudioAccessor = {}



--- Create new AudioAccessor instance.
-- @param audio_accessor . The pointer to audio accessor
-- @return AudioAccessor table.
function AudioAccessor:new(audio_accessor)
    local obj = {
        pointer_type = "AudioAccessor*",
        pointer = audio_accessor
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- @section ReaWrap Custom Methods

--- Log messages with the AudioAccessor logger.
-- @param ... (varargs) Messages to log.
function AudioAccessor:log(...)
    local logger = helpers.log_func('AudioAccessor')
    logger(...)
    return nil
end


-- @section ReaScript API Methods




--- State Changed. Wraps AudioAccessorStateChanged.
-- Returns true if the underlying samples (track or media item take) have changed,
-- but does not update the audio accessor, so the user can selectively call
-- AudioAccessorValidateState only when needed. See CreateTakeAudioAccessor,
-- CreateTrackAudioAccessor, DestroyAudioAccessor, GetAudioAccessorEndTime,
-- GetAudioAccessorSamples.
-- @return boolean
function AudioAccessor:state_changed()
    return r.AudioAccessorStateChanged(self.pointer)
end


--- Update. Wraps AudioAccessorUpdate.
-- Force the accessor to reload its state from the underlying track or media item
-- take. See CreateTakeAudioAccessor, CreateTrackAudioAccessor,
-- DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime,
-- GetAudioAccessorEndTime, GetAudioAccessorSamples.
function AudioAccessor:update()
    return r.AudioAccessorUpdate(self.pointer)
end


--- Validate State. Wraps AudioAccessorValidateState.
-- Validates the current state of the audio accessor -- must ONLY call this from
-- the main thread. Returns true if the state changed.
-- @return boolean
function AudioAccessor:validate_state()
    return r.AudioAccessorValidateState(self.pointer)
end


--- Destroy. Wraps DestroyAudioAccessor.
-- Destroy an audio accessor. Must only call from the main thread. See
-- CreateTakeAudioAccessor, CreateTrackAudioAccessor, AudioAccessorStateChanged,
-- GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
function AudioAccessor:destroy()
    return r.DestroyAudioAccessor(self.pointer)
end


--- Get End Time. Wraps GetAudioAccessorEndTime.
-- Get the end time of the audio that can be returned from this accessor. See
-- CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor,
-- AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorSamples.
-- @return number
function AudioAccessor:get_end_time()
    return r.GetAudioAccessorEndTime(self.pointer)
end


--- Get Samples. Wraps GetAudioAccessorSamples.
-- Get a block of samples from the audio accessor. Samples are extracted
-- immediately pre-FX, and returned interleaved (first sample of first channel,
-- first sample of second channel...). Returns 0 if no audio, 1 if audio, -1 on
-- error. See CreateTakeAudioAccessor, CreateTrackAudioAccessor,
-- DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime,
-- GetAudioAccessorEndTime.
-- @param samplerate number
-- @param numchannels number
-- @param starttime_sec number
-- @param numsamplesperchannel number
-- @param samplebuffer reaper.array
-- @return number
function AudioAccessor:get_samples(samplerate, numchannels, starttime_sec, numsamplesperchannel, samplebuffer)
    return r.GetAudioAccessorSamples(self.pointer, samplerate, numchannels, starttime_sec, numsamplesperchannel, samplebuffer)
end


--- Get Start Time. Wraps GetAudioAccessorStartTime.
-- Get the start time of the audio that can be returned from this accessor. See
-- CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor,
-- AudioAccessorStateChanged, GetAudioAccessorEndTime, GetAudioAccessorSamples.
-- @return number
function AudioAccessor:get_start_time()
    return r.GetAudioAccessorStartTime(self.pointer)
end

return AudioAccessor
