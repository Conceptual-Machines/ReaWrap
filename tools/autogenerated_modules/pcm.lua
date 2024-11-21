-- @description PCM: Provide implementation for PCM functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local hwnd = require('hwnd')
local pcm_source = require('pcm_source')


local PCM = {}



--- Create new PCM instance.
-- @return PCM table.
function PCM:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the PCM logger.
-- @param ... (varargs) Messages to log.
function PCM:log(...)
    local logger = helpers.log_func('PCM')
    logger(...)
    return nil
end

    
--- Calc Media Src Loudness.
-- Calculates loudness statistics of media via dry run render. Statistics will be
-- displayed to the user; call GetSetProjectInfo_String("RENDER_STATS") to retrieve
-- via API. Returns 1 if loudness was calculated successfully, -1 if user canceled
-- the dry run render.
-- @return integer
function PCM:calc_media_src_loudness()
    return r.CalcMediaSrcLoudness(self.pointer)
end

    
--- Calculate Normalization.
-- Calculate normalize adjustment for source media. normalizeTo: 0=LUFS-I, 1=RMS-I,
-- 2=peak, 3=true peak, 4=LUFS-M max, 5=LUFS-S max. normalizeTarget: dBFS or LUFS
-- value. normalizeStart, normalizeEnd: time bounds within source media for
-- normalization calculation. If normalizationStart=0 and normalizationEnd=0, the
-- full duration of the media will be used for the calculation.
-- @param normalize_to integer
-- @param normalize_target number
-- @param normalize_start number
-- @param normalize_end number
-- @return number
function PCM:calculate_normalization(normalize_to, normalize_target, normalize_start, normalize_end)
    return r.CalculateNormalization(self.pointer, normalize_to, normalize_target, normalize_start, normalize_end)
end

    
--- Get Media File Metadata.
-- Get text-based metadata from a media file for a given identifier. Call with
-- identifier="" to list all identifiers contained in the file, separated by
-- newlines. May return "[Binary data]" for metadata that REAPER doesn't handle.
-- @param identifier string
-- @return buf string
function PCM:get_media_file_metadata(identifier)
    local retval, buf = r.GetMediaFileMetadata(self.pointer, identifier)
    if retval then
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
    return r.GetMediaSourceFileName(self.pointer)
end

    
--- Get Media Source Length.
-- Returns the length of the source media. If the media source is beat-based, the
-- length will be in quarter notes, otherwise it will be in seconds.
-- @return length_is_qn boolean
function PCM:get_media_source_length()
    local retval, length_is_qn = r.GetMediaSourceLength(self.pointer)
    if retval then
        return length_is_qn
    else
        return nil
    end
end

    
--- Get Media Source Num Channels.
-- Returns the number of channels in the source media.
-- @return integer
function PCM:get_media_source_num_channels()
    return r.GetMediaSourceNumChannels(self.pointer)
end

    
--- Get Media Source Parent.
-- Returns the parent source, or NULL if src is the root source. This can be used
-- to retrieve the parent properties of sections or reversed sources for example.
-- @return PCM_source table
function PCM:get_media_source_parent()
    local result = r.GetMediaSourceParent(self.pointer)
    return pcm_source.PCM_source:new(result)
end

    
--- Get Media Source Sample Rate.
-- Returns the sample rate. MIDI source media will return zero.
-- @return integer
function PCM:get_media_source_sample_rate()
    return r.GetMediaSourceSampleRate(self.pointer)
end

    
--- Get Media Source Type.
-- copies the media source type ("WAV", "MIDI", etc) to typebuf
-- @return typebuf string
function PCM:get_media_source_type()
    return r.GetMediaSourceType(self.pointer)
end

    
--- Get Sub Project From Source.
-- @return ReaProject table
function PCM:get_sub_project_from_source()
    local result = r.GetSubProjectFromSource(self.pointer)
    return rea_project.ReaProject:new(result)
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
    local retval, rate, targetlen = r.GetTempoMatchPlayRate(self.pointer, srcscale, position, mult)
    if retval then
        return rate, targetlen
    else
        return nil
    end
end

    
--- Sink Enum.
-- @param _idx integer
-- @return descstr string
function PCM:sink_enum(_idx)
    local retval, descstr = r.PCM_Sink_Enum(_idx)
    if retval then
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
-- @return HWND table
function PCM:sink_show_config(cfg)
    local result = r.PCM_Sink_ShowConfig(cfg, hwnd_parent)
    return hwnd.HWND:new(result)
