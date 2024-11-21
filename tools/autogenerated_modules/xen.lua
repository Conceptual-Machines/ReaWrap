-- @description Xen: Provide implementation for Xen functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local Xen = {}



--- Create new Xen instance.
-- @return Xen table.
function Xen:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the Xen logger.
-- @param ... (varargs) Messages to log.
function Xen:log(...)
    local logger = helpers.log_func('Xen')
    logger(...)
    return nil
end

    
--- Audio Writer Create.
-- Creates writer for 32 bit floating point WAV
-- @param filename string
-- @param numchans integer
-- @param samplerate integer
-- @return AudioWriter
function Xen:audio_writer_create(filename, numchans, samplerate)
    return r.Xen_AudioWriter_Create(filename, numchans, samplerate)
end

    
--- Audio Writer Destroy.
-- Destroys writer
-- @param writer AudioWriter
function Xen:audio_writer_destroy(writer)
    return r.Xen_AudioWriter_Destroy(writer)
end

    
--- Audio Writer Write.
-- Write interleaved audio data to disk
-- @param writer AudioWriter
-- @param numframes integer
-- @param data identifier
-- @param offset integer
-- @return integer
function Xen:audio_writer_write(writer, numframes, data, offset)
    return r.Xen_AudioWriter_Write(writer, numframes, data, offset)
end

    
--- Stop Source Preview.
-- Stop audio preview. id -1 stops all.
-- @param preview_id integer
-- @return integer
function Xen:stop_source_preview(preview_id)
    return r.Xen_StopSourcePreview(preview_id)
end

return Xen
