local helpers = require('ReaWrap.models.helpers')

local r = reaper

ImGui = {}

-- New instance of ImGui class
---@param context_label string
function ImGui:new(context_label)
    local o = {
        ctx = self:create_context(context_label),
        end_ctx = false
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function ImGui:log(...)
    logger = helpers.log_func('ImGui')
    logger(...)
end

function ImGui:done()
    self.end_ctx = true
end

function ImGui:is_done()
    return self.end_ctx
end

function ImGui:loop(func, label)
    function loop()
        local window = self:window_context(label)
        local open = window(func)
        if open and not self:is_done() then
            r.defer(loop)
        else
            self:destroy_context()
        end
    end
    return loop
end

--[[
    Returns a closure that takes the following arguments:
    a function, `func`, and a variable number of arguments to `func`.
--]]
-- The first argument of `func` is ImGui ctx
---@param label string
---@param width number
---@param height number
-- return function
function ImGui:window_context(label)
    local visible, open = self:begin_window(label)
    return function(func, ...)
        if visible then
            func(self.ctx, ...)
            self:end_window()
        end
        return open
    end
end

-- Returns a n arguments function that will be called inside a list box
---@param label string
---@param width number
---@param height number
-- return function
function ImGui:list_box_context(label, width, height)
    if self:begin_list_box(label, width, height) then
        return function(func, ...)
            func(...)
            self:end_list_box()
        end
    end
end

-- Returns a n arguments function that will be called inside a list box
---@param label string
---@param flag number
---@param func function
function ImGui:tree_node_context(label, flag, func, ...)
    if self:tree_node(label, flag) then
        func(...)
        self:tree_pop()
    end
end

-- Wrapped ReaScript functions
--------------------------------------------------------------------------------

-- Default values: flags = ImGui_DragDropFlags_None
---@param type string
---@param payload string
---@param flags number
---@return string 
function ImGui:accept_drag_drop_payload(type, payload, flags)
    local retval, payload_ = r.ImGui_AcceptDragDropPayload(self.ctx, type, payload, flags)
    if retval then
        return payload_
    end
end

-- Default values: flags = ImGui_DragDropFlags_None
---@param count number
---@param flags number
---@return number 
function ImGui:accept_drag_drop_payload_files(count, flags)
    local retval, count_ = r.ImGui_AcceptDragDropPayloadFiles(self.ctx, count, flags)
    if retval then
        return count_
    end
end

-- Default values: flags = ImGui_DragDropFlags_None
---@param rgb number
---@param flags number
---@return number 
function ImGui:accept_drag_drop_payload_rgb(rgb, flags)
    local retval, rgba_ = r.ImGui_AcceptDragDropPayloadRGB(self.ctx, rgb, flags)
    if retval then
        return rgba_
    end
end

-- Default values: flags = ImGui_DragDropFlags_None
---@param rgba number
---@param flags number
---@return number
function ImGui:accept_drag_drop_payload_rgba(rgba, flags)
    local retval, rgba_ = r.ImGui_AcceptDragDropPayloadRGB(self.ctx, rgba, flags)
    if retval then
        return rgba_
    end
end

-- Vertically align upcoming text baseline to FramePadding.y so that it will align properly to regularly framed items (call if you have text on a line before a framed item)
function ImGui:align_text_to_frame_padding()
    r.ImGui_AlignTextToFramePadding(self.ctx)
end

-- Square button with an arrow shape
---@param str_id string
---@param dir number
---@return boolean 
function ImGui:arrow_button(str_id, dir)
    return r.ImGui_ArrowButton(self.ctx, str_id, dir)
end

-- Enable a font for use in the given context. Fonts must be attached as soon as possible after creating the context or on a new defer cycle.
---@param font ImGui_Font
---@param retval ReaType
function ImGui:attach_font(font, retval)
    return r.ImGui_AttachFont(self.ctx, font, retval)
end


--[[
    Push window to the stack and start appending to it.
    Passing true to 'p_open' shows a window-closing widget in the upper-right corner of the window,
    which clicking will set the boolean to false when returned.
    You may append multiple times to the same window during the same frame
    by calling Begin()/End() pairs multiple times.
    Some information such as 'flags' or 'open' will only be considered
    by the first call to Begin().
    Begin() return false to indicate the window is collapsed or fully clipped,
    so you may early out and omit submitting anything to the window.
    Note that the bottom of window stack always contains a window called "Debug".

    @label string : label for the window
    @p_open boolean : shows a window-closing widget in the upper-right corner of the window
    #return  --boolean : whether window is visible
    #return  --boolean : whether window is open
--]]
function ImGui:begin_window(label)
    return r.ImGui_Begin(self.ctx, label, true)
end

-- Pop window from the stack.
function ImGui:end_window()
    return r.ImGui_End(self.ctx)
end

-- Default values: size_w = 0.0, size_h = 0.0, border = false, flags = ImGui_WindowFlags_None
---@param str_id string
---@param width number
---@param height number
---@param border_in boolean
---@param flags number
---@return boolean 
function ImGui:begin_child(str_id, width, height, border_in, flags)
    return r.ImGui_BeginChild(self.ctx, str_id, width, height, border_in, flags)
end

function ImGui:end_child()
    return r.ImGui_EndChild(self.ctx)
end

-- Default values: flags = ImGui_WindowFlags_None
---@param str_id string
---@param size_w number
---@param size_h number
---@param flags number
---@return boolean 
function ImGui:begin_child_frame(str_id, size_w, size_h, flags)
    return r.ImGui_BeginChildFrame(self.ctx, str_id, size_w, size_h, flags)
end

function ImGui:end_child_frame()
    return r.ImGui_EndChildFrame(self.ctx)
end

-- Default values: flags = ImGui_ComboFlags_None
---@param label string
---@param preview_value string
---@param flags number
---@return boolean 
function ImGui:begin_combo(label, preview_value, flags)
    return r.ImGui_BeginCombo(self.ctx, label, preview_value, flags)
end

-- Only call EndCombo() if BeginCombo() returns true!
function ImGui:end_combo()
    return r.ImGui_EndCombo(self.ctx)
end

-- Default values: flags = ImGui_DragDropFlags_None
---@param flags number
---@return boolean 
function ImGui:begin_drag_drop_source(flags)
    return r.ImGui_BeginDragDropSource(self.ctx, flags)
end

-- Only call EndDragDropSource() if BeginDragDropSource() returns true!
function ImGui:end_drag_drop_source()
    return r.ImGui_EndDragDropSource(self.ctx)
end

-- Call after submitting an item that may receive a payload. If this returns true, you can call AcceptDragDropPayload() + EndDragDropTarget()
---@return boolean 
function ImGui:begin_drag_drop_target()
    return r.ImGui_BeginDragDropTarget(self.ctx)
end

-- Only call EndDragDropTarget() if BeginDragDropTarget() returns true!
function ImGui:end_drag_drop_target()
    return r.ImGui_EndDragDropTarget(self.ctx)
end

-- Lock horizontal starting position.
function ImGui:begin_group()
    return r.ImGui_BeginGroup(self.ctx)
end

function ImGui:end_group()
    return r.ImGui_EndGroup(self.ctx)
end

---@param label string
---@param width number
---@param height number
---@return boolean 
function ImGui:begin_list_box(label, width, height)
    return r.ImGui_BeginListBox(self.ctx, label, width, height)
end

function ImGui:end_list_box()
    return r.ImGui_EndListBox(self.ctx)
end

-- Default values: enabled = true
---@param label string
---@param enabled_in boolean
---@return boolean 
function ImGui:begin_menu(label, enabled_in)
    return r.ImGui_BeginMenu(self.ctx, label, enabled_in)
end

-- Only call EndMenu() if BeginMenu() returns true! See ImGui_BeginMenu.
function ImGui:end_menu()
    return r.ImGui_EndMenu(self.ctx)
end

-- Append to menu-bar of current window (requires ImGui_WindowFlags_MenuBar flag set on parent window). See ImGui_EndMenuBar.
---@return boolean 
function ImGui:begin_menu_bar()
    return r.ImGui_BeginMenuBar(self.ctx)
end

-- Only call EndMenuBar() if BeginMenuBar() returns true! See ImGui_BeginMenuBar.
function ImGui:end_menu_bar()
    return r.ImGui_EndMenuBar(self.ctx)
end


-- Default values: flags = ImGui_WindowFlags_None
---@param str_id string
---@param flags number
---@return boolean 
function ImGui:begin_popup(str_id, flags)
    return r.ImGui_BeginPopup(self.ctx, str_id, flags)
end

-- only call EndPopup() if BeginPopupXXX() returns true!
function ImGui:end_popup()
    return r.ImGui_EndPopup(self.ctx)
end

-- Default values: str_id = nil, popup_flags = ImGui_PopupFlags_MouseButtonRight
---@param str_id_in string
---@param popup_flags number
---@return boolean 
function ImGui:begin_popup_context_item(str_id_in, popup_flags)
    return r.ImGui_BeginPopupContextItem(self.ctx, str_id_in, popup_flags)
end

-- Default values: str_id = nil, popup_flags = ImGui_PopupFlags_MouseButtonRight
---@param str_id_in string
---@param popup_flags number
---@return boolean 
function ImGui:begin_popup_context_window(str_id_in, popup_flags)
    return r.ImGui_BeginPopupContextWindow(self.ctx, str_id_in, popup_flags)
end

-- Default values: flags = ImGui_WindowFlags_None
---@param name string
---@param p_open boolean
---@param flags number
---@return boolean 
function ImGui:begin_popup_modal(name, p_open, flags)
    local retval, p_open_ = r.ImGui_BeginPopupModal(self.ctx, name, p_open, flags)
    if retval then
        return p_open_
    end
end

-- Default values: flags = ImGui_TabBarFlags_None
---@param str_id string
---@param flags number
---@return boolean 
function ImGui:begin_tab_bar(str_id, flags)
    return r.ImGui_BeginTabBar(self.ctx, str_id, flags)
end

-- Only call EndTabBar() if BeginTabBar() returns true!
function ImGui:end_tab_bar()
    return r.ImGui_EndTabBar(self.ctx)
end

-- Default values: flags = ImGui_TabItemFlags_None
---@param label string
---@param p_open boolean
---@param flags number
---@return boolean 
function ImGui:begin_tab_item(label, p_open, flags)
    local retval, p_open_ = r.ImGui_BeginTabItem(self.ctx, label, p_open, flags)
    if retval then
        return p_open_
    end
end

-- Only call EndTabItem() if BeginTabItem() returns true!
function ImGui:end_tab_item()
    return r.ImGui_EndTabItem(self.ctx)
end

-- Default values: flags = ImGui_TableFlags_None, outer_size_w = 0.0, outer_size_h = 0.0, inner_width = 0.0
---@param str_id string
---@param column number
---@param flags number
---@param outer_width number
---@param outer_height number
---@param inner_width_in number
---@return boolean 
function ImGui:begin_table(str_id, column, flags, outer_width, outer_height, inner_width_in)
    return r.ImGui_BeginTable(self.ctx, str_id, column, flags, outer_width, outer_height, inner_width_in)
end

-- Only call EndTable() if BeginTable() returns true!
function ImGui:end_table()
    return r.ImGui_EndTable(self.ctx)
end

-- Begin/append a tooltip window. to create full-featured tooltip (with any kind of items).
function ImGui:begin_tooltip()
    return r.ImGui_BeginTooltip(self.ctx)
end

function ImGui:end_tooltip()
    return r.ImGui_EndTooltip(self.ctx)
end

-- Draw a small circle + keep the cursor on the same line. advance cursor x position by GetTreeNodeToLabelSpacing(), same distance that TreeNode() uses.
function ImGui:bullet()
    return r.ImGui_Bullet(self.ctx)
end

-- Shortcut for Bullet()+Text()
---@param text string
function ImGui:bullet_text(text)
    return r.ImGui_BulletText(self.ctx, text)
end

-- Default values: size_w = 0.0, size_h = 0.0
---@param label string
---@param width number
---@param height number
---@return boolean 
function ImGui:button(label, width, height)
    return r.ImGui_Button(self.ctx, label, width, height)
end

-- React on left mouse button (default)
---@return number
function ImGui:button_flags_mouse_button_left()
    return r.ImGui_ButtonFlags_MouseButtonLeft(self.ctx)
end

-- React on center mouse button
---@return number
function ImGui:button_flags_mouse_button_middle()
    return r.ImGui_ButtonFlags_MouseButtonMiddle(self.ctx)
end

-- React on right mouse button
---@return number
function ImGui:button_flags_mouse_button_right()
    return r.ImGui_ButtonFlags_MouseButtonRight(self.ctx)
end

-- Flags: for InvisibleButton()
---@return number
function ImGui:button_flags_none()
    return r.ImGui_ButtonFlags_None(self.ctx)
end

-- Width of item given pushed settings and current cursor position. NOT necessarily the width of last item unlike most 'Item' functions.
---@return number 
function ImGui:calc_item_width()
    return r.ImGui_CalcItemWidth(self.ctx)
end

-- Default values: hide_text_after_double_hash = false, wrap_width = -1.0
---@param text string
---@param w number
---@param h number
---@param hide_text_after_double_hash_in boolean
---@param wrap_width_in number
---@return number, number 
function ImGui:calc_text_size(text, w, h, hide_text_after_double_hash_in, wrap_width_in)
    return r.ImGui_CalcTextSize(self.ctx, text, w, h, hide_text_after_double_hash_in, wrap_width_in)
end

-- Default values: want_capture_keyboard_value = true
---@param want_capture_keyboard_value_in boolean
function ImGui:capture_keyboard_from_app(want_capture_keyboard_value_in)
    return r.ImGui_CaptureKeyboardFromApp(self.ctx, want_capture_keyboard_value_in)
end

---@param label string
---@param v boolean
---@return boolean 
function ImGui:checkbox(label, v)
    local retval, v_ = r.ImGui_Checkbox(self.ctx, label, v)
    if retval then
        return v_
    end
end

---@param label string
---@param flags number
---@param flags_value number
---@return number 
function ImGui:checkbox_flags(label, flags, flags_value)
    local retval, flags_ = r.ImGui_CheckboxFlags(self.ctx, label, flags, flags_value)
    if retval then
        return flags_
    end
end

-- CloseCurrentPopup() is called by default by Selectable()/MenuItem() when activated
function ImGui:close_current_popup()
    return r.ImGui_CloseCurrentPopup(self.ctx)
end

---@return number
function ImGui:col_border()
    return r.ImGui_Col_Border()
end

---@return number
function ImGui:col_border_shadow()
    return r.ImGui_Col_BorderShadow()
end

---@return number
function ImGui:col_button()
    return r.ImGui_Col_Button()
end

---@return number
function ImGui:col_button_active()
    return r.ImGui_Col_ButtonActive()
end

---@return number
function ImGui:col_button_hovered()
    return r.ImGui_Col_ButtonHovered()
end

---@return number
function ImGui:col_check_mark()
    return r.ImGui_Col_CheckMark()
end

-- Background of child windows
---@return number
function ImGui:col_child_bg()
    return r.ImGui_Col_ChildBg()
end

-- Background color for empty node (e.g. CentralNode with no window docked into it)
---@return number
function ImGui:col_docking_empty_bg()
    return r.ImGui_Col_DockingEmptyBg()
end

-- Preview overlay color when about to docking something
---@return number
function ImGui:col_docking_preview()
    return r.ImGui_Col_DockingPreview()
end

---@return number
function ImGui:col_drag_drop_target()
    return r.ImGui_Col_DragDropTarget()
end

-- Background of checkbox, radio button, plot, slider, text input
---@return number
function ImGui:col_frame_bg()
    return r.ImGui_Col_FrameBg()
end

---@return number
function ImGui:col_frame_bg_active()
    return r.ImGui_Col_FrameBgActive()
end

---@return number
function ImGui:col_frame_bg_hovered()
    return r.ImGui_Col_FrameBgHovered()
end

-- Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem
---@return number
function ImGui:col_header()
    return r.ImGui_Col_Header()
end

---@return number
function ImGui:col_header_active()
    return r.ImGui_Col_HeaderActive()
end

---@return number
function ImGui:col_header_hovered()
    return r.ImGui_Col_HeaderHovered()
end

---@return number
function ImGui:col_menu_bar_bg()
    return r.ImGui_Col_MenuBarBg()
end

-- Darken/colorize entire screen behind a modal window, when one is active
---@return number
function ImGui:col_modal_window_dim_bg()
    return r.ImGui_Col_ModalWindowDimBg()
end

-- Gamepad/keyboard: current highlighted item
---@return number
function ImGui:col_nav_highlight()
    return r.ImGui_Col_NavHighlight()
end

-- Darken/colorize entire screen behind the CTRL+TAB window list, when active
---@return number
function ImGui:col_nav_windowing_dim_bg()
    return r.ImGui_Col_NavWindowingDimBg()
end

-- Highlight window when using CTRL+TAB
---@return number
function ImGui:col_nav_windowing_highlight()
    return r.ImGui_Col_NavWindowingHighlight()
end

---@return number
function ImGui:col_plot_histogram()
    return r.ImGui_Col_PlotHistogram()
end

---@return number
function ImGui:col_plot_histogram_hovered()
    return r.ImGui_Col_PlotHistogramHovered()
end

---@return number
function ImGui:col_plot_lines()
    return r.ImGui_Col_PlotLines()
end

---@return number
function ImGui:col_plot_lines_hovered()
    return r.ImGui_Col_PlotLinesHovered()
end

-- Background of popups, menus, tooltips windows
---@return number
function ImGui:col_popup_bg()
    return r.ImGui_Col_PopupBg()
end

---@return number
function ImGui:col_resize_grip()
    return r.ImGui_Col_ResizeGrip()
end

---@return number
function ImGui:col_resize_grip_active()
    return r.ImGui_Col_ResizeGripActive()
end

---@return number
function ImGui:col_resize_grip_hovered()
    return r.ImGui_Col_ResizeGripHovered()
end

---@return number
function ImGui:col_scrollbar_bg()
    return r.ImGui_Col_ScrollbarBg()
end

---@return number
function ImGui:col_scrollbar_grab()
    return r.ImGui_Col_ScrollbarGrab()
end

---@return number
function ImGui:col_scrollbar_grab_active()
    return r.ImGui_Col_ScrollbarGrabActive()
end

---@return number
function ImGui:col_scrollbar_grab_hovered()
    return r.ImGui_Col_ScrollbarGrabHovered()
end

---@return number
function ImGui:col_separator()
    return r.ImGui_Col_Separator()
end

---@return number
function ImGui:col_separator_active()
    return r.ImGui_Col_SeparatorActive()
end

---@return number
function ImGui:col_separator_hovered()
    return r.ImGui_Col_SeparatorHovered()
end

---@return number
function ImGui:col_slider_grab()
    return r.ImGui_Col_SliderGrab()
end

---@return number
function ImGui:col_slider_grab_active()
    return r.ImGui_Col_SliderGrabActive()
end

---@return number
function ImGui:col_tab()
    return r.ImGui_Col_Tab()
end

---@return number
function ImGui:col_tab_active()
    return r.ImGui_Col_TabActive()
end

---@return number
function ImGui:col_tab_hovered()
    return r.ImGui_Col_TabHovered()
end

---@return number
function ImGui:col_tab_unfocused()
    return r.ImGui_Col_TabUnfocused()
end

---@return number
function ImGui:col_tab_unfocused_active()
    return r.ImGui_Col_TabUnfocusedActive()
end

-- Table inner borders (prefer using Alpha=1.0 here)
---@return number
function ImGui:col_table_border_light()
    return r.ImGui_Col_TableBorderLight()
end

-- Table outer and header borders (prefer using Alpha=1.0 here)
---@return number
function ImGui:col_table_border_strong()
    return r.ImGui_Col_TableBorderStrong()
end

-- Table header background
---@return number
function ImGui:col_table_header_bg()
    return r.ImGui_Col_TableHeaderBg()
end

-- Table row background (even rows)
---@return number
function ImGui:col_table_row_bg()
    return r.ImGui_Col_TableRowBg()
end

-- Table row background (odd rows)
---@return number
function ImGui:col_table_row_bg_alt()
    return r.ImGui_Col_TableRowBgAlt()
end

---@return number
function ImGui:col_text()
    return r.ImGui_Col_Text()
end

---@return number
function ImGui:col_text_disabled()
    return r.ImGui_Col_TextDisabled()
end

---@return number
function ImGui:col_text_selected_bg()
    return r.ImGui_Col_TextSelectedBg()
end

---@return number
function ImGui:col_title_bg()
    return r.ImGui_Col_TitleBg()
end

---@return number
function ImGui:col_title_bg_active()
    return r.ImGui_Col_TitleBgActive()
end

---@return number
function ImGui:col_title_bg_collapsed()
    return r.ImGui_Col_TitleBgCollapsed()
end

-- Background of normal windows
---@return number
function ImGui:col_window_bg()
    return r.ImGui_Col_WindowBg()
end

-- Default values: flags = ImGui_TreeNodeFlags_None
---@param label string
---@param p_visible boolean
---@param flags number
---@return boolean 
function ImGui:collapsing_header(label, p_visible, flags)
    local retval, p_visible_ = r.ImGui_CollapsingHeader(self.ctx, label, p_visible, flags)
    if retval then
        return p_visible_
    end
end

-- Default values: flags = ImGui_ColorEditFlags_None, size_w = 0.0, size_h = 0.0
---@param desc_id string
---@param col_rgba number
---@param flags number
---@param width number
---@param height number
---@return boolean 
function ImGui:color_button(desc_id, col_rgba, flags, width, height)
    return r.ImGui_ColorButton(self.ctx, desc_id, col_rgba, flags, width, height)
end

-- Default values: alpha = nil
---@param s number
---@param v number
---@param alpha_in number
---@return number, number, number 
function ImGui:color_convert_hsv_to_rgb(s, v, alpha_in)
    local retval, r, g, b = r.ImGui_ColorConvertHSVtoRGB(self.ctx, s, v, alpha_in)
    if retval then
        return r, g, b
    end
end

-- Convert native colors coming from REAPER. This swaps the red and blue channels of the specified 0xRRGGBB color on Windows.
---@return number
function ImGui:color_convert_native()
    return r.ImGui_ColorConvertNative(self.ctx)
end

-- Default values: alpha = nil
---@param r number
---@param g number
---@param b number
---@param alpha_in number
---@return number, number, number 
function ImGui:color_convert_rgb_to_hsv(r, g, b, alpha_in)
    local retval, h, s, v = r.ImGui_ColorConvertRGBtoHSV(self.ctx, g, b, alpha_in)
    if retval then
        return h, s, v
    end
end

-- Default values: flags = ImGui_ColorEditFlags_None
---@param label string
---@param col_rgb number
---@param flags number
---@return number 
function ImGui:color_edit3(label, col_rgb, flags)
    local retval, col_rgb_ = r.ImGui_ColorEdit3(label, col_rgb, flags)
    if retval then
        return col_rgb_
    end
end

-- Default values: flags = ImGui_ColorEditFlags_None
---@param label string
---@param col_rgba number
---@param flags number
---@return number 
function ImGui:color_edit4(label, col_rgba, flags)
    local retval, col_rgba_ = r.ImGui_ColorEdit4(self.ctx, label, col_rgba, flags)
    if retval then
        return col_rgba_
    end
end

-- Defaults Options. You can set application defaults using SetColorEditOptions(). The intent is that you probably don't want to override them in most of your calls. Let the user choose via the option menu and/or call SetColorEditOptions() once during startup.
---@return number
function ImGui:color_edit_flags_options_default()
    return r.ImGui_ColorEditFlags_OptionsDefault(self.ctx)
end

-- ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
---@return number
function ImGui:color_edit_flags_alpha_bar()
    return r.ImGui_ColorEditFlags_AlphaBar(self.ctx)
end

-- ColorEdit, ColorPicker, ColorButton: display preview as a transparent color over a checkerboard, instead of opaque.
---@return number
function ImGui:color_edit_flags_alpha_preview()
    return r.ImGui_ColorEditFlags_AlphaPreview(self.ctx)
end

-- ColorEdit, ColorPicker, ColorButton: display half opaque / half checkerboard, instead of opaque.
---@return number
function ImGui:color_edit_flags_alpha_preview_half()
    return r.ImGui_ColorEditFlags_AlphaPreviewHalf(self.ctx)
end

-- ColorEdit: override _display_ type to HSV. ColorPicker: select any combination using one or more of RGB/HSV/Hex.
---@return number
function ImGui:color_edit_flags_display_hsv()
    return r.ImGui_ColorEditFlags_DisplayHSV(self.ctx)
end

-- ColorEdit: override _display_ type to Hex. ColorPicker: select any combination using one or more of RGB/HSV/Hex.
---@return number
function ImGui:color_edit_flags_display_hex()
    return r.ImGui_ColorEditFlags_DisplayHex(self.ctx)
end

-- ColorEdit: override _display_ type to RGB. ColorPicker: select any combination using one or more of RGB/HSV/Hex.
---@return number
function ImGui:color_edit_flags_display_rgb()
    return r.ImGui_ColorEditFlags_DisplayRGB(self.ctx)
end

-- ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0f..1.0f floats instead of 0..255 integers. No round-trip of value via integers.
---@return number
function ImGui:color_edit_flags_float()
    return r.ImGui_ColorEditFlags_Float(self.ctx)
end

-- ColorEdit, ColorPicker: input and output data in HSV format.
---@return number
function ImGui:color_edit_flags_input_hsv()
    return r.ImGui_ColorEditFlags_InputHSV(self.ctx)
end

-- ColorEdit, ColorPicker: input and output data in RGB format.
---@return number
function ImGui:color_edit_flags_input_rgb()
    return r.ImGui_ColorEditFlags_InputRGB(self.ctx)
end

-- ColorEdit, ColorPicker, ColorButton: ignore Alpha component (will only read 3 components from the input pointer).
---@return number
function ImGui:color_edit_flags_no_alpha()
    return r.ImGui_ColorEditFlags_NoAlpha(self.ctx)
end

-- ColorButton: disable border (which is enforced by default)
---@return number
function ImGui:color_edit_flags_no_border()
    return r.ImGui_ColorEditFlags_NoBorder(self.ctx)
end

-- ColorEdit: disable drag and drop target. ColorButton: disable drag and drop source.
---@return number
function ImGui:color_edit_flags_no_drag_drop()
    return r.ImGui_ColorEditFlags_NoDragDrop(self.ctx)
end

-- ColorEdit, ColorPicker: disable inputs sliders/text widgets (e.g. to show only the small preview color square).
---@return number
function ImGui:color_edit_flags_no_inputs()
    return r.ImGui_ColorEditFlags_NoInputs(self.ctx)
end

-- ColorEdit, ColorPicker: disable display of inline text label (the label is still forwarded to the tooltip and picker).
---@return number
function ImGui:color_edit_flags_no_label()
    return r.ImGui_ColorEditFlags_NoLabel(self.ctx)
end

-- ColorEdit: disable toggling options menu when right-clicking on inputs/small preview.
---@return number
function ImGui:color_edit_flags_no_options()
    return r.ImGui_ColorEditFlags_NoOptions(self.ctx)
end

-- ColorEdit: disable picker when clicking on color square.
---@return number
function ImGui:color_edit_flags_no_picker()
    return r.ImGui_ColorEditFlags_NoPicker(self.ctx)
end

-- ColorPicker: disable bigger color preview on right side of the picker, use small color square preview instead.
---@return number
function ImGui:color_edit_flags_no_side_preview()
    return r.ImGui_ColorEditFlags_NoSidePreview(self.ctx)
end

-- ColorEdit, ColorPicker: disable color square preview next to the inputs. (e.g. to show only the inputs)
---@return number
function ImGui:color_edit_flags_no_small_preview()
    return r.ImGui_ColorEditFlags_NoSmallPreview(self.ctx)
end

-- ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
---@return number
function ImGui:color_edit_flags_no_tooltip()
    return r.ImGui_ColorEditFlags_NoTooltip(self.ctx)
end

-- Flags for ColorEdit3() / ColorEdit4() / ColorPicker3() / ColorPicker4() / ColorButton()
---@return number
function ImGui:color_edit_flags_none()
    return r.ImGui_ColorEditFlags_None(self.ctx)
end

-- ColorPicker: bar for Hue, rectangle for Sat/Value.
---@return number
function ImGui:color_edit_flags_picker_hue_bar()
    return r.ImGui_ColorEditFlags_PickerHueBar(self.ctx)
end

-- ColorPicker: wheel for Hue, triangle for Sat/Value.
---@return number
function ImGui:color_edit_flags_picker_hue_wheel()
    return r.ImGui_ColorEditFlags_PickerHueWheel(self.ctx)
end

-- ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255.
---@return number
function ImGui:color_edit_flags_uint8()
    return r.ImGui_ColorEditFlags_Uint8(self.ctx)
end

-- Default values: flags = ImGui_ColorEditFlags_None
---@param label string
---@param col_rgb number
---@param flags number
---@return number 
function ImGui:color_picker3(label, col_rgb, flags)
    local retval, col_rgb_ = r.ImGui_ColorPicker3(self.ctx, label, col_rgb, flags)
    if retval then
        return col_rgb_
    end
end

-- Default values: flags = ImGui_ColorEditFlags_None, ref_col = nil
---@param label string
---@param col_rgba number
---@param flags number
---@param ref_col_in number
---@return number 
function ImGui:color_picker4(label, col_rgba, flags, ref_col_in)
    local retval, col_rgba_ = r.ImGui_ColorPicker4(self.ctx, label, col_rgba, flags, ref_col_in)
    if retval then
        return col_rgba_
    end
end

-- Default values: popup_max_height_in_items = -1
---@param label string
---@param current_item number
---@param items string
---@param popup_max_height_in_items_in number
---@return number, string 
function ImGui:combo(label, current_item, items, popup_max_height_in_items_in)
    local retval, current_item_, items_ = r.ImGui_Combo(self.ctx, label, current_item, items, popup_max_height_in_items_in)
    if retval then
        return current_item_, items_
    end
end

-- Max ~20 items visible
---@return number
function ImGui:combo_flags_height_large()
    return r.ImGui_ComboFlags_HeightLarge(self.ctx)
end

-- As many fitting items as possible
---@return number
function ImGui:combo_flags_height_largest()
    return r.ImGui_ComboFlags_HeightLargest(self.ctx)
end

-- Max ~8 items visible (default)
---@return number
function ImGui:combo_flags_height_regular()
    return r.ImGui_ComboFlags_HeightRegular(self.ctx)
end

-- Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
---@return number
function ImGui:combo_flags_height_small()
    return r.ImGui_ComboFlags_HeightSmall(self.ctx)
end

-- Display on the preview box without the square arrow button
---@return number
function ImGui:combo_flags_no_arrow_button()
    return r.ImGui_ComboFlags_NoArrowButton(self.ctx)
end

-- Display only a square arrow button
---@return number
function ImGui:combo_flags_no_preview()
    return r.ImGui_ComboFlags_NoPreview(self.ctx)
end

-- Flags for ImGui::BeginCombo()
---@return number
function ImGui:combo_flags_none()
    return r.ImGui_ComboFlags_None(self.ctx)
end

-- Align the popup toward the left by default
---@return number
function ImGui:combo_flags_popup_align_left()
    return r.ImGui_ComboFlags_PopupAlignLeft(self.ctx)
end

-- No condition (always set the variable)
---@return number
function ImGui:cond_always()
    return r.ImGui_Cond_Always()
end

-- Set the variable if the object/window is appearing after being hidden/inactive (or the first time)
---@return number
function ImGui:cond_appearing()
    return r.ImGui_Cond_Appearing()
end

-- Set the variable if the object/window has no persistently saved data (no entry in .ini file)
---@return number
function ImGui:cond_first_use_ever()
    return r.ImGui_Cond_FirstUseEver()
end

-- Set the variable once per runtime session (only the first call will succeed)
---@return number
function ImGui:cond_once()
    return r.ImGui_Cond_Once()
end

-- [BETA] Enable docking functionality.
---@return number
function ImGui:config_flags_docking_enable()
    return r.ImGui_ConfigFlags_DockingEnable(self.ctx)
end

-- Master keyboard navigation enable flag.
---@return number
function ImGui:config_flags_nav_enable_keyboard()
    return r.ImGui_ConfigFlags_NavEnableKeyboard(self.ctx)
end

-- Instruct navigation to move the mouse cursor.
---@return number
function ImGui:config_flags_nav_enable_set_mouse_pos()
    return r.ImGui_ConfigFlags_NavEnableSetMousePos(self.ctx)
end

-- Instruct imgui to clear mouse position/buttons in NewFrame(). This allows ignoring the mouse information set by the backend.
---@return number
function ImGui:config_flags_no_mouse()
    return r.ImGui_ConfigFlags_NoMouse(self.ctx)
end

-- Instruct backend to not alter mouse cursor shape and visibility.
---@return number
function ImGui:config_flags_no_mouse_cursor_change()
    return r.ImGui_ConfigFlags_NoMouseCursorChange(self.ctx)
end

-- Disable state restoration and persistence for the whole context
---@return number
function ImGui:config_flags_no_saved_settings()
    return r.ImGui_ConfigFlags_NoSavedSettings(self.ctx)
end

-- Flags for ImGui_SetConfigFlags
---@return number
function ImGui:config_flags_none()
    return r.ImGui_ConfigFlags_None(self.ctx)
end

-- Default values: config_flags = ImGui_ConfigFlags_None
---@param label string
---@param config_flags number
---@return ImGui_Context 
function ImGui:create_context(label, config_flags)
    return r.ImGui_CreateContext(label, config_flags)
end

-- Close and free the resources used by a context.
function ImGui:destroy_context()
    r.ImGui_DestroyContext(self.ctx)
end

-- Default values: flags = ImGui_FontFlags_None
---@param size number
---@param flags number
---@return ImGui_Font 
function ImGui:create_font(size, flags)
    return r.ImGui_CreateFont(self.ctx, size, flags)
end

-- The returned clipper object is tied to the context and is valid
-- as long as it is used in each defer cycle. See ImGui_ListClipper_Begin.
---@return ImGui_ListClipper 
function ImGui:create_list_clipper()
    return r.ImGui_CreateListClipper(self.ctx)
end


-- A cardinal direction
---@return number
function ImGui:dir_down()
    return r.ImGui_Dir_Down(self.ctx)
end

-- A cardinal direction
---@return number
function ImGui:dir_left()
    return r.ImGui_Dir_Left(self.ctx)
end

-- A cardinal direction
---@return number
function ImGui:dir_none()
    return r.ImGui_Dir_None(self.ctx)
end

-- A cardinal direction
---@return number
function ImGui:dir_right()
    return r.ImGui_Dir_Right(self.ctx)
end

-- A cardinal direction
---@return number
function ImGui:dir_up()
    return r.ImGui_Dir_Up(self.ctx)
end

-- Default values: v_speed = 1.0, v_min = 0.0, v_max = 0.0, format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param v number
---@param v_speed_in number
---@param v_min_in number
---@param v_max_in number
---@param format_in string
---@param flags number
---@return number 
function ImGui:drag_double(label, v, v_speed_in, v_min_in, v_max_in, format_in, flags)
    local retval, v_ = r.ImGui_DragDouble(
            self.ctx, label, v, v_speed_in, v_min_in, v_max_in, format_in, flags
    )
    if retval then
        return v_
    end
end

-- Default values: v_speed = 1.0, v_min = 0.0, v_max = 0.0, format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v_speed_in number
---@param v_min_in number
---@param v_max_in number
---@param format_in string
---@param flags number
---@return number, number 
function ImGui:drag_double2(label, v1, v2, v_speed_in, v_min_in, v_max_in, format_in, flags)
    local retval, v1_, v2_ = r.ImGui_DragDouble2(self.ctx, label, v1, v2, v_speed_in, v_min_in, v_max_in, format_in, flags)
    if retval then
        return v1_, v2_
    end
end

-- Default values: v_speed = 1.0, v_min = 0.0, v_max = 0.0, format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_speed_in number
---@param v_min_in number
---@param v_max_in number
---@param format_in string
---@param flags number
---@return number, number, number 
function ImGui:drag_double3(label, v1, v2, v3, v_speed_in, v_min_in, v_max_in, format_in, flags)
    local retval, v1_, v2_, v3_ = r.ImGui_DragDouble3(self.ctx, label, v1, v2, v3, v_speed_in, v_min_in, v_max_in, format_in, flags)
    if retval then
        return v1_, v2_, v3_
    end
end

-- Default values: v_speed = 1.0, v_min = 0.0, v_max = 0.0, format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_speed_in number
---@param v_min_in number
---@param v_max_in number
---@param format_in string
---@param flags number
---@return number, number, number, number 
function ImGui:drag_double4(label, v1, v2, v3, v4, v_speed_in, v_min_in, v_max_in, format_in, flags)
    local retval, v1_, v2_, v3_, v4_ = r.ImGui_DragDouble4(
            self.ctx, label, v1, v2, v3, v4, v_speed_in, v_min_in, v_max_in, format_in, flags
    )
    if retval then
        return v1_, v2_, v3_, v4_
    end
end

-- Default values: speed = 1.0, min = nil, max = nil, format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param values reaper_array
---@param ctx ImGui_Context
---@param speed_in number
---@param min_in number
---@param max_in number
---@param format_in string
---@param flags number
---@return boolean 
function ImGui:drag_double_n(label, values, ctx, speed_in, min_in, max_in, format_in, flags)
    return r.ImGui_DragDoubleN(
            self.ctx, label, values, ctx, speed_in, min_in, max_in, format_in, flags
    )
end

-- AcceptDragDropPayload() will returns true even before the mouse button is released.
-- You can then call IsDelivery() to test if the payload needs to be delivered.
---@return number
function ImGui:drag_drop_flags_accept_before_delivery()
    return r.ImGui_DragDropFlags_AcceptBeforeDelivery(self.ctx)
end

-- Do not draw the default highlight rectangle when hovering over target.
---@return number
function ImGui:drag_drop_flags_accept_no_draw_default_rect()
    return r.ImGui_DragDropFlags_AcceptNoDrawDefaultRect(self.ctx)
end

-- Request hiding the BeginDragDropSource tooltip from the BeginDragDropTarget site.
---@return number
function ImGui:drag_drop_flags_accept_no_preview_tooltip()
    return r.ImGui_DragDropFlags_AcceptNoPreviewTooltip(self.ctx)
end

-- For peeking ahead and inspecting the payload before delivery. Equivalent to ImGuiDragDropFlags_AcceptBeforeDelivery | ImGuiDragDropFlags_AcceptNoDrawDefaultRect.
---@return number
function ImGui:drag_drop_flags_accept_peek_only()
    return r.ImGui_DragDropFlags_AcceptPeekOnly(self.ctx)
end

-- Flags for ImGui::BeginDragDropSource(), ImGui::AcceptDragDropPayload()
---@return number
function ImGui:drag_drop_flags_none()
    return r.ImGui_DragDropFlags_None(self.ctx)
end

-- Allow items such as Text(), Image() that have no unique identifier to be used as drag source, by manufacturing a temporary identifier based on their window-relative position. This is extremely unusual within the dear imgui ecosystem and so we made it explicit.
---@return number
function ImGui:drag_drop_flags_source_allow_null_i_d()
    return r.ImGui_DragDropFlags_SourceAllowNullID(self.ctx)
end

-- Automatically expire the payload if the source cease to be submitted (otherwise payloads are persisting while being dragged)
---@return number
function ImGui:drag_drop_flags_source_auto_expire_payload()
    return r.ImGui_DragDropFlags_SourceAutoExpirePayload(self.ctx)
end

-- External source (from outside of dear ImGui), won't attempt to read current item/window info.
-- Will always return true. Only one Extern source can be active simultaneously.
---@return number
function ImGui:drag_drop_flags_source_extern()
    return r.ImGui_DragDropFlags_SourceExtern(self.ctx)
end

-- By default, when dragging we clear data so that IsItemHovered() will return false, to avoid subsequent user code submitting tooltips. This flag disable this behavior so you can still call IsItemHovered() on the source item.
---@return number
function ImGui:drag_drop_flags_source_no_disable_hover()
    return r.ImGui_DragDropFlags_SourceNoDisableHover(self.ctx)
end

-- Disable the behavior that allows to open tree nodes and collapsing header by holding over them while dragging a source item.
---@return number
function ImGui:drag_drop_flags_source_no_hold_to_open_others()
    return r.ImGui_DragDropFlags_SourceNoHoldToOpenOthers(self.ctx)
end

-- By default, a successful call to BeginDragDropSource opens a tooltip so you can display a preview or description of the source contents. This flag disable this behavior.
---@return number
function ImGui:drag_drop_flags_source_no_preview_tooltip()
    return r.ImGui_DragDropFlags_SourceNoPreviewTooltip(self.ctx)
end

-- Default values: v_speed = 1.0, v_min = 0.0, v_max = 0.0, format = '%.3f', format_max = nil, flags = ImGui_SliderFlags_None
---@param label string
---@param v_current_min number
---@param v_current_max number
---@param v_speed_in number
---@param v_min_in number
---@param v_max_in number
---@param format_in string
---@param format_max_in string
---@param flags number
---@return number, number 
function ImGui:drag_float_range2(
        label, v_current_min, v_current_max, v_speed_in, v_min_in, v_max_in, format_in, format_max_in, flags
)
    local retval, v_current_min_, v_current_max_ = r.ImGui_DragFloatRange2(
            self.ctx, label, v_current_min, v_current_max, v_speed_in, v_min_in, v_max_in, format_in, format_max_in, flags
    )
    if retval then
        return v_current_min_, v_current_max_
    end
end

-- Default values: v_speed = 1.0, v_min = 0, v_max = 0, format = '%d', flags = ImGui_SliderFlags_None
---@param label string
---@param v number
---@param v_speed_in number
---@param v_min_in number
---@param v_max_in number
---@param format_in string
---@param flags number
---@return number 
function ImGui:drag_int(label, v, v_speed_in, v_min_in, v_max_in, format_in, flags)
    local retval, v_ = r.ImGui_DragInt(self.ctx, label, v, v_speed_in, v_min_in, v_max_in, format_in, flags)
    if retval then
        return v_
    end
end

-- Default values: v_speed = 1.0, v_min = 0, v_max = 0, format = '%d', flags = ImGui_SliderFlags_None)
---@param label string
---@param v1 number
---@param v2 number
---@param v_speed_in number
---@param v_min_in number
---@param v_max_in number
---@param format_in string
---@param flags number
---@return number, number 
function ImGui:drag_int2(label, v1, v2, v_speed_in, v_min_in, v_max_in, format_in, flags)
    local retval, v1_, v2_ = r.ImGui_DragInt2(self.ctx, label, v1, v2, v_speed_in, v_min_in, v_max_in, format_in, flags)
    if retval then
        return v1_, v2_
    end