end

    
--- Source Build Peaks.
-- Calls and returns PCM_source::PeaksBuild_Begin() if mode=0, PeaksBuild_Run() if
-- mode=1, and PeaksBuild_Finish() if mode=2. Normal use is to call
-- PCM_Source_BuildPeaks(src,0), and if that returns nonzero, call
-- PCM_Source_BuildPeaks(src,1) periodically until it returns zero (it returns the
-- percentage of the file remaining), then call PCM_Source_BuildPeaks(src,2) to
-- finalize. If PCM_Source_BuildPeaks(src,0) returns zero, then no further action
-- is necessary.
-- @param mode integer
-- @return integer
function PCM:source_build_peaks(mode)
    return r.PCM_Source_BuildPeaks(self.pointer, mode)
end

    
--- Source Create From File.
-- See PCM_Source_CreateFromFileEx.
-- @param filename string
-- @return PCM_source table
function PCM:source_create_from_file(filename)
    local result = r.PCM_Source_CreateFromFile(filename)
    return pcm_source.PCM_source:new(result)
end

    
--- Source Create From File Ex.
-- Create a PCM_source from filename, and override pref of MIDI files being
-- imported as in-project MIDI events.
-- @param filename string
-- @param forceno_midi_imp boolean
-- @return PCM_source table
function PCM:source_create_from_file_ex(filename, forceno_midi_imp)
    local result = r.PCM_Source_CreateFromFileEx(filename, forceno_midi_imp)
    return pcm_source.PCM_source:new(result)
end

    
--- Source Create From Type.
-- Create a PCM_source from a "type" (use this if you're going to load its state
-- via LoadState/ProjectStateContext). Valid types include "WAVE", "MIDI", or
-- whatever plug-ins define as well.
-- @param sourcetype string
-- @return PCM_source table
function PCM:source_create_from_type(sourcetype)
    local result = r.PCM_Source_CreateFromType(sourcetype)
    return pcm_source.PCM_source:new(result)
