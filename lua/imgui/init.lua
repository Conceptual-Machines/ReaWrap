--- ReaWrap ImGui wrapper module.
-- Provides OOP abstractions over ReaImGui for cleaner, more Pythonic code.
-- @module imgui
-- @author Nomad Monad
-- @license MIT

local r = reaper

local M = {}

-- Submodules (lazy loaded)
M.Window = nil
M.Theme = nil

--------------------------------------------------------------------------------
-- Context Management
--------------------------------------------------------------------------------

--- ImGui context wrapper that provides shorthand methods.
-- @type Context
local Context = {}
Context.__index = Context

--- Create a new ImGui context wrapper.
-- @param name string Context name (window title)
-- @param opts table|nil Optional settings {config_flags}
-- @return Context
function Context:new(name, opts)
    opts = opts or {}

    -- Config flags are passed directly to CreateContext as optional second param
    local ctx
    if opts.config_flags then
        ctx = r.ImGui_CreateContext(name, opts.config_flags)
    else
        ctx = r.ImGui_CreateContext(name)
    end

    if not ctx then
        error("Failed to create ImGui context. Is ReaImGui installed?")
    end

    local self = setmetatable({
        ctx = ctx,
        name = name,
        _fonts = {},
        _style_stack = {},
    }, Context)

    return self
end

--- Destroy the context.
-- Note: In ReaImGui 0.8+, contexts are garbage collected automatically.
-- This method just clears the reference to allow GC.
function Context:destroy()
    -- Contexts are garbage collected in modern ReaImGui
    -- Just clear our reference
    self.ctx = nil
end

--- Get the raw ImGui context pointer.
-- @return userdata Raw context
function Context:get_raw()
    return self.ctx
end

--- Check if context is valid.
-- @return boolean
function Context:is_valid()
    return self.ctx ~= nil
end

--------------------------------------------------------------------------------
-- Window Functions
--------------------------------------------------------------------------------

--- Begin a window.
-- @param title string Window title
-- @param p_open boolean|nil Closeable window flag (pass true for closeable)
-- @param flags number|nil Window flags
-- @return boolean visible Whether window is visible
-- @return boolean open Whether window is still open
function Context:begin_window(title, p_open, flags)
    flags = flags or r.ImGui_WindowFlags_None()
    return r.ImGui_Begin(self.ctx, title, p_open, flags)
end

--- End a window.
function Context:end_window()
    r.ImGui_End(self.ctx)
end

--- Set next window size.
-- @param width number
-- @param height number
-- @param cond number|nil Condition (default: FirstUseEver)
function Context:set_next_window_size(width, height, cond)
    cond = cond or r.ImGui_Cond_FirstUseEver()
    r.ImGui_SetNextWindowSize(self.ctx, width, height, cond)
end

--- Set next window position.
-- @param x number
-- @param y number
-- @param cond number|nil Condition
function Context:set_next_window_pos(x, y, cond)
    cond = cond or r.ImGui_Cond_FirstUseEver()
    r.ImGui_SetNextWindowPos(self.ctx, x, y, cond)
end

--- Begin a child region.
-- @param id string Child ID
-- @param width number|nil Width (0 = auto)
-- @param height number|nil Height (0 = auto)
-- @param flags number|nil Child flags
-- @return boolean
function Context:begin_child(id, width, height, child_flags, window_flags)
    width = width or 0
    height = height or 0
    child_flags = child_flags or 0
    window_flags = window_flags or 0
    return r.ImGui_BeginChild(self.ctx, id, width, height, child_flags, window_flags)
end

--- End a child region.
function Context:end_child()
    r.ImGui_EndChild(self.ctx)
end

--------------------------------------------------------------------------------
-- Basic Widgets
--------------------------------------------------------------------------------

--- Display text.
-- @param text string
function Context:text(text)
    r.ImGui_Text(self.ctx, text)
end

--- Display formatted text.
-- @param fmt string Format string
-- @param ... Format arguments
function Context:text_fmt(fmt, ...)
    r.ImGui_Text(self.ctx, string.format(fmt, ...))
end

--- Display disabled/grayed text.
-- @param text string
function Context:text_disabled(text)
    r.ImGui_TextDisabled(self.ctx, text)
