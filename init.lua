-- Aggregate all functionality in the module
local ReaWrap = {}

-- Import and expose submodules
ReaWrap.constants = require('models.constants')
ReaWrap.fx = require('models.fx')
ReaWrap.helpers = require('models.helpers')
ReaWrap.im_gui = require('models.im_gui')
ReaWrap.item = require('models.item')
ReaWrap.pcm = require('models.pcm')
ReaWrap.project = require('models.project')
ReaWrap.reaper = require('models.reaper')
ReaWrap.take = require('models.take')
ReaWrap.track = require('models.track')

local reawrap = ReaWrap.reaper:new()
reawrap:log('ReaWrap loaded')

return ReaWrap