--- Window abstraction for ReaImGui.
-- Provides a class-based approach to creating ImGui windows with lifecycle management.
-- @module imgui.window
-- @author Nomad Monad
-- @license MIT
-- @release 0.2.0

local r = reaper
local imgui = require("imgui")

--------------------------------------------------------------------------------
-- Window Class
--------------------------------------------------------------------------------

--- Window class for managing ImGui windows.
-- @type Window
local Window = {}
Window.__index = Window

--- Create a new Window instance.
-- @param opts table Window options
-- @param opts.title string Window title
-- @param opts.width number|nil Initial width (default 400)
-- @param opts.height number|nil Initial height (default 300)
-- @param opts.x number|nil Initial X position
-- @param opts.y number|nil Initial Y position
-- @param opts.flags number|nil Window flags
-- @param opts.closeable boolean|nil Whether window can be closed (default true)
-- @param opts.on_open function|nil Called when window opens
-- @param opts.on_close function|nil Called when window closes
-- @param opts.on_draw function Required draw callback (receives gui context)
-- @return Window
function Window:new(opts)
    assert(opts.title, "Window requires a title")
    assert(opts.on_draw, "Window requires an on_draw callback")

    local self = setmetatable({
        title = opts.title,
        width = opts.width or 400,
        height = opts.height or 300,
        x = opts.x,
        y = opts.y,
        flags = opts.flags or r.ImGui_WindowFlags_None(),
        closeable = opts.closeable ~= false,

        -- Callbacks
        on_open = opts.on_open,
        on_close = opts.on_close,
        on_draw = opts.on_draw,

        -- State
        _ctx = nil,
        _is_open = false,
        _first_frame = true,

        -- User data storage
        data = opts.data or {},
    }, Window)

    return self
end

--- Open the window and start rendering.
-- @param run_loop boolean|nil If true, runs the defer loop automatically
function Window:open(run_loop)
    if self._is_open then
        return
    end

    -- Check for ReaImGui
    if not imgui.is_available() then
        r.ShowMessageBox(
            "This script requires the ReaImGui extension.\n\nPlease install it via ReaPack.",
            self.title .. " - Missing Dependency",
            0
        )
        return
    end

    -- Create context
    self._ctx = imgui.create_context(self.title)
    self._is_open = true
    self._first_frame = true

    -- Callback
    if self.on_open then
        self:on_open()
    end

    -- Start render loop if requested
    if run_loop then
        self:_run_loop()
    end
end

--- Close the window.
function Window:close()
    if not self._is_open then
        return
    end

    self._is_open = false

    -- Callback
    if self.on_close then
        self:on_close()
    end

    -- Destroy context
    if self._ctx then
        self._ctx:destroy()
        self._ctx = nil
    end
end

--- Check if window is open.
-- @return boolean
function Window:is_open()
    return self._is_open
end

--- Get the ImGui context.
-- @return Context
function Window:get_context()
    return self._ctx
end

--- Render a single frame.
-- @return boolean True if window should continue, false if closed
function Window:render_frame()
    if not self._is_open or not self._ctx then
        return false
    end

    local ctx = self._ctx

    -- Set initial size/position on first frame
    if self._first_frame then
        ctx:set_next_window_size(self.width, self.height)
        if self.x and self.y then
            ctx:set_next_window_pos(self.x, self.y)
        end
        self._first_frame = false
    end

    -- Begin window
    local visible, open
    if self.closeable then
        visible, open = ctx:begin_window(self.title, true, self.flags)
    else
        visible, open = ctx:begin_window(self.title, nil, self.flags)
        open = true -- Non-closeable windows stay open
    end

    if visible then
        -- Call draw callback
        self:on_draw(ctx)
        ctx:end_window()
    end

    -- Handle close
    if not open then
        self:close()
        return false
    end

    return true
end

