-- [BR] Get media item take GUID as a string (guidStringOut_sz should be at least 64). To get take from GUID string, see SNM_GetMediaItemTakeByGUID.
-- @return string 
function Take:b_r__get_media_item_take_g_u_i_d()
    return r.BR_GetMediaItemTakeGUID(self.pointer)
end

-- To set source properties, see BR_SetMediaSourceProperties.
-- @return boolean, number, number, number, boolean 
function Take:b_r__get_media_source_properties()
    local retval, section, start, length, fade, reverse = r.BR_GetMediaSourceProperties(self.pointer)
    if retval then
        return section, start, length, fade, reverse
    end
end

-- [BR] Get MIDI take source length in PPQ. In case the take isn't MIDI, return value will be -1.
-- @return number 
function Take:b_r__get_midi_source_len_p_p_q()
    return r.BR_GetMidiSourceLenPPQ(self.pointer)
end

-- [BR] Get MIDI take pool GUID as a string (guidStringOut_sz should be at least 64). Returns true if take is pooled.
-- @return string 
function Take:b_r__get_midi_take_pool_g_u_i_d()
    local retval, guid_string = r.BR_GetMidiTakePoolGUID(self.pointer)
    if retval then
        return guid_string
    end
end

-- [BR] Get "ignore project tempo" information for MIDI take. Returns true if take can ignore project tempo (no matter if it's actually ignored), otherwise false.
-- @return boolean, number, number, number 
function Take:b_r__get_midi_take_tempo_info()
    local retval, ignore_proj_tempo, bpm, num, den = r.BR_GetMidiTakeTempoInfo(self.pointer)
    if retval then
        return ignore_proj_tempo, bpm, num, den
    end
end

-- [BR] Returns FX count for supplied take
-- @return integer 
function Take:b_r__get_take_f_x_count()
    return r.BR_GetTakeFXCount(self.pointer)
end

-- [SWS] Check if take has MIDI inline editor open and returns true or false.
-- @return boolean 
function Take:b_r__is_midi_open_in_inline_editor()
    return r.BR_IsMidiOpenInInlineEditor(self.pointer)
end

-- [BR] Check if take is MIDI take, in case MIDI take is in-project MIDI source data, inProjectMidiOut will be true, otherwise false.
-- @return boolean 
function Take:b_r__is_take_midi()
    local retval, in_project_midi = r.BR_IsTakeMidi(self.pointer)
    if retval then
        return in_project_midi
    end
end

-- To get source properties, see BR_GetMediaSourceProperties.
-- @section boolean
-- @start number
-- @length number
-- @fade number
-- @reverse boolean
-- @return boolean 
function Take:b_r__set_media_source_properties(section, start, length, fade, reverse)
    return r.BR_SetMediaSourceProperties(self.pointer, section, start, length, fade, reverse)
end

-- [BR] Set "ignore project tempo" information for MIDI take. Returns true in case the take was successfully updated.
-- @ignore_proj_tempo boolean
-- @bpm number
-- @num integer
-- @den integer
-- @return boolean 
function Take:b_r__set_midi_take_tempo_info(ignore_proj_tempo, bpm, num, den)
    return r.BR_SetMidiTakeTempoInfo(self.pointer, ignore_proj_tempo, bpm, num, den)
end

-- Note: To set source from existing take, see SNM_GetSetSourceState2.
-- @filename_in string
-- @in_project_data boolean
-- @return boolean 
function Take:b_r__set_take_source_from_file(filename_in, in_project_data)
    return r.BR_SetTakeSourceFromFile(self.pointer, filename_in, in_project_data)
end

-- [BR] Differs from BR_SetTakeSourceFromFile only that it can also preserve existing take media source properties.
-- @filename_in string
-- @in_project_data boolean
-- @keep_source_properties boolean
-- @return boolean 
function Take:b_r__set_take_source_from_file2(filename_in, in_project_data, keep_source_properties)
    return r.BR_SetTakeSourceFromFile2(self.pointer, filename_in, in_project_data, keep_source_properties)
end

-- Return a handle to the given take FX chain window. HACK: This temporarily renames the take in order to disambiguate the take FX chain window from similarily named takes.
-- @return FxChain 
function Take:c_f__get_take_f_x_chain()
    return r.CF_GetTakeFXChain(self.pointer)
end

-- See GetTakeEnvelope
-- @return integer 
function Take:count_take_envelopes()
    return r.CountTakeEnvelopes(self.pointer)
end

-- Create an audio accessor object for this take. Must only call from the main thread. See CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
-- @return AudioAccessor 
function Take:create_take_audio_accessor()
    return r.CreateTakeAudioAccessor(self.pointer)
end

-- Delete a take marker. Note that idx will change for all following take markers. See GetNumTakeMarkers, GetTakeMarker, SetTakeMarker
-- @idx integer
-- @return boolean 
function Take:delete_take_marker(idx)
    return r.DeleteTakeMarker(self.pointer, idx)
end

-- Deletes one or more stretch markers. Returns number of stretch markers deleted.
-- @idx integer
-- @count_in number
-- @return integer 
function Take:delete_take_stretch_markers(idx, count_in)
    return r.DeleteTakeStretchMarkers(self.pointer, idx, count_in)
end

-- [FNG] Allocate a RprMidiTake from a take pointer. Returns a NULL pointer if the take is not an in-project MIDI take
-- @return RprMidiTake 
function Take:f_n_g__alloc_midi_take()
    return r.FNG_AllocMidiTake(self.pointer)
end

-- Get parent item of media item take
-- @return MediaItem 
function Take:get_media_item_item()
    return r.GetMediaItemTake_Item(self.pointer)
end

-- Gets block of peak samples to buf. Note that the peak samples are interleaved, but in two or three blocks (maximums, then minimums, then extra). Return value has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000), then a bit to signify whether extra_type was available (0x1000000). extra_type can be 115 ('s') for spectral information, which will return peak samples as integers with the low 15 bits frequency, next 14 bits tonality.
-- @peakrate number
-- @starttime number
-- @numchannels integer
-- @numsamplesperchannel integer
-- @want_extra_type integer
-- @buf reaper.array
-- @return integer 
function Take:get_media_item_peaks(peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
    return r.GetMediaItemTake_Peaks(self.pointer, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf)
end

-- Get media source of media item take
-- @return PCM_source 
function Take:get_media_item_source()
    return r.GetMediaItemTake_Source(self.pointer)
end

-- @parmname string
-- @return number 
function Take:get_media_item_take_info__value(parmname)
    return r.GetMediaItemTakeInfo_Value(self.pointer, parmname)
end

-- Get parent track of media item take
-- @return MediaTrack 
function Take:get_media_item_track()
    return r.GetMediaItemTake_Track(self.pointer)
end

-- Returns number of take markers. See GetTakeMarker, SetTakeMarker, DeleteTakeMarker
-- @return integer 
function Take:get_num_take_markers()
    return r.GetNumTakeMarkers(self.pointer)
end

-- @parmname string
-- @string_need_big string
-- @set_new_value boolean
-- @return string 
function Take:get_set_media_item_take_info__string(parmname, string_need_big, set_new_value)
    local retval, string_need_big_ = r.GetSetMediaItemTakeInfo_String(self.pointer, parmname, string_need_big, set_new_value)
    if retval then
        return string_need_big_
    end
end

-- @envidx integer
-- @return TrackEnvelope 
function Take:get_take_envelope(envidx)
    return r.GetTakeEnvelope(self.pointer, envidx)
end

-- @envname string
-- @return TrackEnvelope 
function Take:get_take_envelope_by_name(envname)
    return r.GetTakeEnvelopeByName(self.pointer, envname)
end

-- Get information about a take marker. Returns the position in media item source time, or -1 if the take marker does not exist. See GetNumTakeMarkers, SetTakeMarker, DeleteTakeMarker
-- @idx integer
-- @return string, number 
function Take:get_take_marker(idx)
    local retval, name, color = r.GetTakeMarker(self.pointer, idx)
    if retval then
        return name, color
    end
end

-- returns NULL if the take is not valid
-- @return string 
function Take:get_take_name()
    return r.GetTakeName(self.pointer)
end

-- Returns number of stretch markers in take
-- @return integer 
function Take:get_take_num_stretch_markers()
    return r.GetTakeNumStretchMarkers(self.pointer)
end

-- Gets information on a stretch marker, idx is 0..n. Returns false if stretch marker not valid. posOut will be set to position in item, srcposOutOptional will be set to source media position. Returns index. if input index is -1, next marker is found using position (or source position if position is -1). If position/source position are used to find marker position, their values are not updated.
-- @idx integer
-- @return number, number 
function Take:get_take_stretch_marker(idx)
    local retval, pos, srcpos = r.GetTakeStretchMarker(self.pointer, idx)
    if retval then
        return pos, srcpos
    end
end

-- See SetTakeStretchMarkerSlope
-- @idx integer
-- @return number 
function Take:get_take_stretch_marker_slope(idx)
    return r.GetTakeStretchMarkerSlope(self.pointer, idx)
end

-- Count the number of notes, CC events, and text/sysex events in a given MIDI item.
-- @return number, number, number 
function Take:m_i_d_i__count_evts()
    local retval, notecnt, ccevtcnt, textsyxevtcnt = r.MIDI_CountEvts(self.pointer)
    if retval then
        return notecnt, ccevtcnt, textsyxevtcnt
    end
end

-- Delete a MIDI CC event.
-- @ccidx integer
-- @return boolean 
function Take:m_i_d_i__delete_c_c(ccidx)
    return r.MIDI_DeleteCC(self.pointer, ccidx)
end

-- Delete a MIDI event.
-- @evtidx integer
-- @return boolean 
function Take:m_i_d_i__delete_evt(evtidx)
    return r.MIDI_DeleteEvt(self.pointer, evtidx)
end

-- Delete a MIDI note.
-- @noteidx integer
-- @return boolean 
function Take:m_i_d_i__delete_note(noteidx)
    return r.MIDI_DeleteNote(self.pointer, noteidx)
end

-- Delete a MIDI text or sysex event.
-- @textsyxevtidx integer
-- @return boolean 
function Take:m_i_d_i__delete_text_sysex_evt(textsyxevtidx)
    return r.MIDI_DeleteTextSysexEvt(self.pointer, textsyxevtidx)
end

-- Disable sorting for all MIDI insert, delete, get and set functions, until MIDI_Sort is called.
function Take:m_i_d_i__disable_sort()
    return r.MIDI_DisableSort(self.pointer)
end

-- Returns the index of the next selected MIDI CC event after ccidx (-1 if there are no more selected events).
-- @ccidx integer
-- @return integer 
function Take:m_i_d_i__enum_sel_c_c(ccidx)
    return r.MIDI_EnumSelCC(self.pointer, ccidx)
end

-- Returns the index of the next selected MIDI event after evtidx (-1 if there are no more selected events).
-- @evtidx integer
-- @return integer 
function Take:m_i_d_i__enum_sel_evts(evtidx)
    return r.MIDI_EnumSelEvts(self.pointer, evtidx)
end

-- Returns the index of the next selected MIDI note after noteidx (-1 if there are no more selected events).
-- @noteidx integer
-- @return integer 
function Take:m_i_d_i__enum_sel_notes(noteidx)
    return r.MIDI_EnumSelNotes(self.pointer, noteidx)
end

-- Returns the index of the next selected MIDI text/sysex event after textsyxidx (-1 if there are no more selected events).
-- @textsyxidx integer
-- @return integer 
function Take:m_i_d_i__enum_sel_text_sysex_evts(textsyxidx)
    return r.MIDI_EnumSelTextSysexEvts(self.pointer, textsyxidx)
end

-- See MIDI_SetAllEvts.
-- @buf string
-- @return string 
function Take:m_i_d_i__get_all_evts(buf)
    local retval, buf_ = r.MIDI_GetAllEvts(self.pointer, buf)
    if retval then
        return buf_
    end
end

-- Get MIDI CC event properties.
-- @ccidx integer
-- @return boolean, boolean, number, number, number, number, number 
function Take:m_i_d_i__get_c_c(ccidx)
    local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = r.MIDI_GetCC(self.pointer, ccidx)
    if retval then
        return selected, muted, ppqpos, chanmsg, chan, msg2, msg3
    end
end

-- Get CC shape and bezier tension. See MIDI_GetCC, MIDI_SetCCShape
-- @ccidx integer
-- @return number, number 
function Take:m_i_d_i__get_c_c_shape(ccidx)
    local retval, shape, beztension = r.MIDI_GetCCShape(self.pointer, ccidx)
    if retval then
        return shape, beztension
    end
end

-- Get MIDI event properties.
-- @evtidx integer
-- @selected boolean
-- @muted boolean
-- @ppqpos number
-- @msg string
-- @return boolean, boolean, number, string 
function Take:m_i_d_i__get_evt(evtidx, selected, muted, ppqpos, msg)
    local retval, selected_, muted_, ppqpos_, msg_ = r.MIDI_GetEvt(self.pointer, evtidx, selected, muted, ppqpos, msg)
    if retval then
        return selected_, muted_, ppqpos_, msg_
    end
end

-- Returns the most recent MIDI editor grid size for this MIDI take, in QN. Swing is between 0 and 1. Note length is 0 if it follows the grid size.
-- @return number, number 
function Take:m_i_d_i__get_grid()
    local retval, swing, note_len = r.MIDI_GetGrid(self.pointer)
    if retval then
        return swing, note_len
    end
end

-- Get a string that only changes when the MIDI data changes. If notesonly==true, then the string changes only when the MIDI notes change. See MIDI_GetTrackHash
-- @notesonly boolean
-- @hash string
-- @return string 
function Take:m_i_d_i__get_hash(notesonly, hash)
    local retval, hash_ = r.MIDI_GetHash(self.pointer, notesonly, hash)
    if retval then
        return hash_
    end
end

-- Get MIDI note properties.
-- @noteidx integer
-- @return boolean, boolean, number, number, number, number, number 
function Take:m_i_d_i__get_note(noteidx)
    local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = r.MIDI_GetNote(self.pointer, noteidx)
    if retval then
        return selected, muted, startppqpos, endppqpos, chan, pitch, vel
    end
end

-- Returns the MIDI tick (ppq) position corresponding to the end of the measure.
-- @ppqpos number
-- @return number 
function Take:m_i_d_i__get_p_p_q_pos__end_of_measure(ppqpos)
    return r.MIDI_GetPPQPos_EndOfMeasure(self.pointer, ppqpos)
end

-- Returns the MIDI tick (ppq) position corresponding to the start of the measure.
-- @ppqpos number
-- @return number 
function Take:m_i_d_i__get_p_p_q_pos__start_of_measure(ppqpos)
    return r.MIDI_GetPPQPos_StartOfMeasure(self.pointer, ppqpos)
end

-- Returns the MIDI tick (ppq) position corresponding to a specific project time in quarter notes.
-- @projqn number
-- @return number 
function Take:m_i_d_i__get_p_p_q_pos_from_proj_q_n(projqn)
    return r.MIDI_GetPPQPosFromProjQN(self.pointer, projqn)
end

-- Returns the MIDI tick (ppq) position corresponding to a specific project time in seconds.
-- @projtime number
-- @return number 
function Take:m_i_d_i__get_p_p_q_pos_from_proj_time(projtime)
    return r.MIDI_GetPPQPosFromProjTime(self.pointer, projtime)
end

-- Returns the project time in quarter notes corresponding to a specific MIDI tick (ppq) position.
-- @ppqpos number
-- @return number 
function Take:m_i_d_i__get_proj_q_n_from_p_p_q_pos(ppqpos)
    return r.MIDI_GetProjQNFromPPQPos(self.pointer, ppqpos)
end

-- Returns the project time in seconds corresponding to a specific MIDI tick (ppq) position.
-- @ppqpos number
-- @return number 
function Take:m_i_d_i__get_proj_time_from_p_p_q_pos(ppqpos)
    return r.MIDI_GetProjTimeFromPPQPos(self.pointer, ppqpos)
end

-- Get the active scale in the media source, if any. root 0=C, 1=C#, etc. scale &0x1=root, &0x2=minor 2nd, &0x4=major 2nd, &0x8=minor 3rd, &0xF=fourth, etc.
-- @root number
-- @scale number
-- @name string
-- @return number, number, string 
function Take:m_i_d_i__get_scale(root, scale, name)
    local retval, root_, scale_, name_ = r.MIDI_GetScale(self.pointer, root, scale, name)
    if retval then
        return root_, scale_, name_
    end
end

-- Get MIDI meta-event properties. Allowable types are -1:sysex (msg should not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event. For all other meta-messages, type is returned as -2 and msg returned as all zeroes. See MIDI_GetEvt.
-- @textsyxevtidx integer
-- @selected boolean
-- @muted boolean
-- @ppqpos number
-- @type number
-- @msg string
-- @return boolean, boolean, number, number, string 
function Take:m_i_d_i__get_text_sysex_evt(textsyxevtidx, selected, muted, ppqpos, type, msg)
    local retval, selected_, muted_, ppqpos_, type_, msg_ = r.MIDI_GetTextSysexEvt(self.pointer, textsyxevtidx, selected, muted, ppqpos, type, msg)
    if retval then
        return selected_, muted_, ppqpos_, type_, msg_
    end
end

-- Insert a new MIDI CC event.
-- @selected boolean
-- @muted boolean
-- @ppqpos number
-- @chanmsg integer
-- @chan integer
-- @msg2 integer
-- @msg3 integer
-- @return boolean 
function Take:m_i_d_i__insert_c_c(selected, muted, ppqpos, chanmsg, chan, msg2, msg3)
    return r.MIDI_InsertCC(self.pointer, selected, muted, ppqpos, chanmsg, chan, msg2, msg3)
end

-- Insert a new MIDI event.
-- @selected boolean
-- @muted boolean
-- @ppqpos number
-- @bytestr string
-- @return boolean 
function Take:m_i_d_i__insert_evt(selected, muted, ppqpos, bytestr)
    return r.MIDI_InsertEvt(self.pointer, selected, muted, ppqpos, bytestr)
end

-- Insert a new MIDI note. Set noSort if inserting multiple events, then call MIDI_Sort when done.
-- @selected boolean
-- @muted boolean
-- @startppqpos number
-- @endppqpos number
-- @chan integer
-- @pitch integer
-- @vel integer
-- @no_sort_in boolean
-- @return boolean 
function Take:m_i_d_i__insert_note(selected, muted, startppqpos, endppqpos, chan, pitch, vel, no_sort_in)
    return r.MIDI_InsertNote(self.pointer, selected, muted, startppqpos, endppqpos, chan, pitch, vel, no_sort_in)
end

-- Insert a new MIDI text or sysex event. Allowable types are -1:sysex (msg should not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event.
-- @selected boolean
-- @muted boolean
-- @ppqpos number
-- @type integer
-- @bytestr string
-- @return boolean 
function Take:m_i_d_i__insert_text_sysex_evt(selected, muted, ppqpos, type, bytestr)
    return r.MIDI_InsertTextSysexEvt(self.pointer, selected, muted, ppqpos, type, bytestr)
end

-- Select or deselect all MIDI content.
-- @select boolean
function Take:m_i_d_i__select_all(select)
    return r.MIDI_SelectAll(self.pointer, select)
end

-- See MIDI_GetAllEvts.
-- @buf string
-- @return boolean 
function Take:m_i_d_i__set_all_evts(buf)
    return r.MIDI_SetAllEvts(self.pointer, buf)
end

-- Set MIDI CC event properties. Properties passed as NULL will not be set. set noSort if setting multiple events, then call MIDI_Sort when done.
-- @ccidx integer
-- @selected_in boolean
-- @muted_in boolean
-- @ppqpos_in number
-- @chanmsg_in number
-- @chan_in number
-- @msg2_in number
-- @msg3_in number
-- @no_sort_in boolean
-- @return boolean 
function Take:m_i_d_i__set_c_c(ccidx, selected_in, muted_in, ppqpos_in, chanmsg_in, chan_in, msg2_in, msg3_in, no_sort_in)
    return r.MIDI_SetCC(self.pointer, ccidx, selected_in, muted_in, ppqpos_in, chanmsg_in, chan_in, msg2_in, msg3_in, no_sort_in)
end

-- Set CC shape and bezier tension. set noSort if setting multiple events, then call MIDI_Sort when done. See MIDI_SetCC, MIDI_GetCCShape
-- @ccidx integer
-- @shape integer
-- @beztension number
-- @no_sort_in boolean
-- @return boolean 
function Take:m_i_d_i__set_c_c_shape(ccidx, shape, beztension, no_sort_in)
    return r.MIDI_SetCCShape(self.pointer, ccidx, shape, beztension, no_sort_in)
end

-- Set MIDI event properties. Properties passed as NULL will not be set.  set noSort if setting multiple events, then call MIDI_Sort when done.
-- @evtidx integer
-- @selected_in boolean
-- @muted_in boolean
-- @ppqpos_in number
-- @msg string
-- @no_sort_in boolean
-- @return boolean 
function Take:m_i_d_i__set_evt(evtidx, selected_in, muted_in, ppqpos_in, msg, no_sort_in)
    return r.MIDI_SetEvt(self.pointer, evtidx, selected_in, muted_in, ppqpos_in, msg, no_sort_in)
end

-- Set MIDI note properties. Properties passed as NULL (or negative values) will not be set. Set noSort if setting multiple events, then call MIDI_Sort when done. Setting multiple note start positions at once is done more safely by deleting and re-inserting the notes.
-- @noteidx integer
-- @selected_in boolean
-- @muted_in boolean
-- @startppqpos_in number
-- @endppqpos_in number
-- @chan_in number
-- @pitch_in number
-- @vel_in number
-- @no_sort_in boolean
-- @return boolean 
function Take:m_i_d_i__set_note(noteidx, selected_in, muted_in, startppqpos_in, endppqpos_in, chan_in, pitch_in, vel_in, no_sort_in)
    return r.MIDI_SetNote(self.pointer, noteidx, selected_in, muted_in, startppqpos_in, endppqpos_in, chan_in, pitch_in, vel_in, no_sort_in)
end

-- Set MIDI text or sysex event properties. Properties passed as NULL will not be set. Allowable types are -1:sysex (msg should not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event. set noSort if setting multiple events, then call MIDI_Sort when done.
-- @textsyxevtidx integer
-- @selected_in boolean
-- @muted_in boolean
-- @ppqpos_in number
-- @type_in number
-- @msg string
-- @no_sort_in boolean
-- @return boolean 
function Take:m_i_d_i__set_text_sysex_evt(textsyxevtidx, selected_in, muted_in, ppqpos_in, type_in, msg, no_sort_in)
    return r.MIDI_SetTextSysexEvt(self.pointer, textsyxevtidx, selected_in, muted_in, ppqpos_in, type_in, msg, no_sort_in)
end

-- Sort MIDI events after multiple calls to MIDI_SetNote, MIDI_SetCC, etc.
function Take:m_i_d_i__sort()
    return r.MIDI_Sort(self.pointer)
end

-- Full loudness analysis. retval: returns true on successful analysis, false on MIDI take or when analysis failed for some reason. analyzeTruePeak=true: Also do true peak analysis. Returns true peak value and true peak position (relative to item position). Considerably slower than without true peak analysis (since it uses oversampling). Note: Short term uses a time window of 3 sec. for calculation. So for items shorter than this shortTermMaxOut can't be calculated correctly. Momentary uses a time window of 0.4 sec. 
-- @analyze_true_peak boolean
-- @return number, number, number, number, number, number 
function Take:n_f__analyze_take_loudness(analyze_true_peak)
    local retval, lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max = r.NF_AnalyzeTakeLoudness(self.pointer, analyze_true_peak)
    if retval then
        return lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max
    end
end

-- Same as NF_AnalyzeTakeLoudness but additionally returns shortTermMaxPos and momentaryMaxPos (in absolute project time). Note: shortTermMaxPos and momentaryMaxPos actaully indicate the beginning of time intervalls, (3 sec. and 0.4 sec. resp.). 
-- @analyze_true_peak boolean
-- @return number, number, number, number, number, number, number, number 
function Take:n_f__analyze_take_loudness2(analyze_true_peak)
    local retval, lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max, short_term_max_pos, momentary_max_pos = r.NF_AnalyzeTakeLoudness2(self.pointer, analyze_true_peak)
    if retval then
        return lufs_integrated, range, true_peak, true_peak_pos, short_term_max, momentary_max, short_term_max_pos, momentary_max_pos
    end
end

-- Does LUFS integrated analysis only. Faster than full loudness analysis (NF_AnalyzeTakeLoudness) . Use this if only LUFS integrated is required. Take vol. env. is taken into account. See: Signal flow
-- @return number 
function Take:n_f__analyze_take_loudness__integrated_only()
    local retval, lufs_integrated = r.NF_AnalyzeTakeLoudness_IntegratedOnly(self.pointer)
    if retval then
        return lufs_integrated
    end
end

-- Note: this function cannot deal with empty takes, see SNM_GetSetSourceState.
-- @state WDL_FastString
-- @retval ReaType
-- @setnewvalue boolean
-- @return boolean 
function Take:s_n_m__get_set_source_state2(state, retval, setnewvalue)
    return r.SNM_GetSetSourceState2(self.pointer, state, retval, setnewvalue)
end

-- [S&M] Deprecated, see GetMediaSourceType. Gets the source type of a take. Returns false if failed (e.g. take with empty source, etc..)
-- @type WDL_FastString
-- @retval ReaType
-- @return boolean 
function Take:s_n_m__get_source_type(type, retval)
    return r.SNM_GetSourceType(self.pointer, type, retval)
end

-- set this take active in this media item
function Take:set_active_take()
    return r.SetActiveTake(self.pointer)
end

-- Set media source of media item take. The old source will not be destroyed, it is the caller's responsibility to retrieve it and destroy it after. If source already exists in any project, it will be duplicated before being set. C/C++ code should not use this and instead use GetSetMediaItemTakeInfo() with P_SOURCE to manage ownership directly.
-- @source PCM_source
-- @return boolean 
function Take:set_media_item_source(source)
    return r.SetMediaItemTake_Source(self.pointer, source)
end

-- @parmname string
-- @newvalue number
-- @return boolean 
function Take:set_media_item_take_info__value(parmname, newvalue)
    return r.SetMediaItemTakeInfo_Value(self.pointer, parmname, newvalue)
end

-- Inserts or updates a take marker. If idx<0, a take marker will be added, otherwise an existing take marker will be updated. Returns the index of the new or updated take marker (which may change if srcPos is updated). See GetNumTakeMarkers, GetTakeMarker, DeleteTakeMarker
-- @idx integer
-- @name_in string
-- @srcpos_in number
-- @color_in number
-- @return integer 
function Take:set_take_marker(idx, name_in, srcpos_in, color_in)
    return r.SetTakeMarker(self.pointer, idx, name_in, srcpos_in, color_in)
end

-- Adds or updates a stretch marker. If idx<0, stretch marker will be added. If idx>=0, stretch marker will be updated. When adding, if srcposInOptional is omitted, source position will be auto-calculated. When updating a stretch marker, if srcposInOptional is omitted, srcpos will not be modified. Position/srcposition values will be constrained to nearby stretch markers. Returns index of stretch marker, or -1 if did not insert (or marker already existed at time).
-- @idx integer
-- @pos number
-- @srcpos_in number
-- @return integer 
function Take:set_take_stretch_marker(idx, pos, srcpos_in)
    return r.SetTakeStretchMarker(self.pointer, idx, pos, srcpos_in)
end

-- See GetTakeStretchMarkerSlope
-- @idx integer
-- @slope number
-- @return boolean 
function Take:set_take_stretch_marker_slope(idx, slope)
    return r.SetTakeStretchMarkerSlope(self.pointer, idx, slope)
end

-- Adds or queries the position of a named FX in a take. See TrackFX_AddByName() for information on fxname and instantiate.
-- @fxname string
-- @instantiate integer
-- @return integer 
function Take:take_f_x__add_by_name(fxname, instantiate)
    return r.TakeFX_AddByName(self.pointer, fxname, instantiate)
end

-- Copies (or moves) FX from src_take to dest_take. Can be used with src_take=dest_take to reorder.
-- @src_fx integer
-- @dest_take MediaItem_Take
-- @dest_fx integer
-- @is_move boolean
function Take:take_f_x__copy_to_take(src_fx, dest_take, dest_fx, is_move)
    return r.TakeFX_CopyToTake(self.pointer, src_fx, dest_take, dest_fx, is_move)
end

-- Copies (or moves) FX from src_take to dest_track. dest_fx can have 0x1000000 set to reference input FX.
-- @src_fx integer
-- @dest_track MediaTrack
-- @dest_fx integer
-- @is_move boolean
function Take:take_f_x__copy_to_track(src_fx, dest_track, dest_fx, is_move)
    return r.TakeFX_CopyToTrack(self.pointer, src_fx, dest_track, dest_fx, is_move)
end

-- Remove a FX from take chain (returns true on success)
-- @fx integer
-- @return boolean 
function Take:take_f_x__delete(fx)
    return r.TakeFX_Delete(self.pointer, fx)
end

-- @fx integer
-- @param integer
-- @return boolean 
function Take:take_f_x__end_param_edit(fx, param)
    return r.TakeFX_EndParamEdit(self.pointer, fx, param)
end

-- Note: only works with FX that support Cockos VST extensions.
-- @fx integer
-- @param integer
-- @val number
-- @buf string
-- @return string 
function Take:take_f_x__format_param_value(fx, param, val, buf)
    local retval, buf_ = r.TakeFX_FormatParamValue(self.pointer, fx, param, val, buf)
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
function Take:take_f_x__format_param_value_normalized(fx, param, value, buf)
    local retval, buf_ = r.TakeFX_FormatParamValueNormalized(self.pointer, fx, param, value, buf)
    if retval then
        return buf_
    end
end

-- returns index of effect visible in chain, or -1 for chain hidden, or -2 for chain visible but no effect selected
-- @return integer 
function Take:take_f_x__get_chain_visible()
    return r.TakeFX_GetChainVisible(self.pointer)
end

-- @return integer 
function Take:take_f_x__get_count()
    return r.TakeFX_GetCount(self.pointer)
end

-- See TakeFX_SetEnabled
-- @fx integer
-- @return boolean 
function Take:take_f_x__get_enabled(fx)
    return r.TakeFX_GetEnabled(self.pointer, fx)
end

-- Returns the FX parameter envelope. If the envelope does not exist and create=true, the envelope will be created.
-- @fxindex integer
-- @parameterindex integer
-- @create boolean
-- @return TrackEnvelope 
function Take:take_f_x__get_envelope(fxindex, parameterindex, create)
    return r.TakeFX_GetEnvelope(self.pointer, fxindex, parameterindex, create)
end

-- @fx integer
-- @return string 
function Take:take_f_x__get_f_x_g_u_i_d(fx)
    return r.TakeFX_GetFXGUID(self.pointer, fx)
end

-- @fx integer
-- @buf string
-- @return string 
function Take:take_f_x__get_f_x_name(fx, buf)
    local retval, buf_ = r.TakeFX_GetFXName(self.pointer, fx, buf)
    if retval then
        return buf_
    end
end

-- returns HWND of floating window for effect index, if any
-- @index integer
-- @return HWND 
function Take:take_f_x__get_floating_window(index)
    return r.TakeFX_GetFloatingWindow(self.pointer, index)
end

-- @fx integer
-- @param integer
-- @buf string
-- @return string 
function Take:take_f_x__get_formatted_param_value(fx, param, buf)
    local retval, buf_ = r.TakeFX_GetFormattedParamValue(self.pointer, fx, param, buf)
    if retval then
        return buf_
    end
end

-- sets the number of input/output pins for FX if available, returns plug-in type or -1 on error
-- @fx integer
-- @return number, number 
function Take:take_f_x__get_i_o_size(fx)
    local retval, input_pins, output_pins = r.TakeFX_GetIOSize(self.pointer, fx)
    if retval then
        return input_pins, output_pins
    end
end

-- gets plug-in specific named configuration value (returns true on success). see TrackFX_GetNamedConfigParm
-- @fx integer
-- @parmname string
-- @return string 
function Take:take_f_x__get_named_config_parm(fx, parmname)
    local retval, buf = r.TakeFX_GetNamedConfigParm(self.pointer, fx, parmname)
    if retval then
        return buf
    end
end

-- @fx integer
-- @return integer 
function Take:take_f_x__get_num_params(fx)
    return r.TakeFX_GetNumParams(self.pointer, fx)
end

-- See TakeFX_SetOffline
-- @fx integer
-- @return boolean 
function Take:take_f_x__get_offline(fx)
    return r.TakeFX_GetOffline(self.pointer, fx)
end

-- Returns true if this FX UI is open in the FX chain window or a floating window. See TakeFX_SetOpen
-- @fx integer
-- @return boolean 
function Take:take_f_x__get_open(fx)
    return r.TakeFX_GetOpen(self.pointer, fx)
end

-- @fx integer
-- @param integer
-- @return number, number 
function Take:take_f_x__get_param(fx, param)
    local retval, minval, maxval = r.TakeFX_GetParam(self.pointer, fx, param)
    if retval then
        return minval, maxval
    end
end

-- @fx integer
-- @param integer
-- @return number, number, number 
function Take:take_f_x__get_param_ex(fx, param)
    local retval, minval, maxval, midval = r.TakeFX_GetParamEx(self.pointer, fx, param)
    if retval then
        return minval, maxval, midval
    end
end

-- @fx integer
-- @param integer
-- @buf string
-- @return string 
function Take:take_f_x__get_param_name(fx, param, buf)
    local retval, buf_ = r.TakeFX_GetParamName(self.pointer, fx, param, buf)
    if retval then
        return buf_
    end
end

-- @fx integer
-- @param integer
-- @return number 
function Take:take_f_x__get_param_normalized(fx, param)
    return r.TakeFX_GetParamNormalized(self.pointer, fx, param)
end

-- @fx integer
-- @param integer
-- @return number, number, number, boolean 
function Take:take_f_x__get_parameter_step_sizes(fx, param)
    local retval, step, smallstep, largestep, istoggle = r.TakeFX_GetParameterStepSizes(self.pointer, fx, param)
    if retval then
        return step, smallstep, largestep, istoggle
    end
end

-- gets the effective channel mapping bitmask for a particular pin. high32OutOptional will be set to the high 32 bits
-- @fx integer
-- @isoutput integer
-- @pin integer
-- @return number 
function Take:take_f_x__get_pin_mappings(fx, isoutput, pin)
    local retval, high32 = r.TakeFX_GetPinMappings(self.pointer, fx, isoutput, pin)
    if retval then
        return high32
    end
end

-- Get the name of the preset currently showing in the REAPER dropdown, or the full path to a factory preset file for VST3 plug-ins (.vstpreset). Returns false if the current FX parameters do not exactly match the preset (in other words, if the user loaded the preset but moved the knobs afterward). See TakeFX_SetPreset.
-- @fx integer
-- @presetname string
-- @return string 
function Take:take_f_x__get_preset(fx, presetname)
    local retval, presetname_ = r.TakeFX_GetPreset(self.pointer, fx, presetname)
    if retval then
        return presetname_
    end
end

-- Returns current preset index, or -1 if error. numberOfPresetsOut will be set to total number of presets available. See TakeFX_SetPresetByIndex
-- @fx integer
-- @return number 
function Take:take_f_x__get_preset_index(fx)
    local retval, number_of_presets = r.TakeFX_GetPresetIndex(self.pointer, fx)
    if retval then
        return number_of_presets
    end
end

-- @fx integer
-- @fn string
-- @return string 
function Take:take_f_x__get_user_preset_filename(fx, fn)
    return r.TakeFX_GetUserPresetFilename(self.pointer, fx, fn)
end

-- presetmove==1 activates the next preset, presetmove==-1 activates the previous preset, etc.
-- @fx integer
-- @presetmove integer
-- @return boolean 
function Take:take_f_x__navigate_presets(fx, presetmove)
    return r.TakeFX_NavigatePresets(self.pointer, fx, presetmove)
end

-- See TakeFX_GetEnabled
-- @fx integer
-- @enabled boolean
function Take:take_f_x__set_enabled(fx, enabled)
    return r.TakeFX_SetEnabled(self.pointer, fx, enabled)
end

-- gets plug-in specific named configuration value (returns true on success)
-- @fx integer
-- @parmname string
-- @value string
-- @return boolean 
function Take:take_f_x__set_named_config_parm(fx, parmname, value)
    return r.TakeFX_SetNamedConfigParm(self.pointer, fx, parmname, value)
end

-- See TakeFX_GetOffline
-- @fx integer
-- @offline boolean
function Take:take_f_x__set_offline(fx, offline)
    return r.TakeFX_SetOffline(self.pointer, fx, offline)
end

-- Open this FX UI. See TakeFX_GetOpen
-- @fx integer
-- @open boolean
function Take:take_f_x__set_open(fx, open)
    return r.TakeFX_SetOpen(self.pointer, fx, open)
end

-- @fx integer
-- @param integer
-- @val number
-- @return boolean 
function Take:take_f_x__set_param(fx, param, val)
    return r.TakeFX_SetParam(self.pointer, fx, param, val)
end

-- @fx integer
-- @param integer
-- @value number
-- @return boolean 
function Take:take_f_x__set_param_normalized(fx, param, value)
    return r.TakeFX_SetParamNormalized(self.pointer, fx, param, value)
end

-- sets the channel mapping bitmask for a particular pin. returns false if unsupported (not all types of plug-ins support this capability)
-- @fx integer
-- @isoutput integer
-- @pin integer
-- @low32bits integer
-- @hi32bits integer
-- @return boolean 
function Take:take_f_x__set_pin_mappings(fx, isoutput, pin, low32bits, hi32bits)
    return r.TakeFX_SetPinMappings(self.pointer, fx, isoutput, pin, low32bits, hi32bits)
end

-- Activate a preset with the name shown in the REAPER dropdown. Full paths to .vstpreset files are also supported for VST3 plug-ins. See TakeFX_GetPreset.
-- @fx integer
-- @presetname string
-- @return boolean 
function Take:take_f_x__set_preset(fx, presetname)
    return r.TakeFX_SetPreset(self.pointer, fx, presetname)
end

-- Sets the preset idx, or the factory preset (idx==-2), or the default user preset (idx==-1). Returns true on success. See TakeFX_GetPresetIndex.
-- @fx integer
-- @idx integer
-- @return boolean 
function Take:take_f_x__set_preset_by_index(fx, idx)
    return r.TakeFX_SetPresetByIndex(self.pointer, fx, idx)
end

-- showflag=0 for hidechain, =1 for show chain(index valid), =2 for hide floating window(index valid), =3 for show floating window (index valid)
-- @index integer
-- @show_flag integer
function Take:take_f_x__show(index, show_flag)
    return r.TakeFX_Show(self.pointer, index, show_flag)
end

-- Returns true if the active take contains MIDI.
-- @return boolean 
function Take:take_is_m_i_d_i()
    return r.TakeIsMIDI(self.pointer)
end

