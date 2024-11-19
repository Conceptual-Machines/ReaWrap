-- creates a new take in an item
-- @return MediaItem_Take 
function Item:add_take_to_media_item()
    return r.AddTakeToMediaItem(self.pointer)
end

-- [BR] Get media item GUID as a string (guidStringOut_sz should be at least 64). To get media item back from GUID string, see BR_GetMediaItemByGUID.
-- @return string 
function Item:b_r__get_media_item_g_u_i_d()
    return r.BR_GetMediaItemGUID(self.pointer)
end

-- [BR] Get currently loaded image resource and its flags for a given item. Returns false if there is no image resource set. To set image resource, see BR_SetMediaItemImageResource.
-- @return string, number 
function Item:b_r__get_media_item_image_resource()
    local retval, image, image_flags = r.BR_GetMediaItemImageResource(self.pointer)
    if retval then
        return image, image_flags
    end
end

-- [BR] Set item start and end edges' position - returns true in case of any changes
-- @start_time number
-- @end_time number
-- @return boolean 
function Item:b_r__set_item_edges(start_time, end_time)
    return r.BR_SetItemEdges(self.pointer, start_time, end_time)
end

-- To get image resource, see BR_GetMediaItemImageResource.
-- @image_in string
-- @image_flags integer
function Item:b_r__set_media_item_image_resource(image_in, image_flags)
    return r.BR_SetMediaItemImageResource(self.pointer, image_in, image_flags)
end

-- count the number of takes in the item
-- @return integer 
function Item:count_takes()
    return r.CountTakes(self.pointer)
end

-- get the active take in this item
-- @return MediaItem_Take 
function Item:get_active_take()
    return r.GetActiveTake(self.pointer)
end

-- see GetDisplayedMediaItemColor2.
-- @return integer 
function Item:get_displayed_media_item_color()
    return r.GetDisplayedMediaItemColor(self.pointer)
end

-- Returns the custom take, item, or track color that is used (according to the user preference) to color the media item. The returned color is OS dependent|0x01000000 (i.e. ColorToNative(r,g,b)|0x01000000), so a return of zero means "no color", not black.
-- @take MediaItem_Take
-- @return integer 
function Item:get_displayed_media_item_color2(take)
    return r.GetDisplayedMediaItemColor2(self.pointer, take)
end

-- @return ReaProject 
function Item:get_item_project_context()
    return r.GetItemProjectContext(self.pointer)
end

-- Gets the RPPXML state of an item, returns true if successful. Undo flag is a performance/caching hint.
-- @str string
-- @isundo boolean
-- @return string 
function Item:get_item_state_chunk(str, isundo)
    local retval, str_ = r.GetItemStateChunk(self.pointer, str, isundo)
    if retval then
        return str_
    end
end

-- @parmname string
-- @return number 
function Item:get_media_item_info__value(parmname)
    return r.GetMediaItemInfo_Value(self.pointer, parmname)
end

-- @return integer 
function Item:get_media_item_num_takes()
    return r.GetMediaItemNumTakes(self.pointer)
end

-- @tk integer
-- @return MediaItem_Take 
function Item:get_media_item_take(tk)
    return r.GetMediaItemTake(self.pointer, tk)
end

-- @return MediaTrack 
function Item:get_media_item_track()
    return r.GetMediaItemTrack(self.pointer)
end

-- Get parent track of media item
-- @return MediaTrack 
function Item:get_media_track()
    return r.GetMediaItem_Track(self.pointer)
end

-- deprecated -- see SetItemStateChunk, GetItemStateChunk
-- @str string
-- @return string 
function Item:get_set_item_state(str)
    local retval, str_ = r.GetSetItemState(self.pointer, str)
    if retval then
        return str_
    end
end

-- deprecated -- see SetItemStateChunk, GetItemStateChunk
-- @str string
-- @isundo boolean
-- @return string 
function Item:get_set_item_state2(str, isundo)
    local retval, str_ = r.GetSetItemState2(self.pointer, str, isundo)
    if retval then
        return str_
    end
end

-- @parmname string
-- @string_need_big string
-- @set_new_value boolean
-- @return string 
function Item:get_set_media_item_info__string(parmname, string_need_big, set_new_value)
    local retval, string_need_big_ = r.GetSetMediaItemInfo_String(self.pointer, parmname, string_need_big, set_new_value)
    if retval then
        return string_need_big_
    end
end

-- get a take from an item by take count (zero-based)
-- @takeidx integer
-- @return MediaItem_Take 
function Item:get_take(takeidx)
    return r.GetTake(self.pointer, takeidx)
end

-- @return boolean 
function Item:is_media_item_selected()
    return r.IsMediaItemSelected(self.pointer)
end

-- Set the start/end positions of a media item that contains a MIDI take.
-- @start_q_n number
-- @end_q_n number
-- @return boolean 
function Item:m_i_d_i__set_item_extents(start_q_n, end_q_n)
    return r.MIDI_SetItemExtents(self.pointer, start_q_n, end_q_n)
end

-- Returns 1 if the track holds the item, 2 if the track is a folder containing the track that holds the item, etc.
-- @track MediaTrack
-- @return integer 
function Item:media_item_descends_from_track(track)
    return r.MediaItemDescendsFromTrack(self.pointer, track)