end

-- Default values: v_speed = 1.0, v_min = 0, v_max = 0, format = '%d', flags = ImGui_SliderFlags_None)
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_speed_in number
---@param v_min_in number
---@param v_max_in number
---@param format_in string
---@param flags number
---@return number, number, number 
function ImGui:drag_int3(label, v1, v2, v3, v_speed_in, v_min_in, v_max_in, format_in, flags)
    local retval, v1_, v2_, v3_ = r.ImGui_DragInt3(self.ctx, label, v1, v2, v3, v_speed_in, v_min_in, v_max_in, format_in, flags)
    if retval then
        return v1_, v2_, v3_
    end
end

-- Default values: v_speed = 1.0, v_min = 0, v_max = 0, format = '%d', flags = ImGui_SliderFlags_None)
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_speed_in number
---@param v_min_in number
---@param v_max_in number
---@param format_in string
---@param flags number
---@return number, number, number, number 
function ImGui:drag_int4(label, v1, v2, v3, v4, v_speed_in, v_min_in, v_max_in, format_in, flags)
    local retval, v1_, v2_, v3_, v4_ = r.ImGui_DragInt4(self.ctx, label, v1, v2, v3, v4, v_speed_in, v_min_in, v_max_in, format_in, flags)
    if retval then
        return v1_, v2_, v3_, v4_
    end
