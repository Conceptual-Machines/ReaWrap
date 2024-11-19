-- @is_minor boolean
function TrackList:adjust_windows(is_minor)
    return r.TrackList_AdjustWindows(is_minor)
end

function TrackList:update_all_external_surfaces()
    return r.TrackList_UpdateAllExternalSurfaces()
end

