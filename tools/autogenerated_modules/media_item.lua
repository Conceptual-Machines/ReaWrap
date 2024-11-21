-- @description MediaItem: Provide implementation for MediaItem functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_item_take = require('media_item_take')
local media_track = require('media_track')


local MediaItem = {}



--- Create new MediaItem instance.
-- @param media_item userdata. The pointer to Reaper MediaItem*
-- @return MediaItem table.
function MediaItem:new(media_item)
    local obj = {
        pointer_type = constants.PointerTypes.MediaItem,
        pointer = media_item
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the MediaItem logger.
-- @param ... (varargs) Messages to log.
function MediaItem:log(...)
    local logger = helpers.log_func('MediaItem')
    logger(...)
    return nil
end

    
--- Add Take To.
-- creates a new take in an item
-- @return MediaItemTake table
function MediaItem:add_take_to()
    local result = r.AddTakeToMediaItem(self.pointer)
    return media_item_take.MediaItemTake:new(result)
end

    
--- Count Takes.
-- count the number of takes in the item
-- @return integer
function MediaItem:count_takes()
    return r.CountTakes(self.pointer)
end

    
--- Get Active Take.
-- get the active take in this item
-- @return MediaItemTake table
function MediaItem:get_active_take()
    local result = r.GetActiveTake(self.pointer)
    return media_item_take.MediaItemTake:new(result)
end

    
--- Get Displayed Color.
-- see GetDisplayedMediaItemColor2.
-- @return integer
function MediaItem:get_displayed_color()
    return r.GetDisplayedMediaItemColor(self.pointer)
end

    
--- Get Displayed Color2.
-- Returns the custom take, item, or track color that is used (according to the
-- user preference) to color the media item. The returned color is OS
-- dependent|0x01000000 (i.e. ColorToNative(r,g,b)|0x01000000), so a return of zero
-- means "no color", not black.
-- @return integer
function MediaItem:get_displayed_color2()
    return r.GetDisplayedMediaItemColor2(self.pointer, take)
end

    
--- Get Item Project Context.
-- @return ReaProject table
function MediaItem:get_item_project_context()
    local result = r.GetItemProjectContext(self.pointer)
    return rea_project.ReaProject:new(result)
end

    
--- Get Item State Chunk.
-- Gets the RPPXML state of an item, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string
-- @param is_undo boolean
-- @return str string
function MediaItem:get_item_state_chunk(str, is_undo)
    local retval, str = r.GetItemStateChunk(self.pointer, str, is_undo)
    if retval then
        return str
    else
        return nil
    end
end

    
--- Get Track.
-- Get parent track of media item
-- @return MediaTrack table
function MediaItem:get_track()
    local result = r.GetMediaItem_Track(self.pointer)
    return media_track.MediaTrack:new(result)
end

    
--- Get Info Value.
-- Get media item numerical-value attributes. B_MUTE : bool * : muted (item solo
-- overrides). setting this value will clear C_MUTE_SOLO. B_MUTE_ACTUAL : bool * :
-- muted (ignores solo). setting this value will not affect C_MUTE_SOLO.
-- C_LANEPLAYS : char * : on fixed lane tracks, 0=this item lane does not play,
-- 1=this item lane plays exclusively, 2=this item lane plays and other lanes also
-- play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-
-- lane track (read-only) C_MUTE_SOLO : char * : solo override (-1=soloed, 0=no
-- override, 1=unsoloed). note that this API does not automatically unsolo other
-- items when soloing (nor clear the unsolos when clearing the last soloed item),
-- it must be done by the caller via action or via this API. B_LOOPSRC : bool * :
-- loop source B_ALLTAKESPLAY : bool * : all takes play B_UISEL : bool * : selected
-- in arrange view C_BEATATTACHMODE : char * : item timebase, -1=track or project
-- default, 1=beats (position, length, rate), 2=beats (position only). for auto-
-- stretch timebase: C_BEATATTACHMODE=1, C_AUTOSTRETCH=1 C_AUTOSTRETCH: : char * :
-- auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
-- C_LOCK : char * : locked, &1=locked D_VOL : double * : item volume,  0=-inf,
-- 0.5=-6dB, 1=+0dB, 2=+6dB, etc D_POSITION : double * : item position in seconds
-- D_LENGTH : double * : item length in seconds D_SNAPOFFSET : double * : item snap
-- offset in seconds D_FADEINLEN : double * : item manual fadein length in seconds
-- D_FADEOUTLEN : double * : item manual fadeout length in seconds D_FADEINDIR :
-- double * : item fadein curvature, -1..1 D_FADEOUTDIR : double * : item fadeout
-- curvature, -1..1 D_FADEINLEN_AUTO : double * : item auto-fadein length in
-- seconds, -1=no auto-fadein D_FADEOUTLEN_AUTO : double * : item auto-fadeout
-- length in seconds, -1=no auto-fadeout C_FADEINSHAPE : int * : fadein shape,
-- 0..6, 0=linear C_FADEOUTSHAPE : int * : fadeout shape, 0..6, 0=linear I_GROUPID
-- : int * : group ID, 0=no group I_LASTY : int * : Y-position (relative to top of
-- track) in pixels (read-only) I_LASTH : int * : height in pixels (read-only)
-- I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e.
-- ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be
-- used, but will store the color I_CURTAKE : int * : active take number
-- IP_ITEMNUMBER : int : item number on this track (read-only, returns the item
-- number directly) F_FREEMODE_Y : float * : free item positioning or fixed lane
-- Y-position. 0=top of track, 1.0=bottom of track F_FREEMODE_H : float * : free
-- item positioning or fixed lane height. 0.5=half the track height, 1.0=full track
-- height I_FIXEDLANE : int * : fixed lane of item (fine to call with setNewValue,
-- but returned value is read-only) B_FIXEDLANE_HIDDEN : bool * : true if
-- displaying only one fixed lane and this item is in a different lane (read-only)
-- P_TRACK : MediaTrack * : (read-only)
-- @param parmname string
-- @return number
function MediaItem:get_info_value(parmname)
    return r.GetMediaItemInfo_Value(self.pointer, parmname)
end

    
--- Get Num Takes.
-- @return integer
function MediaItem:get_num_takes()
    return r.GetMediaItemNumTakes(self.pointer)
end

    
--- Get Take.
-- @param tk integer
-- @return MediaItemTake table
function MediaItem:get_take(tk)
    local result = r.GetMediaItemTake(self.pointer, tk)
    return media_item_take.MediaItemTake:new(result)
end

    
--- Get Track.
-- @return MediaTrack table
function MediaItem:get_track()
    local result = r.GetMediaItemTrack(self.pointer)
    return media_track.MediaTrack:new(result)
end

    
--- Get Set Info String.
-- Gets/sets an item attribute string: P_NOTES : char * : item note text (do not
-- write to returned pointer, use setNewValue to update) P_EXT:xyz : char * :
-- extension-specific persistent data GUID : GUID * : 16-byte GUID, can query or
-- update. If using a _String() function, GUID is a string {xyz-...}.
-- @param parmname string
-- @param string_need_big string
-- @param set_new_value boolean
-- @return string_need_big string
function MediaItem:get_set_info_string(parmname, string_need_big, set_new_value)
    local retval, string_need_big = r.GetSetMediaItemInfo_String(self.pointer, parmname, string_need_big, set_new_value)
    if retval then
        return string_need_big
    else
        return nil
    end
end

    
--- Get Take.
-- get a take from an item by take count (zero-based)
-- @param take_idx integer
-- @return MediaItemTake table
function MediaItem:get_take(take_idx)
    local result = r.GetTake(self.pointer, take_idx)
    return media_item_take.MediaItemTake:new(result)
end

    
--- Is Selected.
-- @return boolean
function MediaItem:is_selected()
    return r.IsMediaItemSelected(self.pointer)
end

    
--- Descends From Track.
-- Returns 1 if the track holds the item, 2 if the track is a folder containing the
-- track that holds the item, etc.
-- @return integer
function MediaItem:descends_from_track()
    return r.MediaItemDescendsFromTrack(self.pointer, track)
end

    
--- Move To Track.
-- returns TRUE if move succeeded
-- @return boolean
function MediaItem:move_to_track()
    return r.MoveMediaItemToTrack(self.pointer, desttr)
end

    
--- Set Item State Chunk.
-- Sets the RPPXML state of an item, returns true if successful. Undo flag is a
-- performance/caching hint.
-- @param str string
-- @param is_undo boolean
-- @return boolean
function MediaItem:set_item_state_chunk(str, is_undo)
    return r.SetItemStateChunk(self.pointer, str, is_undo)
end

    
--- Set Info Value.
-- Set media item numerical-value attributes. B_MUTE : bool * : muted (item solo
-- overrides). setting this value will clear C_MUTE_SOLO. B_MUTE_ACTUAL : bool * :
-- muted (ignores solo). setting this value will not affect C_MUTE_SOLO.
-- C_LANEPLAYS : char * : on fixed lane tracks, 0=this item lane does not play,
-- 1=this item lane plays exclusively, 2=this item lane plays and other lanes also
-- play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-
-- lane track (read-only) C_MUTE_SOLO : char * : solo override (-1=soloed, 0=no
-- override, 1=unsoloed). note that this API does not automatically unsolo other
-- items when soloing (nor clear the unsolos when clearing the last soloed item),
-- it must be done by the caller via action or via this API. B_LOOPSRC : bool * :
-- loop source B_ALLTAKESPLAY : bool * : all takes play B_UISEL : bool * : selected
-- in arrange view C_BEATATTACHMODE : char * : item timebase, -1=track or project
-- default, 1=beats (position, length, rate), 2=beats (position only). for auto-
-- stretch timebase: C_BEATATTACHMODE=1, C_AUTOSTRETCH=1 C_AUTOSTRETCH: : char * :
-- auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
-- C_LOCK : char * : locked, &1=locked D_VOL : double * : item volume,  0=-inf,
-- 0.5=-6dB, 1=+0dB, 2=+6dB, etc D_POSITION : double * : item position in seconds
-- D_LENGTH : double * : item length in seconds D_SNAPOFFSET : double * : item snap
-- offset in seconds D_FADEINLEN : double * : item manual fadein length in seconds
-- D_FADEOUTLEN : double * : item manual fadeout length in seconds D_FADEINDIR :
-- double * : item fadein curvature, -1..1 D_FADEOUTDIR : double * : item fadeout
-- curvature, -1..1 D_FADEINLEN_AUTO : double * : item auto-fadein length in
-- seconds, -1=no auto-fadein D_FADEOUTLEN_AUTO : double * : item auto-fadeout
-- length in seconds, -1=no auto-fadeout C_FADEINSHAPE : int * : fadein shape,
-- 0..6, 0=linear C_FADEOUTSHAPE : int * : fadeout shape, 0..6, 0=linear I_GROUPID
-- : int * : group ID, 0=no group I_LASTY : int * : Y-position (relative to top of
-- track) in pixels (read-only) I_LASTH : int * : height in pixels (read-only)
-- I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e.
-- ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be
-- used, but will store the color I_CURTAKE : int * : active take number
-- IP_ITEMNUMBER : int : item number on this track (read-only, returns the item
-- number directly) F_FREEMODE_Y : float * : free item positioning or fixed lane
-- Y-position. 0=top of track, 1.0=bottom of track F_FREEMODE_H : float * : free
-- item positioning or fixed lane height. 0.5=half the track height, 1.0=full track
-- height I_FIXEDLANE : int * : fixed lane of item (fine to call with setNewValue,
-- but returned value is read-only) B_FIXEDLANE_HIDDEN : bool * : true if
-- displaying only one fixed lane and this item is in a different lane (read-only)
-- @param parmname string
-- @param newvalue number
-- @return boolean
function MediaItem:set_info_value(parmname, newvalue)
    return r.SetMediaItemInfo_Value(self.pointer, parmname, newvalue)
end

    
--- Set Length.
-- Redraws the screen only if refreshUI == true. See UpdateArrange().
-- @param length number
-- @param refresh_ui boolean
-- @return boolean
function MediaItem:set_length(length, refresh_ui)
    return r.SetMediaItemLength(self.pointer, length, refresh_ui)
end

    
--- Set Position.
-- Redraws the screen only if refreshUI == true. See UpdateArrange().
-- @param position number
-- @param refresh_ui boolean
-- @return boolean
function MediaItem:set_position(position, refresh_ui)
    return r.SetMediaItemPosition(self.pointer, position, refresh_ui)
end

    
--- Set Selected.
-- @param selected boolean
function MediaItem:set_selected(selected)
    return r.SetMediaItemSelected(self.pointer, selected)
end

    
--- Split.
-- the original item becomes the left-hand split, the function returns the right-
-- hand split (or NULL if the split failed)
-- @param position number
-- @return MediaItem table
function MediaItem:split(position)
    local result = r.SplitMediaItem(self.pointer, position)
    return media_item.MediaItem:new(result)
end

    
--- Update Item In Project.
function MediaItem:update_item_in_project()
    return r.UpdateItemInProject(self.pointer)
end

    
--- Br Get Guid.
-- [BR] Get media item GUID as a string (guidStringOut_sz should be at least 64).
-- To get media item back from GUID string, see BR_GetMediaItemByGUID.
-- @return guid_string string
function MediaItem:br_get_guid()
    return r.BR_GetMediaItemGUID(self.pointer)
end

    
--- Br Get Image Resource.
-- [BR] Get currently loaded image resource and its flags for a given item. Returns
-- false if there is no image resource set. To set image resource, see
-- BR_SetMediaItemImageResource.
-- @return image string
-- @return image_flags integer
function MediaItem:br_get_image_resource()
    local retval, image, image_flags = r.BR_GetMediaItemImageResource(self.pointer)
    if retval then
        return image, image_flags
    else
        return nil
    end
end

    
--- Set Item Edges.
-- [BR] Set item start and end edges' position - returns true in case of any
-- changes
-- @param start_time number
-- @param end_time number
-- @return boolean
function MediaItem:set_item_edges(start_time, end_time)
    return r.BR_SetItemEdges(self.pointer, start_time, end_time)
end

    
--- Br Set Image Resource.
-- [BR] Set image resource and its flags for a given item. To clear current image
-- resource, pass imageIn as "". imageFlags: &1=0: don't display image, &1: center
-- / tile, &3: stretch, &5: full height (REAPER 5.974+). Can also be used to
-- display existing text in empty items unstretched (pass imageIn = "", imageFlags
-- = 0) or stretched (pass imageIn = "". imageFlags = 3). To get image resource,
-- see BR_GetMediaItemImageResource.
-- @param image_in string
-- @param image_flags integer
function MediaItem:br_set_image_resource(image_in, image_flags)
    return r.BR_SetMediaItemImageResource(self.pointer, image_in, image_flags)
end

return MediaItem
