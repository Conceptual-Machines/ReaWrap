-- Enumerate the source's media cues. Returns the next index or 0 when finished.
-- @index integer
-- @return number, number, boolean, string 
function PCMSource:c_f__enum_media_source_cues(index)
    local retval, time, end_time, is_region, name = r.CF_EnumMediaSourceCues(self.pointer, index)
    if retval then
        return time, end_time, is_region, name
    end
end

-- Export the source to the given file (MIDI only).
-- @fn string
-- @return boolean 
function PCMSource:c_f__export_media_source(fn)
    return r.CF_ExportMediaSource(self.pointer, fn)
end

-- Returns the bit depth if available (0 otherwise).
-- @return integer 
function PCMSource:c_f__get_media_source_bit_depth()
    return r.CF_GetMediaSourceBitDepth(self.pointer)
end

-- Get the value of the given metadata field (eg. DESC, ORIG, ORIGREF, DATE, TIME, UMI, CODINGHISTORY for BWF).
-- @name string
-- @out string
-- @return string 
function PCMSource:c_f__get_media_source_metadata(name, out)
    local retval, out_ = r.CF_GetMediaSourceMetadata(self.pointer, name, out)
    if retval then
        return out_
    end
end

-- Returns the online/offline status of the given source.
-- @return boolean 
function PCMSource:c_f__get_media_source_online()
    return r.CF_GetMediaSourceOnline(self.pointer)
end

-- Get the project associated with this source (BWF, subproject...).
-- @return string 
function PCMSource:c_f__get_media_source_r_p_p()
    local retval, fn = r.CF_GetMediaSourceRPP(self.pointer)
    if retval then
        return fn
    end
end

-- Set the online/offline status of the given source (closes files when set=false).
-- @set boolean
function PCMSource:c_f__set_media_source_online(set)
    return r.CF_SetMediaSourceOnline(self.pointer, set)
end

-- Get text-based metadata from a media file for a given identifier. Call with identifier="" to list all identifiers contained in the file, separated by newlines. May return "[Binary data]" for metadata that REAPER doesn't handle.
-- @identifier string
-- @return string 
function PCMSource:get_media_file_metadata(identifier)
    local retval, buf = r.GetMediaFileMetadata(self.pointer, identifier)
    if retval then
        return buf
    end
end

-- Copies the media source filename to typebuf. Note that in-project MIDI media sources have no associated filename. See GetMediaSourceParent.
-- @filenamebuf string
-- @return string 
function PCMSource:get_media_source_file_name(filenamebuf)
    return r.GetMediaSourceFileName(self.pointer, filenamebuf)
end

-- Returns the length of the source media. If the media source is beat-based, the length will be in quarter notes, otherwise it will be in seconds.
-- @return boolean 
function PCMSource:get_media_source_length()
    local retval, length_is_q_n = r.GetMediaSourceLength(self.pointer)
    if retval then
        return length_is_q_n
    end
end

-- Returns the number of channels in the source media.
-- @return integer 
function PCMSource:get_media_source_num_channels()
    return r.GetMediaSourceNumChannels(self.pointer)
end

-- Returns the parent source, or NULL if src is the root source. This can be used to retrieve the parent properties of sections or reversed sources for example.
-- @return PCM_source 
function PCMSource:get_media_source_parent()
    return r.GetMediaSourceParent(self.pointer)
end

-- Returns the sample rate. MIDI source media will return zero.
-- @return integer 
function PCMSource:get_media_source_sample_rate()
    return r.GetMediaSourceSampleRate(self.pointer)
end

-- copies the media source type ("WAV", "MIDI", etc) to typebuf
-- @typebuf string
-- @return string 
function PCMSource:get_media_source_type(typebuf)
    return r.GetMediaSourceType(self.pointer, typebuf)
end

-- @return ReaProject 
function PCMSource:get_sub_project_from_source()
    return r.GetSubProjectFromSource(self.pointer)
end

-- finds the playrate and target length to insert this item stretched to a round power-of-2 number of bars, between 1/8 and 256
-- @srcscale number
-- @position number
-- @mult number
-- @return number, number 
function PCMSource:get_tempo_match_play_rate(srcscale, position, mult)
    local retval, rate, targetlen = r.GetTempoMatchPlayRate(self.pointer, srcscale, position, mult)
    if retval then
        return rate, targetlen
    end
end

-- Deletes a PCM_source -- be sure that you remove any project reference before deleting a source
function PCMSource:p_c_m__source__destroy()
    return r.PCM_Source_Destroy(self.pointer)
end

-- Gets block of peak samples to buf. Note that the peak samples are interleaved, but in two or three blocks (maximums, then minimums, then extra). Return value has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000), then a bit to signify whether extra_type was available (0x1000000). extra_type can be 115 ('s') for spectral information, which will return peak samples as integers with the low 15 bits frequency, next 14 bits tonality.
-- @peakrate number
-- @starttime number
-- @numchannels integer
-- @numsamplesperchannel integer
-- @want_extra_type integer
-- @buf reaper.array
-- @return integer 
function PCMSource:p_c_m__source__get_peaks(peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
    return r.PCM_Source_GetPeaks(self.pointer, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
end

-- If a section/reverse block, retrieves offset/len/reverse. return true if success
-- @return number, number, boolean 
function PCMSource:p_c_m__source__get_section_info()
    local retval, offs, len, rev = r.PCM_Source_GetSectionInfo(self.pointer)
    if retval then
        return offs, len, rev
    end
end

-- Get the value of metadata from media source(.wav only). metaType=BWF,IXML,INFO,CART, key=MetadataID(eg.INAM,IART,... of INFO)
-- @meta_type string
-- @key string
-- @buf string
-- @buf_size integer
-- @return string 
function PCMSource:r_d_n_a__get_media_source_metadata(meta_type, key, buf, buf_size)
    local retval, buf_ = r.RDNA_GetMediaSourceMetadata(self.pointer, meta_type, key, buf, buf_size)
    if retval then
        return buf_
    end
end

-- Get interleaved audio data from media source
-- @destbuf identifier
-- @destbufoffset integer
-- @numframes integer
-- @numchans integer
-- @samplerate number
-- @sourceposition number
-- @return integer 
function PCMSource:xen__get_media_source_samples(destbuf, destbufoffset, numframes, numchans, samplerate, sourceposition)
    return r.Xen_GetMediaSourceSamples(self.pointer, destbuf, destbufoffset, numframes, numchans, samplerate, sourceposition)
end

-- If the given PCM_source does not belong to an existing MediaItem/Take, it will be deleted by the preview system when the preview is stopped.
-- @gain number
-- @loop boolean
-- @outputchanindex_in number
-- @return integer 
function PCMSource:xen__start_source_preview(gain, loop, outputchanindex_in)
    return r.Xen_StartSourcePreview(self.pointer, gain, loop, outputchanindex_in)
end

