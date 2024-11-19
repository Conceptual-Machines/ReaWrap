-- Creates writer for 32 bit floating point WAV
-- @filename string
-- @numchans integer
-- @samplerate integer
-- @return AudioWriter 
function Xen:audio_writer__create(filename, numchans, samplerate)
    return r.Xen_AudioWriter_Create(filename, numchans, samplerate)
end

-- Destroys writer
-- @writer AudioWriter
function Xen:audio_writer__destroy(writer)
    return r.Xen_AudioWriter_Destroy(writer)
end

-- Write interleaved audio data to disk
-- @writer AudioWriter
-- @numframes integer
-- @data identifier
-- @offset integer
-- @return integer 
function Xen:audio_writer__write(writer, numframes, data, offset)
    return r.Xen_AudioWriter_Write(writer, numframes, data, offset)
end

-- Stop audio preview. id -1 stops all.
-- @preview_id integer
-- @return integer 
function Xen:stop_source_preview(preview_id)
    return r.Xen_StopSourcePreview(preview_id)
end

