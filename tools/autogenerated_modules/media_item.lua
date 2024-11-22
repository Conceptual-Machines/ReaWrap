-- @description Provide implementation for MediaItem functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')
local media_item_take = require('media_item_take')
local media_track = require('media_track')


local MediaItem = {}



--- Create new MediaItem instance.
-- @param media_item userdata. The pointer to Reaper MediaItem*
-- @return MediaItem table.
function MediaItem:new(media_item)
    local obj = {
        pointer_type = "MediaItem*",
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
-- @param str string.
-- @param is_undo boolean.
-- @return ret_val boolean
-- @return str string
function MediaItem:get_item_state_chunk(str, is_undo)
    return r.GetItemStateChunk(self.pointer, str, is_undo)
end

    
--- Get Track.
-- Get parent track of media item
-- @return MediaTrack table
function MediaItem:get_track()
    local result = r.GetMediaItem_Track(self.pointer)
    return media_track.MediaTrack:new(result)
end

    
--- Constants for MediaItem:get_info_value.
-- @field B_MUTE boolean: muted (item solo overrides). setting this value will clear C_MUTE_SOLO.
-- @field B_MUTE_ACTUAL boolean: muted (ignores solo). setting this value will not affect C_MUTE_SOLO.
-- @field C_LANEPLAYS string: on fixed lane tracks, 0=this item lane does not play, 1=this item lane plays exclusively, 2=this item lane plays and other lanes also play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-lane track (read-only)
-- @field C_MUTE_SOLO string: solo override (-1=soloed, 0=no override, 1=unsoloed). note that this API does not automatically unsolo other items when soloing (nor clear the unsolos when clearing the last soloed item), it must be done by the caller via action or via this API.
-- @field B_LOOPSRC boolean: loop source
-- @field B_ALLTAKESPLAY boolean: all takes play
-- @field B_UISEL boolean: selected in arrange view
-- @field C_BEATATTACHMODE string: char *item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebaseC_BEATATTACHMODE=1, C_AUTOSTRETCH=1
-- @field C_AUTOSTRETCH string: auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
-- @field C_LOCK string: locked, &1=locked
-- @field D_VOL double *: item volume,  0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
-- @field D_POSITION double *: item position in seconds
-- @field D_LENGTH double *: item length in seconds
-- @field D_SNAPOFFSET double *: item snap offset in seconds
-- @field D_FADEINLEN double *: item manual fadein length in seconds
-- @field D_FADEOUTLEN double *: item manual fadeout length in seconds
-- @field D_FADEINDIR double *: item fadein curvature, -1..1
-- @field D_FADEOUTDIR double *: item fadeout curvature, -1..1
-- @field D_FADEINLEN_AUTO double *: item auto-fadein length in seconds, -1=no auto-fadein
-- @field D_FADEOUTLEN_AUTO double *: item auto-fadeout length in seconds, -1=no auto-fadeout
-- @field C_FADEINSHAPE number: fadein shape, 0..6, 0=linear
-- @field C_FADEOUTSHAPE number: fadeout shape, 0..6, 0=linear
-- @field I_GROUPID number: group ID, 0=no group
-- @field I_LASTY number: Y-position (relative to top of track) in pixels (read-only)
-- @field I_LASTH number: height in pixels (read-only)
-- @field I_CUSTOMCOLOR number: custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
-- @field I_CURTAKE number: active take number
-- @field IP_ITEMNUMBER number: item number on this track (read-only, returns the item number directly)
-- @field F_FREEMODE_Y float *: free item positioning or fixed lane Y-position. 0=top of track, 1.0=bottom of track
-- @field F_FREEMODE_H float *: free item positioning or fixed lane height. 0.5=half the track height, 1.0=full track height
-- @field I_FIXEDLANE number: fixed lane of item (fine to call with setNewValue, but returned value is read-only)
-- @field B_FIXEDLANE_HIDDEN boolean: true if displaying only one fixed lane and this item is in a different lane (read-only)
-- @field P_TRACK MediaTrack: (read-only)
MediaItem.GetInfoValueConstants{
    B_MUTE = "B_MUTE",
    B_MUTE_ACTUAL = "B_MUTE_ACTUAL",
    C_LANEPLAYS = "C_LANEPLAYS",
    C_MUTE_SOLO = "C_MUTE_SOLO",
    B_LOOPSRC = "B_LOOPSRC",
    B_ALLTAKESPLAY = "B_ALLTAKESPLAY",
    B_UISEL = "B_UISEL",
    C_BEATATTACHMODE = "C_BEATATTACHMODE",
    C_AUTOSTRETCH = "C_AUTOSTRETCH",
    C_LOCK = "C_LOCK",
    D_VOL = "D_VOL",
    D_POSITION = "D_POSITION",
    D_LENGTH = "D_LENGTH",
    D_SNAPOFFSET = "D_SNAPOFFSET",
    D_FADEINLEN = "D_FADEINLEN",
    D_FADEOUTLEN = "D_FADEOUTLEN",
    D_FADEINDIR = "D_FADEINDIR",
    D_FADEOUTDIR = "D_FADEOUTDIR",
    D_FADEINLEN_AUTO = "D_FADEINLEN_AUTO",
    D_FADEOUTLEN_AUTO = "D_FADEOUTLEN_AUTO",
    C_FADEINSHAPE = "C_FADEINSHAPE",
    C_FADEOUTSHAPE = "C_FADEOUTSHAPE",
    I_GROUPID = "I_GROUPID",
    I_LASTY = "I_LASTY",
    I_LASTH = "I_LASTH",
    I_CUSTOMCOLOR = "I_CUSTOMCOLOR",
    I_CURTAKE = "I_CURTAKE",
    IP_ITEMNUMBER = "IP_ITEMNUMBER",
    F_FREEMODE_Y = "F_FREEMODE_Y",
    F_FREEMODE_H = "F_FREEMODE_H",
    I_FIXEDLANE = "I_FIXEDLANE",
    B_FIXEDLANE_HIDDEN = "B_FIXEDLANE_HIDDEN",
    P_TRACK = "P_TRACK",
}
    
--- Get Info Value.
-- Get media item numerical-value attributes.
-- @param parm_name string. MediaItem.GetInfoValueConstants
-- @return number
function MediaItem:get_info_value(parm_name)
    return r.GetMediaItemInfo_Value(self.pointer, parm_name)
end

    
--- Get Num Takes.
-- @return integer
function MediaItem:get_num_takes()
    return r.GetMediaItemNumTakes(self.pointer)
end

    
--- Get Take.
-- @param tk integer.
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

    
--- Constants for MediaItem:get_set_info_string.
-- @field P_NOTES string: item note text (do not write to returned pointer, use setNewValue to update)
-- @field P_EXT xyz: xyzchar *extension-specific persistent data
-- @field GUID GUID *: 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
MediaItem.GetSetInfoStringConstants{
    P_NOTES = "P_NOTES",
    P_EXT = "P_EXT",
    GUID = "GUID",
}
    
--- Get Set Info String.
-- Gets/sets an item attribute string:
-- @param parm_name string. MediaItem.GetSetInfoStringConstants
-- @param string_need_big string.
-- @param set_new_value boolean.
-- @return ret_val boolean
-- @return string_need_big string
function MediaItem:get_set_info_string(parm_name, string_need_big, set_new_value)
    return r.GetSetMediaItemInfo_String(self.pointer, parm_name, string_need_big, set_new_value)
end

    
--- Get Take.
-- get a take from an item by take count (zero-based)
-- @param take_idx integer.
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

    
--- Set Item Extents.
-- Set the start/end positions of a media item that contains a MIDI take.
-- @param start_qn number.
-- @param end_qn number.
-- @return boolean
function MediaItem:set_item_extents(start_qn, end_qn)
    return r.MIDI_SetItemExtents(self.pointer, start_qn, end_qn)
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
-- @param str string.
-- @param is_undo boolean.
-- @return boolean
function MediaItem:set_item_state_chunk(str, is_undo)
    return r.SetItemStateChunk(self.pointer, str, is_undo)
end

    
--- Constants for MediaItem:set_info_value.
-- @field B_MUTE boolean: muted (item solo overrides). setting this value will clear C_MUTE_SOLO.
-- @field B_MUTE_ACTUAL boolean: muted (ignores solo). setting this value will not affect C_MUTE_SOLO.
-- @field C_LANEPLAYS string: on fixed lane tracks, 0=this item lane does not play, 1=this item lane plays exclusively, 2=this item lane plays and other lanes also play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-lane track (read-only)
-- @field C_MUTE_SOLO string: solo override (-1=soloed, 0=no override, 1=unsoloed). note that this API does not automatically unsolo other items when soloing (nor clear the unsolos when clearing the last soloed item), it must be done by the caller via action or via this API.
-- @field B_LOOPSRC boolean: loop source
-- @field B_ALLTAKESPLAY boolean: all takes play
-- @field B_UISEL boolean: selected in arrange view
-- @field C_BEATATTACHMODE string: char *item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebaseC_BEATATTACHMODE=1, C_AUTOSTRETCH=1
-- @field C_AUTOSTRETCH string: auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
-- @field C_LOCK string: locked, &1=locked
-- @field D_VOL double *: item volume,  0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
-- @field D_POSITION double *: item position in seconds
-- @field D_LENGTH double *: item length in seconds
-- @field D_SNAPOFFSET double *: item snap offset in seconds
-- @field D_FADEINLEN double *: item manual fadein length in seconds
-- @field D_FADEOUTLEN double *: item manual fadeout length in seconds
-- @field D_FADEINDIR double *: item fadein curvature, -1..1
-- @field D_FADEOUTDIR double *: item fadeout curvature, -1..1
-- @field D_FADEINLEN_AUTO double *: item auto-fadein length in seconds, -1=no auto-fadein
-- @field D_FADEOUTLEN_AUTO double *: item auto-fadeout length in seconds, -1=no auto-fadeout
-- @field C_FADEINSHAPE number: fadein shape, 0..6, 0=linear
-- @field C_FADEOUTSHAPE number: fadeout shape, 0..6, 0=linear
-- @field I_GROUPID number: group ID, 0=no group
-- @field I_LASTY number: Y-position (relative to top of track) in pixels (read-only)
-- @field I_LASTH number: height in pixels (read-only)
-- @field I_CUSTOMCOLOR number: custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
-- @field I_CURTAKE number: active take number
-- @field IP_ITEMNUMBER number: item number on this track (read-only, returns the item number directly)
-- @field F_FREEMODE_Y float *: free item positioning or fixed lane Y-position. 0=top of track, 1.0=bottom of track
-- @field F_FREEMODE_H float *: free item positioning or fixed lane height. 0.5=half the track height, 1.0=full track height
-- @field I_FIXEDLANE number: fixed lane of item (fine to call with setNewValue, but returned value is read-only)
-- @field B_FIXEDLANE_HIDDEN boolean: true if displaying only one fixed lane and this item is in a different lane (read-only)
MediaItem.SetInfoValueConstants{
    B_MUTE = "B_MUTE",
    B_MUTE_ACTUAL = "B_MUTE_ACTUAL",
    C_LANEPLAYS = "C_LANEPLAYS",
    C_MUTE_SOLO = "C_MUTE_SOLO",
    B_LOOPSRC = "B_LOOPSRC",
    B_ALLTAKESPLAY = "B_ALLTAKESPLAY",
    B_UISEL = "B_UISEL",
    C_BEATATTACHMODE = "C_BEATATTACHMODE",
    C_AUTOSTRETCH = "C_AUTOSTRETCH",
    C_LOCK = "C_LOCK",
    D_VOL = "D_VOL",
    D_POSITION = "D_POSITION",
    D_LENGTH = "D_LENGTH",
    D_SNAPOFFSET = "D_SNAPOFFSET",
    D_FADEINLEN = "D_FADEINLEN",
    D_FADEOUTLEN = "D_FADEOUTLEN",
    D_FADEINDIR = "D_FADEINDIR",
    D_FADEOUTDIR = "D_FADEOUTDIR",
    D_FADEINLEN_AUTO = "D_FADEINLEN_AUTO",
    D_FADEOUTLEN_AUTO = "D_FADEOUTLEN_AUTO",
    C_FADEINSHAPE = "C_FADEINSHAPE",
    C_FADEOUTSHAPE = "C_FADEOUTSHAPE",
    I_GROUPID = "I_GROUPID",
    I_LASTY = "I_LASTY",
    I_LASTH = "I_LASTH",
    I_CUSTOMCOLOR = "I_CUSTOMCOLOR",
    I_CURTAKE = "I_CURTAKE",
    IP_ITEMNUMBER = "IP_ITEMNUMBER",
    F_FREEMODE_Y = "F_FREEMODE_Y",
    F_FREEMODE_H = "F_FREEMODE_H",
    I_FIXEDLANE = "I_FIXEDLANE",
    B_FIXEDLANE_HIDDEN = "B_FIXEDLANE_HIDDEN",
}
    
--- Set Info Value.
-- Set media item numerical-value attributes.
-- @param parm_name string. MediaItem.SetInfoValueConstants
-- @param newvalue number.
-- @return boolean
function MediaItem:set_info_value(parm_name, newvalue)
    return r.SetMediaItemInfo_Value(self.pointer, parm_name, newvalue)
end

    
--- Set Length.
-- Redraws the screen only if refreshUI == true. See UpdateArrange().
-- @param length number.
-- @param refresh_ui boolean.
-- @return boolean
function MediaItem:set_length(length, refresh_ui)
    return r.SetMediaItemLength(self.pointer, length, refresh_ui)
end

    
--- Set Position.
-- Redraws the screen only if refreshUI == true. See UpdateArrange().
-- @param position number.
-- @param refresh_ui boolean.
-- @return boolean
function MediaItem:set_position(position, refresh_ui)
    return r.SetMediaItemPosition(self.pointer, position, refresh_ui)
end

    
--- Set Selected.
-- @param selected boolean.
function MediaItem:set_selected(selected)
    return r.SetMediaItemSelected(self.pointer, selected)
end

    
--- Split.
-- the original item becomes the left-hand split, the function returns the right-
-- hand split (or NULL if the split failed)
-- @param position number.
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
-- @return ret_val boolean
-- @return image string
-- @return image_flags integer
function MediaItem:br_get_image_resource()
    return r.BR_GetMediaItemImageResource(self.pointer)
end

    
--- Set Item Edges.
-- [BR] Set item start and end edges' position - returns true in case of any
-- changes
-- @param start_time number.
-- @param end_time number.
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
-- @param image_in string.
-- @param image_flags integer.
function MediaItem:br_set_image_resource(image_in, image_flags)
    return r.BR_SetMediaItemImageResource(self.pointer, image_in, image_flags)
end

    
--- Nf Analyze Peak And Rms.
-- This function combines all other NF_Peak/RMS functions in a single one and
-- additionally returns peak RMS positions. Lua example code here. Note: It's
-- recommended to use this function with ReaScript/Lua as it provides reaper.array
-- objects. If using this function with other scripting languages, you must provide
-- arrays in the reaper.array format.
-- @param window_size number.
-- @param reaperarray_peaks identifier.
-- @param reaperarray_peakpositions identifier.
-- @param reaperarray_rm_ss identifier.
-- @param reaperarray_rm_spositions identifier.
-- @return boolean
function MediaItem:nf_analyze_peak_and_rms(window_size, reaperarray_peaks, reaperarray_peakpositions, reaperarray_rm_ss, reaperarray_rm_spositions)
    return r.NF_AnalyzeMediaItemPeakAndRMS(self.pointer, window_size, reaperarray_peaks, reaperarray_peakpositions, reaperarray_rm_ss, reaperarray_rm_spositions)
end

    
--- Delete Take From Item.
-- Deletes a take from an item. takeIdx is zero-based. Returns true on success.
-- @param take_idx integer.
-- @return boolean
function MediaItem:delete_take_from_item(take_idx)
    return r.NF_DeleteTakeFromItem(self.pointer, take_idx)
end

    
--- Nf Get Average Rms.
-- Returns the average overall (non-windowed) dB RMS level of active channels of an
-- audio item active take, post item gain, post take volume envelope, post-fade,
-- pre fader, pre item FX.   Returns -150.0 if MIDI take or empty item.
-- @return number
function MediaItem:nf_get_average_rms()
    return r.NF_GetMediaItemAverageRMS(self.pointer)
end

    
--- Nf Get Max Peak.
-- Returns the greatest max. peak value in dBFS of all active channels of an audio
-- item active take, post item gain, post take volume envelope, post-fade, pre
-- fader, pre item FX.   Returns -150.0 if MIDI take or empty item.
-- @return number
function MediaItem:nf_get_max_peak()
    return r.NF_GetMediaItemMaxPeak(self.pointer)
end

    
--- Nf Get Max Peak And Max Peak Pos.
-- See NF_GetMediaItemMaxPeak, additionally returns maxPeakPos (relative to item
-- position).
-- @return ret_val number
-- @return max_peak_pos number
function MediaItem:nf_get_max_peak_and_max_peak_pos()
    return r.NF_GetMediaItemMaxPeakAndMaxPeakPos(self.pointer)
end

    
--- Nf Get Peak Rms Non Windowed.
-- Returns the greatest overall (non-windowed) dB RMS peak level of all active
-- channels of an audio item active take, post item gain, post take volume
-- envelope, post-fade, pre fader, pre item FX.   Returns -150.0 if MIDI take or
-- empty item.
-- @return number
function MediaItem:nf_get_peak_rms_non_windowed()
    return r.NF_GetMediaItemPeakRMS_NonWindowed(self.pointer)
end

    
--- Nf Get Peak Rms Windowed.
-- Returns the average dB RMS peak level of all active channels of an audio item
-- active take, post item gain, post take volume envelope, post-fade, pre fader,
-- pre item FX.   Obeys 'Window size for peak RMS' setting in 'SWS: Set RMS
-- analysis/normalize options' for calculation. Returns -150.0 if MIDI take or
-- empty item.
-- @return number
function MediaItem:nf_get_peak_rms_windowed()
    return r.NF_GetMediaItemPeakRMS_Windowed(self.pointer)
end

    
--- Get Set Source State.
-- [S&M] Gets or sets a take source state. Returns false if failed. Use takeidx=-1
-- to get/alter the active take. Note: this function does not use a MediaItem_Take*
-- param in order to manage empty takes (i.e. takes with MediaItem_Take*==NULL),
-- see SNM_GetSetSourceState2.
-- @param take_idx integer.
-- @param state WDL_FastString.
-- @param setnewvalue boolean.
-- @return boolean
function MediaItem:get_set_source_state(take_idx, state, setnewvalue)
    return r.SNM_GetSetSourceState(self.pointer, take_idx, state, setnewvalue)
end

return MediaItem
