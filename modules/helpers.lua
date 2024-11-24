--- Contains helper functions for common tasks.
-- @author Nomad Monad
-- @license MIT
-- @release 0.0.1
-- @module helpers

local r = reaper

-- @class helpers
-- Helper functions for common tasks.
local helpers = {}

--- Return a function that joins a variable number of arguments, separated by the argument `sep` (default ', ').
--- @param sep string
--- @return function
function helpers.string_join(sep)
	sep = sep or ", "
	return function(...)
		local joined = ""
		for i, v in ipairs({ ... }) do
			if i == 1 then
				joined = tostring(v)
			else
				joined = joined .. sep .. tostring(v)
			end
		end
		return joined
	end
end

--- Print to console and add new line separator.
function helpers.console_msg(arg)
	r.ShowConsoleMsg(tostring(arg) .. "\n")
end

--- Return a print function that joins the arguments with a separator.
--- @param sep string Default is ', '
--- @return function
function helpers.print_func(sep)
	return function(...)
		local joiner = helpers.string_join(sep)
		helpers.console_msg(joiner(...))
	end
end

--- Return a log function that prepends the current date and a name to the arguments.
--- @param name string
--- @param sep string Default is ' --- '
--- @return function
function helpers.log_func(name, sep)
	sep = sep or " --- "
	return function(...)
		local printer = helpers.print_func(sep)
		printer(os.date(), name, ...)
	end
end

--- Constants for message box types.
--- @field OK number
--- @field OKCANCEL number
--- @field ABORTRETRYIGNORE number
--- @field YESNOCANCEL number
--- @field YESNO number
--- @field RETRYCANCEL number
helpers.MsgBoxTypes = {
	OK = 0,
	OKCANCEL = 1,
	ABORTRETRYIGNORE = 2,
	YESNOCANCEL = 3,
	YESNO = 4,
	RETRYCANCEL = 5,
}

--- Show a Message Box dialogue
--- @param msg string
--- @param title number
--- @param msgbox_type number helpers.MsgBoxTypes
--- @return number
--- @see helpers.MsgBoxTypes
function helpers.msg_box(msg, title, msgbox_type)
	type = type or 0
	return r.ShowMessageBox(msg, title, msgbox_type)
end

--- Create an iterator function for a table.
-- https://www.lua.org/pil/7.1.html
--- @param t table
--- @return function
function helpers.iter(t)
	local i = 0
	local n = #t
	return function()
		i = i + 1
		if i <= n then
			return t[i]
		end
	end
end

--- Slice a table.
--- @param source_table table
--- @param start_idx number
--- @param end_idx number
--- @return table
function helpers.slice_table(source_table, start_idx, end_idx)
	start_idx = start_idx or 1
	end_idx = end_idx or #source_table
	local dest_table = {}
	for idx, item in ipairs(source_table) do
		if idx >= start_idx and idx <= end_idx then
			dest_table[#dest_table + 1] = item
		end
	end
	return dest_table
end

--- Check if a file exists.
--- @param fpath string
--- @return boolean
function helpers.file_exists(fpath)
	local f = io.open(fpath, "rb")
	if f then
		f:close()
	else
		helpers.msg_box("File not found: " .. tostring(fpath), "Error")
	end
	return f ~= nil
end

--- Read a file.
--- @param fpath string
--- @return string
function helpers.read_file(fpath)
	if file_exists(fpath) then
		local content = f:read("*all")
		f:close()
		return content
	else
		return nil
	end
end

return helpers
