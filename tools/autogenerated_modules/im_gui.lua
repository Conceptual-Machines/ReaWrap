-- @description Provide implementation for ImGui functions.
-- @author NomadMonad
-- @license MIT

local r = reaper
local helpers = require('helpers')


local ImGui = {}



--- Create new ImGui instance.
-- @return ImGui table.
function ImGui:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- @section ReaWrap Custom Methods

--- Log messages with the ImGui logger.
-- @param ... (varargs) Messages to log.
function ImGui:log(...)
    local logger = helpers.log_func('ImGui')
    logger(...)
    return nil
end


-- @section ReaScript API Methods




--- Accept Drag Drop Payload. Wraps ImGui_AcceptDragDropPayload.
-- Accept contents of a given type. If DragDropFlags_AcceptBeforeDelivery is set
-- you can peek into the payload before the mouse button is released.
-- @param ctx ImGui_Context
-- @param type string
-- @param payload string
-- @param integer flagsIn Optional
-- @return payload string
function ImGui:accept_drag_drop_payload(ctx, type, payload, integer)
    local integer = integer or nil
    local ret_val, payload = r.ImGui_AcceptDragDropPayload(ctx, type, payload, integer)
    if ret_val then
        return payload
    else
        return nil
    end
end


--- Accept Drag Drop Payload Files. Wraps ImGui_AcceptDragDropPayloadFiles.
-- Accept a list of dropped files. See AcceptDragDropPayload and
-- GetDragDropPayloadFile.
-- @param ctx ImGui_Context
-- @param count number
-- @param integer flagsIn Optional
-- @return count number
function ImGui:accept_drag_drop_payload_files(ctx, count, integer)
    local integer = integer or nil
    local ret_val, count = r.ImGui_AcceptDragDropPayloadFiles(ctx, count, integer)
    if ret_val then
        return count
    else
        return nil
    end
end


--- Accept Drag Drop Payload Rgb. Wraps ImGui_AcceptDragDropPayloadRGB.
-- Accept a RGB color. See AcceptDragDropPayload.
-- @param ctx ImGui_Context
-- @param rgb number
-- @param integer flagsIn Optional
-- @return rgb number
function ImGui:accept_drag_drop_payload_rgb(ctx, rgb, integer)
    local integer = integer or nil
    local ret_val, rgb = r.ImGui_AcceptDragDropPayloadRGB(ctx, rgb, integer)
    if ret_val then
        return rgb
    else
        return nil
    end
end


--- Accept Drag Drop Payload Rgba. Wraps ImGui_AcceptDragDropPayloadRGBA.
-- Accept a RGBA color. See AcceptDragDropPayload.
-- @param ctx ImGui_Context
-- @param rgba number
-- @param integer flagsIn Optional
-- @return rgba number
function ImGui:accept_drag_drop_payload_rgba(ctx, rgba, integer)
    local integer = integer or nil
    local ret_val, rgba = r.ImGui_AcceptDragDropPayloadRGBA(ctx, rgba, integer)
    if ret_val then
        return rgba
    else
        return nil
    end
end


--- Align Text To Frame Padding. Wraps ImGui_AlignTextToFramePadding.
-- Vertically align upcoming text baseline to StyleVar_FramePadding.y so that it
-- will align properly to regularly framed items (call if you have text on a line
-- before a framed item).
-- @param ctx ImGui_Context
function ImGui:align_text_to_frame_padding(ctx)
    return r.ImGui_AlignTextToFramePadding(ctx)
end


--- Arrow Button. Wraps ImGui_ArrowButton.
-- Square button with an arrow shape. 'dir' is one of the Dir_* values
-- @param ctx ImGui_Context
-- @param str_id string
-- @param dir number
-- @return boolean
function ImGui:arrow_button(ctx, str_id, dir)
    return r.ImGui_ArrowButton(ctx, str_id, dir)
end


--- Attach. Wraps ImGui_Attach.
-- Link the object's lifetime to the given context. Objects can be draw list
-- splitters, fonts, images, list clippers, etc. Call Detach to let the object be
-- garbage-collected after unuse again.
-- @param ctx ImGui_Context
-- @param obj ImGui_Resource
function ImGui:attach(ctx, obj)
    return r.ImGui_Attach(ctx, obj)
end


--- Begin. Wraps ImGui_Begin.
-- Push window to the stack and start appending to it.
-- @param ctx ImGui_Context
-- @param name string
-- @param boolean p_open Optional
-- @param integer flagsIn Optional
-- @return boolean p_open
function ImGui:begin(ctx, name, boolean, integer)
    local boolean = boolean or nil
    local integer = integer or nil
    local ret_val, boolean = r.ImGui_Begin(ctx, name, boolean, integer)
    if ret_val then
        return boolean
    else
        return nil
    end
end


--- Begin Child. Wraps ImGui_BeginChild.
-- Manual sizing (each axis can use a different setting e.g. size_w=0 and
-- size_h=400): - = 0.0: use remaining parent window size for this axis - \> 0.0:
-- use specified size for this axis - < 0.0: right/bottom-align to specified
-- distance from available content boundaries
-- @param ctx ImGui_Context
-- @param str_id string
-- @param number size_wIn Optional
-- @param number size_hIn Optional
-- @param integer child_flagsIn Optional
-- @param integer window_flagsIn Optional
-- @return boolean
function ImGui:begin_child(ctx, str_id, number, number, integer, integer)
    local number = number or nil
    local integer = integer or nil
    return r.ImGui_BeginChild(ctx, str_id, number, number, integer, integer)
end


--- Begin Combo. Wraps ImGui_BeginCombo.
-- The BeginCombo/EndCombo API allows you to manage your contents and selection
-- state however you want it, by creating e.g. Selectable items.
-- @param ctx ImGui_Context
-- @param label string
-- @param preview_value string
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:begin_combo(ctx, label, preview_value, integer)
    local integer = integer or nil
    return r.ImGui_BeginCombo(ctx, label, preview_value, integer)
end


--- Begin Disabled. Wraps ImGui_BeginDisabled.
-- Disable all user interactions and dim items visuals (applying
-- StyleVar_DisabledAlpha over current colors).
-- @param ctx ImGui_Context
-- @param boolean disabledIn Optional
function ImGui:begin_disabled(ctx, boolean)
    local boolean = boolean or nil
    return r.ImGui_BeginDisabled(ctx, boolean)
end


--- Begin Drag Drop Source. Wraps ImGui_BeginDragDropSource.
-- Call after submitting an item which may be dragged. when this return true, you
-- can call SetDragDropPayload() + EndDragDropSource()
-- @param ctx ImGui_Context
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:begin_drag_drop_source(ctx, integer)
    local integer = integer or nil
    return r.ImGui_BeginDragDropSource(ctx, integer)
end


--- Begin Drag Drop Target. Wraps ImGui_BeginDragDropTarget.
-- Call after submitting an item that may receive a payload. If this returns true,
-- you can call AcceptDragDropPayload + EndDragDropTarget.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:begin_drag_drop_target(ctx)
    return r.ImGui_BeginDragDropTarget(ctx)
end


--- Begin Group. Wraps ImGui_BeginGroup.
-- Lock horizontal starting position. See EndGroup.
-- @param ctx ImGui_Context
function ImGui:begin_group(ctx)
    return r.ImGui_BeginGroup(ctx)
end


--- Begin Item Tooltip. Wraps ImGui_BeginItemTooltip.
-- Begin/append a tooltip window if preceding item was hovered. Shortcut for
-- `IsItemHovered(HoveredFlags_ForTooltip) && BeginTooltip()`.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:begin_item_tooltip(ctx)
    return r.ImGui_BeginItemTooltip(ctx)
end


--- Begin List Box. Wraps ImGui_BeginListBox.
-- Open a framed scrolling region.
-- @param ctx ImGui_Context
-- @param label string
-- @param number size_wIn Optional
-- @param number size_hIn Optional
-- @return boolean
function ImGui:begin_list_box(ctx, label, number, number)
    local number = number or nil
    return r.ImGui_BeginListBox(ctx, label, number, number)
end


--- Begin Menu. Wraps ImGui_BeginMenu.
-- Create a sub-menu entry. only call EndMenu if this returns true!
-- @param ctx ImGui_Context
-- @param label string
-- @param boolean enabledIn Optional
-- @return boolean
function ImGui:begin_menu(ctx, label, boolean)
    local boolean = boolean or nil
    return r.ImGui_BeginMenu(ctx, label, boolean)
end


--- Begin Menu Bar. Wraps ImGui_BeginMenuBar.
-- Append to menu-bar of current window (requires WindowFlags_MenuBar flag set on
-- parent window). See EndMenuBar.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:begin_menu_bar(ctx)
    return r.ImGui_BeginMenuBar(ctx)
end


--- Begin Popup. Wraps ImGui_BeginPopup.
-- Query popup state, if open start appending into the window. Call EndPopup
-- afterwards if returned true. WindowFlags* are forwarded to the window.
-- @param ctx ImGui_Context
-- @param str_id string
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:begin_popup(ctx, str_id, integer)
    local integer = integer or nil
    return r.ImGui_BeginPopup(ctx, str_id, integer)
end


--- Begin Popup Context Item. Wraps ImGui_BeginPopupContextItem.
-- This is a helper to handle the simplest case of associating one named popup to
-- one given widget. You can pass a nil str_id to use the identifier of the last
-- item. This is essentially the same as calling OpenPopupOnItemClick + BeginPopup
-- but written to avoid computing the ID twice because BeginPopupContext* functions
-- may be called very frequently.
-- @param ctx ImGui_Context
-- @param string str_idIn Optional
-- @param integer popup_flagsIn Optional
-- @return boolean
function ImGui:begin_popup_context_item(ctx, string, integer)
    local string = string or nil
    local integer = integer or nil
    return r.ImGui_BeginPopupContextItem(ctx, string, integer)
end


--- Begin Popup Context Window. Wraps ImGui_BeginPopupContextWindow.
-- Open+begin popup when clicked on current window.
-- @param ctx ImGui_Context
-- @param string str_idIn Optional
-- @param integer popup_flagsIn Optional
-- @return boolean
function ImGui:begin_popup_context_window(ctx, string, integer)
    local string = string or nil
    local integer = integer or nil
    return r.ImGui_BeginPopupContextWindow(ctx, string, integer)
end


--- Begin Popup Modal. Wraps ImGui_BeginPopupModal.
-- Block every interaction behind the window, cannot be closed by user, add a
-- dimming background, has a title bar. Return true if the modal is open, and you
-- can start outputting to it. See BeginPopup.
-- @param ctx ImGui_Context
-- @param name string
-- @param boolean p_open Optional
-- @param integer flagsIn Optional
-- @return boolean p_open
function ImGui:begin_popup_modal(ctx, name, boolean, integer)
    local boolean = boolean or nil
    local integer = integer or nil
    local ret_val, boolean = r.ImGui_BeginPopupModal(ctx, name, boolean, integer)
    if ret_val then
        return boolean
    else
        return nil
    end
end


--- Begin Tab Bar. Wraps ImGui_BeginTabBar.
-- Create and append into a TabBar.
-- @param ctx ImGui_Context
-- @param str_id string
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:begin_tab_bar(ctx, str_id, integer)
    local integer = integer or nil
    return r.ImGui_BeginTabBar(ctx, str_id, integer)
end


--- Begin Tab Item. Wraps ImGui_BeginTabItem.
-- Create a Tab. Returns true if the Tab is selected. Set 'p_open' to true to
-- enable the close button.
-- @param ctx ImGui_Context
-- @param label string
-- @param boolean p_open Optional
-- @param integer flagsIn Optional
-- @return boolean p_open
function ImGui:begin_tab_item(ctx, label, boolean, integer)
    local boolean = boolean or nil
    local integer = integer or nil
    local ret_val, boolean = r.ImGui_BeginTabItem(ctx, label, boolean, integer)
    if ret_val then
        return boolean
    else
        return nil
    end
end


--- Begin Table. Wraps ImGui_BeginTable.
-- @param ctx ImGui_Context
-- @param str_id string
-- @param columns number
-- @param integer flagsIn Optional
-- @param number outer_size_wIn Optional
-- @param number outer_size_hIn Optional
-- @param number inner_widthIn Optional
-- @return boolean
function ImGui:begin_table(ctx, str_id, columns, integer, number, number, number)
    local integer = integer or nil
    local number = number or nil
    return r.ImGui_BeginTable(ctx, str_id, columns, integer, number, number, number)
end


--- Begin Tooltip. Wraps ImGui_BeginTooltip.
-- Begin/append a tooltip window.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:begin_tooltip(ctx)
    return r.ImGui_BeginTooltip(ctx)
end


--- Bullet. Wraps ImGui_Bullet.
-- Draw a small circle + keep the cursor on the same line. Advance cursor x
-- position by GetTreeNodeToLabelSpacing, same distance that TreeNode uses.
-- @param ctx ImGui_Context
function ImGui:bullet(ctx)
    return r.ImGui_Bullet(ctx)
end


--- Bullet Text. Wraps ImGui_BulletText.
-- Shortcut for Bullet + Text.
-- @param ctx ImGui_Context
-- @param text string
function ImGui:bullet_text(ctx, text)
    return r.ImGui_BulletText(ctx, text)
end


--- Button. Wraps ImGui_Button.
-- @param ctx ImGui_Context
-- @param label string
-- @param number size_wIn Optional
-- @param number size_hIn Optional
-- @return boolean
function ImGui:button(ctx, label, number, number)
    local number = number or nil
    return r.ImGui_Button(ctx, label, number, number)
end


--- Button Flags Mouse Button Left. Wraps ImGui_ButtonFlags_MouseButtonLeft.
-- React on left mouse button (default).
-- @return number
function ImGui:button_flags_mouse_button_left()
    return r.ImGui_ButtonFlags_MouseButtonLeft()
end


--- Button Flags Mouse Button Middle. Wraps ImGui_ButtonFlags_MouseButtonMiddle.
-- React on center mouse button.
-- @return number
function ImGui:button_flags_mouse_button_middle()
    return r.ImGui_ButtonFlags_MouseButtonMiddle()
end


--- Button Flags Mouse Button Right. Wraps ImGui_ButtonFlags_MouseButtonRight.
-- React on right mouse button.
-- @return number
function ImGui:button_flags_mouse_button_right()
    return r.ImGui_ButtonFlags_MouseButtonRight()
end


--- Button Flags None. Wraps ImGui_ButtonFlags_None.
-- @return number
function ImGui:button_flags_none()
    return r.ImGui_ButtonFlags_None()
end


--- Calc Item Width. Wraps ImGui_CalcItemWidth.
-- Width of item given pushed settings and current cursor position. NOT necessarily
-- the width of last item unlike most 'Item' functions.
-- @param ctx ImGui_Context
-- @return number
function ImGui:calc_item_width(ctx)
    return r.ImGui_CalcItemWidth(ctx)
end


--- Calc Text Size. Wraps ImGui_CalcTextSize.
-- @param ctx ImGui_Context
-- @param text string
-- @param w number
-- @param h number
-- @param boolean hide_text_after_double_hashIn Optional
-- @param number wrap_widthIn Optional
-- @return w number
-- @return h number
function ImGui:calc_text_size(ctx, text, w, h, boolean, number)
    local boolean = boolean or nil
    local number = number or nil
    return r.ImGui_CalcTextSize(ctx, text, w, h, boolean, number)
end


--- Checkbox. Wraps ImGui_Checkbox.
-- @param ctx ImGui_Context
-- @param label string
-- @param v boolean
-- @return v boolean
function ImGui:checkbox(ctx, label, v)
    local ret_val, v = r.ImGui_Checkbox(ctx, label, v)
    if ret_val then
        return v
    else
        return nil
    end
end


--- Checkbox Flags. Wraps ImGui_CheckboxFlags.
-- @param ctx ImGui_Context
-- @param label string
-- @param flags number
-- @param flags_value number
-- @return flags number
function ImGui:checkbox_flags(ctx, label, flags, flags_value)
    local ret_val, flags = r.ImGui_CheckboxFlags(ctx, label, flags, flags_value)
    if ret_val then
        return flags
    else
        return nil
    end
end


--- Child Flags Always Auto Resize. Wraps ImGui_ChildFlags_AlwaysAutoResize.
-- Combined with AutoResizeX/AutoResizeY. Always measure size even when child is
-- hidden, always return true, always disable clipping optimization! NOT
-- RECOMMENDED.
-- @return number
function ImGui:child_flags_always_auto_resize()
    return r.ImGui_ChildFlags_AlwaysAutoResize()
end


--- Child Flags Always Use Window Padding. Wraps ImGui_ChildFlags_AlwaysUseWindowPadding.
-- Pad with StyleVar_WindowPadding even if no border are drawn (no padding by
-- default for non-bordered child windows because it makes more sense).
-- @return number
function ImGui:child_flags_always_use_window_padding()
    return r.ImGui_ChildFlags_AlwaysUseWindowPadding()
end


--- Child Flags Auto Resize X. Wraps ImGui_ChildFlags_AutoResizeX.
-- Enable auto-resizing width. Read notes above.
-- @return number
function ImGui:child_flags_auto_resize_x()
    return r.ImGui_ChildFlags_AutoResizeX()
end


--- Child Flags Auto Resize Y. Wraps ImGui_ChildFlags_AutoResizeY.
-- Enable auto-resizing height. Read notes above.
-- @return number
function ImGui:child_flags_auto_resize_y()
    return r.ImGui_ChildFlags_AutoResizeY()
end


--- Child Flags Border. Wraps ImGui_ChildFlags_Border.
-- Show an outer border and enable WindowPadding.
-- @return number
function ImGui:child_flags_border()
    return r.ImGui_ChildFlags_Border()
end


--- Child Flags Frame Style. Wraps ImGui_ChildFlags_FrameStyle.
-- Style the child window like a framed item: use Col_FrameBg,
-- StyleVar_FrameRounding, StyleVar_FrameBorderSize, StyleVar_FramePadding
-- instead of Col_ChildBg, StyleVar_ChildRounding, StyleVar_ChildBorderSize,
-- StyleVar_WindowPadding.
-- @return number
function ImGui:child_flags_frame_style()
    return r.ImGui_ChildFlags_FrameStyle()
end


--- Child Flags Nav Flattened. Wraps ImGui_ChildFlags_NavFlattened.
-- Share focus scope, allow gamepad/keyboard navigation to cross over parent
-- border to this child or between sibling child windows.
-- @return number
function ImGui:child_flags_nav_flattened()
    return r.ImGui_ChildFlags_NavFlattened()
end


--- Child Flags None. Wraps ImGui_ChildFlags_None.
-- @return number
function ImGui:child_flags_none()
    return r.ImGui_ChildFlags_None()
end


--- Child Flags Resize X. Wraps ImGui_ChildFlags_ResizeX.
-- Allow resize from right border (layout direction). Enables .ini saving (unless
-- WindowFlags_NoSavedSettings passed to window flags).
-- @return number
function ImGui:child_flags_resize_x()
    return r.ImGui_ChildFlags_ResizeX()
end


--- Child Flags Resize Y. Wraps ImGui_ChildFlags_ResizeY.
-- Allow resize from bottom border (layout direction). Enables .ini saving (unless
-- WindowFlags_NoSavedSettings passed to window flags).
-- @return number
function ImGui:child_flags_resize_y()
    return r.ImGui_ChildFlags_ResizeY()
end


--- Close Current Popup. Wraps ImGui_CloseCurrentPopup.
-- Manually close the popup we have begin-ed into. Use inside the
-- BeginPopup/EndPopup scope to close manually.
-- @param ctx ImGui_Context
function ImGui:close_current_popup(ctx)
    return r.ImGui_CloseCurrentPopup(ctx)
end


--- Col Border. Wraps ImGui_Col_Border.
-- @return number
function ImGui:col_border()
    return r.ImGui_Col_Border()
end


--- Col Border Shadow. Wraps ImGui_Col_BorderShadow.
-- @return number
function ImGui:col_border_shadow()
    return r.ImGui_Col_BorderShadow()
end


--- Col Button. Wraps ImGui_Col_Button.
-- @return number
function ImGui:col_button()
    return r.ImGui_Col_Button()
end


--- Col Button Active. Wraps ImGui_Col_ButtonActive.
-- @return number
function ImGui:col_button_active()
    return r.ImGui_Col_ButtonActive()
end


--- Col Button Hovered. Wraps ImGui_Col_ButtonHovered.
-- @return number
function ImGui:col_button_hovered()
    return r.ImGui_Col_ButtonHovered()
end


--- Col Check Mark. Wraps ImGui_Col_CheckMark.
-- Checkbox tick and RadioButton circle
-- @return number
function ImGui:col_check_mark()
    return r.ImGui_Col_CheckMark()
end


--- Col Child Bg. Wraps ImGui_Col_ChildBg.
-- Background of child windows.
-- @return number
function ImGui:col_child_bg()
    return r.ImGui_Col_ChildBg()
end


--- Col Docking Empty Bg. Wraps ImGui_Col_DockingEmptyBg.
-- Background color for empty node (e.g. CentralNode with no window docked into
-- it).
-- @return number
function ImGui:col_docking_empty_bg()
    return r.ImGui_Col_DockingEmptyBg()
end


--- Col Docking Preview. Wraps ImGui_Col_DockingPreview.
-- Preview overlay color when about to docking something.
-- @return number
function ImGui:col_docking_preview()
    return r.ImGui_Col_DockingPreview()
end


--- Col Drag Drop Target. Wraps ImGui_Col_DragDropTarget.
-- Rectangle highlighting a drop target
-- @return number
function ImGui:col_drag_drop_target()
    return r.ImGui_Col_DragDropTarget()
end


--- Col Frame Bg. Wraps ImGui_Col_FrameBg.
-- Background of checkbox, radio button, plot, slider, text input.
-- @return number
function ImGui:col_frame_bg()
    return r.ImGui_Col_FrameBg()
end


--- Col Frame Bg Active. Wraps ImGui_Col_FrameBgActive.
-- @return number
function ImGui:col_frame_bg_active()
    return r.ImGui_Col_FrameBgActive()
end


--- Col Frame Bg Hovered. Wraps ImGui_Col_FrameBgHovered.
-- @return number
function ImGui:col_frame_bg_hovered()
    return r.ImGui_Col_FrameBgHovered()
end


--- Col Header. Wraps ImGui_Col_Header.
-- Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem.
-- @return number
function ImGui:col_header()
    return r.ImGui_Col_Header()
end


--- Col Header Active. Wraps ImGui_Col_HeaderActive.
-- @return number
function ImGui:col_header_active()
    return r.ImGui_Col_HeaderActive()
end


--- Col Header Hovered. Wraps ImGui_Col_HeaderHovered.
-- @return number
function ImGui:col_header_hovered()
    return r.ImGui_Col_HeaderHovered()
end


--- Col Menu Bar Bg. Wraps ImGui_Col_MenuBarBg.
-- @return number
function ImGui:col_menu_bar_bg()
    return r.ImGui_Col_MenuBarBg()
end


--- Col Modal Window Dim Bg. Wraps ImGui_Col_ModalWindowDimBg.
-- Darken/colorize entire screen behind a modal window, when one is active.
-- @return number
function ImGui:col_modal_window_dim_bg()
    return r.ImGui_Col_ModalWindowDimBg()
end


--- Col Nav Highlight. Wraps ImGui_Col_NavHighlight.
-- Gamepad/keyboard: current highlighted item.
-- @return number
function ImGui:col_nav_highlight()
    return r.ImGui_Col_NavHighlight()
end


--- Col Nav Windowing Dim Bg. Wraps ImGui_Col_NavWindowingDimBg.
-- Darken/colorize entire screen behind the CTRL+TAB window list, when active.
-- @return number
function ImGui:col_nav_windowing_dim_bg()
    return r.ImGui_Col_NavWindowingDimBg()
end


--- Col Nav Windowing Highlight. Wraps ImGui_Col_NavWindowingHighlight.
-- Highlight window when using CTRL+TAB.
-- @return number
function ImGui:col_nav_windowing_highlight()
    return r.ImGui_Col_NavWindowingHighlight()
end


--- Col Plot Histogram. Wraps ImGui_Col_PlotHistogram.
-- @return number
function ImGui:col_plot_histogram()
    return r.ImGui_Col_PlotHistogram()
end


--- Col Plot Histogram Hovered. Wraps ImGui_Col_PlotHistogramHovered.
-- @return number
function ImGui:col_plot_histogram_hovered()
    return r.ImGui_Col_PlotHistogramHovered()
end


--- Col Plot Lines. Wraps ImGui_Col_PlotLines.
-- @return number
function ImGui:col_plot_lines()
    return r.ImGui_Col_PlotLines()
end


--- Col Plot Lines Hovered. Wraps ImGui_Col_PlotLinesHovered.
-- @return number
function ImGui:col_plot_lines_hovered()
    return r.ImGui_Col_PlotLinesHovered()
end


--- Col Popup Bg. Wraps ImGui_Col_PopupBg.
-- Background of popups, menus, tooltips windows.
-- @return number
function ImGui:col_popup_bg()
    return r.ImGui_Col_PopupBg()
end


--- Col Resize Grip. Wraps ImGui_Col_ResizeGrip.
-- Resize grip in lower-right and lower-left corners of windows.
-- @return number
function ImGui:col_resize_grip()
    return r.ImGui_Col_ResizeGrip()
end


--- Col Resize Grip Active. Wraps ImGui_Col_ResizeGripActive.
-- @return number
function ImGui:col_resize_grip_active()
    return r.ImGui_Col_ResizeGripActive()
end


--- Col Resize Grip Hovered. Wraps ImGui_Col_ResizeGripHovered.
-- @return number
function ImGui:col_resize_grip_hovered()
    return r.ImGui_Col_ResizeGripHovered()
end


--- Col Scrollbar Bg. Wraps ImGui_Col_ScrollbarBg.
-- @return number
function ImGui:col_scrollbar_bg()
    return r.ImGui_Col_ScrollbarBg()
end


--- Col Scrollbar Grab. Wraps ImGui_Col_ScrollbarGrab.
-- @return number
function ImGui:col_scrollbar_grab()
    return r.ImGui_Col_ScrollbarGrab()
end


--- Col Scrollbar Grab Active. Wraps ImGui_Col_ScrollbarGrabActive.
-- @return number
function ImGui:col_scrollbar_grab_active()
    return r.ImGui_Col_ScrollbarGrabActive()
end


--- Col Scrollbar Grab Hovered. Wraps ImGui_Col_ScrollbarGrabHovered.
-- @return number
function ImGui:col_scrollbar_grab_hovered()
    return r.ImGui_Col_ScrollbarGrabHovered()
end


--- Col Separator. Wraps ImGui_Col_Separator.
-- @return number
function ImGui:col_separator()
    return r.ImGui_Col_Separator()
end


--- Col Separator Active. Wraps ImGui_Col_SeparatorActive.
-- @return number
function ImGui:col_separator_active()
    return r.ImGui_Col_SeparatorActive()
end


--- Col Separator Hovered. Wraps ImGui_Col_SeparatorHovered.
-- @return number
function ImGui:col_separator_hovered()
    return r.ImGui_Col_SeparatorHovered()
end


--- Col Slider Grab. Wraps ImGui_Col_SliderGrab.
-- @return number
function ImGui:col_slider_grab()
    return r.ImGui_Col_SliderGrab()
end


--- Col Slider Grab Active. Wraps ImGui_Col_SliderGrabActive.
-- @return number
function ImGui:col_slider_grab_active()
    return r.ImGui_Col_SliderGrabActive()
end


--- Col Tab. Wraps ImGui_Col_Tab.
-- Tab background, when tab-bar is focused & tab is unselected
-- @return number
function ImGui:col_tab()
    return r.ImGui_Col_Tab()
end


--- Col Tab Dimmed. Wraps ImGui_Col_TabDimmed.
-- Tab background, when tab-bar is unfocused & tab is unselected
-- @return number
function ImGui:col_tab_dimmed()
    return r.ImGui_Col_TabDimmed()
end


--- Col Tab Dimmed Selected. Wraps ImGui_Col_TabDimmedSelected.
-- Tab background, when tab-bar is unfocused & tab is selected
-- @return number
function ImGui:col_tab_dimmed_selected()
    return r.ImGui_Col_TabDimmedSelected()
end


--- Col Tab Dimmed Selected Overline. Wraps ImGui_Col_TabDimmedSelectedOverline.
-- Horizontal overline, when tab-bar is unfocused & tab is selected
-- @return number
function ImGui:col_tab_dimmed_selected_overline()
    return r.ImGui_Col_TabDimmedSelectedOverline()
end


--- Col Tab Hovered. Wraps ImGui_Col_TabHovered.
-- Tab background, when hovered
-- @return number
function ImGui:col_tab_hovered()
    return r.ImGui_Col_TabHovered()
end


--- Col Tab Selected. Wraps ImGui_Col_TabSelected.
-- Tab background, when tab-bar is focused & tab is selected
-- @return number
function ImGui:col_tab_selected()
    return r.ImGui_Col_TabSelected()
end


--- Col Tab Selected Overline. Wraps ImGui_Col_TabSelectedOverline.
-- Tab horizontal overline, when tab-bar is focused & tab is selected
-- @return number
function ImGui:col_tab_selected_overline()
    return r.ImGui_Col_TabSelectedOverline()
end


--- Col Table Border Light. Wraps ImGui_Col_TableBorderLight.
-- Table inner borders (prefer using Alpha=1.0 here).
-- @return number
function ImGui:col_table_border_light()
    return r.ImGui_Col_TableBorderLight()
end


--- Col Table Border Strong. Wraps ImGui_Col_TableBorderStrong.
-- Table outer and header borders (prefer using Alpha=1.0 here).
-- @return number
function ImGui:col_table_border_strong()
    return r.ImGui_Col_TableBorderStrong()
end


--- Col Table Header Bg. Wraps ImGui_Col_TableHeaderBg.
-- Table header background.
-- @return number
function ImGui:col_table_header_bg()
    return r.ImGui_Col_TableHeaderBg()
end


--- Col Table Row Bg. Wraps ImGui_Col_TableRowBg.
-- Table row background (even rows).
-- @return number
function ImGui:col_table_row_bg()
    return r.ImGui_Col_TableRowBg()
end


--- Col Table Row Bg Alt. Wraps ImGui_Col_TableRowBgAlt.
-- Table row background (odd rows).
-- @return number
function ImGui:col_table_row_bg_alt()
    return r.ImGui_Col_TableRowBgAlt()
end


--- Col Text. Wraps ImGui_Col_Text.
-- @return number
function ImGui:col_text()
    return r.ImGui_Col_Text()
end


--- Col Text Disabled. Wraps ImGui_Col_TextDisabled.
-- @return number
function ImGui:col_text_disabled()
    return r.ImGui_Col_TextDisabled()
end


--- Col Text Selected Bg. Wraps ImGui_Col_TextSelectedBg.
-- @return number
function ImGui:col_text_selected_bg()
    return r.ImGui_Col_TextSelectedBg()
end


--- Col Title Bg. Wraps ImGui_Col_TitleBg.
-- Title bar
-- @return number
function ImGui:col_title_bg()
    return r.ImGui_Col_TitleBg()
end


--- Col Title Bg Active. Wraps ImGui_Col_TitleBgActive.
-- Title bar when focused
-- @return number
function ImGui:col_title_bg_active()
    return r.ImGui_Col_TitleBgActive()
end


--- Col Title Bg Collapsed. Wraps ImGui_Col_TitleBgCollapsed.
-- Title bar when collapsed
-- @return number
function ImGui:col_title_bg_collapsed()
    return r.ImGui_Col_TitleBgCollapsed()
end


--- Col Window Bg. Wraps ImGui_Col_WindowBg.
-- Background of normal windows. See also WindowFlags_NoBackground.
-- @return number
function ImGui:col_window_bg()
    return r.ImGui_Col_WindowBg()
end


--- Collapsing Header. Wraps ImGui_CollapsingHeader.
-- Returns true when opened but do not indent nor push into the ID stack (because
-- of the TreeNodeFlags_NoTreePushOnOpen flag).
-- @param ctx ImGui_Context
-- @param label string
-- @param boolean p_visible Optional
-- @param integer flagsIn Optional
-- @return boolean p_visible
function ImGui:collapsing_header(ctx, label, boolean, integer)
    local boolean = boolean or nil
    local integer = integer or nil
    local ret_val, boolean = r.ImGui_CollapsingHeader(ctx, label, boolean, integer)
    if ret_val then
        return boolean
    else
        return nil
    end
end


--- Color Button. Wraps ImGui_ColorButton.
-- Display a color square/button, hover for details, return true when pressed.
-- Color is in 0xRRGGBBAA or, if ColorEditFlags_NoAlpha is set, 0xRRGGBB.
-- @param ctx ImGui_Context
-- @param desc_id string
-- @param col_rgba number
-- @param integer flagsIn Optional
-- @param number size_wIn Optional
-- @param number size_hIn Optional
-- @return boolean
function ImGui:color_button(ctx, desc_id, col_rgba, integer, number, number)
    local integer = integer or nil
    local number = number or nil
    return r.ImGui_ColorButton(ctx, desc_id, col_rgba, integer, number, number)
end


--- Color Convert Double4 To U32. Wraps ImGui_ColorConvertDouble4ToU32.
-- Pack 0..1 RGBA values into a 32-bit integer (0xRRGGBBAA).
-- @param r number
-- @param g number
-- @param b number
-- @param a number
-- @return number
function ImGui:color_convert_double4_to_u32(r, g, b, a)
    return r.ImGui_ColorConvertDouble4ToU32(r, g, b, a)
end


--- Color Convert Hs Vto Rgb. Wraps ImGui_ColorConvertHSVtoRGB.
-- Convert HSV values (0..1) into RGB (0..1).
-- @param h number
-- @param s number
-- @param v number
-- @return r number
-- @return g number
-- @return b number
function ImGui:color_convert_hs_vto_rgb(h, s, v)
    return r.ImGui_ColorConvertHSVtoRGB(h, s, v)
end


--- Color Convert Native. Wraps ImGui_ColorConvertNative.
-- Convert a native color coming from REAPER or 0xRRGGBB to native. This swaps the
-- red and blue channels on Windows.
-- @param rgb number
-- @return number
function ImGui:color_convert_native(rgb)
    return r.ImGui_ColorConvertNative(rgb)
end


--- Color Convert Rg Bto Hsv. Wraps ImGui_ColorConvertRGBtoHSV.
-- Convert RGB values (0..1) into HSV (0..1).
-- @param r number
-- @param g number
-- @param b number
-- @return h number
-- @return s number
-- @return v number
function ImGui:color_convert_rg_bto_hsv(r, g, b)
    return r.ImGui_ColorConvertRGBtoHSV(r, g, b)
end


--- Color Convert U32 To Double4. Wraps ImGui_ColorConvertU32ToDouble4.
-- Unpack a 32-bit integer (0xRRGGBBAA) into separate RGBA values (0..1).
-- @param rgba number
-- @return r number
-- @return g number
-- @return b number
-- @return a number
function ImGui:color_convert_u32_to_double4(rgba)
    return r.ImGui_ColorConvertU32ToDouble4(rgba)
end


--- Color Edit3. Wraps ImGui_ColorEdit3.
-- Color is in 0xXXRRGGBB. XX is ignored and will not be modified.
-- @param ctx ImGui_Context
-- @param label string
-- @param col_rgb number
-- @param integer flagsIn Optional
-- @return col_rgb number
function ImGui:color_edit3(ctx, label, col_rgb, integer)
    local integer = integer or nil
    local ret_val, col_rgb = r.ImGui_ColorEdit3(ctx, label, col_rgb, integer)
    if ret_val then
        return col_rgb
    else
        return nil
    end
end


--- Color Edit4. Wraps ImGui_ColorEdit4.
-- Color is in 0xRRGGBBAA or, if ColorEditFlags_NoAlpha is set, 0xXXRRGGBB (XX is
-- ignored and will not be modified).
-- @param ctx ImGui_Context
-- @param label string
-- @param col_rgba number
-- @param integer flagsIn Optional
-- @return col_rgba number
function ImGui:color_edit4(ctx, label, col_rgba, integer)
    local integer = integer or nil
    local ret_val, col_rgba = r.ImGui_ColorEdit4(ctx, label, col_rgba, integer)
    if ret_val then
        return col_rgba
    else
        return nil
    end
end


--- Color Edit Flags Alpha Bar. Wraps ImGui_ColorEditFlags_AlphaBar.
-- ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
-- @return number
function ImGui:color_edit_flags_alpha_bar()
    return r.ImGui_ColorEditFlags_AlphaBar()
end


--- Color Edit Flags Alpha Preview. Wraps ImGui_ColorEditFlags_AlphaPreview.
-- ColorEdit, ColorPicker, ColorButton: display preview as a transparent color
-- over a checkerboard, instead of opaque.
-- @return number
function ImGui:color_edit_flags_alpha_preview()
    return r.ImGui_ColorEditFlags_AlphaPreview()
end


--- Color Edit Flags Alpha Preview Half. Wraps ImGui_ColorEditFlags_AlphaPreviewHalf.
-- ColorEdit, ColorPicker, ColorButton: display half opaque / half checkerboard,
-- instead of opaque.
-- @return number
function ImGui:color_edit_flags_alpha_preview_half()
    return r.ImGui_ColorEditFlags_AlphaPreviewHalf()
end


--- Color Edit Flags Display Hsv. Wraps ImGui_ColorEditFlags_DisplayHSV.
-- ColorEdit: override _display_ type to HSV. ColorPicker:    select any
-- combination using one or more of RGB/HSV/Hex.
-- @return number
function ImGui:color_edit_flags_display_hsv()
    return r.ImGui_ColorEditFlags_DisplayHSV()
end


--- Color Edit Flags Display Hex. Wraps ImGui_ColorEditFlags_DisplayHex.
-- ColorEdit: override _display_ type to Hex. ColorPicker:    select any
-- combination using one or more of RGB/HSV/Hex.
-- @return number
function ImGui:color_edit_flags_display_hex()
    return r.ImGui_ColorEditFlags_DisplayHex()
end


--- Color Edit Flags Display Rgb. Wraps ImGui_ColorEditFlags_DisplayRGB.
-- ColorEdit: override _display_ type to RGB. ColorPicker:    select any
-- combination using one or more of RGB/HSV/Hex.
-- @return number
function ImGui:color_edit_flags_display_rgb()
    return r.ImGui_ColorEditFlags_DisplayRGB()
end


