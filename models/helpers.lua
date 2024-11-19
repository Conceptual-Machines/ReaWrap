local r = reaper

--[[
    Return a function that joins a variable number of arguments, separated by
    the argument `sep` (default ', ')
--]]

local helpers = {}

function helpers.string_join(sep)
    sep = sep or ', '
    return function(...)
        local joined = ''
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

-- Print to console and add new line separator
function helpers.console_msg(arg)
    r.ShowConsoleMsg(tostring(arg) .. '\n')
end

--[[
    Return a print closure function that takes a variable number of arguments.
    The printer shows a console msg where the arguments are separated by
    `sep` (default ', ').

    @return function
--]]
function helpers.print_func(sep)
    return function(...)
        joiner = helpers.string_join(sep)
        helpers.console_msg(joiner(...))
    end
end

--[[
    Return a logger closure function that takes a variable number of arguments.
    The logger shows a console msg where the arguments are separated by the
    arg `sep` (default ' --- '). Additionally provides timestamp and `name`.

    @return function
--]]
function helpers.log_func(name, sep)
    sep = sep or ' --- '
    return function(...)
        printer = helpers.print_func(sep)
        printer(os.date(), name, ...)
    end
end

-- Show a Message Box dialogue
-- @msg string
-- @title string
-- @type number : Accepted values : constants.MsgBoxTypes
-- @return number : Expected values : constants.MsgBoxReturnTypes
function helpers.msg_box(msg, title, type)
    type = type or 0
    return r.ShowMessageBox(msg, title, type)
end

-- Iterator function
-- https://www.lua.org/pil/7.1.html
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

Binary = {}


function Binary:new(bits)
    local o = {
        bits = bits or {}
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Binary:__tostring()
    return string.reverse(table.concat(self.bits))
end

function Binary:from_decimal(dec)
    return self:new(dec_to_bin(dec))
end

function Binary:to_decimal(dec)
    return bin_to_dec(self.bits)
end

-- return a table with the indices (1 based) of value 1 bits
-- e.g. [0,1,0,1] -> {2,4}
function Binary:to_bits_indices()
    local indices = {}
    for i, bit in ipairs(self.bits) do
        if bit == 1 then
            indices[#indices + 1] = i
        end
    end
    return indices
end

-- @return table
function dec_to_bin(dec)
    local bits = {}
    while dec > 0 do
        bit = dec % 2
        bits[#bits + 1] = bit
        dec = math.floor(dec / 2)
    end
    return bits
end

-- @return number
function bin_to_dec(bits)
    local buf = 0
    for i = 0, #bits - 1 do
        if bits[i + 1] == 1 then
            buf = buf + 2 ^ i
        end
    end
    return math.floor(buf)
end

function file_exists(fpath)
    local f = io.open(fpath, 'rb')
    if f then
        f:close()
    else
        msg_box('File not found: ' .. tostring(fpath), 'Error')
    end
    return f ~= nil
end

function read_file(fpath)
    if file_exists(fpath) then
        local content = f:read("*all")
        f:close()
        return content
    else
        return nil
    end
end

function slice_table(source_table, start_idx, end_idx)
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

BarsAndBeats = {}
--- Helper class for Bars and Beats
--- @return table
function BarsAndBeats:new(bars, beats)
    local o = {
        bars = bars or 0,
        beats = beats or 0,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

--- Get number of beats from seconds
---@param seconds any
---@param bpm any
---@param timesig any
function BarsAndBeats:seconds_to_beats(seconds, bpm, timesig)
    return seconds / 60 * bpm / timesig
end

--- Get number of bars from seconds
--- @param seconds number
--- @param bpm number
--- @param timesig number
function BarsAndBeats:seconds_to_bars(seconds, bpm, timesig)
    local beats = self.seconds_to_beats(seconds, bpm, timesig)
    return self.beats_to_bars(beats, timesig)
end

--- Get number of bars from beats
---@param beats any
---@param beats_per_bar any
function BarsAndBeats:beats_to_bars_and_beats(beats, beats_per_bar)
    local bars = beats // beats_per_bar
    local rem_beats = beats % beats_per_bar
    return bars, rem_beats
end

--- Get number of beats from bars
function BarsAndBeats:bars_to_beats(bars, beats_per_bar)
    return bars * beats_per_bar
end

--- Create new BarsAndBeats object from seconds, bpm and timesig
---@param seconds any
---@param bpm any
---@param timesig any
function BarsAndBeats:from_seconds(seconds, bpm, timesig)
    local total_beats = self.seconds_to_beats(seconds, bpm, timesig)
    local bars, beats = self:beats_to_bars_and_beats(total_beats, timesig)
    return self:new(bars, beats)
end

return helpers