end

--- Display colored text.
-- @param color number RGBA color (0xRRGGBBAA)
-- @param text string
function Context:text_colored(color, text)
    r.ImGui_TextColored(self.ctx, color, text)
end

--- Display wrapped text.
-- @param text string
function Context:text_wrapped(text)
    r.ImGui_TextWrapped(self.ctx, text)
end

--- Create a button.
-- @param label string Button label
-- @param width number|nil Button width (0 = auto)
-- @param height number|nil Button height (0 = auto)
-- @return boolean True if clicked
function Context:button(label, width, height)
    width = width or 0
    height = height or 0
    return r.ImGui_Button(self.ctx, label, width, height)
end

--- Create a small button (no frame padding).
-- @param label string
-- @return boolean True if clicked
function Context:small_button(label)
    return r.ImGui_SmallButton(self.ctx, label)
end

--- Create an invisible button.
-- @param id string
-- @param width number
-- @param height number
-- @return boolean True if clicked
function Context:invisible_button(id, width, height)
    return r.ImGui_InvisibleButton(self.ctx, id, width, height)
end

--- Create a checkbox.
-- @param label string
-- @param value boolean Current value
-- @return boolean changed Whether value changed
-- @return boolean value New value
function Context:checkbox(label, value)
    local changed, new_value = r.ImGui_Checkbox(self.ctx, label, value)
    return changed, new_value
end

--- Create a radio button.
-- @param label string
-- @param active boolean Whether this option is active
-- @return boolean True if clicked
function Context:radio_button(label, active)
    return r.ImGui_RadioButton(self.ctx, label, active)
end

--- Create a selectable item.
-- @param label string
-- @param selected boolean|nil Whether selected
-- @param flags number|nil Selectable flags
-- @return boolean True if clicked
function Context:selectable(label, selected, flags, size_w, size_h)
    selected = selected or false
    flags = flags or 0
    size_w = size_w or 0
    size_h = size_h or 0
    return r.ImGui_Selectable(self.ctx, label, selected, flags, size_w, size_h)
end

--------------------------------------------------------------------------------
-- Input Widgets
--------------------------------------------------------------------------------

--- Create a text input.
-- @param label string
-- @param value string Current value
-- @param flags number|nil Input text flags
-- @return boolean changed
-- @return string new_value
function Context:input_text(label, value, flags)
    flags = flags or 0
    return r.ImGui_InputText(self.ctx, label, value, flags)
end

--- Create an integer input.
-- @param label string
-- @param value number Current value
-- @param step number|nil Step amount
-- @param step_fast number|nil Fast step amount
-- @return boolean changed
-- @return number new_value
function Context:input_int(label, value, step, step_fast)
    step = step or 1
    step_fast = step_fast or 100
    return r.ImGui_InputInt(self.ctx, label, value, step, step_fast)
end

--- Create a float input.
-- @param label string
-- @param value number Current value
-- @param step number|nil Step amount
-- @param step_fast number|nil Fast step amount
-- @param format string|nil Display format
-- @return boolean changed
-- @return number new_value
function Context:input_double(label, value, step, step_fast, format)
    step = step or 0.0
    step_fast = step_fast or 0.0
    format = format or "%.3f"
    return r.ImGui_InputDouble(self.ctx, label, value, step, step_fast, format)
end

--- Create a slider (integer).
-- @param label string
-- @param value number Current value
-- @param min number Minimum value
-- @param max number Maximum value
-- @param format string|nil Display format
-- @return boolean changed
-- @return number new_value
function Context:slider_int(label, value, min, max, format)
    format = format or "%d"
    return r.ImGui_SliderInt(self.ctx, label, value, min, max, format)
end

--- Create a slider (float).
-- @param label string
-- @param value number Current value
-- @param min number Minimum value
-- @param max number Maximum value
-- @param format string|nil Display format
-- @return boolean changed
-- @return number new_value
function Context:slider_double(label, value, min, max, format)
    format = format or "%.3f"
    return r.ImGui_SliderDouble(self.ctx, label, value, min, max, format)
end

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

