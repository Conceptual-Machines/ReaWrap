--- Provide implementation for AudioAccessor functions.
-- @author NomadMonad
-- @license MIT
-- @release 0.0.1
-- @module audio_accessor

local r = reaper
local helpers = require("helpers")

local AudioAccessor = {}

--- Create new AudioAccessor instance.
--- @within ReaWrap Custom Methods
--- @param audio_accessor userdata. The pointer to audio accessor
--- @return table AudioAccessor instance
function AudioAccessor:new(audio_accessor)
	local obj = {
		pointer_type = "AudioAccessor*",
		pointer = audio_accessor,
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

--- Log messages with the AudioAccessor logger.
--- @within ReaWrap Custom Methods
--- @param ... (varargs) Messages to log.
function AudioAccessor:log(...)
	local logger = helpers.log_func("AudioAccessor")
	logger(...)
	return nil
end

--- State Changed. Wraps AudioAccessorStateChanged.
-- Returns true if the underlying samples (track or media item take) have changed,
-- but does not update the audio accessor, so the user can selectively call
-- AudioAccessorValidateState only when needed.
--- @within ReaScript Wrapped Methods
--- @return boolean
function AudioAccessor:state_changed()
	return r.AudioAccessorStateChanged(self.pointer)
end

--- Update. Wraps AudioAccessorUpdate.
-- Force the accessor to reload its state from the underlying track or media item
-- take.
--- @within ReaScript Wrapped Methods
function AudioAccessor:update()
	return r.AudioAccessorUpdate(self.pointer)
end

--- Validate State. Wraps AudioAccessorValidateState.
-- Validates the current state of the audio accessor -- must ONLY call this from
-- the main thread. Returns true if the state changed.
--- @within ReaScript Wrapped Methods
--- @return boolean
function AudioAccessor:validate_state()
	return r.AudioAccessorValidateState(self.pointer)
end

--- Destroy. Wraps DestroyAudioAccessor.
-- Destroy an audio accessor. Must only call from the main thread.
--- @within ReaScript Wrapped Methods
function AudioAccessor:destroy()
	return r.DestroyAudioAccessor(self.pointer)
end

--- Get End Time. Wraps GetAudioAccessorEndTime.
-- Get the end time of the audio that can be returned from this accessor.
--- @within ReaScript Wrapped Methods
--- @return number
function AudioAccessor:get_end_time()
	return r.GetAudioAccessorEndTime(self.pointer)
end

--- Get Samples. Wraps GetAudioAccessorSamples.
-- Get a block of samples from the audio accessor. Samples are extracted
-- immediately pre-FX, and returned interleaved (first sample of first channel,
-- first sample of second channel...). Returns 0 if no audio, 1 if audio, -1 on
-- error.
--- @within ReaScript Wrapped Methods
--- @param samplerate number
--- @param num_channels number
--- @param start_time_sec number
--- @param samples_per_channel number
--- @param sample_buffer userdata (reaper.array). A block of samples from the audio accessor.
--- @return number
function AudioAccessor:get_samples(samplerate, num_channels, start_time_sec, samples_per_channel, sample_buffer)
	return r.GetAudioAccessorSamples(
		self.pointer,
		samplerate,
		num_channels,
		start_time_sec,
		samples_per_channel,
		sample_buffer
	)
end

--- Get Start Time. Wraps GetAudioAccessorStartTime.
-- Get the start time of the audio that can be returned from this accessor.
--- @within ReaScript Wrapped Methods
--- @return number
function AudioAccessor:get_start_time()
	return r.GetAudioAccessorStartTime(self.pointer)
end

return AudioAccessor