end

-- Default values: v_speed = 1.0, v_min = 0, v_max = 0, format = '%d', format_max = nil, flags = ImGui_SliderFlags_None
---@param label string
---@param v_current_min number
---@param v_current_max number
---@param v_speed_in number
---@param v_min_in number
---@param v_max_in number
---@param format_in string
---@param format_max_in string
---@param flags number
---@return number, number 
function ImGui:drag_int_range2(label, v_current_min, v_current_max, v_speed_in, v_min_in, v_max_in, format_in, format_max_in, flags)
    local retval, v_current_min_, v_current_max_ = r.ImGui_DragIntRange2(self.ctx, label, v_current_min, v_current_max, v_speed_in, v_min_in, v_max_in, format_in, format_max_in, flags)
    if retval then
        return v_current_min_, v_current_max_
    end
end

-- PathStroke(), AddPolyline(): specify that shape should be closed (Important: this is always == 1 for legacy reason)
---@return number
function ImGui:draw_flags_closed()
    return r.ImGui_DrawFlags_Closed(self.ctx)
end

---@return number
function ImGui:draw_flags_none()
    return r.ImGui_DrawFlags_None(self.ctx)
end

---@return number
function ImGui:draw_flags_round_corners_all()
    return r.ImGui_DrawFlags_RoundCornersAll(self.ctx)
end

---@return number
function ImGui:draw_flags_round_corners_bottom()
    return r.ImGui_DrawFlags_RoundCornersBottom(self.ctx)
end

-- AddRect(), AddRectFilled(), PathRect(): enable rounding bottom-left corner only (when rounding > 0.0f, we default to all corners).
---@return number
function ImGui:draw_flags_round_corners_bottom_left()
    return r.ImGui_DrawFlags_RoundCornersBottomLeft(self.ctx)
end

-- AddRect(), AddRectFilled(), PathRect(): enable rounding bottom-right corner only (when rounding > 0.0f, we default to all corners).
---@return number
function ImGui:draw_flags_round_corners_bottom_right()
    return r.ImGui_DrawFlags_RoundCornersBottomRight(self.ctx)
end

---@return number
function ImGui:draw_flags_round_corners_left()
    return r.ImGui_DrawFlags_RoundCornersLeft(self.ctx)
end

-- AddRect(), AddRectFilled(), PathRect(): disable rounding on all corners (when rounding > 0.0f). This is NOT zero, NOT an implicit flag!
---@return number
function ImGui:draw_flags_round_corners_none()
    return r.ImGui_DrawFlags_RoundCornersNone(self.ctx)
end

---@return number
function ImGui:draw_flags_round_corners_right()
    return r.ImGui_DrawFlags_RoundCornersRight(self.ctx)
end

---@return number
function ImGui:draw_flags_round_corners_top()
    return r.ImGui_DrawFlags_RoundCornersTop(self.ctx)
end

-- AddRect(), AddRectFilled(), PathRect(): enable rounding top-left corner only (when rounding > 0.0f, we default to all corners).
---@return number
function ImGui:draw_flags_round_corners_top_left()
    return r.ImGui_DrawFlags_RoundCornersTopLeft(self.ctx)
end

-- AddRect(), AddRectFilled(), PathRect(): enable rounding top-right corner only (when rounding > 0.0f, we default to all corners).
---@return number
function ImGui:draw_flags_round_corners_top_right()
    return r.ImGui_DrawFlags_RoundCornersTopRight(self.ctx)
end

-- Default values: num_segments = 0
---@param p1_x number
---@param p1_y number
---@param p2_x number
---@param p2_y number
---@param p3_x number
---@param p3_y number
---@param p4_x number
---@param p4_y number
---@param col_rgba number
---@param thickness number
---@param num_segments_in number
function ImGui:draw_list_add_bezier_cubic(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba, thickness, num_segments_in)
    return r.ImGui_DrawList_AddBezierCubic(self.ctx, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba, thickness, num_segments_in)
end

-- Default values: num_segments = 0
---@param p1_x number
---@param p1_y number
---@param p2_x number
---@param p2_y number
---@param p3_x number
---@param p3_y number
---@param col_rgba number
---@param thickness number
---@param num_segments_in number
function ImGui:draw_list_add_bezier_quadratic(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba, thickness, num_segments_in)
    return r.ImGui_DrawList_AddBezierQuadratic(self.ctx, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba, thickness, num_segments_in)
end

-- Default values: num_segments = 0, thickness = 1.0
---@param center_x number
---@param center_y number
---@param radius number
---@param col_rgba number
---@param num_segments_in number
---@param thickness_in number
function ImGui:draw_list_add_circle(center_x, center_y, radius, col_rgba, num_segments_in, thickness_in)
    return r.ImGui_DrawList_AddCircle(self.ctx, center_x, center_y, radius, col_rgba, num_segments_in, thickness_in)
end

-- Default values: num_segments = 0
---@param center_x number
---@param center_y number
---@param radius number
---@param col_rgba number
---@param num_segments_in number
function ImGui:draw_list_add_circle_filled(center_x, center_y, radius, col_rgba, num_segments_in)
    return r.ImGui_DrawList_AddCircleFilled(self.ctx, center_x, center_y, radius, col_rgba, num_segments_in)
end

-- Note: Anti-aliased filling requires points to be in clockwise order.
---@param values reaper_array
---@param retval ReaType
---@param num_points number
---@param col_rgba number
function ImGui:draw_list_add_convex_poly_filled(values, retval, num_points, col_rgba)
    return r.ImGui_DrawList_AddConvexPolyFilled(self.ctx, values, retval, num_points, col_rgba)
end

-- Default values: thickness = 1.0
---@param p1_x number
---@param p1_y number
---@param p2_x number
---@param p2_y number
---@param col_rgba number
---@param thickness_in number
function ImGui:draw_list_add_line(p1_x, p1_y, p2_x, p2_y, col_rgba, thickness_in)
    return r.ImGui_DrawList_AddLine(self.ctx, p1_x, p1_y, p2_x, p2_y, col_rgba, thickness_in)
end

-- Default values: thickness = 1.0
---@param center_x number
---@param center_y number
---@param radius number
---@param col_rgba number
---@param num_segments number
---@param thickness_in number
function ImGui:draw_list_add_ngon(center_x, center_y, radius, col_rgba, num_segments, thickness_in)
    return r.ImGui_DrawList_AddNgon(self.ctx, center_x, center_y, radius, col_rgba, num_segments, thickness_in)
end

---@param center_x number
---@param center_y number
---@param radius number
---@param col_rgba number
---@param num_segments number
function ImGui:draw_list_add_ngon_filled(center_x, center_y, radius, col_rgba, num_segments)
    return r.ImGui_DrawList_AddNgonFilled(self.ctx, center_x, center_y, radius, col_rgba, num_segments)
end

-- Points is a list of x,y coordinates.
---@param values reaper_array
---@param retval ReaType
---@param col_rgba number
---@param flags number
---@param thickness number
function ImGui:draw_list_add_polyline(values, retval, col_rgba, flags, thickness)
    return r.ImGui_DrawList_AddPolyline(self.ctx, values, retval, col_rgba, flags, thickness)
end

-- Default values: thickness = 1.0
---@param p1_x number
---@param p1_y number
---@param p2_x number
---@param p2_y number
---@param p3_x number
---@param p3_y number
---@param p4_x number
---@param p4_y number
---@param col_rgba number
---@param thickness_in number
function ImGui:draw_list_add_quad(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba, thickness_in)
    return r.ImGui_DrawList_AddQuad(self.ctx, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba, thickness_in)
end

---@param p1_x number
---@param p1_y number
---@param p2_x number
---@param p2_y number
---@param p3_x number
---@param p3_y number
---@param p4_x number
---@param p4_y number
---@param col_rgba number
function ImGui:draw_list_add_quad_filled(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba)
    return r.ImGui_DrawList_AddQuadFilled(self.ctx, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col_rgba)
end

-- Default values: rounding = 0.0, flags = ImGui_DrawFlags_None, thickness = 1.0
---@param p_min_x number
---@param p_min_y number
---@param p_max_x number
---@param p_max_y number
---@param col_rgba number
---@param rounding_in number
---@param flags number
---@param thickness_in number
function ImGui:draw_list_add_rect(p_min_x, p_min_y, p_max_x, p_max_y, col_rgba, rounding_in, flags, thickness_in)
    return r.ImGui_DrawList_AddRect(self.ctx, p_min_x, p_min_y, p_max_x, p_max_y, col_rgba, rounding_in, flags, thickness_in)
end

-- Default values: rounding = 0.0, flags = ImGui_DrawFlags_None
---@param p_min_x number
---@param p_min_y number
---@param p_max_x number
---@param p_max_y number
---@param col_rgba number
---@param rounding_in number
---@param flags number
function ImGui:draw_list_add_rect_filled(p_min_x, p_min_y, p_max_x, p_max_y, col_rgba, rounding_in, flags)
    return r.ImGui_DrawList_AddRectFilled(self.ctx, p_min_x, p_min_y, p_max_x, p_max_y, col_rgba, rounding_in, flags)
end

