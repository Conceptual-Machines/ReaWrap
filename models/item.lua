local constants = require('models.constants')
local helpers = require('models.helpers')
local media_item_take = require('models.take')

local r = reaper

-- MediaItem
MediaItem = {
    pointer_type = constants.PointerTypes.MediaItem,

}


-- MediaItem constructor
-- @media_item : userdata
function MediaItem:new(media_item)
    local o = {
        pointer = media_item
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function MediaItem:__tostring()
    return string.format(
            '<MediaItem GUID=%s>', self:GUID()
    )
end

function MediaItem:log(...)
    local logger = log_func('MediaItem')
    logger(...)
end


-- @return string
function MediaItem:GUID()
    return r.BR_GetMediaItemGUID(self.pointer)
end

-- Get media item numerical-value attributes
-- @param string : Accepted param values: constants.MediaItemInfoValue
-- @return number
function MediaItem:get_info_value(param --[[string]])
    --if MediaItemInfoValue[param] == nil then
    --    error('Invalid param. Please use constants.MediaItemInfoValue')
    --end
    return r.GetMediaItemInfo_Value(self.pointer, param)
end

-- Get media item attribute string
-- @param string : Accepted param values: constants.MediaItemInfoString
-- @return string
function MediaItem:get_info_string(param --[[string]])
    --if MediaItemInfoValue[param] == nil then
    --    error('Invalid param. Please use constants.MediaItemInfoValue')
    --end
    retval, info = r.GetSetMediaItemInfo_String(self.pointer, param, '',  false)
    if retval then
        return info
    end
end


-- Get media item length
function MediaItem:get_length()
    return r.GetMediaItemInfo_Value(self.pointer, MediaItemInfoValue.D_LENGTH)
end


-- Get media item position
function MediaItem:get_position()
    return r.GetMediaItemInfo_Value(self.pointer, MediaItemInfoValue.D_POSITION)
end

-- Set media item numerical-value attributes
-- @param string : Accepted param values: constants.MediaItemInfoValue
-- @value
function MediaItem:set_info_value(param --[[string]], value --[[any]])
    --if MediaItemInfoValue[param] == nil then
    --    error('Invalid param. Please use constants.MediaItemInfoValue')
    --end
    return r.SetMediaItemInfo_Value(self.pointer, param, value)
end

-- Set media item attribute string
-- @param string : Accepted param values: constants.MediaItemInfoString
-- @value string
function MediaItem:set_info_string(param --[[string]], value --[[string]])
    --if MediaItemInfoValue[param] == nil then
    --    error('Invalid param. Please use constants.MediaItemInfoValue')
    --end
     local retval, info = r.GetSetMediaItemInfo_String(
             self.pointer, param, value,  true
     )
end

function MediaItem:set_length(length --[[number]], refreshUI --[[boolean]])
    refreshUI = refreshUI or true
    r.SetMediaItemLength(self.pointer, length, refreshUI)
end

function MediaItem:set_position(position --[[number]], refreshUI --[[boolean]])
    refreshUI = refreshUI or true
    r.SetMediaItemPosition(self.pointer, position, refreshUI)
end

-- Total number of takes in MediaItem
-- @return number
function MediaItem:count_takes()
    return r.GetMediaItemNumTakes(self.pointer)
end

-- Get take by selected idx
-- @return MediaItemTake
function MediaItem:get_take(idx --[[number]])
    local take = r.GetMediaItemTake(self.pointer, idx)
    return media_item_take.MediaItemTake:new(self, take)
end

-- Get all takes
-- @return Table<MediaItemTake>
function MediaItem:get_takes()
    local takes = {}
    for i = 0, self:count_takes() - 1 do
        local take = self:get_take(i)
        takes[i + 1] = take
    end
    return takes
end


-- Iterate over takes with iterator function
function MediaItem:iter_takes()
    return helpers.iter(self:get_takes())
end


-- Add take to media item and return it
-- @return MediaItemTake
function MediaItem:add_take()
    local take = r.AddTakeToMediaItem(self.pointer)
    return media_item_take.MediaItemTake:new(self, take)
end

function MediaItem:get_state_chunk(is_undo --[[boolean - optional]])
    is_undo = is_undo or false
    local retval, chunk = r.GetItemStateChunk(self.pointer, '', is_undo)
    if retval then
        return chunk
    else
        return nil
    end
end

function MediaItem:set_state_chunk(state --[[string]], is_undo --[[boolean - optional]])
    is_undo = is_undo or false
    return r.SetItemStateChunk(self.pointer, state, is_undo)
end

return MediaItem