--- Add horizontal spacing and continue on same line.
function Context:same_line()
    r.ImGui_SameLine(self.ctx)
end

--- Add horizontal spacing and continue on same line with offset.
-- @param offset number|nil X offset
-- @param spacing number|nil Spacing
function Context:same_line_ex(offset, spacing)
    offset = offset or 0
    spacing = spacing or -1
    r.ImGui_SameLine(self.ctx, offset, spacing)
end

--- Add vertical spacing.
function Context:spacing()
    r.ImGui_Spacing(self.ctx)
end

--- Add a separator line.
function Context:separator()
    r.ImGui_Separator(self.ctx)
end

--- Add a newline.
function Context:newline()
    r.ImGui_NewLine(self.ctx)
end

--- Begin a horizontal group.
function Context:begin_group()
    r.ImGui_BeginGroup(self.ctx)
end

--- End a horizontal group.
function Context:end_group()
    r.ImGui_EndGroup(self.ctx)
end

--- Push item width.
-- @param width number Item width (-1 = remaining, 0 = default)
function Context:push_item_width(width)
    r.ImGui_PushItemWidth(self.ctx, width)
end

--- Pop item width.
function Context:pop_item_width()
    r.ImGui_PopItemWidth(self.ctx)
end

--- Set cursor position X.
-- @param x number
function Context:set_cursor_pos_x(x)
    r.ImGui_SetCursorPosX(self.ctx, x)
end

--- Set cursor position Y.
-- @param y number
function Context:set_cursor_pos_y(y)
    r.ImGui_SetCursorPosY(self.ctx, y)
end

--- Get cursor position X.
-- @return number
function Context:get_cursor_pos_x()
    return r.ImGui_GetCursorPosX(self.ctx)
end

--- Get cursor position Y.
-- @return number
function Context:get_cursor_pos_y()
    return r.ImGui_GetCursorPosY(self.ctx)
end

--- Indent content.
-- @param width number|nil Indent width
function Context:indent(width)
    width = width or 0
    r.ImGui_Indent(self.ctx, width)
end

--- Unindent content.
-- @param width number|nil Unindent width
function Context:unindent(width)
    width = width or 0
    r.ImGui_Unindent(self.ctx, width)
end

--------------------------------------------------------------------------------
-- ID Stack
--------------------------------------------------------------------------------

--- Push an ID onto the ID stack.
-- Use to avoid ID conflicts when creating multiple widgets with same labels.
-- @param id string|number ID to push
function Context:push_id(id)
    if type(id) == "number" then
        r.ImGui_PushID(self.ctx, id)
    else
        r.ImGui_PushID(self.ctx, tostring(id))
    end
end

--- Pop an ID from the ID stack.
function Context:pop_id()
    r.ImGui_PopID(self.ctx)
end

--- Set width for the next item.
-- @param width number Width in pixels
function Context:set_next_item_width(width)
    r.ImGui_SetNextItemWidth(self.ctx, width)
end

--------------------------------------------------------------------------------
-- Tables
--------------------------------------------------------------------------------

--- Begin a table.
-- @param id string Table ID
-- @param columns number Number of columns
-- @param flags number|nil Table flags
-- @return boolean
function Context:begin_table(id, columns, flags)
    flags = flags or 0
    return r.ImGui_BeginTable(self.ctx, id, columns, flags)
end

--- End a table.
function Context:end_table()
    r.ImGui_EndTable(self.ctx)
end

--- Move to next table row.
-- @param flags number|nil Row flags
-- @param min_height number|nil Minimum row height
function Context:table_next_row(flags, min_height)
    flags = flags or 0
    min_height = min_height or 0
    r.ImGui_TableNextRow(self.ctx, flags, min_height)
end

--- Move to next table column.
-- @return boolean
function Context:table_next_column()
    return r.ImGui_TableNextColumn(self.ctx)
end

--- Set current table column index.
-- @param column number Column index (0-based)
-- @return boolean
function Context:table_set_column_index(column)
    return r.ImGui_TableSetColumnIndex(self.ctx, column)
end