--- Color Edit Flags Float. Wraps ImGui_ColorEditFlags_Float.
-- ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0..1.0
-- floats instead of 0..255 integers. No round-trip of value via integers.
-- @return number
function ImGui:color_edit_flags_float()
    return r.ImGui_ColorEditFlags_Float()
end


--- Color Edit Flags Input Hsv. Wraps ImGui_ColorEditFlags_InputHSV.
-- ColorEdit, ColorPicker: input and output data in HSV format.
-- @return number
function ImGui:color_edit_flags_input_hsv()
    return r.ImGui_ColorEditFlags_InputHSV()
end


--- Color Edit Flags Input Rgb. Wraps ImGui_ColorEditFlags_InputRGB.
-- ColorEdit, ColorPicker: input and output data in RGB format.
-- @return number
function ImGui:color_edit_flags_input_rgb()
    return r.ImGui_ColorEditFlags_InputRGB()
end


--- Color Edit Flags No Alpha. Wraps ImGui_ColorEditFlags_NoAlpha.
-- ColorEdit, ColorPicker, ColorButton: ignore Alpha component   (will only read 3
-- components from the input pointer).
-- @return number
function ImGui:color_edit_flags_no_alpha()
    return r.ImGui_ColorEditFlags_NoAlpha()
end


--- Color Edit Flags No Border. Wraps ImGui_ColorEditFlags_NoBorder.
-- ColorButton: disable border (which is enforced by default).
-- @return number
function ImGui:color_edit_flags_no_border()
    return r.ImGui_ColorEditFlags_NoBorder()
end


--- Color Edit Flags No Drag Drop. Wraps ImGui_ColorEditFlags_NoDragDrop.
-- ColorEdit: disable drag and drop target. ColorButton: disable drag and drop
-- source.
-- @return number
function ImGui:color_edit_flags_no_drag_drop()
    return r.ImGui_ColorEditFlags_NoDragDrop()
end


--- Color Edit Flags No Inputs. Wraps ImGui_ColorEditFlags_NoInputs.
-- ColorEdit, ColorPicker: disable inputs sliders/text widgets    (e.g. to show
-- only the small preview color square).
-- @return number
function ImGui:color_edit_flags_no_inputs()
    return r.ImGui_ColorEditFlags_NoInputs()
end


--- Color Edit Flags No Label. Wraps ImGui_ColorEditFlags_NoLabel.
-- ColorEdit, ColorPicker: disable display of inline text label    (the label is
-- still forwarded to the tooltip and picker).
-- @return number
function ImGui:color_edit_flags_no_label()
    return r.ImGui_ColorEditFlags_NoLabel()
end


--- Color Edit Flags No Options. Wraps ImGui_ColorEditFlags_NoOptions.
-- ColorEdit: disable toggling options menu when right-clicking on inputs/small
-- preview.
-- @return number
function ImGui:color_edit_flags_no_options()
    return r.ImGui_ColorEditFlags_NoOptions()
end


--- Color Edit Flags No Picker. Wraps ImGui_ColorEditFlags_NoPicker.
-- ColorEdit: disable picker when clicking on color square.
-- @return number
function ImGui:color_edit_flags_no_picker()
    return r.ImGui_ColorEditFlags_NoPicker()
end


--- Color Edit Flags No Side Preview. Wraps ImGui_ColorEditFlags_NoSidePreview.
-- ColorPicker: disable bigger color preview on right side of the picker,    use
-- small color square preview instead.
-- @return number
function ImGui:color_edit_flags_no_side_preview()
    return r.ImGui_ColorEditFlags_NoSidePreview()
end


--- Color Edit Flags No Small Preview. Wraps ImGui_ColorEditFlags_NoSmallPreview.
-- ColorEdit, ColorPicker: disable color square preview next to the inputs.
-- (e.g. to show only the inputs).
-- @return number
function ImGui:color_edit_flags_no_small_preview()
    return r.ImGui_ColorEditFlags_NoSmallPreview()
end


--- Color Edit Flags No Tooltip. Wraps ImGui_ColorEditFlags_NoTooltip.
-- ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
-- @return number
function ImGui:color_edit_flags_no_tooltip()
    return r.ImGui_ColorEditFlags_NoTooltip()
end


--- Color Edit Flags None. Wraps ImGui_ColorEditFlags_None.
-- @return number
function ImGui:color_edit_flags_none()
    return r.ImGui_ColorEditFlags_None()
end


--- Color Edit Flags Picker Hue Bar. Wraps ImGui_ColorEditFlags_PickerHueBar.
-- ColorPicker: bar for Hue, rectangle for Sat/Value.
-- @return number
function ImGui:color_edit_flags_picker_hue_bar()
    return r.ImGui_ColorEditFlags_PickerHueBar()
end


--- Color Edit Flags Picker Hue Wheel. Wraps ImGui_ColorEditFlags_PickerHueWheel.
-- ColorPicker: wheel for Hue, triangle for Sat/Value.
-- @return number
function ImGui:color_edit_flags_picker_hue_wheel()
    return r.ImGui_ColorEditFlags_PickerHueWheel()
end


--- Color Edit Flags Uint8. Wraps ImGui_ColorEditFlags_Uint8.
-- ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255.
-- @return number
function ImGui:color_edit_flags_uint8()
    return r.ImGui_ColorEditFlags_Uint8()
end


--- Color Picker3. Wraps ImGui_ColorPicker3.
-- Color is in 0xXXRRGGBB. XX is ignored and will not be modified.
-- @param ctx ImGui_Context
-- @param label string
-- @param col_rgb number
-- @param integer flagsIn Optional
-- @return col_rgb number
function ImGui:color_picker3(ctx, label, col_rgb, integer)
    local integer = integer or nil
    local ret_val, col_rgb = r.ImGui_ColorPicker3(ctx, label, col_rgb, integer)
    if ret_val then
        return col_rgb
    else
        return nil
    end
end


--- Color Picker4. Wraps ImGui_ColorPicker4.
-- @param ctx ImGui_Context
-- @param label string
-- @param col_rgba number
-- @param integer flagsIn Optional
-- @param integer ref_colIn Optional
-- @return col_rgba number
function ImGui:color_picker4(ctx, label, col_rgba, integer, integer)
    local integer = integer or nil
    local ret_val, col_rgba = r.ImGui_ColorPicker4(ctx, label, col_rgba, integer, integer)
    if ret_val then
        return col_rgba
    else
        return nil
    end
end


--- Combo. Wraps ImGui_Combo.
-- Helper over BeginCombo/EndCombo for convenience purpose. Each item must be null-
-- terminated (requires REAPER v6.44 or newer for EEL and Lua).
-- @param ctx ImGui_Context
-- @param label string
-- @param current_item number
-- @param items string
-- @param integer popup_max_height_in_itemsIn Optional
-- @return current_item number
function ImGui:combo(ctx, label, current_item, items, integer)
    local integer = integer or nil
    local ret_val, current_item = r.ImGui_Combo(ctx, label, current_item, items, integer)
    if ret_val then
        return current_item
    else
        return nil
    end
end


--- Combo Flags Height Large. Wraps ImGui_ComboFlags_HeightLarge.
-- Max ~20 items visible.
-- @return number
function ImGui:combo_flags_height_large()
    return r.ImGui_ComboFlags_HeightLarge()
end


--- Combo Flags Height Largest. Wraps ImGui_ComboFlags_HeightLargest.
-- As many fitting items as possible.
-- @return number
function ImGui:combo_flags_height_largest()
    return r.ImGui_ComboFlags_HeightLargest()
end


--- Combo Flags Height Regular. Wraps ImGui_ComboFlags_HeightRegular.
-- Max ~8 items visible (default).
-- @return number
function ImGui:combo_flags_height_regular()
    return r.ImGui_ComboFlags_HeightRegular()
end


--- Combo Flags Height Small. Wraps ImGui_ComboFlags_HeightSmall.
-- Max ~4 items visible. Tip: If you want your combo popup to be a specific size
-- you can use SetNextWindowSizeConstraints prior to calling BeginCombo.
-- @return number
function ImGui:combo_flags_height_small()
    return r.ImGui_ComboFlags_HeightSmall()
end


--- Combo Flags No Arrow Button. Wraps ImGui_ComboFlags_NoArrowButton.
-- Display on the preview box without the square arrow button.
-- @return number
function ImGui:combo_flags_no_arrow_button()
    return r.ImGui_ComboFlags_NoArrowButton()
end


--- Combo Flags No Preview. Wraps ImGui_ComboFlags_NoPreview.
-- Display only a square arrow button.
-- @return number
function ImGui:combo_flags_no_preview()
    return r.ImGui_ComboFlags_NoPreview()
end


--- Combo Flags None. Wraps ImGui_ComboFlags_None.
-- @return number
function ImGui:combo_flags_none()
    return r.ImGui_ComboFlags_None()
end


--- Combo Flags Popup Align Left. Wraps ImGui_ComboFlags_PopupAlignLeft.
-- Align the popup toward the left by default.
-- @return number
function ImGui:combo_flags_popup_align_left()
    return r.ImGui_ComboFlags_PopupAlignLeft()
end


--- Combo Flags Width Fit Preview. Wraps ImGui_ComboFlags_WidthFitPreview.
-- Width dynamically calculated from preview contents.
-- @return number
function ImGui:combo_flags_width_fit_preview()
    return r.ImGui_ComboFlags_WidthFitPreview()
end


--- Cond Always. Wraps ImGui_Cond_Always.
-- No condition (always set the variable).
-- @return number
function ImGui:cond_always()
    return r.ImGui_Cond_Always()
end


--- Cond Appearing. Wraps ImGui_Cond_Appearing.
-- Set the variable if the object/window is appearing after being
-- hidden/inactive (or the first time).
-- @return number
function ImGui:cond_appearing()
    return r.ImGui_Cond_Appearing()
end


--- Cond First Use Ever. Wraps ImGui_Cond_FirstUseEver.
-- Set the variable if the object/window has no persistently saved data    (no
-- entry in .ini file).
-- @return number
function ImGui:cond_first_use_ever()
    return r.ImGui_Cond_FirstUseEver()
end


--- Cond Once. Wraps ImGui_Cond_Once.
-- Set the variable once per runtime session (only the first call will succeed).
-- @return number
function ImGui:cond_once()
    return r.ImGui_Cond_Once()
end


--- Config Flags Docking Enable. Wraps ImGui_ConfigFlags_DockingEnable.
-- Enable docking functionality.
-- @return number
function ImGui:config_flags_docking_enable()
    return r.ImGui_ConfigFlags_DockingEnable()
end


--- Config Flags Nav Enable Keyboard. Wraps ImGui_ConfigFlags_NavEnableKeyboard.
-- Master keyboard navigation enable flag.    Enable full Tabbing + directional
-- arrows + space/enter to activate.
-- @return number
function ImGui:config_flags_nav_enable_keyboard()
    return r.ImGui_ConfigFlags_NavEnableKeyboard()
end


--- Config Flags Nav Enable Set Mouse Pos. Wraps ImGui_ConfigFlags_NavEnableSetMousePos.
-- Instruct navigation to move the mouse cursor.
-- @return number
function ImGui:config_flags_nav_enable_set_mouse_pos()
    return r.ImGui_ConfigFlags_NavEnableSetMousePos()
end


--- Config Flags Nav No Capture Keyboard. Wraps ImGui_ConfigFlags_NavNoCaptureKeyboard.
-- Instruct navigation to not capture global keyboard input when
-- ConfigFlags_NavEnableKeyboard is set (see SetNextFrameWantCaptureKeyboard).
-- @return number
function ImGui:config_flags_nav_no_capture_keyboard()
    return r.ImGui_ConfigFlags_NavNoCaptureKeyboard()
end


--- Config Flags No Keyboard. Wraps ImGui_ConfigFlags_NoKeyboard.
-- Instruct dear imgui to disable keyboard inputs and interactions. This is done by
-- ignoring keyboard events and clearing existing states.
-- @return number
function ImGui:config_flags_no_keyboard()
    return r.ImGui_ConfigFlags_NoKeyboard()
end


--- Config Flags No Mouse. Wraps ImGui_ConfigFlags_NoMouse.
-- Instruct dear imgui to disable mouse inputs and interactions
-- @return number
function ImGui:config_flags_no_mouse()
    return r.ImGui_ConfigFlags_NoMouse()
end


--- Config Flags No Mouse Cursor Change. Wraps ImGui_ConfigFlags_NoMouseCursorChange.
-- Instruct backend to not alter mouse cursor shape and visibility.
-- @return number
function ImGui:config_flags_no_mouse_cursor_change()
    return r.ImGui_ConfigFlags_NoMouseCursorChange()
end


--- Config Flags No Saved Settings. Wraps ImGui_ConfigFlags_NoSavedSettings.
-- Disable state restoration and persistence for the whole context.
-- @return number
function ImGui:config_flags_no_saved_settings()
    return r.ImGui_ConfigFlags_NoSavedSettings()
end


--- Config Flags None. Wraps ImGui_ConfigFlags_None.
-- @return number
function ImGui:config_flags_none()
    return r.ImGui_ConfigFlags_None()
end


--- Config Var Debug Begin Return Value Loop. Wraps ImGui_ConfigVar_DebugBeginReturnValueLoop.
-- Some calls to Begin()/BeginChild() will return false. Will cycle through window
-- depths then repeat. Suggested use: add
-- "SetConfigVar(ConfigVar_DebugBeginReturnValueLoop(), GetKeyMods() == Mod_Shift"
-- in your main loop then occasionally press SHIFT. Windows should be flickering
-- while running.
-- @return number
function ImGui:config_var_debug_begin_return_value_loop()
    return r.ImGui_ConfigVar_DebugBeginReturnValueLoop()
end


--- Config Var Debug Begin Return Value Once. Wraps ImGui_ConfigVar_DebugBeginReturnValueOnce.
-- First-time calls to Begin()/BeginChild() will return false. **Needs to be set at
-- context startup time** if you don't want to miss windows.
-- @return number
function ImGui:config_var_debug_begin_return_value_once()
    return r.ImGui_ConfigVar_DebugBeginReturnValueOnce()
end


--- Config Var Docking No Split. Wraps ImGui_ConfigVar_DockingNoSplit.
-- Simplified docking mode: disable window splitting, so docking is limited to
-- merging multiple windows together into tab-bars.
-- @return number
function ImGui:config_var_docking_no_split()
    return r.ImGui_ConfigVar_DockingNoSplit()
end


--- Config Var Docking Transparent Payload. Wraps ImGui_ConfigVar_DockingTransparentPayload.
-- Make window or viewport transparent when docking and only display docking
-- boxes on the target viewport.
-- @return number
function ImGui:config_var_docking_transparent_payload()
    return r.ImGui_ConfigVar_DockingTransparentPayload()
end


