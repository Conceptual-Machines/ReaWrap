-- @description Provide implementation for PCM functions.
-- @author NomadMonad
-- @license MIT

local r = reaper
local helpers = require('helpers')


local PCM = {}



--- Create new PCM instance.
-- @param source . The pointer to PCM_source*
-- @return PCM table.
function PCM:new(source)
    local obj = {
        pointer_type = "PCM_source*",
        pointer = source
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- @section ReaWrap Custom Methods

--- Log messages with the PCM logger.
-- @param ... (varargs) Messages to log.
function PCM:log(...)
    local logger = helpers.log_func('PCM')
    logger(...)
    return nil
end


-- @section ReaScript API Methods



    
--- Calc Media Src Loudness.
-- Calculates loudness statistics of media via dry run render. Statistics will be
-- displayed to the user; call GetSetProjectInfo_String("RENDER_STATS") to retrieve
-- via API. Returns 1 if loudness was calculated successfully, -1 if user canceled
-- the dry run render.
-- @return number
function PCM:calc_media_src_loudness()
    return r.CalcMediaSrcLoudness(self.mediasource.pointer)
end

    
--- Calculate Normalization.
-- Calculate normalize adjustment for source media. normalizeTo: 0=LUFS-I, 1=RMS-I,
-- 2=peak, 3=true peak, 4=LUFS-M max, 5=LUFS-S max. normalizeTarget: dBFS or LUFS
-- value. normalizeStart, normalizeEnd: time bounds within source media for
-- normalization calculation. If normalizationStart=0 and normalizationEnd=0, the
-- full duration of the media will be used for the calculation.
-- @param normalize_to number
-- @param normalize_target number
-- @param normalize_start number
-- @param normalize_end number
-- @return number
function PCM:calculate_normalization(normalize_to, normalize_target, normalize_start, normalize_end)
    return r.CalculateNormalization(self.source.pointer, normalize_to, normalize_target, normalize_start, normalize_end)
end

    
--- Get Media File Metadata.
-- Get text-based metadata from a media file for a given identifier. Call with
-- identifier="" to list all identifiers contained in the file, separated by
-- newlines. May return "[Binary data]" for metadata that REAPER doesn't handle.
-- @param identifier string
-- @return buf string
function PCM:get_media_file_metadata(identifier)
    local ret_val, buf = r.GetMediaFileMetadata(self.media_source.pointer, identifier)
    if ret_val then
        return buf
    else
        return nil
    end
end

    
--- Get Media Source File Name.
-- Copies the media source filename to filenamebuf. Note that in-project MIDI media
-- sources have no associated filename. See GetMediaSourceParent.
-- @return filenamebuf string
function PCM:get_media_source_file_name()
    return r.GetMediaSourceFileName(self.source.pointer)
end

    
--- Get Media Source Length.
-- Returns the length of the source media. If the media source is beat-based, the
-- length will be in quarter notes, otherwise it will be in seconds.
-- @return length_is_qn boolean
function PCM:get_media_source_length()
    local ret_val, length_is_qn = r.GetMediaSourceLength(self.source.pointer)
    if ret_val then
        return length_is_qn
    else
        return nil
    end
end

    
--- Get Media Source Num Channels.
-- Returns the number of channels in the source media.
-- @return number
function PCM:get_media_source_num_channels()
    return r.GetMediaSourceNumChannels(self.source.pointer)
end

    
--- Get Media Source Parent.
-- Returns the parent source, or NULL if src is the root source. This can be used
-- to retrieve the parent properties of sections or reversed sources for example.
-- @return userdata
function PCM:get_media_source_parent()
    local PCM_source = require('pcm_source')
    local result = r.GetMediaSourceParent(self.src.pointer)
    return PCM_source:new(result)
end

    
--- Get Media Source Sample Rate.
-- Returns the sample rate. MIDI source media will return zero.
-- @return number
function PCM:get_media_source_sample_rate()
    return r.GetMediaSourceSampleRate(self.source.pointer)
end

    
--- Get Media Source Type.
-- copies the media source type ("WAV", "MIDI", etc) to typebuf
-- @return typebuf string
function PCM:get_media_source_type()
    return r.GetMediaSourceType(self.source.pointer)
end

    
--- Get Sub Project From Source.
-- @return Project table
function PCM:get_sub_project_from_source()
    local Project = require('project')
    local result = r.GetSubProjectFromSource(self.src.pointer)
    return Project:new(result)
end

    
--- Get Tempo Match Play Rate.
-- finds the playrate and target length to insert this item stretched to a round
-- power-of-2 number of bars, between 1/8 and 256
-- @param srcscale number
-- @param position number
-- @param mult number
-- @return rate number
-- @return targetlen number
function PCM:get_tempo_match_play_rate(srcscale, position, mult)
    local ret_val, rate, targetlen = r.GetTempoMatchPlayRate(self.source.pointer, srcscale, position, mult)
    if ret_val then
        return rate, targetlen
    else
        return nil
    end
end

    
--- Sink Enum.
-- @param idx number
-- @return descstr string
function PCM:sink_enum(idx)
    local ret_val, descstr = r.PCM_Sink_Enum(idx)
    if ret_val then
        return descstr
    else
        return nil
    end
end

    
--- Sink Get Extension.
-- @param data string
-- @return string
function PCM:sink_get_extension(data)
    return r.PCM_Sink_GetExtension(data)
end

    
--- Sink Show Config.
-- @param cfg string
-- @param hwnd_parent HWND
-- @return HWND
function PCM:sink_show_config(cfg, hwnd_parent)
    return r.PCM_Sink_ShowConfig(cfg, hwnd_parent)
end

    
--- Source Build Peaks.
-- Calls and returns PCM_source::PeaksBuild_Begin() if mode=0, PeaksBuild_Run() if
-- mode=1, and PeaksBuild_Finish() if mode=2. Normal use is to call
-- PCM_Source_BuildPeaks(src,0), and if that returns nonzero, call
-- PCM_Source_BuildPeaks(src,1) periodically until it returns zero (it returns the
-- percentage of the file remaining), then call PCM_Source_BuildPeaks(src,2) to
-- finalize. If PCM_Source_BuildPeaks(src,0) returns zero, then no further action
-- is necessary.
-- @param mode number
-- @return number
function PCM:source_build_peaks(mode)
    return r.PCM_Source_BuildPeaks(self.src.pointer, mode)
end

    
--- Source Create From File.
-- See PCM_Source_CreateFromFileEx.
-- @param file_name string
-- @return userdata
function PCM:source_create_from_file(file_name)
    local PCM_source = require('pcm_source')
    local result = r.PCM_Source_CreateFromFile(file_name)
    return PCM_source:new(result)
end

    
--- Source Create From File Ex.
-- Create a PCM_source from filename, and override pref of MIDI files being
-- imported as in-project MIDI events.
-- @param file_name string
-- @param forceno_midi_imp boolean
-- @return userdata
function PCM:source_create_from_file_ex(file_name, forceno_midi_imp)
    local PCM_source = require('pcm_source')
    local result = r.PCM_Source_CreateFromFileEx(file_name, forceno_midi_imp)
    return PCM_source:new(result)
end

    
--- Source Create From Type.
-- Create a PCM_source from a "type" (use this if you're going to load its state
-- via LoadState/ProjectStateContext). Valid types include "WAVE", "MIDI", or
-- whatever plug-ins define as well.
-- @param source_type string
-- @return userdata
function PCM:source_create_from_type(source_type)
    local PCM_source = require('pcm_source')
    local result = r.PCM_Source_CreateFromType(source_type)
    return PCM_source:new(result)
end

    
--- Source Destroy.
-- Deletes a PCM_source -- be sure that you remove any project reference before
-- deleting a source
function PCM:source_destroy()
    return r.PCM_Source_Destroy(self.src.pointer)
end

    
--- Source Get Peaks.
-- Gets block of peak samples to buf. Note that the peak samples are interleaved,
-- but in two or three blocks (maximums, then minimums, then extra). Return value
-- has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000),
-- then a bit to signify whether extra_type was available (0x1000000). extra_type
-- can be 115 ('s') for spectral information, which will return peak samples as
-- integers with the low 15 bits frequency, next 14 bits tonality.
-- @param peakrate number
-- @param starttime number
-- @param numchannels number
-- @param numsamplesperchannel number
-- @param want_extra_type number
-- @param buf reaper.array
-- @return number
function PCM:source_get_peaks(peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
    return r.PCM_Source_GetPeaks(self.src.pointer, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
end

    
--- Source Get Section Info.
-- If a section/reverse block, retrieves offset/len/reverse. return true if success
-- @return offs number
-- @return len number
-- @return rev boolean
function PCM:source_get_section_info()
    local ret_val, offs, len, rev = r.PCM_Source_GetSectionInfo(self.src.pointer)
    if ret_val then
        return offs, len, rev
    else
        return nil
    end
end

    
--- Create Preview.
-- Create a new preview object. Does not take ownership of the source (don't forget
-- to destroy it unless it came from a take!). See CF_Preview_Play and the others
-- CF_Preview_* functions.
-- @return CF_Preview
function PCM:create_preview()
    return r.CF_CreatePreview(self.source.pointer)
end

    
--- Enum Media Source Cues.
-- Enumerate the source's media cues. Returns the next index or 0 when finished.
-- @param index number
-- @return time number
-- @return end_time number
-- @return is_region boolean
-- @return name string
-- @return is_chapter boolean
function PCM:enum_media_source_cues(index)
    local ret_val, time, end_time, is_region, name, is_chapter = r.CF_EnumMediaSourceCues(self.src.pointer, index)
    if ret_val then
        return time, end_time, is_region, name, is_chapter
    else
        return nil
    end
end

    
--- Export Media Source.
-- Export the source to the given file (MIDI only).
-- @param fn string
-- @return boolean
function PCM:export_media_source(fn)
    return r.CF_ExportMediaSource(self.src.pointer, fn)
end

    
--- Get Media Source Bit Depth.
-- Returns the bit depth if available (0 otherwise).
-- @return number
function PCM:get_media_source_bit_depth()
    return r.CF_GetMediaSourceBitDepth(self.src.pointer)
end

    
--- Get Media Source Bit Rate.
-- Returns the bit rate for WAVE (wav, aif) and streaming/variable formats (mp3,
-- ogg, opus). REAPER v6.19 or later is required for non-WAVE formats.
-- @return number
function PCM:get_media_source_bit_rate()
    return r.CF_GetMediaSourceBitRate(self.src.pointer)
end

    
--- Get Media Source Metadata.
-- Get the value of the given metadata field (eg. DESC, ORIG, ORIGREF, DATE, TIME,
-- UMI, CODINGHISTORY for BWF).
-- @param name string
-- @param out string
-- @return out string
function PCM:get_media_source_metadata(name, out)
    local ret_val, out = r.CF_GetMediaSourceMetadata(self.src.pointer, name, out)
    if ret_val then
        return out
    else
        return nil
    end
end

    
--- Get Media Source Online.
-- Returns the online/offline status of the given source.
-- @return boolean
function PCM:get_media_source_online()
    return r.CF_GetMediaSourceOnline(self.src.pointer)
end

    
--- Get Media Source Rpp.
-- Get the project associated with this source (BWF, subproject...).
-- @return fn string
function PCM:get_media_source_rpp()
    local ret_val, fn = r.CF_GetMediaSourceRPP(self.src.pointer)
    if ret_val then
        return fn
    else
        return nil
    end
end

    
--- Source Set Section Info.
-- Give a section source created using PCM_Source_CreateFromType("SECTION"). Offset
-- and length are ignored if 0. Negative length to subtract from the total length
-- of the source.
-- @param offset number
-- @param length number
-- @param reverse boolean
-- @param number fadeIn Optional
-- @return boolean
function PCM:source_set_section_info(offset, length, reverse, number)
    local number = number or nil
    return r.CF_PCM_Source_SetSectionInfo(self.section.pointer, source, offset, length, reverse, number)
end

    
--- Set Media Source Online.
-- Set the online/offline status of the given source (closes files when set=false).
-- @param set boolean
function PCM:set_media_source_online(set)
    return r.CF_SetMediaSourceOnline(self.src.pointer, set)
end

    
--- Source Get Sample Value.
-- Gets a PCM_source's sample value at a point in time (seconds)
-- @param time number
-- @return number
function PCM:source_get_sample_value(time)
    return r.GU_PCM_Source_GetSampleValue(self.source.pointer, time)
end

    
--- Source Has Region.
-- Checks if PCM_source has embedded Media Cue Markers
-- @return boolean
function PCM:source_has_region()
    return r.GU_PCM_Source_HasRegion(self.source.pointer)
end

    
--- Source Is Mono.
-- Checks if PCM_source is mono by comparing all channels
-- @return boolean
function PCM:source_is_mono()
    return r.GU_PCM_Source_IsMono(self.source.pointer)
end

    
--- Source Time To Peak.
-- Returns duration in seconds for PCM_source from start til peak threshold is
-- breached. Returns -1 if invalid
-- @param buffer_size number
-- @param threshold number
-- @return number
function PCM:source_time_to_peak(buffer_size, threshold)
    return r.GU_PCM_Source_TimeToPeak(self.source.pointer, buffer_size, threshold)
end

    
--- Source Time To Peak R.
-- Returns duration in seconds for PCM_source from end til peak threshold is
-- breached in reverse. Returns -1 if invalid
-- @param buffer_size number
-- @param threshold number
-- @return number
function PCM:source_time_to_peak_r(buffer_size, threshold)
    return r.GU_PCM_Source_TimeToPeakR(self.source.pointer, buffer_size, threshold)
end

    
--- Source Time To Rms.
-- Returns duration in seconds for PCM_source from start til RMS threshold is
-- breached. Returns -1 if invalid
-- @param buffer_size number
-- @param threshold number
-- @return number
function PCM:source_time_to_rms(buffer_size, threshold)
    return r.GU_PCM_Source_TimeToRMS(self.source.pointer, buffer_size, threshold)
end

    
--- Source Time To Rmsr.
-- Returns duration in seconds for PCM_source from end til RMS threshold is
-- breached in reverse. Returns -1 if invalid
-- @param buffer_size number
-- @param threshold number
-- @return number
function PCM:source_time_to_rmsr(buffer_size, threshold)
    return r.GU_PCM_Source_TimeToRMSR(self.source.pointer, buffer_size, threshold)
end

    
--- Get Media Source Samples.
-- Get interleaved audio data from media source
-- @param destbuf identifier
-- @param destbufoffset number
-- @param numframes number
-- @param numchans number
-- @param samplerate number
-- @param sourceposition number
-- @return number
function PCM:get_media_source_samples(destbuf, destbufoffset, numframes, numchans, samplerate, sourceposition)
    return r.Xen_GetMediaSourceSamples(self.src.pointer, destbuf, destbufoffset, numframes, numchans, samplerate, sourceposition)
end

    
--- Start Source Preview.
-- Start audio preview of a PCM_source. Returns id of a preview handle that can be
-- provided to Xen_StopSourcePreview. If the given PCM_source does not belong to an
-- existing MediaItem/Take, it will be deleted by the preview system when the
-- preview is stopped.
-- @param gain number
-- @param loop boolean
-- @param integer outputchanindexIn Optional
-- @return number
function PCM:start_source_preview(gain, loop, integer)
    local integer = integer or nil
    return r.Xen_StartSourcePreview(self.source.pointer, gain, loop, integer)
end

return PCM