--- Set up a table column.
-- @param label string Column label
-- @param flags number|nil Column flags
-- @param init_width number|nil Initial width
function Context:table_setup_column(label, flags, init_width)
    flags = flags or 0
    init_width = init_width or 0
    r.ImGui_TableSetupColumn(self.ctx, label, flags, init_width)
end

--- Display table headers row.
function Context:table_headers_row()
    r.ImGui_TableHeadersRow(self.ctx)
end

--------------------------------------------------------------------------------
-- Trees & Collapsing Headers
--------------------------------------------------------------------------------

--- Create a tree node.
-- @param label string
-- @param flags number|nil Tree node flags
-- @return boolean True if open
function Context:tree_node(label, flags)
    flags = flags or 0
    return r.ImGui_TreeNode(self.ctx, label, flags)
end

--- Create a tree node with extended options.
-- @param label string
-- @param flags number|nil Tree node flags
-- @return boolean True if open
function Context:tree_node_ex(label, flags)
    flags = flags or 0
    return r.ImGui_TreeNodeEx(self.ctx, label, flags)
end

--- Pop a tree node.
function Context:tree_pop()
    r.ImGui_TreePop(self.ctx)
end

--- Create a collapsing header.
-- @param label string
-- @param flags number|nil
-- @return boolean True if open
function Context:collapsing_header(label, flags)
    flags = flags or 0
    return r.ImGui_CollapsingHeader(self.ctx, label, nil, flags)
end

--------------------------------------------------------------------------------
-- Popups & Modals
--------------------------------------------------------------------------------

--- Begin a popup.
-- @param id string Popup ID
-- @param flags number|nil Window flags
-- @return boolean
function Context:begin_popup(id, flags)
    flags = flags or 0
    return r.ImGui_BeginPopup(self.ctx, id, flags)
end

--- Begin a popup modal.
-- @param title string Modal title
-- @param p_open boolean|nil
-- @param flags number|nil Window flags
-- @return boolean visible
-- @return boolean|nil open
function Context:begin_popup_modal(title, p_open, flags)
    flags = flags or 0
    return r.ImGui_BeginPopupModal(self.ctx, title, p_open, flags)
end

--- End a popup.
function Context:end_popup()
    r.ImGui_EndPopup(self.ctx)
end

--- Open a popup.
-- @param id string Popup ID
function Context:open_popup(id)
    r.ImGui_OpenPopup(self.ctx, id)
end

--- Close current popup.
function Context:close_current_popup()
    r.ImGui_CloseCurrentPopup(self.ctx)
end

--- Begin a context menu (right-click popup).
-- @param id string|nil Popup ID
-- @return boolean
function Context:begin_popup_context_item(id)
    return r.ImGui_BeginPopupContextItem(self.ctx, id)
end

--------------------------------------------------------------------------------
-- Tooltips
--------------------------------------------------------------------------------

--- Set tooltip for previous item.
-- @param text string Tooltip text
function Context:set_tooltip(text)
    r.ImGui_SetTooltip(self.ctx, text)
end

--- Begin a tooltip region.
function Context:begin_tooltip()
    r.ImGui_BeginTooltip(self.ctx)
end

--- End a tooltip region.
function Context:end_tooltip()
    r.ImGui_EndTooltip(self.ctx)
end

--- Show tooltip if previous item is hovered.
-- @param text string Tooltip text
function Context:help_marker(text)
    if r.ImGui_IsItemHovered(self.ctx) then
        r.ImGui_SetTooltip(self.ctx, text)
    end
end

--------------------------------------------------------------------------------
-- Menus
--------------------------------------------------------------------------------

--- Begin a menu bar.
-- @return boolean
function Context:begin_menu_bar()
    return r.ImGui_BeginMenuBar(self.ctx)
end

--- End a menu bar.
function Context:end_menu_bar()
    r.ImGui_EndMenuBar(self.ctx)
end

--- Begin a menu.
-- @param label string Menu label
-- @param enabled boolean|nil Whether enabled
-- @return boolean
function Context:begin_menu(label, enabled)
    enabled = enabled == nil and true or enabled
    return r.ImGui_BeginMenu(self.ctx, label, enabled)
end

--- End a menu.
function Context:end_menu()
    r.ImGui_EndMenu(self.ctx)