end

-- returns TRUE if move succeeded
-- @desttr MediaTrack
-- @return boolean 
function Item:move_media_item_to_track(desttr)
    return r.MoveMediaItemToTrack(self.pointer, desttr)
end

-- This function combines all other NF_Peak/RMS functions in a single one and additionally returns peak RMS positions. Lua example code here. Note: It's recommended to use this function with ReaScript/Lua as it provides reaper.array objects. If using this function with other scripting languages, you must provide arrays in the reaper.array format.
-- @window_size number
-- @reaper_array_peaks identifier
-- @reaper_array_peakpositions identifier
-- @reaper_array__r_m_ss identifier
-- @reaper_array__r_m_spositions identifier
-- @return boolean 
function Item:n_f__analyze_media_item_peak_and_r_m_s(window_size, reaper_array_peaks, reaper_array_peakpositions, reaper_array__r_m_ss, reaper_array__r_m_spositions)
    return r.NF_AnalyzeMediaItemPeakAndRMS(self.pointer, window_size, reaper_array_peaks, reaper_array_peakpositions, reaper_array__r_m_ss, reaper_array__r_m_spositions)
end

--  Returns -150.0 if MIDI take or empty item.
-- @return number 
function Item:n_f__get_media_item_average_r_m_s()
    return r.NF_GetMediaItemAverageRMS(self.pointer)
end

--  Returns -150.0 if MIDI take or empty item.
-- @return number 
function Item:n_f__get_media_item_max_peak()
    return r.NF_GetMediaItemMaxPeak(self.pointer)
end

-- See NF_GetMediaItemMaxPeak, additionally returns maxPeakPos (relative to item position).
-- @return number 
function Item:n_f__get_media_item_max_peak_and_max_peak_pos()
    local retval, max_peak_pos = r.NF_GetMediaItemMaxPeakAndMaxPeakPos(self.pointer)
    if retval then
        return max_peak_pos
    end
end

--  Returns -150.0 if MIDI take or empty item.
-- @return number 
function Item:n_f__get_media_item_peak_r_m_s__non_windowed()
    return r.NF_GetMediaItemPeakRMS_NonWindowed(self.pointer)
end

--  Obeys 'Window size for peak RMS' setting in 'SWS: Set RMS analysis/normalize options' for calculation. Returns -150.0 if MIDI take or empty item.
-- @return number 
function Item:n_f__get_media_item_peak_r_m_s__windowed()
    return r.NF_GetMediaItemPeakRMS_Windowed(self.pointer)
end

-- See BR_TrackFX_GetFXModuleName. fx: counted consecutively across all takes (zero-based).
-- @fx integer
-- @return string 
function Item:n_f__take_f_x__get_f_x_module_name(fx)
    local retval, name = r.NF_TakeFX_GetFXModuleName(self.pointer, fx)
    if retval then
        return name
    end
end

-- Note: this function does not use a MediaItem_Take* param in order to manage empty takes (i.e. takes with MediaItem_Take*==NULL), see SNM_GetSetSourceState2.
-- @takeidx integer
-- @state WDL_FastString
-- @item MediaItem
-- @setnewvalue boolean
-- @return boolean 
function Item:s_n_m__get_set_source_state(takeidx, state, item, setnewvalue)
    return r.SNM_GetSetSourceState(self.pointer, takeidx, state, item, setnewvalue)
end

-- Sets the RPPXML state of an item, returns true if successful. Undo flag is a performance/caching hint.
-- @str string
-- @isundo boolean
-- @return boolean 
function Item:set_item_state_chunk(str, isundo)
    return r.SetItemStateChunk(self.pointer, str, isundo)
end

-- @parmname string
-- @newvalue number
-- @return boolean 
function Item:set_media_item_info__value(parmname, newvalue)
    return r.SetMediaItemInfo_Value(self.pointer, parmname, newvalue)
end

-- See UpdateArrange().
-- @length number
-- @refresh_u_i boolean
-- @return boolean 
function Item:set_media_item_length(length, refresh_u_i)
    return r.SetMediaItemLength(self.pointer, length, refresh_u_i)
end

-- See UpdateArrange().
-- @position number
-- @refresh_u_i boolean
-- @return boolean 
function Item:set_media_item_position(position, refresh_u_i)
    return r.SetMediaItemPosition(self.pointer, position, refresh_u_i)
end

-- @selected boolean
function Item:set_media_item_selected(selected)
    return r.SetMediaItemSelected(self.pointer, selected)
end

-- the original item becomes the left-hand split, the function returns the right-hand split (or NULL if the split failed)
-- @position number
-- @return MediaItem 
function Item:split_media_item(position)
    return r.SplitMediaItem(self.pointer, position)
end

-- [ULT] Deprecated, see GetSetMediaItemInfo_String (v5.95+). Get item notes.
-- @return string 
function Item:u_l_t__get_media_item_note()
    return r.ULT_GetMediaItemNote(self.pointer)
end

-- [ULT] Deprecated, see GetSetMediaItemInfo_String (v5.95+). Set item notes.
-- @note string
function Item:u_l_t__set_media_item_note(note)
    return r.ULT_SetMediaItemNote(self.pointer, note)
end

function Item:update_item_in_project()
    return r.UpdateItemInProject(self.pointer)
end

