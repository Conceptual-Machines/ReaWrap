require('ReaWrap.models.constants')
require('ReaWrap.models.reaper')
require('ReaWrap.models.fx')
require('ReaWrap.models.helpers')
require('ReaWrap.models.item')
require('ReaWrap.models.envelope')

local r = reaper

Track = {
    pointer_type = PointerTypes.MediaTrack
}

---Create new instance of Track
---@param media_track userdata : Pointer to Reaper MediaTrack*
---@return table Track
function Track:new(media_track)
    local o = {
        pointer = media_track
    }
    setmetatable(o, self)
    self.__index = self
    return o
end


---String representation of Track object
---@return string
function Track:__tostring()
    return string.format(
            '<Track name=%s>',
            self:get_name()
    )
end

---Whether track references a valid MediaTrack* pointer
function Track:is_valid()
    return Reaper:is_valid_pointer(self.pointer, self.pointer_type)
end

function Track:log(...)
    logger = log_func('Track')
    logger(...)
end

function Track:from_media_item(media_item)
    local media_track = r.GetMediaItemTrack(media_item.pointer)
    return self:new(media_track)
end


---Get track numerical-value attributes.
---@param param string : Accepted param values: constants.TrackInfoNumber
---@return number
function Track:get_info_value(param)
    return r.GetMediaTrackInfo_Value(self.pointer, param)
end


---Get track info values as string.
---@return string : Accepted param values : constants.TrackInfoString
function Track:get_info_string(param --[[string]])
    if TrackInfoString[param] == nil
        then error('Invalid param. Please use constants.TrackInfoString')
    end
    local retval, info = r.GetSetMediaTrackInfo_String(
            self.pointer, param, '', false
    )
    if retval then
        return info
    end
end


---Set track numerical-value attributes.
---@param param string : Accepted param values : constants.TrackInfoNumber
---@param value string
---@return boolean
function Track:set_info_value(param, value)
     local retval, _ = reaper.SetMediaTrackInfo_Value(
             self.pointer, param, value
     )
    return retval
end

---Set track info values as string.
---@param param string
---@param value string
---@return boolean
function Track:set_info_string(param --[[string]], value --[[string]])
    local retval, _ = r.GetSetMediaTrackInfo_String(
            self.pointer, param, value, true
    )
    return retval
end

---Get track name.
---@return string
function Track:get_name()
    local _, name = r.GetTrackName(self.pointer)
    return name
end


---Get track index.
---@param b number (optional) : Index base. 1 by default. Accepted values 0 or 1.
---@return number
function Track:get_index(b)
    b = b or 1
    if b ~= 0 and b~= 1 then
        error('Wrong value for index base. Please use 0 or 1')
    end
    local track_number = self:get_info_value(TrackInfoValue.IP_TRACKNUMBER)
    if b == 1 then
        return track_number
    else
        return track_number - 1
    end
end

---Get track color.
---@return string
function Track:get_color()
    return r.GetTrackColor(self.pointer)
end

---Get track icon. Full filename, or relative to resource_path/data/track_icons.
---@return string
function Track:get_icon()
    local retval, info_string = r.GetSetMediaTrackInfo_String(
            self.pointer, TrackInfoString.P_ICON, '', false
    )
    if retval then
        return info_string
    else
        return nil
    end
end

---Get MCP layout.
---@return string
function Track:get_mcp_layout()
    local retval, info_string = r.GetSetMediaTrackInfo_String(
            self.pointer, TrackInfoString.P_MCP_LAYOUT, '', false
    )
    if retval then
        return info_string
    else
        return nil
    end
end

---Get TCP layout.
---@return string
function Track:get_tcp_layout()
    local retval, info_string = r.GetSetMediaTrackInfo_String(
            self.pointer, TrackInfoString.P_TCP_LAYOUT, '', false
    )
    if retval then
        return info_string
    else
        return nil
    end
end

function Track:get_key_value_store()
    local retval, info_string = r.GetSetMediaTrackInfo_String(
            self.pointer, TrackInfoString.P_EXT, '', false
    )
    if retval then
        return info_string
    else
        return nil
    end
end

---Total number of FX in Track
---@return number
function Track:get_fx_count()
    return r.TrackFX_GetCount(self.pointer)
end

---Get Track FX Chain
---@return table array<FX>
function Track:get_fx_chain()
    local fx_chain = {}
    for i = 0, self:get_fx_count() - 1 do
        local fx = TrackFX:new(self, i)
        fx_chain[i + 1] = fx
    end
    return fx_chain