end

--- Create a menu item.
-- @param label string Item label
-- @param shortcut string|nil Keyboard shortcut text
-- @param selected boolean|nil Whether selected
-- @param enabled boolean|nil Whether enabled
-- @return boolean clicked
function Context:menu_item(label, shortcut, selected, enabled)
    shortcut = shortcut or ""
    selected = selected or false
    enabled = enabled == nil and true or enabled
    return r.ImGui_MenuItem(self.ctx, label, shortcut, selected, enabled)
end

--------------------------------------------------------------------------------
-- Tabs
--------------------------------------------------------------------------------

--- Begin a tab bar.
-- @param id string Tab bar ID
-- @param flags number|nil Tab bar flags
-- @return boolean
function Context:begin_tab_bar(id, flags)
    flags = flags or 0
    return r.ImGui_BeginTabBar(self.ctx, id, flags)
end

--- End a tab bar.
function Context:end_tab_bar()
    r.ImGui_EndTabBar(self.ctx)
end

--- Begin a tab item.
-- @param label string Tab label
-- @param p_open boolean|nil Closeable tab flag
-- @param flags number|nil Tab item flags
-- @return boolean selected
-- @return boolean|nil open
function Context:begin_tab_item(label, p_open, flags)
    flags = flags or 0
    return r.ImGui_BeginTabItem(self.ctx, label, p_open, flags)
end

--- End a tab item.
function Context:end_tab_item()
    r.ImGui_EndTabItem(self.ctx)
end

--------------------------------------------------------------------------------
-- State Queries
--------------------------------------------------------------------------------

--- Check if previous item is hovered.
-- @param flags number|nil Hovered flags
-- @return boolean
function Context:is_item_hovered(flags)
    flags = flags or 0
    return r.ImGui_IsItemHovered(self.ctx, flags)
end

--- Check if previous item is clicked.
-- @param button number|nil Mouse button (0=left, 1=right, 2=middle)
-- @return boolean
function Context:is_item_clicked(button)
    button = button or 0
    return r.ImGui_IsItemClicked(self.ctx, button)
end

--- Check if previous item is active.
-- @return boolean
function Context:is_item_active()
    return r.ImGui_IsItemActive(self.ctx)
end

--- Check if previous item is focused.
-- @return boolean
function Context:is_item_focused()
    return r.ImGui_IsItemFocused(self.ctx)
end

--- Check if mouse button is down.
-- @param button number Mouse button
-- @return boolean
function Context:is_mouse_down(button)
    return r.ImGui_IsMouseDown(self.ctx, button)
end

--- Check if mouse button was clicked.
-- @param button number Mouse button
-- @return boolean
function Context:is_mouse_clicked(button)
    return r.ImGui_IsMouseClicked(self.ctx, button)
end

--- Check if mouse button was double-clicked.
-- @param button number Mouse button
-- @return boolean
function Context:is_mouse_double_clicked(button)
    return r.ImGui_IsMouseDoubleClicked(self.ctx, button)
end

--- Check if key is down.
-- @param key number Key code
-- @return boolean
function Context:is_key_down(key)
    return r.ImGui_IsKeyDown(self.ctx, key)
end

--- Check if key was pressed.
-- @param key number Key code
-- @return boolean
function Context:is_key_pressed(key)
    return r.ImGui_IsKeyPressed(self.ctx, key)
end

--- Get current modifier key flags.
-- @return number Bitmask of modifier keys
function Context:get_key_mods()
    return r.ImGui_GetKeyMods(self.ctx)
end

--- Check if shift modifier is held.
-- @return boolean
function Context:is_shift_down()
    local mods = r.ImGui_GetKeyMods(self.ctx)
    return (mods & r.ImGui_Mod_Shift()) ~= 0
end

--- Check if ctrl/cmd modifier is held.
-- @return boolean
function Context:is_ctrl_down()
    local mods = r.ImGui_GetKeyMods(self.ctx)
    return (mods & r.ImGui_Mod_Ctrl()) ~= 0
end

--- Check if alt modifier is held.
-- @return boolean
function Context:is_alt_down()
    local mods = r.ImGui_GetKeyMods(self.ctx)
    return (mods & r.ImGui_Mod_Alt()) ~= 0
