local r = reaper
-- PCMSource

PCMSource = {}

function PCMSource:new(
	take --[[MediaItemTake]],
	source --[[userdata]]
)
	local o = {
		media_item_take = take,
		pointer = source,
	}
	setmetatable(o, self)
	self.__index = self
	return o
end

--@return string
function PCMSource:get_filename()
	return r.GetMediaSourceFileName(self.pointer, "")
end

--@return number
function PCMSource:get_length()
	return r.GetMediaSourceFileName(self.pointer, "")
end

--@return number
function PCMSource:get_channels_num()
	return r.GetMediaSourceNumChannels(self.pointer)
end

-- TODO
function PCMSource:parent()
	return r.GetMediaSourceParent(self.pointer)
end

-- @return number
function PCMSource:sample_rate()
	return r.GetMediaSourceSampleRate(self.pointer)
end

-- @return string
function PCMSource:get_type()
	return r.GetMediaSourceType(self.pointer, "")
end

function PCMSource:destroy()
	r.PCM_Source_Destroy(self.pointer)
end

-- Get section info
--[[
    @return : a Table with 3 items (number, number, boolean) on success,
    nil otherwise
--]]
function PCMSource:get_section_info()
	local retval, offset, length, is_reversed = r.PCM_Source_GetSectionInfo(self.pointer)
	if retval then
		return { offset, length, is_reversed }
	else
		return nil
	end
end

return PCMSource
