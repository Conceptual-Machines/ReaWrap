-- @description GU: Provide implementation for GU functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_item_take = require('media_item_take')


local GU = {}



--- Create new GU instance.
-- @return GU table.
function GU:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the GU logger.
-- @param ... (varargs) Messages to log.
function GU:log(...)
    local logger = helpers.log_func('GU')
    logger(...)
    return nil
end

    
--- Config Read.
-- Reads from a config file in the GUtilities folder in Reaper's resource folder
-- @param file_name string
-- @param category string
-- @param key string
-- @return value string
function GU:config_read(file_name, category, key)
    local retval, value = r.GU_Config_Read(file_name, category, key)
    if retval then
        return value
    else
        return nil
    end
end

    
--- Config Write.
-- Writes a config file to the GUtilities folder in Reaper's resource folder
-- @param file_name string
-- @param category string
-- @param key string
-- @param value string
-- @return boolean
function GU:config_write(file_name, category, key, value)
    return r.GU_Config_Write(file_name, category, key, value)
end

    
--- Filesystem Count Media Files.
-- Returns count and filesize in megabytes for all valid media files within the
-- path. Returns -1 if path is invalid. Flags can be passed as an argument to
-- determine which media files are valid. A flag with a value of -1 will reset the
-- cache, otherwise, the following flags can be used: ALL = 0, WAV = 1, AIFF = 2,
-- FLAC = 4, MP3 = 8, OGG = 16, BWF = 32, W64 = 64, WAVPACK = 128, GIF = 256, MP4 =
-- 512
-- @param path string
-- @param flags integer
-- @return file_size number
function GU:filesystem_count_media_files(path, flags)
    local retval, file_size = r.GU_Filesystem_CountMediaFiles(path, flags)
    if retval then
        return file_size
    else
        return nil
    end
end

    
--- Filesystem Enumerate Media Files.
-- Returns the next valid file in a directory each time this function is called
-- with the same path. Returns an empty string if path does not contain any more
-- valid files. Flags can be passed as an argument to determine which media files
-- are valid. A flag with a value of -1 will reset the cache, otherwise, the
-- following flags can be used: ALL = 0, WAV = 1, AIFF = 2, FLAC = 4, MP3 = 8, OGG
-- = 16, BWF = 32, W64 = 64, WAVPACK = 128, GIF = 256, MP4 = 512
-- @param path string
-- @param flags integer
-- @return path string
function GU:filesystem_enumerate_media_files(path, flags)
    return r.GU_Filesystem_EnumerateMediaFiles(path, flags)
end

    
--- Filesystem Find File In Path.
-- Returns the first found file's path from within a given path. Returns an empty
-- string if not found
-- @param path string
-- @param file_name string
-- @return path string
function GU:filesystem_find_file_in_path(path, file_name)
    return r.GU_Filesystem_FindFileInPath(path, file_name)
end

    
--- Filesystem Path Exists.
-- Checks if file or directory exists
-- @param path string
-- @return boolean
function GU:filesystem_path_exists(path)
    return r.GU_Filesystem_PathExists(path)
end

    
--- Tilities Api Get Version.
-- Gets the current GUtilitiesAPI version
-- @return version string
function GU:tilities_api_get_version()
    return r.GU_GUtilitiesAPI_GetVersion()
end

    
--- Wildcard Parse Take.
-- Returns a string by parsing wildcards relative to the supplied MediaItem_Take
-- @param input string
-- @return value string
function GU:wildcard_parse_take(input)
    return r.GU_WildcardParseTake(self.pointer, input)
end

return GU