end


function Track:iter_fx_chain()
    return iter(self:get_fx_chain())
end


function Track:has_instrument()
    for _, fx in ipairs(self:get_fx_chain()) do
        if fx:is_instrument() then
            return true
        end
    end
    return false
end


---Get track state chunk
---@return string
function Track:get_state_chunk(is_undo --[[boolean]])
    is_undo = is_undo or false
    local retval, state = r.GetTrackStateChunk(self.pointer, '', is_undo)
    if retval then
        return StateChunk:new(state)
    end
end

---Set Track name
---@param name string: track name
function Track:set_name(name)
    self:set_info_string('P_NAME', name)
end

---Set Track icon
---@param color string
function Track:set_color(color)
    r.SetTrackColor(self.media_item, color)
end

---Set Track color
---@param icon string: full filename, or relative to resource_path/data/track_icons
function Track:set_color(name)
    self:set_info_string('P_ICON', name)
end

---Set MCP layout
---@param name string: layout name
function Track:set_mcp_layout(name)
    r:set_info_string('P_MCP_LAYOUT', name)
end

---Set TCP layout
---@param name string: layout name
function Track:set_tcp_layout(name)
    r:set_info_string('P_TCP_LAYOUT', name)
end

---Set razor edits
--[[
    @razoredits table:
    list of razor edit areas
    as space-separated triples of start time, end time,
    and envelope GUID string.
--]]
function Track:set_razor_edits(razoredits)
    r:set_info_string('P_MCP_LAYOUT', name)
end

---Set persistent track data
---@param ext string: extension name
function Track:set_key_value(ext)
    r:set_info_string('P_TCP_LAYOUT', name)
end


---Get Track Globally Unique ID
---@return string
function Track:GUID()
    return r.GetTrackGUID(self.pointer)
end

---Add media item to track and return it.
---@return table MediaItem
function Track:add_media_item()
    local media_item = r.AddMediaItemToTrack(self.pointer)
    return MediaItem:new(media_item)
end

---Create new Send.
---@param dest Track/null. Index of destination track. If null a new HW send will be created.
---@return Send
function Track:create_send(dest)
    if type(dest) == 'table' then
        if dest.pointer == nil then
            error('Please provide a valid Track object')
        end
        dest = dest.pointer
    elseif dest ~= nil then
        error('Accepted types for dest. Track or nil for HW output.')
    end
    local idx = r.CreateTrackSend(self.pointer, dest)
    return Send:new(self, idx)
end

function Track:remove_send(idx, category)
    category = category or SendReceiveCategory.send
    r.RemoveTrackSend(self.pointer, category, idx)
end

function Track:count_sends()
    return r.GetTrackNumSends(self.pointer, SendReceiveCategory.send)
end

function Track:count_receives()
    return r.GetTrackNumSends(self.pointer, SendReceiveCategory.receive)
end

function Track:get_sends()
    local sends = {}
    for i = 0 , self:count_sends() - 1 do
        sends[i + 1] = Send:new(self, i)
    end
    return sends
end

function Track:iter_sends()
    return iter(self:get_sends())
end

function Track:get_receives()
    local receives = {}
    for i=0, self:count_receives() - 1 do
        receives[i + 1] = Receive:new(self, i)
    end
    return receives
end

function Track:iter_receives()
    return iter(self:get_receives())
end

function Track:get_send_name(send_index)
    category = category or SendReceiveCategory.send
    local retval, buf = reaper.GetTrackSendName(self.pointer, send_index, '')
    if retval then
        return buf
    end
end

function Track:get_receive_name(rcv_index)
    category = category or SendReceiveCategory.send
    local retval, buf = reaper.GetTrackReceiveName(self.pointer, rcv_index, '')
    if retval then
        return buf
    end
end


---@param category SendReceiveCategory
---@param send_idx number
---@param category SendReceiveCategory
---@param param SendReceiveInfoValue
function Track:get_send_rcv_info_value(send_idx, category, param)
    --if SendReceiveCategory[category] == nil then
    ---   error(
    ---           'Please select a valid category. ' ..
    ---                   table.concat(SendReceiveCategory, ' - ')
    ---   )
    --end
    --if SendReceiveInfoValue[param] == nil then
    ---   error(
    ---           'Please select a valid info value. ' ..
    ---                   table.concat(SendReceiveInfoValue, ' - ')
    ---   )
    --end
    param = param or SendReceiveInfoValue.P_DESTTRACK
    return r.GetTrackSendInfo_Value(self.pointer, category, send_idx, param)