end

--------------------------------------------------------------------------------
-- Drag and Drop
--------------------------------------------------------------------------------

--- Begin a drag source on the last item.
-- Call between item creation and next item. Returns true if dragging.
-- @param flags number|nil DragDropFlags (default 0)
-- @return boolean True if drag source is active
function Context:begin_drag_drop_source(flags)
    return r.ImGui_BeginDragDropSource(self.ctx, flags or 0)
end

--- End drag source (must call if begin_drag_drop_source returned true).
function Context:end_drag_drop_source()
    r.ImGui_EndDragDropSource(self.ctx)
end

--- Set drag payload data.
-- @param type string Payload type identifier
-- @param data string Payload data
-- @param cond number|nil SetCond flags (default Always)
-- @return boolean
function Context:set_drag_drop_payload(type, data, cond)
    return r.ImGui_SetDragDropPayload(self.ctx, type, data, cond)
end

--- Begin a drop target on the last item.
-- @return boolean True if drop target is active
function Context:begin_drag_drop_target()
    return r.ImGui_BeginDragDropTarget(self.ctx)
end

--- End drop target (must call if begin_drag_drop_target returned true).
function Context:end_drag_drop_target()
    r.ImGui_EndDragDropTarget(self.ctx)
end

--- Accept a drag payload.
-- @param type string Expected payload type
-- @param flags number|nil DragDropFlags (default 0)
-- @return boolean, string|nil Accepted, payload data
function Context:accept_drag_drop_payload(type, flags)
    local rv, payload = r.ImGui_AcceptDragDropPayload(self.ctx, type, flags or 0)
    return rv, payload
end

--- Get current drag payload (peek without accepting).
-- @param type string|nil Expected payload type (nil for any)
-- @return boolean, string|nil Has payload, payload data
function Context:get_drag_drop_payload(type)
    return r.ImGui_GetDragDropPayload(self.ctx, type)
end

--------------------------------------------------------------------------------
-- Disabled State
--------------------------------------------------------------------------------

--- Begin disabled state.
-- @param disabled boolean|nil Whether to disable (default true)
function Context:begin_disabled(disabled)
    disabled = disabled == nil and true or disabled
    r.ImGui_BeginDisabled(self.ctx, disabled)
end

--- End disabled state.
function Context:end_disabled()
    r.ImGui_EndDisabled(self.ctx)
end

--- Execute callback in disabled state if condition is true.
-- @param disabled boolean Whether to disable
-- @param fn function Callback to execute
function Context:with_disabled(disabled, fn)
    if disabled then
        self:begin_disabled()
    end
    fn()
    if disabled then
        self:end_disabled()
    end
end

--------------------------------------------------------------------------------
-- Style
--------------------------------------------------------------------------------

