--- Provide implementation for PCM functions.
-- @author NomadMonad
-- @license MIT
-- @release 0.0.1

local r = reaper
local helpers = require("helpers")

-- @class PCM
-- Abstracts PCM_source.
local PCM = {}

--- Create new PCM instance.
--- @param source userdata The pointer to PCM_source*
--- @return table PCM object
function PCM:new(source)
	local obj = {
		pointer_type = "PCM_source*",
		pointer = source,
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

-- @section ReaWrap Custom Methods

--- Log messages with the PCM logger.
--- @param ... (varargs) Messages to log.
function PCM:log(...)
	local logger = helpers.log_func("PCM")
	logger(...)
	return nil
end

-- @section ReaScript API Methods

--- Calc Media Src Loudness. Wraps CalcMediaSrcLoudness.
-- Calculates loudness statistics of media via dry run render. Statistics will be
-- displayed to the user; call GetSetProjectInfo_String("RENDER_STATS") to retrieve
-- via API. Returns 1 if loudness was calculated successfully, -1 if user canceled
-- the dry run render.
--- @return number
function PCM:calc_media_src_loudness()
	return r.CalcMediaSrcLoudness(self.mediasource.pointer)
end

--- Calculate Normalization. Wraps CalculateNormalization.
-- Calculate normalize adjustment for source media. normalizeTo: 0=LUFS-I, 1=RMS-I,
-- 2=peak, 3=true peak, 4=LUFS-M max, 5=LUFS-S max. normalizeTarget: dBFS or LUFS
-- value. normalizeStart, normalizeEnd: time bounds within source media for
-- normalization calculation. If normalizationStart=0 and normalizationEnd=0, the
-- full duration of the media will be used for the calculation.
--- @param normalize_to number
--- @param normalize_target number
--- @param normalize_start number
--- @param normalize_end number
--- @return number
function PCM:calculate_normalization(normalize_to, normalize_target, normalize_start, normalize_end)
	return r.CalculateNormalization(self.pointer, normalize_to, normalize_target, normalize_start, normalize_end)
end

--- Get Media File Metadata. Wraps GetMediaFileMetadata.
-- Get text-based metadata from a media file for a given identifier. Call with
-- identifier="" to list all identifiers contained in the file, separated by
-- newlines. May return "[Binary data]" for metadata that REAPER doesn't handle.
--- @param identifier string
--- @return string buf
function PCM:get_media_file_metadata(identifier)
	local ret_val, buf = r.GetMediaFileMetadata(self.media_source.pointer, identifier)
	if ret_val then
		return buf
	else
		error("Failed to get media file metadata.")
	end
end

--- Get Media Source File Name. Wraps GetMediaSourceFileName.
-- Copies the media source filename to filenamebuf. Note that in-project MIDI media
-- sources have no associated filename. See GetMediaSourceParent.
--- @return string filenamebuf
function PCM:get_media_source_file_name()
	return r.GetMediaSourceFileName(self.pointer)
end

--- Get Media Source Length. Wraps GetMediaSourceLength.
-- Returns the length of the source media. If the media source is beat-based, the
-- length will be in quarter notes, otherwise it will be in seconds.
--- @return boolean length_is_qn
function PCM:get_media_source_length()
	local ret_val, length_is_qn = r.GetMediaSourceLength(self.pointer)
	if ret_val then
		return length_is_qn
	else
		error("Failed to get media source length.")
	end
end

--- Get Media Source Num Channels. Wraps GetMediaSourceNumChannels.
-- Returns the number of channels in the source media.
--- @return number
function PCM:get_media_source_num_channels()
	return r.GetMediaSourceNumChannels(self.pointer)
end

--- Get Media Source Parent. Wraps GetMediaSourceParent.
-- Returns the parent source, or NULL if src is the root source. This can be used
-- to retrieve the parent properties of sections or reversed sources for example.
--- @return userdata
function PCM:get_media_source_parent()
	local PCM_source = require("pcm_source")
	local result = r.GetMediaSourceParent(self.pointer)
	return PCM_source:new(result)
end

--- Get Media Source Sample Rate. Wraps GetMediaSourceSampleRate.
-- Returns the sample rate. MIDI source media will return zero.
--- @return number
function PCM:get_media_source_sample_rate()
	return r.GetMediaSourceSampleRate(self.pointer)
end

--- Get Media Source Type. Wraps GetMediaSourceType.
-- copies the media source type ("WAV", "MIDI", etc) to typebuf
--- @return string
function PCM:get_media_source_type()
	return r.GetMediaSourceType(self.pointer)
end

--- Get Sub Project From Source. Wraps GetSubProjectFromSource.
--- @return table Project object
function PCM:get_sub_project_from_source()
	local Project = require("project")
	local result = r.GetSubProjectFromSource(self.pointer)
	return Project:new(result)
end

--- Get Tempo Match Play Rate. Wraps GetTempoMatchPlayRate.
-- finds the playrate and target length to insert this item stretched to a round
-- power-of-2 number of bars, between 1/8 and 256
--- @param srcscale number
--- @param position number
--- @param mult number
--- @return number rate
--- @return number targetlen
function PCM:get_tempo_match_play_rate(srcscale, position, mult)
	local ret_val, rate, targetlen = r.GetTempoMatchPlayRate(self.pointer, srcscale, position, mult)
	if ret_val then
		return rate, targetlen
	else
		error("Failed to get tempo match play rate.")
	end
end

--- Sink Enum. Wraps PCM_Sink_Enum.
--- @param idx number
--- @return string
function PCM:sink_enum(idx)
	local ret_val, descstr = r.PCM_Sink_Enum(idx)
	if ret_val then
		return descstr
	else
		error("Failed to enumerate sink.")
	end
end

--- Sink Get Extension. Wraps PCM_Sink_GetExtension.
--- @param data string
--- @return string
function PCM:sink_get_extension(data)
	return r.PCM_Sink_GetExtension(data)
end

--- Sink Show Config. Wraps PCM_Sink_ShowConfig.
--- @param cfg string
--- @param hwnd_parent userdata HWND
--- @return userdata HWND
function PCM:sink_show_config(cfg, hwnd_parent)
	return r.PCM_Sink_ShowConfig(cfg, hwnd_parent)
end

--- Source Build Peaks. Wraps PCM_Source_BuildPeaks.
-- Calls and returns PCM_source::PeaksBuild_Begin() if mode=0, PeaksBuild_Run() if
-- mode=1, and PeaksBuild_Finish() if mode=2. Normal use is to call
-- PCM_Source_BuildPeaks(src,0), and if that returns nonzero, call
-- PCM_Source_BuildPeaks(src,1) periodically until it returns zero (it returns the
-- percentage of the file remaining), then call PCM_Source_BuildPeaks(src,2) to
-- finalize. If PCM_Source_BuildPeaks(src,0) returns zero, then no further action
-- is necessary.
--- @param mode number
--- @return number
function PCM:source_build_peaks(mode)
	return r.PCM_Source_BuildPeaks(self.pointer, mode)
end

--- Source Create From File. Wraps PCM_Source_CreateFromFile.
-- See PCM_Source_CreateFromFileEx.
--- @param file_name string
--- @return table PCM object
function PCM:source_create_from_file(file_name)
	local result = r.PCM_Source_CreateFromFile(file_name)
	return self:new(result)
end

--- Source Create From File Ex. Wraps PCM_Source_CreateFromFileEx.
-- Create a PCM_source from filename, and override pref of MIDI files being
-- imported as in-project MIDI events.
--- @param file_name string
--- @param forceno_midi_imp boolean
--- @return table PCM object
function PCM:source_create_from_file_ex(file_name, forceno_midi_imp)
	local result = r.PCM_Source_CreateFromFileEx(file_name, forceno_midi_imp)
	return self:new(result)
end

--- Source Create From Type. Wraps PCM_Source_CreateFromType.
-- Create a PCM_source from a "type" (use this if you're going to load its state
-- via LoadState/ProjectStateContext). Valid types include "WAVE", "MIDI", or
-- whatever plug-ins define as well.
--- @param source_type string
--- @return table PCM object
function PCM:source_create_from_type(source_type)
	local result = r.PCM_Source_CreateFromType(source_type)
	return PCM:new(result)
end

--- Source Destroy. Wraps PCM_Source_Destroy.
-- Deletes a PCM_source -- be sure that you remove any project reference before
-- deleting a source
function PCM:source_destroy()
	return r.PCM_Source_Destroy(self.pointer)
end

--- Source Get Peaks. Wraps PCM_Source_GetPeaks.
-- Gets block of peak samples to buf. Note that the peak samples are interleaved,
-- but in two or three blocks (maximums, then minimums, then extra). Return value
-- has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000),
-- then a bit to signify whether extra_type was available (0x1000000). extra_type
-- can be 115 ('s') for spectral information, which will return peak samples as
-- integers with the low 15 bits frequency, next 14 bits tonality.
--- @param peakrate number
--- @param starttime number
--- @param numchannels number
--- @param numsamplesperchannel number
--- @param want_extra_type number
--- @param buf userdata
--- @return number
function PCM:source_get_peaks(peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
	return r.PCM_Source_GetPeaks(
		self.pointer,
		peakrate,
		starttime,
		numchannels,
		numsamplesperchannel,
		want_extra_type,
		buf
	)
end

--- Source Get Section Info. Wraps PCM_Source_GetSectionInfo.
-- If a section/reverse block, retrieves offset/len/reverse. return true if success
--- @return number offs
--- @return number len
--- @return boolean rev
function PCM:source_get_section_info()
	local ret_val, offs, len, rev = r.PCM_Source_GetSectionInfo(self.pointer)
	if ret_val then
		return offs, len, rev
	else
		error("Failed to get source section info.")
	end
end

--- Create Preview. Wraps CF_CreatePreview.
-- Create a new preview object. Does not take ownership of the source (don't forget
-- to destroy it unless it came from a take!). See CF_Preview_Play and the others
-- CF_Preview_* functions.
--- @return userdata
function PCM:create_preview()
	return r.CF_CreatePreview(self.pointer)
end

--- Enum Media Source Cues. Wraps CF_EnumMediaSourceCues.
-- Enumerate the source's media cues. Returns the next index or 0 when finished.
--- @param index number
--- @return number time
--- @return number end_time
--- @return boolean is_region
--- @return string name
--- @return boolean is_chapter
function PCM:enum_media_source_cues(index)
	local ret_val, time, end_time, is_region, name, is_chapter = r.CF_EnumMediaSourceCues(self.pointer, index)
	if ret_val then
		return time, end_time, is_region, name, is_chapter
	else
		error("Failed to enumerate media source cues.")
	end
end

--- Export Media Source. Wraps CF_ExportMediaSource.
-- Export the source to the given file (MIDI only).
--- @param file_name string
--- @return boolean
function PCM:export_media_source(file_name)
	return r.CF_ExportMediaSource(self.pointer, file_name)
end

--- Get Media Source Bit Depth. Wraps CF_GetMediaSourceBitDepth.
-- Returns the bit depth if available (0 otherwise).
--- @return number
function PCM:get_media_source_bit_depth()
	return r.CF_GetMediaSourceBitDepth(self.pointer)
end

--- Get Media Source Bit Rate. Wraps CF_GetMediaSourceBitRate.
-- Returns the bit rate for WAVE (wav, aif) and streaming/variable formats (mp3,
-- ogg, opus). REAPER v6.19 or later is required for non-WAVE formats.
--- @return number
function PCM:get_media_source_bit_rate()
	return r.CF_GetMediaSourceBitRate(self.pointer)
end

--- Get Media Source Metadata. Wraps CF_GetMediaSourceMetadata.
-- Get the value of the given metadata field (eg. DESC, ORIG, ORIGREF, DATE, TIME,
-- UMI, CODINGHISTORY for BWF).
--- @param name string
--- @param out string
--- @return string
function PCM:get_media_source_metadata(name, out)
	local ret_val, out = r.CF_GetMediaSourceMetadata(self.pointer, name, out)
	if ret_val then
		return out
	else
		error("Failed to get media source metadata.")
	end
end

--- Get Media Source Online. Wraps CF_GetMediaSourceOnline.
-- Returns the online/offline status of the given source.
--- @return boolean
function PCM:get_media_source_online()
	return r.CF_GetMediaSourceOnline(self.pointer)
end

--- Get Media Source Rpp. Wraps CF_GetMediaSourceRPP.
-- Get the project associated with this source (BWF, subproject...).
--- @return string
function PCM:get_media_source_rpp()
	local ret_val, fn = r.CF_GetMediaSourceRPP(self.pointer)
	if ret_val then
		return fn
	else
		error("Failed to get media source RPP.")
	end
end

--- Source Set Section Info. Wraps CF_PCM_Source_SetSectionInfo.
-- Give a section source created using PCM_Source_CreateFromType("SECTION"). Offset
-- and length are ignored if 0. Negative length to subtract from the total length
-- of the source.
--- @param offset number
--- @param length number
--- @param reverse boolean
--- @param fade_in number Optional
--- @return boolean
function PCM:source_set_section_info(section, offset, length, reverse, fade_in)
	local fade_in = fade_in or nil
	return r.CF_PCM_Source_SetSectionInfo(section, self.pointer, offset, length, reverse, fade_in)
end

--- Set Media Source Online. Wraps CF_SetMediaSourceOnline.
-- Set the online/offline status of the given source (closes files when set=false).
--- @param set boolean
function PCM:set_media_source_online(set)
	return r.CF_SetMediaSourceOnline(self.pointer, set)
end

--- Source Get Sample Value. Wraps GU_PCM_Source_GetSampleValue.
-- Gets a PCM_source's sample value at a point in time (seconds)
--- @param time number
--- @return number
function PCM:source_get_sample_value(time)
	return r.GU_PCM_Source_GetSampleValue(self.pointer, time)
end

--- Source Has Region. Wraps GU_PCM_Source_HasRegion.
-- Checks if PCM_source has embedded Media Cue Markers
--- @return boolean
function PCM:source_has_region()
	return r.GU_PCM_Source_HasRegion(self.pointer)
end

--- Source Is Mono. Wraps GU_PCM_Source_IsMono.
-- Checks if PCM_source is mono by comparing all channels
--- @return boolean
function PCM:source_is_mono()
	return r.GU_PCM_Source_IsMono(self.pointer)
end

--- Source Time To Peak. Wraps GU_PCM_Source_TimeToPeak.
-- Returns duration in seconds for PCM_source from start til peak threshold is
-- breached. Returns -1 if invalid
--- @param buffer_size number
--- @param threshold number
--- @return number
function PCM:source_time_to_peak(buffer_size, threshold)
	return r.GU_PCM_Source_TimeToPeak(self.pointer, buffer_size, threshold)
end

--- Source Time To Peak R. Wraps GU_PCM_Source_TimeToPeakR.
-- Returns duration in seconds for PCM_source from end til peak threshold is
-- breached in reverse. Returns -1 if invalid
--- @param buffer_size number
--- @param threshold number
--- @return number
function PCM:source_time_to_peak_r(buffer_size, threshold)
	return r.GU_PCM_Source_TimeToPeakR(self.pointer, buffer_size, threshold)
end

--- Source Time To Rms. Wraps GU_PCM_Source_TimeToRMS.
-- Returns duration in seconds for PCM_source from start til RMS threshold is
-- breached. Returns -1 if invalid
--- @param buffer_size number
--- @param threshold number
--- @return number
function PCM:source_time_to_rms(buffer_size, threshold)
	return r.GU_PCM_Source_TimeToRMS(self.pointer, buffer_size, threshold)
end

--- Source Time To Rmsr. Wraps GU_PCM_Source_TimeToRMSR.
-- Returns duration in seconds for PCM_source from end til RMS threshold is
-- breached in reverse. Returns -1 if invalid
--- @param buffer_size number
--- @param threshold number
--- @return number
function PCM:source_time_to_rmsr(buffer_size, threshold)
	return r.GU_PCM_Source_TimeToRMSR(self.pointer, buffer_size, threshold)
end

--- Get Media Source Samples. Wraps Xen_GetMediaSourceSamples.
-- Get interleaved audio data from media source
--- @param destbuf userdata
--- @param destbufoffset number
--- @param numframes number
--- @param numchans number
--- @param samplerate number
--- @param sourceposition number
--- @return number
function PCM:get_media_source_samples(destbuf, destbufoffset, numframes, numchans, samplerate, sourceposition)
	return r.Xen_GetMediaSourceSamples(
		self.pointer,
		destbuf,
		destbufoffset,
		numframes,
		numchans,
		samplerate,
		sourceposition
	)
end

--- Start Source Preview. Wraps Xen_StartSourcePreview.
-- Start audio preview of a PCM_source. Returns id of a preview handle that can be
-- provided to Xen_StopSourcePreview. If the given PCM_source does not belong to an
-- existing MediaItem/Take, it will be deleted by the preview system when the
-- preview is stopped.
--- @param gain number
--- @param loop boolean
--- @param output_chain_idx number Optional
--- @return number
function PCM:start_source_preview(gain, loop, output_chain_idx)
	local output_chain_idx = output_chain_idx or 0
	return r.Xen_StartSourcePreview(self.pointer, gain, loop, output_chain_idx)
end

return PCM
