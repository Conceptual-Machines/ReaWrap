-- The repository index is downloaded asynchronously if the cached copy doesn't exist or is older than one week.
-- @entry PackageEntry
-- @return boolean 
function ReaPack:about_installed_package(entry)
    return r.ReaPack_AboutInstalledPackage(entry)
end

-- The repository index is downloaded asynchronously if the cached copy doesn't exist or is older than one week.
-- @repo_name string
-- @return boolean 
function ReaPack:about_repository(repo_name)
    return r.ReaPack_AboutRepository(repo_name)
end

-- autoInstall: usually set to 2 (obey user setting).
-- @name string
-- @url string
-- @enable boolean
-- @auto_install integer
-- @return string 
function ReaPack:add_set_repository(name, url, enable, auto_install)
    local retval, error = r.ReaPack_AddSetRepository(name, url, enable, auto_install)
    if retval then
        return error
    end
end

-- Opens the package browser with the given filter string.
-- @filter string
function ReaPack:browse_packages(filter)
    return r.ReaPack_BrowsePackages(filter)
end

-- Returns 0 if both versions are equal, a positive value if ver1 is higher than ver2 and a negative value otherwise.
-- @ver1 string
-- @ver2 string
-- @return string 
function ReaPack:compare_versions(ver1, ver2)
    local retval, error = r.ReaPack_CompareVersions(ver1, ver2)
    if retval then
        return error
    end
end

-- type: see ReaPack_GetEntryInfo.
-- @entry PackageEntry
-- @index integer
-- @return string, number, number 
function ReaPack:enum_owned_files(entry, index)
    local retval, path, sections, type = r.ReaPack_EnumOwnedFiles(entry, index)
    if retval then
        return path, sections, type
    end
end

-- Free resources allocated for the given package entry.
-- @entry PackageEntry
-- @return boolean 
function ReaPack:free_entry(entry)
    return r.ReaPack_FreeEntry(entry)
end

-- type: 1=script, 2=extension, 3=effect, 4=data, 5=theme, 6=langpack, 7=webinterface
-- @entry PackageEntry
-- @return string, string, string, string, number, string, string, boolean, number 
function ReaPack:get_entry_info(entry)
    local retval, repo, cat, pkg, desc, type, ver, author, pinned, file_count = r.ReaPack_GetEntryInfo(entry)
    if retval then
        return repo, cat, pkg, desc, type, ver, author, pinned, file_count
    end
end

-- Delete the returned object from memory after use with ReaPack_FreeEntry.
-- @fn string
-- @return string 
function ReaPack:get_owner(fn)
    local retval, error = r.ReaPack_GetOwner(fn)
    if retval then
        return error
    end
end

-- autoInstall: 0=manual, 1=when sychronizing, 2=obey user setting
-- @name string
-- @return string, boolean, number 
function ReaPack:get_repository_info(name)
    local retval, url, enabled, auto_install = r.ReaPack_GetRepositoryInfo(name)
    if retval then
        return url, enabled, auto_install
    end
end

-- Run pending operations and save the configuration file. If refreshUI is true the browser and manager windows are guaranteed to be refreshed (otherwise it depends on which operations are in the queue).
-- @refresh_u_i boolean
function ReaPack:process_queue(refresh_u_i)
    return r.ReaPack_ProcessQueue(refresh_u_i)
end

