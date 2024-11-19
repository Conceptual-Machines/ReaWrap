local r = reaper
-- MediaItemTake

MediaItemTake = {}

-- @media_item: MediaItem
-- @pointer: userdata
-- @return MediaItemTake
function MediaItemTake:new(media_item --[[MediaItem]], take --[[userdata]])
    local o = {
        media_item = media_item,
        pointer = take
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function MediaItemTake:__tostring()
    return string.format('<MediaItemTake GUID=%s>', self:GUID())
end

function MediaItemTake:GUID()
    return r.BR_GetMediaItemTakeGUID(self.pointer)
end

-- @param string : constants.MediaItemTakeInfoValue
-- @return number
function MediaItemTake:get_info_value(param)
    if MediaItemTakeInfoValue[param] == nil then
        error(
                [[
                Invalid argument to get_info_value().
                Please use constants.MediaItemTakeInfoValue
        ]]
        )
    end
    return r.GetMediaItemTakeInfo_Value(self.pointer, param)
end

-- @param string : constants.MediaItemTakeInfoString
-- @return string
function MediaItemTake:get_info_string(param)
    if MediaItemTakeInfoString[param] == nil then
        error(
                [[
                Invalid argument to get_info_value().
                Please use constants.MediaItemTakeInfoString
        ]]
        )
    end
    local retval, info = reaper.GetSetMediaItemTakeInfo_String(
            self.pointer, param, '', false
    )
    if retval then
        return info
    end
end

function MediaItemTake:get_name()
    return self:get_info_string(MediaItemTakeInfoString.P_NAME)
end


-- @return PCMSource
function MediaItemTake:get_pcm_source()
    local source = r.GetMediaItemTake_Source(self.pointer)
    return PCMSource:new(self, source)
end

-- @return string
function MediaItemTake:set_info_value(param)
    return r.GetMediaItemTakeInfo_Value(self.pointer, param)
end

-- @return string
function MediaItemTake:set_info_string(param, value)
    local retval, _ = reaper.GetSetMediaItemTakeInfo_String(
            self.pointer, param, value, true
    )
    if not retval then
        error('Could not get media item take info string')
    end
end


function MediaItemTake:set_name(name)
    return self:set_info_string(MediaItemTakeInfoString.P_NAME, name)
end


function MediaItemTake:set_pcm_source(source  --[[PCMSource]])
    r.SetMediaItemTake_Source(self.pointer, source.pointer)
end

function MediaItemTake:set_active()
    r.SetActiveTake(self.pointer)
end