end

function Track:get_send_info_value(send_idx, param)
    return self:get_send_rcv_info_value(send_idx, SendReceiveCategory.send, param)
end

function Track:get_rcv_info_value(send_idx, param)
    return self:get_send_rcv_info_value(send_idx, SendReceiveCategory.receive, param)
end


---@param send_idx number
---@param param string constants.SendReceiveInfoValue
function Track:set_send_info_value(send_idx, param, value)
    r.SetTrackSendInfo_Value(
            self.pointer, SendReceiveCategory.send, send_idx, param, value
    )
end

---@param send_idx number
---@param param SendReceiveInfoValue
function Track:set_rcv_info_value(send_idx, param, value)
    r.SetTrackSendInfo_Value(
            self.pointer, SendReceiveCategory.receive, send_idx, param, value
    )
end


function Track:get_send_info_string(send_idx, param)
    local ret, val = r.GetSetTrackSendInfo_String(
            self.pointer, SendReceiveCategory.send, send_idx, param, '', false
    )
    if ret then
        return val
    end
end


function Track:set_send_info_string(category, send_idx, param, value)
    local ret, val = r.GetSetTrackSendInfo_String(
            self.pointer, category, send_idx, param, value, true
    )
    if ret then
        return val
    end
end

function Track:get_rcv_info_string(send_idx, param)
    local ret, val = r.GetSetTrackSendInfo_String(
            self.pointer, SendReceiveCategory.receive, send_idx, param, '', false
    )
    if ret then
        return val
    end
end


---@param env_id number/string Either the idx or the name of the envelope
---@return Envelope
function Track:get_envelope(env_id)
    local env
    if type(env_id) == number then
        env = r.GetTrackEnvelope(self.pointer, env_id)
    elseif type(env_id) == string then
        env = r.GetTrackEnvelopeByName(self.pointer, env_id)
    end
    return Envelope:new(env)
end

---@param env_id number/string Either the idx or the name of the envelope
---@return Envelope
function Track:get_fx_envelope(fx_idx, param_idx, create)
    create = create or true
    local env = r.GetFXEnvelope(self.pointer, fx_idx, param_idx, create)
    return Envelope:new(env)
end

---@param category number : constants.SendReceiveCategory
---@param send_idx number
---@param envelope_type number : constants.EnvelopeType
function Track:get_send_info_envelope(category, send_idx, envelope_type)
    local pointer = r.BR_GetMediaTrackSendInfo_Envelope(
            self.pointer, category, send_idx, envelope_type
    )
    return Envelope:new(pointer)
end


Send = {}

---Create new instance of Send
---@param track Parent Track object
---@param idx number
---@return Send
function Send:new(track, idx)
    local o = {
        track = track,
        idx = idx
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---String representation of Track object
---@return string
function Send:__tostring()
    return string.format(
            '<Send name=%s>',
            self:get_name()
    )
end

function Send:get_name()
    return self.track:get_send_name(self.idx)
end

function Send:get_info_value(param)
    return self.track:get_send_info_value(self.idx, param)
end

function Send:get_info_string(param)
    return self.track:get_send_info_string(self.idx, param)
end

function Send:set_info_value(param, value)
    return self.track:set_send_info_value(self.idx, param, value)
end

function Send:set_info_string(param, value)
    return self.track:set_send_info_string(self.idx, param, value)
end

---@param env_type number: constants.EnvelopeType (default volume = 0)
function Send:get_envelope(env_type)
    env_type = env_type or EnvelopeType.volume
    return self.track:get_send_info_envelope(
            SendReceiveCategory.send, self.idx, env_type
    )
end

Receive = {}

function Receive:new(track, idx)
    local o = {
        track = track,
        idx = idx
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---String representation of Track object
---@return string
function Receive:__tostring()
    return string.format(
            '<Receive name=%s>',
            self:get_name()
    )
end

function Receive:get_name()
    return self.track:get_receive_name(self.idx)
end

function Receive:get_info_value()
    return self.track:get_rcv_info_value(self.idx)
end

---@param env_type number: constants.EnvelopeType (default volume = 0)
function Receive:get_envelope(env_type)
    env_type = env_type or EnvelopeType.volume
    return self.track:get_envelope(
            SendReceiveCategory.receive, self.idx, env_type
    )
end


StateChunk = {}

function StateChunk:new(raw)
    local o = {
        raw = raw
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---String representation of Track object
---@return string
function StateChunk:__tostring()
    return self.raw
end