---@param p_min_x number
---@param p_min_y number
---@param p_max_x number
---@param p_max_y number
---@param col_upr_left number
---@param col_upr_right number
---@param col_bot_right number
---@param col_bot_left number
function ImGui:draw_list_add_rect_filled_multi_color(p_min_x, p_min_y, p_max_x, p_max_y, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
    return r.ImGui_DrawList_AddRectFilledMultiColor(self.ctx, p_min_x, p_min_y, p_max_x, p_max_y, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
end

---@param x number
---@param y number
---@param col_rgba number
---@param text string
function ImGui:draw_list_add_text(x, y, col_rgba, text)
    return r.ImGui_DrawList_AddText(self.ctx, x, y, col_rgba, text)
end

-- Default values: wrap_width = 0.0, cpu_fine_clip_rect_x = nil, cpu_fine_clip_rect_y = nil, cpu_fine_clip_rect_w = nil, cpu_fine_clip_rect_h = nil
---@param font ImGui_Font
---@param retval ReaType
---@param font_size number
---@param pos_x number
---@param pos_y number
---@param col_rgba number
---@param text string
---@param wrap_width_in number
---@param cpu_fine_clip_rect_x_in number
---@param cpu_fine_clip_rect_y_in number
---@param cpu_fine_clip_rect_w_in number
---@param cpu_fine_clip_rect_h_in number
function ImGui:draw_list_add_text_ex(font, retval, font_size, pos_x, pos_y, col_rgba, text, wrap_width_in, cpu_fine_clip_rect_x_in, cpu_fine_clip_rect_y_in, cpu_fine_clip_rect_w_in, cpu_fine_clip_rect_h_in)
    return r.ImGui_DrawList_AddTextEx(self.ctx, font, retval, font_size, pos_x, pos_y, col_rgba, text, wrap_width_in, cpu_fine_clip_rect_x_in, cpu_fine_clip_rect_y_in, cpu_fine_clip_rect_w_in, cpu_fine_clip_rect_h_in)
end

-- Default values: thickness = 1.0
---@param p1_x number
---@param p1_y number
---@param p2_x number
---@param p2_y number
---@param p3_x number
---@param p3_y number
---@param col_rgba number
---@param thickness_in number
function ImGui:draw_list_add_triangle(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba, thickness_in)
    return r.ImGui_DrawList_AddTriangle(self.ctx, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba, thickness_in)
end

---@param p1_x number
---@param p1_y number
---@param p2_x number
---@param p2_y number
---@param p3_x number
---@param p3_y number
---@param col_rgba number
function ImGui:draw_list_add_triangle_filled(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba)
    return r.ImGui_DrawList_AddTriangleFilled(self.ctx, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col_rgba)
end

-- Default values: num_segments = 0
---@param center_x number
---@param center_y number
---@param radius number
---@param a_min number
---@param a_max number
---@param num_segments_in number
function ImGui:draw_list_path_arc_to(center_x, center_y, radius, a_min, a_max, num_segments_in)
    return r.ImGui_DrawList_PathArcTo(self.ctx, center_x, center_y, radius, a_min, a_max, num_segments_in)
end

-- Use precomputed angles for a 12 steps circle.
---@param center_x number
---@param center_y number
---@param radius number
---@param a_min_of_12 number
---@param a_max_of_12 number
function ImGui:draw_list_path_arc_to_fast(center_x, center_y, radius, a_min_of_12, a_max_of_12)
    return r.ImGui_DrawList_PathArcToFast(self.ctx, center_x, center_y, radius, a_min_of_12, a_max_of_12)
end

-- Default values: num_segments = 0
---@param p2_x number
---@param p2_y number
---@param p3_x number
---@param p3_y number
---@param p4_x number
---@param p4_y number
---@param num_segments_in number
function ImGui:draw_list_path_bezier_cubic_curve_to(p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, num_segments_in)
    return r.ImGui_DrawList_PathBezierCubicCurveTo(self.ctx, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, num_segments_in)
end

-- Default values: num_segments = 0
---@param p2_x number
---@param p2_y number
---@param p3_x number
---@param p3_y number
---@param num_segments_in number
function ImGui:draw_list_path_bezier_quadratic_curve_to(p2_x, p2_y, p3_x, p3_y, num_segments_in)
    return r.ImGui_DrawList_PathBezierQuadraticCurveTo(self.ctx, p2_x, p2_y, p3_x, p3_y, num_segments_in)
end

function ImGui:draw_list_path_clear()
    return r.ImGui_DrawList_PathClear(self.ctx)
end

-- Stateful path API, add points then finish with PathFillConvex() or PathStroke()
---@param pos_x number
---@param pos_y number
function ImGui:draw_list_path_line_to(pos_x, pos_y)
    return r.ImGui_DrawList_PathLineTo(self.ctx, pos_x, pos_y)
end

-- Default values: rounding = 0.0, flags = ImGui_DrawFlags_None
---@param rect_min_x number
---@param rect_min_y number
---@param rect_max_x number
---@param rect_max_y number
---@param rounding_in number
---@param flags number
function ImGui:draw_list_path_rect(rect_min_x, rect_min_y, rect_max_x, rect_max_y, rounding_in, flags)
    return r.ImGui_DrawList_PathRect(self.ctx, rect_min_x, rect_min_y, rect_max_x, rect_max_y, rounding_in, flags)
end

-- Default values: flags = ImGui_DrawFlags_None, thickness = 1.0
---@param col_rgba number
---@param flags number
---@param thickness_in number
function ImGui:draw_list_path_stroke(col_rgba, flags, thickness_in)
    return r.ImGui_DrawList_PathStroke(self.ctx, col_rgba, flags, thickness_in)
end

-- See DrawList_PushClipRect
function ImGui:draw_list_pop_clip_rect()
    return r.ImGui_DrawList_PopClipRect(self.ctx)
end

-- Default values: intersect_with_current_clip_rect = false
---@param clip_rect_min_x number
---@param clip_rect_min_y number
---@param clip_rect_max_x number
---@param clip_rect_max_y number
---@param intersect_with_current_clip_rect_in boolean
function ImGui:draw_list_push_clip_rect(clip_rect_min_x, clip_rect_min_y, clip_rect_max_x, clip_rect_max_y, intersect_with_current_clip_rect_in)
    return r.ImGui_DrawList_PushClipRect(self.ctx, clip_rect_min_x, clip_rect_min_y, clip_rect_max_x, clip_rect_max_y, intersect_with_current_clip_rect_in)
end

function ImGui:draw_list_push_clip_rect_full_screen()
    return r.ImGui_DrawList_PushClipRectFullScreen(self.ctx)
end

-- Add a dummy item of given size. unlike InvisibleButton(), Dummy() won't take the mouse click or be navigable into.
---@param size_w number
---@param size_h number
function ImGui:dummy(size_w, size_h)
    return r.ImGui_Dummy(self.ctx, size_w, size_h)
end

-- IsWindowFocused(): Return true if any window is focused. Important: If you are trying to tell how to dispatch your low-level inputs, do NOT use this. Use 'io.WantCaptureMouse' instead! Please read the FAQ!
---@return number
function ImGui:focused_flags_any_window()
    return r.ImGui_FocusedFlags_AnyWindow(self.ctx)
end

-- IsWindowFocused(): Return true if any children of the window is focused
---@return number
function ImGui:focused_flags_child_windows()
    return r.ImGui_FocusedFlags_ChildWindows(self.ctx)
end

-- Flags for ImGui::IsWindowFocused()
---@return number
function ImGui:focused_flags_none()
    return r.ImGui_FocusedFlags_None(self.ctx)
end

-- ImGui_FocusedFlags_RootWindow | ImGui_FocusedFlags_ChildWindows
---@return number
function ImGui:focused_flags_root_and_child_windows()
    return r.ImGui_FocusedFlags_RootAndChildWindows(self.ctx)
end

-- IsWindowFocused(): Test from root window (top most parent of the current hierarchy)
---@return number
function ImGui:focused_flags_root_window()
    return r.ImGui_FocusedFlags_RootWindow(self.ctx)
end

---@return number
function ImGui:font_flags_bold()
    return r.ImGui_FontFlags_Bold(self.ctx)
end

---@return number
function ImGui:font_flags_italic()
    return r.ImGui_FontFlags_Italic(self.ctx)
end

---@return number
function ImGui:font_flags_none()
    return r.ImGui_FontFlags_None(self.ctx)
end

-- This draw list will be the first rendering one. Useful to quickly draw shapes/text behind dear imgui contents.
---@return ImGui_DrawList 
function ImGui:get_background_draw_list()
    return r.ImGui_GetBackgroundDrawList(self.ctx)
end

-- See ImGui_SetClipboardText.
---@return string 
function ImGui:get_clipboard_text()
    return r.ImGui_GetClipboardText(self.ctx)
end

-- Default values: alpha_mul = 1.0
---@param idx number
---@param alpha_mul_in number
---@return number
function ImGui:get_color(idx, alpha_mul_in)
    return r.ImGui_GetColor(self.ctx, idx, alpha_mul_in)
end

-- Retrieve given color with style alpha applied, packed as a 32-bit value (RGBA).
---@param col_rgba number
---@return number
function ImGui:get_color_ex(col_rgba)
    return r.ImGui_GetColorEx(self.ctx, col_rgba)
end

-- See ImGui_SetConfigFlags, ImGui_ConfigFlags_*.
---@return number
function ImGui:get_config_flags()
    return r.ImGui_GetConfigFlags(self.ctx)
end

-- == GetContentRegionMax() - GetCursorPos()
---@return number, number 
function ImGui:get_content_region_avail()
    return r.ImGui_GetContentRegionAvail(self.ctx)
end

-- Current content boundaries (typically window boundaries including scrolling, or current column boundaries), in windows coordinates
---@return number, number 
function ImGui:get_content_region_max()
    return r.ImGui_GetContentRegionMax(self.ctx)
end

-- Cursor position in window
---@return number, number 
function ImGui:get_cursor_pos()
    return r.ImGui_GetCursorPos(self.ctx)
end

-- Cursor X position in window
---@return number 
function ImGui:get_cursor_pos_x()
    return r.ImGui_GetCursorPosX(self.ctx)
end

-- Cursor Y position in window
---@return number 
function ImGui:get_cursor_pos_y()
    return r.ImGui_GetCursorPosY(self.ctx)
end

-- Cursor position in absolute screen coordinates [0..io.DisplaySize] (useful to work with ImDrawList API)
---@return number, number 
function ImGui:get_cursor_screen_pos()
    return r.ImGui_GetCursorScreenPos(self.ctx)
end

-- Initial cursor position in window coordinates
---@return number, number 
function ImGui:get_cursor_start_pos()
    return r.ImGui_GetCursorStartPos(self.ctx)
end

-- Time elapsed since last frame, in seconds.
---@return number 
function ImGui:get_delta_time()
    return r.ImGui_GetDeltaTime(self.ctx)
end

-- Peek directly into the current payload from anywhere.
---@return string, string, boolean, boolean 
function ImGui:get_drag_drop_payload()
    local retval, type, payload, is_preview, is_delivery = r.ImGui_GetDragDropPayload(self.ctx)
    if retval then
        return type, payload, is_preview, is_delivery
    end
end

---@param index number
---@return string 
function ImGui:get_drag_drop_payload_file(index)
    local retval, filename = r.ImGui_GetDragDropPayloadFile(self.ctx, index)
    if retval then
        return filename
    end
end

-- Get the current font
---@return ImGui_Font 
function ImGui:get_font()
    return r.ImGui_GetFont(self.ctx)
end

-- Get current font size (= height in pixels) of current font with current scale applied
---@return number 
function ImGui:get_font_size()
    return r.ImGui_GetFontSize(self.ctx)
end

-- This draw list will be the last rendered one. Useful to quickly draw shapes/text over dear imgui contents.
---@return ImGui_DrawList 
function ImGui:get_foreground_draw_list()
    return r.ImGui_GetForegroundDrawList(self.ctx)
end

-- Get global imgui frame count. incremented by 1 every frame.
---@return number
function ImGui:get_frame_count()
    return r.ImGui_GetFrameCount(self.ctx)
end

-- ~ FontSize + style.FramePadding.y * 2
---@return number 
function ImGui:get_frame_height()
    return r.ImGui_GetFrameHeight(self.ctx)
end

-- ~ FontSize + style.FramePadding.y * 2 + style.ItemSpacing.y (distance in pixels between 2 consecutive lines of framed widgets)
---@return number 
function ImGui:get_frame_height_with_spacing()
    return r.ImGui_GetFrameHeightWithSpacing(self.ctx)
end

-- Read from ImGui's character input queue. Call with increasing idx until false is returned.
---@param idx number
---@return number 
function ImGui:get_input_queue_character(idx)
    local retval, unicode_char = r.ImGui_GetInputQueueCharacter(self.ctx, idx)
    if retval then
        return unicode_char
    end
end

-- Get lower-right bounding rectangle of the last item (screen space)
---@return number, number 
function ImGui:get_item_rect_max()
    return r.ImGui_GetItemRectMax(self.ctx)
end

-- Get upper-left bounding rectangle of the last item (screen space)
---@return number, number 
function ImGui:get_item_rect_min()
    return r.ImGui_GetItemRectMin(self.ctx)
end

-- Get size of last item
---@return number, number 
function ImGui:get_item_rect_size()
    return r.ImGui_GetItemRectSize(self.ctx)
end

-- Duration the keyboard key has been down (0.0f == just pressed)
---@param key_code number
---@return number 
function ImGui:get_key_down_duration(key_code)
    return r.ImGui_GetKeyDownDuration(self.ctx, key_code)
end

-- Ctrl/Shift/Alt/Super. See ImGui_KeyModFlags_*.
---@return number
function ImGui:get_key_mods()
    return r.ImGui_GetKeyMods(self.ctx)
end

-- Uses provided repeat rate/delay. return a count, most often 0 or 1 but might be >1 if RepeatRate is small enough that DeltaTime > RepeatRate
---@param key_index number
---@param repeat_delay number
---@param rate number
---@return number
function ImGui:get_key_pressed_amount(key_index, repeat_delay, rate)
    return r.ImGui_GetKeyPressedAmount(self.ctx, key_index, repeat_delay, rate)
end

-- Windows are generally trying to stay within the Work Area of their host viewport.
---@return ImGui_Viewport 
function ImGui:get_main_viewport()
    return r.ImGui_GetMainViewport(self.ctx)
end

---@param button number
---@return number, number 
function ImGui:get_mouse_clicked_pos(button)
    return r.ImGui_GetMouseClickedPos(self.ctx, button)
end

-- Get desired cursor type, reset every frame. This is updated during the frame.
---@return number
function ImGui:get_mouse_cursor()
    return r.ImGui_GetMouseCursor(self.ctx)
end

-- Mouse delta. Note that this is zero if either current or previous position are invalid (-FLT_MAX,-FLT_MAX), so a disappearing/reappearing mouse won't have a huge delta.
---@return number, number 
function ImGui:get_mouse_delta()
    return r.ImGui_GetMouseDelta(self.ctx)
end

-- Duration the mouse button has been down (0.0f == just clicked)
---@param button number
---@return number 
function ImGui:get_mouse_down_duration(button)
    return r.ImGui_GetMouseDownDuration(self.ctx, button)
end

-- Default values: button = ImGui_MouseButton_Left, lock_threshold = -1.0
---@param x number
---@param y number
---@param button_in number
---@param lock_threshold_in number
---@return number, number 
function ImGui:get_mouse_drag_delta(x, y, button_in, lock_threshold_in)
    return r.ImGui_GetMouseDragDelta(self.ctx, x, y, button_in, lock_threshold_in)
end

---@return number, number 
function ImGui:get_mouse_pos()
    return r.ImGui_GetMousePos(self.ctx)
end

-- Retrieve mouse position at the time of opening popup we have BeginPopup() into (helper to avoid user backing that value themselves)
---@return number, number 
function ImGui:get_mouse_pos_on_opening_current_popup()
    return r.ImGui_GetMousePosOnOpeningCurrentPopup(self.ctx)
end

-- Mouse wheel Vertical: 1 unit scrolls about 5 lines text.
---@return number, number 
function ImGui:get_mouse_wheel()
    return r.ImGui_GetMouseWheel(self.ctx)
end

-- Get maximum scrolling amount ~~ ContentSize.x - WindowSize.x - DecorationsSize.x
---@return number 
function ImGui:get_scroll_max_x()
    return r.ImGui_GetScrollMaxX(self.ctx)
end

-- Get maximum scrolling amount ~~ ContentSize.y - WindowSize.y - DecorationsSize.y
---@return number 
function ImGui:get_scroll_max_y()
    return r.ImGui_GetScrollMaxY(self.ctx)
end

-- Get scrolling amount [0 .. GetScrollMaxX()]
---@return number 
function ImGui:get_scroll_x()
    return r.ImGui_GetScrollX(self.ctx)
end

-- Get scrolling amount [0 .. GetScrollMaxY()]
---@return number 
function ImGui:get_scroll_y()
    return r.ImGui_GetScrollY(self.ctx)
end

-- Retrieve style color as stored in ImGuiStyle structure. Use to feed back into PushStyleColor(), Otherwise use ImGui_GetColor() to get style color with style alpha baked in. See ImGui_Col_* for available style colors.
---@param idx number
---@return number
function ImGui:get_style_color(idx)
    return r.ImGui_GetStyleColor(self.ctx, idx)
end

-- Get a string corresponding to the enum value (for display, saving, etc.).
---@return string 
function ImGui:get_style_color_name()
    return r.ImGui_GetStyleColorName(self.ctx)
end

---@param var_idx number
---@return number, number 
function ImGui:get_style_var(var_idx)
    return r.ImGui_GetStyleVar(self.ctx, var_idx)
end

-- Same as ImGui_GetFontSize
---@return number 
function ImGui:get_text_line_height()
    return r.ImGui_GetTextLineHeight(self.ctx)
end

-- ~ FontSize + style.ItemSpacing.y (distance in pixels between 2 consecutive lines of text)
---@return number 
function ImGui:get_text_line_height_with_spacing()
    return r.ImGui_GetTextLineHeightWithSpacing(self.ctx)
end

-- Get global imgui time. Incremented every frame.
---@return number 
function ImGui:get_time()
    return r.ImGui_GetTime(self.ctx)
end

-- Horizontal distance preceding label when using TreeNode*() or Bullet() == (g.FontSize + style.FramePadding.x*2) for a regular unframed TreeNode
---@return number 
function ImGui:get_tree_node_to_label_spacing()
    return r.ImGui_GetTreeNodeToLabelSpacing(self.ctx)
end

---@return string, string 
function ImGui:get_version()
    return r.ImGui_GetVersion(self.ctx)
end

-- Content boundaries max (roughly (0,0)+Size-Scroll) where Size can be override with SetNextWindowContentSize(), in window coordinates
---@return number, number 
function ImGui:get_window_content_region_max()
    return r.ImGui_GetWindowContentRegionMax(self.ctx)
end

-- Content boundaries min (roughly (0,0)-Scroll), in window coordinates
---@return number, number 
function ImGui:get_window_content_region_min()
    return r.ImGui_GetWindowContentRegionMin(self.ctx)
end

---@return number 
function ImGui:get_window_content_region_width()
    return r.ImGui_GetWindowContentRegionWidth(self.ctx)
end

-- See ImGui_SetNextWindowDockID.
---@return number
function ImGui:get_window_dock_i_d()
    return r.ImGui_GetWindowDockID(self.ctx)
end

-- The draw list associated to the current window, to append your own drawing primitives
---@return ImGui_DrawList 
function ImGui:get_window_draw_list()
    return r.ImGui_GetWindowDrawList(self.ctx)
end

-- Get current window height (shortcut for ({ImGui_GetWindowSize()})[2])
---@return number 
function ImGui:get_window_height()
    return r.ImGui_GetWindowHeight(self.ctx)
end

-- Get current window position in screen space (useful if you want to do your own drawing via the DrawList API)
---@return number, number 
function ImGui:get_window_pos()
    return r.ImGui_GetWindowPos(self.ctx)
end

-- Get current window size
---@return number, number 
function ImGui:get_window_size()
    return r.ImGui_GetWindowSize(self.ctx)
end

-- Get current window width (shortcut for ({ImGui_GetWindowSize()})[1])
---@return number 
function ImGui:get_window_width()
    return r.ImGui_GetWindowWidth(self.ctx)
end

-- Return true even if an active item is blocking access to this item/window. Useful for Drag and Drop patterns.
---@return number
function ImGui:hovered_flags_allow_when_blocked_by_active_item()
    return r.ImGui_HoveredFlags_AllowWhenBlockedByActiveItem(self.ctx)
end

-- Return true even if a popup window is normally blocking access to this item/window
---@return number
function ImGui:hovered_flags_allow_when_blocked_by_popup()
    return r.ImGui_HoveredFlags_AllowWhenBlockedByPopup(self.ctx)
end

-- Return true even if the item is disabled
---@return number
function ImGui:hovered_flags_allow_when_disabled()
    return r.ImGui_HoveredFlags_AllowWhenDisabled(self.ctx)
end

-- Return true even if the position is obstructed or overlapped by another window
---@return number
function ImGui:hovered_flags_allow_when_overlapped()
    return r.ImGui_HoveredFlags_AllowWhenOverlapped(self.ctx)
end

-- IsWindowHovered() only: Return true if any window is hovered
---@return number
function ImGui:hovered_flags_any_window()
    return r.ImGui_HoveredFlags_AnyWindow(self.ctx)
end

-- IsWindowHovered() only: Return true if any children of the window is hovered
---@return number
function ImGui:hovered_flags_child_windows()
    return r.ImGui_HoveredFlags_ChildWindows(self.ctx)
end

-- Return true if directly over the item/window, not obstructed by another window, not obstructed by an active popup or modal blocking inputs under them.
---@return number
function ImGui:hovered_flags_none()
    return r.ImGui_HoveredFlags_None(self.ctx)
end

-- ImGui_HoveredFlags_AllowWhenBlockedByPopup | ImGui_HoveredFlags_AllowWhenBlockedByActiveItem | ImGui_HoveredFlags_AllowWhenOverlapped
---@return number
function ImGui:hovered_flags_rect_only()
    return r.ImGui_HoveredFlags_RectOnly(self.ctx)
end

-- ImGui_HoveredFlags_RootWindow | ImGui_HoveredFlags_ChildWindows
---@return number
function ImGui:hovered_flags_root_and_child_windows()
    return r.ImGui_HoveredFlags_RootAndChildWindows(self.ctx)
end

-- IsWindowHovered() only: Test from root window (top most parent of the current hierarchy)
---@return number
function ImGui:hovered_flags_root_window()
    return r.ImGui_HoveredFlags_RootWindow(self.ctx)
end

-- Default values: indent_w = 0.0
---@param indent_w_in number
function ImGui:indent(indent_w_in)
    return r.ImGui_Indent(self.ctx, indent_w_in)
end

-- Default values: step = 0.0, step_fast = 0.0, format = '%.3f', flags = ImGui_InputTextFlags_None
---@param label string
---@param v number
---@param step_in number
---@param step_fast_in number
---@param format_in string
---@param flags number
---@return number 
function ImGui:input_double(label, v, step_in, step_fast_in, format_in, flags)
    local retval, v_ = r.ImGui_InputDouble(self.ctx, label, v, step_in, step_fast_in, format_in, flags)
    if retval then
        return v_
    end
end

-- Default values: format = '%.3f', flags = ImGui_InputTextFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param format_in string
---@param flags number
---@return number, number 
function ImGui:input_double2(label, v1, v2, format_in, flags)
    local retval, v1_, v2_ = r.ImGui_InputDouble2(self.ctx, label, v1, v2, format_in, flags)
    if retval then
        return v1_, v2_
    end
end

-- Default values: format = '%.3f', flags = ImGui_InputTextFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param format_in string
---@param flags number
---@return number, number, number 
function ImGui:input_double3(label, v1, v2, v3, format_in, flags)
    local retval, v1_, v2_, v3_ = r.ImGui_InputDouble3(self.ctx, label, v1, v2, v3, format_in, flags)
    if retval then
        return v1_, v2_, v3_
    end
end

-- Default values: format = '%.3f', flags = ImGui_InputTextFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param format_in string
---@param flags number
---@return number, number, number, number 
function ImGui:input_double4(label, v1, v2, v3, v4, format_in, flags)
    local retval, v1_, v2_, v3_, v4_ = r.ImGui_InputDouble4(self.ctx, label, v1, v2, v3, v4, format_in, flags)
    if retval then
        return v1_, v2_, v3_, v4_
    end
end

-- Default values: step = nil, format = nil, step_fast = nil, format = '%.3f', flags = ImGui_InputTextFlags_None
---@param label string
---@param values reaper_array
---@param ctx ImGui_Context
---@param step_in number
---@param step_fast_in number
---@param format_in string
---@param flags number
---@return boolean 
function ImGui:input_double_n(label, values, ctx, step_in, step_fast_in, format_in, flags)
    return r.ImGui_InputDoubleN(self.ctx, label, values, ctx, step_in, step_fast_in, format_in, flags)
end

-- Default values: step = 1, step_fast = 100, flags = ImGui_InputTextFlags_None
---@param label string
---@param v number
---@param step_in number
---@param step_fast_in number
---@param flags number
---@return number 
function ImGui:input_int(label, v, step_in, step_fast_in, flags)
    local retval, v_ = r.ImGui_InputInt(self.ctx, label, v, step_in, step_fast_in, flags)
    if retval then
        return v_
    end
end

-- Default values: flags = ImGui_InputTextFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param flags number
---@return number, number 
function ImGui:input_int2(label, v1, v2, flags)
    local retval, v1_, v2_ = r.ImGui_InputInt2(self.ctx, label, v1, v2, flags)
    if retval then
        return v1_, v2_
    end
end

-- Default values: flags = ImGui_InputTextFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param flags number
---@return number, number, number 
function ImGui:input_int3(label, v1, v2, v3, flags)
    local retval, v1_, v2_, v3_ = r.ImGui_InputInt3(self.ctx, label, v1, v2, v3, flags)
    if retval then
        return v1_, v2_, v3_
    end
end

-- Default values: flags = ImGui_InputTextFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param flags number
---@return number, number, number, number 
function ImGui:input_int4(label, v1, v2, v3, v4, flags)
    local retval, v1_, v2_, v3_, v4_ = r.ImGui_InputInt4(self.ctx, label, v1, v2, v3, v4, flags)
    if retval then
        return v1_, v2_, v3_, v4_
    end
end

-- Default values: flags = ImGui_InputTextFlags_None
---@param label string
---@param buf string
---@param flags number
---@return string 
function ImGui:input_text(label, buf, flags)
    local retval, buf_ = r.ImGui_InputText(self.ctx, label, buf, flags)
    if retval then
        return buf_
    end
end

-- Pressing TAB input a '\t' character into the text field
---@return number
function ImGui:input_text_flags_allow_tab_input()
    return r.ImGui_InputTextFlags_AllowTabInput(self.ctx)
end

-- Overwrite mode
---@return number
function ImGui:input_text_flags_always_overwrite()
    return r.ImGui_InputTextFlags_AlwaysOverwrite(self.ctx)
end

-- Select entire text when first taking mouse focus
---@return number
function ImGui:input_text_flags_auto_select_all()
    return r.ImGui_InputTextFlags_AutoSelectAll(self.ctx)
end

-- Allow 0123456789.+-*/
---@return number
function ImGui:input_text_flags_chars_decimal()
    return r.ImGui_InputTextFlags_CharsDecimal(self.ctx)
end

-- Allow 0123456789ABCDEFabcdef
---@return number
function ImGui:input_text_flags_chars_hexadecimal()
    return r.ImGui_InputTextFlags_CharsHexadecimal(self.ctx)
end

-- Filter out spaces, tabs
---@return number
function ImGui:input_text_flags_chars_no_blank()
    return r.ImGui_InputTextFlags_CharsNoBlank(self.ctx)
end

-- Allow 0123456789.+-*/eE (Scientific notation input)
---@return number
function ImGui:input_text_flags_chars_scientific()
    return r.ImGui_InputTextFlags_CharsScientific(self.ctx)
end

-- Turn a..z into A..Z
---@return number
function ImGui:input_text_flags_chars_uppercase()
    return r.ImGui_InputTextFlags_CharsUppercase(self.ctx)
end

-- In multi-line mode, unfocus with Enter, add new line with Ctrl+Enter (default is opposite: unfocus with Ctrl+Enter, add line with Enter).
---@return number
function ImGui:input_text_flags_ctrl_enter_for_new_line()
    return r.ImGui_InputTextFlags_CtrlEnterForNewLine(self.ctx)
end

-- Return 'true' when Enter is pressed (as opposed to every time the value was modified). Consider looking at the IsItemDeactivatedAfterEdit() function.
---@return number
function ImGui:input_text_flags_enter_returns_true()
    return r.ImGui_InputTextFlags_EnterReturnsTrue(self.ctx)
end

-- Disable following the cursor horizontally
---@return number
function ImGui:input_text_flags_no_horizontal_scroll()
    return r.ImGui_InputTextFlags_NoHorizontalScroll(self.ctx)
end

-- Disable undo/redo. Note that input text owns the text data while active, if you want to provide your own undo/redo stack you need e.g. to call ClearActiveID().
---@return number
function ImGui:input_text_flags_no_undo_redo()
    return r.ImGui_InputTextFlags_NoUndoRedo(self.ctx)
end

-- Most of the ImGuiInputTextFlags flags are only useful for InputText() and not for InputFloatX, InputIntX, InputDouble etc.
---@return number
function ImGui:input_text_flags_none()
    return r.ImGui_InputTextFlags_None(self.ctx)
end

-- Password mode, display all characters as '*'
---@return number
function ImGui:input_text_flags_password()
    return r.ImGui_InputTextFlags_Password(self.ctx)
end

-- Read-only mode
---@return number
function ImGui:input_text_flags_read_only()
    return r.ImGui_InputTextFlags_ReadOnly(self.ctx)
end

-- Default values: size_w = 0.0, size_h = 0.0, flags = ImGui_InputTextFlags_None
---@param label string
---@param buf string
---@param width number
---@param height number
---@param flags number
---@return string 
function ImGui:input_text_multiline(label, buf, width, height, flags)
    local retval, buf_ = r.ImGui_InputTextMultiline(self.ctx, label, buf, width, height, flags)
    if retval then
        return buf_
    end
end

-- Default values: flags = ImGui_InputTextFlags_None
---@param label string
---@param hint string
---@param buf string
---@param flags number
---@return string 
function ImGui:input_text_with_hint(label, hint, buf, flags)
    local retval, buf_ = r.ImGui_InputTextWithHint(self.ctx, label, hint, buf, flags)
    if retval then
        return buf_
    end
end

-- Default values: flags = ImGui_ButtonFlags_None
---@param str_id string
---@param size_w number
---@param size_h number
---@param flags number
---@return boolean 
function ImGui:invisible_button(str_id, size_w, size_h, flags)
    return r.ImGui_InvisibleButton(self.ctx, str_id, size_w, size_h, flags)
end

-- is any item active?
---@return boolean 
function ImGui:is_any_item_active()
    return r.ImGui_IsAnyItemActive(self.ctx)
end

-- is any item focused?
---@return boolean 
function ImGui:is_any_item_focused()
    return r.ImGui_IsAnyItemFocused(self.ctx)
end

-- is any item hovered?
---@return boolean 
function ImGui:is_any_item_hovered()
    return r.ImGui_IsAnyItemHovered(self.ctx)
end

-- Is any mouse button held?
---@return boolean 
function ImGui:is_any_mouse_down()
    return r.ImGui_IsAnyMouseDown(self.ctx)
end

-- Was the last item just made active (item was previously inactive).
---@return boolean 
function ImGui:is_item_activated()
    return r.ImGui_IsItemActivated(self.ctx)
end

-- Is the last item active? (e.g. button being held, text field being edited. This will continuously return true while holding mouse button on an item. Items that don't interact will always return false)
---@return boolean 
function ImGui:is_item_active()
    return r.ImGui_IsItemActive(self.ctx)
end

-- Default values: mouse_button = ImGui_MouseButton_Left
---@param mouse_button_in number
---@return boolean 
function ImGui:is_item_clicked(mouse_button_in)
    return r.ImGui_IsItemClicked(self.ctx, mouse_button_in)
end

-- Was the last item just made inactive (item was previously active). Useful for Undo/Redo patterns with widgets that requires continuous editing.
---@return boolean 
function ImGui:is_item_deactivated()
    return r.ImGui_IsItemDeactivated(self.ctx)
end

-- Was the last item just made inactive and made a value change when it was active? (e.g. Slider/Drag moved). Useful for Undo/Redo patterns with widgets that requires continuous editing. Note that you may get false positives (some widgets such as Combo()/ListBox()/Selectable() will return true even when clicking an already selected item).
---@return boolean 
function ImGui:is_item_deactivated_after_edit()
    return r.ImGui_IsItemDeactivatedAfterEdit(self.ctx)
end

-- Did the last item modify its underlying value this frame? or was pressed? This is generally the same as the "bool" return value of many widgets.
---@return boolean 
function ImGui:is_item_edited()
    return r.ImGui_IsItemEdited(self.ctx)
end

-- Is the last item focused for keyboard/gamepad navigation?
---@return boolean 
function ImGui:is_item_focused()
    return r.ImGui_IsItemFocused(self.ctx)
end

-- Default values: flags = ImGui_HoveredFlags_None
---@param flags number
---@return boolean 
function ImGui:is_item_hovered(flags)
    return r.ImGui_IsItemHovered(self.ctx, flags)
end

-- Was the last item open state toggled? Set by TreeNode().
---@return boolean 
function ImGui:is_item_toggled_open()
    return r.ImGui_IsItemToggledOpen(self.ctx)
end

-- Is the last item visible? (items may be out of sight because of clipping/scrolling)
---@return boolean 
function ImGui:is_item_visible()
    return r.ImGui_IsItemVisible(self.ctx)
end

-- Is key being held.
---@param key_code number
---@return boolean 
function ImGui:is_key_down(key_code)
    return r.ImGui_IsKeyDown(self.ctx, key_code)
end

-- Default values: repeat = true
---@param key_code number
---@param repeat_in boolean
---@return boolean 
function ImGui:is_key_pressed(key_code, repeat_in)
    return r.ImGui_IsKeyPressed(self.ctx, key_code, repeat_in)
end

-- Was key released (went from Down to !Down)?
---@param key_code number
---@return boolean 
function ImGui:is_key_released(key_code)
    return r.ImGui_IsKeyReleased(self.ctx, key_code)
end

-- Default values: repeat = false
---@param button number
---@param repeat_in boolean
---@return boolean 
function ImGui:is_mouse_clicked(button, repeat_in)
    return r.ImGui_IsMouseClicked(self.ctx, button, repeat_in)
end

-- Did mouse button double-clicked? (note that a double-click will also report IsMouseClicked() == true)
---@param button number
---@return boolean 
function ImGui:is_mouse_double_clicked(button)
    button = button or 0
    return r.ImGui_IsMouseDoubleClicked(self.ctx, button)
end

-- Is mouse button held?
---@param button number
---@return boolean 
function ImGui:is_mouse_down(button)
    return r.ImGui_IsMouseDown(self.ctx, button)
end

-- Default values: lock_threshold = -1.0
---@param button number
---@param lock_threshold_in number
---@return boolean 
function ImGui:is_mouse_dragging(button, lock_threshold_in)
    return r.ImGui_IsMouseDragging(self.ctx, button, lock_threshold_in)
end

-- Default values: clip = true
---@param r_min_x number
---@param r_min_y number
---@param r_max_x number
---@param r_max_y number
---@param clip_in boolean
---@return boolean 
function ImGui:is_mouse_hovering_rect(r_min_x, r_min_y, r_max_x, r_max_y, clip_in)
    return r.ImGui_IsMouseHoveringRect(self.ctx, r_min_x, r_min_y, r_max_x, r_max_y, clip_in)
end

-- Default values: mouse_pos_x = nil, mouse_pos_y = nil
---@param mouse_pos_x_in number
---@param mouse_pos_y_in number
---@return boolean 
function ImGui:is_mouse_pos_valid(mouse_pos_x_in, mouse_pos_y_in)
    return r.ImGui_IsMousePosValid(self.ctx, mouse_pos_x_in, mouse_pos_y_in)
end

-- Did mouse button released? (went from Down to !Down)
---@param button number
---@return boolean 
function ImGui:is_mouse_released(button)
    return r.ImGui_IsMouseReleased(self.ctx, button)
end

-- Default values: flags = ImGui_PopupFlags_None
---@param str_id string
---@param flags number
---@return boolean 
function ImGui:is_popup_open(str_id, flags)
    return r.ImGui_IsPopupOpen(self.ctx, str_id, flags)
end

-- Test if rectangle (of given size, starting from cursor position) is visible / not clipped.
---@param size_w number
---@param size_h number
---@return boolean 
function ImGui:is_rect_visible(size_w, size_h)
    return r.ImGui_IsRectVisible(self.ctx, size_w, size_h)
end

-- Test if rectangle (in screen space) is visible / not clipped. to perform coarse clipping on user's side.
---@param rect_min_x number
---@param rect_min_y number
---@param rect_max_x number
---@param rect_max_y number
---@return boolean 
function ImGui:is_rect_visible_ex(rect_min_x, rect_min_y, rect_max_x, rect_max_y)
    return r.ImGui_IsRectVisibleEx(self.ctx, rect_min_x, rect_min_y, rect_max_x, rect_max_y)
end

---@return boolean 
function ImGui:is_window_appearing()
    return r.ImGui_IsWindowAppearing(self.ctx)
end

---@return boolean 
function ImGui:is_window_collapsed()
    return r.ImGui_IsWindowCollapsed(self.ctx)
end

-- Is current window docked into another window?
---@return boolean 
function ImGui:is_window_docked()
    return r.ImGui_IsWindowDocked(self.ctx)
end

-- Default values: flags = ImGui_FocusedFlags_None
---@param flags number
---@return boolean 
function ImGui:is_window_focused(flags)
    return r.ImGui_IsWindowFocused(self.ctx, flags)
end

-- Default values: flags = ImGui_HoveredFlags_None
---@param flags number
---@return boolean 
function ImGui:is_window_hovered(flags)
    return r.ImGui_IsWindowHovered(self.ctx, flags)
end

---@return number
function ImGui:key_mod_flags_alt()
    return r.ImGui_KeyModFlags_Alt(self.ctx)
end

---@return number
function ImGui:key_mod_flags_ctrl()
    return r.ImGui_KeyModFlags_Ctrl(self.ctx)
end

---@return number
function ImGui:key_mod_flags_none()
    return r.ImGui_KeyModFlags_None(self.ctx)
end

---@return number
function ImGui:key_mod_flags_shift()
    return r.ImGui_KeyModFlags_Shift(self.ctx)
end

---@return number
function ImGui:key_mod_flags_super()
    return r.ImGui_KeyModFlags_Super(self.ctx)
end

-- Display text+label aligned the same way as value+label widgets
---@param label string
---@param text string
function ImGui:label_text(label, text)
    return r.ImGui_LabelText(self.ctx, label, text)
end

-- Default values: height_in_items = -1
---@param label string
---@param current_item number
---@param items string
---@param height_in_items_in number
---@return number, string 
function ImGui:list_box(label, current_item, items, height_in_items_in)
    local retval, current_item_, items_ = r.ImGui_ListBox(self.ctx, label, current_item, items, height_in_items_in)
    if retval then
        return current_item_, items_
    end
end

-- Default values: items_height = -1.0
---@param items_count number
---@param items_height_in number
function ImGui:list_clipper_begin(items_count, items_height_in)
    return r.ImGui_ListClipper_Begin(self.ctx, items_count, items_height_in)
end

-- Automatically called on the last call of Step() that returns false. See ImGui_ListClipper_Step.
function ImGui:list_clipper_end()
    return r.ImGui_ListClipper_End(self.ctx)
end

---@return number, number 
function ImGui:list_clipper_get_display_range()
    return r.ImGui_ListClipper_GetDisplayRange(self.ctx)
end

-- Call until it returns false. The DisplayStart/DisplayEnd fields will be set and you can process/draw those items.
---@return boolean 
function ImGui:list_clipper_step()
    return r.ImGui_ListClipper_Step(self.ctx)
end

-- Stop logging (close file, etc.)
function ImGui:log_finish()
    return r.ImGui_LogFinish(self.ctx)
end

-- Pass text data straight to log (without being displayed)
---@param text string
function ImGui:log_text(text)
    return r.ImGui_LogText(self.ctx, text)
end

-- Default values: auto_open_depth = -1
---@param auto_open_depth_in number
function ImGui:log_to_clipboard(auto_open_depth_in)
    return r.ImGui_LogToClipboard(self.ctx, auto_open_depth_in)
end

-- Default values: auto_open_depth = -1, filename = nil
---@param auto_open_depth_in number
---@param filename_in string
function ImGui:log_to_file(auto_open_depth_in, filename_in)
    return r.ImGui_LogToFile(self.ctx, auto_open_depth_in, filename_in)
end

-- Default values: auto_open_depth = -1
---@param auto_open_depth_in number
function ImGui:log_to_t_t_y(auto_open_depth_in)
    return r.ImGui_LogToTTY(self.ctx, auto_open_depth_in)
end

-- Default values: enabled = true
---@param label string
---@param shortcut_in string
---@param p_selected boolean
---@param enabled_in boolean
---@return boolean 
function ImGui:menu_item(label, shortcut_in, p_selected, enabled_in)
    local retval, p_selected_ = r.ImGui_MenuItem(self.ctx, label, shortcut_in, p_selected, enabled_in)
    if retval then
        return p_selected_
    end
end

---@return number
function ImGui:mouse_button_left()
    return r.ImGui_MouseButton_Left(self.ctx)
end

---@return number
function ImGui:mouse_button_middle()
    return r.ImGui_MouseButton_Middle(self.ctx)
end

---@return number
function ImGui:mouse_button_right()
    return r.ImGui_MouseButton_Right(self.ctx)
end

---@return number
function ImGui:mouse_cursor_arrow()
    return r.ImGui_MouseCursor_Arrow(self.ctx)
end

-- (Unused by Dear ImGui functions. Use for e.g. hyperlinks)
---@return number
function ImGui:mouse_cursor_hand()
    return r.ImGui_MouseCursor_Hand(self.ctx)
end

-- When hovering something with disallowed interaction. Usually a crossed circle.
---@return number
function ImGui:mouse_cursor_not_allowed()
    return r.ImGui_MouseCursor_NotAllowed(self.ctx)
end

-- (Unused by Dear ImGui functions)
---@return number
function ImGui:mouse_cursor_resize_all()
    return r.ImGui_MouseCursor_ResizeAll(self.ctx)
end

-- When hovering over a vertical border or a column
---@return number
function ImGui:mouse_cursor_resize_e_w()
    return r.ImGui_MouseCursor_ResizeEW(self.ctx)
end

-- When hovering over the bottom-left corner of a window
---@return number
function ImGui:mouse_cursor_resize_n_e_s_w()
    return r.ImGui_MouseCursor_ResizeNESW(self.ctx)
end

-- When hovering over an horizontal border
---@return number
function ImGui:mouse_cursor_resize_n_s()
    return r.ImGui_MouseCursor_ResizeNS(self.ctx)
end

-- When hovering over the bottom-right corner of a window
---@return number
function ImGui:mouse_cursor_resize_n_w_s_e()
    return r.ImGui_MouseCursor_ResizeNWSE(self.ctx)
end

-- When hovering over InputText, etc.
---@return number
function ImGui:mouse_cursor_text_input()
    return r.ImGui_MouseCursor_TextInput(self.ctx)
end

-- Undo a SameLine() or force a new line when in an horizontal-layout context.
function ImGui:new_line()
    return r.ImGui_NewLine(self.ctx)
end

-- Returns FLT_MIN and FLT_MAX for this system.
---@return number, number 
function ImGui:numeric_limits_float()
    return r.ImGui_NumericLimits_Float()
end

-- Default values: popup_flags = ImGui_PopupFlags_None
---@param str_id string
---@param popup_flags number
function ImGui:open_popup(str_id, popup_flags)
    return r.ImGui_OpenPopup(self.ctx, str_id, popup_flags)
end

-- Default values: str_id = nil, popup_flags = ImGui_PopupFlags_MouseButtonRight
---@param str_id_in string
---@param popup_flags number
function ImGui:open_popup_on_item_click(str_id_in, popup_flags)
    return r.ImGui_OpenPopupOnItemClick(self.ctx, str_id_in, popup_flags)
end

-- Note: Anti-aliased filling requires points to be in clockwise order.
---@param col_rgba number
function ImGui:path_fill_convex(col_rgba)
    return r.ImGui_PathFillConvex(self.ctx, col_rgba)
end

-- Default values: values_offset = 0, overlay_text = nil, scale_min = FLT_MAX, scale_max = FLT_MAX, graph_size_w = 0.0, graph_size_h = 0.0
---@param label string
---@param values reaper_array
---@param ctx ImGui_Context
---@param values_offset_in number
---@param overlay_text_in string
---@param scale_min_in number
---@param scale_max_in number
---@param graph_width number
---@param graph_height number
function ImGui:plot_histogram(label, values, ctx, values_offset_in, overlay_text_in, scale_min_in, scale_max_in, graph_width, graph_height)
    return r.ImGui_PlotHistogram(self.ctx, label, values, ctx, values_offset_in, overlay_text_in, scale_min_in, scale_max_in, graph_width, graph_height)
end

-- Default values: values_offset = 0, overlay_text = nil, scale_min = 0.0, scale_max = 0.0, graph_size_w = 0.0, graph_size_h = 0.0
---@param label string
---@param values reaper_array
---@param ctx ImGui_Context
---@param values_offset_in number
---@param overlay_text_in string
---@param scale_min_in number
---@param scale_max_in number
---@param graph_width number
---@param graph_height number
function ImGui:plot_lines(label, values, ctx, values_offset_in, overlay_text_in, scale_min_in, scale_max_in, graph_width, graph_height)
    return r.ImGui_PlotLines(self.ctx, label, values, ctx, values_offset_in, overlay_text_in, scale_min_in, scale_max_in, graph_width, graph_height)
end

-- See ImGui_PushAllowKeyboardFocus
function ImGui:pop_allow_keyboard_focus()
    return r.ImGui_PopAllowKeyboardFocus(self.ctx)
end

-- See ImGui_PushButtonRepeat
function ImGui:pop_button_repeat()
    return r.ImGui_PopButtonRepeat(self.ctx)
end

-- See ImGui_PushClipRect
function ImGui:pop_clip_rect()
    return r.ImGui_PopClipRect(self.ctx)
end

-- See ImGui_PushFont.
function ImGui:pop_font()
    return r.ImGui_PopFont(self.ctx)
end

-- Pop from the ID stack.
function ImGui:pop_i_d()
    return r.ImGui_PopID(self.ctx)
end

-- See ImGui_PushItemWidth
function ImGui:pop_item_width()
    return r.ImGui_PopItemWidth(self.ctx)
end

-- Default values: count = 1
---@param count_in number
function ImGui:pop_style_color(count_in)
    return r.ImGui_PopStyleColor(self.ctx, count_in)
end

-- Default values: count = 1
---@param count_in number
function ImGui:pop_style_var(count_in)
    return r.ImGui_PopStyleVar(self.ctx, count_in)
end

function ImGui:pop_text_wrap_pos()
    return r.ImGui_PopTextWrapPos(self.ctx)
end

-- ImGuiPopupFlags_AnyPopupId | ImGuiPopupFlags_AnyPopupLevel
---@return number
function ImGui:popup_flags_any_popup()
    return r.ImGui_PopupFlags_AnyPopup(self.ctx)
end

-- For IsPopupOpen(): ignore the ImGuiID parameter and test for any popup.
---@return number
function ImGui:popup_flags_any_popup_id()
    return r.ImGui_PopupFlags_AnyPopupId(self.ctx)
end

-- For IsPopupOpen(): search/test at any level of the popup stack (default test in the current level)
---@return number
function ImGui:popup_flags_any_popup_level()
    return r.ImGui_PopupFlags_AnyPopupLevel(self.ctx)
end

-- For BeginPopupContext*(): open on Left Mouse release. Guaranteed to always be == 0 (same as ImGuiMouseButton_Left)
---@return number
function ImGui:popup_flags_mouse_button_left()
    return r.ImGui_PopupFlags_MouseButtonLeft(self.ctx)
end

-- For BeginPopupContext*(): open on Middle Mouse release. Guaranteed to always be == 2 (same as ImGuiMouseButton_Middle)
---@return number
function ImGui:popup_flags_mouse_button_middle()
    return r.ImGui_PopupFlags_MouseButtonMiddle(self.ctx)
end

-- For BeginPopupContext*(): open on Right Mouse release. Guaranteed to always be == 1 (same as ImGuiMouseButton_Right)
---@return number
function ImGui:popup_flags_mouse_button_right()
    return r.ImGui_PopupFlags_MouseButtonRight(self.ctx)
end

-- For OpenPopup*(), BeginPopupContext*(): don't open if there's already a popup at the same level of the popup stack
---@return number
function ImGui:popup_flags_no_open_over_existing_popup()
    return r.ImGui_PopupFlags_NoOpenOverExistingPopup(self.ctx)
end

-- For BeginPopupContextWindow(): don't return true when hovering items, only when hovering empty space
---@return number
function ImGui:popup_flags_no_open_over_items()
    return r.ImGui_PopupFlags_NoOpenOverItems(self.ctx)
end

-- Flags: for OpenPopup*(), BeginPopupContext*(), IsPopupOpen()
---@return number
function ImGui:popup_flags_none()
    return r.ImGui_PopupFlags_None(self.ctx)
end

-- Default values: size_arg_w = -FLT_MIN, size_arg_h = 0.0, overlay = nil
---@param fraction number
---@param size_arg_w_in number
---@param size_arg_h_in number
---@param overlay_in string
function ImGui:progress_bar(fraction, size_arg_w_in, size_arg_h_in, overlay_in)
    return r.ImGui_ProgressBar(self.ctx, fraction, size_arg_w_in, size_arg_h_in, overlay_in)
end

-- Allow focusing using TAB/Shift-TAB, enabled by default but you can disable it for certain widgets
---@param allow_keyboard_focus boolean
function ImGui:push_allow_keyboard_focus(allow_keyboard_focus)
    return r.ImGui_PushAllowKeyboardFocus(self.ctx, allow_keyboard_focus)
end

-- In 'repeat' mode, Button*() functions return repeated true in a typematic manner (using io.KeyRepeatDelay/io.KeyRepeatRate setting). Note that you can call IsItemActive() after any Button() to tell if the button is held in the current frame.
---@param repeat_ boolean
function ImGui:push_button_repeat(repeat_)
    return r.ImGui_PushButtonRepeat(self.ctx, repeat_)
end

-- Mouse hovering is affected by ImGui::PushClipRect() calls, unlike direct calls to ImDrawList::PushClipRect() which are render only. See ImGui_PopClipRect.
---@param clip_rect_min_x number
---@param clip_rect_min_y number
---@param clip_rect_max_x number
---@param clip_rect_max_y number
---@param intersect_with_current_clip_rect boolean
function ImGui:push_clip_rect(clip_rect_min_x, clip_rect_min_y, clip_rect_max_x, clip_rect_max_y, intersect_with_current_clip_rect)
    return r.ImGui_PushClipRect(self.ctx, clip_rect_min_x, clip_rect_min_y, clip_rect_max_x, clip_rect_max_y, intersect_with_current_clip_rect)
end

-- Change the current font. Use nil to push the default font. See ImGui_PopFont.
---@param font ImGui_Font
---@param retval ReaType
function ImGui:push_font(font, retval)
    return r.ImGui_PushFont(self.ctx, font, retval)
end

-- You can also use the "Label##foobar" syntax within widget label to distinguish them from each others.
---@param str_id string
function ImGui:push_i_d(str_id)
    return r.ImGui_PushID(self.ctx, str_id)
end

-- Push width of items for common large "item+label" widgets. >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -FLT_MIN always align width to the right side). 0.0f = default to ~2/3 of windows width,
---@param item_width number
function ImGui:push_item_width(item_width)
    return r.ImGui_PushItemWidth(self.ctx, item_width)
end

-- Modify a style color. Call ImGui_PopStyleColor to undo after use (before the end of the frame). See ImGui_Col_* for available style colors.
---@param idx number
---@param col_rgba number
function ImGui:push_style_color(idx, col_rgba)
    return r.ImGui_PushStyleColor(self.ctx, idx, col_rgba)
end

-- Default values: val2 = nil
---@param var_idx number
---@param val1 number
---@param val2_in number
function ImGui:push_style_var(var_idx, val1, val2_in)
    return r.ImGui_PushStyleVar(self.ctx, var_idx, val1, val2_in)
end

-- Default values: wrap_local_pos_x = 0.0
---@param wrap_local_pos_x_in number
function ImGui:push_text_wrap_pos(wrap_local_pos_x_in)
    return r.ImGui_PushTextWrapPos(self.ctx, wrap_local_pos_x_in)
end

-- Use with e.g. if (RadioButton("one", my_value==1)) { my_value = 1; }
---@param label string
---@param active boolean
---@return boolean 
function ImGui:radio_button(label, active)
    return r.ImGui_RadioButton(self.ctx, label, active)
end

-- Shortcut to handle RadioButton's example pattern when value is an number
---@param label string
---@param v number
---@param v_button number
---@return number 
function ImGui:radio_button_ex(label, v, v_button)
    local retval, v_ = r.ImGui_RadioButtonEx(self.ctx, label, v, v_button)
    if retval then
        return v_
    end
end

-- Default values: button = ImGui_MouseButton_Left
---@param button_in number
function ImGui:reset_mouse_drag_delta(button_in)
    return r.ImGui_ResetMouseDragDelta(self.ctx, button_in)
end

-- Default values: offset_from_start_x = 0.0, spacing = -1.0.
---@param offset_from_start_x_in number
---@param spacing_in number
function ImGui:same_line(offset_from_start_x_in, spacing_in)
    return r.ImGui_SameLine(self.ctx, offset_from_start_x_in, spacing_in)
end

-- Default values: flags = ImGui_SelectableFlags_None, size_w = 0.0, size_h = 0.0
---@param label string
---@param p_selected boolean
---@param flags number
---@param width number
---@param height number
---@return boolean 
function ImGui:selectable(label, p_selected, flags, width, height)
    local retval, p_selected_ = r.ImGui_Selectable(self.ctx, label, p_selected, flags, width, height)
    if retval then
        return p_selected_
    end
end

-- Generate press events on double clicks too
---@return number
function ImGui:selectable_flags_allow_double_click()
    return r.ImGui_SelectableFlags_AllowDoubleClick()
end

-- Hit testing to allow subsequent widgets to overlap this one
---@return number
function ImGui:selectable_flags_allow_item_overlap()
    return r.ImGui_SelectableFlags_AllowItemOverlap()
end

-- Cannot be selected, display grayed out text
---@return number
function ImGui:selectable_flags_disabled()
    return r.ImGui_SelectableFlags_Disabled()
end

-- Clicking this don't close parent popup window
---@return number
function ImGui:selectable_flags_dont_close_popups()
    return r.ImGui_SelectableFlags_DontClosePopups()
end

-- Flags: for Selectable()
---@return number
function ImGui:selectable_flags_none()
    return r.ImGui_SelectableFlags_None()
end

-- Selectable frame can span all columns (text will still fit in current column)
---@return number
function ImGui:selectable_flags_span_all_columns()
    return r.ImGui_SelectableFlags_SpanAllColumns()
end

-- Separator, generally horizontal. inside a menu bar or in horizontal layout mode, this becomes a vertical separator.
function ImGui:separator()
    return r.ImGui_Separator(self.ctx)
end

-- See also the ImGui_LogToClipboard function to capture GUI into clipboard, or easily output text data to the clipboard.
---@param text string
function ImGui:set_clipboard_text(text)
    return r.ImGui_SetClipboardText(self.ctx, text)
end

-- Picker type, etc. User will be able to change many settings, unless you pass the _NoOptions flag to your calls.
---@param flags number
function ImGui:set_color_edit_options(flags)
    return r.ImGui_SetColorEditOptions(self.ctx, flags)
end

-- See ImGui_GetConfigFlags, ImGui_ConfigFlags_*.
---@param flags number
function ImGui:set_config_flags(flags)
    return r.ImGui_SetConfigFlags(self.ctx, flags)
end

-- Cursor position in window
---@param local_pos_x number
---@param local_pos_y number
function ImGui:set_cursor_pos(local_pos_x, local_pos_y)
    return r.ImGui_SetCursorPos(self.ctx, local_pos_x, local_pos_y)
end

-- Cursor X position in window
---@param local_x number
function ImGui:set_cursor_pos_x(local_x)
    return r.ImGui_SetCursorPosX(self.ctx, local_x)
end

-- Cursor Y position in window
---@param local_y number
function ImGui:set_cursor_pos_y(local_y)
    return r.ImGui_SetCursorPosY(self.ctx, local_y)
end

-- Cursor position in absolute screen coordinates [0..io.DisplaySize]
---@param pos_x number
---@param pos_y number
function ImGui:set_cursor_screen_pos(pos_x, pos_y)
    return r.ImGui_SetCursorScreenPos(self.ctx, pos_x, pos_y)
end

-- Default values: cond = ImGui_Cond_Always
---@param type string
---@param data string
---@param cond_in number
---@return boolean 
function ImGui:set_drag_drop_payload(type, data, cond_in)
    return r.ImGui_SetDragDropPayload(self.ctx, type, data, cond_in)
end

-- Allow last item to be overlapped by a subsequent item. sometimes useful with invisible buttons, selectables, etc. to catch unused area.
function ImGui:set_item_allow_overlap()
    return r.ImGui_SetItemAllowOverlap(self.ctx)
end

-- Prefer using "SetItemDefaultFocus()" over "if (IsWindowAppearing()) SetScrollHereY()" when applicable to signify "this is the default item"
function ImGui:set_item_default_focus()
    return r.ImGui_SetItemDefaultFocus(self.ctx)
end

-- Default values: offset = 0
---@param offset_in number
function ImGui:set_keyboard_focus_here(offset_in)
    return r.ImGui_SetKeyboardFocusHere(self.ctx, offset_in)
end

-- Set desired cursor type
---@param cursor_type number
function ImGui:set_mouse_cursor(cursor_type)
    return r.ImGui_SetMouseCursor(self.ctx, cursor_type)
end

-- Default values: cond = ImGui_Cond_Always.
---@param is_open boolean
---@param cond_in number
function ImGui:set_next_item_open(is_open, cond_in)
    return r.ImGui_SetNextItemOpen(self.ctx, is_open, cond_in)
end

-- Set width of the _next_ common large "item+label" widget. >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -FLT_MIN always align width to the right side)
---@param item_width number
function ImGui:set_next_item_width(item_width)
    return r.ImGui_SetNextItemWidth(self.ctx, item_width)
end

-- Set next window background color alpha. helper to easily override the Alpha component of ImGuiCol_WindowBg/ChildBg/PopupBg. you may also use ImGui_WindowFlags_NoBackground.
---@param alpha number
function ImGui:set_next_window_bg_alpha(alpha)
    return r.ImGui_SetNextWindowBgAlpha(self.ctx, alpha)
end

-- Default values: cond = ImGui_Cond_Always
---@param collapsed boolean
---@param cond_in number
function ImGui:set_next_window_collapsed(collapsed, cond_in)
    return r.ImGui_SetNextWindowCollapsed(self.ctx, collapsed, cond_in)
end

-- Set next window content size (~ scrollable client area, which enforce the range of scrollbars). Not including window decorations (title bar, menu bar, etc.) nor WindowPadding. set an axis to 0.0f to leave it automatic. Call before Begin().
---@param size_w number
---@param size_h number
function ImGui:set_next_window_content_size(size_w, size_h)
    return r.ImGui_SetNextWindowContentSize(self.ctx, size_w, size_h)
end

-- Default values: cond = ImGui_Cond_Always
---@param dock_id number
---@param cond_in number
function ImGui:set_next_window_dock_i_d(dock_id, cond_in)
    return r.ImGui_SetNextWindowDockID(self.ctx, dock_id, cond_in)
end

-- Set next window to be focused / top-most. Call before Begin().
function ImGui:set_next_window_focus()
    return r.ImGui_SetNextWindowFocus(self.ctx)
end

-- Default values: cond = ImGui_Cond_Always, pivot_x = 0.0, pivot_y = 0.0
---@param pos_x number
---@param pos_y number
---@param cond_in number
---@param pivot_x_in number
---@param pivot_y_in number
function ImGui:set_next_window_pos(pos_x, pos_y, cond_in, pivot_x_in, pivot_y_in)
    return r.ImGui_SetNextWindowPos(self.ctx, pos_x, pos_y, cond_in, pivot_x_in, pivot_y_in)
end

-- Default values: cond = ImGui_Cond_Always
---@param size_w number
---@param size_h number
---@param cond_in number
function ImGui:set_next_window_size(size_w, size_h, cond_in)
    return r.ImGui_SetNextWindowSize(self.ctx, size_w, size_h, cond_in)
end

-- Set next window size limits. use -1,-1 on either X/Y axis to preserve the current size. Sizes will be rounded down.
---@param size_min_w number
---@param size_min_h number
---@param size_max_w number
---@param size_max_h number
function ImGui:set_next_window_size_constraints(size_min_w, size_min_h, size_max_w, size_max_h)
    return r.ImGui_SetNextWindowSizeConstraints(self.ctx, size_min_w, size_min_h, size_max_w, size_max_h)
end

-- Default values: center_x_ratio = 0.5
---@param local_x number
---@param center_x_ratio_in number
function ImGui:set_scroll_from_pos_x(local_x, center_x_ratio_in)
    return r.ImGui_SetScrollFromPosX(self.ctx, local_x, center_x_ratio_in)
end

-- Default values: center_y_ratio = 0.5
---@param local_y number
---@param center_y_ratio_in number
function ImGui:set_scroll_from_pos_y(local_y, center_y_ratio_in)
    return r.ImGui_SetScrollFromPosY(self.ctx, local_y, center_y_ratio_in)
end

-- Default values: center_x_ratio = 0.5
---@param center_x_ratio_in number
function ImGui:set_scroll_here_x(center_x_ratio_in)
    return r.ImGui_SetScrollHereX(self.ctx, center_x_ratio_in)
end

-- Default values: center_y_ratio = 0.5
---@param center_y_ratio_in number
function ImGui:set_scroll_here_y(center_y_ratio_in)
    return r.ImGui_SetScrollHereY(self.ctx, center_y_ratio_in)
end

-- Set scrolling amount [0 .. GetScrollMaxX()]
---@param scroll_x number
function ImGui:set_scroll_x(scroll_x)
    return r.ImGui_SetScrollX(self.ctx, scroll_x)
end

-- Set scrolling amount [0 .. GetScrollMaxY()]
---@param scroll_y number
function ImGui:set_scroll_y(scroll_y)
    return r.ImGui_SetScrollY(self.ctx, scroll_y)
end

-- Notify TabBar or Docking system of a closed tab/window ahead (useful to reduce visual flicker on reorderable tab bars). For tab-bar: call after BeginTabBar() and before Tab submissions. Otherwise call with a window name.
---@param tab_or_docked_window_label string
function ImGui:set_tab_item_closed(tab_or_docked_window_label)
    return r.ImGui_SetTabItemClosed(self.ctx, tab_or_docked_window_label)
end

-- Set a text-only tooltip, typically use with ImGui_IsItemHovered(). override any previous call to SetTooltip().
---@param text string
function ImGui:set_tooltip(text)
    return r.ImGui_SetTooltip(self.ctx, text)
end

-- Default values: cond = ImGui_Cond_Always
---@param collapsed boolean
---@param cond_in number
function ImGui:set_window_collapsed(collapsed, cond_in)
    return r.ImGui_SetWindowCollapsed(self.ctx, collapsed, cond_in)
end

-- Default values: cond = ImGui_Cond_Always
---@param name string
---@param collapsed boolean
---@param cond_in number
function ImGui:set_window_collapsed_ex(name, collapsed, cond_in)
    return r.ImGui_SetWindowCollapsedEx(self.ctx, name, collapsed, cond_in)
end

-- (Not recommended) Set current window to be focused / top-most. Prefer using ImGui_SetNextWindowFocus().
function ImGui:set_window_focus()
    return r.ImGui_SetWindowFocus(self.ctx)
end

-- Set named window to be focused / top-most. Use an empty name to remove focus.
---@param name string
function ImGui:set_window_focus_ex(name)
    return r.ImGui_SetWindowFocusEx(self.ctx, name)
end

-- Default values: cond = ImGui_Cond_Always
---@param pos_x number
---@param pos_y number
---@param cond_in number
function ImGui:set_window_pos(pos_x, pos_y, cond_in)
    return r.ImGui_SetWindowPos(self.ctx, pos_x, pos_y, cond_in)
end

-- Default values: cond = ImGui_Cond_Always
---@param name string
---@param pos_x number
---@param pos_y number
---@param cond_in number
function ImGui:set_window_pos_ex(name, pos_x, pos_y, cond_in)
    return r.ImGui_SetWindowPosEx(self.ctx, name, pos_x, pos_y, cond_in)
end

-- Default values: cond = ImGui_Cond_Always
---@param size_w number
---@param size_h number
---@param cond_in number
function ImGui:set_window_size(size_w, size_h, cond_in)
    return r.ImGui_SetWindowSize(self.ctx, size_w, size_h, cond_in)
end

-- Default values: cond = ImGui_Cond_Always
---@param name string
---@param size_w number
---@param size_h number
---@param cond_in number
function ImGui:set_window_size_ex(name, size_w, size_h, cond_in)
    return r.ImGui_SetWindowSizeEx(self.ctx, name, size_w, size_h, cond_in)
end

-- Create Metrics/Debugger window. Display Dear ImGui internals: windows, draw commands, various internal state, etc. Set p_open to true to enable the close button.
---@return boolean 
function ImGui:show_metrics_window()
    return r.ImGui_ShowMetricsWindow(self.ctx)
end

-- Default values: v_degrees_min = -360.0, v_degrees_max = +360.0, format = '%.0f deg', flags = ImGui_SliderFlags_None
---@param label string
---@param v_rad number
---@param v_degrees_min_in number
---@param v_degrees_max_in number
---@param format_in string
---@param flags number
---@return number 
function ImGui:slider_angle(label, v_rad, v_degrees_min_in, v_degrees_max_in, format_in, flags)
    local retval, v_rad_ = r.ImGui_SliderAngle(self.ctx, label, v_rad, v_degrees_min_in, v_degrees_max_in, format_in, flags)
    if retval then
        return v_rad_
    end
end

-- Default values: format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param v number
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return number 
function ImGui:slider_double(label, v, v_min, v_max, format_in, flags)
    local retval, v_ = r.ImGui_SliderDouble(self.ctx, label, v, v_min, v_max, format_in, flags)
    if retval then
        return v_
    end
end

-- Default values: format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return number, number 
function ImGui:slider_double2(label, v1, v2, v_min, v_max, format_in, flags)
    local retval, v1_, v2_ = r.ImGui_SliderDouble2(self.ctx, label, v1, v2, v_min, v_max, format_in, flags)
    if retval then
        return v1_, v2_
    end
end

-- Default values: format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return number, number, number 
function ImGui:slider_double3(label, v1, v2, v3, v_min, v_max, format_in, flags)
    local retval, v1_, v2_, v3_ = r.ImGui_SliderDouble3(self.ctx, label, v1, v2, v3, v_min, v_max, format_in, flags)
    if retval then
        return v1_, v2_, v3_
    end
end

-- Default values: format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return number, number, number, number 
function ImGui:slider_double4(label, v1, v2, v3, v4, v_min, v_max, format_in, flags)
    local retval, v1_, v2_, v3_, v4_ = r.ImGui_SliderDouble4(self.ctx, label, v1, v2, v3, v4, v_min, v_max, format_in, flags)
    if retval then
        return v1_, v2_, v3_, v4_
    end
end

-- Default values: format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param values reaper_array
---@param ctx ImGui_Context
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return boolean 
function ImGui:slider_double_n(label, values, ctx, v_min, v_max, format_in, flags)
    return r.ImGui_SliderDoubleN(self.ctx, label, values, ctx, v_min, v_max, format_in, flags)
end

-- Clamp value to min/max bounds when input manually with CTRL+Click. By default CTRL+Click allows going out of bounds.
---@return number
function ImGui:slider_flags_always_clamp()
    return r.ImGui_SliderFlags_AlwaysClamp(self.ctx)
end

-- Make the widget logarithmic (linear otherwise). Consider using ImGuiSliderFlags_NoRoundToFormat with this if using a format-string with small amount of digits.
---@return number
function ImGui:slider_flags_logarithmic()
    return r.ImGui_SliderFlags_Logarithmic(self.ctx)
end

-- Disable CTRL+Click or Enter key allowing to input text directly into the widget
---@return number
function ImGui:slider_flags_no_input()
    return r.ImGui_SliderFlags_NoInput(self.ctx)
end

-- Disable rounding underlying value to match precision of the display format string (e.g. %.3f values are rounded to those 3 digits)
---@return number
function ImGui:slider_flags_no_round_to_format()
    return r.ImGui_SliderFlags_NoRoundToFormat(self.ctx)
end

-- for DragFloat(), DragInt(), SliderFloat(), SliderInt() etc.
---@return number
function ImGui:slider_flags_none()
    return r.ImGui_SliderFlags_None(self.ctx)
end

-- Default values: format = '%d', flags = ImGui_SliderFlags_None
---@param label string
---@param v number
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return number 
function ImGui:slider_int(label, v, v_min, v_max, format_in, flags)
    local retval, v_ = r.ImGui_SliderInt(self.ctx, label, v, v_min, v_max, format_in, flags)
    if retval then
        return v_
    end
end

-- Default values: format = '%d', flags = ImGui_SliderFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return number, number 
function ImGui:slider_int2(label, v1, v2, v_min, v_max, format_in, flags)
    local retval, v1_, v2_ = r.ImGui_SliderInt2(self.ctx, label, v1, v2, v_min, v_max, format_in, flags)
    if retval then
        return v1_, v2_
    end
end

-- Default values: format = '%d', flags = ImGui_SliderFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return number, number, number 
function ImGui:slider_int3(label, v1, v2, v3, v_min, v_max, format_in, flags)
    local retval, v1_, v2_, v3_ = r.ImGui_SliderInt3(self.ctx, label, v1, v2, v3, v_min, v_max, format_in, flags)
    if retval then
        return v1_, v2_, v3_
    end
end

-- Default values: format = '%d', flags = ImGui_SliderFlags_None
---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return number, number, number, number 
function ImGui:slider_int4(label, v1, v2, v3, v4, v_min, v_max, format_in, flags)
    local retval, v1_, v2_, v3_, v4_ = r.ImGui_SliderInt4(self.ctx, label, v1, v2, v3, v4, v_min, v_max, format_in, flags)
    if retval then
        return v1_, v2_, v3_, v4_
    end
end

-- Button with FramePadding=(0,0) to easily embed within text
---@param label string
---@return boolean 
function ImGui:small_button(label)
    return r.ImGui_SmallButton(self.ctx, label)
end

-- Ascending = 0->9, A->Z etc.
---@return number
function ImGui:sort_direction_ascending()
    return r.ImGui_SortDirection_Ascending(self.ctx)
end

-- Descending = 9->0, Z->A etc.
---@return number
function ImGui:sort_direction_descending()
    return r.ImGui_SortDirection_Descending(self.ctx)
end

---@return number
function ImGui:sort_direction_none()
    return r.ImGui_SortDirection_None(self.ctx)
end

-- Add vertical spacing.
function ImGui:spacing()
    return r.ImGui_Spacing(self.ctx)
end

-- Global alpha applies to everything in Dear ImGui.
---@return number
function ImGui:style_var_alpha()
    return r.ImGui_StyleVar_Alpha(self.ctx)
end

-- Alignment of button text when button is larger than text. Defaults to (0.5f, 0.5f) (centered).
---@return number
function ImGui:style_var_button_text_align()
    return r.ImGui_StyleVar_ButtonTextAlign(self.ctx)
end

-- Padding within a table cell
---@return number
function ImGui:style_var_cell_padding()
    return r.ImGui_StyleVar_CellPadding(self.ctx)
end

-- Thickness of border around child windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
---@return number
function ImGui:style_var_child_border_size()
    return r.ImGui_StyleVar_ChildBorderSize(self.ctx)
end

-- Radius of child window corners rounding. Set to 0.0f to have rectangular windows.
---@return number
function ImGui:style_var_child_rounding()
    return r.ImGui_StyleVar_ChildRounding(self.ctx)
end

-- Thickness of border around frames. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
---@return number
function ImGui:style_var_frame_border_size()
    return r.ImGui_StyleVar_FrameBorderSize(self.ctx)
end

-- Padding within a framed rectangle (used by most widgets).
---@return number
function ImGui:style_var_frame_padding()
    return r.ImGui_StyleVar_FramePadding(self.ctx)
end

-- Radius of frame corners rounding. Set to 0.0f to have rectangular frame (used by most widgets).
---@return number
function ImGui:style_var_frame_rounding()
    return r.ImGui_StyleVar_FrameRounding(self.ctx)
end

-- Minimum width/height of a grab box for slider/scrollbar.
---@return number
function ImGui:style_var_grab_min_size()
    return r.ImGui_StyleVar_GrabMinSize(self.ctx)
end

-- Radius of grabs corners rounding. Set to 0.0f to have rectangular slider grabs.
---@return number
function ImGui:style_var_grab_rounding()
    return r.ImGui_StyleVar_GrabRounding(self.ctx)
end

-- Horizontal indentation when e.g. entering a tree node. Generally == (FontSize + FramePadding.x*2).
---@return number
function ImGui:style_var_indent_spacing()
    return r.ImGui_StyleVar_IndentSpacing(self.ctx)
end

-- Horizontal and vertical spacing between within elements of a composed widget (e.g. a slider and its label).
---@return number
function ImGui:style_var_item_inner_spacing()
    return r.ImGui_StyleVar_ItemInnerSpacing(self.ctx)
end

-- Horizontal and vertical spacing between widgets/lines.
---@return number
function ImGui:style_var_item_spacing()
    return r.ImGui_StyleVar_ItemSpacing(self.ctx)
end

-- Thickness of border around popup/tooltip windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
---@return number
function ImGui:style_var_popup_border_size()
    return r.ImGui_StyleVar_PopupBorderSize(self.ctx)
end

-- Radius of popup window corners rounding. (Note that tooltip windows use WindowRounding)
---@return number
function ImGui:style_var_popup_rounding()
    return r.ImGui_StyleVar_PopupRounding(self.ctx)
end

-- Radius of grab corners for scrollbar.
---@return number
function ImGui:style_var_scrollbar_rounding()
    return r.ImGui_StyleVar_ScrollbarRounding(self.ctx)
end

-- Width of the vertical scrollbar, Height of the horizontal scrollbar.
---@return number
function ImGui:style_var_scrollbar_size()
    return r.ImGui_StyleVar_ScrollbarSize(self.ctx)
end

-- Alignment of selectable text. Defaults to (0.0f, 0.0f) (top-left aligned). It's generally important to keep this left-aligned if you want to lay multiple items on a same line.
---@return number
function ImGui:style_var_selectable_text_align()
    return r.ImGui_StyleVar_SelectableTextAlign(self.ctx)
end

-- Radius of upper corners of a tab. Set to 0.0f to have rectangular tabs.
---@return number
function ImGui:style_var_tab_rounding()
    return r.ImGui_StyleVar_TabRounding(self.ctx)
end

-- Thickness of border around windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
---@return number
function ImGui:style_var_window_border_size()
    return r.ImGui_StyleVar_WindowBorderSize(self.ctx)
end

-- Minimum window size. This is a global setting. If you want to constraint individual windows, use SetNextWindowSizeConstraints().
---@return number
function ImGui:style_var_window_min_size()
    return r.ImGui_StyleVar_WindowMinSize(self.ctx)
end

-- Padding within a window.
---@return number
function ImGui:style_var_window_padding()
    return r.ImGui_StyleVar_WindowPadding(self.ctx)
end

-- Radius of window corners rounding. Set to 0.0f to have rectangular windows. Large values tend to lead to variety of artifacts and are not recommended.
---@return number
function ImGui:style_var_window_rounding()
    return r.ImGui_StyleVar_WindowRounding(self.ctx)
end

-- Alignment for title bar text. Defaults to (0.0f,0.5f) for left-aligned,vertically centered.
---@return number
function ImGui:style_var_window_title_align()
    return r.ImGui_StyleVar_WindowTitleAlign(self.ctx)
end

-- Automatically select new tabs when they appear
---@return number
function ImGui:tab_bar_flags_auto_select_new_tabs()
    return r.ImGui_TabBarFlags_AutoSelectNewTabs(self.ctx)
end

-- Resize tabs when they don't fit
---@return number
function ImGui:tab_bar_flags_fitting_policy_resize_down()
    return r.ImGui_TabBarFlags_FittingPolicyResizeDown(self.ctx)
end

-- Add scroll buttons when tabs don't fit
---@return number
function ImGui:tab_bar_flags_fitting_policy_scroll()
    return r.ImGui_TabBarFlags_FittingPolicyScroll(self.ctx)
end

-- Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You can still repro this behavior on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
---@return number
function ImGui:tab_bar_flags_no_close_with_middle_mouse_button()
    return r.ImGui_TabBarFlags_NoCloseWithMiddleMouseButton(self.ctx)
end

-- Disable scrolling buttons (apply when fitting policy is ImGuiTabBarFlags_FittingPolicyScroll)
---@return number
function ImGui:tab_bar_flags_no_tab_list_scrolling_buttons()
    return r.ImGui_TabBarFlags_NoTabListScrollingButtons(self.ctx)
end

-- Disable tooltips when hovering a tab
---@return number
function ImGui:tab_bar_flags_no_tooltip()
    return r.ImGui_TabBarFlags_NoTooltip(self.ctx)
end

-- Flags: for BeginTabBar()
---@return number
function ImGui:tab_bar_flags_none()
    return r.ImGui_TabBarFlags_None(self.ctx)
end

-- Allow manually dragging tabs to re-order them + New tabs are appended at the end of list
---@return number
function ImGui:tab_bar_flags_reorderable()
    return r.ImGui_TabBarFlags_Reorderable(self.ctx)
end

-- Disable buttons to open the tab list popup
---@return number
function ImGui:tab_bar_flags_tab_list_popup_button()
    return r.ImGui_TabBarFlags_TabListPopupButton(self.ctx)
end

-- Default values: flags = ImGui_TabItemFlags_None
---@param label string
---@param flags number
---@return boolean 
function ImGui:tab_item_button(label, flags)
    return r.ImGui_TabItemButton(self.ctx, label, flags)
end

-- Enforce the tab position to the left of the tab bar (after the tab list popup button)
---@return number
function ImGui:tab_item_flags_leading()
    return r.ImGui_TabItemFlags_Leading(self.ctx)
end

-- Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You can still repro this behavior on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
---@return number
function ImGui:tab_item_flags_no_close_with_middle_mouse_button()
    return r.ImGui_TabItemFlags_NoCloseWithMiddleMouseButton(self.ctx)
end

-- Don't call PushID(tab->ID)/PopID() on BeginTabItem()/EndTabItem()
---@return number
function ImGui:tab_item_flags_no_push_id()
    return r.ImGui_TabItemFlags_NoPushId(self.ctx)
end

-- Disable reordering this tab or having another tab cross over this tab
---@return number
function ImGui:tab_item_flags_no_reorder()
    return r.ImGui_TabItemFlags_NoReorder(self.ctx)
end

-- Disable tooltip for the given tab
---@return number
function ImGui:tab_item_flags_no_tooltip()
    return r.ImGui_TabItemFlags_NoTooltip(self.ctx)
end

-- Flags: for BeginTabItem()
---@return number
function ImGui:tab_item_flags_none()
    return r.ImGui_TabItemFlags_None(self.ctx)
end

-- Trigger flag to programmatically make the tab selected when calling BeginTabItem()
---@return number
function ImGui:tab_item_flags_set_selected()
    return r.ImGui_TabItemFlags_SetSelected(self.ctx)
end

-- Enforce the tab position to the right of the tab bar (before the scrolling buttons)
---@return number
function ImGui:tab_item_flags_trailing()
    return r.ImGui_TabItemFlags_Trailing(self.ctx)
end

-- Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. Also: tab is selected on closure and closure is deferred by one frame to allow code to undo it without flicker.
---@return number
function ImGui:tab_item_flags_unsaved_document()
    return r.ImGui_TabItemFlags_UnsavedDocument(self.ctx)
end

-- Set cell background color (top-most color)
---@return number
function ImGui:table_bg_target_cell_bg()
    return r.ImGui_TableBgTarget_CellBg(self.ctx)
end

-- If you set the color of RowBg1 or ColumnBg1 target, your color will blend over the RowBg0 color.
---@return number
function ImGui:table_bg_target_none()
    return r.ImGui_TableBgTarget_None(self.ctx)
end

-- Set row background color 0 (generally used for background, automatically set when ImGuiTableFlags_RowBg is used)
---@return number
function ImGui:table_bg_target_row_bg0()
    return r.ImGui_TableBgTarget_RowBg0(self.ctx)
end

-- Set row background color 1 (generally used for selection marking)
---@return number
function ImGui:table_bg_target_row_bg1()
    return r.ImGui_TableBgTarget_RowBg1(self.ctx)
end

-- Default as a hidden/disabled column.
---@return number
function ImGui:table_column_flags_default_hide()
    return r.ImGui_TableColumnFlags_DefaultHide(self.ctx)
end

-- Default as a sorting column.
---@return number
function ImGui:table_column_flags_default_sort()
    return r.ImGui_TableColumnFlags_DefaultSort(self.ctx)
end

-- Ignore current Indent value when entering cell (default for columns > 0). Indentation changes _within_ the cell will still be honored.
---@return number
function ImGui:table_column_flags_indent_disable()
    return r.ImGui_TableColumnFlags_IndentDisable(self.ctx)
end

-- Use current Indent value when entering cell (default for column 0).
---@return number
function ImGui:table_column_flags_indent_enable()
    return r.ImGui_TableColumnFlags_IndentEnable(self.ctx)
end

-- Status: is enabled == not hidden by user/api (referred to as "Hide" in _DefaultHide and _NoHide) flags.
---@return number
function ImGui:table_column_flags_is_enabled()
    return r.ImGui_TableColumnFlags_IsEnabled(self.ctx)
end

-- Status: is hovered by mouse
---@return number
function ImGui:table_column_flags_is_hovered()
    return r.ImGui_TableColumnFlags_IsHovered(self.ctx)
end

-- Status: is currently part of the sort specs
---@return number
function ImGui:table_column_flags_is_sorted()
    return r.ImGui_TableColumnFlags_IsSorted(self.ctx)
end

-- Status: is visible == is enabled AND not clipped by scrolling.
---@return number
function ImGui:table_column_flags_is_visible()
    return r.ImGui_TableColumnFlags_IsVisible(self.ctx)
end

-- Disable clipping for this column (all NoClip columns will render in a same draw command).
---@return number
function ImGui:table_column_flags_no_clip()
    return r.ImGui_TableColumnFlags_NoClip(self.ctx)
end

-- Disable header text width contribution to automatic column width.
---@return number
function ImGui:table_column_flags_no_header_width()
    return r.ImGui_TableColumnFlags_NoHeaderWidth(self.ctx)
end

-- Disable ability to hide/disable this column.
---@return number
function ImGui:table_column_flags_no_hide()
    return r.ImGui_TableColumnFlags_NoHide(self.ctx)
end

-- Disable manual reordering this column, this will also prevent other columns from crossing over this column.
---@return number
function ImGui:table_column_flags_no_reorder()
    return r.ImGui_TableColumnFlags_NoReorder(self.ctx)
end

-- Disable manual resizing.
---@return number
function ImGui:table_column_flags_no_resize()
    return r.ImGui_TableColumnFlags_NoResize(self.ctx)
end

-- Disable ability to sort on this field (even if ImGui_TableFlags_Sortable is set on the table).
---@return number
function ImGui:table_column_flags_no_sort()
    return r.ImGui_TableColumnFlags_NoSort(self.ctx)
end

-- Disable ability to sort in the ascending direction.
---@return number
function ImGui:table_column_flags_no_sort_ascending()
    return r.ImGui_TableColumnFlags_NoSortAscending(self.ctx)
end

-- Disable ability to sort in the descending direction.
---@return number
function ImGui:table_column_flags_no_sort_descending()
    return r.ImGui_TableColumnFlags_NoSortDescending(self.ctx)
end

-- Flags: For TableSetupColumn()
---@return number
function ImGui:table_column_flags_none()
    return r.ImGui_TableColumnFlags_None(self.ctx)
end

-- Make the initial sort direction Ascending when first sorting on this column (default).
---@return number
function ImGui:table_column_flags_prefer_sort_ascending()
    return r.ImGui_TableColumnFlags_PreferSortAscending(self.ctx)
end

-- Make the initial sort direction Descending when first sorting on this column.
---@return number
function ImGui:table_column_flags_prefer_sort_descending()
    return r.ImGui_TableColumnFlags_PreferSortDescending(self.ctx)
end

-- Column will not stretch. Preferable with horizontal scrolling enabled (default if table sizing policy is _SizingFixedFit and table is resizable).
---@return number
function ImGui:table_column_flags_width_fixed()
    return r.ImGui_TableColumnFlags_WidthFixed()
end

-- Column will stretch. Preferable with horizontal scrolling disabled (default if table sizing policy is _SizingStretchSame or _SizingStretchProp).
---@return number
function ImGui:table_column_flags_width_stretch()
    return r.ImGui_TableColumnFlags_WidthStretch()
end

-- Draw all borders.
---@return number
function ImGui:table_flags_borders()
    return r.ImGui_TableFlags_Borders()
end

-- Draw horizontal borders.
---@return number
function ImGui:table_flags_borders_h()
    return r.ImGui_TableFlags_BordersH()
end

-- Draw inner borders.
---@return number
function ImGui:table_flags_borders_inner()
    return r.ImGui_TableFlags_BordersInner()
end

-- Draw horizontal borders between rows.
---@return number
function ImGui:table_flags_borders_inner_h()
    return r.ImGui_TableFlags_BordersInnerH()
end

-- Draw vertical borders between columns.
---@return number
function ImGui:table_flags_borders_inner_v()
    return r.ImGui_TableFlags_BordersInnerV()
end

-- Draw outer borders.
---@return number
function ImGui:table_flags_borders_outer()
    return r.ImGui_TableFlags_BordersOuter()
end

-- Draw horizontal borders at the top and bottom.
---@return number
function ImGui:table_flags_borders_outer_h()
    return r.ImGui_TableFlags_BordersOuterH()
end

-- Draw vertical borders on the left and right sides.
---@return number
function ImGui:table_flags_borders_outer_v()
    return r.ImGui_TableFlags_BordersOuterV()
end

-- Draw vertical borders.
---@return number
function ImGui:table_flags_borders_v()
    return r.ImGui_TableFlags_BordersV()
end

-- Right-click on columns body/contents will display table context menu. By default it is available in TableHeadersRow().
---@return number
function ImGui:table_flags_context_menu_in_body()
    return r.ImGui_TableFlags_ContextMenuInBody()
end

-- Enable hiding/disabling columns in context menu.
---@return number
function ImGui:table_flags_hideable()
    return r.ImGui_TableFlags_Hideable()
end

-- Disable clipping rectangle for every individual columns (reduce draw command count, items will be able to overflow into other columns). Generally incompatible with TableSetupScrollFreeze().
---@return number
function ImGui:table_flags_no_clip()
    return r.ImGui_TableFlags_NoClip()
end

-- Make outer width auto-fit to columns, overriding outer_size.x value. Only available when ScrollX/ScrollY are disabled and Stretch columns are not used.
---@return number
function ImGui:table_flags_no_host_extend_x()
    return r.ImGui_TableFlags_NoHostExtendX()
end

-- Make outer height stop exactly at outer_size.y (prevent auto-extending table past the limit). Only available when ScrollX/ScrollY are disabled. Data below the limit will be clipped and not visible.
---@return number
function ImGui:table_flags_no_host_extend_y()
    return r.ImGui_TableFlags_NoHostExtendY()
end

-- Disable keeping column always minimally visible when ScrollX is off and table gets too small. Not recommended if columns are resizable.
---@return number
function ImGui:table_flags_no_keep_columns_visible()
    return r.ImGui_TableFlags_NoKeepColumnsVisible()
end

-- Disable inner padding between columns (double inner padding if BordersOuterV is on, single inner padding if BordersOuterV is off).
---@return number
function ImGui:table_flags_no_pad_inner_x()
    return r.ImGui_TableFlags_NoPadInnerX()
end

-- Default if BordersOuterV is off. Disable outer-most padding.
---@return number
function ImGui:table_flags_no_pad_outer_x()
    return r.ImGui_TableFlags_NoPadOuterX()
end

-- Disable persisting columns order, width and sort settings in the .ini file.
---@return number
function ImGui:table_flags_no_saved_settings()
    return r.ImGui_TableFlags_NoSavedSettings()
end

-- - Read on documentation at the top of imgui_tables.cpp for details.
---@return number
function ImGui:table_flags_none()
    return r.ImGui_TableFlags_None()
end

-- Default if BordersOuterV is on. Enable outer-most padding. Generally desirable if you have headers.
---@return number
function ImGui:table_flags_pad_outer_x()
    return r.ImGui_TableFlags_PadOuterX()
end

-- Disable distributing remainder width to stretched columns (width allocation on a 100-wide table with 3 columns: Without this flag: 33,33,34. With this flag: 33,33,33). With larger number of columns, resizing will appear to be less smooth.
---@return number
function ImGui:table_flags_precise_widths()
    return r.ImGui_TableFlags_PreciseWidths()
end

-- Enable reordering columns in header row (need calling TableSetupColumn() + TableHeadersRow() to display headers)
---@return number
function ImGui:table_flags_reorderable()
    return r.ImGui_TableFlags_Reorderable()
end

-- Enable resizing columns.
---@return number
function ImGui:table_flags_resizable()
    return r.ImGui_TableFlags_Resizable()
end

-- Set each RowBg color with ImGuiCol_TableRowBg or ImGuiCol_TableRowBgAlt (equivalent of calling TableSetBgColor with ImGuiTableBgFlags_RowBg0 on each row manually)
---@return number
function ImGui:table_flags_row_bg()
    return r.ImGui_TableFlags_RowBg()
end

-- Enable horizontal scrolling. Require 'outer_size' parameter of BeginTable() to specify the container size. Changes default sizing policy. Because this create a child window, ScrollY is currently generally recommended when using ScrollX.
---@return number
function ImGui:table_flags_scroll_x()
    return r.ImGui_TableFlags_ScrollX()
end

-- Enable vertical scrolling. Require 'outer_size' parameter of BeginTable() to specify the container size.
---@return number
function ImGui:table_flags_scroll_y()
    return r.ImGui_TableFlags_ScrollY()
end

-- Columns default to _WidthFixed or _WidthAuto (if resizable or not resizable), matching contents width.
---@return number
function ImGui:table_flags_sizing_fixed_fit()
    return r.ImGui_TableFlags_SizingFixedFit()
end

-- Columns default to _WidthFixed or _WidthAuto (if resizable or not resizable), matching the maximum contents width of all columns. Implicitly enable ImGuiTableFlags_NoKeepColumnsVisible.
---@return number
function ImGui:table_flags_sizing_fixed_same()
    return r.ImGui_TableFlags_SizingFixedSame()
end

-- Columns default to _WidthStretch with default weights proportional to each columns contents widths.
---@return number
function ImGui:table_flags_sizing_stretch_prop()
    return r.ImGui_TableFlags_SizingStretchProp()
end

-- Columns default to _WidthStretch with default weights all equal, unless overriden by TableSetupColumn().
---@return number
function ImGui:table_flags_sizing_stretch_same()
    return r.ImGui_TableFlags_SizingStretchSame()
end

-- Hold shift when clicking headers to sort on multiple column. TableGetSortSpecs() may return specs where (SpecsCount > 1).
---@return number
function ImGui:table_flags_sort_multi()
    return r.ImGui_TableFlags_SortMulti()
end

-- Allow no sorting, disable default sorting. TableGetSortSpecs() may return specs where (SpecsCount == 0).
---@return number
function ImGui:table_flags_sort_tristate()
    return r.ImGui_TableFlags_SortTristate()
end

-- Enable sorting. Call TableGetSortSpecs() to obtain sort specs. Also see ImGuiTableFlags_SortMulti and ImGuiTableFlags_SortTristate.
---@return number
function ImGui:table_flags_sortable()
    return r.ImGui_TableFlags_Sortable()
end

-- Return number of columns (value passed to BeginTable)
---@return number
function ImGui:table_get_column_count()
    return r.ImGui_TableGetColumnCount(self.ctx)
end

-- Default values: column_n = -1
---@param column_n_in number
---@return number
function ImGui:table_get_column_flags(column_n_in)
    return r.ImGui_TableGetColumnFlags(self.ctx, column_n_in)
end

-- Return current column index.
---@return number
function ImGui:table_get_column_index()
    return r.ImGui_TableGetColumnIndex(self.ctx)
end

-- Default values: column_n = -1
---@param column_n_in number
---@return string 
function ImGui:table_get_column_name(column_n_in)
    return r.ImGui_TableGetColumnName(self.ctx, column_n_in)
end

-- See ImGui_TableNeedSort.
---@param id number
---@return number, number, number, number 
function ImGui:table_get_column_sort_specs(id)
    local retval, column_user_id, column_index, sort_order, sort_direction = r.ImGui_TableGetColumnSortSpecs(self.ctx, id)
    if retval then
        return column_user_id, column_index, sort_order, sort_direction
    end
end

-- Return current row index.
---@return number
function ImGui:table_get_row_index()
    return r.ImGui_TableGetRowIndex(self.ctx)
end

-- Submit one header cell manually (rarely used). See ImGui_TableSetColumn
---@param label string
function ImGui:table_header(label)
    return r.ImGui_TableHeader(self.ctx, label)
end

-- Submit all headers cells based on data provided to TableSetupColumn() + submit context menu
function ImGui:table_headers_row()
    return r.ImGui_TableHeadersRow(self.ctx)
end

-- Return true once when sorting specs have changed since last call, or the first time. 'has_specs' is false when not sorting. See ImGui_TableSortSpecs_GetColumnSpecs.
---@return boolean 
function ImGui:table_need_sort()
    local retval, has_specs = r.ImGui_TableNeedSort(self.ctx)
    if retval then
        return has_specs
    end
end

-- Append into the next column (or first column of next row if currently in last column). Return true when column is visible.
---@return boolean 
function ImGui:table_next_column()
    return r.ImGui_TableNextColumn(self.ctx)
end

-- Default values: row_flags = ImGui_TableRowFlags_None, min_row_height = 0.0
---@param row_flags number
---@param min_row_height_in number
function ImGui:table_next_row(row_flags, min_row_height_in)
    return r.ImGui_TableNextRow(self.ctx, row_flags, min_row_height_in)
end

-- Identify header row (set default background color + width of its contents accounted different for auto column width)
---@return number
function ImGui:table_row_flags_headers()
    return r.ImGui_TableRowFlags_Headers(self.ctx)
end

-- Flags: For TableNextRow()
---@return number
function ImGui:table_row_flags_none()
    return r.ImGui_TableRowFlags_None(self.ctx)
end

-- Default values: column_n = -1
---@param target number
---@param color_rgba number
---@param column_n_in number
function ImGui:table_set_bg_color(target, color_rgba, column_n_in)
    return r.ImGui_TableSetBgColor(self.ctx, target, color_rgba, column_n_in)
end

-- Change enabled/disabled state of a column, set to false to hide the column. Note that end-user can use the context menu to change this themselves (right-click in headers, or right-click in columns body with ImGuiTableFlags_ContextMenuInBody)
---@param column_n number
---@param v boolean
function ImGui:table_set_column_enabled(column_n, v)
    return r.ImGui_TableSetColumnEnabled(self.ctx, column_n, v)
end

-- Append into the specified column. Return true when column is visible.
---@param column_n number
---@return boolean 
function ImGui:table_set_column_index(column_n)
    return r.ImGui_TableSetColumnIndex(self.ctx, column_n)
end

-- Default values: flags = ImGui_TableColumnFlags_None, init_width_or_weight = 0.0, user_id = 0
---@param label string
---@param flags number
---@param init_width_or_weight_in number
---@param user_id_in number
function ImGui:table_setup_column(label, flags, init_width_or_weight_in, user_id_in)
    return r.ImGui_TableSetupColumn(self.ctx, label, flags, init_width_or_weight_in, user_id_in)
end

-- Lock columns/rows so they stay visible when scrolled.
---@param cols number
---@param rows number
function ImGui:table_setup_scroll_freeze(cols, rows)
    return r.ImGui_TableSetupScrollFreeze(self.ctx, cols, rows)
end

---@param text string
function ImGui:text(text)
    return r.ImGui_Text(self.ctx, text)
end

-- Shortcut for PushStyleColor(ImGuiCol_Text, color); Text(text); PopStyleColor();
---@param col_rgba number
---@param text string
function ImGui:text_colored(col_rgba, text)
    return r.ImGui_TextColored(self.ctx, col_rgba, text)
end

---@param text string
function ImGui:text_disabled(text)
    return r.ImGui_TextDisabled(self.ctx, text)
end

-- Shortcut for PushTextWrapPos(0.0f); Text(fmt, ...); PopTextWrapPos();. Note that this won't work on an auto-resizing window if there's no other widgets to extend the window width, yoy may need to set a size using SetNextWindowSize().
---@param text string
function ImGui:text_wrapped(text)
    return r.ImGui_TextWrapped(self.ctx, text)
end

-- Default values: flags = ImGui_TreeNodeFlags_None
---@param label string
---@param flags number
---@return boolean 
function ImGui:tree_node(label, flags)
    return r.ImGui_TreeNode(self.ctx, label, flags)
end

-- Default values: flags = ImGui_TreeNodeFlags_None
---@param str_id string
---@param label string
---@param flags number
---@return boolean 
function ImGui:tree_node_ex(str_id, label, flags)
    return r.ImGui_TreeNodeEx(self.ctx, str_id, label, flags)
end

-- Hit testing to allow subsequent widgets to overlap this one
---@return number
function ImGui:tree_node_flags_allow_item_overlap()
    return r.ImGui_TreeNodeFlags_AllowItemOverlap(self.ctx)
end

-- Display a bullet instead of arrow
---@return number
function ImGui:tree_node_flags_bullet()
    return r.ImGui_TreeNodeFlags_Bullet(self.ctx)
end

---@return number
function ImGui:tree_node_flags_collapsing_header()
    return r.ImGui_TreeNodeFlags_CollapsingHeader(self.ctx)
end

-- Default node to be open
---@return number
function ImGui:tree_node_flags_default_open()
    return r.ImGui_TreeNodeFlags_DefaultOpen(self.ctx)
end

-- Use FramePadding (even for an unframed text node) to vertically align text baseline to regular widget height. Equivalent to calling AlignTextToFramePadding().
---@return number
function ImGui:tree_node_flags_frame_padding()
    return r.ImGui_TreeNodeFlags_FramePadding(self.ctx)
end

-- Draw frame with background (e.g. for CollapsingHeader)
---@return number
function ImGui:tree_node_flags_framed()
    return r.ImGui_TreeNodeFlags_Framed(self.ctx)
end

-- No collapsing, no arrow (use as a convenience for leaf nodes).
---@return number
function ImGui:tree_node_flags_leaf()
    return r.ImGui_TreeNodeFlags_Leaf(self.ctx)
end

-- Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
---@return number
function ImGui:tree_node_flags_no_auto_open_on_log()
    return r.ImGui_TreeNodeFlags_NoAutoOpenOnLog(self.ctx)
end

-- Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
---@return number
function ImGui:tree_node_flags_no_tree_push_on_open()
    return r.ImGui_TreeNodeFlags_NoTreePushOnOpen(self.ctx)
end

-- Flags for TreeNode(), TreeNodeEx(), CollapsingHeader()
---@return number
function ImGui:tree_node_flags_none()
    return r.ImGui_TreeNodeFlags_None(self.ctx)
end

-- Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
---@return number
function ImGui:tree_node_flags_open_on_arrow()
    return r.ImGui_TreeNodeFlags_OpenOnArrow(self.ctx)
end

-- Need double-click to open node
---@return number
function ImGui:tree_node_flags_open_on_double_click()
    return r.ImGui_TreeNodeFlags_OpenOnDoubleClick(self.ctx)
end

-- Draw as selected
---@return number
function ImGui:tree_node_flags_selected()
    return r.ImGui_TreeNodeFlags_Selected(self.ctx)
end

-- Extend hit box to the right-most edge, even if not framed. This is not the default in order to allow adding other items on the same line. In the future we may refactor the hit system to be front-to-back, allowing natural overlaps and then this can become the default.
---@return number
function ImGui:tree_node_flags_span_avail_width()
    return r.ImGui_TreeNodeFlags_SpanAvailWidth(self.ctx)
end

-- Extend hit box to the left-most and right-most edges (bypass the indented area).
---@return number
function ImGui:tree_node_flags_span_full_width()
    return r.ImGui_TreeNodeFlags_SpanFullWidth(self.ctx)
end

-- Unindent()+PopId()
function ImGui:tree_pop()
    return r.ImGui_TreePop(self.ctx)
end

-- ~ Indent()+PushId(). Already called by TreeNode() when returning true, but you can call TreePush/TreePop yourself if desired.
---@param str_id string
function ImGui:tree_push(str_id)
    return r.ImGui_TreePush(self.ctx, str_id)
end

-- Default values: indent_w = 0.0
---@param indent_w_in number
function ImGui:unindent(indent_w_in)
    return r.ImGui_Unindent(self.ctx, indent_w_in)
end

-- Default values: format = '%.3f', flags = ImGui_SliderFlags_None
---@param label string
---@param size_w number
---@param size_h number
---@param v number
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return number 
function ImGui:v_slider_double(label, size_w, size_h, v, v_min, v_max, format_in, flags)
    local retval, v_ = r.ImGui_VSliderDouble(self.ctx, label, size_w, size_h, v, v_min, v_max, format_in, flags)
    if retval then
        return v_
    end
end

-- Default values: format = '%d', flags = ImGui_SliderFlags_None
---@param label string
---@param size_w number
---@param size_h number
---@param v number
---@param v_min number
---@param v_max number
---@param format_in string
---@param flags number
---@return number 
function ImGui:v_slider_int(label, size_w, size_h, v, v_min, v_max, format_in, flags)
    local retval, v_ = r.ImGui_VSliderInt(self.ctx, label, size_w, size_h, v, v_min, v_max, format_in, flags)
    if retval then
        return v_
    end
end

-- Return whether the pointer of the specified type is valid. Supported types are ImGui_Context*, ImGui_DrawList*, ImGui_ListClipper* and ImGui_Viewport*.
---@param type string
---@return boolean 
function ImGui:validate_ptr(type)
    return r.ImGui_ValidatePtr(self.ctx, type)
end

-- Main Area: Center of the viewport.
---@return number, number 
function ImGui:viewport_get_center()
    return r.ImGui_Viewport_GetCenter(self.ctx)
end

-- Main Area: Position of the viewport (Dear ImGui coordinates are the same as OS desktop/native coordinates)
---@return number, number 
function ImGui:viewport_get_pos()
    return r.ImGui_Viewport_GetPos(self.ctx)
end

-- Main Area: Size of the viewport.
---@return number, number 
function ImGui:viewport_get_size()
    return r.ImGui_Viewport_GetSize(self.ctx)
end

-- Work Area: Center of the viewport.
---@return number, number 
function ImGui:viewport_get_work_center()
    return r.ImGui_Viewport_GetWorkCenter(self.ctx)
end

-- Work Area: Position of the viewport minus task bars, menus bars, status bars (>= Pos)
---@return number, number 
function ImGui:viewport_get_work_pos()
    return r.ImGui_Viewport_GetWorkPos(self.ctx)
end

-- Work Area: Size of the viewport minus task bars, menu bars, status bars (<= Size)
---@return number, number 
function ImGui:viewport_get_work_size()
    return r.ImGui_Viewport_GetWorkSize(self.ctx)
end

-- Resize every window to its content every frame
---@return number
function ImGui:window_flags_always_auto_resize()
    return r.ImGui_WindowFlags_AlwaysAutoResize(self.ctx)
end

-- Always show horizontal scrollbar (even if ContentSize.x < Size.x)
---@return number
function ImGui:window_flags_always_horizontal_scrollbar()
    return r.ImGui_WindowFlags_AlwaysHorizontalScrollbar(self.ctx)
end

-- Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)
---@return number
function ImGui:window_flags_always_use_window_padding()
    return r.ImGui_WindowFlags_AlwaysUseWindowPadding(self.ctx)
