--- Provide implementation for Item functions.
-- @author NomadMonad
-- @license MIT
-- @release 0.0.1

local r = reaper
local helpers = require("helpers")

-- @class Item
-- @field pointer_type string "MediaItem*"
-- @field pointer userdata The pointer to Reaper MediaItem*
local Item = {}

--- Create new Item instance.
--- @within ReaWrap Custom Methods
--- @param item userdata The pointer to Reaper MediaItem*
--- @return table Item instance
function Item:new(item)
	local obj = {
		pointer_type = "MediaItem*",
		pointer = item,
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

--- Log messages with the Item logger.
--- @within ReaWrap Custom Methods
--- @param ... (varargs) Messages to log.
function Item:log(...)
	local logger = helpers.log_func("Item")
	logger(...)
	return nil
end

--- String representation of the Item instance.
--- @within ReaWrap Custom Methods
--- @return string
function Item:__tostring()
	return string.format("<Item GUID=%s>", self:get_guid())
end

--- Get all takes.
--- @within ReaWrap Custom Methods
--- @return table array<Take>
function Item:get_takes()
	local takes = {}
	local count = self:count_takes()
	for i = 0, count - 1 do
		local take = self:get_take(i)
		takes[i + 1] = take
	end
	return takes
end

--- Iterate over takes.
--- @within ReaWrap Custom Methods
--- @return function iterator
function Item:iter_takes()
	return helpers.iter(self:get_takes())
end

--- Whether there is at least one take in the item.
--- @within ReaWrap Custom Methods
--- @return boolean
function Item:has_takes()
	return self:count_takes() > 0
end

--- Set Length in Beats.
-- Redraws the screen only if refreshUI == true.
--- @within ReaWrap Custom Methods
--- @param length number Length in beats.
--- @param refresh_ui boolean Optional (default true).
--- @return boolean
function Item:set_length_beats(length, refresh_ui)
	local project = self:get_project_context()
	local beats_to_seconds = project:beats_to_time(length)
	local refresh_ui = refresh_ui or true
	return r.SetMediaItemLength(self.pointer, beats_to_seconds, refresh_ui)
end

--- Set Position in Beats.
-- Redraws the screen only if refreshUI == true.
--- @within ReaWrap Custom Methods
--- @param position number Position in beats.
--- @param refresh_ui boolean Optional (default true).
--- @return boolean
function Item:set_position_beats(position, refresh_ui)
	local project = self:get_project_context()
	local beats_to_seconds = project:beats_to_time(position)
	local refresh_ui = refresh_ui or true
	return r.SetMediaItemLength(self.pointer, beats_to_seconds, refresh_ui)
end

--- Add Take. Wraps AddTakeToMediaItem.
-- creates a new take in an item
--- @within ReaScript Wrapped Methods
--- @return table Take instance
function Item:add_take()
	local Take = require("take")
	local result = r.AddTakeToMediaItem(self.pointer)
	return Take:new(result)
end

--- Count Takes. Wraps CountTakes.
-- count the number of takes in the item
--- @within ReaScript Wrapped Methods
--- @return number
function Item:count_takes()
	return r.CountTakes(self.pointer)
end

--- Get Active Take. Wraps GetActiveTake.
-- get the active take in this item
--- @within ReaScript Wrapped Methods
--- @return table Take instance
function Item:get_active_take()
	local Take = require("take")
	local result = r.GetActiveTake(self.pointer)
	return Take:new(result)
end

--- Get Displayed Color. Wraps GetDisplayedMediaItemColor.
-- see GetDisplayedMediaItemColor2.
--- @within ReaScript Wrapped Methods
--- @return number
function Item:get_displayed_color()
	return r.GetDisplayedMediaItemColor(self.pointer)
end

--- Get Displayed Color2. Wraps GetDisplayedMediaItemColor2.
-- Returns the custom take, item, or track color that is used (according to the
-- user preference) to color the media item. The returned color is OS
-- dependent|0x01000000 (i.e. ColorToNative(r,g,b)|0x01000000), so a return of zero
-- means "no color", not black.
--- @within ReaScript Wrapped Methods
--- @return number
function Item:get_displayed_color2()
	return r.GetDisplayedMediaItemColor2(self.pointer, take)
end

--- Get Item Project Context. Wraps GetItemProjectContext.
--- @within ReaScript Wrapped Methods
--- @return table Project instance
function Item:get_project_context()
	local Project = require("project")
	local result = r.GetItemProjectContext(self.pointer)
	return Project:new(result)
end

--- Get Item State Chunk. Wraps GetItemStateChunk.
-- Gets the RPPXML state of an item, returns true if successful. Undo flag is a
-- performance/caching hint.
--- @within ReaScript Wrapped Methods
--- @param str string
--- @param is_undo boolean
--- @return string
function Item:get_state_chunk(str, is_undo)
	local ret_val, chunk = r.GetItemStateChunk(self.pointer, str, is_undo)
	if ret_val then
		return chunk
	else
		error("Failed to get item state chunk.")
	end
end

--- Get Track. Wraps GetMediaItem_Track.
-- Get parent track of media item
--- @within ReaScript Wrapped Methods
--- @return table Track object
function Item:get_track()
	local Track = require("track")
	local result = r.GetMediaItem_Track(self.pointer)
	return Track:new(result)
end

--- Constants for Item:get_info_value.
--- @within Constants
--- @field B_MUTE boolean: muted (item solo overrides). setting this value will clear C_MUTE_SOLO.
--- @field B_MUTE_ACTUAL boolean: muted (ignores solo). setting this value will not affect C_MUTE_SOLO.
--- @field C_LANEPLAYS string: on fixed lane tracks, 0=this item lane does not play, 1=this item lane plays exclusively, 2=this item lane plays and other lanes also play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-lane track (read-only)
--- @field C_MUTE_SOLO string: solo override (-1=soloed, 0=no override, 1=unsoloed). note that this API does not automatically unsolo other items when soloing (nor clear the unsolos when clearing the last soloed item), it must be done by the caller via action or via this API.
--- @field B_LOOPSRC boolean: loop source
--- @field B_ALLTAKESPLAY boolean: all takes play
--- @field B_UISEL boolean: selected in arrange view
--- @field C_BEATATTACHMODE string: char *item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebaseC_BEATATTACHMODE=1, C_AUTOSTRETCH=1
--- @field C_AUTOSTRETCH string: auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
--- @field C_LOCK string: locked, &1=locked
--- @field D_VOL number: item volume,  0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
--- @field D_POSITION number: item position in seconds
--- @field D_LENGTH number: item length in seconds
--- @field D_SNAPOFFSET number: item snap offset in seconds
--- @field D_FADEINLEN number: item manual fadein length in seconds
--- @field D_FADEOUTLEN number: item manual fadeout length in seconds
--- @field D_FADEINDIR number: item fadein curvature, -1..1
--- @field D_FADEOUTDIR number: item fadeout curvature, -1..1
--- @field D_FADEINLEN_AUTO number: item auto-fadein length in seconds, -1=no auto-fadein
--- @field D_FADEOUTLEN_AUTO number: item auto-fadeout length in seconds, -1=no auto-fadeout
--- @field C_FADEINSHAPE number: fadein shape, 0..6, 0=linear
--- @field C_FADEOUTSHAPE number: fadeout shape, 0..6, 0=linear
--- @field I_GROUPID number: group ID, 0=no group
--- @field I_LASTY number: Y-position (relative to top of track) in pixels (read-only)
--- @field I_LASTH number: height in pixels (read-only)
--- @field I_CUSTOMCOLOR number: custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
--- @field I_CURTAKE number: active take number
--- @field IP_ITEMNUMBER number: item number on this track (read-only, returns the item number directly)
--- @field F_FREEMODE_Y float *: free item positioning or fixed lane Y-position. 0=top of track, 1.0=bottom of track
--- @field F_FREEMODE_H float *: free item positioning or fixed lane height. 0.5=half the track height, 1.0=full track height
--- @field I_FIXEDLANE number: fixed lane of item (fine to call with setNewValue, but returned value is read-only)
--- @field B_FIXEDLANE_HIDDEN boolean: true if displaying only one fixed lane and this item is in a different lane (read-only)
--- @field P_TRACK userdata: (read-only)
Item.GetInfoValueConstants = {
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

--- Get Info Value. Wraps GetMediaItemInfo_Value.
-- Get media item numerical-value attributes.
--- @within ReaScript Wrapped Methods
--- @param param_name string Item.GetInfoValueConstants
--- @return number
--- @see Item.GetInfoValueConstants
function Item:get_info_value(param_name)
	return r.GetMediaItemInfo_Value(self.pointer, param_name)
end

--- Get Num Takes. Wraps GetMediaItemNumTakes.
--- @within ReaScript Wrapped Methods
--- @return number
function Item:get_num_takes()
	return r.GetMediaItemNumTakes(self.pointer)
end

--- Get Take. Wraps GetMediaItemTake.
--- @within ReaScript Wrapped Methods
--- @param tk number
--- @return Take table
function Item:get_take(tk)
	local Take = require("take")
	local result = r.GetMediaItemTake(self.pointer, tk)
	return Take:new(result)
end

--- Constants for Item:get_set_info_string.
--- @within Constants
--- @field P_NOTES string: item note text (do not write to returned pointer, use setNewValue to update)
--- @field P_EXT xyz: xyzchar *extension-specific persistent data
--- @field GUID GUID *: 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
Item.GetSetInfoStringConstants = {
	P_NOTES = "P_NOTES",
	P_EXT = "P_EXT",
	GUID = "GUID",
}

--- Get Set Info String. Wraps GetSetMediaItemInfo_String.
-- Gets/sets an item attribute string.
--- @within ReaScript Wrapped Methods
--- @param param_name string Item.GetSetInfoStringConstants
--- @param info string
--- @param set_value boolean Optional (default false)
--- @return string info
--- @see Item.GetSetInfoStringConstants
function Item:get_set_info_string(param_name, info, set_value)
	local set_value = set_value or false
	local ret_val, info = r.GetSetMediaItemInfo_String(self.pointer, param_name, info, set_value)
	if ret_val then
		return info
	else
		error("Failed to get/set item info string.")
	end
end

--- Is Selected. Wraps IsMediaItemSelected.
--- @within ReaScript Wrapped Methods
--- @return boolean
function Item:is_selected()
	return r.IsMediaItemSelected(self.pointer)
end

--- Descends From Track. Wraps MediaItemDescendsFromTrack.
-- Returns 1 if the track holds the item, 2 if the track is a folder containing the
-- track that holds the item, etc.
--- @within ReaScript Wrapped Methods
--- @return number
function Item:descends_from_track()
	return r.MediaItemDescendsFromTrack(self.pointer, track)
end

--- Midi Set Item Extents. Wraps MIDI_SetItemExtents.
-- Set the start/end positions of a media item that contains a MIDI take.
--- @within ReaScript Wrapped Methods
--- @param start_qn number
--- @param end_qn number
--- @return boolean
function Item:midi_set_item_extents(start_qn, end_qn)
	return r.MIDI_SetItemExtents(self.pointer, start_qn, end_qn)
end

--- Move To Track. Wraps MoveMediaItemToTrack.
-- Returns TRUE if move succeeded.
--- @within ReaScript Wrapped Methods
--- @param dest_track table Track
--- @return boolean
function Item:move_to_track(dest_track)
	return r.MoveMediaItemToTrack(self.pointer, dest_track.pointer)
end

--- Set Item State Chunk. Wraps SetItemStateChunk.
-- Sets the RPPXML state of an item, returns true if successful. Undo flag is a
-- performance/caching hint.
--- @within ReaScript Wrapped Methods
--- @param str string
--- @param is_undo boolean
--- @return boolean
function Item:set_item_state_chunk(str, is_undo)
	return r.SetItemStateChunk(self.pointer, str, is_undo)
end

--- Constants for Item:set_info_value.
--- @within Constants
--- @field B_MUTE boolean: muted (item solo overrides). setting this value will clear C_MUTE_SOLO.
--- @field B_MUTE_ACTUAL boolean: muted (ignores solo). setting this value will not affect C_MUTE_SOLO.
--- @field C_LANEPLAYS string: on fixed lane tracks, 0=this item lane does not play, 1=this item lane plays exclusively, 2=this item lane plays and other lanes also play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-lane track (read-only)
--- @field C_MUTE_SOLO string: solo override (-1=soloed, 0=no override, 1=unsoloed). note that this API does not automatically unsolo other items when soloing (nor clear the unsolos when clearing the last soloed item), it must be done by the caller via action or via this API.
--- @field B_LOOPSRC boolean: loop source
--- @field B_ALLTAKESPLAY boolean: all takes play
--- @field B_UISEL boolean: selected in arrange view
--- @field C_BEATATTACHMODE string: char *item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebaseC_BEATATTACHMODE=1, C_AUTOSTRETCH=1
--- @field C_AUTOSTRETCH string: auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
--- @field C_LOCK string: locked, &1=locked
--- @field D_VOL number: item volume,  0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
--- @field D_POSITION number: item position in seconds
--- @field D_LENGTH number: item length in seconds
--- @field D_SNAPOFFSET number: item snap offset in seconds
--- @field D_FADEINLEN number: item manual fadein length in seconds
--- @field D_FADEOUTLEN number: item manual fadeout length in seconds
--- @field D_FADEINDIR number: item fadein curvature, -1..1
--- @field D_FADEOUTDIR number: item fadeout curvature, -1..1
--- @field D_FADEINLEN_AUTO number: item auto-fadein length in seconds, -1=no auto-fadein
--- @field D_FADEOUTLEN_AUTO number: item auto-fadeout length in seconds, -1=no auto-fadeout
--- @field C_FADEINSHAPE number: fadein shape, 0..6, 0=linear
--- @field C_FADEOUTSHAPE number: fadeout shape, 0..6, 0=linear
--- @field I_GROUPID number: group ID, 0=no group
--- @field I_LASTY number: Y-position (relative to top of track) in pixels (read-only)
--- @field I_LASTH number: height in pixels (read-only)
--- @field I_CUSTOMCOLOR number: custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
--- @field I_CURTAKE number: active take number
--- @field IP_ITEMNUMBER number: item number on this track (read-only, returns the item number directly)
--- @field F_FREEMODE_Y float *: free item positioning or fixed lane Y-position. 0=top of track, 1.0=bottom of track
--- @field F_FREEMODE_H float *: free item positioning or fixed lane height. 0.5=half the track height, 1.0=full track height
--- @field I_FIXEDLANE number: fixed lane of item (fine to call with setNewValue, but returned value is read-only)
--- @field B_FIXEDLANE_HIDDEN boolean: true if displaying only one fixed lane and this item is in a different lane (read-only)
Item.SetInfoValueConstants = {
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

--- Set Info Value. Wraps SetMediaItemInfo_Value.
-- Set media item numerical-value attributes.
--- @within ReaScript Wrapped Methods
--- @param param_name string Item.SetInfoValueConstants
--- @param new_value any
--- @return boolean
--- @see Item.SetInfoValueConstants
function Item:set_info_value(param_name, new_value)
	return r.SetMediaItemInfo_Value(self.pointer, param_name, new_value)
end

--- Set Length in seconds. Wraps SetMediaItemLength.
-- Redraws the screen only if refreshUI == true.
--- @within ReaScript Wrapped Methods
--- @param length number Length in seconds.
--- @param refresh_ui boolean Optional (default true)
--- @return boolean
function Item:set_length_seconds(length, refresh_ui)
	local refresh_ui = refresh_ui or true
	return r.SetMediaItemLength(self.pointer, length, refresh_ui)
end

--- Set Position in seconds. Wraps SetMediaItemPosition.
-- Redraws the screen only if refreshUI == true.
--- @within ReaScript Wrapped Methods
--- @param position number Position in seconds.
--- @param refresh_ui boolean Optional (default true).
--- @return boolean
function Item:set_position_seconds(position, refresh_ui)
	local refresh_ui = refresh_ui or true
	return r.SetMediaItemPosition(self.pointer, position, refresh_ui)
end

--- Set Selected. Wraps SetMediaItemSelected.
--- @within ReaScript Wrapped Methods
--- @param selected boolean
function Item:set_selected(selected)
	return r.SetMediaItemSelected(self.pointer, selected)
end

--- Split. Wraps SplitMediaItem.
-- the original item becomes the left-hand split, the function returns the right-
-- hand split (or NULL if the split failed)
--- @within ReaScript Wrapped Methods
--- @param position number
--- @return Item table
function Item:split(position)
	local Item = require("item")
	local result = r.SplitMediaItem(self.pointer, position)
	return Item:new(result)
end

--- Update Item In Project. Wraps UpdateItemInProject.
--- @within ReaScript Wrapped Methods
function Item:update_item_in_project()
	return r.UpdateItemInProject(self.pointer)
end

--- Get Guid. Wraps BR_GetMediaItemGUID.
-- [BR] Get media item GUID as a string (guidStringOut_sz should be at least 64).
-- To get media item back from GUID string, see BR_GetMediaItemByGUID.
--- @within ReaScript Wrapped Methods
--- @return string guid_string
function Item:get_guid()
	return r.BR_GetMediaItemGUID(self.pointer)
end

--- Get Image Resource. Wraps BR_GetMediaItemImageResource.
-- [BR] Get currently loaded image resource and its flags for a given item. Returns
-- false if there is no image resource set. To set image resource, see
-- BR_SetMediaItemImageResource.
--- @within ReaScript Wrapped Methods
--- @return string image
--- @return number image_flags
function Item:get_image_resource()
	local ret_val, image, image_flags = r.BR_GetMediaItemImageResource(self.pointer)
	if ret_val then
		return image, image_flags
	else
		error("Failed to get image resource.")
	end
end

--- Set Item Edges. Wraps BR_SetItemEdges.
-- [BR] Set item start and end edges' position - returns true in case of any
-- changes
--- @within ReaScript Wrapped Methods
--- @param start_time number
--- @param end_time number
--- @return boolean
function Item:set_item_edges(start_time, end_time)
	return r.BR_SetItemEdges(self.pointer, start_time, end_time)
end

--- Set Image Resource. Wraps BR_SetMediaItemImageResource.
-- [BR] Set image resource and its flags for a given item. To clear current image
-- resource, pass imageIn as "". imageFlags: &1=0: don't display image, &1: center
-- / tile, &3: stretch, &5: full height (REAPER 5.974+). Can also be used to
-- display existing text in empty items unstretched (pass imageIn = "", imageFlags
-- = 0) or stretched (pass imageIn = "". imageFlags = 3). To get image resource,
-- see BR_GetMediaItemImageResource.
--- @within ReaScript Wrapped Methods
--- @param image_in string
--- @param image_flags number
function Item:set_image_resource(image_in, image_flags)
	return r.BR_SetMediaItemImageResource(self.pointer, image_in, image_flags)
end

--- Analyze Peak And Rms. Wraps NF_AnalyzeMediaItemPeakAndRMS.
-- This function combines all other NF_Peak/RMS functions in a single one and
-- additionally returns peak RMS positions. Lua example code here. Note: It's
-- recommended to use this function with ReaScript/Lua as it provides reaper.array
-- objects. If using this function with other scripting languages, you must provide
-- arrays in the reaper.array format.
--- @within ReaScript Wrapped Methods
--- @param win_size number
--- @param peaks userdata
--- @param peaks_pos userdata
--- @param rms userdata
--- @param rms_pos userdata
--- @return boolean
function Item:analyze_peak_and_rms(win_size, peaks, peaks_pos, rms, rms_pos)
	return r.NF_AnalyzeMediaItemPeakAndRMS(self.pointer, win_size, peaks, peaks_pos, rms, rms_pos)
end

--- Delete Take From Item. Wraps NF_DeleteTakeFromItem.
-- Deletes a take from an item. takeIdx is zero-based. Returns true on success.
--- @within ReaScript Wrapped Methods
--- @param take_idx number
--- @return boolean
function Item:delete_take_from_item(take_idx)
	return r.NF_DeleteTakeFromItem(self.pointer, take_idx)
end

--- Get Average Rms. Wraps NF_GetMediaItemAverageRMS.
-- Returns the average overall (non-windowed) dB RMS level of active channels of an
-- audio item active take, post item gain, post take volume envelope, post-fade,
-- pre fader, pre item FX.   Returns -150.0 if MIDI take or empty item.
--- @within ReaScript Wrapped Methods
--- @return number
function Item:get_average_rms()
	return r.NF_GetMediaItemAverageRMS(self.pointer)
end

--- Get Max Peak. Wraps NF_GetMediaItemMaxPeak.
-- Returns the greatest max. peak value in dBFS of all active channels of an audio
-- item active take, post item gain, post take volume envelope, post-fade, pre
-- fader, pre item FX.   Returns -150.0 if MIDI take or empty item.
--- @within ReaScript Wrapped Methods
--- @return number
function Item:get_max_peak()
	return r.NF_GetMediaItemMaxPeak(self.pointer)
end

--- Get Max Peak And Max Peak Pos. Wraps NF_GetMediaItemMaxPeakAndMaxPeakPos.
-- See NF_GetMediaItemMaxPeak, additionally returns maxPeakPos (relative to item
-- position).
--- @within ReaScript Wrapped Methods
--- @return number max_peak_pos
function Item:get_max_peak_and_max_peak_pos()
	local ret_val, max_peak_pos = r.NF_GetMediaItemMaxPeakAndMaxPeakPos(self.pointer)
	if ret_val then
		return max_peak_pos
	else
		error("Failed to get max peak and max peak pos.")
	end
end

--- Get Peak Rms Non Windowed. Wraps NF_GetMediaItemPeakRMS_NonWindowed.
-- Returns the greatest overall (non-windowed) dB RMS peak level of all active
-- channels of an audio item active take, post item gain, post take volume
-- envelope, post-fade, pre fader, pre item FX.   Returns -150.0 if MIDI take or
-- empty item.
--- @within ReaScript Wrapped Methods
--- @return number
function Item:get_peak_rms_non_windowed()
	return r.NF_GetMediaItemPeakRMS_NonWindowed(self.pointer)
end

--- Get Peak Rms Windowed. Wraps NF_GetMediaItemPeakRMS_Windowed.
-- Returns the average dB RMS peak level of all active channels of an audio item
-- active take, post item gain, post take volume envelope, post-fade, pre fader,
-- pre item FX.   Obeys 'Window size for peak RMS' setting in 'SWS: Set RMS
-- analysis/normalize options' for calculation. Returns -150.0 if MIDI take or
-- empty item.
--- @within ReaScript Wrapped Methods
--- @return number
function Item:get_peak_rms_windowed()
	return r.NF_GetMediaItemPeakRMS_Windowed(self.pointer)
end

--- Get Set Source State. Wraps SNM_GetSetSourceState.
-- [S&M] Gets or sets a take source state. Returns false if failed. Use takeidx=-1
-- to get/alter the active take. Note: this function does not use a MediaItem_Take*
-- param in order to manage empty takes (i.e. takes with MediaItem_Take*==NULL),
-- see SNM_GetSetSourceState2.
--- @within ReaScript Wrapped Methods
--- @param take_idx number
--- @param state userdata
--- @param new_value boolean
--- @return boolean
function Item:get_set_source_state(take_idx, state, new_value)
	return r.SNM_GetSetSourceState(self.pointer, take_idx, state, new_value)
end

return Item