end

    
--- Source Destroy.
-- Deletes a PCM_source -- be sure that you remove any project reference before
-- deleting a source
function PCM:source_destroy()
    return r.PCM_Source_Destroy(self.pointer)
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
-- @param numchannels integer
-- @param numsamplesperchannel integer
-- @param want_extra_type integer
-- @param buf reaper.array
-- @return integer
function PCM:source_get_peaks(peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
    return r.PCM_Source_GetPeaks(self.pointer, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
end

    
--- Source Get Section Info.
-- If a section/reverse block, retrieves offset/len/reverse. return true if success
-- @return offs number
-- @return len number
-- @return rev boolean
function PCM:source_get_section_info()
    local retval, offs, len, rev = r.PCM_Source_GetSectionInfo(self.pointer)
    if retval then
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
    return r.CF_CreatePreview(self.pointer)
end

    
--- Enum Media Source Cues.
-- Enumerate the source's media cues. Returns the next index or 0 when finished.
-- @param index integer
-- @return time number
-- @return end_time number
-- @return is__region boolean
-- @return name string
-- @return is__chapter boolean
function PCM:enum_media_source_cues(index)
    local retval, time, end_time, is__region, name, is__chapter = r.CF_EnumMediaSourceCues(self.pointer, index)
    if retval then
        return time, end_time, is__region, name, is__chapter
    else
        return nil
    end
end

    
--- Export Media Source.
-- Export the source to the given file (MIDI only).
-- @param fn string
-- @return boolean
function PCM:export_media_source(fn)
    return r.CF_ExportMediaSource(self.pointer, fn)
end

    
--- Get Media Source Bit Depth.
-- Returns the bit depth if available (0 otherwise).
-- @return integer
function PCM:get_media_source_bit_depth()
    return r.CF_GetMediaSourceBitDepth(self.pointer)
end

    
--- Get Media Source Bit Rate.
-- Returns the bit rate for WAVE (wav, aif) and streaming/variable formats (mp3,
-- ogg, opus). REAPER v6.19 or later is required for non-WAVE formats.
-- @return number
function PCM:get_media_source_bit_rate()
    return r.CF_GetMediaSourceBitRate(self.pointer)
end

    
--- Get Media Source Metadata.
-- Get the value of the given metadata field (eg. DESC, ORIG, ORIGREF, DATE, TIME,
-- UMI, CODINGHISTORY for BWF).
-- @param name string
-- @param out string
-- @return out string
function PCM:get_media_source_metadata(name, out)
    local retval, out = r.CF_GetMediaSourceMetadata(self.pointer, name, out)
    if retval then
        return out
    else
        return nil
    end
end

    
--- Get Media Source Online.
-- Returns the online/offline status of the given source.
-- @return boolean
function PCM:get_media_source_online()
    return r.CF_GetMediaSourceOnline(self.pointer)
end

    
--- Get Media Source Rpp.
-- Get the project associated with this source (BWF, subproject...).
-- @return fn string
function PCM:get_media_source_rpp()
    local retval, fn = r.CF_GetMediaSourceRPP(self.pointer)
    if retval then
        return fn
    else
        return nil
    end
end

    
--- Cf Source Set Section Info.
-- Give a section source created using PCM_Source_CreateFromType("SECTION"). Offset
-- and length are ignored if 0. Negative length to subtract from the total length
-- of the source.
-- @param offset number
-- @param length number
-- @param reverse boolean
-- @param number fadeIn optional
-- @return boolean
function PCM:cf_source_set_section_info(offset, length, reverse, number)
    local number = number or nil
    return r.CF_PCM_Source_SetSectionInfo(self.pointer, source, offset, length, reverse, number)
end

    
--- Set Media Source Online.
-- Set the online/offline status of the given source (closes files when set=false).
-- @param set boolean
function PCM:set_media_source_online(set)
    return r.CF_SetMediaSourceOnline(self.pointer, set)
end

    
--- Gu Source Get Sample Value.
-- Gets a PCM_source's sample value at a point in time (seconds)
-- @param time number
-- @return number
function PCM:gu_source_get_sample_value(time)
    return r.GU_PCM_Source_GetSampleValue(self.pointer, time)
end

    
--- Gu Source Has Region.
-- Checks if PCM_source has embedded Media Cue Markers
-- @return boolean
function PCM:gu_source_has_region()
    return r.GU_PCM_Source_HasRegion(self.pointer)
end

    
--- Gu Source Is Mono.
-- Checks if PCM_source is mono by comparing all channels
-- @return boolean
function PCM:gu_source_is_mono()
    return r.GU_PCM_Source_IsMono(self.pointer)
end

    
--- Gu Source Time To Peak.
-- Returns duration in seconds for PCM_source from start til peak threshold is
-- breached. Returns -1 if invalid
-- @param buffer_size integer
-- @param threshold number
-- @return number
function PCM:gu_source_time_to_peak(buffer_size, threshold)
    return r.GU_PCM_Source_TimeToPeak(self.pointer, buffer_size, threshold)
end

    
--- Gu Source Time To Peak R.
-- Returns duration in seconds for PCM_source from end til peak threshold is
-- breached in reverse. Returns -1 if invalid
-- @param buffer_size integer
-- @param threshold number
-- @return number
function PCM:gu_source_time_to_peak_r(buffer_size, threshold)
    return r.GU_PCM_Source_TimeToPeakR(self.pointer, buffer_size, threshold)
end

    
--- Gu Source Time To Rms.
-- Returns duration in seconds for PCM_source from start til RMS threshold is
-- breached. Returns -1 if invalid
-- @param buffer_size integer
-- @param threshold number
-- @return number
function PCM:gu_source_time_to_rms(buffer_size, threshold)
    return r.GU_PCM_Source_TimeToRMS(self.pointer, buffer_size, threshold)
end

    
--- Gu Source Time To Rmsr.
-- Returns duration in seconds for PCM_source from end til RMS threshold is
-- breached in reverse. Returns -1 if invalid
-- @param buffer_size integer
-- @param threshold number
-- @return number
function PCM:gu_source_time_to_rmsr(buffer_size, threshold)
    return r.GU_PCM_Source_TimeToRMSR(self.pointer, buffer_size, threshold)
end

    
--- Get Media Source Samples.
-- Get interleaved audio data from media source
-- @param destbuf identifier
-- @param destbufoffset integer
-- @param numframes integer
-- @param numchans integer
-- @param samplerate number
-- @param sourceposition number
-- @return integer
function PCM:get_media_source_samples(destbuf, destbufoffset, numframes, numchans, samplerate, sourceposition)
    return r.Xen_GetMediaSourceSamples(self.pointer, destbuf, destbufoffset, numframes, numchans, samplerate, sourceposition)
end

    
--- Start Source Preview.
-- Start audio preview of a PCM_source. Returns id of a preview handle that can be
-- provided to Xen_StopSourcePreview. If the given PCM_source does not belong to an
-- existing MediaItem/Take, it will be deleted by the preview system when the
-- preview is stopped.
-- @param gain number
-- @param loop boolean
-- @param integer outputchanindexIn optional
-- @return integer
function PCM:start_source_preview(gain, loop, integer)
    local integer = integer or nil
    return r.Xen_StartSourcePreview(self.pointer, gain, loop, integer)
end

return PCM
