-- creates a new media item.
-- @return MediaItem 
function Track:add_media_item_to_track()
    return r.AddMediaItemToTrack(self.pointer)
end

-- [BR] Get media track freeze count (if track isn't frozen at all, returns 0).
-- @return integer 
function Track:b_r__get_media_track_freeze_count()
    return r.BR_GetMediaTrackFreezeCount(self.pointer)
end

-- [BR] Deprecated, see GetSetMediaTrackInfo_String (v5.95+). Get media track GUID as a string (guidStringOut_sz should be at least 64). To get media track back from GUID string, see BR_GetMediaTrackByGUID.
-- @return string 
function Track:b_r__get_media_track_g_u_i_d()
    return r.BR_GetMediaTrackGUID(self.pointer)
end

-- [BR] Deprecated, see GetSetMediaTrackInfo (REAPER v5.02+). Get media track layouts for MCP and TCP. Empty string ("") means that layout is set to the default layout. To set media track layouts, see BR_SetMediaTrackLayouts.
-- @return string, string 
function Track:b_r__get_media_track_layouts()
    return r.BR_GetMediaTrackLayouts(self.pointer)
end

-- Note: To get or set other send attributes, see BR_GetSetTrackSendInfo and BR_GetMediaTrackSendInfo_Track.
-- @category integer
-- @sendidx integer
-- @envelope_type integer
-- @return TrackEnvelope 
function Track:b_r__get_media_track_send_info__envelope(category, sendidx, envelope_type)
    return r.BR_GetMediaTrackSendInfo_Envelope(self.pointer, category, sendidx, envelope_type)
end

-- Note: To get or set other send attributes, see BR_GetSetTrackSendInfo and BR_GetMediaTrackSendInfo_Envelope.
-- @category integer
-- @sendidx integer
-- @track_type integer
-- @return MediaTrack 
function Track:b_r__get_media_track_send_info__track(category, sendidx, track_type)
    return r.BR_GetMediaTrackSendInfo_Track(self.pointer, category, sendidx, track_type)
end

-- Note: To get or set other send attributes, see BR_GetMediaTrackSendInfo_Envelope and BR_GetMediaTrackSendInfo_Track.
-- @category integer
-- @sendidx integer
-- @parmname string
-- @set_new_value boolean
-- @new_value number
-- @return number 
function Track:b_r__get_set_track_send_info(category, sendidx, parmname, set_new_value, new_value)
    return r.BR_GetSetTrackSendInfo(self.pointer, category, sendidx, parmname, set_new_value, new_value)
end

-- To get media track layouts, see BR_GetMediaTrackLayouts.
-- @mcp_layout_name_in string
-- @tcp_layout_name_in string
-- @return boolean 
function Track:b_r__set_media_track_layouts(mcp_layout_name_in, tcp_layout_name_in)
    return r.BR_SetMediaTrackLayouts(self.pointer, mcp_layout_name_in, tcp_layout_name_in)
end

-- [BR] Get the exact name (like effect.dll, effect.vst3, etc...) of an FX.
-- @fx integer
-- @return string 
function Track:b_r__track_f_x__get_f_x_module_name(fx)
    local retval, name = r.BR_TrackFX_GetFXModuleName(self.pointer, fx)
    if retval then
        return name
    end
end

-- Return a handle to the given track FX chain window.
-- @return FxChain 
function Track:c_f__get_track_f_x_chain()
    return r.CF_GetTrackFXChain(self.pointer)
end

-- Set which track effect is active in the track's FX chain. The FX chain window does not have to be open.
-- @index integer
-- @return boolean 
function Track:c_f__select_track_f_x(index)
    return r.CF_SelectTrackFX(self.pointer, index)
end

-- @is_pan integer
-- @return boolean 
function Track:c_surf__get_touch_state(is_pan)
    return r.CSurf_GetTouchState(self.pointer, is_pan)
end

-- @en integer
-- @return boolean 
function Track:c_surf__on_f_x_change(en)
    return r.CSurf_OnFXChange(self.pointer, en)
end

-- @monitor integer
-- @return integer 
function Track:c_surf__on_input_monitor_change(monitor)
    return r.CSurf_OnInputMonitorChange(self.pointer, monitor)
end

-- @monitor integer
-- @allowgang boolean
-- @return integer 
function Track:c_surf__on_input_monitor_change_ex(monitor, allowgang)
    return r.CSurf_OnInputMonitorChangeEx(self.pointer, monitor, allowgang)
end

-- @mute integer
-- @return boolean 
function Track:c_surf__on_mute_change(mute)
    return r.CSurf_OnMuteChange(self.pointer, mute)
end

-- @mute integer
-- @allowgang boolean
-- @return boolean 
function Track:c_surf__on_mute_change_ex(mute, allowgang)
    return r.CSurf_OnMuteChangeEx(self.pointer, mute, allowgang)
end

-- @pan number
-- @relative boolean
-- @return number 
function Track:c_surf__on_pan_change(pan, relative)
    return r.CSurf_OnPanChange(self.pointer, pan, relative)
end

-- @pan number
-- @relative boolean
-- @allow_gang boolean
-- @return number 
function Track:c_surf__on_pan_change_ex(pan, relative, allow_gang)
    return r.CSurf_OnPanChangeEx(self.pointer, pan, relative, allow_gang)
end

-- @recarm integer
-- @return boolean 
function Track:c_surf__on_rec_arm_change(recarm)
    return r.CSurf_OnRecArmChange(self.pointer, recarm)
end

-- @recarm integer
-- @allowgang boolean
-- @return boolean 
function Track:c_surf__on_rec_arm_change_ex(recarm, allowgang)
    return r.CSurf_OnRecArmChangeEx(self.pointer, recarm, allowgang)
end

-- @recv_index integer
-- @pan number
-- @relative boolean
-- @return number 
function Track:c_surf__on_recv_pan_change(recv_index, pan, relative)
    return r.CSurf_OnRecvPanChange(self.pointer, recv_index, pan, relative)
end

-- @recv_index integer
-- @volume number
-- @relative boolean
-- @return number 
function Track:c_surf__on_recv_volume_change(recv_index, volume, relative)
    return r.CSurf_OnRecvVolumeChange(self.pointer, recv_index, volume, relative)
end

-- @selected integer
-- @return boolean 
function Track:c_surf__on_selected_change(selected)
    return r.CSurf_OnSelectedChange(self.pointer, selected)
end

-- @send_index integer
-- @pan number
-- @relative boolean
-- @return number 
function Track:c_surf__on_send_pan_change(send_index, pan, relative)
    return r.CSurf_OnSendPanChange(self.pointer, send_index, pan, relative)
end

-- @send_index integer
-- @volume number
-- @relative boolean
-- @return number 
function Track:c_surf__on_send_volume_change(send_index, volume, relative)
    return r.CSurf_OnSendVolumeChange(self.pointer, send_index, volume, relative)
end

-- @solo integer
-- @return boolean 
function Track:c_surf__on_solo_change(solo)
    return r.CSurf_OnSoloChange(self.pointer, solo)
end

-- @solo integer
-- @allowgang boolean
-- @return boolean 
function Track:c_surf__on_solo_change_ex(solo, allowgang)
    return r.CSurf_OnSoloChangeEx(self.pointer, solo, allowgang)
end

function Track:c_surf__on_track_selection()
    return r.CSurf_OnTrackSelection(self.pointer)
end

-- @volume number
-- @relative boolean
-- @return number 
function Track:c_surf__on_volume_change(volume, relative)
    return r.CSurf_OnVolumeChange(self.pointer, volume, relative)
end

-- @volume number
-- @relative boolean
-- @allow_gang boolean
-- @return number 
function Track:c_surf__on_volume_change_ex(volume, relative, allow_gang)
    return r.CSurf_OnVolumeChangeEx(self.pointer, volume, relative, allow_gang)
end

-- @width number
-- @relative boolean
-- @return number 
function Track:c_surf__on_width_change(width, relative)
    return r.CSurf_OnWidthChange(self.pointer, width, relative)
end

-- @width number
-- @relative boolean
-- @allow_gang boolean
-- @return number 
function Track:c_surf__on_width_change_ex(width, relative, allow_gang)
    return r.CSurf_OnWidthChangeEx(self.pointer, width, relative, allow_gang)
end

-- @mute boolean
-- @ignoresurf IReaperControlSurface
function Track:c_surf__set_surface_mute(mute, ignoresurf)
    return r.CSurf_SetSurfaceMute(self.pointer, mute, ignoresurf)
end

-- @pan number
-- @ignoresurf IReaperControlSurface
function Track:c_surf__set_surface_pan(pan, ignoresurf)
    return r.CSurf_SetSurfacePan(self.pointer, pan, ignoresurf)
end

-- @recarm boolean
-- @ignoresurf IReaperControlSurface
function Track:c_surf__set_surface_rec_arm(recarm, ignoresurf)
    return r.CSurf_SetSurfaceRecArm(self.pointer, recarm, ignoresurf)
end

-- @selected boolean
-- @ignoresurf IReaperControlSurface
function Track:c_surf__set_surface_selected(selected, ignoresurf)
    return r.CSurf_SetSurfaceSelected(self.pointer, selected, ignoresurf)
end

-- @solo boolean
-- @ignoresurf IReaperControlSurface
function Track:c_surf__set_surface_solo(solo, ignoresurf)
    return r.CSurf_SetSurfaceSolo(self.pointer, solo, ignoresurf)
end

-- @volume number
-- @ignoresurf IReaperControlSurface
function Track:c_surf__set_surface_volume(volume, ignoresurf)
    return r.CSurf_SetSurfaceVolume(self.pointer, volume, ignoresurf)
end

-- @mcp_view boolean
-- @return integer 
function Track:c_surf__track_to_i_d(mcp_view)
    return r.CSurf_TrackToID(self.pointer, mcp_view)
end

-- see GetTrackEnvelope
-- @return integer 
function Track:count_track_envelopes()
    return r.CountTrackEnvelopes(self.pointer)
end

-- count the number of items in the track
-- @return integer 
function Track:count_track_media_items()
    return r.CountTrackMediaItems(self.pointer)
end

-- Create a new MIDI media item, containing no MIDI events. Time is in seconds unless qn is set.
-- @starttime number
-- @endtime number
-- @qn_in boolean
-- @return MediaItem 
function Track:create_new_m_i_d_i_item_in_proj(starttime, endtime, qn_in)
    return r.CreateNewMIDIItemInProj(self.pointer, starttime, endtime, qn_in)
end

-- Create an audio accessor object for this track. Must only call from the main thread. See CreateTakeAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
-- @return AudioAccessor 
function Track:create_track_audio_accessor()
    return r.CreateTrackAudioAccessor(self.pointer)
end

-- Create a send/receive (desttrInOptional!=NULL), or a hardware output (desttrInOptional==NULL) with default properties, return >=0 on success (== new send/receive index). See RemoveTrackSend, GetSetTrackSendInfo, GetTrackSendInfo_Value, SetTrackSendInfo_Value.
-- @desttr_in MediaTrack
-- @return integer 
function Track:create_track_send(desttr_in)
    return r.CreateTrackSend(self.pointer, desttr_in)
end

-- deletes a track
function Track:delete_track()
    return r.DeleteTrack(self.pointer)
end

-- @it MediaItem
-- @return boolean 
function Track:delete_track_media_item(it)
    return r.DeleteTrackMediaItem(self.pointer, it)
end

-- Returns the FX parameter envelope. If the envelope does not exist and create=true, the envelope will be created.
-- @fxindex integer
-- @parameterindex integer
-- @create boolean
-- @return TrackEnvelope 
function Track:get_f_x_envelope(fxindex, parameterindex, create)
    return r.GetFXEnvelope(self.pointer, fxindex, parameterindex, create)
end

-- @parmname string
-- @return number 
function Track:get_media_track_info__value(parmname)
    return r.GetMediaTrackInfo_Value(self.pointer, parmname)
end

-- @return MediaTrack 
function Track:get_parent_track()
    return r.GetParentTrack(self.pointer)
end

-- Returns meter hold state, in dB*0.01 (0 = +0dB, -0.01 = -1dB, 0.02 = +2dB, etc). If clear is set, clears the meter hold. If master track and channel==1024 or channel==1025, returns/clears RMS maximum state.
-- @channel integer
-- @clear boolean
-- @return number 
function Track:get_peak_hold_d_b(channel, clear)
    return r.Track_GetPeakHoldDB(self.pointer, channel, clear)
end

-- Returns peak meter value (1.0=+0dB, 0.0=-inf) for channel. If master track and channel==1024 or channel==1025, returns RMS meter value. if master track and channel==2048 or channel=2049, returns RMS meter hold value.
-- @channel integer
-- @return number 
function Track:get_peak_info(channel)
    return r.Track_GetPeakInfo(self.pointer, channel)
end

-- @parmname string
-- @string_need_big string
-- @set_new_value boolean
-- @return string 
function Track:get_set_media_track_info__string(parmname, string_need_big, set_new_value)
    local retval, string_need_big_ = r.GetSetMediaTrackInfo_String(self.pointer, parmname, string_need_big, set_new_value)
    if retval then
        return string_need_big_
    end
end

-- @groupname string
-- @setmask integer
-- @setvalue integer
-- @return integer 
function Track:get_set_track_group_membership(groupname, setmask, setvalue)
    return r.GetSetTrackGroupMembership(self.pointer, groupname, setmask, setvalue)
end

-- @groupname string
-- @setmask integer
-- @setvalue integer
-- @return integer 
function Track:get_set_track_group_membership_high(groupname, setmask, setvalue)
    return r.GetSetTrackGroupMembershipHigh(self.pointer, groupname, setmask, setvalue)
end

-- @category integer
-- @sendidx integer
-- @parmname string
-- @string_need_big string
-- @set_new_value boolean
-- @return string 
function Track:get_set_track_send_info__string(category, sendidx, parmname, string_need_big, set_new_value)
    local retval, string_need_big_ = r.GetSetTrackSendInfo_String(self.pointer, category, sendidx, parmname, string_need_big, set_new_value)
    if retval then
        return string_need_big_
    end
end

-- deprecated -- see SetTrackStateChunk, GetTrackStateChunk
-- @str string
-- @return string 
function Track:get_set_track_state(str)
    local retval, str_ = r.GetSetTrackState(self.pointer, str)
    if retval then
        return str_
    end
end

-- deprecated -- see SetTrackStateChunk, GetTrackStateChunk
-- @str string
-- @isundo boolean
-- @return string 
function Track:get_set_track_state2(str, isundo)
    local retval, str_ = r.GetSetTrackState2(self.pointer, str, isundo)
    if retval then
        return str_
    end
end

-- return the track mode, regardless of global override
-- @return integer 
function Track:get_track_automation_mode()
    return r.GetTrackAutomationMode(self.pointer)
end

-- Returns the track custom color as OS dependent color|0x100000 (i.e. ColorToNative(r,g,b)|0x100000). Black is returned as 0x01000000, no color setting is returned as 0.
-- @return integer 
function Track:get_track_color()
    return r.GetTrackColor(self.pointer)
end

-- @return integer 
function Track:get_track_depth()
    return r.GetTrackDepth(self.pointer)
end

-- @envidx integer
-- @return TrackEnvelope 
function Track:get_track_envelope(envidx)
    return r.GetTrackEnvelope(self.pointer, envidx)
end

-- @cfgchunkname_or_guid string
-- @return TrackEnvelope 
function Track:get_track_envelope_by_chunk_name(cfgchunkname_or_guid)
    return r.GetTrackEnvelopeByChunkName(self.pointer, cfgchunkname_or_guid)
end

-- @envname string
-- @return TrackEnvelope 
function Track:get_track_envelope_by_name(envname)
    return r.GetTrackEnvelopeByName(self.pointer, envname)
end

-- @return string 
function Track:get_track_g_u_i_d()
    return r.GetTrackGUID(self.pointer)
end

-- Get all MIDI lyrics on the track. Lyrics will be returned as one string with tabs between each word. flag&1: double tabs at the end of each measure and triple tabs when skipping measures, flag&2: each lyric is preceded by its beat position in the project (example with flag=2: "1.1.2\tLyric for measure 1 beat 2\t.1.1\tLyric for measure 2 beat 1	"). See SetTrackMIDILyrics
-- @flag integer
-- @buf_want string
-- @return string 
function Track:get_track_m_i_d_i_lyrics(flag, buf_want)
    local retval, buf_want_ = r.GetTrackMIDILyrics(self.pointer, flag, buf_want)
    if retval then
        return buf_want_
    end
end

-- @itemidx integer
-- @return MediaItem 
function Track:get_track_media_item(itemidx)
    return r.GetTrackMediaItem(self.pointer, itemidx)
end

-- Returns "MASTER" for master track, "Track N" if track has no name.
-- @return string 
function Track:get_track_name()
    local retval, buf = r.GetTrackName(self.pointer)
    if retval then
        return buf
    end
end

-- @return integer 
function Track:get_track_num_media_items()
    return r.GetTrackNumMediaItems(self.pointer)
end

-- returns number of sends/receives/hardware outputs - category is <0 for receives, 0=sends, >0 for hardware outputs
-- @category integer
-- @return integer 
function Track:get_track_num_sends(category)
    return r.GetTrackNumSends(self.pointer, category)
end

-- See GetTrackSendName.
-- @recv_index integer
-- @buf string
-- @return string 
function Track:get_track_receive_name(recv_index, buf)
    local retval, buf_ = r.GetTrackReceiveName(self.pointer, recv_index, buf)
    if retval then
        return buf_
    end
end

-- See GetTrackSendUIMute.
-- @recv_index integer
-- @return boolean 
function Track:get_track_receive_u_i_mute(recv_index)
    local retval, mute = r.GetTrackReceiveUIMute(self.pointer, recv_index)
    if retval then
        return mute
    end
end

-- See GetTrackSendUIVolPan.
-- @recv_index integer
-- @return number, number 
function Track:get_track_receive_u_i_vol_pan(recv_index)
    local retval, volume, pan = r.GetTrackReceiveUIVolPan(self.pointer, recv_index)
    if retval then
        return volume, pan
    end
end

-- See CreateTrackSend, RemoveTrackSend, GetTrackNumSends.
-- @category integer
-- @sendidx integer
-- @parmname string
-- @return number 
function Track:get_track_send_info__value(category, sendidx, parmname)
    return r.GetTrackSendInfo_Value(self.pointer, category, sendidx, parmname)
end

-- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveName.
-- @send_index integer
-- @buf string
-- @return string 
function Track:get_track_send_name(send_index, buf)
    local retval, buf_ = r.GetTrackSendName(self.pointer, send_index, buf)
    if retval then
        return buf_
    end
end

-- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveUIMute.
-- @send_index integer
-- @return boolean 
function Track:get_track_send_u_i_mute(send_index)
    local retval, mute = r.GetTrackSendUIMute(self.pointer, send_index)
    if retval then
        return mute
    end
end

-- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveUIVolPan.
-- @send_index integer
-- @return number, number 
function Track:get_track_send_u_i_vol_pan(send_index)
    local retval, volume, pan = r.GetTrackSendUIVolPan(self.pointer, send_index)
    if retval then
        return volume, pan
    end
end

-- &1024=hide from MCP
-- @return number 
function Track:get_track_state()
    local retval, flags = r.GetTrackState(self.pointer)
    if retval then
        return flags
    end
end

-- Gets the RPPXML state of a track, returns true if successful. Undo flag is a performance/caching hint.
-- @str string
-- @isundo boolean
-- @return string 
function Track:get_track_state_chunk(str, isundo)
    local retval, str_ = r.GetTrackStateChunk(self.pointer, str, isundo)
    if retval then
        return str_
    end
end

-- @return boolean 
function Track:get_track_u_i_mute()
    local retval, mute = r.GetTrackUIMute(self.pointer)
    if retval then
        return mute
    end
end

-- @return number, number, number 
function Track:get_track_u_i_pan()
    local retval, pan1, pan2, panmode = r.GetTrackUIPan(self.pointer)
    if retval then
        return pan1, pan2, panmode
    end
end

-- @return number, number 
function Track:get_track_u_i_vol_pan()
    local retval, volume, pan = r.GetTrackUIVolPan(self.pointer)
    if retval then
        return volume, pan
    end
end

-- @return boolean 
function Track:is_track_selected()
    return r.IsTrackSelected(self.pointer)
end

-- If mixer==true, returns true if the track is visible in the mixer.  If mixer==false, returns true if the track is visible in the track control panel.
-- @mixer boolean
-- @return boolean 
function Track:is_track_visible(mixer)
    return r.IsTrackVisible(self.pointer, mixer)
end

-- Get a string that only changes when the MIDI data changes. If notesonly==true, then the string changes only when the MIDI notes change. See MIDI_GetHash
-- @notesonly boolean
-- @hash string
-- @return string 
function Track:m_i_d_i__get_track_hash(notesonly, hash)
    local retval, hash_ = r.MIDI_GetTrackHash(self.pointer, notesonly, hash)
    if retval then
        return hash_
    end
end

-- If track is supplied, item is ignored
-- @item MediaItem
function Track:mark_track_items_dirty(item)
    return r.MarkTrackItemsDirty(self.pointer, item)
end

-- @return string 
function Track:n_f__get_s_w_s_track_notes()
    return r.NF_GetSWSTrackNotes(self.pointer)
end

-- @str string
function Track:n_f__set_s_w_s_track_notes(str)
    return r.NF_SetSWSTrackNotes(self.pointer, str)
end

-- Remove a send/receive/hardware output, return true on success. category is <0 for receives, 0=sends, >0 for hardware outputs. See CreateTrackSend, GetSetTrackSendInfo, GetTrackSendInfo_Value, SetTrackSendInfo_Value, GetTrackNumSends.
-- @category integer
-- @sendidx integer
-- @return boolean 
function Track:remove_track_send(category, sendidx)
    return r.RemoveTrackSend(self.pointer, category, sendidx)
end

-- Note: obeys default sends preferences, supports frozen tracks, etc..
-- @dest MediaTrack
-- @type integer
-- @return boolean 
function Track:s_n_m__add_receive(dest, type)
    return r.SNM_AddReceive(self.pointer, dest, type)
end

-- [S&M] Add an FX parameter knob in the TCP. Returns false if nothing updated (invalid parameters, knob already present, etc..)
-- @fx_id integer
-- @prm_id integer
-- @return boolean 
function Track:s_n_m__add_t_c_p_f_x_parm(fx_id, prm_id)
    return r.SNM_AddTCPFXParm(self.pointer, fx_id, prm_id)
end

-- fxId: fx index in chain or -1 for the selected fx. what: 0 to remove, -1 to move fx up in chain, 1 to move fx down in chain.
-- @fx_id integer
-- @what integer
-- @return boolean 
function Track:s_n_m__move_or_remove_track_f_x(fx_id, what)
    return r.SNM_MoveOrRemoveTrackFX(self.pointer, fx_id, what)
end

-- [S&M] Deprecated, see RemoveTrackSend (v5.15pre1+). Removes a receive. Returns false if nothing updated.
-- @rcvidx integer
-- @return boolean 
function Track:s_n_m__remove_receive(rcvidx)
    return r.SNM_RemoveReceive(self.pointer, rcvidx)
end

-- [S&M] Removes all receives from srctr. Returns false if nothing updated.
-- @srctr MediaTrack
-- @return boolean 
function Track:s_n_m__remove_receives_from(srctr)
    return r.SNM_RemoveReceivesFrom(self.pointer, srctr)
end

-- @parmname string
-- @newvalue number
-- @return boolean 
function Track:set_media_track_info__value(parmname, newvalue)
    return r.SetMediaTrackInfo_Value(self.pointer, parmname, newvalue)
end

-- Scroll the mixer so that leftmosttrack is the leftmost visible track. Returns the leftmost track after scrolling, which may be different from the passed-in track if there are not enough tracks to its right.
-- @return MediaTrack 
function Track:set_mixer_scroll()
    return r.SetMixerScroll(self.pointer)
end

-- Set exactly one track selected, deselect all others
function Track:set_only_track_selected()
    return r.SetOnlyTrackSelected(self.pointer)
end

-- @mode integer
function Track:set_track_automation_mode(mode)
    return r.SetTrackAutomationMode(self.pointer, mode)
end

-- Set the custom track color, color is OS dependent (i.e. ColorToNative(r,g,b).
-- @color integer
function Track:set_track_color(color)
    return r.SetTrackColor(self.pointer, color)
end

-- Set all MIDI lyrics on the track. Lyrics will be stuffed into any MIDI items found in range. Flag is unused at present. str is passed in as beat position, tab, text, tab (example with flag=2: "1.1.2\tLyric for measure 1 beat 2\t.1.1\tLyric for measure 2 beat 1	"). See GetTrackMIDILyrics
-- @flag integer
-- @str string
-- @return boolean 
function Track:set_track_m_i_d_i_lyrics(flag, str)
    return r.SetTrackMIDILyrics(self.pointer, flag, str)
end

-- @selected boolean
function Track:set_track_selected(selected)
    return r.SetTrackSelected(self.pointer, selected)
end

-- See CreateTrackSend, RemoveTrackSend, GetTrackNumSends.
-- @category integer
-- @sendidx integer
-- @parmname string
-- @newvalue number
-- @return boolean 
function Track:set_track_send_info__value(category, sendidx, parmname, newvalue)
    return r.SetTrackSendInfo_Value(self.pointer, category, sendidx, parmname, newvalue)
end

-- send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1 for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
-- @send_idx integer
-- @pan number
-- @isend integer
-- @return boolean 
function Track:set_track_send_u_i_pan(send_idx, pan, isend)
    return r.SetTrackSendUIPan(self.pointer, send_idx, pan, isend)
end

-- send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1 for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
-- @send_idx integer
-- @vol number
-- @isend integer
-- @return boolean 
function Track:set_track_send_u_i_vol(send_idx, vol, isend)
    return r.SetTrackSendUIVol(self.pointer, send_idx, vol, isend)
end

-- Sets the RPPXML state of a track, returns true if successful. Undo flag is a performance/caching hint.
-- @str string
-- @isundo boolean
-- @return boolean 
function Track:set_track_state_chunk(str, isundo)
    return r.SetTrackStateChunk(self.pointer, str, isundo)
end

-- send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends.
-- @send_idx integer
-- @return boolean 
function Track:toggle_track_send_u_i_mute(send_idx)
    return r.ToggleTrackSendUIMute(self.pointer, send_idx)
end

-- Adds or queries the position of a named FX from the track FX chain (recFX=false) or record input FX/monitoring FX (recFX=true, monitoring FX are on master track). Specify a negative value for instantiate to always create a new effect, 0 to only query the first instance of an effect, or a positive value to add an instance if one is not found. If instantiate is <= -1000, it is used for the insertion position (-1000 is first item in chain, -1001 is second, etc). fxname can have prefix to specify type: VST3:,VST2:,VST:,AU:,JS:, or DX:, or FXADD: which adds selected items from the currently-open FX browser, FXADD:2 to limit to 2 FX added, or FXADD:2e to only succeed if exactly 2 FX are selected. Returns -1 on failure or the new position in chain on success.
-- @fxname string
-- @rec_f_x boolean
-- @instantiate integer
-- @return integer 
function Track:track_f_x__add_by_name(fxname, rec_f_x, instantiate)
    return r.TrackFX_AddByName(self.pointer, fxname, rec_f_x, instantiate)
end

-- Copies (or moves) FX from src_track to dest_take. src_fx can have 0x1000000 set to reference input FX.
-- @src_fx integer
-- @dest_take MediaItem_Take
-- @dest_fx integer
-- @is_move boolean
function Track:track_f_x__copy_to_take(src_fx, dest_take, dest_fx, is_move)
    return r.TrackFX_CopyToTake(self.pointer, src_fx, dest_take, dest_fx, is_move)
end

-- Copies (or moves) FX from src_track to dest_track. Can be used with src_track=dest_track to reorder, FX indices have 0x1000000 set to reference input FX.
-- @src_fx integer
-- @dest_track MediaTrack
-- @dest_fx integer
-- @is_move boolean
function Track:track_f_x__copy_to_track(src_fx, dest_track, dest_fx, is_move)
    return r.TrackFX_CopyToTrack(self.pointer, src_fx, dest_track, dest_fx, is_move)
end

-- Remove a FX from track chain (returns true on success)
-- @fx integer
-- @return boolean 
function Track:track_f_x__delete(fx)
    return r.TrackFX_Delete(self.pointer, fx)
end

-- @fx integer
-- @param integer
-- @return boolean 
function Track:track_f_x__end_param_edit(fx, param)
    return r.TrackFX_EndParamEdit(self.pointer, fx, param)
end

-- Note: only works with FX that support Cockos VST extensions.
-- @fx integer
-- @param integer
-- @val number
-- @buf string
-- @return string 
function Track:track_f_x__format_param_value(fx, param, val, buf)
    local retval, buf_ = r.TrackFX_FormatParamValue(self.pointer, fx, param, val, buf)
    if retval then
        return buf_
    end
end

-- Note: only works with FX that support Cockos VST extensions.
-- @fx integer
-- @param integer
-- @value number
-- @buf string
-- @return string 
function Track:track_f_x__format_param_value_normalized(fx, param, value, buf)
    local retval, buf_ = r.TrackFX_FormatParamValueNormalized(self.pointer, fx, param, value, buf)
    if retval then
        return buf_
    end
end

-- Get the index of the first track FX insert that matches fxname. If the FX is not in the chain and instantiate is true, it will be inserted. See TrackFX_GetInstrument, TrackFX_GetEQ. Deprecated in favor of TrackFX_AddByName.
-- @fxname string
-- @instantiate boolean
-- @return integer 
function Track:track_f_x__get_by_name(fxname, instantiate)
    return r.TrackFX_GetByName(self.pointer, fxname, instantiate)
end

-- returns index of effect visible in chain, or -1 for chain hidden, or -2 for chain visible but no effect selected
-- @return integer 
function Track:track_f_x__get_chain_visible()
    return r.TrackFX_GetChainVisible(self.pointer)
end

-- @return integer 
function Track:track_f_x__get_count()
    return r.TrackFX_GetCount(self.pointer)
end

-- Get the index of ReaEQ in the track FX chain. If ReaEQ is not in the chain and instantiate is true, it will be inserted. See TrackFX_GetInstrument, TrackFX_GetByName.
-- @instantiate boolean
-- @return integer 
function Track:track_f_x__get_e_q(instantiate)
    return r.TrackFX_GetEQ(self.pointer, instantiate)
end

-- See TrackFX_GetEQ, TrackFX_GetEQParam, TrackFX_SetEQParam, TrackFX_SetEQBandEnabled.
-- @fxidx integer
-- @bandtype integer
-- @bandidx integer
-- @return boolean 
function Track:track_f_x__get_e_q_band_enabled(fxidx, bandtype, bandidx)
    return r.TrackFX_GetEQBandEnabled(self.pointer, fxidx, bandtype, bandidx)
end

-- See TrackFX_GetEQ, TrackFX_SetEQParam, TrackFX_GetEQBandEnabled, TrackFX_SetEQBandEnabled.
-- @fxidx integer
-- @paramidx integer
-- @return number, number, number, number 
function Track:track_f_x__get_e_q_param(fxidx, paramidx)
    local retval, bandtype, bandidx, paramtype, normval = r.TrackFX_GetEQParam(self.pointer, fxidx, paramidx)
    if retval then
        return bandtype, bandidx, paramtype, normval
    end
end

-- See TrackFX_SetEnabled
-- @fx integer
-- @return boolean 
function Track:track_f_x__get_enabled(fx)
    return r.TrackFX_GetEnabled(self.pointer, fx)
end

-- @fx integer
-- @return string 
function Track:track_f_x__get_f_x_g_u_i_d(fx)
    return r.TrackFX_GetFXGUID(self.pointer, fx)
end

-- @fx integer
-- @buf string
-- @return string 
function Track:track_f_x__get_f_x_name(fx, buf)
    local retval, buf_ = r.TrackFX_GetFXName(self.pointer, fx, buf)
    if retval then
        return buf_
    end
end

-- returns HWND of floating window for effect index, if any
-- @index integer
-- @return HWND 
function Track:track_f_x__get_floating_window(index)
    return r.TrackFX_GetFloatingWindow(self.pointer, index)
end

-- @fx integer
-- @param integer
-- @buf string
-- @return string 
function Track:track_f_x__get_formatted_param_value(fx, param, buf)
    local retval, buf_ = r.TrackFX_GetFormattedParamValue(self.pointer, fx, param, buf)
    if retval then
        return buf_
    end
end

-- sets the number of input/output pins for FX if available, returns plug-in type or -1 on error
-- @fx integer
-- @return number, number 
function Track:track_f_x__get_i_o_size(fx)
    local retval, input_pins, output_pins = r.TrackFX_GetIOSize(self.pointer, fx)
    if retval then
        return input_pins, output_pins
    end
end

-- Get the index of the first track FX insert that is a virtual instrument, or -1 if none. See TrackFX_GetEQ, TrackFX_GetByName.
-- @return integer 
function Track:track_f_x__get_instrument()
    return r.TrackFX_GetInstrument(self.pointer)
end

-- gets plug-in specific named configuration value (returns true on success). Special values: 'pdc' returns PDC latency. 'in_pin_0' returns name of first input pin (if available), 'out_pin_0' returns name of first output pin (if available), etc.
-- @fx integer
-- @parmname string
-- @return string 
function Track:track_f_x__get_named_config_parm(fx, parmname)
    local retval, buf = r.TrackFX_GetNamedConfigParm(self.pointer, fx, parmname)
    if retval then
        return buf
    end
end

-- @fx integer
-- @return integer 
function Track:track_f_x__get_num_params(fx)
    return r.TrackFX_GetNumParams(self.pointer, fx)
end

-- See TrackFX_SetOffline
-- @fx integer
-- @return boolean 
function Track:track_f_x__get_offline(fx)
    return r.TrackFX_GetOffline(self.pointer, fx)
end

-- Returns true if this FX UI is open in the FX chain window or a floating window. See TrackFX_SetOpen
-- @fx integer
-- @return boolean 
function Track:track_f_x__get_open(fx)
    return r.TrackFX_GetOpen(self.pointer, fx)
end

-- @fx integer
-- @param integer
-- @return number, number 
function Track:track_f_x__get_param(fx, param)
    local retval, minval, maxval = r.TrackFX_GetParam(self.pointer, fx, param)
    if retval then
        return minval, maxval
    end
end

-- @fx integer
-- @param integer
-- @return number, number, number 
function Track:track_f_x__get_param_ex(fx, param)
    local retval, minval, maxval, midval = r.TrackFX_GetParamEx(self.pointer, fx, param)
    if retval then
        return minval, maxval, midval
    end
end

-- @fx integer
-- @param integer
-- @buf string
-- @return string 
function Track:track_f_x__get_param_name(fx, param, buf)
    local retval, buf_ = r.TrackFX_GetParamName(self.pointer, fx, param, buf)
    if retval then
        return buf_
    end
end

-- @fx integer
-- @param integer
-- @return number 
function Track:track_f_x__get_param_normalized(fx, param)
    return r.TrackFX_GetParamNormalized(self.pointer, fx, param)
end

-- @fx integer
-- @param integer
-- @return number, number, number, boolean 
function Track:track_f_x__get_parameter_step_sizes(fx, param)
    local retval, step, smallstep, largestep, istoggle = r.TrackFX_GetParameterStepSizes(self.pointer, fx, param)
    if retval then
        return step, smallstep, largestep, istoggle
    end
end

-- gets the effective channel mapping bitmask for a particular pin. high32OutOptional will be set to the high 32 bits
-- @fx integer
-- @isoutput integer
-- @pin integer
-- @return number 
function Track:track_f_x__get_pin_mappings(fx, isoutput, pin)
    local retval, high32 = r.TrackFX_GetPinMappings(self.pointer, fx, isoutput, pin)
    if retval then
        return high32
    end
end

-- Get the name of the preset currently showing in the REAPER dropdown, or the full path to a factory preset file for VST3 plug-ins (.vstpreset). Returns false if the current FX parameters do not exactly match the preset (in other words, if the user loaded the preset but moved the knobs afterward). See TrackFX_SetPreset.
-- @fx integer
-- @presetname string
-- @return string 
function Track:track_f_x__get_preset(fx, presetname)
    local retval, presetname_ = r.TrackFX_GetPreset(self.pointer, fx, presetname)
    if retval then
        return presetname_
    end
end

-- Returns current preset index, or -1 if error. numberOfPresetsOut will be set to total number of presets available. See TrackFX_SetPresetByIndex
-- @fx integer
-- @return number 
function Track:track_f_x__get_preset_index(fx)
    local retval, number_of_presets = r.TrackFX_GetPresetIndex(self.pointer, fx)
    if retval then
        return number_of_presets
    end
end

-- returns index of effect visible in record input chain, or -1 for chain hidden, or -2 for chain visible but no effect selected
-- @return integer 
function Track:track_f_x__get_rec_chain_visible()
    return r.TrackFX_GetRecChainVisible(self.pointer)
end

-- returns count of record input FX. To access record input FX, use a FX indices [0x1000000..0x1000000+n). On the master track, this accesses monitoring FX rather than record input FX.
-- @return integer 
function Track:track_f_x__get_rec_count()
    return r.TrackFX_GetRecCount(self.pointer)
end

-- @fx integer
-- @fn string
-- @return string 
function Track:track_f_x__get_user_preset_filename(fx, fn)
    return r.TrackFX_GetUserPresetFilename(self.pointer, fx, fn)
end

-- presetmove==1 activates the next preset, presetmove==-1 activates the previous preset, etc.
-- @fx integer
-- @presetmove integer
-- @return boolean 
function Track:track_f_x__navigate_presets(fx, presetmove)
    return r.TrackFX_NavigatePresets(self.pointer, fx, presetmove)
end

-- See TrackFX_GetEQ, TrackFX_GetEQParam, TrackFX_SetEQParam, TrackFX_GetEQBandEnabled.
-- @fxidx integer
-- @bandtype integer
-- @bandidx integer
-- @enable boolean
-- @return boolean 
function Track:track_f_x__set_e_q_band_enabled(fxidx, bandtype, bandidx, enable)
    return r.TrackFX_SetEQBandEnabled(self.pointer, fxidx, bandtype, bandidx, enable)
end

-- See TrackFX_GetEQ, TrackFX_GetEQParam, TrackFX_GetEQBandEnabled, TrackFX_SetEQBandEnabled.
-- @fxidx integer
-- @bandtype integer
-- @bandidx integer
-- @paramtype integer
-- @val number
-- @isnorm boolean
-- @return boolean 
function Track:track_f_x__set_e_q_param(fxidx, bandtype, bandidx, paramtype, val, isnorm)
    return r.TrackFX_SetEQParam(self.pointer, fxidx, bandtype, bandidx, paramtype, val, isnorm)
end

-- See TrackFX_GetEnabled
-- @fx integer
-- @enabled boolean
function Track:track_f_x__set_enabled(fx, enabled)
    return r.TrackFX_SetEnabled(self.pointer, fx, enabled)
end

-- sets plug-in specific named configuration value (returns true on success)
-- @fx integer
-- @parmname string
-- @value string
-- @return boolean 
function Track:track_f_x__set_named_config_parm(fx, parmname, value)
    return r.TrackFX_SetNamedConfigParm(self.pointer, fx, parmname, value)
end

-- See TrackFX_GetOffline
-- @fx integer
-- @offline boolean
function Track:track_f_x__set_offline(fx, offline)
    return r.TrackFX_SetOffline(self.pointer, fx, offline)
end

-- Open this FX UI. See TrackFX_GetOpen
-- @fx integer
-- @open boolean
function Track:track_f_x__set_open(fx, open)
    return r.TrackFX_SetOpen(self.pointer, fx, open)
end

-- @fx integer
-- @param integer
-- @val number
-- @return boolean 
function Track:track_f_x__set_param(fx, param, val)
    return r.TrackFX_SetParam(self.pointer, fx, param, val)
end

-- @fx integer
-- @param integer
-- @value number
-- @return boolean 
function Track:track_f_x__set_param_normalized(fx, param, value)
    return r.TrackFX_SetParamNormalized(self.pointer, fx, param, value)
end

-- sets the channel mapping bitmask for a particular pin. returns false if unsupported (not all types of plug-ins support this capability)
-- @fx integer
-- @isoutput integer
-- @pin integer
-- @low32bits integer
-- @hi32bits integer
-- @return boolean 
function Track:track_f_x__set_pin_mappings(fx, isoutput, pin, low32bits, hi32bits)
    return r.TrackFX_SetPinMappings(self.pointer, fx, isoutput, pin, low32bits, hi32bits)
end

-- Activate a preset with the name shown in the REAPER dropdown. Full paths to .vstpreset files are also supported for VST3 plug-ins. See TrackFX_GetPreset.
-- @fx integer
-- @presetname string
-- @return boolean 
function Track:track_f_x__set_preset(fx, presetname)
    return r.TrackFX_SetPreset(self.pointer, fx, presetname)
end

-- Sets the preset idx, or the factory preset (idx==-2), or the default user preset (idx==-1). Returns true on success. See TrackFX_GetPresetIndex.
-- @fx integer
-- @idx integer
-- @return boolean 
function Track:track_f_x__set_preset_by_index(fx, idx)
    return r.TrackFX_SetPresetByIndex(self.pointer, fx, idx)
end

-- showflag=0 for hidechain, =1 for show chain(index valid), =2 for hide floating window(index valid), =3 for show floating window (index valid)
-- @index integer
-- @show_flag integer
function Track:track_f_x__show(index, show_flag)
    return r.TrackFX_Show(self.pointer, index, show_flag)
end