--- Push a style color.
-- @param idx number Color index (ImGui_Col_*)
-- @param color number RGBA color
function Context:push_style_color(idx, color)
    r.ImGui_PushStyleColor(self.ctx, idx, color)
    self._style_stack[#self._style_stack + 1] = "color"
end

--- Pop style colors.
-- @param count number|nil Number to pop (default 1)
function Context:pop_style_color(count)
    count = count or 1
    r.ImGui_PopStyleColor(self.ctx, count)
    for _ = 1, count do
        table.remove(self._style_stack)
    end
end

--- Push a style variable (float).
-- @param idx number Variable index (ImGui_StyleVar_*)
-- @param value number Value
function Context:push_style_var(idx, value)
    r.ImGui_PushStyleVar(self.ctx, idx, value)
    self._style_stack[#self._style_stack + 1] = "var"
end

--- Pop style variables.
-- @param count number|nil Number to pop (default 1)
function Context:pop_style_var(count)
    count = count or 1
    r.ImGui_PopStyleVar(self.ctx, count)
    for _ = 1, count do
        table.remove(self._style_stack)
    end
end

--------------------------------------------------------------------------------
-- Utility
--------------------------------------------------------------------------------

--- Calculate text size.
-- @param text string
-- @return number width
-- @return number height
function Context:calc_text_size(text)
    return r.ImGui_CalcTextSize(self.ctx, text)
end

--- Get content region available width.
-- @return number
function Context:get_content_region_avail_width()
    local w, _ = r.ImGui_GetContentRegionAvail(self.ctx)
    return w
end

--- Get content region available.
-- @return number width
-- @return number height
function Context:get_content_region_avail()
    return r.ImGui_GetContentRegionAvail(self.ctx)
end

--- Get window size.
-- @return number width
-- @return number height
function Context:get_window_size()
    return r.ImGui_GetWindowSize(self.ctx)
end

--- Get window position.
-- @return number x
-- @return number y
function Context:get_window_pos()
    return r.ImGui_GetWindowPos(self.ctx)
end

--------------------------------------------------------------------------------
-- Module Exports
--------------------------------------------------------------------------------

M.Context = Context

--- Create a new context (convenience function).
-- @param name string Context name
-- @param opts table|nil Options
-- @return Context
function M.create_context(name, opts)
    return Context:new(name, opts)
end

--- Check if ReaImGui is available.
-- @return boolean
function M.is_available()
    return r.ImGui_CreateContext ~= nil
end

--- Get ReaImGui version.
-- @return string|nil Version string or nil if not available
function M.get_version()
    if M.is_available() then
        return r.ImGui_GetVersion()
    end
    return nil
end

-- Flag constants (shortcuts)
M.WindowFlags = {
    None = function() return r.ImGui_WindowFlags_None() end,
    NoTitleBar = function() return r.ImGui_WindowFlags_NoTitleBar() end,
    NoResize = function() return r.ImGui_WindowFlags_NoResize() end,
    NoMove = function() return r.ImGui_WindowFlags_NoMove() end,
    NoScrollbar = function() return r.ImGui_WindowFlags_NoScrollbar() end,
    NoCollapse = function() return r.ImGui_WindowFlags_NoCollapse() end,
    MenuBar = function() return r.ImGui_WindowFlags_MenuBar() end,
    AlwaysAutoResize = function() return r.ImGui_WindowFlags_AlwaysAutoResize() end,
}

-- ChildFlags (newer ReaImGui versions - provide safe fallbacks)
local function safe_flag(fn, fallback)
    return function()
        if fn then
            local ok, val = pcall(fn)
            if ok then return val end
        end
        return fallback or 0
    end
end

M.ChildFlags = {
    None = safe_flag(r.ImGui_ChildFlags_None, 0),
    Border = safe_flag(r.ImGui_ChildFlags_Border, 1),  -- 1 = border in older API
    AlwaysAutoResize = safe_flag(r.ImGui_ChildFlags_AlwaysAutoResize, 0),
}

M.TreeNodeFlags = {
    None = function() return r.ImGui_TreeNodeFlags_None() end,
    Selected = function() return r.ImGui_TreeNodeFlags_Selected() end,
    Framed = function() return r.ImGui_TreeNodeFlags_Framed() end,
    AllowOverlap = function() return r.ImGui_TreeNodeFlags_AllowOverlap() end,
    NoTreePushOnOpen = function() return r.ImGui_TreeNodeFlags_NoTreePushOnOpen() end,
    NoAutoOpenOnLog = function() return r.ImGui_TreeNodeFlags_NoAutoOpenOnLog() end,
    DefaultOpen = function() return r.ImGui_TreeNodeFlags_DefaultOpen() end,
    OpenOnDoubleClick = function() return r.ImGui_TreeNodeFlags_OpenOnDoubleClick() end,
    OpenOnArrow = function() return r.ImGui_TreeNodeFlags_OpenOnArrow() end,
    Leaf = function() return r.ImGui_TreeNodeFlags_Leaf() end,
    Bullet = function() return r.ImGui_TreeNodeFlags_Bullet() end,
    FramePadding = function() return r.ImGui_TreeNodeFlags_FramePadding() end,
    SpanAvailWidth = function() return r.ImGui_TreeNodeFlags_SpanAvailWidth() end,
    SpanFullWidth = function() return r.ImGui_TreeNodeFlags_SpanFullWidth() end,
    CollapsingHeader = function() return r.ImGui_TreeNodeFlags_CollapsingHeader() end,
}

M.TableFlags = {
    None = safe_flag(r.ImGui_TableFlags_None, 0),
    Resizable = safe_flag(r.ImGui_TableFlags_Resizable, 0),
    Borders = safe_flag(r.ImGui_TableFlags_Borders, 0),
    BordersH = safe_flag(r.ImGui_TableFlags_BordersH, 0),
    BordersV = safe_flag(r.ImGui_TableFlags_BordersV, 0),
    RowBg = safe_flag(r.ImGui_TableFlags_RowBg, 0),
    SizingStretchSame = safe_flag(r.ImGui_TableFlags_SizingStretchSame, 0),
    SizingStretchProp = safe_flag(r.ImGui_TableFlags_SizingStretchProp, 0),
}

M.TableColumnFlags = {
    None = safe_flag(r.ImGui_TableColumnFlags_None, 0),
    WidthStretch = safe_flag(r.ImGui_TableColumnFlags_WidthStretch, 0),
    WidthFixed = safe_flag(r.ImGui_TableColumnFlags_WidthFixed, 0),
    NoResize = safe_flag(r.ImGui_TableColumnFlags_NoResize, 0),
}

M.InputTextFlags = {
    None = function() return r.ImGui_InputTextFlags_None() end,
    CharsDecimal = function() return r.ImGui_InputTextFlags_CharsDecimal() end,
    CharsHexadecimal = function() return r.ImGui_InputTextFlags_CharsHexadecimal() end,
    CharsUppercase = function() return r.ImGui_InputTextFlags_CharsUppercase() end,
    CharsNoBlank = function() return r.ImGui_InputTextFlags_CharsNoBlank() end,
    AutoSelectAll = function() return r.ImGui_InputTextFlags_AutoSelectAll() end,
    EnterReturnsTrue = function() return r.ImGui_InputTextFlags_EnterReturnsTrue() end,
    AllowTabInput = function() return r.ImGui_InputTextFlags_AllowTabInput() end,
    CtrlEnterForNewLine = function() return r.ImGui_InputTextFlags_CtrlEnterForNewLine() end,
    NoHorizontalScroll = function() return r.ImGui_InputTextFlags_NoHorizontalScroll() end,
    ReadOnly = function() return r.ImGui_InputTextFlags_ReadOnly() end,
    Password = function() return r.ImGui_InputTextFlags_Password() end,
}

M.Cond = {
    Always = function() return r.ImGui_Cond_Always() end,
    Once = function() return r.ImGui_Cond_Once() end,
    FirstUseEver = function() return r.ImGui_Cond_FirstUseEver() end,
    Appearing = function() return r.ImGui_Cond_Appearing() end,
}

M.Col = {
    Text = function() return r.ImGui_Col_Text() end,
    WindowBg = function() return r.ImGui_Col_WindowBg() end,
    Button = function() return r.ImGui_Col_Button() end,
    ButtonHovered = function() return r.ImGui_Col_ButtonHovered() end,
    ButtonActive = function() return r.ImGui_Col_ButtonActive() end,
    Header = function() return r.ImGui_Col_Header() end,
    HeaderHovered = function() return r.ImGui_Col_HeaderHovered() end,
    HeaderActive = function() return r.ImGui_Col_HeaderActive() end,
}

M.Key = {
    Shift = function() return r.ImGui_Mod_Shift() end,
    Ctrl = function() return r.ImGui_Mod_Ctrl() end,
    Alt = function() return r.ImGui_Mod_Alt() end,
    Super = function() return r.ImGui_Mod_Super() end,
}

M.ConfigFlags = {
    None = safe_flag(r.ImGui_ConfigFlags_None, 0),
    NavEnableKeyboard = safe_flag(r.ImGui_ConfigFlags_NavEnableKeyboard, 0),
    NavEnableGamepad = safe_flag(r.ImGui_ConfigFlags_NavEnableGamepad, 0),
    NoSavedSettings = safe_flag(r.ImGui_ConfigFlags_NoSavedSettings, 0),
    DockingEnable = safe_flag(r.ImGui_ConfigFlags_DockingEnable, 0),
}

return M
