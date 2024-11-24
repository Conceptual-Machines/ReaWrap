local current_dir = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
local root_dir = current_dir:match('^(.+/)tests/')
package.path = package.path .. ';' .. root_dir .. 'modules/?.lua'

local Project = require('project')


local p = Project:new()
p:log('Project test')
p:log(tostring(p))


local function test_iter_sel_tracks()
    for sel_track in p:iter_selected_tracks() do
        p:log(sel_track)
        for fx in sel_track:iter_track_fx_chain() do
            p:log(fx)
            p:log("PDC: ", fx:get_named_config_param(fx.NamedConfigParamConstants:create().PDC))
--             p:log("FX_TYPE: ", fx:get_named_config_param(fx.NamedConfigParamConstants().FX_TYPE))
--             p:log("FX_IDENT: ", fx:get_named_config_param(fx.NamedConfigParamConstants().FX_IDENT))
--             p:log("FX_NAME: ", fx:get_named_config_param(fx.NamedConfigParamConstants().FX_NAME))
--             p:log("GAIN_REDUCTION_DB: ", fx:get_named_config_param(fx.NamedConfigParamConstants().GAINREDUCTION_DB))
            local cont_item = fx.NamedConfigParamConstants:create({container_idx = 0}).CONTAINER_ITEM_X
            local fx_idx = fx:get_named_config_param(cont_item)
            p:log(fx:get_name(fx_idx))
--             p:log("PARENT_CONTAINER: ", fx:get_named_config_param(fx.NamedConfigParamConstants().PARENT_CONTAINER))
--             p:log("CONTAINER_COUNT: ", fx:get_named_config_param(fx.NamedConfigParamConstants().CONTAINER_COUNT))
        end
--         for item in sel_track:iter_items() do
--             p:log(item)
--             for take in item:iter_takes() do
--                 p:log(take)
--             end
--         end
    end
end
test_iter_sel_tracks()
--
-- local function test_iter_sel_tracks()
--     for sel_track in p:iter_selected_tracks() do
--         p:log(sel_track:get_name())
--     end
-- end
-- test_iter_sel_tracks()

--
-- local function test_get_media_items_length()
--     for media_item in p:iter_selected_media_items() do
--         p:log(media_item)
--         local length = media_item:get_length()
--         local position = media_item:get_position()
--         local tot_length = position + length
--         local bars_and_beats = r.TimeMap2_timeToBeats(0, tot_length)
--     end
-- end
--
-- test_get_media_items_length()
--
-- local function test_create_media_item()
--     for sel_track in p:iter_selected_tracks() do
--         p:log(sel_track)
--         local item = sel_track:add_media_item()
--         item:set_position(1)
--         item:set_length(8)
--         p:log(item)
--     end
-- end
-- -- test_create_media_item()
--
-- local function test_media_item_take_get_name()
--     for item in p:iter_selected_media_items() do
--         for take in item:iter_takes() do
--             p:log(take:get_name())
--         end
--     end
-- end
--
-- -- test_media_item_take_get_name()
--
-- local function test_media_item_take_set_name()
--     for item in p:iter_selected_media_items() do
--         for take in item:iter_takes() do
--             take:set_name('Some random name')
--         end
--     end
-- end
--
-- -- test_media_item_take_set_name()
--
-- local function test_track_get_state_chunk()
--     r:log(debug.getinfo(1, "n").name)
--     for track in p:iter_selected_tracks() do
--         r:log(track:get_state_chunk())
--     end
-- end
--
-- local function test_create_track_sends()
--     r:log(debug.getinfo(1, "n").name)
--     for track in p:iter_selected_tracks() do
--         local dest_track = p:get_track(track:get_index(0) + 1)
--         local send = track:create_send(dest_track)
--         r:log(send)
--     end
-- end
--
--
-- local function test_get_send_info_values()
--     r:log(debug.getinfo(1, "n").name)
--     for track in p:iter_selected_tracks() do
--         for send in track:iter_sends() do
--             local value = send:get_info_value(SendReceiveInfoValue.I_SENDMODE)
--             r:log(value)
--         end
--     end
-- end
--
-- local function test_get_track_info()
--     r:log(debug.getinfo(1, "n").name)
--     for track in p:iter_selected_tracks() do
--         r:log(track)
--         r:log('I_RECMODE', track:get_info_value('I_RECMODE'))
--
--     end
-- end
--
-- --test_get_track_info()
--
-- local function test_fx_getters()
--     r:log(debug.getinfo(1, "n").name)
--     for track in p:iter_selected_tracks() do
--         r:print(track)
--         for fx in track:iter_fx_chain() do
--             r:log('FX name', fx:get_name())
--             r:log('FX IO', fx:get_io_size())
--             r:log('FX params')
--             r:log('value', fxparam:get_value())
--             r:log('step size', table.concat(fxparam:get_step_size(), ', '))
--             r:log('FX has inputs', fx:has_inputs())
--             r:log('FX pdc latency', fx:get_pdc_latency())
--             for pin in fx:iter_input_pins() do
--                 r:log(pin)
--                 local mappings = pin:get_mappings()
--                 r:log('Pin mappings', table.concat(mappings, ', '))
--             end
--             for pin in fx:iter_output_pins() do
--                 r:log(pin)
--                 local mappings = pin:get_mappings()
--                 r:log('Pin mappings', table.concat(mappings, ', '))
--             end
--         end
--     end
-- end
--
--
-- local function set_media_item_ext()
--     for item in p:iter_selected_media_items() do
--         item:set_info_string(MediaItemInfoString.P_EXT..':hello', 'sdasdasdasd')
--         r:log('info hello', item:get_info_string(MediaItemInfoString.P_EXT..':hello'))
--     end
-- end
-- --set_media_item_ext()
--
-- local function test_media_item_get_state_chunk()
--     for item in p:iter_selected_media_items() do
--         local state = item:get_state_chunk()
--         r:print(state)
--     end
-- end
-- --test_media_item_get_state_chunk()
--
-- local function test_get_fx_envelope()
--     for track in p:iter_selected_tracks() do
--         local env = track:get_fx_envelope(0, 0)
--         r:log(env)
--     end
-- end
--
-- --test_get_fx_envelope()
--
-- local function test_get_selected_envelope()
--     sel_env = p:get_selected_envelope()
--     r:log(sel_env)
--     sel_track_env = p:get_selected_track_envelope()
--     r:log('selected', sel_track_env)
-- end
--
-- --test_get_selected_envelope()
--
-- local function test_get_fx_params()
--     for track in p:iter_selected_tracks() do
--         for fx in track:iter_fx_chain() do
--             for param in fx:iter_params() do
--                 r:log(param)
--             end
--         end
--     end
-- end
--
-- --test_get_fx_params()
--
-- local function test_get_envelope_points()
--     local sel_env = p:get_selected_envelope()
--     for point in sel_env:iter_points() do
--         r:log(point)
--     end
-- end
-- --test_get_envelope_points()