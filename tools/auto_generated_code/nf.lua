-- Get SWS analysis/normalize options. See NF_SetSWS_RMSoptions.
-- @return number, number 
function NF:get_s_w_s__r_m_soptions()
    return r.NF_GetSWS_RMSoptions()
end

-- Returns SWS/S&M marker/region subtitle. markerRegionIdx: Refers to index that can be passed to EnumProjectMarkers (not displayed marker/region index). Returns empty string if marker/region with specified index not found or marker/region subtitle not set. Lua code example here.
-- @marker_region_idx integer
-- @return string 
function NF:get_s_w_s_marker_region_sub(marker_region_idx)
    return r.NF_GetSWSMarkerRegionSub(marker_region_idx)
end

-- Set SWS analysis/normalize options (same as running action 'SWS: Set RMS analysis/normalize options'). targetLevel: target RMS normalize level (dB), windowSize: window size for peak RMS (sec.)
-- @target_level number
-- @window_size number
-- @return boolean 
function NF:set_s_w_s__r_m_soptions(target_level, window_size)
    return r.NF_SetSWS_RMSoptions(target_level, window_size)
end

-- Set SWS/S&M marker/region subtitle. markerRegionIdx: Refers to index that can be passed to EnumProjectMarkers (not displayed marker/region index). Returns true if subtitle is set successfully (i.e. marker/region with specified index is present in project). Lua code example here.
-- @marker_region_sub string
-- @marker_region_idx integer
-- @return boolean 
function NF:set_s_w_s_marker_region_sub(marker_region_sub, marker_region_idx)
    return r.NF_SetSWSMarkerRegionSub(marker_region_sub, marker_region_idx)
end

-- Redraw the Notes window (call if you've changed a subtitle via NF_SetSWSMarkerRegionSub which is currently displayed in the Notes window and you want to appear the new subtitle immediately.)
function NF:update_s_w_s_marker_region_sub_window()
    return r.NF_UpdateSWSMarkerRegionSubWindow()
end

-- Equivalent to win32 API GetSystemMetrics().
-- @n_index integer
-- @return integer 
function NF:win32__get_system_metrics(n_index)
    return r.NF_Win32_GetSystemMetrics(n_index)
end

