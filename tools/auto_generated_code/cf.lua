-- Return the index of the next selected effect in the given FX chain. Start index should be -1. Returns -1 if there are no more selected effects.
-- @hwnd FxChain
-- @index integer
-- @return integer 
function CF:enum_selected_f_x(hwnd, index)
    return r.CF_EnumSelectedFX(hwnd, index)
end

-- Main=0, Main (alt recording)=100, MIDI Editor=32060, MIDI Event List Editor=32061, MIDI Inline Editor=32062, Media Explorer=32063
-- @section integer
-- @index integer
-- @return string 
function CF:enumerate_actions(section, index)
    local retval, name = r.CF_EnumerateActions(section, index)
    if retval then
        return name
    end
end

-- Read the contents of the system clipboard.
-- @return string 
function CF:get_clipboard()
    return r.CF_GetClipboard()
end

-- [DEPRECATED: Use CF_GetClipboard] Read the contents of the system clipboard. See SNM_CreateFastString and SNM_DeleteFastString.
-- @output WDL_FastString
-- @return string 
function CF:get_clipboard_big(output)
    return r.CF_GetClipboardBig(output)
end

-- Wrapper for the unexposed kbd_getTextFromCmd API function. See CF_EnumerateActions for common section IDs.
-- @section integer
-- @command integer
-- @return string 
function CF:get_command_text(section, command)
    return r.CF_GetCommandText(section, command)
end

-- Return a handle to the currently focused FX chain window.
-- @return FxChain 
function CF:get_focused_f_x_chain()
    return r.CF_GetFocusedFXChain()
end

-- Return the current SWS version number.
-- @return string 
function CF:get_s_w_s_version()
    return r.CF_GetSWSVersion()
end

-- Select the given file in explorer/finder.
-- @file string
-- @return boolean 
function CF:locate_in_explorer(file)
    return r.CF_LocateInExplorer(file)
end

-- Write the given string into the system clipboard.
-- @str string
function CF:set_clipboard(str)
    return r.CF_SetClipboard(str)
end

-- Open the given file or URL in the default application. See also CF_LocateInExplorer.
-- @file string
-- @return boolean 
function CF:shell_execute(file)
    return r.CF_ShellExecute(file)
end

