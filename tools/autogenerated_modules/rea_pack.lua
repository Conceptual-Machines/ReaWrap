-- @description ReaPack: Provide implementation for ReaPack functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local ReaPack = {}



--- Create new ReaPack instance.
-- @return ReaPack table.
function ReaPack:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the ReaPack logger.
-- @param ... (varargs) Messages to log.
function ReaPack:log(...)
    local logger = helpers.log_func('ReaPack')
    logger(...)
    return nil
end

    
--- About Installed Package.
-- Show the about dialog of the given package entry. The repository index is
-- downloaded asynchronously if the cached copy doesn't exist or is older than one
-- week.
-- @param entry PackageEntry
-- @return boolean
function ReaPack:about_installed_package(entry)
    return r.ReaPack_AboutInstalledPackage(entry)
end

    
--- About Repository.
-- Show the about dialog of the given repository. Returns true if the repository
-- exists in the user configuration. The repository index is downloaded
-- asynchronously if the cached copy doesn't exist or is older than one week.
-- @param repo_name string
-- @return boolean
function ReaPack:about_repository(repo_name)
    return r.ReaPack_AboutRepository(repo_name)
end

    
--- Add Set Repository.
-- Add or modify a repository. Set url to nullptr (or empty string in Lua) to keep
-- the existing URL. Call ReaPack_ProcessQueue(true) when done to process the new
-- list and update the GUI.
-- @param name string
-- @param url string
-- @param enable boolean
-- @param auto_install integer
-- @return error string
function ReaPack:add_set_repository(name, url, enable, auto_install)
    local retval, error = r.ReaPack_AddSetRepository(name, url, enable, auto_install)
    if retval then
        return error
    else
        return nil
    end
end

    
--- Browse Packages.
-- Opens the package browser with the given filter string.
-- @param filter string
function ReaPack:browse_packages(filter)
    return r.ReaPack_BrowsePackages(filter)
end

    
--- Compare Versions.
-- Returns 0 if both versions are equal, a positive value if ver1 is higher than
-- ver2 and a negative value otherwise.
-- @param ver1 string
-- @param ver2 string
-- @return error string
function ReaPack:compare_versions(ver1, ver2)
    local retval, error = r.ReaPack_CompareVersions(ver1, ver2)
    if retval then
        return error
    else
        return nil
    end
end

    
--- Enum Owned Files.
-- Enumerate the files owned by the given package. Returns false when there is no
-- more data.
-- @param entry PackageEntry
-- @param index integer
-- @return path string
-- @return sections integer
-- @return type integer
function ReaPack:enum_owned_files(entry, index)
    local retval, path, sections, type = r.ReaPack_EnumOwnedFiles(entry, index)
    if retval then
        return path, sections, type
    else
        return nil
    end
end

    
--- Free Entry.
-- Free resources allocated for the given package entry.
-- @param entry PackageEntry
-- @return boolean
function ReaPack:free_entry(entry)
    return r.ReaPack_FreeEntry(entry)
end

    
--- Get Entry Info.
-- Get the repository name, category, package name, package description, package
-- type, the currently installed version, author name, flags (&1=Pinned,
-- &2=BleedingEdge) and how many files are owned by the given package entry.
-- @param entry PackageEntry
-- @return repo string
-- @return cat string
-- @return pkg string
-- @return desc string
-- @return type integer
-- @return ver string
-- @return author string
-- @return flags integer
-- @return file_count integer
function ReaPack:get_entry_info(entry)
    local retval, repo, cat, pkg, desc, type, ver, author, flags, file_count = r.ReaPack_GetEntryInfo(entry)
    if retval then
        return repo, cat, pkg, desc, type, ver, author, flags, file_count
    else
        return nil
    end
end

    
--- Get Owner.
-- Returns the package entry owning the given file. Delete the returned object from
-- memory after use with ReaPack_FreeEntry.
-- @param fn string
-- @return error string
function ReaPack:get_owner(fn)
    local retval, error = r.ReaPack_GetOwner(fn)
    if retval then
        return error
    else
        return nil
    end
end

    
--- Get Repository Info.
-- Get the infos of the given repository.
-- @param name string
-- @return url string
-- @return enabled boolean
-- @return auto_install integer
function ReaPack:get_repository_info(name)
    local retval, url, enabled, auto_install = r.ReaPack_GetRepositoryInfo(name)
    if retval then
        return url, enabled, auto_install
    else
        return nil
    end
end

    
--- Process Queue.
-- Run pending operations and save the configuration file. If refreshUI is true the
-- browser and manager windows are guaranteed to be refreshed (otherwise it depends
-- on which operations are in the queue).
-- @param refresh_ui boolean
function ReaPack:process_queue(refresh_ui)
    return r.ReaPack_ProcessQueue(refresh_ui)
end

return ReaPack