end

-- Always show vertical scrollbar (even if ContentSize.y < Size.y)
---@return number
function ImGui:window_flags_always_vertical_scrollbar()
    return r.ImGui_WindowFlags_AlwaysVerticalScrollbar(self.ctx)
end

-- Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
---@return number
function ImGui:window_flags_horizontal_scrollbar()
    return r.ImGui_WindowFlags_HorizontalScrollbar(self.ctx)
end

-- Has a menu-bar
---@return number
function ImGui:window_flags_menu_bar()
    return r.ImGui_WindowFlags_MenuBar(self.ctx)
end

-- Disable drawing background color (WindowBg, etc.) and outside border. Similar as using SetNextWindowBgAlpha(0.0f).
---@return number
function ImGui:window_flags_no_background()
    return r.ImGui_WindowFlags_NoBackground(self.ctx)
end

-- Disable bringing window to front when taking focus (e.g. clicking on it or programmatically giving it focus)
---@return number
function ImGui:window_flags_no_bring_to_front_on_focus()
    return r.ImGui_WindowFlags_NoBringToFrontOnFocus(self.ctx)
end

-- Disable user collapsing window by double-clicking on it
---@return number
function ImGui:window_flags_no_collapse()
    return r.ImGui_WindowFlags_NoCollapse(self.ctx)
