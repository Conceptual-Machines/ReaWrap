-- Aggregate all functionality in the module
local ReaWrap = {}

-- Import and expose submodules
ReaWrap.constants = require('ReaWrap.models.constants')
ReaWrap.fx = require('ReaWrap.models.fx')
ReaWrap.helpers = require('ReaWrap.models.helpers')
ReaWrap.im_gui = require('ReaWrap.models.im_gui')
ReaWrap.item = require('ReaWrap.models.item')
ReaWrap.pcm = require('ReaWrap.models.pcm')
ReaWrap.project = require('ReaWrap.models.project')
ReaWrap.reaper = require('ReaWrap.models.reaper')
ReaWrap.take = require('ReaWrap.models.take')
ReaWrap.track = require('ReaWrap.models.track')

local reawrap = ReaWrap.reaper:new()
reawrap:log('ReaWrap loaded')

return ReaWrap