--- Internal: Run the defer loop.
function Window:_run_loop()
    local function frame()
        if self:render_frame() then
            r.defer(frame)
        end
    end
    r.defer(frame)
end

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

--- Create and immediately open a window.
-- @param opts table Window options (see Window:new)
-- @return Window
function Window.run(opts)
    local win = Window:new(opts)
    win:open(true)
    return win
end

--------------------------------------------------------------------------------
-- Modal Dialog
--------------------------------------------------------------------------------

--- Modal dialog class (extends Window behavior).
-- @type Modal
local Modal = setmetatable({}, { __index = Window })
Modal.__index = Modal

--- Create a new Modal dialog.
-- @param opts table Modal options (same as Window, plus result callback)
-- @param opts.on_result function|nil Called with result when modal closes
-- @return Modal
function Modal:new(opts)
    local self = Window.new(self, opts)
    self._is_modal = true
    self.on_result = opts.on_result
    self._result = nil
    return self
end

--- Set the modal result and close.
-- @param result any The result value
function Modal:set_result(result)
    self._result = result
    if self.on_result then
        self:on_result(result)
    end
    self:close()
end

--- Render a modal frame.
-- @return boolean
function Modal:render_frame()
    if not self._is_open or not self._ctx then
        return false
    end

    local ctx = self._ctx

    -- Set initial size/position on first frame
    if self._first_frame then
        ctx:set_next_window_size(self.width, self.height)
        self._first_frame = false
        -- Open the popup
        ctx:open_popup(self.title)
    end

    -- Begin modal
    local visible, open = ctx:begin_popup_modal(self.title, self.closeable, self.flags)

    if visible then
        -- Call draw callback
        self:on_draw(ctx)
        ctx:end_popup()
    end

    -- Handle close
    if not open then
        self:close()
        return false
    end

    return true
end

--------------------------------------------------------------------------------
-- Confirm Dialog Helper
--------------------------------------------------------------------------------

--- Show a confirmation dialog.
-- @param title string Dialog title
-- @param message string Message to display
-- @param on_confirm function Called if user confirms
-- @param on_cancel function|nil Called if user cancels
function Window.confirm(title, message, on_confirm, on_cancel)
    Window.run({
        title = title,
        width = 300,
        height = 120,
        flags = r.ImGui_WindowFlags_NoResize() | r.ImGui_WindowFlags_NoCollapse(),
        data = { message = message },
        on_draw = function(self, ctx)
            ctx:text_wrapped(self.data.message)
            ctx:spacing()
            ctx:separator()
            ctx:spacing()

            local btn_width = 80
            local avail = ctx:get_content_region_avail_width()
            ctx:set_cursor_pos_x((avail - btn_width * 2 - 10) / 2)

            if ctx:button("OK", btn_width, 0) then
                if on_confirm then on_confirm() end
                self:close()
            end
            ctx:same_line()
            if ctx:button("Cancel", btn_width, 0) then
                if on_cancel then on_cancel() end
                self:close()
            end
        end,
    })
end

--- Show an alert dialog.
-- @param title string Dialog title
-- @param message string Message to display
-- @param on_close function|nil Called when dialog closes
function Window.alert(title, message, on_close)
    Window.run({
        title = title,
        width = 300,
        height = 100,
        flags = r.ImGui_WindowFlags_NoResize() | r.ImGui_WindowFlags_NoCollapse(),
        data = { message = message },
        on_close = on_close,
        on_draw = function(self, ctx)
            ctx:text_wrapped(self.data.message)
            ctx:spacing()
            ctx:separator()
            ctx:spacing()

            local btn_width = 80
            local avail = ctx:get_content_region_avail_width()
            ctx:set_cursor_pos_x((avail - btn_width) / 2)

            if ctx:button("OK", btn_width, 0) then
                self:close()
            end
        end,
    })
end

--------------------------------------------------------------------------------
-- Module Exports
--------------------------------------------------------------------------------

return {
    Window = Window,
    Modal = Modal,
}