end

-- WindowFlags_NoTitleBar | WindowFlags_NoResize | WindowFlags_NoScrollbar | WindowFlags_NoCollapse
---@return number
function ImGui:window_flags_no_decoration()
    return r.ImGui_WindowFlags_NoDecoration(self.ctx)
end

-- Disable docking of this window
---@return number
function ImGui:window_flags_no_docking()
    return r.ImGui_WindowFlags_NoDocking(self.ctx)
end

-- Disable taking focus when transitioning from hidden to visible state
---@return number
function ImGui:window_flags_no_focus_on_appearing()
    return r.ImGui_WindowFlags_NoFocusOnAppearing(self.ctx)
end

-- WindowFlags_NoMouseInputs | WindowFlags_NoNavInputs | WindowFlags_NoNavFocus
---@return number
function ImGui:window_flags_no_inputs()
    return r.ImGui_WindowFlags_NoInputs(self.ctx)
end

-- Disable catching mouse, hovering test with pass through.
---@return number
function ImGui:window_flags_no_mouse_inputs()
    return r.ImGui_WindowFlags_NoMouseInputs(self.ctx)
end

-- Disable user moving the window
---@return number
function ImGui:window_flags_no_move()
    return r.ImGui_WindowFlags_NoMove(self.ctx)
end