--- Config Var Docking With Shift. Wraps ImGui_ConfigVar_DockingWithShift.
-- Enable docking with holding Shift key    (reduce visual noise, allows dropping
-- in wider space
-- @return number
function ImGui:config_var_docking_with_shift()
    return r.ImGui_ConfigVar_DockingWithShift()
end


--- Config Var Drag Click To Input Text. Wraps ImGui_ConfigVar_DragClickToInputText.
-- Enable turning Drag* widgets into text input with a simple mouse    click-
-- release (without moving). Not desirable on devices without a keyboard.
-- @return number
function ImGui:config_var_drag_click_to_input_text()
    return r.ImGui_ConfigVar_DragClickToInputText()
end


--- Config Var Flags. Wraps ImGui_ConfigVar_Flags.
-- ConfigFlags_*
-- @return number
function ImGui:config_var_flags()
    return r.ImGui_ConfigVar_Flags()
end


--- Config Var Hover Delay Normal. Wraps ImGui_ConfigVar_HoverDelayNormal.
-- Delay for IsItemHovered(HoveredFlags_DelayNormal).    Usually used along with
-- ConfigVar_HoverStationaryDelay.
-- @return number
function ImGui:config_var_hover_delay_normal()
    return r.ImGui_ConfigVar_HoverDelayNormal()
end


--- Config Var Hover Delay Short. Wraps ImGui_ConfigVar_HoverDelayShort.
-- Delay for IsItemHovered(HoveredFlags_DelayShort).    Usually used along with
-- ConfigVar_HoverStationaryDelay.
-- @return number
function ImGui:config_var_hover_delay_short()
    return r.ImGui_ConfigVar_HoverDelayShort()
end


--- Config Var Hover Flags For Tooltip Mouse. Wraps ImGui_ConfigVar_HoverFlagsForTooltipMouse.
-- Default flags when using IsItemHovered(HoveredFlags_ForTooltip) or
-- BeginItemTooltip()/SetItemTooltip() while using mouse.
-- @return number
function ImGui:config_var_hover_flags_for_tooltip_mouse()
    return r.ImGui_ConfigVar_HoverFlagsForTooltipMouse()
end


--- Config Var Hover Flags For Tooltip Nav. Wraps ImGui_ConfigVar_HoverFlagsForTooltipNav.
-- Default flags when using IsItemHovered(HoveredFlags_ForTooltip) or
-- BeginItemTooltip()/SetItemTooltip() while using keyboard/gamepad.
-- @return number
function ImGui:config_var_hover_flags_for_tooltip_nav()
    return r.ImGui_ConfigVar_HoverFlagsForTooltipNav()
end


--- Config Var Hover Stationary Delay. Wraps ImGui_ConfigVar_HoverStationaryDelay.
-- Delay for IsItemHovered(HoveredFlags_Stationary).    Time required to consider
-- mouse stationary.
-- @return number
function ImGui:config_var_hover_stationary_delay()
    return r.ImGui_ConfigVar_HoverStationaryDelay()
end


--- Config Var Input Text Cursor Blink. Wraps ImGui_ConfigVar_InputTextCursorBlink.
-- Enable blinking cursor (optional as some users consider it to be distracting).
-- @return number
function ImGui:config_var_input_text_cursor_blink()
    return r.ImGui_ConfigVar_InputTextCursorBlink()
end


--- Config Var Input Text Enter Keep Active. Wraps ImGui_ConfigVar_InputTextEnterKeepActive.
-- Pressing Enter will keep item active and select contents (single-line only).
-- @return number
function ImGui:config_var_input_text_enter_keep_active()
    return r.ImGui_ConfigVar_InputTextEnterKeepActive()
end


--- Config Var Input Trickle Event Queue. Wraps ImGui_ConfigVar_InputTrickleEventQueue.
-- Enable input queue trickling: some types of events submitted during the same
-- frame (e.g. button down + up) will be spread over multiple frames, improving
-- interactions with low framerates.
-- @return number
function ImGui:config_var_input_trickle_event_queue()
    return r.ImGui_ConfigVar_InputTrickleEventQueue()
end


--- Config Var Key Repeat Delay. Wraps ImGui_ConfigVar_KeyRepeatDelay.
-- When holding a key/button, time before it starts repeating, in seconds    (for
-- buttons in Repeat mode, etc.).
-- @return number
function ImGui:config_var_key_repeat_delay()
    return r.ImGui_ConfigVar_KeyRepeatDelay()
end


--- Config Var Key Repeat Rate. Wraps ImGui_ConfigVar_KeyRepeatRate.
-- When holding a key/button, rate at which it repeats, in seconds.
-- @return number
function ImGui:config_var_key_repeat_rate()
    return r.ImGui_ConfigVar_KeyRepeatRate()
end


--- Config Var Mac Osx Behaviors. Wraps ImGui_ConfigVar_MacOSXBehaviors.
-- Enabled by default on macOS. Swap Cmd<>Ctrl keys, OS X style text editing
-- cursor movement using Alt instead of Ctrl, Shortcuts using Cmd/Super instead
-- of Ctrl, Line/Text Start and End using Cmd+Arrows instead of Home/End,    Double
-- click selects by word instead of selecting whole text, Multi-selection    in
-- lists uses Cmd/Super instead of Ctrl.
-- @return number
function ImGui:config_var_mac_osx_behaviors()
    return r.ImGui_ConfigVar_MacOSXBehaviors()
end


--- Config Var Mouse Double Click Max Dist. Wraps ImGui_ConfigVar_MouseDoubleClickMaxDist.
-- Distance threshold to stay in to validate a double-click, in pixels.
-- @return number
function ImGui:config_var_mouse_double_click_max_dist()
    return r.ImGui_ConfigVar_MouseDoubleClickMaxDist()
end


--- Config Var Mouse Double Click Time. Wraps ImGui_ConfigVar_MouseDoubleClickTime.
-- Time for a double-click, in seconds.
-- @return number
function ImGui:config_var_mouse_double_click_time()
    return r.ImGui_ConfigVar_MouseDoubleClickTime()
end


--- Config Var Mouse Drag Threshold. Wraps ImGui_ConfigVar_MouseDragThreshold.
-- Distance threshold before considering we are dragging.
-- @return number
function ImGui:config_var_mouse_drag_threshold()
    return r.ImGui_ConfigVar_MouseDragThreshold()
end


--- Config Var Viewports No Decoration. Wraps ImGui_ConfigVar_ViewportsNoDecoration.
-- Disable default OS window decoration. Enabling decoration can create
-- subsequent issues at OS levels (e.g. minimum window size).
-- @return number
function ImGui:config_var_viewports_no_decoration()
    return r.ImGui_ConfigVar_ViewportsNoDecoration()
end


--- Config Var Windows Move From Title Bar Only. Wraps ImGui_ConfigVar_WindowsMoveFromTitleBarOnly.
-- Enable allowing to move windows only when clicking on their title bar.    Does
-- not apply to windows without a title bar.
-- @return number
function ImGui:config_var_windows_move_from_title_bar_only()
    return r.ImGui_ConfigVar_WindowsMoveFromTitleBarOnly()
end


--- Config Var Windows Resize From Edges. Wraps ImGui_ConfigVar_WindowsResizeFromEdges.
-- Enable resizing of windows from their edges and from the lower-left corner.
-- @return number
function ImGui:config_var_windows_resize_from_edges()
    return r.ImGui_ConfigVar_WindowsResizeFromEdges()
end


--- Create Context. Wraps ImGui_CreateContext.
-- Create a new ReaImGui context. The context will remain valid as long as it is
-- used in each defer cycle.
-- @param label string
-- @param integer config_flagsIn Optional
-- @return ImGui_Context
function ImGui:create_context(label, integer)
    local integer = integer or nil
    return r.ImGui_CreateContext(label, integer)
end


--- Create Draw List Splitter. Wraps ImGui_CreateDrawListSplitter.
-- @param draw_list ImGui_DrawList
-- @return ImGui_DrawListSplitter
function ImGui:create_draw_list_splitter(draw_list)
    return r.ImGui_CreateDrawListSplitter(draw_list)
end


--- Create Font. Wraps ImGui_CreateFont.
-- Load a font matching a font family name or from a font file. The font will
-- remain valid while it's attached to a context. See Attach.
-- @param family_or_file string
-- @param size number
-- @param integer flagsIn Optional
-- @return ImGui_Font
function ImGui:create_font(family_or_file, size, integer)
    local integer = integer or nil
    return r.ImGui_CreateFont(family_or_file, size, integer)
end


--- Create Font From Mem. Wraps ImGui_CreateFontFromMem.
-- Requires REAPER v6.44 or newer for EEL and Lua. Use CreateFont or explicitely
-- specify data_sz to support older versions.
-- @param data string
-- @param size number
-- @param integer flagsIn Optional
-- @return ImGui_Font
function ImGui:create_font_from_mem(data, size, integer)
    local integer = integer or nil
    return r.ImGui_CreateFontFromMem(data, size, integer)
end


--- Create Function From Eel. Wraps ImGui_CreateFunctionFromEEL.
-- Compile an EEL program.
-- @param code string
-- @return ImGui_Function
function ImGui:create_function_from_eel(code)
    return r.ImGui_CreateFunctionFromEEL(code)
end


--- Create Image. Wraps ImGui_CreateImage.
-- The returned object is valid as long as it is used in each defer cycle unless
-- attached to a context (see Attach).
-- @param file string
-- @param integer flagsIn Optional
-- @return ImGui_Image
function ImGui:create_image(file, integer)
    local integer = integer or nil
    return r.ImGui_CreateImage(file, integer)
end


--- Create Image From Lice. Wraps ImGui_CreateImageFromLICE.
-- Copies pixel data from a LICE bitmap created using JS_LICE_CreateBitmap.
-- @param bitmap LICE_IBitmap
-- @param integer flagsIn Optional
-- @return ImGui_Image
function ImGui:create_image_from_lice(bitmap, integer)
    local integer = integer or nil
    return r.ImGui_CreateImageFromLICE(bitmap, integer)
end


--- Create Image From Mem. Wraps ImGui_CreateImageFromMem.
-- Requires REAPER v6.44 or newer for EEL and Lua. Load from a file using
-- CreateImage or explicitely specify data_sz to support older versions.
-- @param data string
-- @param integer flagsIn Optional
-- @return ImGui_Image
function ImGui:create_image_from_mem(data, integer)
    local integer = integer or nil
    return r.ImGui_CreateImageFromMem(data, integer)
end


--- Create Image Set. Wraps ImGui_CreateImageSet.
-- @return ImGui_ImageSet
function ImGui:create_image_set()
    return r.ImGui_CreateImageSet()
end


--- Create List Clipper. Wraps ImGui_CreateListClipper.
-- The returned clipper object is only valid for the given context and is valid as
-- long as it is used in each defer cycle unless attached (see Attach).
-- @param ctx ImGui_Context
-- @return ImGui_ListClipper
function ImGui:create_list_clipper(ctx)
    return r.ImGui_CreateListClipper(ctx)
end


--- Create Text Filter. Wraps ImGui_CreateTextFilter.
-- Valid while used every frame unless attached to a context (see Attach).
-- @param string default_filterIn Optional
-- @return ImGui_TextFilter
function ImGui:create_text_filter(string)
    local string = string or nil
    return r.ImGui_CreateTextFilter(string)
end


--- Debug Flash Style Color. Wraps ImGui_DebugFlashStyleColor.
-- @param ctx ImGui_Context
-- @param idx number
function ImGui:debug_flash_style_color(ctx, idx)
    return r.ImGui_DebugFlashStyleColor(ctx, idx)
end


--- Debug Start Item Picker. Wraps ImGui_DebugStartItemPicker.
-- @param ctx ImGui_Context
function ImGui:debug_start_item_picker(ctx)
    return r.ImGui_DebugStartItemPicker(ctx)
end


--- Debug Text Encoding. Wraps ImGui_DebugTextEncoding.
-- Helper tool to diagnose between text encoding issues and font loading issues.
-- Pass your UTF-8 string and verify that there are correct.
-- @param ctx ImGui_Context
-- @param text string
function ImGui:debug_text_encoding(ctx, text)
    return r.ImGui_DebugTextEncoding(ctx, text)
end


--- Detach. Wraps ImGui_Detach.
-- Unlink the object's lifetime. Unattached objects are automatically destroyed
-- when left unused. You may check whether an object has been destroyed using
-- ValidatePtr.
-- @param ctx ImGui_Context
-- @param obj ImGui_Resource
function ImGui:detach(ctx, obj)
    return r.ImGui_Detach(ctx, obj)
end


--- Dir Down. Wraps ImGui_Dir_Down.
-- @return number
function ImGui:dir_down()
    return r.ImGui_Dir_Down()
end


--- Dir Left. Wraps ImGui_Dir_Left.
-- @return number
function ImGui:dir_left()
    return r.ImGui_Dir_Left()
end


--- Dir None. Wraps ImGui_Dir_None.
-- @return number
function ImGui:dir_none()
    return r.ImGui_Dir_None()
end


--- Dir Right. Wraps ImGui_Dir_Right.
-- @return number
function ImGui:dir_right()
    return r.ImGui_Dir_Right()
end


--- Dir Up. Wraps ImGui_Dir_Up.
-- @return number
function ImGui:dir_up()
    return r.ImGui_Dir_Up()
end


--- Drag Double. Wraps ImGui_DragDouble.
-- @param ctx ImGui_Context
-- @param label string
-- @param v number
-- @param number v_speedIn Optional
-- @param number v_minIn Optional
-- @param number v_maxIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v number
function ImGui:drag_double(ctx, label, v, number, number, number, string, integer)
    local number = number or nil
    local string = string or nil
    local integer = integer or nil
    local ret_val, v = r.ImGui_DragDouble(ctx, label, v, number, number, number, string, integer)
    if ret_val then
        return v
    else
        return nil
    end
end


--- Drag Double2. Wraps ImGui_DragDouble2.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param number v_speedIn Optional
-- @param number v_minIn Optional
-- @param number v_maxIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
function ImGui:drag_double2(ctx, label, v1, v2, number, number, number, string, integer)
    local number = number or nil
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2 = r.ImGui_DragDouble2(ctx, label, v1, v2, number, number, number, string, integer)
    if ret_val then
        return v1, v2
    else
        return nil
    end
end


--- Drag Double3. Wraps ImGui_DragDouble3.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param number v_speedIn Optional
-- @param number v_minIn Optional
-- @param number v_maxIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
function ImGui:drag_double3(ctx, label, v1, v2, v3, number, number, number, string, integer)
    local number = number or nil
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2, v3 = r.ImGui_DragDouble3(ctx, label, v1, v2, v3, number, number, number, string, integer)
    if ret_val then
        return v1, v2, v3
    else
        return nil
    end
end


--- Drag Double4. Wraps ImGui_DragDouble4.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param v4 number
-- @param number v_speedIn Optional
-- @param number v_minIn Optional
-- @param number v_maxIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
-- @return v4 number
function ImGui:drag_double4(ctx, label, v1, v2, v3, v4, number, number, number, string, integer)
    local number = number or nil
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2, v3, v4 = r.ImGui_DragDouble4(ctx, label, v1, v2, v3, v4, number, number, number, string, integer)
    if ret_val then
        return v1, v2, v3, v4
    else
        return nil
    end
end


--- Drag Double N. Wraps ImGui_DragDoubleN.
-- @param ctx ImGui_Context
-- @param label string
-- @param values reaper_array
-- @param number speedIn Optional
-- @param number minIn Optional
-- @param number maxIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:drag_double_n(ctx, label, values, number, number, number, string, integer)
    local number = number or nil
    local string = string or nil
    local integer = integer or nil
    return r.ImGui_DragDoubleN(ctx, label, values, number, number, number, string, integer)
end


--- Drag Drop Flags Accept Before Delivery. Wraps ImGui_DragDropFlags_AcceptBeforeDelivery.
-- AcceptDragDropPayload will returns true even before the mouse button is
-- released. You can then check GetDragDropPayload/is_delivery to test if the
-- payload needs to be delivered.
-- @return number
function ImGui:drag_drop_flags_accept_before_delivery()
    return r.ImGui_DragDropFlags_AcceptBeforeDelivery()
end


--- Drag Drop Flags Accept No Draw Default Rect. Wraps ImGui_DragDropFlags_AcceptNoDrawDefaultRect.
-- Do not draw the default highlight rectangle when hovering over target.
-- @return number
function ImGui:drag_drop_flags_accept_no_draw_default_rect()
    return r.ImGui_DragDropFlags_AcceptNoDrawDefaultRect()
end


--- Drag Drop Flags Accept No Preview Tooltip. Wraps ImGui_DragDropFlags_AcceptNoPreviewTooltip.
-- Request hiding the BeginDragDropSource tooltip from the BeginDragDropTarget
-- site.
-- @return number
function ImGui:drag_drop_flags_accept_no_preview_tooltip()
    return r.ImGui_DragDropFlags_AcceptNoPreviewTooltip()
end


--- Drag Drop Flags Accept Peek Only. Wraps ImGui_DragDropFlags_AcceptPeekOnly.
-- For peeking ahead and inspecting the payload before delivery.    Equivalent to
-- DragDropFlags_AcceptBeforeDelivery |    DragDropFlags_AcceptNoDrawDefaultRect.
-- @return number
function ImGui:drag_drop_flags_accept_peek_only()
    return r.ImGui_DragDropFlags_AcceptPeekOnly()
end


--- Drag Drop Flags None. Wraps ImGui_DragDropFlags_None.
-- @return number
function ImGui:drag_drop_flags_none()
    return r.ImGui_DragDropFlags_None()
end


--- Drag Drop Flags Payload Auto Expire. Wraps ImGui_DragDropFlags_PayloadAutoExpire.
-- Automatically expire the payload if the source cease to be submitted
-- (otherwise payloads are persisting while being dragged).
-- @return number
function ImGui:drag_drop_flags_payload_auto_expire()
    return r.ImGui_DragDropFlags_PayloadAutoExpire()
end


--- Drag Drop Flags Source Allow Null Id. Wraps ImGui_DragDropFlags_SourceAllowNullID.
-- Allow items such as Text, Image that have no unique identifier to be used as
-- drag source, by manufacturing a temporary identifier based on their    window-
-- relative position. This is extremely unusual within the dear imgui    ecosystem
-- and so we made it explicit.
-- @return number
function ImGui:drag_drop_flags_source_allow_null_id()
    return r.ImGui_DragDropFlags_SourceAllowNullID()
end


--- Drag Drop Flags Source Extern. Wraps ImGui_DragDropFlags_SourceExtern.
-- External source (from outside of dear imgui), won't attempt to read current
-- item/window info. Will always return true.    Only one Extern source can be
-- active simultaneously.
-- @return number
function ImGui:drag_drop_flags_source_extern()
    return r.ImGui_DragDropFlags_SourceExtern()
end


--- Drag Drop Flags Source No Disable Hover. Wraps ImGui_DragDropFlags_SourceNoDisableHover.
-- By default, when dragging we clear data so that IsItemHovered will return
-- false, to avoid subsequent user code submitting tooltips. This flag disables
-- this behavior so you can still call IsItemHovered on the source item.
-- @return number
function ImGui:drag_drop_flags_source_no_disable_hover()
    return r.ImGui_DragDropFlags_SourceNoDisableHover()
end


--- Drag Drop Flags Source No Hold To Open Others. Wraps ImGui_DragDropFlags_SourceNoHoldToOpenOthers.
-- Disable the behavior that allows to open tree nodes and collapsing header by
-- holding over them while dragging a source item.
-- @return number
function ImGui:drag_drop_flags_source_no_hold_to_open_others()
    return r.ImGui_DragDropFlags_SourceNoHoldToOpenOthers()
end


--- Drag Drop Flags Source No Preview Tooltip. Wraps ImGui_DragDropFlags_SourceNoPreviewTooltip.
-- By default, a successful call to BeginDragDropSource opens a tooltip so you
-- can display a preview or description of the source contents.    This flag
-- disables this behavior.
-- @return number
function ImGui:drag_drop_flags_source_no_preview_tooltip()
    return r.ImGui_DragDropFlags_SourceNoPreviewTooltip()
end


--- Drag Float Range2. Wraps ImGui_DragFloatRange2.
-- @param ctx ImGui_Context
-- @param label string
-- @param v_current_min number
-- @param v_current_max number
-- @param number v_speedIn Optional
-- @param number v_minIn Optional
-- @param number v_maxIn Optional
-- @param string formatIn Optional
-- @param string format_maxIn Optional
-- @param integer flagsIn Optional
-- @return v_current_min number
-- @return v_current_max number
function ImGui:drag_float_range2(ctx, label, v_current_min, v_current_max, number, number, number, string, string, integer)
    local number = number or nil
    local string = string or nil
    local integer = integer or nil
    local ret_val, v_current_min, v_current_max = r.ImGui_DragFloatRange2(ctx, label, v_current_min, v_current_max, number, number, number, string, string, integer)
    if ret_val then
        return v_current_min, v_current_max
    else
        return nil
    end
end


--- Drag Int. Wraps ImGui_DragInt.
-- @param ctx ImGui_Context
-- @param label string
-- @param v number
-- @param number v_speedIn Optional
-- @param integer v_minIn Optional
-- @param integer v_maxIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v number
function ImGui:drag_int(ctx, label, v, number, integer, integer, string, integer)
    local number = number or nil
    local integer = integer or nil
    local string = string or nil
    local ret_val, v = r.ImGui_DragInt(ctx, label, v, number, integer, integer, string, integer)
    if ret_val then
        return v
    else
        return nil
    end
end


--- Drag Int2. Wraps ImGui_DragInt2.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param number v_speedIn Optional
-- @param integer v_minIn Optional
-- @param integer v_maxIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
function ImGui:drag_int2(ctx, label, v1, v2, number, integer, integer, string, integer)
    local number = number or nil
    local integer = integer or nil
    local string = string or nil
    local ret_val, v1, v2 = r.ImGui_DragInt2(ctx, label, v1, v2, number, integer, integer, string, integer)
    if ret_val then
        return v1, v2
    else
        return nil
    end
end


--- Drag Int3. Wraps ImGui_DragInt3.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param number v_speedIn Optional
-- @param integer v_minIn Optional
-- @param integer v_maxIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
function ImGui:drag_int3(ctx, label, v1, v2, v3, number, integer, integer, string, integer)
    local number = number or nil
    local integer = integer or nil
    local string = string or nil
    local ret_val, v1, v2, v3 = r.ImGui_DragInt3(ctx, label, v1, v2, v3, number, integer, integer, string, integer)
    if ret_val then
        return v1, v2, v3
    else
        return nil
    end
end


--- Drag Int4. Wraps ImGui_DragInt4.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param v4 number
-- @param number v_speedIn Optional
-- @param integer v_minIn Optional
-- @param integer v_maxIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
-- @return v4 number
function ImGui:drag_int4(ctx, label, v1, v2, v3, v4, number, integer, integer, string, integer)
    local number = number or nil
    local integer = integer or nil
    local string = string or nil
    local ret_val, v1, v2, v3, v4 = r.ImGui_DragInt4(ctx, label, v1, v2, v3, v4, number, integer, integer, string, integer)
    if ret_val then
        return v1, v2, v3, v4
    else
        return nil
    end
end


--- Drag Int Range2. Wraps ImGui_DragIntRange2.
-- @param ctx ImGui_Context
-- @param label string
-- @param v_current_min number
-- @param v_current_max number
-- @param number v_speedIn Optional
-- @param integer v_minIn Optional
-- @param integer v_maxIn Optional
-- @param string formatIn Optional
-- @param string format_maxIn Optional
-- @param integer flagsIn Optional
-- @return v_current_min number
-- @return v_current_max number
function ImGui:drag_int_range2(ctx, label, v_current_min, v_current_max, number, integer, integer, string, string, integer)
    local number = number or nil
    local integer = integer or nil
    local string = string or nil
    local ret_val, v_current_min, v_current_max = r.ImGui_DragIntRange2(ctx, label, v_current_min, v_current_max, number, integer, integer, string, string, integer)
    if ret_val then
        return v_current_min, v_current_max
    else
        return nil
    end
end


--- Draw Flags Closed. Wraps ImGui_DrawFlags_Closed.
-- DrawList_PathStroke, DrawList_AddPolyline: specify that shape should be
-- closed (Important: this is always == 1 for legacy reason).
-- @return number
function ImGui:draw_flags_closed()
    return r.ImGui_DrawFlags_Closed()
end


--- Draw Flags None. Wraps ImGui_DrawFlags_None.
-- @return number
function ImGui:draw_flags_none()
    return r.ImGui_DrawFlags_None()
end


--- Draw Flags Round Corners All. Wraps ImGui_DrawFlags_RoundCornersAll.
-- @return number
function ImGui:draw_flags_round_corners_all()
    return r.ImGui_DrawFlags_RoundCornersAll()
end


--- Draw Flags Round Corners Bottom. Wraps ImGui_DrawFlags_RoundCornersBottom.
-- @return number
function ImGui:draw_flags_round_corners_bottom()
    return r.ImGui_DrawFlags_RoundCornersBottom()
end


--- Draw Flags Round Corners Bottom Left. Wraps ImGui_DrawFlags_RoundCornersBottomLeft.
-- DrawList_AddRect, DrawList_AddRectFilled, DrawList_PathRect: enable rounding
-- bottom-left corner only (when rounding > 0.0, we default to all corners).
-- @return number
function ImGui:draw_flags_round_corners_bottom_left()
    return r.ImGui_DrawFlags_RoundCornersBottomLeft()
end


--- Draw Flags Round Corners Bottom Right. Wraps ImGui_DrawFlags_RoundCornersBottomRight.
-- DrawList_AddRect, DrawList_AddRectFilled, DrawList_PathRect: enable rounding
-- bottom-right corner only (when rounding > 0.0, we default to all corners).
-- @return number
function ImGui:draw_flags_round_corners_bottom_right()
    return r.ImGui_DrawFlags_RoundCornersBottomRight()
end


--- Draw Flags Round Corners Left. Wraps ImGui_DrawFlags_RoundCornersLeft.
-- @return number
function ImGui:draw_flags_round_corners_left()
    return r.ImGui_DrawFlags_RoundCornersLeft()
end


--- Draw Flags Round Corners None. Wraps ImGui_DrawFlags_RoundCornersNone.
-- DrawList_AddRect, DrawList_AddRectFilled, DrawList_PathRect: disable rounding
-- on all corners (when rounding > 0.0). This is NOT zero, NOT an implicit flag!.
-- @return number
function ImGui:draw_flags_round_corners_none()
    return r.ImGui_DrawFlags_RoundCornersNone()
end


--- Draw Flags Round Corners Right. Wraps ImGui_DrawFlags_RoundCornersRight.
-- @return number
function ImGui:draw_flags_round_corners_right()
    return r.ImGui_DrawFlags_RoundCornersRight()
end


--- Draw Flags Round Corners Top. Wraps ImGui_DrawFlags_RoundCornersTop.
-- @return number
function ImGui:draw_flags_round_corners_top()
    return r.ImGui_DrawFlags_RoundCornersTop()
end


--- Draw Flags Round Corners Top Left. Wraps ImGui_DrawFlags_RoundCornersTopLeft.
-- DrawList_AddRect, DrawList_AddRectFilled, DrawList_PathRect: enable rounding
-- top-left corner only (when rounding > 0.0, we default to all corners).
-- @return number
function ImGui:draw_flags_round_corners_top_left()
    return r.ImGui_DrawFlags_RoundCornersTopLeft()
end


--- Draw Flags Round Corners Top Right. Wraps ImGui_DrawFlags_RoundCornersTopRight.
-- DrawList_AddRect, DrawList_AddRectFilled, DrawList_PathRect: enable rounding
-- top-right corner only (when rounding > 0.0, we default to all corners).
-- @return number
function ImGui:draw_flags_round_corners_top_right()
    return r.ImGui_DrawFlags_RoundCornersTopRight()
end


--- Draw List Splitter Clear. Wraps ImGui_DrawListSplitter_Clear.
-- @param splitter ImGui_DrawListSplitter
function ImGui:draw_list_splitter_clear(splitter)
    return r.ImGui_DrawListSplitter_Clear(splitter)
end


--- Draw List Splitter Merge. Wraps ImGui_DrawListSplitter_Merge.
-- @param splitter ImGui_DrawListSplitter
function ImGui:draw_list_splitter_merge(splitter)
    return r.ImGui_DrawListSplitter_Merge(splitter)
end


--- Draw List Splitter Set Current Channel. Wraps ImGui_DrawListSplitter_SetCurrentChannel.
-- @param splitter ImGui_DrawListSplitter
-- @param channel_idx number
function ImGui:draw_list_splitter_set_current_channel(splitter, channel_idx)
    return r.ImGui_DrawListSplitter_SetCurrentChannel(splitter, channel_idx)
end


--- Draw List Splitter Split. Wraps ImGui_DrawListSplitter_Split.
-- @param splitter ImGui_DrawListSplitter
-- @param count number
function ImGui:draw_list_splitter_split(splitter, count)
    return r.ImGui_DrawListSplitter_Split(splitter, count)
end


--- Draw List Add Bezier Cubic. Wraps ImGui_DrawList_AddBezierCubic.
-- Cubic Bezier (4 control points)
-- @param draw_list ImGui_DrawList
-- @param p1_x number
-- @param p1_y number
-- @param p2_x number
-- @param p2_y number
-- @param p3_x number
-- @param p3_y number
-- @param p4_x number
-- @param p4_y number
-- @param col_rgba number
-- @param thickness number
-- @param integer num_segmentsIn Optional
function ImGui:draw_list_add_bezier_cubic(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba, thickness, integer)
    local integer = integer or nil
    return r.ImGui_DrawList_AddBezierCubic(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba, thickness, integer)
end


--- Draw List Add Bezier Quadratic. Wraps ImGui_DrawList_AddBezierQuadratic.
-- Quadratic Bezier (3 control points)
-- @param draw_list ImGui_DrawList
-- @param p1_x number
-- @param p1_y number
-- @param p2_x number
-- @param p2_y number
-- @param p3_x number
-- @param p3_y number
-- @param col_rgba number
-- @param thickness number
-- @param integer num_segmentsIn Optional
function ImGui:draw_list_add_bezier_quadratic(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba, thickness, integer)
    local integer = integer or nil
    return r.ImGui_DrawList_AddBezierQuadratic(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba, thickness, integer)
end


--- Draw List Add Circle. Wraps ImGui_DrawList_AddCircle.
-- Use "num_segments == 0" to automatically calculate tessellation (preferred).
-- @param draw_list ImGui_DrawList
-- @param center_x number
-- @param center_y number
-- @param radius number
-- @param col_rgba number
-- @param integer num_segmentsIn Optional
-- @param number thicknessIn Optional
function ImGui:draw_list_add_circle(draw_list, center_x, center_y, radius, col_rgba, integer, number)
    local integer = integer or nil
    local number = number or nil
    return r.ImGui_DrawList_AddCircle(draw_list, center_x, center_y, radius, col_rgba, integer, number)
end


--- Draw List Add Circle Filled. Wraps ImGui_DrawList_AddCircleFilled.
-- Use "num_segments == 0" to automatically calculate tessellation (preferred).
-- @param draw_list ImGui_DrawList
-- @param center_x number
-- @param center_y number
-- @param radius number
-- @param col_rgba number
-- @param integer num_segmentsIn Optional
function ImGui:draw_list_add_circle_filled(draw_list, center_x, center_y, radius, col_rgba, integer)
    local integer = integer or nil
    return r.ImGui_DrawList_AddCircleFilled(draw_list, center_x, center_y, radius, col_rgba, integer)
end


--- Draw List Add Concave Poly Filled. Wraps ImGui_DrawList_AddConcavePolyFilled.
-- Concave polygon fill is more expensive than convex one: it has O(N^2)
-- complexity.
-- @param draw_list ImGui_DrawList
-- @param points reaper_array
-- @param col_rgba number
function ImGui:draw_list_add_concave_poly_filled(draw_list, points, col_rgba)
    return r.ImGui_DrawList_AddConcavePolyFilled(draw_list, points, col_rgba)
end


--- Draw List Add Convex Poly Filled. Wraps ImGui_DrawList_AddConvexPolyFilled.
-- Note: Anti-aliased filling requires points to be in clockwise order.
-- @param draw_list ImGui_DrawList
-- @param points reaper_array
-- @param col_rgba number
function ImGui:draw_list_add_convex_poly_filled(draw_list, points, col_rgba)
    return r.ImGui_DrawList_AddConvexPolyFilled(draw_list, points, col_rgba)
end


--- Draw List Add Ellipse. Wraps ImGui_DrawList_AddEllipse.
-- @param draw_list ImGui_DrawList
-- @param center_x number
-- @param center_y number
-- @param radius_x number
-- @param radius_y number
-- @param col_rgba number
-- @param number rotIn Optional
-- @param integer num_segmentsIn Optional
-- @param number thicknessIn Optional
function ImGui:draw_list_add_ellipse(draw_list, center_x, center_y, radius_x, radius_y, col_rgba, number, integer, number)
    local number = number or nil
    local integer = integer or nil
    return r.ImGui_DrawList_AddEllipse(draw_list, center_x, center_y, radius_x, radius_y, col_rgba, number, integer, number)
end


--- Draw List Add Ellipse Filled. Wraps ImGui_DrawList_AddEllipseFilled.
-- @param draw_list ImGui_DrawList
-- @param center_x number
-- @param center_y number
-- @param radius_x number
-- @param radius_y number
-- @param col_rgba number
-- @param number rotIn Optional
-- @param integer num_segmentsIn Optional
function ImGui:draw_list_add_ellipse_filled(draw_list, center_x, center_y, radius_x, radius_y, col_rgba, number, integer)
    local number = number or nil
    local integer = integer or nil
    return r.ImGui_DrawList_AddEllipseFilled(draw_list, center_x, center_y, radius_x, radius_y, col_rgba, number, integer)
end


--- Draw List Add Image. Wraps ImGui_DrawList_AddImage.
-- @param draw_list ImGui_DrawList
-- @param image ImGui_Image
-- @param p_min_x number
-- @param p_min_y number
-- @param p_max_x number
-- @param p_max_y number
-- @param number uv_min_xIn Optional
-- @param number uv_min_yIn Optional
-- @param number uv_max_xIn Optional
-- @param number uv_max_yIn Optional
-- @param integer col_rgbaIn Optional
function ImGui:draw_list_add_image(draw_list, image, p_min_x, p_min_y, p_max_x, p_max_y, number, number, number, number, integer)
    local number = number or nil
    local integer = integer or nil
    return r.ImGui_DrawList_AddImage(draw_list, image, p_min_x, p_min_y, p_max_x, p_max_y, number, number, number, number, integer)
end


--- Draw List Add Image Quad. Wraps ImGui_DrawList_AddImageQuad.
-- @param draw_list ImGui_DrawList
-- @param image ImGui_Image
-- @param p1_x number
-- @param p1_y number
-- @param p2_x number
-- @param p2_y number
-- @param p3_x number
-- @param p3_y number
-- @param p4_x number
-- @param p4_y number
-- @param number uv1_xIn Optional
-- @param number uv1_yIn Optional
-- @param number uv2_xIn Optional
-- @param number uv2_yIn Optional
-- @param number uv3_xIn Optional
-- @param number uv3_yIn Optional
-- @param number uv4_xIn Optional
-- @param number uv4_yIn Optional
-- @param integer col_rgbaIn Optional
function ImGui:draw_list_add_image_quad(draw_list, image, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, number, number, number, number, number, number, number, number, integer)
    local number = number or nil
    local integer = integer or nil
    return r.ImGui_DrawList_AddImageQuad(draw_list, image, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, number, number, number, number, number, number, number, number, integer)
end


--- Draw List Add Image Rounded. Wraps ImGui_DrawList_AddImageRounded.
-- @param draw_list ImGui_DrawList
-- @param image ImGui_Image
-- @param p_min_x number
-- @param p_min_y number
-- @param p_max_x number
-- @param p_max_y number
-- @param uv_min_x number
-- @param uv_min_y number
-- @param uv_max_x number
-- @param uv_max_y number
-- @param col_rgba number
-- @param rounding number
-- @param integer flagsIn Optional
function ImGui:draw_list_add_image_rounded(draw_list, image, p_min_x, p_min_y, p_max_x, p_max_y, uv_min_x, uv_min_y, uv_max_x, uv_max_y, col_rgba, rounding, integer)
    local integer = integer or nil
    return r.ImGui_DrawList_AddImageRounded(draw_list, image, p_min_x, p_min_y, p_max_x, p_max_y, uv_min_x, uv_min_y, uv_max_x, uv_max_y, col_rgba, rounding, integer)
end


--- Draw List Add Line. Wraps ImGui_DrawList_AddLine.
-- @param draw_list ImGui_DrawList
-- @param p1_x number
-- @param p1_y number
-- @param p2_x number
-- @param p2_y number
-- @param col_rgba number
-- @param number thicknessIn Optional
function ImGui:draw_list_add_line(draw_list, p1_x, p1_y, p2_x, p2_y, col_rgba, number)
    local number = number or nil
    return r.ImGui_DrawList_AddLine(draw_list, p1_x, p1_y, p2_x, p2_y, col_rgba, number)
end


--- Draw List Add Ngon. Wraps ImGui_DrawList_AddNgon.
-- @param draw_list ImGui_DrawList
-- @param center_x number
-- @param center_y number
-- @param radius number
-- @param col_rgba number
-- @param num_segments number
-- @param number thicknessIn Optional
function ImGui:draw_list_add_ngon(draw_list, center_x, center_y, radius, col_rgba, num_segments, number)
    local number = number or nil
    return r.ImGui_DrawList_AddNgon(draw_list, center_x, center_y, radius, col_rgba, num_segments, number)
end


--- Draw List Add Ngon Filled. Wraps ImGui_DrawList_AddNgonFilled.
-- @param draw_list ImGui_DrawList
-- @param center_x number
-- @param center_y number
-- @param radius number
-- @param col_rgba number
-- @param num_segments number
function ImGui:draw_list_add_ngon_filled(draw_list, center_x, center_y, radius, col_rgba, num_segments)
    return r.ImGui_DrawList_AddNgonFilled(draw_list, center_x, center_y, radius, col_rgba, num_segments)
end


--- Draw List Add Polyline. Wraps ImGui_DrawList_AddPolyline.
-- Points is a list of x,y coordinates.
-- @param draw_list ImGui_DrawList
-- @param points reaper_array
-- @param col_rgba number
-- @param flags number
-- @param thickness number
function ImGui:draw_list_add_polyline(draw_list, points, col_rgba, flags, thickness)
    return r.ImGui_DrawList_AddPolyline(draw_list, points, col_rgba, flags, thickness)
end


--- Draw List Add Quad. Wraps ImGui_DrawList_AddQuad.
-- @param draw_list ImGui_DrawList
-- @param p1_x number
-- @param p1_y number
-- @param p2_x number
-- @param p2_y number
-- @param p3_x number
-- @param p3_y number
-- @param p4_x number
-- @param p4_y number
-- @param col_rgba number
-- @param number thicknessIn Optional
function ImGui:draw_list_add_quad(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba, number)
    local number = number or nil
    return r.ImGui_DrawList_AddQuad(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba, number)
end


--- Draw List Add Quad Filled. Wraps ImGui_DrawList_AddQuadFilled.
-- @param draw_list ImGui_DrawList
-- @param p1_x number
-- @param p1_y number
-- @param p2_x number
-- @param p2_y number
-- @param p3_x number
-- @param p3_y number
-- @param p4_x number
-- @param p4_y number
-- @param col_rgba number
function ImGui:draw_list_add_quad_filled(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba)
    return r.ImGui_DrawList_AddQuadFilled(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba)
end


--- Draw List Add Rect. Wraps ImGui_DrawList_AddRect.
-- @param draw_list ImGui_DrawList
-- @param p_min_x number
-- @param p_min_y number
-- @param p_max_x number
-- @param p_max_y number
-- @param col_rgba number
-- @param number roundingIn Optional
-- @param integer flagsIn Optional
-- @param number thicknessIn Optional
function ImGui:draw_list_add_rect(draw_list, p_min_x, p_min_y, p_max_x, p_max_y, col_rgba, number, integer, number)
    local number = number or nil
    local integer = integer or nil
    return r.ImGui_DrawList_AddRect(draw_list, p_min_x, p_min_y, p_max_x, p_max_y, col_rgba, number, integer, number)
end


--- Draw List Add Rect Filled. Wraps ImGui_DrawList_AddRectFilled.
-- @param draw_list ImGui_DrawList
-- @param p_min_x number
-- @param p_min_y number
-- @param p_max_x number
-- @param p_max_y number
-- @param col_rgba number
-- @param number roundingIn Optional
-- @param integer flagsIn Optional
function ImGui:draw_list_add_rect_filled(draw_list, p_min_x, p_min_y, p_max_x, p_max_y, col_rgba, number, integer)
    local number = number or nil
    local integer = integer or nil
    return r.ImGui_DrawList_AddRectFilled(draw_list, p_min_x, p_min_y, p_max_x, p_max_y, col_rgba, number, integer)
end


--- Draw List Add Rect Filled Multi Color. Wraps ImGui_DrawList_AddRectFilledMultiColor.
-- @param draw_list ImGui_DrawList
-- @param p_min_x number
-- @param p_min_y number
-- @param p_max_x number
-- @param p_max_y number
-- @param col_upr_left number
-- @param col_upr_right number
-- @param col_bot_right number
-- @param col_bot_left number
function ImGui:draw_list_add_rect_filled_multi_color(draw_list, p_min_x, p_min_y, p_max_x, p_max_y, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
    return r.ImGui_DrawList_AddRectFilledMultiColor(draw_list, p_min_x, p_min_y, p_max_x, p_max_y, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
end


--- Draw List Add Text. Wraps ImGui_DrawList_AddText.
-- @param draw_list ImGui_DrawList
-- @param x number
-- @param y number
-- @param col_rgba number
-- @param text string
function ImGui:draw_list_add_text(draw_list, x, y, col_rgba, text)
    return r.ImGui_DrawList_AddText(draw_list, x, y, col_rgba, text)
end


--- Draw List Add Text Ex. Wraps ImGui_DrawList_AddTextEx.
-- The last pushed font is used if font is nil. The size of the last pushed font is
-- used if font_size is 0. cpu_fine_clip_rect_* only takes effect if all four are
-- non-nil.
-- @param draw_list ImGui_DrawList
-- @param font ImGui_Font
-- @param font_size number
-- @param pos_x number
-- @param pos_y number
-- @param col_rgba number
-- @param text string
-- @param number wrap_widthIn Optional
-- @param number cpu_fine_clip_rect_min_xIn Optional
-- @param number cpu_fine_clip_rect_min_yIn Optional
-- @param number cpu_fine_clip_rect_max_xIn Optional
-- @param number cpu_fine_clip_rect_max_yIn Optional
function ImGui:draw_list_add_text_ex(draw_list, font, font_size, pos_x, pos_y, col_rgba, text, number, number, number, number, number)
    local number = number or nil
    return r.ImGui_DrawList_AddTextEx(draw_list, font, font_size, pos_x, pos_y, col_rgba, text, number, number, number, number, number)
end


--- Draw List Add Triangle. Wraps ImGui_DrawList_AddTriangle.
-- @param draw_list ImGui_DrawList
-- @param p1_x number
-- @param p1_y number
-- @param p2_x number
-- @param p2_y number
-- @param p3_x number
-- @param p3_y number
-- @param col_rgba number
-- @param number thicknessIn Optional
function ImGui:draw_list_add_triangle(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba, number)
    local number = number or nil
    return r.ImGui_DrawList_AddTriangle(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba, number)
end


--- Draw List Add Triangle Filled. Wraps ImGui_DrawList_AddTriangleFilled.
-- @param draw_list ImGui_DrawList
-- @param p1_x number
-- @param p1_y number
-- @param p2_x number
-- @param p2_y number
-- @param p3_x number
-- @param p3_y number
-- @param col_rgba number
function ImGui:draw_list_add_triangle_filled(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba)
    return r.ImGui_DrawList_AddTriangleFilled(draw_list, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba)
end


--- Draw List Path Arc To. Wraps ImGui_DrawList_PathArcTo.
-- @param draw_list ImGui_DrawList
-- @param center_x number
-- @param center_y number
-- @param radius number
-- @param a_min number
-- @param a_max number
-- @param integer num_segmentsIn Optional
function ImGui:draw_list_path_arc_to(draw_list, center_x, center_y, radius, a_min, a_max, integer)
    local integer = integer or nil
    return r.ImGui_DrawList_PathArcTo(draw_list, center_x, center_y, radius, a_min, a_max, integer)
end


--- Draw List Path Arc To Fast. Wraps ImGui_DrawList_PathArcToFast.
-- Use precomputed angles for a 12 steps circle.
-- @param draw_list ImGui_DrawList
-- @param center_x number
-- @param center_y number
-- @param radius number
-- @param a_min_of_12 number
-- @param a_max_of_12 number
function ImGui:draw_list_path_arc_to_fast(draw_list, center_x, center_y, radius, a_min_of_12, a_max_of_12)
    return r.ImGui_DrawList_PathArcToFast(draw_list, center_x, center_y, radius, a_min_of_12, a_max_of_12)
end


--- Draw List Path Bezier Cubic Curve To. Wraps ImGui_DrawList_PathBezierCubicCurveTo.
-- Cubic Bezier (4 control points)
-- @param draw_list ImGui_DrawList
-- @param p2_x number
-- @param p2_y number
-- @param p3_x number
-- @param p3_y number
-- @param p4_x number
-- @param p4_y number
-- @param integer num_segmentsIn Optional
function ImGui:draw_list_path_bezier_cubic_curve_to(draw_list, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, integer)
    local integer = integer or nil
    return r.ImGui_DrawList_PathBezierCubicCurveTo(draw_list, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, integer)
end


--- Draw List Path Bezier Quadratic Curve To. Wraps ImGui_DrawList_PathBezierQuadraticCurveTo.
-- Quadratic Bezier (3 control points)
-- @param draw_list ImGui_DrawList
-- @param p2_x number
-- @param p2_y number
-- @param p3_x number
-- @param p3_y number
-- @param integer num_segmentsIn Optional
function ImGui:draw_list_path_bezier_quadratic_curve_to(draw_list, p2_x, p2_y, p3_x, p3_y, integer)
    local integer = integer or nil
    return r.ImGui_DrawList_PathBezierQuadraticCurveTo(draw_list, p2_x, p2_y, p3_x, p3_y, integer)
end


--- Draw List Path Clear. Wraps ImGui_DrawList_PathClear.
-- @param draw_list ImGui_DrawList
function ImGui:draw_list_path_clear(draw_list)
    return r.ImGui_DrawList_PathClear(draw_list)
end


--- Draw List Path Elliptical Arc To. Wraps ImGui_DrawList_PathEllipticalArcTo.
-- Ellipse
-- @param draw_list ImGui_DrawList
-- @param center_x number
-- @param center_y number
-- @param radius_x number
-- @param radius_y number
-- @param rot number
-- @param a_min number
-- @param a_max number
-- @param integer num_segmentsIn Optional
function ImGui:draw_list_path_elliptical_arc_to(draw_list, center_x, center_y, radius_x, radius_y, rot, a_min, a_max, integer)
    local integer = integer or nil
    return r.ImGui_DrawList_PathEllipticalArcTo(draw_list, center_x, center_y, radius_x, radius_y, rot, a_min, a_max, integer)
end


--- Draw List Path Fill Concave. Wraps ImGui_DrawList_PathFillConcave.
-- @param draw_list ImGui_DrawList
-- @param col_rgba number
function ImGui:draw_list_path_fill_concave(draw_list, col_rgba)
    return r.ImGui_DrawList_PathFillConcave(draw_list, col_rgba)
end


--- Draw List Path Fill Convex. Wraps ImGui_DrawList_PathFillConvex.
-- @param draw_list ImGui_DrawList
-- @param col_rgba number
function ImGui:draw_list_path_fill_convex(draw_list, col_rgba)
    return r.ImGui_DrawList_PathFillConvex(draw_list, col_rgba)
end


--- Draw List Path Line To. Wraps ImGui_DrawList_PathLineTo.
-- @param draw_list ImGui_DrawList
-- @param pos_x number
-- @param pos_y number
function ImGui:draw_list_path_line_to(draw_list, pos_x, pos_y)
    return r.ImGui_DrawList_PathLineTo(draw_list, pos_x, pos_y)
end


--- Draw List Path Rect. Wraps ImGui_DrawList_PathRect.
-- @param draw_list ImGui_DrawList
-- @param rect_min_x number
-- @param rect_min_y number
-- @param rect_max_x number
-- @param rect_max_y number
-- @param number roundingIn Optional
-- @param integer flagsIn Optional
function ImGui:draw_list_path_rect(draw_list, rect_min_x, rect_min_y, rect_max_x, rect_max_y, number, integer)
    local number = number or nil
    local integer = integer or nil
    return r.ImGui_DrawList_PathRect(draw_list, rect_min_x, rect_min_y, rect_max_x, rect_max_y, number, integer)
end


--- Draw List Path Stroke. Wraps ImGui_DrawList_PathStroke.
-- @param draw_list ImGui_DrawList
-- @param col_rgba number
-- @param integer flagsIn Optional
-- @param number thicknessIn Optional
function ImGui:draw_list_path_stroke(draw_list, col_rgba, integer, number)
    local integer = integer or nil
    local number = number or nil
    return r.ImGui_DrawList_PathStroke(draw_list, col_rgba, integer, number)
end


--- Draw List Pop Clip Rect. Wraps ImGui_DrawList_PopClipRect.
-- See DrawList_PushClipRect
-- @param draw_list ImGui_DrawList
function ImGui:draw_list_pop_clip_rect(draw_list)
    return r.ImGui_DrawList_PopClipRect(draw_list)
end


--- Draw List Push Clip Rect. Wraps ImGui_DrawList_PushClipRect.
-- Render-level scissoring. Prefer using higher-level PushClipRect to affect logic
-- (hit-testing and widget culling).
-- @param draw_list ImGui_DrawList
-- @param clip_rect_min_x number
-- @param clip_rect_min_y number
-- @param clip_rect_max_x number
-- @param clip_rect_max_y number
-- @param boolean intersect_with_current_clip_rectIn Optional
function ImGui:draw_list_push_clip_rect(draw_list, clip_rect_min_x, clip_rect_min_y, clip_rect_max_x, clip_rect_max_y, boolean)
    local boolean = boolean or nil
    return r.ImGui_DrawList_PushClipRect(draw_list, clip_rect_min_x, clip_rect_min_y, clip_rect_max_x, clip_rect_max_y, boolean)
end


--- Draw List Push Clip Rect Full Screen. Wraps ImGui_DrawList_PushClipRectFullScreen.
-- @param draw_list ImGui_DrawList
function ImGui:draw_list_push_clip_rect_full_screen(draw_list)
    return r.ImGui_DrawList_PushClipRectFullScreen(draw_list)
end


--- Dummy. Wraps ImGui_Dummy.
-- Add a dummy item of given size. unlike InvisibleButton, Dummy() won't take the
-- mouse click or be navigable into.
-- @param ctx ImGui_Context
-- @param size_w number
-- @param size_h number
function ImGui:dummy(ctx, size_w, size_h)
    return r.ImGui_Dummy(ctx, size_w, size_h)
end


--- End . Wraps ImGui_End.
-- Pop window from the stack. See Begin.
-- @param ctx ImGui_Context
function ImGui:end_(ctx)
    return r.ImGui_End(ctx)
end


--- End Child. Wraps ImGui_EndChild.
-- See BeginChild.
-- @param ctx ImGui_Context
function ImGui:end_child(ctx)
    return r.ImGui_EndChild(ctx)
end


--- End Combo. Wraps ImGui_EndCombo.
-- Only call EndCombo() if BeginCombo returns true!
-- @param ctx ImGui_Context
function ImGui:end_combo(ctx)
    return r.ImGui_EndCombo(ctx)
end


--- End Disabled. Wraps ImGui_EndDisabled.
-- See BeginDisabled.
-- @param ctx ImGui_Context
function ImGui:end_disabled(ctx)
    return r.ImGui_EndDisabled(ctx)
end


--- End Drag Drop Source. Wraps ImGui_EndDragDropSource.
-- Only call EndDragDropSource() if BeginDragDropSource returns true!
-- @param ctx ImGui_Context
function ImGui:end_drag_drop_source(ctx)
    return r.ImGui_EndDragDropSource(ctx)
end


--- End Drag Drop Target. Wraps ImGui_EndDragDropTarget.
-- Only call EndDragDropTarget() if BeginDragDropTarget returns true!
-- @param ctx ImGui_Context
function ImGui:end_drag_drop_target(ctx)
    return r.ImGui_EndDragDropTarget(ctx)
end


--- End Group. Wraps ImGui_EndGroup.
-- Unlock horizontal starting position + capture the whole group bounding box into
-- one "item" (so you can use IsItemHovered or layout primitives such as SameLine
-- on whole group, etc.).
-- @param ctx ImGui_Context
function ImGui:end_group(ctx)
    return r.ImGui_EndGroup(ctx)
end


--- End List Box. Wraps ImGui_EndListBox.
-- Only call EndListBox() if BeginListBox returned true!
-- @param ctx ImGui_Context
function ImGui:end_list_box(ctx)
    return r.ImGui_EndListBox(ctx)
end


--- End Menu. Wraps ImGui_EndMenu.
-- Only call EndMenu() if BeginMenu returns true!
-- @param ctx ImGui_Context
function ImGui:end_menu(ctx)
    return r.ImGui_EndMenu(ctx)
end


--- End Menu Bar. Wraps ImGui_EndMenuBar.
-- Only call EndMenuBar if BeginMenuBar returns true!
-- @param ctx ImGui_Context
function ImGui:end_menu_bar(ctx)
    return r.ImGui_EndMenuBar(ctx)
end


--- End Popup. Wraps ImGui_EndPopup.
-- Only call EndPopup() if BeginPopup*() returns true!
-- @param ctx ImGui_Context
function ImGui:end_popup(ctx)
    return r.ImGui_EndPopup(ctx)
end


--- End Tab Bar. Wraps ImGui_EndTabBar.
-- Only call EndTabBar() if BeginTabBar() returns true!
-- @param ctx ImGui_Context
function ImGui:end_tab_bar(ctx)
    return r.ImGui_EndTabBar(ctx)
end


--- End Tab Item. Wraps ImGui_EndTabItem.
-- Only call EndTabItem() if BeginTabItem() returns true!
-- @param ctx ImGui_Context
function ImGui:end_tab_item(ctx)
    return r.ImGui_EndTabItem(ctx)
end


--- End Table. Wraps ImGui_EndTable.
-- Only call EndTable() if BeginTable() returns true!
-- @param ctx ImGui_Context
function ImGui:end_table(ctx)
    return r.ImGui_EndTable(ctx)
end


--- End Tooltip. Wraps ImGui_EndTooltip.
-- Only call EndTooltip() if BeginTooltip()/BeginItemTooltip() returns true.
-- @param ctx ImGui_Context
function ImGui:end_tooltip(ctx)
    return r.ImGui_EndTooltip(ctx)
end


--- Focused Flags Any Window. Wraps ImGui_FocusedFlags_AnyWindow.
-- Return true if any window is focused.
-- @return number
function ImGui:focused_flags_any_window()
    return r.ImGui_FocusedFlags_AnyWindow()
end


--- Focused Flags Child Windows. Wraps ImGui_FocusedFlags_ChildWindows.
-- Return true if any children of the window is focused.
-- @return number
function ImGui:focused_flags_child_windows()
    return r.ImGui_FocusedFlags_ChildWindows()
end


--- Focused Flags Dock Hierarchy. Wraps ImGui_FocusedFlags_DockHierarchy.
-- Consider docking hierarchy (treat dockspace host as parent of docked window)
-- (when used with _ChildWindows or _RootWindow).
-- @return number
function ImGui:focused_flags_dock_hierarchy()
    return r.ImGui_FocusedFlags_DockHierarchy()
end


--- Focused Flags No Popup Hierarchy. Wraps ImGui_FocusedFlags_NoPopupHierarchy.
-- Do not consider popup hierarchy (do not treat popup emitter as parent of
-- popup) (when used with _ChildWindows or _RootWindow).
-- @return number
function ImGui:focused_flags_no_popup_hierarchy()
    return r.ImGui_FocusedFlags_NoPopupHierarchy()
end


--- Focused Flags None. Wraps ImGui_FocusedFlags_None.
-- @return number
function ImGui:focused_flags_none()
    return r.ImGui_FocusedFlags_None()
end


--- Focused Flags Root And Child Windows. Wraps ImGui_FocusedFlags_RootAndChildWindows.
-- FocusedFlags_RootWindow | FocusedFlags_ChildWindows
-- @return number
function ImGui:focused_flags_root_and_child_windows()
    return r.ImGui_FocusedFlags_RootAndChildWindows()
end


--- Focused Flags Root Window. Wraps ImGui_FocusedFlags_RootWindow.
-- Test from root window (top most parent of the current hierarchy).
-- @return number
function ImGui:focused_flags_root_window()
    return r.ImGui_FocusedFlags_RootWindow()
end


--- Font Flags Bold. Wraps ImGui_FontFlags_Bold.
-- @return number
function ImGui:font_flags_bold()
    return r.ImGui_FontFlags_Bold()
end


--- Font Flags Italic. Wraps ImGui_FontFlags_Italic.
-- @return number
function ImGui:font_flags_italic()
    return r.ImGui_FontFlags_Italic()
end


--- Font Flags None. Wraps ImGui_FontFlags_None.
-- @return number
function ImGui:font_flags_none()
    return r.ImGui_FontFlags_None()
end


--- Function Execute. Wraps ImGui_Function_Execute.
-- @param func ImGui_Function
function ImGui:function_execute(func)
    return r.ImGui_Function_Execute(func)
end


--- Function Get Value. Wraps ImGui_Function_GetValue.
-- @param func ImGui_Function
-- @param name string
-- @return number
function ImGui:function_get_value(func, name)
    return r.ImGui_Function_GetValue(func, name)
end


--- Function Get Value Array. Wraps ImGui_Function_GetValue_Array.
-- Copy the values in the function's memory starting at the address stored in the
-- given variable into the array.
-- @param func ImGui_Function
-- @param name string
-- @param values reaper_array
function ImGui:function_get_value_array(func, name, values)
    return r.ImGui_Function_GetValue_Array(func, name, values)
end


--- Function Get Value String. Wraps ImGui_Function_GetValue_String.
-- Read from a string slot or a named string (when name starts with a `#`).
-- @param func ImGui_Function
-- @param name string
-- @return value string
function ImGui:function_get_value_string(func, name)
    return r.ImGui_Function_GetValue_String(func, name)
end


--- Function Set Value. Wraps ImGui_Function_SetValue.
-- @param func ImGui_Function
-- @param name string
-- @param value number
function ImGui:function_set_value(func, name, value)
    return r.ImGui_Function_SetValue(func, name, value)
end


--- Function Set Value Array. Wraps ImGui_Function_SetValue_Array.
-- Copy the values in the array to the function's memory at the address stored in
-- the given variable.
-- @param func ImGui_Function
-- @param name string
-- @param values reaper_array
function ImGui:function_set_value_array(func, name, values)
    return r.ImGui_Function_SetValue_Array(func, name, values)
end


--- Function Set Value String. Wraps ImGui_Function_SetValue_String.
-- Write to a string slot or a named string (when name starts with a `#`).
-- @param func ImGui_Function
-- @param name string
-- @param value string
function ImGui:function_set_value_string(func, name, value)
    return r.ImGui_Function_SetValue_String(func, name, value)
end


--- Get Background Draw List. Wraps ImGui_GetBackgroundDrawList.
-- This draw list will be the first rendering one. Useful to quickly draw
-- shapes/text behind dear imgui contents.
-- @param ctx ImGui_Context
-- @return ImGui_DrawList
function ImGui:get_background_draw_list(ctx)
    return r.ImGui_GetBackgroundDrawList(ctx)
end


--- Get Builtin Path. Wraps ImGui_GetBuiltinPath.
-- Returns the path to the directory containing imgui.lua, imgui.py and
-- gfx2imgui.lua.
-- @return string
function ImGui:get_builtin_path()
    return r.ImGui_GetBuiltinPath()
end


--- Get Clipboard Text. Wraps ImGui_GetClipboardText.
-- @param ctx ImGui_Context
-- @return string
function ImGui:get_clipboard_text(ctx)
    return r.ImGui_GetClipboardText(ctx)
end


--- Get Color. Wraps ImGui_GetColor.
-- Retrieve given style color with style alpha applied and optional extra alpha
-- multiplier, packed as a 32-bit value (RGBA). See Col_* for available style
-- colors.
-- @param ctx ImGui_Context
-- @param idx number
-- @param number alpha_mulIn Optional
-- @return number
function ImGui:get_color(ctx, idx, number)
    local number = number or nil
    return r.ImGui_GetColor(ctx, idx, number)
end


--- Get Color Ex. Wraps ImGui_GetColorEx.
-- Retrieve given color with style alpha applied, packed as a 32-bit value (RGBA).
-- @param ctx ImGui_Context
-- @param col_rgba number
-- @param number alpha_mulIn Optional
-- @return number
function ImGui:get_color_ex(ctx, col_rgba, number)
    local number = number or nil
    return r.ImGui_GetColorEx(ctx, col_rgba, number)
end


--- Get Config Var. Wraps ImGui_GetConfigVar.
-- @param ctx ImGui_Context
-- @param var_idx number
-- @return number
function ImGui:get_config_var(ctx, var_idx)
    return r.ImGui_GetConfigVar(ctx, var_idx)
end


--- Get Content Region Avail. Wraps ImGui_GetContentRegionAvail.
-- == GetContentRegionMax() - GetCursorPos()
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_content_region_avail(ctx)
    return r.ImGui_GetContentRegionAvail(ctx)
end


--- Get Content Region Max. Wraps ImGui_GetContentRegionMax.
-- Current content boundaries (typically window boundaries including scrolling, or
-- current column boundaries), in windows coordinates.
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_content_region_max(ctx)
    return r.ImGui_GetContentRegionMax(ctx)
end


--- Get Cursor Pos. Wraps ImGui_GetCursorPos.
-- Cursor position in window
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_cursor_pos(ctx)
    return r.ImGui_GetCursorPos(ctx)
end


--- Get Cursor Pos X. Wraps ImGui_GetCursorPosX.
-- Cursor X position in window
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_cursor_pos_x(ctx)
    return r.ImGui_GetCursorPosX(ctx)
end


--- Get Cursor Pos Y. Wraps ImGui_GetCursorPosY.
-- Cursor Y position in window
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_cursor_pos_y(ctx)
    return r.ImGui_GetCursorPosY(ctx)
end


--- Get Cursor Screen Pos. Wraps ImGui_GetCursorScreenPos.
-- Cursor position in absolute screen coordinates (useful to work with the DrawList
-- API).
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_cursor_screen_pos(ctx)
    return r.ImGui_GetCursorScreenPos(ctx)
end


--- Get Cursor Start Pos. Wraps ImGui_GetCursorStartPos.
-- Initial cursor position in window coordinates.
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_cursor_start_pos(ctx)
    return r.ImGui_GetCursorStartPos(ctx)
end


--- Get Delta Time. Wraps ImGui_GetDeltaTime.
-- Time elapsed since last frame, in seconds.
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_delta_time(ctx)
    return r.ImGui_GetDeltaTime(ctx)
end


--- Get Drag Drop Payload. Wraps ImGui_GetDragDropPayload.
-- Peek directly into the current payload from anywhere. Returns false when drag
-- and drop is finished or inactive.
-- @param ctx ImGui_Context
-- @return type string
-- @return payload string
-- @return is_preview boolean
-- @return is_delivery boolean
function ImGui:get_drag_drop_payload(ctx)
    local ret_val, type, payload, is_preview, is_delivery = r.ImGui_GetDragDropPayload(ctx)
    if ret_val then
        return type, payload, is_preview, is_delivery
    else
        return nil
    end
end


--- Get Drag Drop Payload File. Wraps ImGui_GetDragDropPayloadFile.
-- Get a filename from the list of dropped files. Returns false if index is out of
-- bounds.
-- @param ctx ImGui_Context
-- @param index number
-- @return file_name string
function ImGui:get_drag_drop_payload_file(ctx, index)
    local ret_val, file_name = r.ImGui_GetDragDropPayloadFile(ctx, index)
    if ret_val then
        return file_name
    else
        return nil
    end
end


--- Get Font. Wraps ImGui_GetFont.
-- Get the current font
-- @param ctx ImGui_Context
-- @return ImGui_Font
function ImGui:get_font(ctx)
    return r.ImGui_GetFont(ctx)
end


--- Get Font Size. Wraps ImGui_GetFontSize.
-- Get current font size (= height in pixels) of current font with current scale
-- applied.
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_font_size(ctx)
    return r.ImGui_GetFontSize(ctx)
end


--- Get Foreground Draw List. Wraps ImGui_GetForegroundDrawList.
-- This draw list will be the last rendered one. Useful to quickly draw shapes/text
-- over dear imgui contents.
-- @param ctx ImGui_Context
-- @return ImGui_DrawList
function ImGui:get_foreground_draw_list(ctx)
    return r.ImGui_GetForegroundDrawList(ctx)
end


--- Get Frame Count. Wraps ImGui_GetFrameCount.
-- Get global imgui frame count. incremented by 1 every frame.
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_frame_count(ctx)
    return r.ImGui_GetFrameCount(ctx)
end


--- Get Frame Height. Wraps ImGui_GetFrameHeight.
-- GetFontSize + StyleVar_FramePadding.y * 2
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_frame_height(ctx)
    return r.ImGui_GetFrameHeight(ctx)
end


--- Get Frame Height With Spacing. Wraps ImGui_GetFrameHeightWithSpacing.
-- GetFontSize + StyleVar_FramePadding.y * 2 + StyleVar_ItemSpacing.y (distance in
-- pixels between 2 consecutive lines of framed widgets).
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_frame_height_with_spacing(ctx)
    return r.ImGui_GetFrameHeightWithSpacing(ctx)
end


--- Get Framerate. Wraps ImGui_GetFramerate.
-- Estimate of application framerate (rolling average over 60 frames, based on
-- GetDeltaTime), in frame per second. Solely for convenience.
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_framerate(ctx)
    return r.ImGui_GetFramerate(ctx)
end


--- Get Input Queue Character. Wraps ImGui_GetInputQueueCharacter.
-- Read from ImGui's character input queue. Call with increasing idx until false is
-- returned.
-- @param ctx ImGui_Context
-- @param idx number
-- @return unicode_char number
function ImGui:get_input_queue_character(ctx, idx)
    local ret_val, unicode_char = r.ImGui_GetInputQueueCharacter(ctx, idx)
    if ret_val then
        return unicode_char
    else
        return nil
    end
end


--- Get Item Rect Max. Wraps ImGui_GetItemRectMax.
-- Get lower-right bounding rectangle of the last item (screen space)
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_item_rect_max(ctx)
    return r.ImGui_GetItemRectMax(ctx)
end


--- Get Item Rect Min. Wraps ImGui_GetItemRectMin.
-- Get upper-left bounding rectangle of the last item (screen space)
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_item_rect_min(ctx)
    return r.ImGui_GetItemRectMin(ctx)
end


--- Get Item Rect Size. Wraps ImGui_GetItemRectSize.
-- Get size of last item
-- @param ctx ImGui_Context
-- @return w number
-- @return h number
function ImGui:get_item_rect_size(ctx)
    return r.ImGui_GetItemRectSize(ctx)
end


--- Get Key Down Duration. Wraps ImGui_GetKeyDownDuration.
-- Duration the keyboard key has been down (0.0 == just pressed)
-- @param ctx ImGui_Context
-- @param key number
-- @return number
function ImGui:get_key_down_duration(ctx, key)
    return r.ImGui_GetKeyDownDuration(ctx, key)
end


--- Get Key Mods. Wraps ImGui_GetKeyMods.
-- Flags for the Ctrl/Shift/Alt/Super keys. Uses Mod_* values.
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_key_mods(ctx)
    return r.ImGui_GetKeyMods(ctx)
end


--- Get Key Pressed Amount. Wraps ImGui_GetKeyPressedAmount.
-- Uses provided repeat rate/delay. Return a count, most often 0 or 1 but might be
-- >1 if ConfigVar_RepeatRate is small enough that GetDeltaTime > RepeatRate.
-- @param ctx ImGui_Context
-- @param key number
-- @param repeat_delay number
-- @param rate number
-- @return number
function ImGui:get_key_pressed_amount(ctx, key, repeat_delay, rate)
    return r.ImGui_GetKeyPressedAmount(ctx, key, repeat_delay, rate)
end


--- Get Main Viewport. Wraps ImGui_GetMainViewport.
-- Currently represents REAPER's main window (arrange view). WARNING: This may
-- change or be removed in the future.
-- @param ctx ImGui_Context
-- @return ImGui_Viewport
function ImGui:get_main_viewport(ctx)
    return r.ImGui_GetMainViewport(ctx)
end


--- Get Mouse Clicked Count. Wraps ImGui_GetMouseClickedCount.
-- Return the number of successive mouse-clicks at the time where a click happen
-- (otherwise 0).
-- @param ctx ImGui_Context
-- @param button number
-- @return number
function ImGui:get_mouse_clicked_count(ctx, button)
    return r.ImGui_GetMouseClickedCount(ctx, button)
end


--- Get Mouse Clicked Pos. Wraps ImGui_GetMouseClickedPos.
-- @param ctx ImGui_Context
-- @param button number
-- @return x number
-- @return y number
function ImGui:get_mouse_clicked_pos(ctx, button)
    return r.ImGui_GetMouseClickedPos(ctx, button)
end


--- Get Mouse Cursor. Wraps ImGui_GetMouseCursor.
-- Get desired mouse cursor shape, reset every frame. This is updated during the
-- frame.
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_mouse_cursor(ctx)
    return r.ImGui_GetMouseCursor(ctx)
end


--- Get Mouse Delta. Wraps ImGui_GetMouseDelta.
-- Mouse delta. Note that this is zero if either current or previous position are
-- invalid (-FLT_MAX,-FLT_MAX), so a disappearing/reappearing mouse won't have a
-- huge delta.
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_mouse_delta(ctx)
    return r.ImGui_GetMouseDelta(ctx)
end


--- Get Mouse Down Duration. Wraps ImGui_GetMouseDownDuration.
-- Duration the mouse button has been down (0.0 == just clicked)
-- @param ctx ImGui_Context
-- @param button number
-- @return number
function ImGui:get_mouse_down_duration(ctx, button)
    return r.ImGui_GetMouseDownDuration(ctx, button)
end


--- Get Mouse Drag Delta. Wraps ImGui_GetMouseDragDelta.
-- Return the delta from the initial clicking position while the mouse button is
-- pressed or was just released. This is locked and return 0.0 until the mouse
-- moves past a distance threshold at least once (uses ConfigVar_MouseDragThreshold
-- if lock_threshold < 0.0).
-- @param ctx ImGui_Context
-- @param x number
-- @param y number
-- @param integer buttonIn Optional
-- @param number lock_thresholdIn Optional
-- @return x number
-- @return y number
function ImGui:get_mouse_drag_delta(ctx, x, y, integer, number)
    local integer = integer or nil
    local number = number or nil
    return r.ImGui_GetMouseDragDelta(ctx, x, y, integer, number)
end


--- Get Mouse Pos. Wraps ImGui_GetMousePos.
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_mouse_pos(ctx)
    return r.ImGui_GetMousePos(ctx)
end


--- Get Mouse Pos On Opening Current Popup. Wraps ImGui_GetMousePosOnOpeningCurrentPopup.
-- Retrieve mouse position at the time of opening popup we have BeginPopup() into
-- (helper to avoid user backing that value themselves).
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_mouse_pos_on_opening_current_popup(ctx)
    return r.ImGui_GetMousePosOnOpeningCurrentPopup(ctx)
end


--- Get Mouse Wheel. Wraps ImGui_GetMouseWheel.
-- Vertical: 1 unit scrolls about 5 lines text. >0 scrolls Up, <0 scrolls Down.
-- Hold SHIFT to turn vertical scroll into horizontal scroll
-- @param ctx ImGui_Context
-- @return vertical number
-- @return horizontal number
function ImGui:get_mouse_wheel(ctx)
    return r.ImGui_GetMouseWheel(ctx)
end


--- Get Scroll Max X. Wraps ImGui_GetScrollMaxX.
-- Get maximum scrolling amount ~~ ContentSize.x - WindowSize.x - DecorationsSize.x
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_scroll_max_x(ctx)
    return r.ImGui_GetScrollMaxX(ctx)
end


--- Get Scroll Max Y. Wraps ImGui_GetScrollMaxY.
-- Get maximum scrolling amount ~~ ContentSize.y - WindowSize.y - DecorationsSize.y
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_scroll_max_y(ctx)
    return r.ImGui_GetScrollMaxY(ctx)
end


--- Get Scroll X. Wraps ImGui_GetScrollX.
-- Get scrolling amount [0 .. GetScrollMaxX()]
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_scroll_x(ctx)
    return r.ImGui_GetScrollX(ctx)
end


--- Get Scroll Y. Wraps ImGui_GetScrollY.
-- Get scrolling amount [0 .. GetScrollMaxY()]
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_scroll_y(ctx)
    return r.ImGui_GetScrollY(ctx)
end


--- Get Style Color. Wraps ImGui_GetStyleColor.
-- Retrieve style color as stored in ImGuiStyle structure. Use to feed back into
-- PushStyleColor, Otherwise use GetColor to get style color with style alpha baked
-- in. See Col_* for available style colors.
-- @param ctx ImGui_Context
-- @param idx number
-- @return number
function ImGui:get_style_color(ctx, idx)
    return r.ImGui_GetStyleColor(ctx, idx)
end


--- Get Style Var. Wraps ImGui_GetStyleVar.
-- @param ctx ImGui_Context
-- @param var_idx number
-- @return val1 number
-- @return val2 number
function ImGui:get_style_var(ctx, var_idx)
    return r.ImGui_GetStyleVar(ctx, var_idx)
end


--- Get Text Line Height. Wraps ImGui_GetTextLineHeight.
-- Same as GetFontSize
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_text_line_height(ctx)
    return r.ImGui_GetTextLineHeight(ctx)
end


--- Get Text Line Height With Spacing. Wraps ImGui_GetTextLineHeightWithSpacing.
-- GetFontSize + StyleVar_ItemSpacing.y (distance in pixels between 2 consecutive
-- lines of text).
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_text_line_height_with_spacing(ctx)
    return r.ImGui_GetTextLineHeightWithSpacing(ctx)
end


--- Get Time. Wraps ImGui_GetTime.
-- Get global imgui time. Incremented every frame.
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_time(ctx)
    return r.ImGui_GetTime(ctx)
end


--- Get Tree Node To Label Spacing. Wraps ImGui_GetTreeNodeToLabelSpacing.
-- Horizontal distance preceding label when using TreeNode*() or Bullet() ==
-- (GetFontSize + StyleVar_FramePadding.x*2) for a regular unframed TreeNode.
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_tree_node_to_label_spacing(ctx)
    return r.ImGui_GetTreeNodeToLabelSpacing(ctx)
end


--- Get Version. Wraps ImGui_GetVersion.
-- @return imgui_version string
-- @return imgui_version_num number
-- @return reaimgui_version string
function ImGui:get_version()
    return r.ImGui_GetVersion()
end


--- Get Window Content Region Max. Wraps ImGui_GetWindowContentRegionMax.
-- Content boundaries max (roughly (0,0)+Size-Scroll) where Size can be overridden
-- with SetNextWindowContentSize, in window coordinates.
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_window_content_region_max(ctx)
    return r.ImGui_GetWindowContentRegionMax(ctx)
end


--- Get Window Content Region Min. Wraps ImGui_GetWindowContentRegionMin.
-- Content boundaries min (roughly (0,0)-Scroll), in window coordinates.
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_window_content_region_min(ctx)
    return r.ImGui_GetWindowContentRegionMin(ctx)
end


--- Get Window Dock Id. Wraps ImGui_GetWindowDockID.
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_window_dock_id(ctx)
    return r.ImGui_GetWindowDockID(ctx)
end


--- Get Window Dpi Scale. Wraps ImGui_GetWindowDpiScale.
-- Get DPI scale currently associated to the current window's viewport (1.0 = 96
-- DPI).
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_window_dpi_scale(ctx)
    return r.ImGui_GetWindowDpiScale(ctx)
end


--- Get Window Draw List. Wraps ImGui_GetWindowDrawList.
-- The draw list associated to the current window, to append your own drawing
-- primitives
-- @param ctx ImGui_Context
-- @return ImGui_DrawList
function ImGui:get_window_draw_list(ctx)
    return r.ImGui_GetWindowDrawList(ctx)
end


--- Get Window Height. Wraps ImGui_GetWindowHeight.
-- Get current window height (shortcut for (GetWindowSize().h).
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_window_height(ctx)
    return r.ImGui_GetWindowHeight(ctx)
end


--- Get Window Pos. Wraps ImGui_GetWindowPos.
-- Get current window position in screen space (note: it is unlikely you need to
-- use this. Consider using current layout pos instead, GetCursorScreenPos()).
-- @param ctx ImGui_Context
-- @return x number
-- @return y number
function ImGui:get_window_pos(ctx)
    return r.ImGui_GetWindowPos(ctx)
end


--- Get Window Size. Wraps ImGui_GetWindowSize.
-- Get current window size (note: it is unlikely you need to use this. Consider
-- using GetCursorScreenPos() and e.g. GetContentRegionAvail() instead)
-- @param ctx ImGui_Context
-- @return w number
-- @return h number
function ImGui:get_window_size(ctx)
    return r.ImGui_GetWindowSize(ctx)
end


--- Get Window Viewport. Wraps ImGui_GetWindowViewport.
-- Get viewport currently associated to the current window.
-- @param ctx ImGui_Context
-- @return ImGui_Viewport
function ImGui:get_window_viewport(ctx)
    return r.ImGui_GetWindowViewport(ctx)
end


--- Get Window Width. Wraps ImGui_GetWindowWidth.
-- Get current window width (shortcut for (GetWindowSize().w).
-- @param ctx ImGui_Context
-- @return number
function ImGui:get_window_width(ctx)
    return r.ImGui_GetWindowWidth(ctx)
end


--- Hovered Flags Allow When Blocked By Active Item. Wraps ImGui_HoveredFlags_AllowWhenBlockedByActiveItem.
-- Return true even if an active item is blocking access to this item/window.
-- Useful for Drag and Drop patterns.
-- @return number
function ImGui:hovered_flags_allow_when_blocked_by_active_item()
    return r.ImGui_HoveredFlags_AllowWhenBlockedByActiveItem()
end


--- Hovered Flags Allow When Blocked By Popup. Wraps ImGui_HoveredFlags_AllowWhenBlockedByPopup.
-- Return true even if a popup window is normally blocking access to this
-- item/window.
-- @return number
function ImGui:hovered_flags_allow_when_blocked_by_popup()
    return r.ImGui_HoveredFlags_AllowWhenBlockedByPopup()
end


--- Hovered Flags Allow When Disabled. Wraps ImGui_HoveredFlags_AllowWhenDisabled.
-- Return true even if the item is disabled.
-- @return number
function ImGui:hovered_flags_allow_when_disabled()
    return r.ImGui_HoveredFlags_AllowWhenDisabled()
end


--- Hovered Flags Allow When Overlapped. Wraps ImGui_HoveredFlags_AllowWhenOverlapped.
-- HoveredFlags_AllowWhenOverlappedByItem |
-- HoveredFlags_AllowWhenOverlappedByWindow
-- @return number
function ImGui:hovered_flags_allow_when_overlapped()
    return r.ImGui_HoveredFlags_AllowWhenOverlapped()
end


--- Hovered Flags Allow When Overlapped By Item. Wraps ImGui_HoveredFlags_AllowWhenOverlappedByItem.
-- Return true even if the item uses AllowOverlap mode and is overlapped by
-- another hoverable item.
-- @return number
function ImGui:hovered_flags_allow_when_overlapped_by_item()
    return r.ImGui_HoveredFlags_AllowWhenOverlappedByItem()
end


--- Hovered Flags Allow When Overlapped By Window. Wraps ImGui_HoveredFlags_AllowWhenOverlappedByWindow.
-- Return true even if the position is obstructed or overlapped by another window.
-- @return number
function ImGui:hovered_flags_allow_when_overlapped_by_window()
    return r.ImGui_HoveredFlags_AllowWhenOverlappedByWindow()
end


--- Hovered Flags Any Window. Wraps ImGui_HoveredFlags_AnyWindow.
-- Return true if any window is hovered.
-- @return number
function ImGui:hovered_flags_any_window()
    return r.ImGui_HoveredFlags_AnyWindow()
end


--- Hovered Flags Child Windows. Wraps ImGui_HoveredFlags_ChildWindows.
-- Return true if any children of the window is hovered.
-- @return number
function ImGui:hovered_flags_child_windows()
    return r.ImGui_HoveredFlags_ChildWindows()
end


--- Hovered Flags Delay None. Wraps ImGui_HoveredFlags_DelayNone.
-- Return true immediately (default). As this is the default you generally ignore
-- this.
-- @return number
function ImGui:hovered_flags_delay_none()
    return r.ImGui_HoveredFlags_DelayNone()
end


--- Hovered Flags Delay Normal. Wraps ImGui_HoveredFlags_DelayNormal.
-- Return true after ConfigVar_HoverDelayNormal elapsed (~0.40 sec)    (shared
-- between items) + requires mouse to be stationary for
-- ConfigVar_HoverStationaryDelay (once per item).
-- @return number
function ImGui:hovered_flags_delay_normal()
    return r.ImGui_HoveredFlags_DelayNormal()
end


--- Hovered Flags Delay Short. Wraps ImGui_HoveredFlags_DelayShort.
-- Return true after ConfigVar_HoverDelayShort elapsed (~0.15 sec)    (shared
-- between items) + requires mouse to be stationary for
-- ConfigVar_HoverStationaryDelay (once per item).
-- @return number
function ImGui:hovered_flags_delay_short()
    return r.ImGui_HoveredFlags_DelayShort()
end


--- Hovered Flags Dock Hierarchy. Wraps ImGui_HoveredFlags_DockHierarchy.
-- Consider docking hierarchy (treat dockspace host as   parent of docked window)
-- (when used with _ChildWindows or _RootWindow).
-- @return number
function ImGui:hovered_flags_dock_hierarchy()
    return r.ImGui_HoveredFlags_DockHierarchy()
end


--- Hovered Flags For Tooltip. Wraps ImGui_HoveredFlags_ForTooltip.
-- Typically used with IsItemHovered() before SetTooltip().    This is a shortcut
-- to pull flags from ConfigVar_HoverFlagsForTooltip* where    you can reconfigure
-- the desired behavior.
-- @return number
function ImGui:hovered_flags_for_tooltip()
    return r.ImGui_HoveredFlags_ForTooltip()
end


--- Hovered Flags No Nav Override. Wraps ImGui_HoveredFlags_NoNavOverride.
-- Disable using gamepad/keyboard navigation state when active, always query mouse.
-- @return number
function ImGui:hovered_flags_no_nav_override()
    return r.ImGui_HoveredFlags_NoNavOverride()
end


--- Hovered Flags No Popup Hierarchy. Wraps ImGui_HoveredFlags_NoPopupHierarchy.
-- Do not consider popup hierarchy (do not treat popup   emitter as parent of
-- popup) (when used with _ChildWindows or _RootWindow).
-- @return number
function ImGui:hovered_flags_no_popup_hierarchy()
    return r.ImGui_HoveredFlags_NoPopupHierarchy()
end


--- Hovered Flags No Shared Delay. Wraps ImGui_HoveredFlags_NoSharedDelay.
-- Disable shared delay system where moving from one item to the next keeps    the
-- previous timer for a short time (standard for tooltips with long delays
-- @return number
function ImGui:hovered_flags_no_shared_delay()
    return r.ImGui_HoveredFlags_NoSharedDelay()
end


--- Hovered Flags None. Wraps ImGui_HoveredFlags_None.
-- Return true if directly over the item/window, not obstructed by another
-- window, not obstructed by an active popup or modal blocking inputs under them.
-- @return number
function ImGui:hovered_flags_none()
    return r.ImGui_HoveredFlags_None()
end


--- Hovered Flags Rect Only. Wraps ImGui_HoveredFlags_RectOnly.
-- HoveredFlags_AllowWhenBlockedByPopup |
-- HoveredFlags_AllowWhenBlockedByActiveItem | HoveredFlags_AllowWhenOverlapped
-- @return number
function ImGui:hovered_flags_rect_only()
    return r.ImGui_HoveredFlags_RectOnly()
end


--- Hovered Flags Root And Child Windows. Wraps ImGui_HoveredFlags_RootAndChildWindows.
-- HoveredFlags_RootWindow | HoveredFlags_ChildWindows
-- @return number
function ImGui:hovered_flags_root_and_child_windows()
    return r.ImGui_HoveredFlags_RootAndChildWindows()
end


--- Hovered Flags Root Window. Wraps ImGui_HoveredFlags_RootWindow.
-- Test from root window (top most parent of the current hierarchy).
-- @return number
function ImGui:hovered_flags_root_window()
    return r.ImGui_HoveredFlags_RootWindow()
end


--- Hovered Flags Stationary. Wraps ImGui_HoveredFlags_Stationary.
-- Require mouse to be stationary for ConfigVar_HoverStationaryDelay (~0.15 sec)
-- _at least one time_. After this, can move on same item/window.    Using the
-- stationary test tends to reduces the need for a long delay.
-- @return number
function ImGui:hovered_flags_stationary()
    return r.ImGui_HoveredFlags_Stationary()
end


--- Image. Wraps ImGui_Image.
-- Adds 2.0 to the provided size if a border is visible.
-- @param ctx ImGui_Context
-- @param image ImGui_Image
-- @param image_size_w number
-- @param image_size_h number
-- @param number uv0_xIn Optional
-- @param number uv0_yIn Optional
-- @param number uv1_xIn Optional
-- @param number uv1_yIn Optional
-- @param integer tint_col_rgbaIn Optional
-- @param integer border_col_rgbaIn Optional
function ImGui:image(ctx, image, image_size_w, image_size_h, number, number, number, number, integer, integer)
    local number = number or nil
    local integer = integer or nil
    return r.ImGui_Image(ctx, image, image_size_w, image_size_h, number, number, number, number, integer, integer)
end


--- Image Button. Wraps ImGui_ImageButton.
-- Adds StyleVar_FramePadding*2.0 to provided size.
-- @param ctx ImGui_Context
-- @param str_id string
-- @param image ImGui_Image
-- @param image_size_w number
-- @param image_size_h number
-- @param number uv0_xIn Optional
-- @param number uv0_yIn Optional
-- @param number uv1_xIn Optional
-- @param number uv1_yIn Optional
-- @param integer bg_col_rgbaIn Optional
-- @param integer tint_col_rgbaIn Optional
-- @return boolean
function ImGui:image_button(ctx, str_id, image, image_size_w, image_size_h, number, number, number, number, integer, integer)
    local number = number or nil
    local integer = integer or nil
    return r.ImGui_ImageButton(ctx, str_id, image, image_size_w, image_size_h, number, number, number, number, integer, integer)
end


--- Image Set Add. Wraps ImGui_ImageSet_Add.
-- 'img' cannot be another ImageSet.
-- @param set ImGui_ImageSet
-- @param scale number
-- @param image ImGui_Image
function ImGui:image_set_add(set, scale, image)
    return r.ImGui_ImageSet_Add(set, scale, image)
end


--- Image Get Size. Wraps ImGui_Image_GetSize.
-- @param image ImGui_Image
-- @return w number
-- @return h number
function ImGui:image_get_size(image)
    return r.ImGui_Image_GetSize(image)
end


--- Indent. Wraps ImGui_Indent.
-- Move content position toward the right, by 'indent_w', or StyleVar_IndentSpacing
-- if 'indent_w' <= 0. See Unindent.
-- @param ctx ImGui_Context
-- @param number indent_wIn Optional
function ImGui:indent(ctx, number)
    local number = number or nil
    return r.ImGui_Indent(ctx, number)
end


--- Input Double. Wraps ImGui_InputDouble.
-- @param ctx ImGui_Context
-- @param label string
-- @param v number
-- @param number stepIn Optional
-- @param number step_fastIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v number
function ImGui:input_double(ctx, label, v, number, number, string, integer)
    local number = number or nil
    local string = string or nil
    local integer = integer or nil
    local ret_val, v = r.ImGui_InputDouble(ctx, label, v, number, number, string, integer)
    if ret_val then
        return v
    else
        return nil
    end
end


--- Input Double2. Wraps ImGui_InputDouble2.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
function ImGui:input_double2(ctx, label, v1, v2, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2 = r.ImGui_InputDouble2(ctx, label, v1, v2, string, integer)
    if ret_val then
        return v1, v2
    else
        return nil
    end
end


--- Input Double3. Wraps ImGui_InputDouble3.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
function ImGui:input_double3(ctx, label, v1, v2, v3, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2, v3 = r.ImGui_InputDouble3(ctx, label, v1, v2, v3, string, integer)
    if ret_val then
        return v1, v2, v3
    else
        return nil
    end
end


--- Input Double4. Wraps ImGui_InputDouble4.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param v4 number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
-- @return v4 number
function ImGui:input_double4(ctx, label, v1, v2, v3, v4, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2, v3, v4 = r.ImGui_InputDouble4(ctx, label, v1, v2, v3, v4, string, integer)
    if ret_val then
        return v1, v2, v3, v4
    else
        return nil
    end
end


--- Input Double N. Wraps ImGui_InputDoubleN.
-- @param ctx ImGui_Context
-- @param label string
-- @param values reaper_array
-- @param number stepIn Optional
-- @param number step_fastIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:input_double_n(ctx, label, values, number, number, string, integer)
    local number = number or nil
    local string = string or nil
    local integer = integer or nil
    return r.ImGui_InputDoubleN(ctx, label, values, number, number, string, integer)
end


--- Input Flags None. Wraps ImGui_InputFlags_None.
-- @return number
function ImGui:input_flags_none()
    return r.ImGui_InputFlags_None()
end


--- Input Flags Repeat. Wraps ImGui_InputFlags_Repeat.
-- Enable repeat. Return true on successive repeats.
-- @return number
function ImGui:input_flags_repeat()
    return r.ImGui_InputFlags_Repeat()
end


--- Input Flags Route Active. Wraps ImGui_InputFlags_RouteActive.
-- Route to active item only.
-- @return number
function ImGui:input_flags_route_active()
    return r.ImGui_InputFlags_RouteActive()
end


--- Input Flags Route Always. Wraps ImGui_InputFlags_RouteAlways.
-- Do not register route, poll keys directly.
-- @return number
function ImGui:input_flags_route_always()
    return r.ImGui_InputFlags_RouteAlways()
end


--- Input Flags Route Focused. Wraps ImGui_InputFlags_RouteFocused.
-- Route to windows in the focus stack. Deep-most focused window takes inputs.
-- Active item takes inputs over deep-most focused window.
-- @return number
function ImGui:input_flags_route_focused()
    return r.ImGui_InputFlags_RouteFocused()
end


--- Input Flags Route From Root Window. Wraps ImGui_InputFlags_RouteFromRootWindow.
-- Option: route evaluated from the point of view of root window rather than
-- current window.
-- @return number
function ImGui:input_flags_route_from_root_window()
    return r.ImGui_InputFlags_RouteFromRootWindow()
end


--- Input Flags Route Global. Wraps ImGui_InputFlags_RouteGlobal.
-- Global route (unless a focused window or active item registered the route).
-- @return number
function ImGui:input_flags_route_global()
    return r.ImGui_InputFlags_RouteGlobal()
end


--- Input Flags Route Over Active. Wraps ImGui_InputFlags_RouteOverActive.
-- Global route: higher priority than active item. Unlikely you need to    use
-- that: will interfere with every active items, e.g. Ctrl+A registered by
-- InputText will be overridden by this. May not be fully honored as user/internal
-- code is likely to always assume they can access keys when active.
-- @return number
function ImGui:input_flags_route_over_active()
    return r.ImGui_InputFlags_RouteOverActive()
end


--- Input Flags Route Over Focused. Wraps ImGui_InputFlags_RouteOverFocused.
-- Global route: higher priority than focused route    (unless active item in
-- focused route).
-- @return number
function ImGui:input_flags_route_over_focused()
    return r.ImGui_InputFlags_RouteOverFocused()
end


--- Input Flags Route Unless Bg Focused. Wraps ImGui_InputFlags_RouteUnlessBgFocused.
-- Option: global route: will not be applied if underlying background/void is
-- focused (== no Dear ImGui windows are focused). Useful for overlay applications.
-- @return number
function ImGui:input_flags_route_unless_bg_focused()
    return r.ImGui_InputFlags_RouteUnlessBgFocused()
end


--- Input Flags Tooltip. Wraps ImGui_InputFlags_Tooltip.
-- Automatically display a tooltip when hovering item
-- @return number
function ImGui:input_flags_tooltip()
    return r.ImGui_InputFlags_Tooltip()
end


--- Input Int. Wraps ImGui_InputInt.
-- @param ctx ImGui_Context
-- @param label string
-- @param v number
-- @param integer stepIn Optional
-- @param integer step_fastIn Optional
-- @param integer flagsIn Optional
-- @return v number
function ImGui:input_int(ctx, label, v, integer, integer, integer)
    local integer = integer or nil
    local ret_val, v = r.ImGui_InputInt(ctx, label, v, integer, integer, integer)
    if ret_val then
        return v
    else
        return nil
    end
end


--- Input Int2. Wraps ImGui_InputInt2.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
function ImGui:input_int2(ctx, label, v1, v2, integer)
    local integer = integer or nil
    local ret_val, v1, v2 = r.ImGui_InputInt2(ctx, label, v1, v2, integer)
    if ret_val then
        return v1, v2
    else
        return nil
    end
end


--- Input Int3. Wraps ImGui_InputInt3.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
function ImGui:input_int3(ctx, label, v1, v2, v3, integer)
    local integer = integer or nil
    local ret_val, v1, v2, v3 = r.ImGui_InputInt3(ctx, label, v1, v2, v3, integer)
    if ret_val then
        return v1, v2, v3
    else
        return nil
    end
end


--- Input Int4. Wraps ImGui_InputInt4.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param v4 number
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
-- @return v4 number
function ImGui:input_int4(ctx, label, v1, v2, v3, v4, integer)
    local integer = integer or nil
    local ret_val, v1, v2, v3, v4 = r.ImGui_InputInt4(ctx, label, v1, v2, v3, v4, integer)
    if ret_val then
        return v1, v2, v3, v4
    else
        return nil
    end
end


--- Input Text. Wraps ImGui_InputText.
-- @param ctx ImGui_Context
-- @param label string
-- @param buf string
-- @param integer flagsIn Optional
-- @param callback_in ImGui_Function
-- @return buf string
function ImGui:input_text(ctx, label, buf, integer, callback_in)
    local integer = integer or nil
    local ret_val, buf = r.ImGui_InputText(ctx, label, buf, integer, callback_in)
    if ret_val then
        return buf
    else
        return nil
    end
end


--- Input Text Flags Allow Tab Input. Wraps ImGui_InputTextFlags_AllowTabInput.
-- Pressing TAB input a '\t' character into the text field.
-- @return number
function ImGui:input_text_flags_allow_tab_input()
    return r.ImGui_InputTextFlags_AllowTabInput()
end


--- Input Text Flags Always Overwrite. Wraps ImGui_InputTextFlags_AlwaysOverwrite.
-- Overwrite mode.
-- @return number
function ImGui:input_text_flags_always_overwrite()
    return r.ImGui_InputTextFlags_AlwaysOverwrite()
end


--- Input Text Flags Auto Select All. Wraps ImGui_InputTextFlags_AutoSelectAll.
-- Select entire text when first taking mouse focus.
-- @return number
function ImGui:input_text_flags_auto_select_all()
    return r.ImGui_InputTextFlags_AutoSelectAll()
end


--- Input Text Flags Callback Always. Wraps ImGui_InputTextFlags_CallbackAlways.
-- Callback on each iteration. User code may query cursor position, modify text
-- buffer.
-- @return number
function ImGui:input_text_flags_callback_always()
    return r.ImGui_InputTextFlags_CallbackAlways()
end


--- Input Text Flags Callback Char Filter. Wraps ImGui_InputTextFlags_CallbackCharFilter.
-- Callback on character inputs to replace or discard them.    Modify 'EventChar'
-- to replace or 'EventChar = 0' to discard.
-- @return number
function ImGui:input_text_flags_callback_char_filter()
    return r.ImGui_InputTextFlags_CallbackCharFilter()
end


--- Input Text Flags Callback Completion. Wraps ImGui_InputTextFlags_CallbackCompletion.
-- Callback on pressing TAB (for completion handling).
-- @return number
function ImGui:input_text_flags_callback_completion()
    return r.ImGui_InputTextFlags_CallbackCompletion()
end


--- Input Text Flags Callback Edit. Wraps ImGui_InputTextFlags_CallbackEdit.
-- Callback on any edit (note that InputText() already returns true on edit,    the
-- callback is useful mainly to manipulate the underlying buffer while    focus is
-- active).
-- @return number
function ImGui:input_text_flags_callback_edit()
    return r.ImGui_InputTextFlags_CallbackEdit()
end


--- Input Text Flags Callback History. Wraps ImGui_InputTextFlags_CallbackHistory.
-- Callback on pressing Up/Down arrows (for history handling).
-- @return number
function ImGui:input_text_flags_callback_history()
    return r.ImGui_InputTextFlags_CallbackHistory()
end


--- Input Text Flags Chars Decimal. Wraps ImGui_InputTextFlags_CharsDecimal.
-- Allow 0123456789.+-*/.
-- @return number
function ImGui:input_text_flags_chars_decimal()
    return r.ImGui_InputTextFlags_CharsDecimal()
end


--- Input Text Flags Chars Hexadecimal. Wraps ImGui_InputTextFlags_CharsHexadecimal.
-- Allow 0123456789ABCDEFabcdef.
-- @return number
function ImGui:input_text_flags_chars_hexadecimal()
    return r.ImGui_InputTextFlags_CharsHexadecimal()
end


--- Input Text Flags Chars No Blank. Wraps ImGui_InputTextFlags_CharsNoBlank.
-- Filter out spaces, tabs.
-- @return number
function ImGui:input_text_flags_chars_no_blank()
    return r.ImGui_InputTextFlags_CharsNoBlank()
end


--- Input Text Flags Chars Scientific. Wraps ImGui_InputTextFlags_CharsScientific.
-- Allow 0123456789.+-*/eE (Scientific notation input).
-- @return number
function ImGui:input_text_flags_chars_scientific()
    return r.ImGui_InputTextFlags_CharsScientific()
end


--- Input Text Flags Chars Uppercase. Wraps ImGui_InputTextFlags_CharsUppercase.
-- Turn a..z into A..Z.
-- @return number
function ImGui:input_text_flags_chars_uppercase()
    return r.ImGui_InputTextFlags_CharsUppercase()
end


--- Input Text Flags Ctrl Enter For New Line. Wraps ImGui_InputTextFlags_CtrlEnterForNewLine.
-- In multi-line mode, unfocus with Enter, add new line with Ctrl+Enter    (default
-- is opposite: unfocus with Ctrl+Enter, add line with Enter).
-- @return number
function ImGui:input_text_flags_ctrl_enter_for_new_line()
    return r.ImGui_InputTextFlags_CtrlEnterForNewLine()
end


--- Input Text Flags Display Empty Ref Val. Wraps ImGui_InputTextFlags_DisplayEmptyRefVal.
-- InputDouble(), InputInt() etc. only: when value is zero, do not display it.
-- Generally used with InputTextFlags_ParseEmptyRefVal.
-- @return number
function ImGui:input_text_flags_display_empty_ref_val()
    return r.ImGui_InputTextFlags_DisplayEmptyRefVal()
end


--- Input Text Flags Enter Returns True. Wraps ImGui_InputTextFlags_EnterReturnsTrue.
-- Return 'true' when Enter is pressed (as opposed to every time the value was
-- modified). Consider looking at the IsItemDeactivatedAfterEdit function.
-- @return number
function ImGui:input_text_flags_enter_returns_true()
    return r.ImGui_InputTextFlags_EnterReturnsTrue()
end


--- Input Text Flags Escape Clears All. Wraps ImGui_InputTextFlags_EscapeClearsAll.
-- Escape key clears content if not empty, and deactivate otherwise    (constrast
-- to default behavior of Escape to revert).
-- @return number
function ImGui:input_text_flags_escape_clears_all()
    return r.ImGui_InputTextFlags_EscapeClearsAll()
end


--- Input Text Flags No Horizontal Scroll. Wraps ImGui_InputTextFlags_NoHorizontalScroll.
-- Disable following the cursor horizontally.
-- @return number
function ImGui:input_text_flags_no_horizontal_scroll()
    return r.ImGui_InputTextFlags_NoHorizontalScroll()
end


--- Input Text Flags No Undo Redo. Wraps ImGui_InputTextFlags_NoUndoRedo.
-- Disable undo/redo. Note that input text owns the text data while active.
-- @return number
function ImGui:input_text_flags_no_undo_redo()
    return r.ImGui_InputTextFlags_NoUndoRedo()
end


--- Input Text Flags None. Wraps ImGui_InputTextFlags_None.
-- @return number
function ImGui:input_text_flags_none()
    return r.ImGui_InputTextFlags_None()
end


--- Input Text Flags Parse Empty Ref Val. Wraps ImGui_InputTextFlags_ParseEmptyRefVal.
-- InputDouble(), InputInt() etc. only: parse empty string as zero value.
-- @return number
function ImGui:input_text_flags_parse_empty_ref_val()
    return r.ImGui_InputTextFlags_ParseEmptyRefVal()
end


--- Input Text Flags Password. Wraps ImGui_InputTextFlags_Password.
-- Password mode, display all characters as '*'.
-- @return number
function ImGui:input_text_flags_password()
    return r.ImGui_InputTextFlags_Password()
end


--- Input Text Flags Read Only. Wraps ImGui_InputTextFlags_ReadOnly.
-- Read-only mode.
-- @return number
function ImGui:input_text_flags_read_only()
    return r.ImGui_InputTextFlags_ReadOnly()
end


--- Input Text Multiline. Wraps ImGui_InputTextMultiline.
-- @param ctx ImGui_Context
-- @param label string
-- @param buf string
-- @param number size_wIn Optional
-- @param number size_hIn Optional
-- @param integer flagsIn Optional
-- @param callback_in ImGui_Function
-- @return buf string
function ImGui:input_text_multiline(ctx, label, buf, number, number, integer, callback_in)
    local number = number or nil
    local integer = integer or nil
    local ret_val, buf = r.ImGui_InputTextMultiline(ctx, label, buf, number, number, integer, callback_in)
    if ret_val then
        return buf
    else
        return nil
    end
end


--- Input Text With Hint. Wraps ImGui_InputTextWithHint.
-- @param ctx ImGui_Context
-- @param label string
-- @param hint string
-- @param buf string
-- @param integer flagsIn Optional
-- @param callback_in ImGui_Function
-- @return buf string
function ImGui:input_text_with_hint(ctx, label, hint, buf, integer, callback_in)
    local integer = integer or nil
    local ret_val, buf = r.ImGui_InputTextWithHint(ctx, label, hint, buf, integer, callback_in)
    if ret_val then
        return buf
    else
        return nil
    end
end


--- Invisible Button. Wraps ImGui_InvisibleButton.
-- Flexible button behavior without the visuals, frequently useful to build custom
-- behaviors using the public api (along with IsItemActive, IsItemHovered, etc.).
-- @param ctx ImGui_Context
-- @param str_id string
-- @param size_w number
-- @param size_h number
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:invisible_button(ctx, str_id, size_w, size_h, integer)
    local integer = integer or nil
    return r.ImGui_InvisibleButton(ctx, str_id, size_w, size_h, integer)
end


--- Is Any Item Active. Wraps ImGui_IsAnyItemActive.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_any_item_active(ctx)
    return r.ImGui_IsAnyItemActive(ctx)
end


--- Is Any Item Focused. Wraps ImGui_IsAnyItemFocused.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_any_item_focused(ctx)
    return r.ImGui_IsAnyItemFocused(ctx)
end


--- Is Any Item Hovered. Wraps ImGui_IsAnyItemHovered.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_any_item_hovered(ctx)
    return r.ImGui_IsAnyItemHovered(ctx)
end


--- Is Any Mouse Down. Wraps ImGui_IsAnyMouseDown.
-- Is any mouse button held?
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_any_mouse_down(ctx)
    return r.ImGui_IsAnyMouseDown(ctx)
end


--- Is Item Activated. Wraps ImGui_IsItemActivated.
-- Was the last item just made active (item was previously inactive).
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_item_activated(ctx)
    return r.ImGui_IsItemActivated(ctx)
end


--- Is Item Active. Wraps ImGui_IsItemActive.
-- Is the last item active? (e.g. button being held, text field being edited. This
-- will continuously return true while holding mouse button on an item. Items that
-- don't interact will always return false.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_item_active(ctx)
    return r.ImGui_IsItemActive(ctx)
end


--- Is Item Clicked. Wraps ImGui_IsItemClicked.
-- Is the last item clicked? (e.g. button/node just clicked on) ==
-- IsMouseClicked(mouse_button) && IsItemHovered().
-- @param ctx ImGui_Context
-- @param integer mouse_buttonIn Optional
-- @return boolean
function ImGui:is_item_clicked(ctx, integer)
    local integer = integer or nil
    return r.ImGui_IsItemClicked(ctx, integer)
end


--- Is Item Deactivated. Wraps ImGui_IsItemDeactivated.
-- Was the last item just made inactive (item was previously active). Useful for
-- Undo/Redo patterns with widgets that require continuous editing.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_item_deactivated(ctx)
    return r.ImGui_IsItemDeactivated(ctx)
end


--- Is Item Deactivated After Edit. Wraps ImGui_IsItemDeactivatedAfterEdit.
-- Was the last item just made inactive and made a value change when it was active?
-- (e.g. Slider/Drag moved).
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_item_deactivated_after_edit(ctx)
    return r.ImGui_IsItemDeactivatedAfterEdit(ctx)
end


--- Is Item Edited. Wraps ImGui_IsItemEdited.
-- Did the last item modify its underlying value this frame? or was pressed? This
-- is generally the same as the "bool" return value of many widgets.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_item_edited(ctx)
    return r.ImGui_IsItemEdited(ctx)
end


--- Is Item Focused. Wraps ImGui_IsItemFocused.
-- Is the last item focused for keyboard/gamepad navigation?
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_item_focused(ctx)
    return r.ImGui_IsItemFocused(ctx)
end


--- Is Item Hovered. Wraps ImGui_IsItemHovered.
-- Is the last item hovered? (and usable, aka not blocked by a popup, etc.). See
-- HoveredFlags_* for more options.
-- @param ctx ImGui_Context
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:is_item_hovered(ctx, integer)
    local integer = integer or nil
    return r.ImGui_IsItemHovered(ctx, integer)
end


--- Is Item Toggled Open. Wraps ImGui_IsItemToggledOpen.
-- Was the last item open state toggled? Set by TreeNode.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_item_toggled_open(ctx)
    return r.ImGui_IsItemToggledOpen(ctx)
end


--- Is Item Visible. Wraps ImGui_IsItemVisible.
-- Is the last item visible? (items may be out of sight because of
-- clipping/scrolling)
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_item_visible(ctx)
    return r.ImGui_IsItemVisible(ctx)
end


--- Is Key Chord Pressed. Wraps ImGui_IsKeyChordPressed.
-- Was key chord (mods + key) pressed? You can pass e.g. `Mod_Ctrl | Key_S` as a
-- key chord. This doesn't do any routing or focus check, consider using the
-- Shortcut function instead.
-- @param ctx ImGui_Context
-- @param key_chord number
-- @return boolean
function ImGui:is_key_chord_pressed(ctx, key_chord)
    return r.ImGui_IsKeyChordPressed(ctx, key_chord)
end


--- Is Key Down. Wraps ImGui_IsKeyDown.
-- Is key being held.
-- @param ctx ImGui_Context
-- @param key number
-- @return boolean
function ImGui:is_key_down(ctx, key)
    return r.ImGui_IsKeyDown(ctx, key)
end


--- Is Key Pressed. Wraps ImGui_IsKeyPressed.
-- Was key pressed (went from !Down to Down)? If repeat=true, uses
-- ConfigVar_KeyRepeatDelay / ConfigVar_KeyRepeatRate.
-- @param ctx ImGui_Context
-- @param key number
-- @param boolean repeatIn Optional
-- @return boolean
function ImGui:is_key_pressed(ctx, key, boolean)
    local boolean = boolean or nil
    return r.ImGui_IsKeyPressed(ctx, key, boolean)
end


--- Is Key Released. Wraps ImGui_IsKeyReleased.
-- Was key released (went from Down to !Down)?
-- @param ctx ImGui_Context
-- @param key number
-- @return boolean
function ImGui:is_key_released(ctx, key)
    return r.ImGui_IsKeyReleased(ctx, key)
end


--- Is Mouse Clicked. Wraps ImGui_IsMouseClicked.
-- Did mouse button clicked? (went from !Down to Down). Same as
-- GetMouseClickedCount() == 1.
-- @param ctx ImGui_Context
-- @param button number
-- @param boolean repeatIn Optional
-- @return boolean
function ImGui:is_mouse_clicked(ctx, button, boolean)
    local boolean = boolean or nil
    return r.ImGui_IsMouseClicked(ctx, button, boolean)
end


--- Is Mouse Double Clicked. Wraps ImGui_IsMouseDoubleClicked.
-- Did mouse button double-clicked? Same as GetMouseClickedCount() == 2. (Note that
-- a double-click will also report IsMouseClicked() == true)
-- @param ctx ImGui_Context
-- @param button number
-- @return boolean
function ImGui:is_mouse_double_clicked(ctx, button)
    return r.ImGui_IsMouseDoubleClicked(ctx, button)
end


--- Is Mouse Down. Wraps ImGui_IsMouseDown.
-- Is mouse button held?
-- @param ctx ImGui_Context
-- @param button number
-- @return boolean
function ImGui:is_mouse_down(ctx, button)
    return r.ImGui_IsMouseDown(ctx, button)
end


--- Is Mouse Dragging. Wraps ImGui_IsMouseDragging.
-- Is mouse dragging? (uses ConfigVar_MouseDragThreshold if lock_threshold < 0.0)
-- @param ctx ImGui_Context
-- @param button number
-- @param number lock_thresholdIn Optional
-- @return boolean
function ImGui:is_mouse_dragging(ctx, button, number)
    local number = number or nil
    return r.ImGui_IsMouseDragging(ctx, button, number)
end


--- Is Mouse Hovering Rect. Wraps ImGui_IsMouseHoveringRect.
-- Is mouse hovering given bounding rect (in screen space). Clipped by current
-- clipping settings, but disregarding of other consideration of focus/window
-- ordering/popup-block.
-- @param ctx ImGui_Context
-- @param r_min_x number
-- @param r_min_y number
-- @param r_max_x number
-- @param r_max_y number
-- @param boolean clipIn Optional
-- @return boolean
function ImGui:is_mouse_hovering_rect(ctx, r_min_x, r_min_y, r_max_x, r_max_y, boolean)
    local boolean = boolean or nil
    return r.ImGui_IsMouseHoveringRect(ctx, r_min_x, r_min_y, r_max_x, r_max_y, boolean)
end


--- Is Mouse Pos Valid. Wraps ImGui_IsMousePosValid.
-- @param ctx ImGui_Context
-- @param number mouse_pos_xIn Optional
-- @param number mouse_pos_yIn Optional
-- @return boolean
function ImGui:is_mouse_pos_valid(ctx, number, number)
    local number = number or nil
    return r.ImGui_IsMousePosValid(ctx, number, number)
end


--- Is Mouse Released. Wraps ImGui_IsMouseReleased.
-- Did mouse button released? (went from Down to !Down)
-- @param ctx ImGui_Context
-- @param button number
-- @return boolean
function ImGui:is_mouse_released(ctx, button)
    return r.ImGui_IsMouseReleased(ctx, button)
end


--- Is Popup Open. Wraps ImGui_IsPopupOpen.
-- Return true if the popup is open at the current BeginPopup level of the popup
-- stack.
-- @param ctx ImGui_Context
-- @param str_id string
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:is_popup_open(ctx, str_id, integer)
    local integer = integer or nil
    return r.ImGui_IsPopupOpen(ctx, str_id, integer)
end


--- Is Rect Visible. Wraps ImGui_IsRectVisible.
-- Test if rectangle (of given size, starting from cursor position) is visible /
-- not clipped.
-- @param ctx ImGui_Context
-- @param size_w number
-- @param size_h number
-- @return boolean
function ImGui:is_rect_visible(ctx, size_w, size_h)
    return r.ImGui_IsRectVisible(ctx, size_w, size_h)
end


--- Is Rect Visible Ex. Wraps ImGui_IsRectVisibleEx.
-- Test if rectangle (in screen space) is visible / not clipped. to perform coarse
-- clipping on user's side.
-- @param ctx ImGui_Context
-- @param rect_min_x number
-- @param rect_min_y number
-- @param rect_max_x number
-- @param rect_max_y number
-- @return boolean
function ImGui:is_rect_visible_ex(ctx, rect_min_x, rect_min_y, rect_max_x, rect_max_y)
    return r.ImGui_IsRectVisibleEx(ctx, rect_min_x, rect_min_y, rect_max_x, rect_max_y)
end


--- Is Window Appearing. Wraps ImGui_IsWindowAppearing.
-- Use after Begin/BeginPopup/BeginPopupModal to tell if a window just opened.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_window_appearing(ctx)
    return r.ImGui_IsWindowAppearing(ctx)
end


--- Is Window Docked. Wraps ImGui_IsWindowDocked.
-- Is current window docked into another window or a REAPER docker?
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:is_window_docked(ctx)
    return r.ImGui_IsWindowDocked(ctx)
end


--- Is Window Focused. Wraps ImGui_IsWindowFocused.
-- Is current window focused? or its root/child, depending on flags. See flags for
-- options.
-- @param ctx ImGui_Context
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:is_window_focused(ctx, integer)
    local integer = integer or nil
    return r.ImGui_IsWindowFocused(ctx, integer)
end


--- Is Window Hovered. Wraps ImGui_IsWindowHovered.
-- Is current window hovered and hoverable (e.g. not blocked by a popup/modal)? See
-- HoveredFlags_* for options.
-- @param ctx ImGui_Context
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:is_window_hovered(ctx, integer)
    local integer = integer or nil
    return r.ImGui_IsWindowHovered(ctx, integer)
end


--- Key 0. Wraps ImGui_Key_0.
-- @return number
function ImGui:key_0()
    return r.ImGui_Key_0()
end


--- Key 1. Wraps ImGui_Key_1.
-- @return number
function ImGui:key_1()
    return r.ImGui_Key_1()
end


--- Key 2. Wraps ImGui_Key_2.
-- @return number
function ImGui:key_2()
    return r.ImGui_Key_2()
end


--- Key 3. Wraps ImGui_Key_3.
-- @return number
function ImGui:key_3()
    return r.ImGui_Key_3()
end


--- Key 4. Wraps ImGui_Key_4.
-- @return number
function ImGui:key_4()
    return r.ImGui_Key_4()
end


--- Key 5. Wraps ImGui_Key_5.
-- @return number
function ImGui:key_5()
    return r.ImGui_Key_5()
end


--- Key 6. Wraps ImGui_Key_6.
-- @return number
function ImGui:key_6()
    return r.ImGui_Key_6()
end


--- Key 7. Wraps ImGui_Key_7.
-- @return number
function ImGui:key_7()
    return r.ImGui_Key_7()
end


--- Key 8. Wraps ImGui_Key_8.
-- @return number
function ImGui:key_8()
    return r.ImGui_Key_8()
end


--- Key 9. Wraps ImGui_Key_9.
-- @return number
function ImGui:key_9()
    return r.ImGui_Key_9()
end


--- Key A. Wraps ImGui_Key_A.
-- @return number
function ImGui:key_a()
    return r.ImGui_Key_A()
end


--- Key Apostrophe. Wraps ImGui_Key_Apostrophe.
-- '
-- @return number
function ImGui:key_apostrophe()
    return r.ImGui_Key_Apostrophe()
end


--- Key App Back. Wraps ImGui_Key_AppBack.
-- Available on some keyboard/mouses. Often referred as "Browser Back".
-- @return number
function ImGui:key_app_back()
    return r.ImGui_Key_AppBack()
end


--- Key App Forward. Wraps ImGui_Key_AppForward.
-- @return number
function ImGui:key_app_forward()
    return r.ImGui_Key_AppForward()
end


--- Key B. Wraps ImGui_Key_B.
-- @return number
function ImGui:key_b()
    return r.ImGui_Key_B()
end


--- Key Backslash. Wraps ImGui_Key_Backslash.
-- \
-- @return number
function ImGui:key_backslash()
    return r.ImGui_Key_Backslash()
end


--- Key Backspace. Wraps ImGui_Key_Backspace.
-- @return number
function ImGui:key_backspace()
    return r.ImGui_Key_Backspace()
end


--- Key C. Wraps ImGui_Key_C.
-- @return number
function ImGui:key_c()
    return r.ImGui_Key_C()
end


--- Key Caps Lock. Wraps ImGui_Key_CapsLock.
-- @return number
function ImGui:key_caps_lock()
    return r.ImGui_Key_CapsLock()
end


--- Key Comma. Wraps ImGui_Key_Comma.
-- ,
-- @return number
function ImGui:key_comma()
    return r.ImGui_Key_Comma()
end


--- Key D. Wraps ImGui_Key_D.
-- @return number
function ImGui:key_d()
    return r.ImGui_Key_D()
end


--- Key Delete. Wraps ImGui_Key_Delete.
-- @return number
function ImGui:key_delete()
    return r.ImGui_Key_Delete()
end


--- Key Down Arrow. Wraps ImGui_Key_DownArrow.
-- @return number
function ImGui:key_down_arrow()
    return r.ImGui_Key_DownArrow()
end


--- Key E. Wraps ImGui_Key_E.
-- @return number
function ImGui:key_e()
    return r.ImGui_Key_E()
end


--- Key End. Wraps ImGui_Key_End.
-- @return number
function ImGui:key_end()
    return r.ImGui_Key_End()
end


--- Key Enter. Wraps ImGui_Key_Enter.
-- @return number
function ImGui:key_enter()
    return r.ImGui_Key_Enter()
end


--- Key Equal. Wraps ImGui_Key_Equal.
-- =
-- @return number
function ImGui:key_equal()
    return r.ImGui_Key_Equal()
end


--- Key Escape. Wraps ImGui_Key_Escape.
-- @return number
function ImGui:key_escape()
    return r.ImGui_Key_Escape()
end


--- Key F. Wraps ImGui_Key_F.
-- @return number
function ImGui:key_f()
    return r.ImGui_Key_F()
end


--- Key F1. Wraps ImGui_Key_F1.
-- @return number
function ImGui:key_f1()
    return r.ImGui_Key_F1()
end


--- Key F10. Wraps ImGui_Key_F10.
-- @return number
function ImGui:key_f10()
    return r.ImGui_Key_F10()
end


--- Key F11. Wraps ImGui_Key_F11.
-- @return number
function ImGui:key_f11()
    return r.ImGui_Key_F11()
end


--- Key F12. Wraps ImGui_Key_F12.
-- @return number
function ImGui:key_f12()
    return r.ImGui_Key_F12()
end


--- Key F13. Wraps ImGui_Key_F13.
-- @return number
function ImGui:key_f13()
    return r.ImGui_Key_F13()
end


--- Key F14. Wraps ImGui_Key_F14.
-- @return number
function ImGui:key_f14()
    return r.ImGui_Key_F14()
end


--- Key F15. Wraps ImGui_Key_F15.
-- @return number
function ImGui:key_f15()
    return r.ImGui_Key_F15()
end


--- Key F16. Wraps ImGui_Key_F16.
-- @return number
function ImGui:key_f16()
    return r.ImGui_Key_F16()
end


--- Key F17. Wraps ImGui_Key_F17.
-- @return number
function ImGui:key_f17()
    return r.ImGui_Key_F17()
end


--- Key F18. Wraps ImGui_Key_F18.
-- @return number
function ImGui:key_f18()
    return r.ImGui_Key_F18()
end


--- Key F19. Wraps ImGui_Key_F19.
-- @return number
function ImGui:key_f19()
    return r.ImGui_Key_F19()
end


--- Key F2. Wraps ImGui_Key_F2.
-- @return number
function ImGui:key_f2()
    return r.ImGui_Key_F2()
end


--- Key F20. Wraps ImGui_Key_F20.
-- @return number
function ImGui:key_f20()
    return r.ImGui_Key_F20()
end


--- Key F21. Wraps ImGui_Key_F21.
-- @return number
function ImGui:key_f21()
    return r.ImGui_Key_F21()
end


--- Key F22. Wraps ImGui_Key_F22.
-- @return number
function ImGui:key_f22()
    return r.ImGui_Key_F22()
end


--- Key F23. Wraps ImGui_Key_F23.
-- @return number
function ImGui:key_f23()
    return r.ImGui_Key_F23()
end


--- Key F24. Wraps ImGui_Key_F24.
-- @return number
function ImGui:key_f24()
    return r.ImGui_Key_F24()
end


--- Key F3. Wraps ImGui_Key_F3.
-- @return number
function ImGui:key_f3()
    return r.ImGui_Key_F3()
end


--- Key F4. Wraps ImGui_Key_F4.
-- @return number
function ImGui:key_f4()
    return r.ImGui_Key_F4()
end


--- Key F5. Wraps ImGui_Key_F5.
-- @return number
function ImGui:key_f5()
    return r.ImGui_Key_F5()
end


--- Key F6. Wraps ImGui_Key_F6.
-- @return number
function ImGui:key_f6()
    return r.ImGui_Key_F6()
end


--- Key F7. Wraps ImGui_Key_F7.
-- @return number
function ImGui:key_f7()
    return r.ImGui_Key_F7()
end


--- Key F8. Wraps ImGui_Key_F8.
-- @return number
function ImGui:key_f8()
    return r.ImGui_Key_F8()
end


--- Key F9. Wraps ImGui_Key_F9.
-- @return number
function ImGui:key_f9()
    return r.ImGui_Key_F9()
end


--- Key G. Wraps ImGui_Key_G.
-- @return number
function ImGui:key_g()
    return r.ImGui_Key_G()
end


--- Key Grave Accent. Wraps ImGui_Key_GraveAccent.
-- `
-- @return number
function ImGui:key_grave_accent()
    return r.ImGui_Key_GraveAccent()
end


--- Key H. Wraps ImGui_Key_H.
-- @return number
function ImGui:key_h()
    return r.ImGui_Key_H()
end


--- Key Home. Wraps ImGui_Key_Home.
-- @return number
function ImGui:key_home()
    return r.ImGui_Key_Home()
end


--- Key I. Wraps ImGui_Key_I.
-- @return number
function ImGui:key_i()
    return r.ImGui_Key_I()
end


--- Key Insert. Wraps ImGui_Key_Insert.
-- @return number
function ImGui:key_insert()
    return r.ImGui_Key_Insert()
end


--- Key J. Wraps ImGui_Key_J.
-- @return number
function ImGui:key_j()
    return r.ImGui_Key_J()
end


--- Key K. Wraps ImGui_Key_K.
-- @return number
function ImGui:key_k()
    return r.ImGui_Key_K()
end


--- Key Keypad0. Wraps ImGui_Key_Keypad0.
-- @return number
function ImGui:key_keypad0()
    return r.ImGui_Key_Keypad0()
end


--- Key Keypad1. Wraps ImGui_Key_Keypad1.
-- @return number
function ImGui:key_keypad1()
    return r.ImGui_Key_Keypad1()
end


--- Key Keypad2. Wraps ImGui_Key_Keypad2.
-- @return number
function ImGui:key_keypad2()
    return r.ImGui_Key_Keypad2()
end


--- Key Keypad3. Wraps ImGui_Key_Keypad3.
-- @return number
function ImGui:key_keypad3()
    return r.ImGui_Key_Keypad3()
end


--- Key Keypad4. Wraps ImGui_Key_Keypad4.
-- @return number
function ImGui:key_keypad4()
    return r.ImGui_Key_Keypad4()
end


--- Key Keypad5. Wraps ImGui_Key_Keypad5.
-- @return number
function ImGui:key_keypad5()
    return r.ImGui_Key_Keypad5()
end


--- Key Keypad6. Wraps ImGui_Key_Keypad6.
-- @return number
function ImGui:key_keypad6()
    return r.ImGui_Key_Keypad6()
end


--- Key Keypad7. Wraps ImGui_Key_Keypad7.
-- @return number
function ImGui:key_keypad7()
    return r.ImGui_Key_Keypad7()
end


--- Key Keypad8. Wraps ImGui_Key_Keypad8.
-- @return number
function ImGui:key_keypad8()
    return r.ImGui_Key_Keypad8()
end


--- Key Keypad9. Wraps ImGui_Key_Keypad9.
-- @return number
function ImGui:key_keypad9()
    return r.ImGui_Key_Keypad9()
end


--- Key Keypad Add. Wraps ImGui_Key_KeypadAdd.
-- @return number
function ImGui:key_keypad_add()
    return r.ImGui_Key_KeypadAdd()
end


--- Key Keypad Decimal. Wraps ImGui_Key_KeypadDecimal.
-- @return number
function ImGui:key_keypad_decimal()
    return r.ImGui_Key_KeypadDecimal()
end


--- Key Keypad Divide. Wraps ImGui_Key_KeypadDivide.
-- @return number
function ImGui:key_keypad_divide()
    return r.ImGui_Key_KeypadDivide()
end


--- Key Keypad Enter. Wraps ImGui_Key_KeypadEnter.
-- @return number
function ImGui:key_keypad_enter()
    return r.ImGui_Key_KeypadEnter()
end


--- Key Keypad Equal. Wraps ImGui_Key_KeypadEqual.
-- @return number
function ImGui:key_keypad_equal()
    return r.ImGui_Key_KeypadEqual()
end


--- Key Keypad Multiply. Wraps ImGui_Key_KeypadMultiply.
-- @return number
function ImGui:key_keypad_multiply()
    return r.ImGui_Key_KeypadMultiply()
end


--- Key Keypad Subtract. Wraps ImGui_Key_KeypadSubtract.
-- @return number
function ImGui:key_keypad_subtract()
    return r.ImGui_Key_KeypadSubtract()
end


--- Key L. Wraps ImGui_Key_L.
-- @return number
function ImGui:key_l()
    return r.ImGui_Key_L()
end


--- Key Left Alt. Wraps ImGui_Key_LeftAlt.
-- @return number
function ImGui:key_left_alt()
    return r.ImGui_Key_LeftAlt()
end


--- Key Left Arrow. Wraps ImGui_Key_LeftArrow.
-- @return number
function ImGui:key_left_arrow()
    return r.ImGui_Key_LeftArrow()
end


--- Key Left Bracket. Wraps ImGui_Key_LeftBracket.
-- [
-- @return number
function ImGui:key_left_bracket()
    return r.ImGui_Key_LeftBracket()
end


--- Key Left Ctrl. Wraps ImGui_Key_LeftCtrl.
-- @return number
function ImGui:key_left_ctrl()
    return r.ImGui_Key_LeftCtrl()
end


--- Key Left Shift. Wraps ImGui_Key_LeftShift.
-- @return number
function ImGui:key_left_shift()
    return r.ImGui_Key_LeftShift()
end


--- Key Left Super. Wraps ImGui_Key_LeftSuper.
-- @return number
function ImGui:key_left_super()
    return r.ImGui_Key_LeftSuper()
end


--- Key M. Wraps ImGui_Key_M.
-- @return number
function ImGui:key_m()
    return r.ImGui_Key_M()
end


--- Key Menu. Wraps ImGui_Key_Menu.
-- @return number
function ImGui:key_menu()
    return r.ImGui_Key_Menu()
end


--- Key Minus. Wraps ImGui_Key_Minus.
-- -
-- @return number
function ImGui:key_minus()
    return r.ImGui_Key_Minus()
end


--- Key Mouse Left. Wraps ImGui_Key_MouseLeft.
-- @return number
function ImGui:key_mouse_left()
    return r.ImGui_Key_MouseLeft()
end


--- Key Mouse Middle. Wraps ImGui_Key_MouseMiddle.
-- @return number
function ImGui:key_mouse_middle()
    return r.ImGui_Key_MouseMiddle()
end


--- Key Mouse Right. Wraps ImGui_Key_MouseRight.
-- @return number
function ImGui:key_mouse_right()
    return r.ImGui_Key_MouseRight()
end


--- Key Mouse Wheel X. Wraps ImGui_Key_MouseWheelX.
-- @return number
function ImGui:key_mouse_wheel_x()
    return r.ImGui_Key_MouseWheelX()
end


--- Key Mouse Wheel Y. Wraps ImGui_Key_MouseWheelY.
-- @return number
function ImGui:key_mouse_wheel_y()
    return r.ImGui_Key_MouseWheelY()
end


--- Key Mouse X1. Wraps ImGui_Key_MouseX1.
-- @return number
function ImGui:key_mouse_x1()
    return r.ImGui_Key_MouseX1()
end


--- Key Mouse X2. Wraps ImGui_Key_MouseX2.
-- @return number
function ImGui:key_mouse_x2()
    return r.ImGui_Key_MouseX2()
end


--- Key N. Wraps ImGui_Key_N.
-- @return number
function ImGui:key_n()
    return r.ImGui_Key_N()
end


--- Key Num Lock. Wraps ImGui_Key_NumLock.
-- @return number
function ImGui:key_num_lock()
    return r.ImGui_Key_NumLock()
end


--- Key O. Wraps ImGui_Key_O.
-- @return number
function ImGui:key_o()
    return r.ImGui_Key_O()
end


--- Key P. Wraps ImGui_Key_P.
-- @return number
function ImGui:key_p()
    return r.ImGui_Key_P()
end


--- Key Page Down. Wraps ImGui_Key_PageDown.
-- @return number
function ImGui:key_page_down()
    return r.ImGui_Key_PageDown()
end


--- Key Page Up. Wraps ImGui_Key_PageUp.
-- @return number
function ImGui:key_page_up()
    return r.ImGui_Key_PageUp()
end


--- Key Pause. Wraps ImGui_Key_Pause.
-- @return number
function ImGui:key_pause()
    return r.ImGui_Key_Pause()
end


--- Key Period. Wraps ImGui_Key_Period.
-- .
-- @return number
function ImGui:key_period()
    return r.ImGui_Key_Period()
end


--- Key Print Screen. Wraps ImGui_Key_PrintScreen.
-- @return number
function ImGui:key_print_screen()
    return r.ImGui_Key_PrintScreen()
end


--- Key Q. Wraps ImGui_Key_Q.
-- @return number
function ImGui:key_q()
    return r.ImGui_Key_Q()
end


--- Key R. Wraps ImGui_Key_R.
-- @return number
function ImGui:key_r()
    return r.ImGui_Key_R()
end


--- Key Right Alt. Wraps ImGui_Key_RightAlt.
-- @return number
function ImGui:key_right_alt()
    return r.ImGui_Key_RightAlt()
end


--- Key Right Arrow. Wraps ImGui_Key_RightArrow.
-- @return number
function ImGui:key_right_arrow()
    return r.ImGui_Key_RightArrow()
end


--- Key Right Bracket. Wraps ImGui_Key_RightBracket.
-- ]
-- @return number
function ImGui:key_right_bracket()
    return r.ImGui_Key_RightBracket()
end


--- Key Right Ctrl. Wraps ImGui_Key_RightCtrl.
-- @return number
function ImGui:key_right_ctrl()
    return r.ImGui_Key_RightCtrl()
end


--- Key Right Shift. Wraps ImGui_Key_RightShift.
-- @return number
function ImGui:key_right_shift()
    return r.ImGui_Key_RightShift()
end


--- Key Right Super. Wraps ImGui_Key_RightSuper.
-- @return number
function ImGui:key_right_super()
    return r.ImGui_Key_RightSuper()
end


--- Key S. Wraps ImGui_Key_S.
-- @return number
function ImGui:key_s()
    return r.ImGui_Key_S()
end


--- Key Scroll Lock. Wraps ImGui_Key_ScrollLock.
-- @return number
function ImGui:key_scroll_lock()
    return r.ImGui_Key_ScrollLock()
end


--- Key Semicolon. Wraps ImGui_Key_Semicolon.
-- ;
-- @return number
function ImGui:key_semicolon()
    return r.ImGui_Key_Semicolon()
end


--- Key Slash. Wraps ImGui_Key_Slash.
-- /
-- @return number
function ImGui:key_slash()
    return r.ImGui_Key_Slash()
end


--- Key Space. Wraps ImGui_Key_Space.
-- @return number
function ImGui:key_space()
    return r.ImGui_Key_Space()
end


--- Key T. Wraps ImGui_Key_T.
-- @return number
function ImGui:key_t()
    return r.ImGui_Key_T()
end


--- Key Tab. Wraps ImGui_Key_Tab.
-- @return number
function ImGui:key_tab()
    return r.ImGui_Key_Tab()
end


--- Key U. Wraps ImGui_Key_U.
-- @return number
function ImGui:key_u()
    return r.ImGui_Key_U()
end


--- Key Up Arrow. Wraps ImGui_Key_UpArrow.
-- @return number
function ImGui:key_up_arrow()
    return r.ImGui_Key_UpArrow()
end


--- Key V. Wraps ImGui_Key_V.
-- @return number
function ImGui:key_v()
    return r.ImGui_Key_V()
end


--- Key W. Wraps ImGui_Key_W.
-- @return number
function ImGui:key_w()
    return r.ImGui_Key_W()
end


--- Key X. Wraps ImGui_Key_X.
-- @return number
function ImGui:key_x()
    return r.ImGui_Key_X()
end


--- Key Y. Wraps ImGui_Key_Y.
-- @return number
function ImGui:key_y()
    return r.ImGui_Key_Y()
end


--- Key Z. Wraps ImGui_Key_Z.
-- @return number
function ImGui:key_z()
    return r.ImGui_Key_Z()
end


--- Label Text. Wraps ImGui_LabelText.
-- Display text+label aligned the same way as value+label widgets
-- @param ctx ImGui_Context
-- @param label string
-- @param text string
function ImGui:label_text(ctx, label, text)
    return r.ImGui_LabelText(ctx, label, text)
end


--- List Box. Wraps ImGui_ListBox.
-- This is an helper over BeginListBox/EndListBox for convenience purpose.
-- @param ctx ImGui_Context
-- @param label string
-- @param current_item number
-- @param items string
-- @param integer height_in_itemsIn Optional
-- @return current_item number
function ImGui:list_box(ctx, label, current_item, items, integer)
    local integer = integer or nil
    local ret_val, current_item = r.ImGui_ListBox(ctx, label, current_item, items, integer)
    if ret_val then
        return current_item
    else
        return nil
    end
end


--- List Clipper Begin. Wraps ImGui_ListClipper_Begin.
-- - items_count: Use INT_MAX if you don't know how many items you have (in which
-- case the cursor won't be advanced in the final step) - items_height: Use -1.0 to
-- be calculated automatically on first step.   Otherwise pass in the distance
-- between your items, typically   GetTextLineHeightWithSpacing or
-- GetFrameHeightWithSpacing.
-- @param clipper ImGui_ListClipper
-- @param items_count number
-- @param number items_heightIn Optional
function ImGui:list_clipper_begin(clipper, items_count, number)
    local number = number or nil
    return r.ImGui_ListClipper_Begin(clipper, items_count, number)
end


--- List Clipper End. Wraps ImGui_ListClipper_End.
-- Automatically called on the last call of ListClipper_Step that returns false.
-- @param clipper ImGui_ListClipper
function ImGui:list_clipper_end(clipper)
    return r.ImGui_ListClipper_End(clipper)
end


--- List Clipper Get Display Range. Wraps ImGui_ListClipper_GetDisplayRange.
-- @param clipper ImGui_ListClipper
-- @return display_start number
-- @return display_end number
function ImGui:list_clipper_get_display_range(clipper)
    return r.ImGui_ListClipper_GetDisplayRange(clipper)
end


--- List Clipper Include Item By Index. Wraps ImGui_ListClipper_IncludeItemByIndex.
-- Call ListClipper_IncludeItemByIndex or ListClipper_IncludeItemsByIndex before
-- the first call to ListClipper_Step if you need a range of items to be displayed
-- regardless of visibility.
-- @param clipper ImGui_ListClipper
-- @param item_index number
function ImGui:list_clipper_include_item_by_index(clipper, item_index)
    return r.ImGui_ListClipper_IncludeItemByIndex(clipper, item_index)
end


--- List Clipper Include Items By Index. Wraps ImGui_ListClipper_IncludeItemsByIndex.
-- See ListClipper_IncludeItemByIndex.
-- @param clipper ImGui_ListClipper
-- @param item_begin number
-- @param item_end number
function ImGui:list_clipper_include_items_by_index(clipper, item_begin, item_end)
    return r.ImGui_ListClipper_IncludeItemsByIndex(clipper, item_begin, item_end)
end


--- List Clipper Step. Wraps ImGui_ListClipper_Step.
-- Call until it returns false. The display_start/display_end fields from
-- ListClipper_GetDisplayRange will be set and you can process/draw those items.
-- @param clipper ImGui_ListClipper
-- @return boolean
function ImGui:list_clipper_step(clipper)
    return r.ImGui_ListClipper_Step(clipper)
end


--- Log Finish. Wraps ImGui_LogFinish.
-- Stop logging (close file, etc.)
-- @param ctx ImGui_Context
function ImGui:log_finish(ctx)
    return r.ImGui_LogFinish(ctx)
end


--- Log Text. Wraps ImGui_LogText.
-- Pass text data straight to log (without being displayed)
-- @param ctx ImGui_Context
-- @param text string
function ImGui:log_text(ctx, text)
    return r.ImGui_LogText(ctx, text)
end


--- Log To Clipboard. Wraps ImGui_LogToClipboard.
-- Start logging all text output from the interface to the OS clipboard. See also
-- SetClipboardText.
-- @param ctx ImGui_Context
-- @param integer auto_open_depthIn Optional
function ImGui:log_to_clipboard(ctx, integer)
    local integer = integer or nil
    return r.ImGui_LogToClipboard(ctx, integer)
end


--- Log To File. Wraps ImGui_LogToFile.
-- Start logging all text output from the interface to a file. The data is saved to
-- $resource_path/imgui_log.txt if filename is nil.
-- @param ctx ImGui_Context
-- @param integer auto_open_depthIn Optional
-- @param string filenameIn Optional
function ImGui:log_to_file(ctx, integer, string)
    local integer = integer or nil
    local string = string or nil
    return r.ImGui_LogToFile(ctx, integer, string)
end


--- Log To Tty. Wraps ImGui_LogToTTY.
-- Start logging all text output from the interface to the TTY (stdout).
-- @param ctx ImGui_Context
-- @param integer auto_open_depthIn Optional
function ImGui:log_to_tty(ctx, integer)
    local integer = integer or nil
    return r.ImGui_LogToTTY(ctx, integer)
end


--- Menu Item. Wraps ImGui_MenuItem.
-- Return true when activated. Shortcuts are displayed for convenience but not
-- processed by ImGui at the moment. Toggle state is written to 'selected' when
-- provided.
-- @param ctx ImGui_Context
-- @param label string
-- @param string shortcutIn Optional
-- @param boolean p_selected Optional
-- @param boolean enabledIn Optional
-- @return boolean p_selected
function ImGui:menu_item(ctx, label, string, boolean, boolean)
    local string = string or nil
    local boolean = boolean or nil
    local ret_val, boolean = r.ImGui_MenuItem(ctx, label, string, boolean, boolean)
    if ret_val then
        return boolean
    else
        return nil
    end
end


--- Mod Alt. Wraps ImGui_Mod_Alt.
-- @return number
function ImGui:mod_alt()
    return r.ImGui_Mod_Alt()
end


--- Mod Ctrl. Wraps ImGui_Mod_Ctrl.
-- Cmd when ConfigVar_MacOSXBehaviors is enabled.
-- @return number
function ImGui:mod_ctrl()
    return r.ImGui_Mod_Ctrl()
end


--- Mod None. Wraps ImGui_Mod_None.
-- @return number
function ImGui:mod_none()
    return r.ImGui_Mod_None()
end


--- Mod Shift. Wraps ImGui_Mod_Shift.
-- @return number
function ImGui:mod_shift()
    return r.ImGui_Mod_Shift()
end


--- Mod Super. Wraps ImGui_Mod_Super.
-- Ctrl when ConfigVar_MacOSXBehaviors is enabled.
-- @return number
function ImGui:mod_super()
    return r.ImGui_Mod_Super()
end


--- Mouse Button Left. Wraps ImGui_MouseButton_Left.
-- @return number
function ImGui:mouse_button_left()
    return r.ImGui_MouseButton_Left()
end


--- Mouse Button Middle. Wraps ImGui_MouseButton_Middle.
-- @return number
function ImGui:mouse_button_middle()
    return r.ImGui_MouseButton_Middle()
end


--- Mouse Button Right. Wraps ImGui_MouseButton_Right.
-- @return number
function ImGui:mouse_button_right()
    return r.ImGui_MouseButton_Right()
end


--- Mouse Cursor Arrow. Wraps ImGui_MouseCursor_Arrow.
-- @return number
function ImGui:mouse_cursor_arrow()
    return r.ImGui_MouseCursor_Arrow()
end


--- Mouse Cursor Hand. Wraps ImGui_MouseCursor_Hand.
-- (Unused by Dear ImGui functions. Use for e.g. hyperlinks)
-- @return number
function ImGui:mouse_cursor_hand()
    return r.ImGui_MouseCursor_Hand()
end


--- Mouse Cursor None. Wraps ImGui_MouseCursor_None.
-- @return number
function ImGui:mouse_cursor_none()
    return r.ImGui_MouseCursor_None()
end


--- Mouse Cursor Not Allowed. Wraps ImGui_MouseCursor_NotAllowed.
-- When hovering something with disallowed interaction. Usually a crossed circle.
-- @return number
function ImGui:mouse_cursor_not_allowed()
    return r.ImGui_MouseCursor_NotAllowed()
end


--- Mouse Cursor Resize All. Wraps ImGui_MouseCursor_ResizeAll.
-- (Unused by Dear ImGui functions)
-- @return number
function ImGui:mouse_cursor_resize_all()
    return r.ImGui_MouseCursor_ResizeAll()
end


--- Mouse Cursor Resize Ew. Wraps ImGui_MouseCursor_ResizeEW.
-- When hovering over a vertical border or a column.
-- @return number
function ImGui:mouse_cursor_resize_ew()
    return r.ImGui_MouseCursor_ResizeEW()
end


--- Mouse Cursor Resize Nesw. Wraps ImGui_MouseCursor_ResizeNESW.
-- When hovering over the bottom-left corner of a window.
-- @return number
function ImGui:mouse_cursor_resize_nesw()
    return r.ImGui_MouseCursor_ResizeNESW()
end


--- Mouse Cursor Resize Ns. Wraps ImGui_MouseCursor_ResizeNS.
-- When hovering over a horizontal border.
-- @return number
function ImGui:mouse_cursor_resize_ns()
    return r.ImGui_MouseCursor_ResizeNS()
end


--- Mouse Cursor Resize Nwse. Wraps ImGui_MouseCursor_ResizeNWSE.
-- When hovering over the bottom-right corner of a window.
-- @return number
function ImGui:mouse_cursor_resize_nwse()
    return r.ImGui_MouseCursor_ResizeNWSE()
end


--- Mouse Cursor Text Input. Wraps ImGui_MouseCursor_TextInput.
-- When hovering over InputText, etc.
-- @return number
function ImGui:mouse_cursor_text_input()
    return r.ImGui_MouseCursor_TextInput()
end


--- New Line. Wraps ImGui_NewLine.
-- Undo a SameLine() or force a new line when in a horizontal-layout context.
-- @param ctx ImGui_Context
function ImGui:new_line(ctx)
    return r.ImGui_NewLine(ctx)
end


--- Numeric Limits Double. Wraps ImGui_NumericLimits_Double.
-- Returns DBL_MIN and DBL_MAX for this system.
-- @return min number
-- @return max number
function ImGui:numeric_limits_double()
    return r.ImGui_NumericLimits_Double()
end


--- Numeric Limits Float. Wraps ImGui_NumericLimits_Float.
-- Returns FLT_MIN and FLT_MAX for this system.
-- @return min number
-- @return max number
function ImGui:numeric_limits_float()
    return r.ImGui_NumericLimits_Float()
end


--- Numeric Limits Int. Wraps ImGui_NumericLimits_Int.
-- Returns INT_MIN and INT_MAX for this system.
-- @return min number
-- @return max number
function ImGui:numeric_limits_int()
    return r.ImGui_NumericLimits_Int()
end


--- Open Popup. Wraps ImGui_OpenPopup.
-- Set popup state to open (don't call every frame!). ImGuiPopupFlags are available
-- for opening options.
-- @param ctx ImGui_Context
-- @param str_id string
-- @param integer popup_flagsIn Optional
function ImGui:open_popup(ctx, str_id, integer)
    local integer = integer or nil
    return r.ImGui_OpenPopup(ctx, str_id, integer)
end


--- Open Popup On Item Click. Wraps ImGui_OpenPopupOnItemClick.
-- Helper to open popup when clicked on last item. return true when just opened.
-- (Note: actually triggers on the mouse _released_ event to be consistent with
-- popup behaviors.)
-- @param ctx ImGui_Context
-- @param string str_idIn Optional
-- @param integer popup_flagsIn Optional
function ImGui:open_popup_on_item_click(ctx, string, integer)
    local string = string or nil
    local integer = integer or nil
    return r.ImGui_OpenPopupOnItemClick(ctx, string, integer)
end


--- Plot Histogram. Wraps ImGui_PlotHistogram.
-- @param ctx ImGui_Context
-- @param label string
-- @param values reaper_array
-- @param integer values_offsetIn Optional
-- @param string overlay_textIn Optional
-- @param number scale_minIn Optional
-- @param number scale_maxIn Optional
-- @param number graph_size_wIn Optional
-- @param number graph_size_hIn Optional
function ImGui:plot_histogram(ctx, label, values, integer, string, number, number, number, number)
    local integer = integer or nil
    local string = string or nil
    local number = number or nil
    return r.ImGui_PlotHistogram(ctx, label, values, integer, string, number, number, number, number)
end


--- Plot Lines. Wraps ImGui_PlotLines.
-- @param ctx ImGui_Context
-- @param label string
-- @param values reaper_array
-- @param integer values_offsetIn Optional
-- @param string overlay_textIn Optional
-- @param number scale_minIn Optional
-- @param number scale_maxIn Optional
-- @param number graph_size_wIn Optional
-- @param number graph_size_hIn Optional
function ImGui:plot_lines(ctx, label, values, integer, string, number, number, number, number)
    local integer = integer or nil
    local string = string or nil
    local number = number or nil
    return r.ImGui_PlotLines(ctx, label, values, integer, string, number, number, number, number)
end


--- Point Convert Native. Wraps ImGui_PointConvertNative.
-- Convert a position from the current platform's native coordinate position system
-- to ReaImGui global coordinates (or vice versa).
-- @param ctx ImGui_Context
-- @param x number
-- @param y number
-- @param boolean to_nativeIn Optional
-- @return x number
-- @return y number
function ImGui:point_convert_native(ctx, x, y, boolean)
    local boolean = boolean or nil
    return r.ImGui_PointConvertNative(ctx, x, y, boolean)
end


--- Pop Button Repeat. Wraps ImGui_PopButtonRepeat.
-- See PushButtonRepeat
-- @param ctx ImGui_Context
function ImGui:pop_button_repeat(ctx)
    return r.ImGui_PopButtonRepeat(ctx)
end


--- Pop Clip Rect. Wraps ImGui_PopClipRect.
-- See PushClipRect
-- @param ctx ImGui_Context
function ImGui:pop_clip_rect(ctx)
    return r.ImGui_PopClipRect(ctx)
end


--- Pop Font. Wraps ImGui_PopFont.
-- See PushFont.
-- @param ctx ImGui_Context
function ImGui:pop_font(ctx)
    return r.ImGui_PopFont(ctx)
end


--- Pop Id. Wraps ImGui_PopID.
-- Pop from the ID stack.
-- @param ctx ImGui_Context
function ImGui:pop_id(ctx)
    return r.ImGui_PopID(ctx)
end


--- Pop Item Width. Wraps ImGui_PopItemWidth.
-- See PushItemWidth
-- @param ctx ImGui_Context
function ImGui:pop_item_width(ctx)
    return r.ImGui_PopItemWidth(ctx)
end


--- Pop Style Color. Wraps ImGui_PopStyleColor.
-- @param ctx ImGui_Context
-- @param integer countIn Optional
function ImGui:pop_style_color(ctx, integer)
    local integer = integer or nil
    return r.ImGui_PopStyleColor(ctx, integer)
end


--- Pop Style Var. Wraps ImGui_PopStyleVar.
-- Reset a style variable.
-- @param ctx ImGui_Context
-- @param integer countIn Optional
function ImGui:pop_style_var(ctx, integer)
    local integer = integer or nil
    return r.ImGui_PopStyleVar(ctx, integer)
end


--- Pop Tab Stop. Wraps ImGui_PopTabStop.
-- See PushTabStop
-- @param ctx ImGui_Context
function ImGui:pop_tab_stop(ctx)
    return r.ImGui_PopTabStop(ctx)
end


--- Pop Text Wrap Pos. Wraps ImGui_PopTextWrapPos.
-- @param ctx ImGui_Context
function ImGui:pop_text_wrap_pos(ctx)
    return r.ImGui_PopTextWrapPos(ctx)
end


--- Popup Flags Any Popup. Wraps ImGui_PopupFlags_AnyPopup.
-- PopupFlags_AnyPopupId | PopupFlags_AnyPopupLevel
-- @return number
function ImGui:popup_flags_any_popup()
    return r.ImGui_PopupFlags_AnyPopup()
end


--- Popup Flags Any Popup Id. Wraps ImGui_PopupFlags_AnyPopupId.
-- Ignore the str_id parameter and test for any popup.
-- @return number
function ImGui:popup_flags_any_popup_id()
    return r.ImGui_PopupFlags_AnyPopupId()
end


--- Popup Flags Any Popup Level. Wraps ImGui_PopupFlags_AnyPopupLevel.
-- Search/test at any level of the popup stack (default test in the current level).
-- @return number
function ImGui:popup_flags_any_popup_level()
    return r.ImGui_PopupFlags_AnyPopupLevel()
end


--- Popup Flags Mouse Button Left. Wraps ImGui_PopupFlags_MouseButtonLeft.
-- Open on Left Mouse release.    Guaranteed to always be == 0 (same as
-- MouseButton_Left).
-- @return number
function ImGui:popup_flags_mouse_button_left()
    return r.ImGui_PopupFlags_MouseButtonLeft()
end


--- Popup Flags Mouse Button Middle. Wraps ImGui_PopupFlags_MouseButtonMiddle.
-- Open on Middle Mouse release.    Guaranteed to always be == 2 (same as
-- MouseButton_Middle).
-- @return number
function ImGui:popup_flags_mouse_button_middle()
    return r.ImGui_PopupFlags_MouseButtonMiddle()
end


--- Popup Flags Mouse Button Right. Wraps ImGui_PopupFlags_MouseButtonRight.
-- Open on Right Mouse release.    Guaranteed to always be == 1 (same as
-- MouseButton_Right).
-- @return number
function ImGui:popup_flags_mouse_button_right()
    return r.ImGui_PopupFlags_MouseButtonRight()
end


--- Popup Flags No Open Over Existing Popup. Wraps ImGui_PopupFlags_NoOpenOverExistingPopup.
-- Don't open if there's already a popup at the same level of the popup stack.
-- @return number
function ImGui:popup_flags_no_open_over_existing_popup()
    return r.ImGui_PopupFlags_NoOpenOverExistingPopup()
end


--- Popup Flags No Open Over Items. Wraps ImGui_PopupFlags_NoOpenOverItems.
-- For BeginPopupContextWindow: don't return true when hovering items,    only when
-- hovering empty space.
-- @return number
function ImGui:popup_flags_no_open_over_items()
    return r.ImGui_PopupFlags_NoOpenOverItems()
end


--- Popup Flags No Reopen. Wraps ImGui_PopupFlags_NoReopen.
-- Don't reopen same popup if already open    (won't reposition, won't reinitialize
-- navigation).
-- @return number
function ImGui:popup_flags_no_reopen()
    return r.ImGui_PopupFlags_NoReopen()
end


--- Popup Flags None. Wraps ImGui_PopupFlags_None.
-- @return number
function ImGui:popup_flags_none()
    return r.ImGui_PopupFlags_None()
end


--- Progress Bar. Wraps ImGui_ProgressBar.
-- Fraction < 0.0 displays an indeterminate progress bar animation since v0.9.1.
-- The value must be animated along with time, for example `-1.0 *
-- ImGui.GetTime()`.
-- @param ctx ImGui_Context
-- @param fraction number
-- @param number size_arg_wIn Optional
-- @param number size_arg_hIn Optional
-- @param string overlayIn Optional
function ImGui:progress_bar(ctx, fraction, number, number, string)
    local number = number or nil
    local string = string or nil
    return r.ImGui_ProgressBar(ctx, fraction, number, number, string)
end


--- Push Button Repeat. Wraps ImGui_PushButtonRepeat.
-- In 'repeat' mode, Button*() functions return repeated true in a typematic manner
-- (using ConfigVar_KeyRepeatDelay/ConfigVar_KeyRepeatRate settings).
-- @param ctx ImGui_Context
-- @param repeat_ boolean
function ImGui:push_button_repeat(ctx, repeat_)
    return r.ImGui_PushButtonRepeat(ctx, repeat_)
end


--- Push Clip Rect. Wraps ImGui_PushClipRect.
-- @param ctx ImGui_Context
-- @param clip_rect_min_x number
-- @param clip_rect_min_y number
-- @param clip_rect_max_x number
-- @param clip_rect_max_y number
-- @param intersect_with_current_clip_rect boolean
function ImGui:push_clip_rect(ctx, clip_rect_min_x, clip_rect_min_y, clip_rect_max_x, clip_rect_max_y, intersect_with_current_clip_rect)
    return r.ImGui_PushClipRect(ctx, clip_rect_min_x, clip_rect_min_y, clip_rect_max_x, clip_rect_max_y, intersect_with_current_clip_rect)
end


--- Push Font. Wraps ImGui_PushFont.
-- Change the current font. Use nil to push the default font. The font object must
-- have been registered using Attach. See PopFont.
-- @param ctx ImGui_Context
-- @param font ImGui_Font
function ImGui:push_font(ctx, font)
    return r.ImGui_PushFont(ctx, font)
end


--- Push Id. Wraps ImGui_PushID.
-- Push string into the ID stack.
-- @param ctx ImGui_Context
-- @param str_id string
function ImGui:push_id(ctx, str_id)
    return r.ImGui_PushID(ctx, str_id)
end


--- Push Item Width. Wraps ImGui_PushItemWidth.
-- Push width of items for common large "item+label" widgets.
-- @param ctx ImGui_Context
-- @param item_width number
function ImGui:push_item_width(ctx, item_width)
    return r.ImGui_PushItemWidth(ctx, item_width)
end


--- Push Style Color. Wraps ImGui_PushStyleColor.
-- Temporarily modify a style color. Call PopStyleColor to undo after use (before
-- the end of the frame). See Col_* for available style colors.
-- @param ctx ImGui_Context
-- @param idx number
-- @param col_rgba number
function ImGui:push_style_color(ctx, idx, col_rgba)
    return r.ImGui_PushStyleColor(ctx, idx, col_rgba)
end


--- Push Style Var. Wraps ImGui_PushStyleVar.
-- Temporarily modify a style variable. Call PopStyleVar to undo after use (before
-- the end of the frame). See StyleVar_* for possible values of 'var_idx'.
-- @param ctx ImGui_Context
-- @param var_idx number
-- @param val1 number
-- @param number val2In Optional
function ImGui:push_style_var(ctx, var_idx, val1, number)
    local number = number or nil
    return r.ImGui_PushStyleVar(ctx, var_idx, val1, number)
end


--- Push Tab Stop. Wraps ImGui_PushTabStop.
-- Allow focusing using TAB/Shift-TAB, enabled by default but you can disable it
-- for certain widgets
-- @param ctx ImGui_Context
-- @param tab_stop boolean
function ImGui:push_tab_stop(ctx, tab_stop)
    return r.ImGui_PushTabStop(ctx, tab_stop)
end


--- Push Text Wrap Pos. Wraps ImGui_PushTextWrapPos.
-- Push word-wrapping position for Text*() commands.
-- @param ctx ImGui_Context
-- @param number wrap_local_pos_xIn Optional
function ImGui:push_text_wrap_pos(ctx, number)
    local number = number or nil
    return r.ImGui_PushTextWrapPos(ctx, number)
end


--- Radio Button. Wraps ImGui_RadioButton.
-- Use with e.g. if (RadioButton("one", my_value==1)) { my_value = 1; }
-- @param ctx ImGui_Context
-- @param label string
-- @param active boolean
-- @return boolean
function ImGui:radio_button(ctx, label, active)
    return r.ImGui_RadioButton(ctx, label, active)
end


--- Radio Button Ex. Wraps ImGui_RadioButtonEx.
-- Shortcut to handle RadioButton's example pattern when value is an integer
-- @param ctx ImGui_Context
-- @param label string
-- @param v number
-- @param v_button number
-- @return v number
function ImGui:radio_button_ex(ctx, label, v, v_button)
    local ret_val, v = r.ImGui_RadioButtonEx(ctx, label, v, v_button)
    if ret_val then
        return v
    else
        return nil
    end
end


--- Reset Mouse Drag Delta. Wraps ImGui_ResetMouseDragDelta.
-- @param ctx ImGui_Context
-- @param integer buttonIn Optional
function ImGui:reset_mouse_drag_delta(ctx, integer)
    local integer = integer or nil
    return r.ImGui_ResetMouseDragDelta(ctx, integer)
end


--- Same Line. Wraps ImGui_SameLine.
-- Call between widgets or groups to layout them horizontally. X position given in
-- window coordinates.
-- @param ctx ImGui_Context
-- @param number offset_from_start_xIn Optional
-- @param number spacingIn Optional
function ImGui:same_line(ctx, number, number)
    local number = number or nil
    return r.ImGui_SameLine(ctx, number, number)
end


--- Selectable. Wraps ImGui_Selectable.
-- @param ctx ImGui_Context
-- @param label string
-- @param boolean p_selected Optional
-- @param integer flagsIn Optional
-- @param number size_wIn Optional
-- @param number size_hIn Optional
-- @return boolean p_selected
function ImGui:selectable(ctx, label, boolean, integer, number, number)
    local boolean = boolean or nil
    local integer = integer or nil
    local number = number or nil
    local ret_val, boolean = r.ImGui_Selectable(ctx, label, boolean, integer, number, number)
    if ret_val then
        return boolean
    else
        return nil
    end
end


--- Selectable Flags Allow Double Click. Wraps ImGui_SelectableFlags_AllowDoubleClick.
-- Generate press events on double clicks too.
-- @return number
function ImGui:selectable_flags_allow_double_click()
    return r.ImGui_SelectableFlags_AllowDoubleClick()
end


--- Selectable Flags Allow Overlap. Wraps ImGui_SelectableFlags_AllowOverlap.
-- Hit testing to allow subsequent widgets to overlap this one.
-- @return number
function ImGui:selectable_flags_allow_overlap()
    return r.ImGui_SelectableFlags_AllowOverlap()
end


--- Selectable Flags Disabled. Wraps ImGui_SelectableFlags_Disabled.
-- Cannot be selected, display grayed out text.
-- @return number
function ImGui:selectable_flags_disabled()
    return r.ImGui_SelectableFlags_Disabled()
end


--- Selectable Flags Dont Close Popups. Wraps ImGui_SelectableFlags_DontClosePopups.
-- Clicking this doesn't close parent popup window.
-- @return number
function ImGui:selectable_flags_dont_close_popups()
    return r.ImGui_SelectableFlags_DontClosePopups()
end


--- Selectable Flags None. Wraps ImGui_SelectableFlags_None.
-- @return number
function ImGui:selectable_flags_none()
    return r.ImGui_SelectableFlags_None()
end


--- Selectable Flags Span All Columns. Wraps ImGui_SelectableFlags_SpanAllColumns.
-- Frame will span all columns of its container table (text will still fit in
-- current column).
-- @return number
function ImGui:selectable_flags_span_all_columns()
    return r.ImGui_SelectableFlags_SpanAllColumns()
end


--- Separator. Wraps ImGui_Separator.
-- Separator, generally horizontal. inside a menu bar or in horizontal layout mode,
-- this becomes a vertical separator.
-- @param ctx ImGui_Context
function ImGui:separator(ctx)
    return r.ImGui_Separator(ctx)
end


--- Separator Text. Wraps ImGui_SeparatorText.
-- Text formatted with an horizontal line
-- @param ctx ImGui_Context
-- @param label string
function ImGui:separator_text(ctx, label)
    return r.ImGui_SeparatorText(ctx, label)
end


--- Set Clipboard Text. Wraps ImGui_SetClipboardText.
-- See also the LogToClipboard function to capture GUI into clipboard, or easily
-- output text data to the clipboard.
-- @param ctx ImGui_Context
-- @param text string
function ImGui:set_clipboard_text(ctx, text)
    return r.ImGui_SetClipboardText(ctx, text)
end


--- Set Color Edit Options. Wraps ImGui_SetColorEditOptions.
-- Picker type, etc. User will be able to change many settings, unless you pass the
-- _NoOptions flag to your calls.
-- @param ctx ImGui_Context
-- @param flags number
function ImGui:set_color_edit_options(ctx, flags)
    return r.ImGui_SetColorEditOptions(ctx, flags)
end


--- Set Config Var. Wraps ImGui_SetConfigVar.
-- @param ctx ImGui_Context
-- @param var_idx number
-- @param value number
function ImGui:set_config_var(ctx, var_idx, value)
    return r.ImGui_SetConfigVar(ctx, var_idx, value)
end


--- Set Cursor Pos. Wraps ImGui_SetCursorPos.
-- Cursor position in window
-- @param ctx ImGui_Context
-- @param local_pos_x number
-- @param local_pos_y number
function ImGui:set_cursor_pos(ctx, local_pos_x, local_pos_y)
    return r.ImGui_SetCursorPos(ctx, local_pos_x, local_pos_y)
end


--- Set Cursor Pos X. Wraps ImGui_SetCursorPosX.
-- Cursor X position in window
-- @param ctx ImGui_Context
-- @param local_x number
function ImGui:set_cursor_pos_x(ctx, local_x)
    return r.ImGui_SetCursorPosX(ctx, local_x)
end


--- Set Cursor Pos Y. Wraps ImGui_SetCursorPosY.
-- Cursor Y position in window
-- @param ctx ImGui_Context
-- @param local_y number
function ImGui:set_cursor_pos_y(ctx, local_y)
    return r.ImGui_SetCursorPosY(ctx, local_y)
end


--- Set Cursor Screen Pos. Wraps ImGui_SetCursorScreenPos.
-- Cursor position in absolute screen coordinates.
-- @param ctx ImGui_Context
-- @param pos_x number
-- @param pos_y number
function ImGui:set_cursor_screen_pos(ctx, pos_x, pos_y)
    return r.ImGui_SetCursorScreenPos(ctx, pos_x, pos_y)
end


--- Set Drag Drop Payload. Wraps ImGui_SetDragDropPayload.
-- The type is a user defined string of maximum 32 characters. Strings starting
-- with '_' are reserved for dear imgui internal types. Data is copied and held by
-- imgui.
-- @param ctx ImGui_Context
-- @param type string
-- @param data string
-- @param integer condIn Optional
-- @return boolean
function ImGui:set_drag_drop_payload(ctx, type, data, integer)
    local integer = integer or nil
    return r.ImGui_SetDragDropPayload(ctx, type, data, integer)
end


--- Set Item Default Focus. Wraps ImGui_SetItemDefaultFocus.
-- Make last item the default focused item of a window.
-- @param ctx ImGui_Context
function ImGui:set_item_default_focus(ctx)
    return r.ImGui_SetItemDefaultFocus(ctx)
end


--- Set Item Tooltip. Wraps ImGui_SetItemTooltip.
-- Set a text-only tooltip if preceding item was hovered. Override any previous
-- call to SetTooltip(). Shortcut for `if (IsItemHovered(HoveredFlags_ForTooltip))
-- { SetTooltip(...); }`.
-- @param ctx ImGui_Context
-- @param text string
function ImGui:set_item_tooltip(ctx, text)
    return r.ImGui_SetItemTooltip(ctx, text)
end


--- Set Keyboard Focus Here. Wraps ImGui_SetKeyboardFocusHere.
-- Focus keyboard on the next widget. Use positive 'offset' to access sub
-- components of a multiple component widget. Use -1 to access previous widget.
-- @param ctx ImGui_Context
-- @param integer offsetIn Optional
function ImGui:set_keyboard_focus_here(ctx, integer)
    local integer = integer or nil
    return r.ImGui_SetKeyboardFocusHere(ctx, integer)
end


--- Set Mouse Cursor. Wraps ImGui_SetMouseCursor.
-- Set desired mouse cursor shape. See MouseCursor_* for possible values.
-- @param ctx ImGui_Context
-- @param cursor_type number
function ImGui:set_mouse_cursor(ctx, cursor_type)
    return r.ImGui_SetMouseCursor(ctx, cursor_type)
end


--- Set Next Frame Want Capture Keyboard. Wraps ImGui_SetNextFrameWantCaptureKeyboard.
-- Request capture of keyboard shortcuts in REAPER's global scope for the next
-- frame.
-- @param ctx ImGui_Context
-- @param want_capture_keyboard boolean
function ImGui:set_next_frame_want_capture_keyboard(ctx, want_capture_keyboard)
    return r.ImGui_SetNextFrameWantCaptureKeyboard(ctx, want_capture_keyboard)
end


--- Set Next Item Allow Overlap. Wraps ImGui_SetNextItemAllowOverlap.
-- Allow next item to be overlapped by a subsequent item. Useful with invisible
-- buttons, selectable, treenode covering an area where subsequent items may need
-- to be added. Note that both Selectable() and TreeNode() have dedicated flags
-- doing this.
-- @param ctx ImGui_Context
function ImGui:set_next_item_allow_overlap(ctx)
    return r.ImGui_SetNextItemAllowOverlap(ctx)
end


--- Set Next Item Open. Wraps ImGui_SetNextItemOpen.
-- Set next TreeNode/CollapsingHeader open state. Can also be done with the
-- TreeNodeFlags_DefaultOpen flag.
-- @param ctx ImGui_Context
-- @param is_open boolean
-- @param integer condIn Optional
function ImGui:set_next_item_open(ctx, is_open, integer)
    local integer = integer or nil
    return r.ImGui_SetNextItemOpen(ctx, is_open, integer)
end


--- Set Next Item Shortcut. Wraps ImGui_SetNextItemShortcut.
-- @param ctx ImGui_Context
-- @param key_chord number
-- @param integer flagsIn Optional
function ImGui:set_next_item_shortcut(ctx, key_chord, integer)
    local integer = integer or nil
    return r.ImGui_SetNextItemShortcut(ctx, key_chord, integer)
end


--- Set Next Item Width. Wraps ImGui_SetNextItemWidth.
-- Set width of the _next_ common large "item+label" widget.
-- @param ctx ImGui_Context
-- @param item_width number
function ImGui:set_next_item_width(ctx, item_width)
    return r.ImGui_SetNextItemWidth(ctx, item_width)
end


--- Set Next Window Bg Alpha. Wraps ImGui_SetNextWindowBgAlpha.
-- Set next window background color alpha. Helper to easily override the Alpha
-- component of Col_WindowBg/Col_ChildBg/Col_PopupBg. You may also use
-- WindowFlags_NoBackground for a fully transparent window.
-- @param ctx ImGui_Context
-- @param alpha number
function ImGui:set_next_window_bg_alpha(ctx, alpha)
    return r.ImGui_SetNextWindowBgAlpha(ctx, alpha)
end


--- Set Next Window Collapsed. Wraps ImGui_SetNextWindowCollapsed.
-- Set next window collapsed state.
-- @param ctx ImGui_Context
-- @param collapsed boolean
-- @param integer condIn Optional
function ImGui:set_next_window_collapsed(ctx, collapsed, integer)
    local integer = integer or nil
    return r.ImGui_SetNextWindowCollapsed(ctx, collapsed, integer)
end


--- Set Next Window Content Size. Wraps ImGui_SetNextWindowContentSize.
-- Set next window content size (~ scrollable client area, which enforce the range
-- of scrollbars). Not including window decorations (title bar, menu bar, etc.) nor
-- StyleVar_WindowPadding. set an axis to 0.0 to leave it automatic.
-- @param ctx ImGui_Context
-- @param size_w number
-- @param size_h number
function ImGui:set_next_window_content_size(ctx, size_w, size_h)
    return r.ImGui_SetNextWindowContentSize(ctx, size_w, size_h)
end


--- Set Next Window Dock Id. Wraps ImGui_SetNextWindowDockID.
-- @param ctx ImGui_Context
-- @param dock_id number
-- @param integer condIn Optional
function ImGui:set_next_window_dock_id(ctx, dock_id, integer)
    local integer = integer or nil
    return r.ImGui_SetNextWindowDockID(ctx, dock_id, integer)
end


--- Set Next Window Focus. Wraps ImGui_SetNextWindowFocus.
-- Set next window to be focused / top-most.
-- @param ctx ImGui_Context
function ImGui:set_next_window_focus(ctx)
    return r.ImGui_SetNextWindowFocus(ctx)
end


--- Set Next Window Pos. Wraps ImGui_SetNextWindowPos.
-- Set next window position. Use pivot=(0.5,0.5) to center on given point, etc.
-- @param ctx ImGui_Context
-- @param pos_x number
-- @param pos_y number
-- @param integer condIn Optional
-- @param number pivot_xIn Optional
-- @param number pivot_yIn Optional
function ImGui:set_next_window_pos(ctx, pos_x, pos_y, integer, number, number)
    local integer = integer or nil
    local number = number or nil
    return r.ImGui_SetNextWindowPos(ctx, pos_x, pos_y, integer, number, number)
end


--- Set Next Window Scroll. Wraps ImGui_SetNextWindowScroll.
-- Set next window scrolling value (use < 0.0 to not affect a given axis).
-- @param ctx ImGui_Context
-- @param scroll_x number
-- @param scroll_y number
function ImGui:set_next_window_scroll(ctx, scroll_x, scroll_y)
    return r.ImGui_SetNextWindowScroll(ctx, scroll_x, scroll_y)
end


--- Set Next Window Size. Wraps ImGui_SetNextWindowSize.
-- Set next window size. set axis to 0.0 to force an auto-fit on this axis.
-- @param ctx ImGui_Context
-- @param size_w number
-- @param size_h number
-- @param integer condIn Optional
function ImGui:set_next_window_size(ctx, size_w, size_h, integer)
    local integer = integer or nil
    return r.ImGui_SetNextWindowSize(ctx, size_w, size_h, integer)
end


--- Set Next Window Size Constraints. Wraps ImGui_SetNextWindowSizeConstraints.
-- Set next window size limits. Use 0.0 or FLT_MAX (second return value of
-- NumericLimits_Float) if you don't want limits.
-- @param ctx ImGui_Context
-- @param size_min_w number
-- @param size_min_h number
-- @param size_max_w number
-- @param size_max_h number
-- @param custom_callback_in ImGui_Function
function ImGui:set_next_window_size_constraints(ctx, size_min_w, size_min_h, size_max_w, size_max_h, custom_callback_in)
    return r.ImGui_SetNextWindowSizeConstraints(ctx, size_min_w, size_min_h, size_max_w, size_max_h, custom_callback_in)
end


--- Set Scroll From Pos X. Wraps ImGui_SetScrollFromPosX.
-- Adjust scrolling amount to make given position visible. Generally
-- GetCursorStartPos() + offset to compute a valid position.
-- @param ctx ImGui_Context
-- @param local_x number
-- @param number center_x_ratioIn Optional
function ImGui:set_scroll_from_pos_x(ctx, local_x, number)
    local number = number or nil
    return r.ImGui_SetScrollFromPosX(ctx, local_x, number)
end


--- Set Scroll From Pos Y. Wraps ImGui_SetScrollFromPosY.
-- Adjust scrolling amount to make given position visible. Generally
-- GetCursorStartPos() + offset to compute a valid position.
-- @param ctx ImGui_Context
-- @param local_y number
-- @param number center_y_ratioIn Optional
function ImGui:set_scroll_from_pos_y(ctx, local_y, number)
    local number = number or nil
    return r.ImGui_SetScrollFromPosY(ctx, local_y, number)
end


--- Set Scroll Here X. Wraps ImGui_SetScrollHereX.
-- Adjust scrolling amount to make current cursor position visible.
-- center_x_ratio=0.0: left, 0.5: center, 1.0: right. When using to make a
-- "default/current item" visible, consider using SetItemDefaultFocus instead.
-- @param ctx ImGui_Context
-- @param number center_x_ratioIn Optional
function ImGui:set_scroll_here_x(ctx, number)
    local number = number or nil
    return r.ImGui_SetScrollHereX(ctx, number)
end


--- Set Scroll Here Y. Wraps ImGui_SetScrollHereY.
-- Adjust scrolling amount to make current cursor position visible.
-- center_y_ratio=0.0: top, 0.5: center, 1.0: bottom. When using to make a
-- "default/current item" visible, consider using SetItemDefaultFocus instead.
-- @param ctx ImGui_Context
-- @param number center_y_ratioIn Optional
function ImGui:set_scroll_here_y(ctx, number)
    local number = number or nil
    return r.ImGui_SetScrollHereY(ctx, number)
end


--- Set Scroll X. Wraps ImGui_SetScrollX.
-- Set scrolling amount [0 .. GetScrollMaxX()]
-- @param ctx ImGui_Context
-- @param scroll_x number
function ImGui:set_scroll_x(ctx, scroll_x)
    return r.ImGui_SetScrollX(ctx, scroll_x)
end


--- Set Scroll Y. Wraps ImGui_SetScrollY.
-- Set scrolling amount [0 .. GetScrollMaxY()]
-- @param ctx ImGui_Context
-- @param scroll_y number
function ImGui:set_scroll_y(ctx, scroll_y)
    return r.ImGui_SetScrollY(ctx, scroll_y)
end


--- Set Tab Item Closed. Wraps ImGui_SetTabItemClosed.
-- Notify TabBar or Docking system of a closed tab/window ahead (useful to reduce
-- visual flicker on reorderable tab bars). For tab-bar: call after BeginTabBar and
-- before Tab submissions. Otherwise call with a window name.
-- @param ctx ImGui_Context
-- @param tab_or_docked_window_label string
function ImGui:set_tab_item_closed(ctx, tab_or_docked_window_label)
    return r.ImGui_SetTabItemClosed(ctx, tab_or_docked_window_label)
end


--- Set Tooltip. Wraps ImGui_SetTooltip.
-- Set a text-only tooltip. Often used after a IsItemHovered() check. Override any
-- previous call to SetTooltip.
-- @param ctx ImGui_Context
-- @param text string
function ImGui:set_tooltip(ctx, text)
    return r.ImGui_SetTooltip(ctx, text)
end


--- Set Window Collapsed. Wraps ImGui_SetWindowCollapsed.
-- (Not recommended) Set current window collapsed state. Prefer using
-- SetNextWindowCollapsed.
-- @param ctx ImGui_Context
-- @param collapsed boolean
-- @param integer condIn Optional
function ImGui:set_window_collapsed(ctx, collapsed, integer)
    local integer = integer or nil
    return r.ImGui_SetWindowCollapsed(ctx, collapsed, integer)
end


--- Set Window Collapsed Ex. Wraps ImGui_SetWindowCollapsedEx.
-- Set named window collapsed state.
-- @param ctx ImGui_Context
-- @param name string
-- @param collapsed boolean
-- @param integer condIn Optional
function ImGui:set_window_collapsed_ex(ctx, name, collapsed, integer)
    local integer = integer or nil
    return r.ImGui_SetWindowCollapsedEx(ctx, name, collapsed, integer)
end


--- Set Window Focus. Wraps ImGui_SetWindowFocus.
-- (Not recommended) Set current window to be focused / top-most. Prefer using
-- SetNextWindowFocus.
-- @param ctx ImGui_Context
function ImGui:set_window_focus(ctx)
    return r.ImGui_SetWindowFocus(ctx)
end


--- Set Window Focus Ex. Wraps ImGui_SetWindowFocusEx.
-- Set named window to be focused / top-most. Use an empty name to remove focus.
-- @param ctx ImGui_Context
-- @param name string
function ImGui:set_window_focus_ex(ctx, name)
    return r.ImGui_SetWindowFocusEx(ctx, name)
end


--- Set Window Pos. Wraps ImGui_SetWindowPos.
-- (Not recommended) Set current window position - call within Begin/End. Prefer
-- using SetNextWindowPos, as this may incur tearing and minor side-effects.
-- @param ctx ImGui_Context
-- @param pos_x number
-- @param pos_y number
-- @param integer condIn Optional
function ImGui:set_window_pos(ctx, pos_x, pos_y, integer)
    local integer = integer or nil
    return r.ImGui_SetWindowPos(ctx, pos_x, pos_y, integer)
end


--- Set Window Pos Ex. Wraps ImGui_SetWindowPosEx.
-- Set named window position.
-- @param ctx ImGui_Context
-- @param name string
-- @param pos_x number
-- @param pos_y number
-- @param integer condIn Optional
function ImGui:set_window_pos_ex(ctx, name, pos_x, pos_y, integer)
    local integer = integer or nil
    return r.ImGui_SetWindowPosEx(ctx, name, pos_x, pos_y, integer)
end


--- Set Window Size. Wraps ImGui_SetWindowSize.
-- (Not recommended) Set current window size - call within Begin/End. Set size_w
-- and size_h to 0 to force an auto-fit. Prefer using SetNextWindowSize, as this
-- may incur tearing and minor side-effects.
-- @param ctx ImGui_Context
-- @param size_w number
-- @param size_h number
-- @param integer condIn Optional
function ImGui:set_window_size(ctx, size_w, size_h, integer)
    local integer = integer or nil
    return r.ImGui_SetWindowSize(ctx, size_w, size_h, integer)
end


--- Set Window Size Ex. Wraps ImGui_SetWindowSizeEx.
-- Set named window size. Set axis to 0.0 to force an auto-fit on this axis.
-- @param ctx ImGui_Context
-- @param name string
-- @param size_w number
-- @param size_h number
-- @param integer condIn Optional
function ImGui:set_window_size_ex(ctx, name, size_w, size_h, integer)
    local integer = integer or nil
    return r.ImGui_SetWindowSizeEx(ctx, name, size_w, size_h, integer)
end


--- Shortcut. Wraps ImGui_Shortcut.
-- @param ctx ImGui_Context
-- @param key_chord number
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:shortcut(ctx, key_chord, integer)
    local integer = integer or nil
    return r.ImGui_Shortcut(ctx, key_chord, integer)
end


--- Show About Window. Wraps ImGui_ShowAboutWindow.
-- Create About window. Display ReaImGui version, Dear ImGui version, credits and
-- build/system information.
-- @param ctx ImGui_Context
-- @param boolean p_open Optional
-- @return boolean p_open
function ImGui:show_about_window(ctx, boolean)
    local boolean = boolean or nil
    return r.ImGui_ShowAboutWindow(ctx, boolean)
end


--- Show Debug Log Window. Wraps ImGui_ShowDebugLogWindow.
-- Create Debug Log window. display a simplified log of important dear imgui
-- events.
-- @param ctx ImGui_Context
-- @param boolean p_open Optional
-- @return boolean p_open
function ImGui:show_debug_log_window(ctx, boolean)
    local boolean = boolean or nil
    return r.ImGui_ShowDebugLogWindow(ctx, boolean)
end


--- Show Id Stack Tool Window. Wraps ImGui_ShowIDStackToolWindow.
-- Create Stack Tool window. Hover items with mouse to query information about the
-- source of their unique ID.
-- @param ctx ImGui_Context
-- @param boolean p_open Optional
-- @return boolean p_open
function ImGui:show_id_stack_tool_window(ctx, boolean)
    local boolean = boolean or nil
    return r.ImGui_ShowIDStackToolWindow(ctx, boolean)
end


--- Show Metrics Window. Wraps ImGui_ShowMetricsWindow.
-- Create Metrics/Debugger window. Display Dear ImGui internals: windows, draw
-- commands, various internal state, etc.
-- @param ctx ImGui_Context
-- @param boolean p_open Optional
-- @return boolean p_open
function ImGui:show_metrics_window(ctx, boolean)
    local boolean = boolean or nil
    return r.ImGui_ShowMetricsWindow(ctx, boolean)
end


--- Slider Angle. Wraps ImGui_SliderAngle.
-- @param ctx ImGui_Context
-- @param label string
-- @param v_rad number
-- @param number v_degrees_minIn Optional
-- @param number v_degrees_maxIn Optional
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v_rad number
function ImGui:slider_angle(ctx, label, v_rad, number, number, string, integer)
    local number = number or nil
    local string = string or nil
    local integer = integer or nil
    local ret_val, v_rad = r.ImGui_SliderAngle(ctx, label, v_rad, number, number, string, integer)
    if ret_val then
        return v_rad
    else
        return nil
    end
end


--- Slider Double. Wraps ImGui_SliderDouble.
-- @param ctx ImGui_Context
-- @param label string
-- @param v number
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v number
function ImGui:slider_double(ctx, label, v, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v = r.ImGui_SliderDouble(ctx, label, v, v_min, v_max, string, integer)
    if ret_val then
        return v
    else
        return nil
    end
end


--- Slider Double2. Wraps ImGui_SliderDouble2.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
function ImGui:slider_double2(ctx, label, v1, v2, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2 = r.ImGui_SliderDouble2(ctx, label, v1, v2, v_min, v_max, string, integer)
    if ret_val then
        return v1, v2
    else
        return nil
    end
end


--- Slider Double3. Wraps ImGui_SliderDouble3.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
function ImGui:slider_double3(ctx, label, v1, v2, v3, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2, v3 = r.ImGui_SliderDouble3(ctx, label, v1, v2, v3, v_min, v_max, string, integer)
    if ret_val then
        return v1, v2, v3
    else
        return nil
    end
end


--- Slider Double4. Wraps ImGui_SliderDouble4.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param v4 number
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
-- @return v4 number
function ImGui:slider_double4(ctx, label, v1, v2, v3, v4, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2, v3, v4 = r.ImGui_SliderDouble4(ctx, label, v1, v2, v3, v4, v_min, v_max, string, integer)
    if ret_val then
        return v1, v2, v3, v4
    else
        return nil
    end
end


--- Slider Double N. Wraps ImGui_SliderDoubleN.
-- @param ctx ImGui_Context
-- @param label string
-- @param values reaper_array
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:slider_double_n(ctx, label, values, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    return r.ImGui_SliderDoubleN(ctx, label, values, v_min, v_max, string, integer)
end


--- Slider Flags Always Clamp. Wraps ImGui_SliderFlags_AlwaysClamp.
-- Clamp value to min/max bounds when input manually with CTRL+Click.    By default
-- CTRL+Click allows going out of bounds.
-- @return number
function ImGui:slider_flags_always_clamp()
    return r.ImGui_SliderFlags_AlwaysClamp()
end


--- Slider Flags Logarithmic. Wraps ImGui_SliderFlags_Logarithmic.
-- Make the widget logarithmic (linear otherwise).    Consider using
-- SliderFlags_NoRoundToFormat with this if using a format-string    with small
-- amount of digits.
-- @return number
function ImGui:slider_flags_logarithmic()
    return r.ImGui_SliderFlags_Logarithmic()
end


--- Slider Flags No Input. Wraps ImGui_SliderFlags_NoInput.
-- Disable CTRL+Click or Enter key allowing to input text directly into the widget.
-- @return number
function ImGui:slider_flags_no_input()
    return r.ImGui_SliderFlags_NoInput()
end


--- Slider Flags No Round To Format. Wraps ImGui_SliderFlags_NoRoundToFormat.
-- Disable rounding underlying value to match precision of the display format
-- string (e.g. %.3f values are rounded to those 3 digits).
-- @return number
function ImGui:slider_flags_no_round_to_format()
    return r.ImGui_SliderFlags_NoRoundToFormat()
end


--- Slider Flags None. Wraps ImGui_SliderFlags_None.
-- @return number
function ImGui:slider_flags_none()
    return r.ImGui_SliderFlags_None()
end


--- Slider Flags Wrap Around. Wraps ImGui_SliderFlags_WrapAround.
-- Enable wrapping around from max to min and from min to max    (only supported by
-- DragXXX() functions for now).
-- @return number
function ImGui:slider_flags_wrap_around()
    return r.ImGui_SliderFlags_WrapAround()
end


--- Slider Int. Wraps ImGui_SliderInt.
-- @param ctx ImGui_Context
-- @param label string
-- @param v number
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v number
function ImGui:slider_int(ctx, label, v, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v = r.ImGui_SliderInt(ctx, label, v, v_min, v_max, string, integer)
    if ret_val then
        return v
    else
        return nil
    end
end


--- Slider Int2. Wraps ImGui_SliderInt2.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
function ImGui:slider_int2(ctx, label, v1, v2, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2 = r.ImGui_SliderInt2(ctx, label, v1, v2, v_min, v_max, string, integer)
    if ret_val then
        return v1, v2
    else
        return nil
    end
end


--- Slider Int3. Wraps ImGui_SliderInt3.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
function ImGui:slider_int3(ctx, label, v1, v2, v3, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2, v3 = r.ImGui_SliderInt3(ctx, label, v1, v2, v3, v_min, v_max, string, integer)
    if ret_val then
        return v1, v2, v3
    else
        return nil
    end
end


--- Slider Int4. Wraps ImGui_SliderInt4.
-- @param ctx ImGui_Context
-- @param label string
-- @param v1 number
-- @param v2 number
-- @param v3 number
-- @param v4 number
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v1 number
-- @return v2 number
-- @return v3 number
-- @return v4 number
function ImGui:slider_int4(ctx, label, v1, v2, v3, v4, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v1, v2, v3, v4 = r.ImGui_SliderInt4(ctx, label, v1, v2, v3, v4, v_min, v_max, string, integer)
    if ret_val then
        return v1, v2, v3, v4
    else
        return nil
    end
end


--- Small Button. Wraps ImGui_SmallButton.
-- Button with StyleVar_FramePadding.y == 0 to easily embed within text.
-- @param ctx ImGui_Context
-- @param label string
-- @return boolean
function ImGui:small_button(ctx, label)
    return r.ImGui_SmallButton(ctx, label)
end


--- Sort Direction Ascending. Wraps ImGui_SortDirection_Ascending.
-- Ascending = 0->9, A->Z etc.
-- @return number
function ImGui:sort_direction_ascending()
    return r.ImGui_SortDirection_Ascending()
end


--- Sort Direction Descending. Wraps ImGui_SortDirection_Descending.
-- Descending = 9->0, Z->A etc.
-- @return number
function ImGui:sort_direction_descending()
    return r.ImGui_SortDirection_Descending()
end


--- Sort Direction None. Wraps ImGui_SortDirection_None.
-- @return number
function ImGui:sort_direction_none()
    return r.ImGui_SortDirection_None()
end


--- Spacing. Wraps ImGui_Spacing.
-- Add vertical spacing.
-- @param ctx ImGui_Context
function ImGui:spacing(ctx)
    return r.ImGui_Spacing(ctx)
end


--- Style Var Alpha. Wraps ImGui_StyleVar_Alpha.
-- Global alpha applies to everything in Dear ImGui.
-- @return number
function ImGui:style_var_alpha()
    return r.ImGui_StyleVar_Alpha()
end


--- Style Var Button Text Align. Wraps ImGui_StyleVar_ButtonTextAlign.
-- Alignment of button text when button is larger than text.    Defaults to (0.5,
-- 0.5) (centered).
-- @return number
function ImGui:style_var_button_text_align()
    return r.ImGui_StyleVar_ButtonTextAlign()
end


--- Style Var Cell Padding. Wraps ImGui_StyleVar_CellPadding.
-- Padding within a table cell.    CellPadding.x is locked for entire table.
-- CellPadding.y may be altered between different rows.
-- @return number
function ImGui:style_var_cell_padding()
    return r.ImGui_StyleVar_CellPadding()
end


--- Style Var Child Border Size. Wraps ImGui_StyleVar_ChildBorderSize.
-- Thickness of border around child windows. Generally set to 0.0 or 1.0.    (Other
-- values are not well tested and more CPU/GPU costly).
-- @return number
function ImGui:style_var_child_border_size()
    return r.ImGui_StyleVar_ChildBorderSize()
end


--- Style Var Child Rounding. Wraps ImGui_StyleVar_ChildRounding.
-- Radius of child window corners rounding. Set to 0.0 to have rectangular windows.
-- @return number
function ImGui:style_var_child_rounding()
    return r.ImGui_StyleVar_ChildRounding()
end


--- Style Var Disabled Alpha. Wraps ImGui_StyleVar_DisabledAlpha.
-- Additional alpha multiplier applied by BeginDisabled.   Multiply over current
-- value of Alpha.
-- @return number
function ImGui:style_var_disabled_alpha()
    return r.ImGui_StyleVar_DisabledAlpha()
end


--- Style Var Frame Border Size. Wraps ImGui_StyleVar_FrameBorderSize.
-- Thickness of border around frames. Generally set to 0.0 or 1.0.    (Other values
-- are not well tested and more CPU/GPU costly).
-- @return number
function ImGui:style_var_frame_border_size()
    return r.ImGui_StyleVar_FrameBorderSize()
end


--- Style Var Frame Padding. Wraps ImGui_StyleVar_FramePadding.
-- Padding within a framed rectangle (used by most widgets).
-- @return number
function ImGui:style_var_frame_padding()
    return r.ImGui_StyleVar_FramePadding()
end


--- Style Var Frame Rounding. Wraps ImGui_StyleVar_FrameRounding.
-- Radius of frame corners rounding.    Set to 0.0 to have rectangular frame (used
-- by most widgets).
-- @return number
function ImGui:style_var_frame_rounding()
    return r.ImGui_StyleVar_FrameRounding()
end


--- Style Var Grab Min Size. Wraps ImGui_StyleVar_GrabMinSize.
-- Minimum width/height of a grab box for slider/scrollbar.
-- @return number
function ImGui:style_var_grab_min_size()
    return r.ImGui_StyleVar_GrabMinSize()
end


--- Style Var Grab Rounding. Wraps ImGui_StyleVar_GrabRounding.
-- Radius of grabs corners rounding. Set to 0.0 to have rectangular slider grabs.
-- @return number
function ImGui:style_var_grab_rounding()
    return r.ImGui_StyleVar_GrabRounding()
end


--- Style Var Indent Spacing. Wraps ImGui_StyleVar_IndentSpacing.
-- Horizontal indentation when e.g. entering a tree node.    Generally ==
-- (GetFontSize + StyleVar_FramePadding.x*2).
-- @return number
function ImGui:style_var_indent_spacing()
    return r.ImGui_StyleVar_IndentSpacing()
end


--- Style Var Item Inner Spacing. Wraps ImGui_StyleVar_ItemInnerSpacing.
-- Horizontal and vertical spacing between within elements of a composed widget
-- (e.g. a slider and its label).
-- @return number
function ImGui:style_var_item_inner_spacing()
    return r.ImGui_StyleVar_ItemInnerSpacing()
end


--- Style Var Item Spacing. Wraps ImGui_StyleVar_ItemSpacing.
-- Horizontal and vertical spacing between widgets/lines.
-- @return number
function ImGui:style_var_item_spacing()
    return r.ImGui_StyleVar_ItemSpacing()
end


--- Style Var Popup Border Size. Wraps ImGui_StyleVar_PopupBorderSize.
-- Thickness of border around popup/tooltip windows. Generally set to 0.0 or 1.0.
-- (Other values are not well tested and more CPU/GPU costly).
-- @return number
function ImGui:style_var_popup_border_size()
    return r.ImGui_StyleVar_PopupBorderSize()
end


--- Style Var Popup Rounding. Wraps ImGui_StyleVar_PopupRounding.
-- Radius of popup window corners rounding.    (Note that tooltip windows use
-- StyleVar_WindowRounding.)
-- @return number
function ImGui:style_var_popup_rounding()
    return r.ImGui_StyleVar_PopupRounding()
end


--- Style Var Scrollbar Rounding. Wraps ImGui_StyleVar_ScrollbarRounding.
-- Radius of grab corners for scrollbar.
-- @return number
function ImGui:style_var_scrollbar_rounding()
    return r.ImGui_StyleVar_ScrollbarRounding()
end


--- Style Var Scrollbar Size. Wraps ImGui_StyleVar_ScrollbarSize.
-- Width of the vertical scrollbar, Height of the horizontal scrollbar.
-- @return number
function ImGui:style_var_scrollbar_size()
    return r.ImGui_StyleVar_ScrollbarSize()
end


--- Style Var Selectable Text Align. Wraps ImGui_StyleVar_SelectableTextAlign.
-- Alignment of selectable text. Defaults to (0.0, 0.0) (top-left aligned).    It's
-- generally important to keep this left-aligned if you want to lay    multiple
-- items on a same line.
-- @return number
function ImGui:style_var_selectable_text_align()
    return r.ImGui_StyleVar_SelectableTextAlign()
end


--- Style Var Separator Text Align. Wraps ImGui_StyleVar_SeparatorTextAlign.
-- Alignment of text within the separator. Defaults to (0.0, 0.5) (left aligned,
-- center).
-- @return number
function ImGui:style_var_separator_text_align()
    return r.ImGui_StyleVar_SeparatorTextAlign()
end


--- Style Var Separator Text Border Size. Wraps ImGui_StyleVar_SeparatorTextBorderSize.
-- Thickness of border in SeparatorText()
-- @return number
function ImGui:style_var_separator_text_border_size()
    return r.ImGui_StyleVar_SeparatorTextBorderSize()
end


--- Style Var Separator Text Padding. Wraps ImGui_StyleVar_SeparatorTextPadding.
-- Horizontal offset of text from each edge of the separator + spacing on other
-- axis. Generally small values. .y is recommended to be ==
-- StyleVar_FramePadding.y.
-- @return number
function ImGui:style_var_separator_text_padding()
    return r.ImGui_StyleVar_SeparatorTextPadding()
end


--- Style Var Tab Bar Border Size. Wraps ImGui_StyleVar_TabBarBorderSize.
-- Thickness of tab-bar separator, which takes on the tab active color to denote
-- focus.
-- @return number
function ImGui:style_var_tab_bar_border_size()
    return r.ImGui_StyleVar_TabBarBorderSize()
end


--- Style Var Tab Border Size. Wraps ImGui_StyleVar_TabBorderSize.
-- Thickness of border around tabs.
-- @return number
function ImGui:style_var_tab_border_size()
    return r.ImGui_StyleVar_TabBorderSize()
end


--- Style Var Tab Rounding. Wraps ImGui_StyleVar_TabRounding.
-- Radius of upper corners of a tab. Set to 0.0 to have rectangular tabs.
-- @return number
function ImGui:style_var_tab_rounding()
    return r.ImGui_StyleVar_TabRounding()
end


--- Style Var Table Angled Headers Angle. Wraps ImGui_StyleVar_TableAngledHeadersAngle.
-- Angle of angled headers (supported values range from -50.0 degrees to +50.0
-- degrees).
-- @return number
function ImGui:style_var_table_angled_headers_angle()
    return r.ImGui_StyleVar_TableAngledHeadersAngle()
end


--- Style Var Table Angled Headers Text Align. Wraps ImGui_StyleVar_TableAngledHeadersTextAlign.
-- Alignment of angled headers within the cell
-- @return number
function ImGui:style_var_table_angled_headers_text_align()
    return r.ImGui_StyleVar_TableAngledHeadersTextAlign()
end


--- Style Var Window Border Size. Wraps ImGui_StyleVar_WindowBorderSize.
-- Thickness of border around windows. Generally set to 0.0 or 1.0.   (Other values
-- are not well tested and more CPU/GPU costly).
-- @return number
function ImGui:style_var_window_border_size()
    return r.ImGui_StyleVar_WindowBorderSize()
end


--- Style Var Window Min Size. Wraps ImGui_StyleVar_WindowMinSize.
-- Minimum window size. This is a global setting.   If you want to constrain
-- individual windows, use SetNextWindowSizeConstraints.
-- @return number
function ImGui:style_var_window_min_size()
    return r.ImGui_StyleVar_WindowMinSize()
end


--- Style Var Window Padding. Wraps ImGui_StyleVar_WindowPadding.
-- Padding within a window.
-- @return number
function ImGui:style_var_window_padding()
    return r.ImGui_StyleVar_WindowPadding()
end


--- Style Var Window Rounding. Wraps ImGui_StyleVar_WindowRounding.
-- Radius of window corners rounding. Set to 0.0 to have rectangular windows.
-- Large values tend to lead to variety of artifacts and are not recommended.
-- @return number
function ImGui:style_var_window_rounding()
    return r.ImGui_StyleVar_WindowRounding()
end


--- Style Var Window Title Align. Wraps ImGui_StyleVar_WindowTitleAlign.
-- Alignment for title bar text.    Defaults to (0.0,0.5) for left-
-- aligned,vertically centered.
-- @return number
function ImGui:style_var_window_title_align()
    return r.ImGui_StyleVar_WindowTitleAlign()
end


--- Tab Bar Flags Auto Select New Tabs. Wraps ImGui_TabBarFlags_AutoSelectNewTabs.
-- Automatically select new tabs when they appear.
-- @return number
function ImGui:tab_bar_flags_auto_select_new_tabs()
    return r.ImGui_TabBarFlags_AutoSelectNewTabs()
end


--- Tab Bar Flags Draw Selected Overline. Wraps ImGui_TabBarFlags_DrawSelectedOverline.
-- Draw selected overline markers over selected tab
-- @return number
function ImGui:tab_bar_flags_draw_selected_overline()
    return r.ImGui_TabBarFlags_DrawSelectedOverline()
end


--- Tab Bar Flags Fitting Policy Resize Down. Wraps ImGui_TabBarFlags_FittingPolicyResizeDown.
-- Resize tabs when they don't fit.
-- @return number
function ImGui:tab_bar_flags_fitting_policy_resize_down()
    return r.ImGui_TabBarFlags_FittingPolicyResizeDown()
end


--- Tab Bar Flags Fitting Policy Scroll. Wraps ImGui_TabBarFlags_FittingPolicyScroll.
-- Add scroll buttons when tabs don't fit.
-- @return number
function ImGui:tab_bar_flags_fitting_policy_scroll()
    return r.ImGui_TabBarFlags_FittingPolicyScroll()
end


--- Tab Bar Flags No Close With Middle Mouse Button. Wraps ImGui_TabBarFlags_NoCloseWithMiddleMouseButton.
-- Disable behavior of closing tabs (that are submitted with p_open != nil)    with
-- middle mouse button. You may handle this behavior manually on user's    side
-- with if(IsItemHovered() && IsMouseClicked(2)) p_open = false.
-- @return number
function ImGui:tab_bar_flags_no_close_with_middle_mouse_button()
    return r.ImGui_TabBarFlags_NoCloseWithMiddleMouseButton()
end


--- Tab Bar Flags No Tab List Scrolling Buttons. Wraps ImGui_TabBarFlags_NoTabListScrollingButtons.
-- Disable scrolling buttons (apply when fitting policy is
-- TabBarFlags_FittingPolicyScroll).
-- @return number
function ImGui:tab_bar_flags_no_tab_list_scrolling_buttons()
    return r.ImGui_TabBarFlags_NoTabListScrollingButtons()
end


--- Tab Bar Flags No Tooltip. Wraps ImGui_TabBarFlags_NoTooltip.
-- Disable tooltips when hovering a tab.
-- @return number
function ImGui:tab_bar_flags_no_tooltip()
    return r.ImGui_TabBarFlags_NoTooltip()
end


--- Tab Bar Flags None. Wraps ImGui_TabBarFlags_None.
-- @return number
function ImGui:tab_bar_flags_none()
    return r.ImGui_TabBarFlags_None()
end


--- Tab Bar Flags Reorderable. Wraps ImGui_TabBarFlags_Reorderable.
-- Allow manually dragging tabs to re-order them + New tabs are appended at    the
-- end of list.
-- @return number
function ImGui:tab_bar_flags_reorderable()
    return r.ImGui_TabBarFlags_Reorderable()
end


--- Tab Bar Flags Tab List Popup Button. Wraps ImGui_TabBarFlags_TabListPopupButton.
-- Disable buttons to open the tab list popup.
-- @return number
function ImGui:tab_bar_flags_tab_list_popup_button()
    return r.ImGui_TabBarFlags_TabListPopupButton()
end


--- Tab Item Button. Wraps ImGui_TabItemButton.
-- Create a Tab behaving like a button. Return true when clicked. Cannot be
-- selected in the tab bar.
-- @param ctx ImGui_Context
-- @param label string
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:tab_item_button(ctx, label, integer)
    local integer = integer or nil
    return r.ImGui_TabItemButton(ctx, label, integer)
end


--- Tab Item Flags Leading. Wraps ImGui_TabItemFlags_Leading.
-- Enforce the tab position to the left of the tab bar (after the tab list popup
-- button).
-- @return number
function ImGui:tab_item_flags_leading()
    return r.ImGui_TabItemFlags_Leading()
end


--- Tab Item Flags No Assumed Closure. Wraps ImGui_TabItemFlags_NoAssumedClosure.
-- Tab is selected when trying to close + closure is not immediately assumed
-- (will wait for user to stop submitting the tab).    Otherwise closure is assumed
-- when pressing the X, so if you keep submitting    the tab may reappear at end of
-- tab bar.
-- @return number
function ImGui:tab_item_flags_no_assumed_closure()
    return r.ImGui_TabItemFlags_NoAssumedClosure()
end


--- Tab Item Flags No Close With Middle Mouse Button. Wraps ImGui_TabItemFlags_NoCloseWithMiddleMouseButton.
-- Disable behavior of closing tabs (that are submitted with p_open != nil) with
-- middle mouse button. You can still repro this behavior on user's side with
-- if(IsItemHovered() && IsMouseClicked(2)) p_open = false.
-- @return number
function ImGui:tab_item_flags_no_close_with_middle_mouse_button()
    return r.ImGui_TabItemFlags_NoCloseWithMiddleMouseButton()
end


--- Tab Item Flags No Push Id. Wraps ImGui_TabItemFlags_NoPushId.
-- Don't call PushID()/PopID() on BeginTabItem/EndTabItem.
-- @return number
function ImGui:tab_item_flags_no_push_id()
    return r.ImGui_TabItemFlags_NoPushId()
end


--- Tab Item Flags No Reorder. Wraps ImGui_TabItemFlags_NoReorder.
-- Disable reordering this tab or having another tab cross over this tab.
-- @return number
function ImGui:tab_item_flags_no_reorder()
    return r.ImGui_TabItemFlags_NoReorder()
end


--- Tab Item Flags No Tooltip. Wraps ImGui_TabItemFlags_NoTooltip.
-- Disable tooltip for the given tab.
-- @return number
function ImGui:tab_item_flags_no_tooltip()
    return r.ImGui_TabItemFlags_NoTooltip()
end


--- Tab Item Flags None. Wraps ImGui_TabItemFlags_None.
-- @return number
function ImGui:tab_item_flags_none()
    return r.ImGui_TabItemFlags_None()
end


--- Tab Item Flags Set Selected. Wraps ImGui_TabItemFlags_SetSelected.
-- Trigger flag to programmatically make the tab selected when calling
-- BeginTabItem.
-- @return number
function ImGui:tab_item_flags_set_selected()
    return r.ImGui_TabItemFlags_SetSelected()
end


--- Tab Item Flags Trailing. Wraps ImGui_TabItemFlags_Trailing.
-- Enforce the tab position to the right of the tab bar (before the scrolling
-- buttons).
-- @return number
function ImGui:tab_item_flags_trailing()
    return r.ImGui_TabItemFlags_Trailing()
end


--- Tab Item Flags Unsaved Document. Wraps ImGui_TabItemFlags_UnsavedDocument.
-- Display a dot next to the title + set TabItemFlags_NoAssumedClosure.
-- @return number
function ImGui:tab_item_flags_unsaved_document()
    return r.ImGui_TabItemFlags_UnsavedDocument()
end


--- Table Angled Headers Row. Wraps ImGui_TableAngledHeadersRow.
-- Submit a row with angled headers for every column with the
-- TableColumnFlags_AngledHeader flag. Must be the first row.
-- @param ctx ImGui_Context
function ImGui:table_angled_headers_row(ctx)
    return r.ImGui_TableAngledHeadersRow(ctx)
end


--- Table Bg Target Cell Bg. Wraps ImGui_TableBgTarget_CellBg.
-- Set cell background color (top-most color).
-- @return number
function ImGui:table_bg_target_cell_bg()
    return r.ImGui_TableBgTarget_CellBg()
end


--- Table Bg Target None. Wraps ImGui_TableBgTarget_None.
-- @return number
function ImGui:table_bg_target_none()
    return r.ImGui_TableBgTarget_None()
end


--- Table Bg Target Row Bg0. Wraps ImGui_TableBgTarget_RowBg0.
-- Set row background color 0 (generally used for background,    automatically set
-- when TableFlags_RowBg is used).
-- @return number
function ImGui:table_bg_target_row_bg0()
    return r.ImGui_TableBgTarget_RowBg0()
end


--- Table Bg Target Row Bg1. Wraps ImGui_TableBgTarget_RowBg1.
-- Set row background color 1 (generally used for selection marking).
-- @return number
function ImGui:table_bg_target_row_bg1()
    return r.ImGui_TableBgTarget_RowBg1()
end


--- Table Column Flags Angled Header. Wraps ImGui_TableColumnFlags_AngledHeader.
-- TableHeadersRow will submit an angled header row for this column.    Note this
-- will add an extra row.
-- @return number
function ImGui:table_column_flags_angled_header()
    return r.ImGui_TableColumnFlags_AngledHeader()
end


--- Table Column Flags Default Hide. Wraps ImGui_TableColumnFlags_DefaultHide.
-- Default as a hidden/disabled column.
-- @return number
function ImGui:table_column_flags_default_hide()
    return r.ImGui_TableColumnFlags_DefaultHide()
end


--- Table Column Flags Default Sort. Wraps ImGui_TableColumnFlags_DefaultSort.
-- Default as a sorting column.
-- @return number
function ImGui:table_column_flags_default_sort()
    return r.ImGui_TableColumnFlags_DefaultSort()
end


--- Table Column Flags Disabled. Wraps ImGui_TableColumnFlags_Disabled.
-- Overriding/master disable flag: hide column, won't show in context menu
-- (unlike calling TableSetColumnEnabled which manipulates the user accessible
-- state).
-- @return number
function ImGui:table_column_flags_disabled()
    return r.ImGui_TableColumnFlags_Disabled()
end


--- Table Column Flags Indent Disable. Wraps ImGui_TableColumnFlags_IndentDisable.
-- Ignore current Indent value when entering cell (default for columns > 0).
-- Indentation changes _within_ the cell will still be honored.
-- @return number
function ImGui:table_column_flags_indent_disable()
    return r.ImGui_TableColumnFlags_IndentDisable()
end


--- Table Column Flags Indent Enable. Wraps ImGui_TableColumnFlags_IndentEnable.
-- Use current Indent value when entering cell (default for column 0).
-- @return number
function ImGui:table_column_flags_indent_enable()
    return r.ImGui_TableColumnFlags_IndentEnable()
end


--- Table Column Flags Is Enabled. Wraps ImGui_TableColumnFlags_IsEnabled.
-- Status: is enabled == not hidden by user/api (referred to as "Hide" in
-- _DefaultHide and _NoHide) flags.
-- @return number
function ImGui:table_column_flags_is_enabled()
    return r.ImGui_TableColumnFlags_IsEnabled()
end


--- Table Column Flags Is Hovered. Wraps ImGui_TableColumnFlags_IsHovered.
-- Status: is hovered by mouse.
-- @return number
function ImGui:table_column_flags_is_hovered()
    return r.ImGui_TableColumnFlags_IsHovered()
end


--- Table Column Flags Is Sorted. Wraps ImGui_TableColumnFlags_IsSorted.
-- Status: is currently part of the sort specs.
-- @return number
function ImGui:table_column_flags_is_sorted()
    return r.ImGui_TableColumnFlags_IsSorted()
end


--- Table Column Flags Is Visible. Wraps ImGui_TableColumnFlags_IsVisible.
-- Status: is visible == is enabled AND not clipped by scrolling.
-- @return number
function ImGui:table_column_flags_is_visible()
    return r.ImGui_TableColumnFlags_IsVisible()
end


--- Table Column Flags No Clip. Wraps ImGui_TableColumnFlags_NoClip.
-- Disable clipping for this column    (all NoClip columns will render in a same
-- draw command).
-- @return number
function ImGui:table_column_flags_no_clip()
    return r.ImGui_TableColumnFlags_NoClip()
end


--- Table Column Flags No Header Label. Wraps ImGui_TableColumnFlags_NoHeaderLabel.
-- TableHeadersRow will not submit horizontal label for this column.    Convenient
-- for some small columns. Name will still appear in context menu    or in angled
-- headers.
-- @return number
function ImGui:table_column_flags_no_header_label()
    return r.ImGui_TableColumnFlags_NoHeaderLabel()
end


--- Table Column Flags No Header Width. Wraps ImGui_TableColumnFlags_NoHeaderWidth.
-- Disable header text width contribution to automatic column width.
-- @return number
function ImGui:table_column_flags_no_header_width()
    return r.ImGui_TableColumnFlags_NoHeaderWidth()
end


--- Table Column Flags No Hide. Wraps ImGui_TableColumnFlags_NoHide.
-- Disable ability to hide/disable this column.
-- @return number
function ImGui:table_column_flags_no_hide()
    return r.ImGui_TableColumnFlags_NoHide()
end


--- Table Column Flags No Reorder. Wraps ImGui_TableColumnFlags_NoReorder.
-- Disable manual reordering this column, this will also prevent other columns
-- from crossing over this column.
-- @return number
function ImGui:table_column_flags_no_reorder()
    return r.ImGui_TableColumnFlags_NoReorder()
end


--- Table Column Flags No Resize. Wraps ImGui_TableColumnFlags_NoResize.
-- Disable manual resizing.
-- @return number
function ImGui:table_column_flags_no_resize()
    return r.ImGui_TableColumnFlags_NoResize()
end


--- Table Column Flags No Sort. Wraps ImGui_TableColumnFlags_NoSort.
-- Disable ability to sort on this field    (even if TableFlags_Sortable is set on
-- the table).
-- @return number
function ImGui:table_column_flags_no_sort()
    return r.ImGui_TableColumnFlags_NoSort()
end


--- Table Column Flags No Sort Ascending. Wraps ImGui_TableColumnFlags_NoSortAscending.
-- Disable ability to sort in the ascending direction.
-- @return number
function ImGui:table_column_flags_no_sort_ascending()
    return r.ImGui_TableColumnFlags_NoSortAscending()
end


--- Table Column Flags No Sort Descending. Wraps ImGui_TableColumnFlags_NoSortDescending.
-- Disable ability to sort in the descending direction.
-- @return number
function ImGui:table_column_flags_no_sort_descending()
    return r.ImGui_TableColumnFlags_NoSortDescending()
end


--- Table Column Flags None. Wraps ImGui_TableColumnFlags_None.
-- @return number
function ImGui:table_column_flags_none()
    return r.ImGui_TableColumnFlags_None()
end


--- Table Column Flags Prefer Sort Ascending. Wraps ImGui_TableColumnFlags_PreferSortAscending.
-- Make the initial sort direction Ascending when first sorting on this column
-- (default).
-- @return number
function ImGui:table_column_flags_prefer_sort_ascending()
    return r.ImGui_TableColumnFlags_PreferSortAscending()
end


--- Table Column Flags Prefer Sort Descending. Wraps ImGui_TableColumnFlags_PreferSortDescending.
-- Make the initial sort direction Descending when first sorting on this column.
-- @return number
function ImGui:table_column_flags_prefer_sort_descending()
    return r.ImGui_TableColumnFlags_PreferSortDescending()
end


--- Table Column Flags Width Fixed. Wraps ImGui_TableColumnFlags_WidthFixed.
-- Column will not stretch. Preferable with horizontal scrolling enabled
-- (default if table sizing policy is _SizingFixedFit and table is resizable).
-- @return number
function ImGui:table_column_flags_width_fixed()
    return r.ImGui_TableColumnFlags_WidthFixed()
end


--- Table Column Flags Width Stretch. Wraps ImGui_TableColumnFlags_WidthStretch.
-- Column will stretch. Preferable with horizontal scrolling disabled    (default
-- if table sizing policy is _SizingStretchSame or _SizingStretchProp).
-- @return number
function ImGui:table_column_flags_width_stretch()
    return r.ImGui_TableColumnFlags_WidthStretch()
end


--- Table Flags Borders. Wraps ImGui_TableFlags_Borders.
-- Draw all borders.
-- @return number
function ImGui:table_flags_borders()
    return r.ImGui_TableFlags_Borders()
end


--- Table Flags Borders H. Wraps ImGui_TableFlags_BordersH.
-- Draw horizontal borders.
-- @return number
function ImGui:table_flags_borders_h()
    return r.ImGui_TableFlags_BordersH()
end


--- Table Flags Borders Inner. Wraps ImGui_TableFlags_BordersInner.
-- Draw inner borders.
-- @return number
function ImGui:table_flags_borders_inner()
    return r.ImGui_TableFlags_BordersInner()
end


--- Table Flags Borders Inner H. Wraps ImGui_TableFlags_BordersInnerH.
-- Draw horizontal borders between rows.
-- @return number
function ImGui:table_flags_borders_inner_h()
    return r.ImGui_TableFlags_BordersInnerH()
end


--- Table Flags Borders Inner V. Wraps ImGui_TableFlags_BordersInnerV.
-- Draw vertical borders between columns.
-- @return number
function ImGui:table_flags_borders_inner_v()
    return r.ImGui_TableFlags_BordersInnerV()
end


--- Table Flags Borders Outer. Wraps ImGui_TableFlags_BordersOuter.
-- Draw outer borders.
-- @return number
function ImGui:table_flags_borders_outer()
    return r.ImGui_TableFlags_BordersOuter()
end


--- Table Flags Borders Outer H. Wraps ImGui_TableFlags_BordersOuterH.
-- Draw horizontal borders at the top and bottom.
-- @return number
function ImGui:table_flags_borders_outer_h()
    return r.ImGui_TableFlags_BordersOuterH()
end


--- Table Flags Borders Outer V. Wraps ImGui_TableFlags_BordersOuterV.
-- Draw vertical borders on the left and right sides.
-- @return number
function ImGui:table_flags_borders_outer_v()
    return r.ImGui_TableFlags_BordersOuterV()
end


--- Table Flags Borders V. Wraps ImGui_TableFlags_BordersV.
-- Draw vertical borders.
-- @return number
function ImGui:table_flags_borders_v()
    return r.ImGui_TableFlags_BordersV()
end


--- Table Flags Context Menu In Body. Wraps ImGui_TableFlags_ContextMenuInBody.
-- Right-click on columns body/contents will display table context menu.    By
-- default it is available in TableHeadersRow.
-- @return number
function ImGui:table_flags_context_menu_in_body()
    return r.ImGui_TableFlags_ContextMenuInBody()
end


--- Table Flags Hideable. Wraps ImGui_TableFlags_Hideable.
-- Enable hiding/disabling columns in context menu.
-- @return number
function ImGui:table_flags_hideable()
    return r.ImGui_TableFlags_Hideable()
end


--- Table Flags Highlight Hovered Column. Wraps ImGui_TableFlags_HighlightHoveredColumn.
-- Highlight column headers when hovered (may evolve into a fuller highlight.)
-- @return number
function ImGui:table_flags_highlight_hovered_column()
    return r.ImGui_TableFlags_HighlightHoveredColumn()
end


--- Table Flags No Clip. Wraps ImGui_TableFlags_NoClip.
-- Disable clipping rectangle for every individual columns    (reduce draw command
-- count, items will be able to overflow into other columns).    Generally
-- incompatible with TableSetupScrollFreeze.
-- @return number
function ImGui:table_flags_no_clip()
    return r.ImGui_TableFlags_NoClip()
end


--- Table Flags No Host Extend X. Wraps ImGui_TableFlags_NoHostExtendX.
-- Make outer width auto-fit to columns, overriding outer_size.x value. Only
-- available when ScrollX/ScrollY are disabled and Stretch columns are not used.
-- @return number
function ImGui:table_flags_no_host_extend_x()
    return r.ImGui_TableFlags_NoHostExtendX()
end


--- Table Flags No Host Extend Y. Wraps ImGui_TableFlags_NoHostExtendY.
-- Make outer height stop exactly at outer_size.y (prevent auto-extending table
-- past the limit). Only available when ScrollX/ScrollY are disabled.    Data below
-- the limit will be clipped and not visible.
-- @return number
function ImGui:table_flags_no_host_extend_y()
    return r.ImGui_TableFlags_NoHostExtendY()
end


--- Table Flags No Keep Columns Visible. Wraps ImGui_TableFlags_NoKeepColumnsVisible.
-- Disable keeping column always minimally visible when ScrollX is off and table
-- gets too small. Not recommended if columns are resizable.
-- @return number
function ImGui:table_flags_no_keep_columns_visible()
    return r.ImGui_TableFlags_NoKeepColumnsVisible()
end


--- Table Flags No Pad Inner X. Wraps ImGui_TableFlags_NoPadInnerX.
-- Disable inner padding between columns (double inner padding if
-- TableFlags_BordersOuterV is on, single inner padding if BordersOuterV is off).
-- @return number
function ImGui:table_flags_no_pad_inner_x()
    return r.ImGui_TableFlags_NoPadInnerX()
end


--- Table Flags No Pad Outer X. Wraps ImGui_TableFlags_NoPadOuterX.
-- Default if TableFlags_BordersOuterV is off. Disable outermost padding.
-- @return number
function ImGui:table_flags_no_pad_outer_x()
    return r.ImGui_TableFlags_NoPadOuterX()
end


--- Table Flags No Saved Settings. Wraps ImGui_TableFlags_NoSavedSettings.
-- Disable persisting columns order, width and sort settings in the .ini file.
-- @return number
function ImGui:table_flags_no_saved_settings()
    return r.ImGui_TableFlags_NoSavedSettings()
end


--- Table Flags None. Wraps ImGui_TableFlags_None.
-- @return number
function ImGui:table_flags_none()
    return r.ImGui_TableFlags_None()
end


--- Table Flags Pad Outer X. Wraps ImGui_TableFlags_PadOuterX.
-- Default if TableFlags_BordersOuterV is on. Enable outermost padding.
-- Generally desirable if you have headers.
-- @return number
function ImGui:table_flags_pad_outer_x()
    return r.ImGui_TableFlags_PadOuterX()
end


--- Table Flags Precise Widths. Wraps ImGui_TableFlags_PreciseWidths.
-- Disable distributing remainder width to stretched columns (width allocation
-- on a 100-wide table with 3 columns: Without this flag: 33,33,34. With this
-- flag: 33,33,33).    With larger number of columns, resizing will appear to be
-- less smooth.
-- @return number
function ImGui:table_flags_precise_widths()
    return r.ImGui_TableFlags_PreciseWidths()
end


--- Table Flags Reorderable. Wraps ImGui_TableFlags_Reorderable.
-- Enable reordering columns in header row    (need calling TableSetupColumn +
-- TableHeadersRow to display headers).
-- @return number
function ImGui:table_flags_reorderable()
    return r.ImGui_TableFlags_Reorderable()
end


--- Table Flags Resizable. Wraps ImGui_TableFlags_Resizable.
-- Enable resizing columns.
-- @return number
function ImGui:table_flags_resizable()
    return r.ImGui_TableFlags_Resizable()
end


--- Table Flags Row Bg. Wraps ImGui_TableFlags_RowBg.
-- Set each RowBg color with Col_TableRowBg or Col_TableRowBgAlt (equivalent of
-- calling TableSetBgColor with TableBgTarget_RowBg0 on each row manually).
-- @return number
function ImGui:table_flags_row_bg()
    return r.ImGui_TableFlags_RowBg()
end


--- Table Flags Scroll X. Wraps ImGui_TableFlags_ScrollX.
-- Enable horizontal scrolling. Require 'outer_size' parameter of BeginTable to
-- specify the container size. Changes default sizing policy.    Because this
-- creates a child window, ScrollY is currently generally    recommended when using
-- ScrollX.
-- @return number
function ImGui:table_flags_scroll_x()
    return r.ImGui_TableFlags_ScrollX()
end


--- Table Flags Scroll Y. Wraps ImGui_TableFlags_ScrollY.
-- Enable vertical scrolling.    Require 'outer_size' parameter of BeginTable to
-- specify the container size.
-- @return number
function ImGui:table_flags_scroll_y()
    return r.ImGui_TableFlags_ScrollY()
end


--- Table Flags Sizing Fixed Fit. Wraps ImGui_TableFlags_SizingFixedFit.
-- Columns default to _WidthFixed or _WidthAuto (if resizable or not resizable),
-- matching contents width.
-- @return number
function ImGui:table_flags_sizing_fixed_fit()
    return r.ImGui_TableFlags_SizingFixedFit()
end


--- Table Flags Sizing Fixed Same. Wraps ImGui_TableFlags_SizingFixedSame.
-- Columns default to _WidthFixed or _WidthAuto (if resizable or not resizable),
-- matching the maximum contents width of all columns.    Implicitly enable
-- TableFlags_NoKeepColumnsVisible.
-- @return number
function ImGui:table_flags_sizing_fixed_same()
    return r.ImGui_TableFlags_SizingFixedSame()
end


--- Table Flags Sizing Stretch Prop. Wraps ImGui_TableFlags_SizingStretchProp.
-- Columns default to _WidthStretch with default weights proportional to each
-- columns contents widths.
-- @return number
function ImGui:table_flags_sizing_stretch_prop()
    return r.ImGui_TableFlags_SizingStretchProp()
end


--- Table Flags Sizing Stretch Same. Wraps ImGui_TableFlags_SizingStretchSame.
-- Columns default to _WidthStretch with default weights all equal,    unless
-- overriden by TableSetupColumn.
-- @return number
function ImGui:table_flags_sizing_stretch_same()
    return r.ImGui_TableFlags_SizingStretchSame()
end


--- Table Flags Sort Multi. Wraps ImGui_TableFlags_SortMulti.
-- Hold shift when clicking headers to sort on multiple column.
-- TableGetColumnSortSpecs may return specs where (SpecsCount > 1).
-- @return number
function ImGui:table_flags_sort_multi()
    return r.ImGui_TableFlags_SortMulti()
end


--- Table Flags Sort Tristate. Wraps ImGui_TableFlags_SortTristate.
-- Allow no sorting, disable default sorting.    TableGetColumnSortSpecs may return
-- specs where (SpecsCount == 0).
-- @return number
function ImGui:table_flags_sort_tristate()
    return r.ImGui_TableFlags_SortTristate()
end


--- Table Flags Sortable. Wraps ImGui_TableFlags_Sortable.
-- Enable sorting. Call TableNeedSort/TableGetColumnSortSpecs to obtain sort specs.
-- Also see TableFlags_SortMulti and TableFlags_SortTristate.
-- @return number
function ImGui:table_flags_sortable()
    return r.ImGui_TableFlags_Sortable()
end


--- Table Get Column Count. Wraps ImGui_TableGetColumnCount.
-- Return number of columns (value passed to BeginTable).
-- @param ctx ImGui_Context
-- @return number
function ImGui:table_get_column_count(ctx)
    return r.ImGui_TableGetColumnCount(ctx)
end


--- Table Get Column Flags. Wraps ImGui_TableGetColumnFlags.
-- Return column flags so you can query their Enabled/Visible/Sorted/Hovered status
-- flags. Pass -1 to use current column.
-- @param ctx ImGui_Context
-- @param integer column_nIn Optional
-- @return number
function ImGui:table_get_column_flags(ctx, integer)
    local integer = integer or nil
    return r.ImGui_TableGetColumnFlags(ctx, integer)
end


--- Table Get Column Index. Wraps ImGui_TableGetColumnIndex.
-- Return current column index.
-- @param ctx ImGui_Context
-- @return number
function ImGui:table_get_column_index(ctx)
    return r.ImGui_TableGetColumnIndex(ctx)
end


--- Table Get Column Name. Wraps ImGui_TableGetColumnName.
-- Return "" if column didn't have a name declared by TableSetupColumn. Pass -1 to
-- use current column.
-- @param ctx ImGui_Context
-- @param integer column_nIn Optional
-- @return string
function ImGui:table_get_column_name(ctx, integer)
    local integer = integer or nil
    return r.ImGui_TableGetColumnName(ctx, integer)
end


--- Table Get Column Sort Specs. Wraps ImGui_TableGetColumnSortSpecs.
-- Sorting specification for one column of a table. Call while incrementing 'id'
-- from 0 until false is returned.
-- @param ctx ImGui_Context
-- @param id number
-- @return column_index number
-- @return column_user_id number
-- @return sort_direction number
function ImGui:table_get_column_sort_specs(ctx, id)
    local ret_val, column_index, column_user_id, sort_direction = r.ImGui_TableGetColumnSortSpecs(ctx, id)
    if ret_val then
        return column_index, column_user_id, sort_direction
    else
        return nil
    end
end


--- Table Get Hovered Column. Wraps ImGui_TableGetHoveredColumn.
-- Returns hovered column or -1 when table is not hovered. Returns columns_count if
-- the unused space at the right of visible columns is hovered.
-- @param ctx ImGui_Context
-- @return number
function ImGui:table_get_hovered_column(ctx)
    return r.ImGui_TableGetHoveredColumn(ctx)
end


--- Table Get Row Index. Wraps ImGui_TableGetRowIndex.
-- Return current row index.
-- @param ctx ImGui_Context
-- @return number
function ImGui:table_get_row_index(ctx)
    return r.ImGui_TableGetRowIndex(ctx)
end


--- Table Header. Wraps ImGui_TableHeader.
-- Submit one header cell manually (rarely used). See TableSetupColumn.
-- @param ctx ImGui_Context
-- @param label string
function ImGui:table_header(ctx, label)
    return r.ImGui_TableHeader(ctx, label)
end


--- Table Headers Row. Wraps ImGui_TableHeadersRow.
-- Submit a row with headers cells based on data provided to TableSetupColumn +
-- submit context menu.
-- @param ctx ImGui_Context
function ImGui:table_headers_row(ctx)
    return r.ImGui_TableHeadersRow(ctx)
end


--- Table Need Sort. Wraps ImGui_TableNeedSort.
-- Return true once when sorting specs have changed since last call, or the first
-- time. 'has_specs' is false when not sorting.
-- @param ctx ImGui_Context
-- @return has_specs boolean
function ImGui:table_need_sort(ctx)
    local ret_val, has_specs = r.ImGui_TableNeedSort(ctx)
    if ret_val then
        return has_specs
    else
        return nil
    end
end


--- Table Next Column. Wraps ImGui_TableNextColumn.
-- Append into the next column (or first column of next row if currently in last
-- column). Return true when column is visible.
-- @param ctx ImGui_Context
-- @return boolean
function ImGui:table_next_column(ctx)
    return r.ImGui_TableNextColumn(ctx)
end


--- Table Next Row. Wraps ImGui_TableNextRow.
-- Append into the first cell of a new row.
-- @param ctx ImGui_Context
-- @param integer row_flagsIn Optional
-- @param number min_row_heightIn Optional
function ImGui:table_next_row(ctx, integer, number)
    local integer = integer or nil
    local number = number or nil
    return r.ImGui_TableNextRow(ctx, integer, number)
end


--- Table Row Flags Headers. Wraps ImGui_TableRowFlags_Headers.
-- Identify header row (set default background color + width of its contents
-- accounted different for auto column width).
-- @return number
function ImGui:table_row_flags_headers()
    return r.ImGui_TableRowFlags_Headers()
end


--- Table Row Flags None. Wraps ImGui_TableRowFlags_None.
-- For TableNextRow.
-- @return number
function ImGui:table_row_flags_none()
    return r.ImGui_TableRowFlags_None()
end


--- Table Set Bg Color. Wraps ImGui_TableSetBgColor.
-- Change the color of a cell, row, or column. See TableBgTarget_* flags for
-- details.
-- @param ctx ImGui_Context
-- @param target number
-- @param color_rgba number
-- @param integer column_nIn Optional
function ImGui:table_set_bg_color(ctx, target, color_rgba, integer)
    local integer = integer or nil
    return r.ImGui_TableSetBgColor(ctx, target, color_rgba, integer)
end


--- Table Set Column Enabled. Wraps ImGui_TableSetColumnEnabled.
-- Change user-accessible enabled/disabled state of a column, set to false to hide
-- the column. Note that end-user can use the context menu to change this
-- themselves (right-click in headers, or right-click in columns body with
-- TableFlags_ContextMenuInBody).
-- @param ctx ImGui_Context
-- @param column_n number
-- @param v boolean
function ImGui:table_set_column_enabled(ctx, column_n, v)
    return r.ImGui_TableSetColumnEnabled(ctx, column_n, v)
end


--- Table Set Column Index. Wraps ImGui_TableSetColumnIndex.
-- Append into the specified column. Return true when column is visible.
-- @param ctx ImGui_Context
-- @param column_n number
-- @return boolean
function ImGui:table_set_column_index(ctx, column_n)
    return r.ImGui_TableSetColumnIndex(ctx, column_n)
end


--- Table Setup Column. Wraps ImGui_TableSetupColumn.
-- Use to specify label, resizing policy, default width/weight, id, various other
-- flags etc.
-- @param ctx ImGui_Context
-- @param label string
-- @param integer flagsIn Optional
-- @param number init_width_or_weightIn Optional
-- @param integer user_idIn Optional
function ImGui:table_setup_column(ctx, label, integer, number, integer)
    local integer = integer or nil
    local number = number or nil
    return r.ImGui_TableSetupColumn(ctx, label, integer, number, integer)
end


--- Table Setup Scroll Freeze. Wraps ImGui_TableSetupScrollFreeze.
-- Lock columns/rows so they stay visible when scrolled.
-- @param ctx ImGui_Context
-- @param cols number
-- @param rows number
function ImGui:table_setup_scroll_freeze(ctx, cols, rows)
    return r.ImGui_TableSetupScrollFreeze(ctx, cols, rows)
end


--- Text. Wraps ImGui_Text.
-- @param ctx ImGui_Context
-- @param text string
function ImGui:text(ctx, text)
    return r.ImGui_Text(ctx, text)
end


--- Text Colored. Wraps ImGui_TextColored.
-- Shortcut for PushStyleColor(Col_Text, color); Text(text); PopStyleColor();
-- @param ctx ImGui_Context
-- @param col_rgba number
-- @param text string
function ImGui:text_colored(ctx, col_rgba, text)
    return r.ImGui_TextColored(ctx, col_rgba, text)
end


--- Text Disabled. Wraps ImGui_TextDisabled.
-- @param ctx ImGui_Context
-- @param text string
function ImGui:text_disabled(ctx, text)
    return r.ImGui_TextDisabled(ctx, text)
end


--- Text Filter Clear. Wraps ImGui_TextFilter_Clear.
-- @param filter ImGui_TextFilter
function ImGui:text_filter_clear(filter)
    return r.ImGui_TextFilter_Clear(filter)
end


--- Text Filter Draw. Wraps ImGui_TextFilter_Draw.
-- Helper calling InputText+TextFilter_Set
-- @param filter ImGui_TextFilter
-- @param ctx ImGui_Context
-- @param string labelIn Optional
-- @param number widthIn Optional
-- @return boolean
function ImGui:text_filter_draw(filter, ctx, string, number)
    local string = string or nil
    local number = number or nil
    return r.ImGui_TextFilter_Draw(filter, ctx, string, number)
end


--- Text Filter Get. Wraps ImGui_TextFilter_Get.
-- @param filter ImGui_TextFilter
-- @return string
function ImGui:text_filter_get(filter)
    return r.ImGui_TextFilter_Get(filter)
end


--- Text Filter Is Active. Wraps ImGui_TextFilter_IsActive.
-- @param filter ImGui_TextFilter
-- @return boolean
function ImGui:text_filter_is_active(filter)
    return r.ImGui_TextFilter_IsActive(filter)
end


--- Text Filter Pass Filter. Wraps ImGui_TextFilter_PassFilter.
-- @param filter ImGui_TextFilter
-- @param text string
-- @return boolean
function ImGui:text_filter_pass_filter(filter, text)
    return r.ImGui_TextFilter_PassFilter(filter, text)
end


--- Text Filter Set. Wraps ImGui_TextFilter_Set.
-- @param filter ImGui_TextFilter
-- @param filter_text string
function ImGui:text_filter_set(filter, filter_text)
    return r.ImGui_TextFilter_Set(filter, filter_text)
end


--- Text Wrapped. Wraps ImGui_TextWrapped.
-- Shortcut for PushTextWrapPos(0.0); Text(text); PopTextWrapPos();. Note that this
-- won't work on an auto-resizing window if there's no other widgets to extend the
-- window width, yoy may need to set a size using SetNextWindowSize.
-- @param ctx ImGui_Context
-- @param text string
function ImGui:text_wrapped(ctx, text)
    return r.ImGui_TextWrapped(ctx, text)
end


--- Tree Node. Wraps ImGui_TreeNode.
-- TreeNode functions return true when the node is open, in which case you need to
-- also call TreePop when you are finished displaying the tree node contents.
-- @param ctx ImGui_Context
-- @param label string
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:tree_node(ctx, label, integer)
    local integer = integer or nil
    return r.ImGui_TreeNode(ctx, label, integer)
end


--- Tree Node Ex. Wraps ImGui_TreeNodeEx.
-- Helper variation to easily decorelate the id from the displayed string. Read the
-- [FAQ](https://dearimgui.com/faq) about why and how to use ID. To align arbitrary
-- text at the same level as a TreeNode you can use Bullet.
-- @param ctx ImGui_Context
-- @param str_id string
-- @param label string
-- @param integer flagsIn Optional
-- @return boolean
function ImGui:tree_node_ex(ctx, str_id, label, integer)
    local integer = integer or nil
    return r.ImGui_TreeNodeEx(ctx, str_id, label, integer)
end


--- Tree Node Flags Allow Overlap. Wraps ImGui_TreeNodeFlags_AllowOverlap.
-- Hit testing to allow subsequent widgets to overlap this one.
-- @return number
function ImGui:tree_node_flags_allow_overlap()
    return r.ImGui_TreeNodeFlags_AllowOverlap()
end


--- Tree Node Flags Bullet. Wraps ImGui_TreeNodeFlags_Bullet.
-- Display a bullet instead of arrow. IMPORTANT: node can still be marked
-- open/close if you don't set the _Leaf flag!
-- @return number
function ImGui:tree_node_flags_bullet()
    return r.ImGui_TreeNodeFlags_Bullet()
end


--- Tree Node Flags Collapsing Header. Wraps ImGui_TreeNodeFlags_CollapsingHeader.
-- TreeNodeFlags_Framed | TreeNodeFlags_NoTreePushOnOpen |
-- TreeNodeFlags_NoAutoOpenOnLog
-- @return number
function ImGui:tree_node_flags_collapsing_header()
    return r.ImGui_TreeNodeFlags_CollapsingHeader()
end


--- Tree Node Flags Default Open. Wraps ImGui_TreeNodeFlags_DefaultOpen.
-- Default node to be open.
-- @return number
function ImGui:tree_node_flags_default_open()
    return r.ImGui_TreeNodeFlags_DefaultOpen()
end


--- Tree Node Flags Frame Padding. Wraps ImGui_TreeNodeFlags_FramePadding.
-- Use FramePadding (even for an unframed text node) to vertically align text
-- baseline to regular widget height.    Equivalent to calling
-- AlignTextToFramePadding before the node.
-- @return number
function ImGui:tree_node_flags_frame_padding()
    return r.ImGui_TreeNodeFlags_FramePadding()
end


--- Tree Node Flags Framed. Wraps ImGui_TreeNodeFlags_Framed.
-- Draw frame with background (e.g. for CollapsingHeader).
-- @return number
function ImGui:tree_node_flags_framed()
    return r.ImGui_TreeNodeFlags_Framed()
end


--- Tree Node Flags Leaf. Wraps ImGui_TreeNodeFlags_Leaf.
-- No collapsing, no arrow (use as a convenience for leaf nodes).
-- @return number
function ImGui:tree_node_flags_leaf()
    return r.ImGui_TreeNodeFlags_Leaf()
end


--- Tree Node Flags No Auto Open On Log. Wraps ImGui_TreeNodeFlags_NoAutoOpenOnLog.
-- Don't automatically and temporarily open node when Logging is active    (by
-- default logging will automatically open tree nodes).
-- @return number
function ImGui:tree_node_flags_no_auto_open_on_log()
    return r.ImGui_TreeNodeFlags_NoAutoOpenOnLog()
end


--- Tree Node Flags No Tree Push On Open. Wraps ImGui_TreeNodeFlags_NoTreePushOnOpen.
-- Don't do a TreePush when open (e.g. for CollapsingHeader)    = no extra indent
-- nor pushing on ID stack.
-- @return number
function ImGui:tree_node_flags_no_tree_push_on_open()
    return r.ImGui_TreeNodeFlags_NoTreePushOnOpen()
end


--- Tree Node Flags None. Wraps ImGui_TreeNodeFlags_None.
-- @return number
function ImGui:tree_node_flags_none()
    return r.ImGui_TreeNodeFlags_None()
end


--- Tree Node Flags Open On Arrow. Wraps ImGui_TreeNodeFlags_OpenOnArrow.
-- Only open when clicking on the arrow part.    If TreeNodeFlags_OpenOnDoubleClick
-- is also set, single-click arrow or    double-click all box to open.
-- @return number
function ImGui:tree_node_flags_open_on_arrow()
    return r.ImGui_TreeNodeFlags_OpenOnArrow()
end


--- Tree Node Flags Open On Double Click. Wraps ImGui_TreeNodeFlags_OpenOnDoubleClick.
-- Need double-click to open node.
-- @return number
function ImGui:tree_node_flags_open_on_double_click()
    return r.ImGui_TreeNodeFlags_OpenOnDoubleClick()
end


--- Tree Node Flags Selected. Wraps ImGui_TreeNodeFlags_Selected.
-- Draw as selected.
-- @return number
function ImGui:tree_node_flags_selected()
    return r.ImGui_TreeNodeFlags_Selected()
end


--- Tree Node Flags Span All Columns. Wraps ImGui_TreeNodeFlags_SpanAllColumns.
-- Frame will span all columns of its container table (text will still fit in
-- current column).
-- @return number
function ImGui:tree_node_flags_span_all_columns()
    return r.ImGui_TreeNodeFlags_SpanAllColumns()
end


--- Tree Node Flags Span Avail Width. Wraps ImGui_TreeNodeFlags_SpanAvailWidth.
-- Extend hit box to the right-most edge, even if not framed.    This is not the
-- default in order to allow adding other items on the same line.    In the future
-- we may refactor the hit system to be front-to-back,    allowing natural overlaps
-- and then this can become the default.
-- @return number
function ImGui:tree_node_flags_span_avail_width()
    return r.ImGui_TreeNodeFlags_SpanAvailWidth()
end


--- Tree Node Flags Span Full Width. Wraps ImGui_TreeNodeFlags_SpanFullWidth.
-- Extend hit box to the left-most and right-most edges (bypass the indented area).
-- @return number
function ImGui:tree_node_flags_span_full_width()
    return r.ImGui_TreeNodeFlags_SpanFullWidth()
end


--- Tree Node Flags Span Text Width. Wraps ImGui_TreeNodeFlags_SpanTextWidth.
-- Narrow hit box + narrow hovering highlight, will only cover the label text.
-- @return number
function ImGui:tree_node_flags_span_text_width()
    return r.ImGui_TreeNodeFlags_SpanTextWidth()
end


--- Tree Pop. Wraps ImGui_TreePop.
-- Unindent()+PopID()
-- @param ctx ImGui_Context
function ImGui:tree_pop(ctx)
    return r.ImGui_TreePop(ctx)
end


--- Tree Push. Wraps ImGui_TreePush.
-- Indent()+PushID(). Already called by TreeNode when returning true, but you can
-- call TreePush/TreePop yourself if desired.
-- @param ctx ImGui_Context
-- @param str_id string
function ImGui:tree_push(ctx, str_id)
    return r.ImGui_TreePush(ctx, str_id)
end


--- Unindent. Wraps ImGui_Unindent.
-- Move content position back to the left, by 'indent_w', or StyleVar_IndentSpacing
-- if 'indent_w' <= 0
-- @param ctx ImGui_Context
-- @param number indent_wIn Optional
function ImGui:unindent(ctx, number)
    local number = number or nil
    return r.ImGui_Unindent(ctx, number)
end


--- V Slider Double. Wraps ImGui_VSliderDouble.
-- @param ctx ImGui_Context
-- @param label string
-- @param size_w number
-- @param size_h number
-- @param v number
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v number
function ImGui:v_slider_double(ctx, label, size_w, size_h, v, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v = r.ImGui_VSliderDouble(ctx, label, size_w, size_h, v, v_min, v_max, string, integer)
    if ret_val then
        return v
    else
        return nil
    end
end


--- V Slider Int. Wraps ImGui_VSliderInt.
-- @param ctx ImGui_Context
-- @param label string
-- @param size_w number
-- @param size_h number
-- @param v number
-- @param v_min number
-- @param v_max number
-- @param string formatIn Optional
-- @param integer flagsIn Optional
-- @return v number
function ImGui:v_slider_int(ctx, label, size_w, size_h, v, v_min, v_max, string, integer)
    local string = string or nil
    local integer = integer or nil
    local ret_val, v = r.ImGui_VSliderInt(ctx, label, size_w, size_h, v, v_min, v_max, string, integer)
    if ret_val then
        return v
    else
        return nil
    end
end


--- Validate Ptr. Wraps ImGui_ValidatePtr.
-- Return whether the given pointer is a valid instance of one of the following
-- types (indentation represents inheritance):
-- @param pointer identifier
-- @param type string
-- @return boolean
function ImGui:validate_ptr(pointer, type)
    return r.ImGui_ValidatePtr(pointer, type)
end


--- Viewport Get Center. Wraps ImGui_Viewport_GetCenter.
-- Center of the viewport.
-- @param viewport ImGui_Viewport
-- @return x number
-- @return y number
function ImGui:viewport_get_center(viewport)
    return r.ImGui_Viewport_GetCenter(viewport)
end


--- Viewport Get Pos. Wraps ImGui_Viewport_GetPos.
-- Main Area: Position of the viewport
-- @param viewport ImGui_Viewport
-- @return x number
-- @return y number
function ImGui:viewport_get_pos(viewport)
    return r.ImGui_Viewport_GetPos(viewport)
end


--- Viewport Get Size. Wraps ImGui_Viewport_GetSize.
-- Main Area: Size of the viewport.
-- @param viewport ImGui_Viewport
-- @return w number
-- @return h number
function ImGui:viewport_get_size(viewport)
    return r.ImGui_Viewport_GetSize(viewport)
end


--- Viewport Get Work Center. Wraps ImGui_Viewport_GetWorkCenter.
-- Center of the viewport's work area.
-- @param viewport ImGui_Viewport
-- @return x number
-- @return y number
function ImGui:viewport_get_work_center(viewport)
    return r.ImGui_Viewport_GetWorkCenter(viewport)
end


--- Viewport Get Work Pos. Wraps ImGui_Viewport_GetWorkPos.
-- >= Viewport_GetPos
-- @param viewport ImGui_Viewport
-- @return x number
-- @return y number
function ImGui:viewport_get_work_pos(viewport)
    return r.ImGui_Viewport_GetWorkPos(viewport)
end


--- Viewport Get Work Size. Wraps ImGui_Viewport_GetWorkSize.
-- <= Viewport_GetSize
-- @param viewport ImGui_Viewport
-- @return w number
-- @return h number
function ImGui:viewport_get_work_size(viewport)
    return r.ImGui_Viewport_GetWorkSize(viewport)
end


--- Window Flags Always Auto Resize. Wraps ImGui_WindowFlags_AlwaysAutoResize.
-- Resize every window to its content every frame.
-- @return number
function ImGui:window_flags_always_auto_resize()
    return r.ImGui_WindowFlags_AlwaysAutoResize()
end


--- Window Flags Always Horizontal Scrollbar. Wraps ImGui_WindowFlags_AlwaysHorizontalScrollbar.
-- Always show horizontal scrollbar (even if ContentSize.x < Size.x).
-- @return number
function ImGui:window_flags_always_horizontal_scrollbar()
    return r.ImGui_WindowFlags_AlwaysHorizontalScrollbar()
end


--- Window Flags Always Vertical Scrollbar. Wraps ImGui_WindowFlags_AlwaysVerticalScrollbar.
-- Always show vertical scrollbar (even if ContentSize.y < Size.y).
-- @return number
function ImGui:window_flags_always_vertical_scrollbar()
    return r.ImGui_WindowFlags_AlwaysVerticalScrollbar()
end


--- Window Flags Horizontal Scrollbar. Wraps ImGui_WindowFlags_HorizontalScrollbar.
-- Allow horizontal scrollbar to appear (off by default).    You may use
-- SetNextWindowContentSize(width, 0.0) prior to calling Begin() to    specify
-- width. Read code in the demo's "Horizontal Scrolling" section.
-- @return number
function ImGui:window_flags_horizontal_scrollbar()
    return r.ImGui_WindowFlags_HorizontalScrollbar()
end


--- Window Flags Menu Bar. Wraps ImGui_WindowFlags_MenuBar.
-- Has a menu-bar.
-- @return number
function ImGui:window_flags_menu_bar()
    return r.ImGui_WindowFlags_MenuBar()
end


--- Window Flags No Background. Wraps ImGui_WindowFlags_NoBackground.
-- Disable drawing background color (WindowBg, etc.) and outside border.    Similar
-- as using SetNextWindowBgAlpha(0.0).
-- @return number
function ImGui:window_flags_no_background()
    return r.ImGui_WindowFlags_NoBackground()
end


--- Window Flags No Collapse. Wraps ImGui_WindowFlags_NoCollapse.
-- Disable user collapsing window by double-clicking on it.    Also referred to as
-- Window Menu Button (e.g. within a docking node).
-- @return number
function ImGui:window_flags_no_collapse()
    return r.ImGui_WindowFlags_NoCollapse()
end


--- Window Flags No Decoration. Wraps ImGui_WindowFlags_NoDecoration.
-- WindowFlags_NoTitleBar | WindowFlags_NoResize | WindowFlags_NoScrollbar |
-- WindowFlags_NoCollapse
-- @return number
function ImGui:window_flags_no_decoration()
    return r.ImGui_WindowFlags_NoDecoration()
end


--- Window Flags No Docking. Wraps ImGui_WindowFlags_NoDocking.
-- Disable docking of this window.
-- @return number
function ImGui:window_flags_no_docking()
    return r.ImGui_WindowFlags_NoDocking()
end


--- Window Flags No Focus On Appearing. Wraps ImGui_WindowFlags_NoFocusOnAppearing.
-- Disable taking focus when transitioning from hidden to visible state.
-- @return number
function ImGui:window_flags_no_focus_on_appearing()
    return r.ImGui_WindowFlags_NoFocusOnAppearing()
end


--- Window Flags No Inputs. Wraps ImGui_WindowFlags_NoInputs.
-- WindowFlags_NoMouseInputs | WindowFlags_NoNavInputs | WindowFlags_NoNavFocus
-- @return number
function ImGui:window_flags_no_inputs()
    return r.ImGui_WindowFlags_NoInputs()
end


--- Window Flags No Mouse Inputs. Wraps ImGui_WindowFlags_NoMouseInputs.
-- Disable catching mouse, hovering test with pass through.
-- @return number
function ImGui:window_flags_no_mouse_inputs()
    return r.ImGui_WindowFlags_NoMouseInputs()
end


--- Window Flags No Move. Wraps ImGui_WindowFlags_NoMove.
-- Disable user moving the window.
-- @return number
function ImGui:window_flags_no_move()
    return r.ImGui_WindowFlags_NoMove()
end


--- Window Flags No Nav. Wraps ImGui_WindowFlags_NoNav.
-- WindowFlags_NoNavInputs | WindowFlags_NoNavFocus
-- @return number
function ImGui:window_flags_no_nav()
    return r.ImGui_WindowFlags_NoNav()
end


--- Window Flags No Nav Focus. Wraps ImGui_WindowFlags_NoNavFocus.
-- No focusing toward this window with gamepad/keyboard navigation    (e.g. skipped
-- by CTRL+TAB).
-- @return number
function ImGui:window_flags_no_nav_focus()
    return r.ImGui_WindowFlags_NoNavFocus()
end


--- Window Flags No Nav Inputs. Wraps ImGui_WindowFlags_NoNavInputs.
-- No gamepad/keyboard navigation within the window.
-- @return number
function ImGui:window_flags_no_nav_inputs()
    return r.ImGui_WindowFlags_NoNavInputs()
end


--- Window Flags No Resize. Wraps ImGui_WindowFlags_NoResize.
-- Disable user resizing with the lower-right grip.
-- @return number
function ImGui:window_flags_no_resize()
    return r.ImGui_WindowFlags_NoResize()
end


--- Window Flags No Saved Settings. Wraps ImGui_WindowFlags_NoSavedSettings.
-- Never load/save settings in .ini file.
-- @return number
function ImGui:window_flags_no_saved_settings()
    return r.ImGui_WindowFlags_NoSavedSettings()
end


--- Window Flags No Scroll With Mouse. Wraps ImGui_WindowFlags_NoScrollWithMouse.
-- Disable user vertically scrolling with mouse wheel.    On child window, mouse
-- wheel will be forwarded to the parent unless    NoScrollbar is also set.
-- @return number
function ImGui:window_flags_no_scroll_with_mouse()
    return r.ImGui_WindowFlags_NoScrollWithMouse()
end


--- Window Flags No Scrollbar. Wraps ImGui_WindowFlags_NoScrollbar.
-- Disable scrollbars (window can still scroll with mouse or programmatically).
-- @return number
function ImGui:window_flags_no_scrollbar()
    return r.ImGui_WindowFlags_NoScrollbar()
end


--- Window Flags No Title Bar. Wraps ImGui_WindowFlags_NoTitleBar.
-- Disable title-bar.
-- @return number
function ImGui:window_flags_no_title_bar()
    return r.ImGui_WindowFlags_NoTitleBar()
end


--- Window Flags None. Wraps ImGui_WindowFlags_None.
-- Default flag.
-- @return number
function ImGui:window_flags_none()
    return r.ImGui_WindowFlags_None()
end


--- Window Flags Top Most. Wraps ImGui_WindowFlags_TopMost.
-- Show the window above all non-topmost windows.
-- @return number
function ImGui:window_flags_top_most()
    return r.ImGui_WindowFlags_TopMost()
end


--- Window Flags Unsaved Document. Wraps ImGui_WindowFlags_UnsavedDocument.
-- Display a dot next to the title. When used in a tab/docking context,    tab is
-- selected when clicking the X + closure is not assumed    (will wait for user to
-- stop submitting the tab).    Otherwise closure is assumed when pressing the X,
-- so if you keep submitting the tab may reappear at end of tab bar.
-- @return number
function ImGui:window_flags_unsaved_document()
    return r.ImGui_WindowFlags_UnsavedDocument()
end


--- Getapi. Wraps ImGui__getapi.
-- Internal use only.
-- @param version string
-- @param symbol_name string
-- @return identifier
function ImGui:getapi(version, symbol_name)
    return r.ImGui__getapi(version, symbol_name)
end


--- Geterr. Wraps ImGui__geterr.
-- Internal use only.
-- @return string
function ImGui:geterr()
    return r.ImGui__geterr()
end


--- Init. Wraps ImGui__init.
-- Internal use only.
-- @param buf string
-- @return buf string
function ImGui:init(buf)
    return r.ImGui__init(buf)
end


--- Setshim. Wraps ImGui__setshim.
-- Internal use only.
-- @param version string
-- @param symbol_name string
function ImGui:setshim(version, symbol_name)
    return r.ImGui__setshim(version, symbol_name)
end


--- Shim. Wraps ImGui__shim.
-- Internal use only.
function ImGui:shim()
    return r.ImGui__shim()
end

return ImGui