-- WindowFlags_NoNavInputs | WindowFlags_NoNavFocus
---@return number
function ImGui:window_flags_no_nav()
    return r.ImGui_WindowFlags_NoNav(self.ctx)
end

-- No focusing toward this window with gamepad/keyboard navigation (e.g. skipped by CTRL+TAB)
---@return number
function ImGui:window_flags_no_nav_focus()
    return r.ImGui_WindowFlags_NoNavFocus(self.ctx)
end

-- No gamepad/keyboard navigation within the window
---@return number
function ImGui:window_flags_no_nav_inputs()
    return r.ImGui_WindowFlags_NoNavInputs(self.ctx)
end

-- Disable user resizing with the lower-right grip
---@return number
function ImGui:window_flags_no_resize()
    return r.ImGui_WindowFlags_NoResize(self.ctx)
end

-- Never load/save settings in .ini file
---@return number
function ImGui:window_flags_no_saved_settings()
    return r.ImGui_WindowFlags_NoSavedSettings(self.ctx)
end

-- Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
---@return number
function ImGui:window_flags_no_scroll_with_mouse()
    return r.ImGui_WindowFlags_NoScrollWithMouse(self.ctx)
end

-- Disable scrollbars (window can still scroll with mouse or programmatically)
---@return number
function ImGui:window_flags_no_scrollbar()
    return r.ImGui_WindowFlags_NoScrollbar(self.ctx)
end

-- Disable title-bar
---@return number
function ImGui:window_flags_no_title_bar()
    return r.ImGui_WindowFlags_NoTitleBar(self.ctx)
end

-- Default flag. See ImGui_Begin.
---@return number
function ImGui:window_flags_none()
    return r.ImGui_WindowFlags_None(self.ctx)
end

-- Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. When used in a tab/docking context, tab is selected on closure and closure is deferred by one frame to allow code to cancel the closure (with a confirmation popup, etc.) without flicker.
---@return number
function ImGui:window_flags_unsaved_document()
    return r.ImGui_WindowFlags_UnsavedDocument(self.ctx)
end
