-- @description JS: Provide implementation for JS functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local helpers = require('helpers')


local JS = {}



--- Create new JS instance.
-- @return JS table.
function JS:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the JS logger.
-- @param ... (varargs) Messages to log.
function JS:log(...)
    local logger = helpers.log_func('JS')
    logger(...)
    return nil
end

    
--- Actions Count Shortcuts.
-- Section: 0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI
-- Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
-- @param section integer
-- @param cmd_id integer
-- @return integer
function JS:actions_count_shortcuts(section, cmd_id)
    return r.JS_Actions_CountShortcuts(section, cmd_id)
end

    
--- Actions Delete Shortcut.
-- Section: 0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI
-- Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
-- @param section integer
-- @param cmd_id integer
-- @param shortcut_idx integer
-- @return boolean
function JS:actions_delete_shortcut(section, cmd_id, shortcut_idx)
    return r.JS_Actions_DeleteShortcut(section, cmd_id, shortcut_idx)
end

    
--- Actions Do Shortcut Dialog.
-- Section: 0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI
-- Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
-- @param section integer
-- @param cmd_id integer
-- @param shortcut_idx integer
-- @return boolean
function JS:actions_do_shortcut_dialog(section, cmd_id, shortcut_idx)
    return r.JS_Actions_DoShortcutDialog(section, cmd_id, shortcut_idx)
end

    
--- Actions Get Shortcut Desc.
-- Section: 0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI
-- Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
-- @param section integer
-- @param cmd_id integer
-- @param shortcut_idx integer
-- @return desc string
function JS:actions_get_shortcut_desc(section, cmd_id, shortcut_idx)
    local retval, desc = r.JS_Actions_GetShortcutDesc(section, cmd_id, shortcut_idx)
    if retval then
        return desc
    else
        return nil
    end
end

    
--- Byte.
-- Returns the unsigned byte at address[offset]. Offset is added as steps of 1 byte
-- each.
-- @param pointer identifier
-- @param offset integer
-- @return byte integer
function JS:byte(pointer, offset)
    return r.JS_Byte(pointer, offset)
end

    
--- Composite.
-- Composites a LICE bitmap with a REAPER window.  Each time that the window is re-
-- drawn, the bitmap will be blitted over the window's client area (with per-pixel
-- alpha blending).
-- @param window_hwnd identifier
-- @param dstx integer
-- @param dsty integer
-- @param dstw integer
-- @param dsth integer
-- @param sys_bitmap identifier
-- @param srcx integer
-- @param srcy integer
-- @param srcw integer
-- @param srch integer
-- @param auto_update unsupported
-- @return integer
function JS:composite(window_hwnd, dstx, dsty, dstw, dsth, sys_bitmap, srcx, srcy, srcw, srch, auto_update)
    return r.JS_Composite(window_hwnd, dstx, dsty, dstw, dsth, sys_bitmap, srcx, srcy, srcw, srch, auto_update)
end

    
--- Composite Delay.
-- On WindowsOS, flickering of composited images can be improved considerably by
-- slowing the refresh rate of the window.  The optimal refresh rate may depend on
-- the number of composited bitmaps.
-- @param window_hwnd identifier
-- @param min_time number
-- @param max_time number
-- @param num_bitmaps_when_max integer
-- @return prev_min_time number
-- @return prev_max_time number
-- @return prev_bitmaps integer
function JS:composite_delay(window_hwnd, min_time, max_time, num_bitmaps_when_max)
    local retval, prev_min_time, prev_max_time, prev_bitmaps = r.JS_Composite_Delay(window_hwnd, min_time, max_time, num_bitmaps_when_max)
    if retval then
        return prev_min_time, prev_max_time, prev_bitmaps
    else
        return nil
    end
end

    
--- Composite List Bitmaps.
-- Returns all bitmaps composited to the given window.
-- @param window_hwnd identifier
-- @return list string
function JS:composite_list_bitmaps(window_hwnd)
    local retval, list = r.JS_Composite_ListBitmaps(window_hwnd)
    if retval then
        return list
    else
        return nil
    end
end

    
--- Composite Unlink.
-- Unlinks the window and bitmap.
-- @param window_hwnd identifier
-- @param bitmap identifier
-- @param auto_update unsupported
function JS:composite_unlink(window_hwnd, bitmap, auto_update)
    return r.JS_Composite_Unlink(window_hwnd, bitmap, auto_update)
end

    
--- Dialog Browse For Folder.
-- retval is 1 if a file was selected, 0 if the user cancelled the dialog, and -1
-- if an error occurred.
-- @param caption string
-- @param initial_folder string
-- @return folder string
function JS:dialog_browse_for_folder(caption, initial_folder)
    local retval, folder = r.JS_Dialog_BrowseForFolder(caption, initial_folder)
    if retval then
        return folder
    else
        return nil
    end
end

    
--- Dialog Browse For Open Files.
-- If allowMultiple is true, multiple files may be selected. The returned string is
-- \0-separated, with the first substring containing the folder path and subsequent
-- substrings containing the file names.  * On macOS, the first substring may be
-- empty, and each file name will then contain its entire path.  * This function
-- only allows selection of existing files, and does not allow creation of new
-- files.
-- @param window_title string
-- @param initial_folder string
-- @param initial_file string
-- @param extension_list string
-- @param allow_multiple boolean
-- @return file_names string
function JS:dialog_browse_for_open_files(window_title, initial_folder, initial_file, extension_list, allow_multiple)
    local retval, file_names = r.JS_Dialog_BrowseForOpenFiles(window_title, initial_folder, initial_file, extension_list, allow_multiple)
    if retval then
        return file_names
    else
        return nil
    end
end

    
--- Dialog Browse For Save File.
-- retval is 1 if a file was selected, 0 if the user cancelled the dialog, or
-- negative if an error occurred.
-- @param window_title string
-- @param initial_folder string
-- @param initial_file string
-- @param extension_list string
-- @return file_name string
function JS:dialog_browse_for_save_file(window_title, initial_folder, initial_file, extension_list)
    local retval, file_name = r.JS_Dialog_BrowseForSaveFile(window_title, initial_folder, initial_file, extension_list)
    if retval then
        return file_name
    else
        return nil
    end
end

    
--- Double.
-- Returns the 8-byte floating point value at address[offset]. Offset is added as
-- steps of 8 bytes each.
-- @param pointer identifier
-- @param offset integer
-- @return double number
function JS:double(pointer, offset)
    return r.JS_Double(pointer, offset)
end

    
--- File Stat.
-- Returns information about a file.
-- @param file_path string
-- @return size number
-- @return accessed_time string
-- @return modified_time string
-- @return c_time string
-- @return device_id integer
-- @return device_special_id integer
-- @return inode integer
-- @return mode integer
-- @return num_links integer
-- @return owner_user_id integer
-- @return owner_group_id integer
function JS:file_stat(file_path)
    local retval, size, accessed_time, modified_time, c_time, device_id, device_special_id, inode, mode, num_links, owner_user_id, owner_group_id = r.JS_File_Stat(file_path)
    if retval then
        return size, accessed_time, modified_time, c_time, device_id, device_special_id, inode, mode, num_links, owner_user_id, owner_group_id
    else
        return nil
    end
end

    
--- Gdi Blit.
-- Blits between two device contexts, which may include LICE "system bitmaps".
-- @param dest_hdc identifier
-- @param dstx integer
-- @param dsty integer
-- @param source_hdc identifier
-- @param srcx integer
-- @param srxy integer
-- @param width integer
-- @param height integer
-- @param string mode optional
function JS:gdi_blit(dest_hdc, dstx, dsty, source_hdc, srcx, srxy, width, height, string)
    local string = string or nil
    return r.JS_GDI_Blit(dest_hdc, dstx, dsty, source_hdc, srcx, srxy, width, height, string)
end

    
--- Gdi Create Fill Brush.
-- @param color integer
-- @return identifier
function JS:gdi_create_fill_brush(color)
    return r.JS_GDI_CreateFillBrush(color)
end

    
--- Gdi Create Font.
-- Parameters:  * weight: 0 - 1000, with 0 = auto, 400 = normal and 700 = bold.  *
-- angle: the angle, in tenths of degrees, between the text and the x-axis of the
-- device.  * fontName: If empty string "", uses first font that matches the other
-- specified attributes.
-- @param height integer
-- @param weight integer
-- @param angle integer
-- @param italic boolean
-- @param underline boolean
-- @param strike boolean
-- @param font_name string
-- @return identifier
function JS:gdi_create_font(height, weight, angle, italic, underline, strike, font_name)
    return r.JS_GDI_CreateFont(height, weight, angle, italic, underline, strike, font_name)
end

    
--- Gdi Create Pen.
-- @param width integer
-- @param color integer
-- @return identifier
function JS:gdi_create_pen(width, color)
    return r.JS_GDI_CreatePen(width, color)
end

    
--- Gdi Delete Object.
-- @param gdi_object identifier
function JS:gdi_delete_object(gdi_object)
    return r.JS_GDI_DeleteObject(gdi_object)
end

    
--- Gdi Draw Text.
-- Parameters:  * align: Combination of: "TOP", "VCENTER", "LEFT", "HCENTER",
-- "RIGHT", "BOTTOM", "WORDBREAK", "SINGLELINE", "NOCLIP", "CALCRECT", "NOPREFIX"
-- or "ELLIPSIS"
-- @param device_hdc identifier
-- @param text string
-- @param len integer
-- @param left integer
-- @param top integer
-- @param right integer
-- @param bottom integer
-- @param align string
-- @return integer
function JS:gdi_draw_text(device_hdc, text, len, left, top, right, bottom, align)
    return r.JS_GDI_DrawText(device_hdc, text, len, left, top, right, bottom, align)
end

    
--- Gdi Fill Ellipse.
-- @param device_hdc identifier
-- @param left integer
-- @param top integer
-- @param right integer
-- @param bottom integer
function JS:gdi_fill_ellipse(device_hdc, left, top, right, bottom)
    return r.JS_GDI_FillEllipse(device_hdc, left, top, right, bottom)
end

    
--- Gdi Fill Polygon.
-- packedX and packedY are strings of points, each packed as "<i4".
-- @param device_hdc identifier
-- @param packed_x string
-- @param packed_y string
-- @param num_points integer
function JS:gdi_fill_polygon(device_hdc, packed_x, packed_y, num_points)
    return r.JS_GDI_FillPolygon(device_hdc, packed_x, packed_y, num_points)
end

    
--- Gdi Fill Rect.
-- @param device_hdc identifier
-- @param left integer
-- @param top integer
-- @param right integer
-- @param bottom integer
function JS:gdi_fill_rect(device_hdc, left, top, right, bottom)
    return r.JS_GDI_FillRect(device_hdc, left, top, right, bottom)
end

    
--- Gdi Fill Round Rect.
-- @param device_hdc identifier
-- @param left integer
-- @param top integer
-- @param right integer
-- @param bottom integer
-- @param xrnd integer
-- @param yrnd integer
function JS:gdi_fill_round_rect(device_hdc, left, top, right, bottom, xrnd, yrnd)
    return r.JS_GDI_FillRoundRect(device_hdc, left, top, right, bottom, xrnd, yrnd)
end

    
--- Gdi Get Client Dc.
-- Returns the device context for the client area of the specified window.
-- @param window_hwnd identifier
-- @return identifier
function JS:gdi_get_client_dc(window_hwnd)
    return r.JS_GDI_GetClientDC(window_hwnd)
end

    
--- Gdi Get Screen Dc.
-- Returns a device context for the entire screen.
-- @return identifier
function JS:gdi_get_screen_dc()
    return r.JS_GDI_GetScreenDC()
end

    
--- Gdi Get Sys Color.
-- @param gui_element string
-- @return integer
function JS:gdi_get_sys_color(gui_element)
    return r.JS_GDI_GetSysColor(gui_element)
end

    
--- Gdi Get Text Color.
-- @param device_hdc identifier
-- @return integer
function JS:gdi_get_text_color(device_hdc)
    return r.JS_GDI_GetTextColor(device_hdc)
end

    
--- Gdi Get Window Dc.
-- Returns the device context for the entire window, including title bar and frame.
-- @param window_hwnd identifier
-- @return identifier
function JS:gdi_get_window_dc(window_hwnd)
    return r.JS_GDI_GetWindowDC(window_hwnd)
end

    
--- Gdi Line.
-- @param device_hdc identifier
-- @param x1 integer
-- @param y1 integer
-- @param x2 integer
-- @param y2 integer
function JS:gdi_line(device_hdc, x1, y1, x2, y2)
    return r.JS_GDI_Line(device_hdc, x1, y1, x2, y2)
end

    
--- Gdi Polyline.
-- packedX and packedY are strings of points, each packed as "<i4".
-- @param device_hdc identifier
-- @param packed_x string
-- @param packed_y string
-- @param num_points integer
function JS:gdi_polyline(device_hdc, packed_x, packed_y, num_points)
    return r.JS_GDI_Polyline(device_hdc, packed_x, packed_y, num_points)
end

    
--- Gdi Release Dc.
-- To release a window HDC, both arguments must be supplied: the HWND as well as
-- the HDC.  To release a screen DC, only the HDC needs to be supplied.
-- @param device_hdc identifier
-- @param window_hwnd identifier
-- @return integer
function JS:gdi_release_dc(device_hdc, window_hwnd)
    return r.JS_GDI_ReleaseDC(device_hdc, window_hwnd)
end

    
--- Gdi Select Object.
-- Activates a font, pen, or fill brush for subsequent drawing in the specified
-- device context.
-- @param device_hdc identifier
-- @param gdi_object identifier
-- @return identifier
function JS:gdi_select_object(device_hdc, gdi_object)
    return r.JS_GDI_SelectObject(device_hdc, gdi_object)
end

    
--- Gdi Set Pixel.
-- @param device_hdc identifier
-- @param x integer
-- @param y integer
-- @param color integer
function JS:gdi_set_pixel(device_hdc, x, y, color)
    return r.JS_GDI_SetPixel(device_hdc, x, y, color)
end

    
--- Gdi Set Text Bk Color.
-- @param device_hdc identifier
-- @param color integer
function JS:gdi_set_text_bk_color(device_hdc, color)
    return r.JS_GDI_SetTextBkColor(device_hdc, color)
end

    
--- Gdi Set Text Bk Mode.
-- @param device_hdc identifier
-- @param mode integer
function JS:gdi_set_text_bk_mode(device_hdc, mode)
    return r.JS_GDI_SetTextBkMode(device_hdc, mode)
end

    
--- Gdi Set Text Color.
-- @param device_hdc identifier
-- @param color integer
function JS:gdi_set_text_color(device_hdc, color)
    return r.JS_GDI_SetTextColor(device_hdc, color)
end

    
--- Gdi Stretch Blit.
-- Blits between two device contexts, which may include LICE "system bitmaps".
-- @param dest_hdc identifier
-- @param dstx integer
-- @param dsty integer
-- @param dstw integer
-- @param dsth integer
-- @param source_hdc identifier
-- @param srcx integer
-- @param srxy integer
-- @param srcw integer
-- @param srch integer
-- @param string mode optional
function JS:gdi_stretch_blit(dest_hdc, dstx, dsty, dstw, dsth, source_hdc, srcx, srxy, srcw, srch, string)
    local string = string or nil
    return r.JS_GDI_StretchBlit(dest_hdc, dstx, dsty, dstw, dsth, source_hdc, srcx, srxy, srcw, srch, string)
end

    
--- Header Get Item Count.
-- @param header_hwnd identifier
-- @return integer
function JS:header_get_item_count(header_hwnd)
    return r.JS_Header_GetItemCount(header_hwnd)
end

    
--- Int.
-- Returns the 4-byte signed integer at address[offset]. Offset is added as steps
-- of 4 bytes each.
-- @param pointer identifier
-- @param offset integer
-- @return int integer
function JS:int(pointer, offset)
    return r.JS_Int(pointer, offset)
end

    
--- Lice Alter Bitmap Hsv.
-- Hue is rolled over, saturation and value are clamped, all 0..1. (Alpha remains
-- unchanged.)
-- @param bitmap identifier
-- @param hue number
-- @param saturation number
-- @param value number
function JS:lice_alter_bitmap_hsv(bitmap, hue, saturation, value)
    return r.JS_LICE_AlterBitmapHSV(bitmap, hue, saturation, value)
end

    
--- Lice Alter Rect Hsv.
-- Hue is rolled over, saturation and value are clamped, all 0..1. (Alpha remains
-- unchanged.)
-- @param bitmap identifier
-- @param x integer
-- @param y integer
-- @param w integer
-- @param h integer
-- @param hue number
-- @param saturation number
-- @param value number
function JS:lice_alter_rect_hsv(bitmap, x, y, w, h, hue, saturation, value)
    return r.JS_LICE_AlterRectHSV(bitmap, x, y, w, h, hue, saturation, value)
end

    
--- Lice Arc.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
-- @param bitmap identifier
-- @param cx number
-- @param cy number
-- @param r number
-- @param min_angle number
-- @param max_angle number
-- @param color integer
-- @param alpha number
-- @param mode string
-- @param antialias boolean
function JS:lice_arc(bitmap, cx, cy, r, min_angle, max_angle, color, alpha, mode, antialias)
    return r.JS_LICE_Arc(bitmap, cx, cy, r, min_angle, max_angle, color, alpha, mode, antialias)
end

    
--- Lice Array All Bitmaps.
-- @param reaperarray identifier
-- @return integer
function JS:lice_array_all_bitmaps(reaperarray)
    return r.JS_LICE_ArrayAllBitmaps(reaperarray)
end

    
--- Lice Bezier.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to enable per-
-- pixel alpha blending.
-- @param bitmap identifier
-- @param xstart number
-- @param ystart number
-- @param xctl1 number
-- @param yctl1 number
-- @param xctl2 number
-- @param yctl2 number
-- @param xend number
-- @param yend number
-- @param tol number
-- @param color integer
-- @param alpha number
-- @param mode string
-- @param antialias boolean
function JS:lice_bezier(bitmap, xstart, ystart, xctl1, yctl1, xctl2, yctl2, xend, yend, tol, color, alpha, mode, antialias)
    return r.JS_LICE_Bezier(bitmap, xstart, ystart, xctl1, yctl1, xctl2, yctl2, xend, yend, tol, color, alpha, mode, antialias)
end

    
--- Lice Blit.
-- Standard LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE",
-- "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to
-- enable per-pixel alpha blending.
-- @param dest_bitmap identifier
-- @param dstx integer
-- @param dsty integer
-- @param source_bitmap identifier
-- @param srcx integer
-- @param srcy integer
-- @param width integer
-- @param height integer
-- @param alpha number
-- @param mode string
function JS:lice_blit(dest_bitmap, dstx, dsty, source_bitmap, srcx, srcy, width, height, alpha, mode)
    return r.JS_LICE_Blit(dest_bitmap, dstx, dsty, source_bitmap, srcx, srcy, width, height, alpha, mode)
end

    
--- Lice Circle.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
-- @param bitmap identifier
-- @param cx number
-- @param cy number
-- @param r number
-- @param color integer
-- @param alpha number
-- @param mode string
-- @param antialias boolean
function JS:lice_circle(bitmap, cx, cy, r, color, alpha, mode, antialias)
    return r.JS_LICE_Circle(bitmap, cx, cy, r, color, alpha, mode, antialias)
end

    
--- Lice Clear.
-- @param bitmap identifier
-- @param color integer
function JS:lice_clear(bitmap, color)
    return r.JS_LICE_Clear(bitmap, color)
end

    
--- Lice Create Bitmap.
-- @param is__sys_bitmap boolean
-- @param width integer
-- @param height integer
-- @return identifier
function JS:lice_create_bitmap(is__sys_bitmap, width, height)
    return r.JS_LICE_CreateBitmap(is__sys_bitmap, width, height)
end

    
--- Lice Create Font.
-- @return identifier
function JS:lice_create_font()
    return r.JS_LICE_CreateFont()
end

    
--- Lice Destroy Bitmap.
-- Deletes the bitmap, and also unlinks bitmap from any composited window.
-- @param bitmap identifier
function JS:lice_destroy_bitmap(bitmap)
    return r.JS_LICE_DestroyBitmap(bitmap)
end

    
--- Lice Destroy Font.
-- @param lice_font identifier
function JS:lice_destroy_font(lice_font)
    return r.JS_LICE_DestroyFont(lice_font)
end

    
--- Lice Draw Char.
-- @param bitmap identifier
-- @param x integer
-- @param y integer
-- @param c integer
-- @param color integer
-- @param alpha number
-- @param mode integer
function JS:lice_draw_char(bitmap, x, y, c, color, alpha, mode)
    return r.JS_LICE_DrawChar(bitmap, x, y, c, color, alpha, mode)
end

    
--- Lice Draw Text.
-- @param bitmap identifier
-- @param lice_font identifier
-- @param text string
-- @param text_len integer
-- @param x1 integer
-- @param y1 integer
-- @param x2 integer
-- @param y2 integer
-- @return integer
function JS:lice_draw_text(bitmap, lice_font, text, text_len, x1, y1, x2, y2)
    return r.JS_LICE_DrawText(bitmap, lice_font, text, text_len, x1, y1, x2, y2)
end

    
--- Lice Fill Circle.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
-- @param bitmap identifier
-- @param cx number
-- @param cy number
-- @param r number
-- @param color integer
-- @param alpha number
-- @param mode string
-- @param antialias boolean
function JS:lice_fill_circle(bitmap, cx, cy, r, color, alpha, mode, antialias)
    return r.JS_LICE_FillCircle(bitmap, cx, cy, r, color, alpha, mode, antialias)
end

    
--- Lice Fill Polygon.
-- packedX and packedY are two strings of coordinates, each packed as "<i4".
-- @param bitmap identifier
-- @param packed_x string
-- @param packed_y string
-- @param num_points integer
-- @param color integer
-- @param alpha number
-- @param mode string
function JS:lice_fill_polygon(bitmap, packed_x, packed_y, num_points, color, alpha, mode)
    return r.JS_LICE_FillPolygon(bitmap, packed_x, packed_y, num_points, color, alpha, mode)
end

    
--- Lice Fill Rect.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
-- @param bitmap identifier
-- @param x integer
-- @param y integer
-- @param w integer
-- @param h integer
-- @param color integer
-- @param alpha number
-- @param mode string
function JS:lice_fill_rect(bitmap, x, y, w, h, color, alpha, mode)
    return r.JS_LICE_FillRect(bitmap, x, y, w, h, color, alpha, mode)
end

    
--- Lice Fill Triangle.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
-- @param bitmap identifier
-- @param x1 integer
-- @param y1 integer
-- @param x2 integer
-- @param y2 integer
-- @param x3 integer
-- @param y3 integer
-- @param color integer
-- @param alpha number
-- @param mode string
function JS:lice_fill_triangle(bitmap, x1, y1, x2, y2, x3, y3, color, alpha, mode)
    return r.JS_LICE_FillTriangle(bitmap, x1, y1, x2, y2, x3, y3, color, alpha, mode)
end

    
--- Lice Get Dc.
-- @param bitmap identifier
-- @return identifier
function JS:lice_get_dc(bitmap)
    return r.JS_LICE_GetDC(bitmap)
end

    
--- Lice Get Height.
-- @param bitmap identifier
-- @return integer
function JS:lice_get_height(bitmap)
    return r.JS_LICE_GetHeight(bitmap)
end

    
--- Lice Get Pixel.
-- Returns the color of the specified pixel.
-- @param bitmap identifier
-- @param x integer
-- @param y integer
-- @return color number
function JS:lice_get_pixel(bitmap, x, y)
    return r.JS_LICE_GetPixel(bitmap, x, y)
end

    
--- Lice Get Width.
-- @param bitmap identifier
-- @return integer
function JS:lice_get_width(bitmap)
    return r.JS_LICE_GetWidth(bitmap)
end

    
--- Lice Grad Rect.
-- @param bitmap identifier
-- @param dstx integer
-- @param dsty integer
-- @param dstw integer
-- @param dsth integer
-- @param ir number
-- @param ig number
-- @param ib number
-- @param ia number
-- @param drdx number
-- @param dgdx number
-- @param dbdx number
-- @param dadx number
-- @param drdy number
-- @param dgdy number
-- @param dbdy number
-- @param dady number
-- @param mode string
function JS:lice_grad_rect(bitmap, dstx, dsty, dstw, dsth, ir, ig, ib, ia, drdx, dgdx, dbdx, dadx, drdy, dgdy, dbdy, dady, mode)
    return r.JS_LICE_GradRect(bitmap, dstx, dsty, dstw, dsth, ir, ig, ib, ia, drdx, dgdx, dbdx, dadx, drdy, dgdy, dbdy, dady, mode)
end

    
--- Lice Is Flipped.
-- @param bitmap identifier
-- @return boolean
function JS:lice_is_flipped(bitmap)
    return r.JS_LICE_IsFlipped(bitmap)
end

    
--- Lice Line.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
-- @param bitmap identifier
-- @param x1 number
-- @param y1 number
-- @param x2 number
-- @param y2 number
-- @param color integer
-- @param alpha number
-- @param mode string
-- @param antialias boolean
function JS:lice_line(bitmap, x1, y1, x2, y2, color, alpha, mode, antialias)
    return r.JS_LICE_Line(bitmap, x1, y1, x2, y2, color, alpha, mode, antialias)
end

    
--- Lice List All Bitmaps.
-- @return list string
function JS:lice_list_all_bitmaps()
    local retval, list = r.JS_LICE_ListAllBitmaps()
    if retval then
        return list
    else
        return nil
    end
end

    
--- Lice Load Jpg.
-- Returns a system LICE bitmap containing the JPEG.
-- @param filename string
-- @return identifier
function JS:lice_load_jpg(filename)
    return r.JS_LICE_LoadJPG(filename)
end

    
--- Lice Load Jpg From Memory.
-- Returns a system LICE bitmap containing the JPEG.
-- @param buffer string
-- @param bufsize integer
-- @return identifier
function JS:lice_load_jpg_from_memory(buffer, bufsize)
    return r.JS_LICE_LoadJPGFromMemory(buffer, bufsize)
end

    
--- Lice Load Png.
-- Returns a system LICE bitmap containing the PNG.
-- @param filename string
-- @return identifier
function JS:lice_load_png(filename)
    return r.JS_LICE_LoadPNG(filename)
end

    
--- Lice Load Png From Memory.
-- Returns a system LICE bitmap containing the PNG.
-- @param buffer string
-- @param bufsize integer
-- @return identifier
function JS:lice_load_png_from_memory(buffer, bufsize)
    return r.JS_LICE_LoadPNGFromMemory(buffer, bufsize)
end

    
--- Lice Measure Text.
-- @param text string
-- @return width integer
-- @return height integer
function JS:lice_measure_text(text)
    return r.JS_LICE_MeasureText(text)
end

    
--- Lice Process Rect.
-- Applies bitwise operations to each pixel in the target rectangle.
-- @param bitmap identifier
-- @param x integer
-- @param y integer
-- @param w integer
-- @param h integer
-- @param mode string
-- @param operand number
-- @return boolean
function JS:lice_process_rect(bitmap, x, y, w, h, mode, operand)
    return r.JS_LICE_ProcessRect(bitmap, x, y, w, h, mode, operand)
end

    
--- Lice Put Pixel.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
-- @param bitmap identifier
-- @param x integer
-- @param y integer
-- @param color number
-- @param alpha number
-- @param mode string
function JS:lice_put_pixel(bitmap, x, y, color, alpha, mode)
    return r.JS_LICE_PutPixel(bitmap, x, y, color, alpha, mode)
end

    
--- Lice Resize.
-- @param bitmap identifier
-- @param width integer
-- @param height integer
function JS:lice_resize(bitmap, width, height)
    return r.JS_LICE_Resize(bitmap, width, height)
end

    
--- Lice Rotated Blit.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to enable per-
-- pixel alpha blending.
-- @param dest_bitmap identifier
-- @param dstx integer
-- @param dsty integer
-- @param dstw integer
-- @param dsth integer
-- @param source_bitmap identifier
-- @param srcx number
-- @param srcy number
-- @param srcw number
-- @param srch number
-- @param angle number
-- @param rotxcent number
-- @param rotycent number
-- @param cliptosourcerect boolean
-- @param alpha number
-- @param mode string
function JS:lice_rotated_blit(dest_bitmap, dstx, dsty, dstw, dsth, source_bitmap, srcx, srcy, srcw, srch, angle, rotxcent, rotycent, cliptosourcerect, alpha, mode)
    return r.JS_LICE_RotatedBlit(dest_bitmap, dstx, dsty, dstw, dsth, source_bitmap, srcx, srcy, srcw, srch, angle, rotxcent, rotycent, cliptosourcerect, alpha, mode)
end

    
--- Lice Round Rect.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
-- @param bitmap identifier
-- @param x number
-- @param y number
-- @param w number
-- @param h number
-- @param cornerradius integer
-- @param color integer
-- @param alpha number
-- @param mode string
-- @param antialias boolean
function JS:lice_round_rect(bitmap, x, y, w, h, cornerradius, color, alpha, mode, antialias)
    return r.JS_LICE_RoundRect(bitmap, x, y, w, h, cornerradius, color, alpha, mode, antialias)
end

    
--- Lice Scaled Blit.
-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL",
-- "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to enable per-
-- pixel alpha blending.
-- @param dest_bitmap identifier
-- @param dstx integer
-- @param dsty integer
-- @param dstw integer
-- @param dsth integer
-- @param src_bitmap identifier
-- @param srcx number
-- @param srcy number
-- @param srcw number
-- @param srch number
-- @param alpha number
-- @param mode string
function JS:lice_scaled_blit(dest_bitmap, dstx, dsty, dstw, dsth, src_bitmap, srcx, srcy, srcw, srch, alpha, mode)
    return r.JS_LICE_ScaledBlit(dest_bitmap, dstx, dsty, dstw, dsth, src_bitmap, srcx, srcy, srcw, srch, alpha, mode)
end

    
--- Lice Set Alpha From Color Mask.
-- Sets all pixels that match the given color's RGB values to fully transparent,
-- and all other pixels to fully opaque.  (All pixels' RGB values remain
-- unchanged.)
-- @param bitmap identifier
-- @param color_rgb integer
function JS:lice_set_alpha_from_color_mask(bitmap, color_rgb)
    return r.JS_LICE_SetAlphaFromColorMask(bitmap, color_rgb)
end

    
--- Lice Set Font Bk Color.
-- Sets the color of the font background.
-- @param lice_font identifier
-- @param color integer
function JS:lice_set_font_bk_color(lice_font, color)
    return r.JS_LICE_SetFontBkColor(lice_font, color)
end

    
--- Lice Set Font Color.
-- @param lice_font identifier
-- @param color integer
function JS:lice_set_font_color(lice_font, color)
    return r.JS_LICE_SetFontColor(lice_font, color)
end

    
--- Lice Set Font Fx Color.
-- Sets the color of font FX such as shadow.
-- @param lice_font identifier
-- @param color integer
function JS:lice_set_font_fx_color(lice_font, color)
    return r.JS_LICE_SetFontFXColor(lice_font, color)
end

    
--- Lice Set Font From Gdi.
-- Converts a GDI font into a LICE font.
-- @param lice_font identifier
-- @param gdi_font identifier
-- @param more_formats string
function JS:lice_set_font_from_gdi(lice_font, gdi_font, more_formats)
    return r.JS_LICE_SetFontFromGDI(lice_font, gdi_font, more_formats)
end

    
--- Lice Write Jpg.
-- Parameters:
-- @param filename string
-- @param bitmap identifier
-- @param quality integer
-- @param force_baseline unsupported
-- @return boolean
function JS:lice_write_jpg(filename, bitmap, quality, force_baseline)
    return r.JS_LICE_WriteJPG(filename, bitmap, quality, force_baseline)
end

    
--- Lice Write Png.
-- @param filename string
-- @param bitmap identifier
-- @param want_alpha boolean
-- @return boolean
function JS:lice_write_png(filename, bitmap, want_alpha)
    return r.JS_LICE_WritePNG(filename, bitmap, want_alpha)
end

    
--- List View Ensure Visible.
-- @param listview_hwnd identifier
-- @param index integer
-- @param partial_ok boolean
function JS:list_view_ensure_visible(listview_hwnd, index, partial_ok)
    return r.JS_ListView_EnsureVisible(listview_hwnd, index, partial_ok)
end

    
--- List View Enum Sel Items.
-- Returns the index of the next selected list item with index greater that the
-- specified number. Returns -1 if no selected items left.
-- @param listview_hwnd identifier
-- @param index integer
-- @return integer
function JS:list_view_enum_sel_items(listview_hwnd, index)
    return r.JS_ListView_EnumSelItems(listview_hwnd, index)
end

    
--- List View Get Focused Item.
-- Returns the index and text of the focused item, if any.
-- @param listview_hwnd identifier
-- @return text string
function JS:list_view_get_focused_item(listview_hwnd)
    local retval, text = r.JS_ListView_GetFocusedItem(listview_hwnd)
    if retval then
        return text
    else
        return nil
    end
end

    
--- List View Get Header.
-- @param listview_hwnd identifier
-- @return identifier
function JS:list_view_get_header(listview_hwnd)
    return r.JS_ListView_GetHeader(listview_hwnd)
end

    
--- List View Get Item.
-- Returns the text and state of specified item.
-- @param listview_hwnd identifier
-- @param index integer
-- @param sub_item integer
-- @return text string
-- @return state integer
function JS:list_view_get_item(listview_hwnd, index, sub_item)
    return r.JS_ListView_GetItem(listview_hwnd, index, sub_item)
end

    
--- List View Get Item Count.
-- @param listview_hwnd identifier
-- @return integer
function JS:list_view_get_item_count(listview_hwnd)
    return r.JS_ListView_GetItemCount(listview_hwnd)
end

    
--- List View Get Item Rect.
-- Returns client coordinates of the item.
-- @param listview_hwnd identifier
-- @param index integer
-- @return left integer
-- @return top integer
-- @return right integer
-- @return bottom integer
function JS:list_view_get_item_rect(listview_hwnd, index)
    local retval, left, top, right, bottom = r.JS_ListView_GetItemRect(listview_hwnd, index)
    if retval then
        return left, top, right, bottom
    else
        return nil
    end
end

    
--- List View Get Item State.
-- State is a bitmask: 1 = focused, 2 = selected. On Windows only, cut-and-paste
-- marked = 4, drag-and-drop highlighted = 8.
-- @param listview_hwnd identifier
-- @param index integer
-- @return integer
function JS:list_view_get_item_state(listview_hwnd, index)
    return r.JS_ListView_GetItemState(listview_hwnd, index)
end

    
--- List View Get Item Text.
-- @param listview_hwnd identifier
-- @param index integer
-- @param sub_item integer
-- @return text string
function JS:list_view_get_item_text(listview_hwnd, index, sub_item)
    return r.JS_ListView_GetItemText(listview_hwnd, index, sub_item)
end

    
--- List View Get Selected Count.
-- @param listview_hwnd identifier
-- @return integer
function JS:list_view_get_selected_count(listview_hwnd)
    return r.JS_ListView_GetSelectedCount(listview_hwnd)
end

    
--- List View Get Top Index.
-- @param listview_hwnd identifier
-- @return integer
function JS:list_view_get_top_index(listview_hwnd)
    return r.JS_ListView_GetTopIndex(listview_hwnd)
end

    
--- List View Hit Test.
-- @param listview_hwnd identifier
-- @param client_x integer
-- @param client_y integer
-- @return index integer
-- @return sub_item integer
-- @return flags integer
function JS:list_view_hit_test(listview_hwnd, client_x, client_y)
    return r.JS_ListView_HitTest(listview_hwnd, client_x, client_y)
end

    
--- List View List All Sel Items.
-- Returns the indices of all selected items as a comma-separated list.
-- @param listview_hwnd identifier
-- @return items string
function JS:list_view_list_all_sel_items(listview_hwnd)
    local retval, items = r.JS_ListView_ListAllSelItems(listview_hwnd)
    if retval then
        return items
    else
        return nil
    end
end

    
--- List View Set Item State.
-- The mask parameter specifies the state bits that must be set, and the state
-- parameter specifies the new values for those bits.
-- @param listview_hwnd identifier
-- @param index integer
-- @param state integer
-- @param mask integer
function JS:list_view_set_item_state(listview_hwnd, index, state, mask)
    return r.JS_ListView_SetItemState(listview_hwnd, index, state, mask)
end

    
--- List View Set Item Text.
-- Currently, this fuction only accepts ASCII text.
-- @param listview_hwnd identifier
-- @param index integer
-- @param sub_item integer
-- @param text string
function JS:list_view_set_item_text(listview_hwnd, index, sub_item, text)
    return r.JS_ListView_SetItemText(listview_hwnd, index, sub_item, text)
end

    
--- Localize.
-- Returns the translation of the given US English text, according to the currently
-- loaded Language Pack.
-- @param us_english string
-- @param lang_pack_section string
-- @return translation string
function JS:localize(us_english, lang_pack_section)
    return r.JS_Localize(us_english, lang_pack_section)
end

    
--- Midi Editor Array All.
-- Finds all open MIDI windows (whether docked or not).
-- @param reaperarray identifier
-- @return integer
function JS:midi_editor_array_all(reaperarray)
    return r.JS_MIDIEditor_ArrayAll(reaperarray)
end

    
--- Midi Editor List All.
-- Finds all open MIDI windows (whether docked or not).
-- @return list string
function JS:midi_editor_list_all()
    local retval, list = r.JS_MIDIEditor_ListAll()
    if retval then
        return list
    else
        return nil
    end
end

    
--- Mem Alloc.
-- Allocates memory for general use by functions that require memory buffers.
-- @param size_bytes integer
-- @return identifier
function JS:mem_alloc(size_bytes)
    return r.JS_Mem_Alloc(size_bytes)
end

    
--- Mem Free.
-- Frees memory that was previously allocated by JS_Mem_Alloc.
-- @param malloc_pointer identifier
-- @return boolean
function JS:mem_free(malloc_pointer)
    return r.JS_Mem_Free(malloc_pointer)
end

    
--- Mem From String.
-- Copies a packed string into a memory buffer.
-- @param malloc_pointer identifier
-- @param offset integer
-- @param packed_string string
-- @param string_length integer
-- @return boolean
function JS:mem_from_string(malloc_pointer, offset, packed_string, string_length)
    return r.JS_Mem_FromString(malloc_pointer, offset, packed_string, string_length)
end

    
--- Mouse Get Cursor.
-- On Windows, retrieves a handle to the current mouse cursor. On Linux and macOS,
-- retrieves a handle to the last cursor set by REAPER or its extensions via SWELL.
-- @return identifier
function JS:mouse_get_cursor()
    return r.JS_Mouse_GetCursor()
end

    
--- Mouse Get State.
-- Retrieves the states of mouse buttons and modifiers keys.
-- @param flags integer
-- @return integer
function JS:mouse_get_state(flags)
    return r.JS_Mouse_GetState(flags)
end

    
--- Mouse Load Cursor.
-- Loads a cursor by number.
-- @param cursor_number integer
-- @return identifier
function JS:mouse_load_cursor(cursor_number)
    return r.JS_Mouse_LoadCursor(cursor_number)
end

    
--- Mouse Load Cursor From File.
-- Loads a cursor from a .cur file.
-- @param path_and_file_name string
-- @param force_new_load unsupported
-- @return identifier
function JS:mouse_load_cursor_from_file(path_and_file_name, force_new_load)
    return r.JS_Mouse_LoadCursorFromFile(path_and_file_name, force_new_load)
end

    
--- Mouse Set Cursor.
-- Sets the mouse cursor.  (Only lasts while script is running, and for a single
-- "defer" cycle.)
-- @param cursor_handle identifier
function JS:mouse_set_cursor(cursor_handle)
    return r.JS_Mouse_SetCursor(cursor_handle)
end

    
--- Mouse Set Position.
-- Moves the mouse cursor to the specified screen coordinates.
-- @param x integer
-- @param y integer
-- @return boolean
function JS:mouse_set_position(x, y)
    return r.JS_Mouse_SetPosition(x, y)
end

    
--- Rea Script Api Version.
-- Returns the version of the js_ReaScriptAPI extension.
-- @return version number
function JS:rea_script_api_version()
    return r.JS_ReaScriptAPI_Version()
end

    
--- String.
-- Returns the memory contents starting at address[offset] as a packed string.
-- Offset is added as steps of 1 byte (char) each.
-- @param pointer identifier
-- @param offset integer
-- @param length_chars integer
-- @return buf string
function JS:string(pointer, offset, length_chars)
    local retval, buf = r.JS_String(pointer, offset, length_chars)
    if retval then
        return buf
    else
        return nil
    end
end

    
--- V Keys Get Down.
-- Returns a 255-byte array that specifies which virtual keys, from 0x01 to 0xFF,
-- have sent KEYDOWN messages since cutoffTime.
-- @param cutoff_time number
-- @return state string
function JS:v_keys_get_down(cutoff_time)
    return r.JS_VKeys_GetDown(cutoff_time)
end

    
--- V Keys Get State.
-- Retrieves the current states (0 or 1) of all virtual keys, from 0x01 to 0xFF, in
-- a 255-byte array.
-- @param cutoff_time number
-- @return state string
function JS:v_keys_get_state(cutoff_time)
    return r.JS_VKeys_GetState(cutoff_time)
end

    
--- V Keys Get Up.
-- Return a 255-byte array that specifies which virtual keys, from 0x01 to 0xFF,
-- have sent KEYUP messages since cutoffTime.
-- @param cutoff_time number
-- @return state string
function JS:v_keys_get_up(cutoff_time)
    return r.JS_VKeys_GetUp(cutoff_time)
end

    
--- V Keys Intercept.
-- Intercepting (blocking) virtual keys work similar to the native function
-- PreventUIRefresh:  Each key has a (non-negative) intercept state, and the key is
-- passed through as usual if the state equals 0, or blocked if the state is
-- greater than 0.
-- @param key_code integer
-- @param intercept integer
-- @return integer
function JS:v_keys_intercept(key_code, intercept)
    return r.JS_VKeys_Intercept(key_code, intercept)
end

    
--- Window Message Intercept.
-- Begins intercepting a window message type to specified window.
-- @param window_hwnd identifier
-- @param message string
-- @param pass_through boolean
-- @return integer
function JS:window_message_intercept(window_hwnd, message, pass_through)
    return r.JS_WindowMessage_Intercept(window_hwnd, message, pass_through)
end

    
--- Window Message Intercept List.
-- Begins intercepting window messages to specified window.
-- @param window_hwnd identifier
-- @param messages string
-- @return integer
function JS:window_message_intercept_list(window_hwnd, messages)
    return r.JS_WindowMessage_InterceptList(window_hwnd, messages)
end

    
--- Window Message List Intercepts.
-- Returns a string with a list of all message types currently being intercepted
-- for the specified window.
-- @param window_hwnd identifier
-- @return list string
function JS:window_message_list_intercepts(window_hwnd)
    local retval, list = r.JS_WindowMessage_ListIntercepts(window_hwnd)
    if retval then
        return list
    else
        return nil
    end
end

    
--- Window Message Pass Through.
-- Changes the passthrough setting of a message type that is already being
-- intercepted.
-- @param window_hwnd identifier
-- @param message string
-- @param pass_through boolean
-- @return integer
function JS:window_message_pass_through(window_hwnd, message, pass_through)
    return r.JS_WindowMessage_PassThrough(window_hwnd, message, pass_through)
end

    
--- Window Message Peek.
-- Polls the state of an intercepted message.
-- @param window_hwnd identifier
-- @param message string
-- @return passed_through boolean
-- @return time number
-- @return w_param_low integer
-- @return w_param_high integer
-- @return l_param_low integer
-- @return l_param_high integer
function JS:window_message_peek(window_hwnd, message)
    local retval, passed_through, time, w_param_low, w_param_high, l_param_low, l_param_high = r.JS_WindowMessage_Peek(window_hwnd, message)
    if retval then
        return passed_through, time, w_param_low, w_param_high, l_param_low, l_param_high
    else
        return nil
    end
end

    
--- Window Message Post.
-- If the specified window and message type are not currently being intercepted by
-- a script, this function will post the message in the message queue of the
-- specified window, and return without waiting.
-- @param window_hwnd identifier
-- @param message string
-- @param w_param number
-- @param w_param_high_word integer
-- @param l_param number
-- @param l_param_high_word integer
-- @return boolean
function JS:window_message_post(window_hwnd, message, w_param, w_param_high_word, l_param, l_param_high_word)
    return r.JS_WindowMessage_Post(window_hwnd, message, w_param, w_param_high_word, l_param, l_param_high_word)
end

    
--- Window Message Release.
-- Release intercepts of specified message types.
-- @param window_hwnd identifier
-- @param messages string
-- @return integer
function JS:window_message_release(window_hwnd, messages)
    return r.JS_WindowMessage_Release(window_hwnd, messages)
end

    
--- Window Message Release All.
-- Release script intercepts of window messages for all windows.
function JS:window_message_release_all()
    return r.JS_WindowMessage_ReleaseAll()
end

    
--- Window Message Release Window.
-- Release script intercepts of window messages for specified window.
-- @param window_hwnd identifier
function JS:window_message_release_window(window_hwnd)
    return r.JS_WindowMessage_ReleaseWindow(window_hwnd)
end

    
--- Window Message Send.
-- Sends a message to the specified window by calling the window process directly,
-- and only returns after the message has been processed. Any intercepts of the
-- message by scripts will be skipped, and the message can therefore not be
-- blocked.
-- @param window_hwnd identifier
-- @param message string
-- @param w_param number
-- @param w_param_high_word integer
-- @param l_param number
-- @param l_param_high_word integer
-- @return integer
function JS:window_message_send(window_hwnd, message, w_param, w_param_high_word, l_param, l_param_high_word)
    return r.JS_WindowMessage_Send(window_hwnd, message, w_param, w_param_high_word, l_param, l_param_high_word)
end

    
--- Window Address From Handle.
-- @param handle identifier
-- @return address number
function JS:window_address_from_handle(handle)
    return r.JS_Window_AddressFromHandle(handle)
end

    
--- Window Array All Child.
-- Finds all child windows of the specified parent.
-- @param parent_hwnd identifier
-- @param reaperarray identifier
-- @return integer
function JS:window_array_all_child(parent_hwnd, reaperarray)
    return r.JS_Window_ArrayAllChild(parent_hwnd, reaperarray)
end

    
--- Window Array All Top.
-- Finds all top-level windows.
-- @param reaperarray identifier
-- @return integer
function JS:window_array_all_top(reaperarray)
    return r.JS_Window_ArrayAllTop(reaperarray)
end

    
--- Window Array Find.
-- Finds all windows, whether top-level or child, whose titles match the specified
-- string.
-- @param title string
-- @param exact boolean
-- @param reaperarray identifier
-- @return integer
function JS:window_array_find(title, exact, reaperarray)
    return r.JS_Window_ArrayFind(title, exact, reaperarray)
end

    
--- Window Attach Resize Grip.
-- @param window_hwnd identifier
function JS:window_attach_resize_grip(window_hwnd)
    return r.JS_Window_AttachResizeGrip(window_hwnd)
end

    
--- Window Attach Topmost Pin.
-- Attaches a "pin on top" button to the window frame. The button should remember
-- its state when closing and re-opening the window.
-- @param window_hwnd identifier
function JS:window_attach_topmost_pin(window_hwnd)
    return r.JS_Window_AttachTopmostPin(window_hwnd)
end

    
--- Window Client To Screen.
-- Converts the client-area coordinates of a specified point to screen coordinates.
-- @param window_hwnd identifier
-- @param x integer
-- @param y integer
-- @return x integer
-- @return y integer
function JS:window_client_to_screen(window_hwnd, x, y)
    return r.JS_Window_ClientToScreen(window_hwnd, x, y)
end

    
--- Window Create.
-- Creates a modeless window with WS_OVERLAPPEDWINDOW style and only rudimentary
-- features. Scripts can paint into the window using GDI or LICE/Composite
-- functions (and JS_Window_InvalidateRect to trigger re-painting).
-- @param title string
-- @param class_name string
-- @param x integer
-- @param y integer
-- @param w integer
-- @param h integer
-- @param string style optional
-- @param owner_hwnd identifier
-- @return string style
function JS:window_create(title, class_name, x, y, w, h, string, owner_hwnd)
    local string = string or nil
    local retval, string = r.JS_Window_Create(title, class_name, x, y, w, h, string, owner_hwnd)
    if retval then
        return string
    else
        return nil
    end
end

    
--- Window Destroy.
-- Destroys the specified window.
-- @param window_hwnd identifier
function JS:window_destroy(window_hwnd)
    return r.JS_Window_Destroy(window_hwnd)
end

    
--- Window Enable.
-- Enables or disables mouse and keyboard input to the specified window or control.
-- @param window_hwnd identifier
-- @param enable boolean
function JS:window_enable(window_hwnd, enable)
    return r.JS_Window_Enable(window_hwnd, enable)
end

    
--- Window Enable Metal.
-- On macOS, returns the Metal graphics setting: 2 = Metal enabled and support
-- GetDC()/ReleaseDC() for drawing (more overhead). 1 = Metal enabled. 0 = N/A
-- (Windows and Linux). -1 = non-metal async layered mode. -2 = non-metal non-async
-- layered mode.
-- @param window_hwnd identifier
-- @return integer
function JS:window_enable_metal(window_hwnd)
    return r.JS_Window_EnableMetal(window_hwnd)
end

    
--- Window Find.
-- Returns a HWND to a window whose title matches the specified string.  * Unlike
-- the Win32 function FindWindow, this function searches top-level as well as child
-- windows, so that the target window can be found irrespective of docked state.  *
-- In addition, the function can optionally match substrings of the title.  *
-- Matching is not case sensitive.
-- @param title string
-- @param exact boolean
-- @return identifier
function JS:window_find(title, exact)
    return r.JS_Window_Find(title, exact)
end

    
--- Window Find Child.
-- Returns a HWND to a child window whose title matches the specified string.
-- @param parent_hwnd identifier
-- @param title string
-- @param exact boolean
-- @return identifier
function JS:window_find_child(parent_hwnd, title, exact)
    return r.JS_Window_FindChild(parent_hwnd, title, exact)
end

    
--- Window Find Child By Id.
-- Similar to the C++ WIN32 function GetDlgItem, this function finds child windows
-- by ID.
-- @param parent_hwnd identifier
-- @param id integer
-- @return identifier
function JS:window_find_child_by_id(parent_hwnd, id)
    return r.JS_Window_FindChildByID(parent_hwnd, id)
end

    
--- Window Find Ex.
-- Returns a handle to a child window whose class and title match the specified
-- strings.
-- @param parent_hwnd identifier
-- @param child_hwnd identifier
-- @param class_name string
-- @param title string
-- @return identifier
function JS:window_find_ex(parent_hwnd, child_hwnd, class_name, title)
    return r.JS_Window_FindEx(parent_hwnd, child_hwnd, class_name, title)
end

    
--- Window Find Top.
-- Returns a HWND to a top-level window whose title matches the specified string.
-- @param title string
-- @param exact boolean
-- @return identifier
function JS:window_find_top(title, exact)
    return r.JS_Window_FindTop(title, exact)
end

    
--- Window From Point.
-- Retrieves a HWND to the window that contains the specified point.
-- @param x integer
-- @param y integer
-- @return identifier
function JS:window_from_point(x, y)
    return r.JS_Window_FromPoint(x, y)
end

    
--- Window Get Class Name.
-- WARNING: May not be fully implemented on macOS and Linux.
-- @param window_hwnd identifier
-- @return class string
function JS:window_get_class_name(window_hwnd)
    return r.JS_Window_GetClassName(window_hwnd)
end

    
--- Window Get Client Rect.
-- Retrieves the screen coordinates of the client area rectangle of the specified
-- window.
-- @param window_hwnd identifier
-- @return left integer
-- @return top integer
-- @return right integer
-- @return bottom integer
function JS:window_get_client_rect(window_hwnd)
    local retval, left, top, right, bottom = r.JS_Window_GetClientRect(window_hwnd)
    if retval then
        return left, top, right, bottom
    else
        return nil
    end
end

    
--- Window Get Client Size.
-- @param window_hwnd identifier
-- @return width integer
-- @return height integer
function JS:window_get_client_size(window_hwnd)
    local retval, width, height = r.JS_Window_GetClientSize(window_hwnd)
    if retval then
        return width, height
    else
        return nil
    end
end

    
--- Window Get Focus.
-- Retrieves a HWND to the window that has the keyboard focus, if the window is
-- attached to the calling thread's message queue.
-- @return identifier
function JS:window_get_focus()
    return r.JS_Window_GetFocus()
end

    
--- Window Get Foreground.
-- Retrieves a HWND to the top-level foreground window (the window with which the
-- user is currently working).
-- @return identifier
function JS:window_get_foreground()
    return r.JS_Window_GetForeground()
end

    
--- Window Get Long.
-- Similar to JS_Window_GetLongPtr, but returns the information as a number instead
-- of a pointer.
-- @param window_hwnd identifier
-- @param info string
function JS:window_get_long(window_hwnd, info)
    local retval = r.JS_Window_GetLong(window_hwnd, info)
    if retval then
        return 
    else
        return nil
    end
end

    
--- Window Get Long Ptr.
-- Returns information about the specified window.
-- @param window_hwnd identifier
-- @param info string
-- @return identifier
function JS:window_get_long_ptr(window_hwnd, info)
    return r.JS_Window_GetLongPtr(window_hwnd, info)
end

    
--- Window Get Parent.
-- Retrieves a HWND to the specified window's parent or owner. Returns NULL if the
-- window is unowned or if the function otherwise fails.
-- @param window_hwnd identifier
-- @return identifier
function JS:window_get_parent(window_hwnd)
    return r.JS_Window_GetParent(window_hwnd)
end

    
--- Window Get Rect.
-- Retrieves the screen coordinates of the bounding rectangle of the specified
-- window.
-- @param window_hwnd identifier
-- @return left integer
-- @return top integer
-- @return right integer
-- @return bottom integer
function JS:window_get_rect(window_hwnd)
    local retval, left, top, right, bottom = r.JS_Window_GetRect(window_hwnd)
    if retval then
        return left, top, right, bottom
    else
        return nil
    end
end

    
--- Window Get Related.
-- Retrieves a handle to a window that has the specified relationship (Z-Order or
-- owner) to the specified window. relation: "LAST", "NEXT", "PREV", "OWNER" or
-- "CHILD". (Refer to documentation for Win32 C++ function GetWindow.)
-- @param window_hwnd identifier
-- @param relation string
-- @return identifier
function JS:window_get_related(window_hwnd, relation)
    return r.JS_Window_GetRelated(window_hwnd, relation)
end

    
--- Window Get Scroll Info.
-- Retrieves the scroll information of a window.
-- @param window_hwnd identifier
-- @param scrollbar string
-- @return position integer
-- @return page_size integer
-- @return min integer
-- @return max integer
-- @return track_pos integer
function JS:window_get_scroll_info(window_hwnd, scrollbar)
    local retval, position, page_size, min, max, track_pos = r.JS_Window_GetScrollInfo(window_hwnd, scrollbar)
    if retval then
        return position, page_size, min, max, track_pos
    else
        return nil
    end
end

    
--- Window Get Title.
-- Returns the title (if any) of the specified window.
-- @param window_hwnd identifier
-- @return title string
function JS:window_get_title(window_hwnd)
    return r.JS_Window_GetTitle(window_hwnd)
end

    
--- Window Get Viewport From Rect.
-- Retrieves the dimensions of the display monitor that has the largest area of
-- intersection with the specified rectangle.
-- @param x1 integer
-- @param y1 integer
-- @param x2 integer
-- @param y2 integer
-- @param want_work boolean
-- @return left integer
-- @return top integer
-- @return right integer
-- @return bottom integer
function JS:window_get_viewport_from_rect(x1, y1, x2, y2, want_work)
    return r.JS_Window_GetViewportFromRect(x1, y1, x2, y2, want_work)
end

    
--- Window Handle From Address.
-- Converts an address to a handle (such as a HWND) that can be utilized by REAPER
-- and other API functions.
-- @param address number
-- @return identifier
function JS:window_handle_from_address(address)
    return r.JS_Window_HandleFromAddress(address)
end

    
--- Window Invalidate Rect.
-- Similar to the Win32 function InvalidateRect.
-- @param window_hwnd identifier
-- @param left integer
-- @param top integer
-- @param right integer
-- @param bottom integer
-- @param erase_background boolean
-- @return boolean
function JS:window_invalidate_rect(window_hwnd, left, top, right, bottom, erase_background)
    return r.JS_Window_InvalidateRect(window_hwnd, left, top, right, bottom, erase_background)
end

    
--- Window Is Child.
-- Determines whether a window is a child window or descendant window of a
-- specified parent window.
-- @param parent_hwnd identifier
-- @param child_hwnd identifier
-- @return boolean
function JS:window_is_child(parent_hwnd, child_hwnd)
    return r.JS_Window_IsChild(parent_hwnd, child_hwnd)
end

    
--- Window Is Visible.
-- Determines the visibility state of the window.
-- @param window_hwnd identifier
-- @return boolean
function JS:window_is_visible(window_hwnd)
    return r.JS_Window_IsVisible(window_hwnd)
end

    
--- Window Is Window.
-- Determines whether the specified window handle identifies an existing window.
-- @param window_hwnd identifier
-- @return boolean
function JS:window_is_window(window_hwnd)
    return r.JS_Window_IsWindow(window_hwnd)
end

    
--- Window List All Child.
-- Finds all child windows of the specified parent.
-- @param parent_hwnd identifier
-- @return list string
function JS:window_list_all_child(parent_hwnd)
    local retval, list = r.JS_Window_ListAllChild(parent_hwnd)
    if retval then
        return list
    else
        return nil
    end
end

    
--- Window List All Top.
-- Finds all top-level windows.
-- @return list string
function JS:window_list_all_top()
    local retval, list = r.JS_Window_ListAllTop()
    if retval then
        return list
    else
        return nil
    end
end

    
--- Window List Find.
-- Finds all windows (whether top-level or child) whose titles match the specified
-- string.
-- @param title string
-- @param exact boolean
-- @return list string
function JS:window_list_find(title, exact)
    local retval, list = r.JS_Window_ListFind(title, exact)
    if retval then
        return list
    else
        return nil
    end
end

    
--- Window Move.
-- Changes the position of the specified window, keeping its size constant.
-- @param window_hwnd identifier
-- @param left integer
-- @param top integer
function JS:window_move(window_hwnd, left, top)
    return r.JS_Window_Move(window_hwnd, left, top)
end

    
--- Window On Command.
-- Sends a "WM_COMMAND" message to the specified window, which simulates a user
-- selecting a command in the window menu.
-- @param window_hwnd identifier
-- @param command_id integer
-- @return boolean
function JS:window_on_command(window_hwnd, command_id)
    return r.JS_Window_OnCommand(window_hwnd, command_id)
end

    
--- Window Resize.
-- Changes the dimensions of the specified window, keeping the top left corner
-- position constant.  * If resizing script GUIs, call gfx.update() after resizing.
-- * Equivalent to calling JS_Window_SetPosition with NOMOVE, NOZORDER, NOACTIVATE
-- and NOOWNERZORDER flags set.
-- @param window_hwnd identifier
-- @param width integer
-- @param height integer
function JS:window_resize(window_hwnd, width, height)
    return r.JS_Window_Resize(window_hwnd, width, height)
end

    
--- Window Screen To Client.
-- Converts the screen coordinates of a specified point on the screen to client-
-- area coordinates.
-- @param window_hwnd identifier
-- @param x integer
-- @param y integer
-- @return x integer
-- @return y integer
function JS:window_screen_to_client(window_hwnd, x, y)
    return r.JS_Window_ScreenToClient(window_hwnd, x, y)
end

    
--- Window Set Focus.
-- Sets the keyboard focus to the specified window.
-- @param window_hwnd identifier
function JS:window_set_focus(window_hwnd)
    return r.JS_Window_SetFocus(window_hwnd)
end

    
--- Window Set Foreground.
-- Brings the specified window into the foreground, activates the window, and
-- directs keyboard input to it.
-- @param window_hwnd identifier
function JS:window_set_foreground(window_hwnd)
    return r.JS_Window_SetForeground(window_hwnd)
end

    
--- Window Set Long.
-- Similar to the Win32 function SetWindowLongPtr.
-- @param window_hwnd identifier
-- @param info string
-- @param value number
function JS:window_set_long(window_hwnd, info, value)
    local retval = r.JS_Window_SetLong(window_hwnd, info, value)
    if retval then
        return 
    else
        return nil
    end
end

    
--- Window Set Opacity.
-- Sets the window opacity.
-- @param window_hwnd identifier
-- @param mode string
-- @param value number
-- @return boolean
function JS:window_set_opacity(window_hwnd, mode, value)
    return r.JS_Window_SetOpacity(window_hwnd, mode, value)
end

    
--- Window Set Parent.
-- If successful, returns a handle to the previous parent window.
-- @param child_hwnd identifier
-- @param parent_hwnd identifier
-- @return identifier
function JS:window_set_parent(child_hwnd, parent_hwnd)
    return r.JS_Window_SetParent(child_hwnd, parent_hwnd)
end

    
--- Window Set Position.
-- Interface to the Win32/swell function SetWindowPos, with which window position,
-- size, Z-order and visibility can be set, and new frame styles can be applied.
-- @param window_hwnd identifier
-- @param left integer
-- @param top integer
-- @param width integer
-- @param height integer
-- @param string ZOrder optional
-- @param string flags optional
-- @return string ZOrder
-- @return string flags
function JS:window_set_position(window_hwnd, left, top, width, height, string, string)
    local string = string or nil
    local retval, string, string = r.JS_Window_SetPosition(window_hwnd, left, top, width, height, string, string)
    if retval then
        return string, string
    else
        return nil
    end
end

    
--- Window Set Scroll Pos.
-- Parameters:  * scrollbar: "v" (or "SB_VERT", or "VERT") for vertical scroll, "h"
-- (or "SB_HORZ" or "HORZ") for horizontal.
-- @param window_hwnd identifier
-- @param scrollbar string
-- @param position integer
-- @return boolean
function JS:window_set_scroll_pos(window_hwnd, scrollbar, position)
    return r.JS_Window_SetScrollPos(window_hwnd, scrollbar, position)
end

    
--- Window Set Style.
-- Sets and applies a window style.
-- @param window_hwnd identifier
-- @param style string
-- @return style string
function JS:window_set_style(window_hwnd, style)
    local retval, style = r.JS_Window_SetStyle(window_hwnd, style)
    if retval then
        return style
    else
        return nil
    end
end

    
--- Window Set Title.
-- Changes the title of the specified window. Returns true if successful.
-- @param window_hwnd identifier
-- @param title string
-- @return boolean
function JS:window_set_title(window_hwnd, title)
    return r.JS_Window_SetTitle(window_hwnd, title)
end

    
--- Window Set Z Order.
-- Sets the window Z order.  * Equivalent to calling JS_Window_SetPos with flags
-- NOMOVE | NOSIZE.  * Not all the Z orders have been implemented in Linux yet.
-- @param window_hwnd identifier
-- @param z_order string
-- @param insert_after_hwnd identifier
-- @return boolean
function JS:window_set_z_order(window_hwnd, z_order, insert_after_hwnd)
    return r.JS_Window_SetZOrder(window_hwnd, z_order, insert_after_hwnd)
end

    
--- Window Show.
-- Sets the specified window's show state.
-- @param window_hwnd identifier
-- @param state string
function JS:window_show(window_hwnd, state)
    return r.JS_Window_Show(window_hwnd, state)
end

    
--- Window Update.
-- Similar to the Win32 function UpdateWindow.
-- @param window_hwnd identifier
function JS:window_update(window_hwnd)
    return r.JS_Window_Update(window_hwnd)
end

    
--- Zip Close.
-- Closes the zip archive, using either the file name or the zip handle. Finalizes
-- entries and releases resources.
-- @param zip_file string
-- @param zip_handle identifier
-- @return integer
function JS:zip_close(zip_file, zip_handle)
    return r.JS_Zip_Close(zip_file, zip_handle)
end

    
--- Zip Count Entries.
-- @param zip_handle identifier
-- @return integer
function JS:zip_count_entries(zip_handle)
    return r.JS_Zip_CountEntries(zip_handle)
end

    
--- Zip Delete Entries.
-- Deletes the specified entries from an existing Zip file.
-- @param zip_handle identifier
-- @param entry_names string
-- @param entry_names_str_len integer
-- @return integer
function JS:zip_delete_entries(zip_handle, entry_names, entry_names_str_len)
    return r.JS_Zip_DeleteEntries(zip_handle, entry_names, entry_names_str_len)
end

    
--- Zip Entry Close.
-- Closes a zip entry, flushes buffer and releases resources. In WRITE mode,
-- entries must be closed in order to apply and save changes.
-- @param zip_handle identifier
-- @return integer
function JS:zip_entry_close(zip_handle)
    return r.JS_Zip_Entry_Close(zip_handle)
end

    
--- Zip Entry Compress File.
-- Compresses the specified file into the zip archive's open entry.
-- @param zip_handle identifier
-- @param input_file string
-- @return integer
function JS:zip_entry_compress_file(zip_handle, input_file)
    return r.JS_Zip_Entry_CompressFile(zip_handle, input_file)
end

    
--- Zip Entry Compress Memory.
-- Compresses the specified memory buffer into the zip archive's open entry.
-- @param zip_handle identifier
-- @param buf string
-- @param buf_size integer
-- @return integer
function JS:zip_entry_compress_memory(zip_handle, buf, buf_size)
    return r.JS_Zip_Entry_CompressMemory(zip_handle, buf, buf_size)
end

    
--- Zip Entry Extract To File.
-- Extracts the zip archive's open entry.
-- @param zip_handle identifier
-- @param output_file string
-- @return integer
function JS:zip_entry_extract_to_file(zip_handle, output_file)
    return r.JS_Zip_Entry_ExtractToFile(zip_handle, output_file)
end

    
--- Zip Entry Extract To Memory.
-- Extracts and returns the zip archive's open entry.
-- @param zip_handle identifier
-- @return contents string
function JS:zip_entry_extract_to_memory(zip_handle)
    local retval, contents = r.JS_Zip_Entry_ExtractToMemory(zip_handle)
    if retval then
        return contents
    else
        return nil
    end
end

    
--- Zip Entry Info.
-- Returns information about the zip archive's open entry.
-- @param zip_handle identifier
-- @return name string
-- @return index integer
-- @return is__folder integer
-- @return size number
-- @return crc32 number
function JS:zip_entry_info(zip_handle)
    local retval, name, index, is__folder, size, crc32 = r.JS_Zip_Entry_Info(zip_handle)
    if retval then
        return name, index, is__folder, size, crc32
    else
        return nil
    end
end

    
--- Zip Entry Open By Index.
-- Opens a new entry by index in the zip archive.
-- @param zip_handle identifier
-- @param index integer
-- @return integer
function JS:zip_entry_open_by_index(zip_handle, index)
    return r.JS_Zip_Entry_OpenByIndex(zip_handle, index)
end

    
--- Zip Entry Open By Name.
-- Opens an entry by name in the zip archive.
-- @param zip_handle identifier
-- @param entry_name string
-- @return integer
function JS:zip_entry_open_by_name(zip_handle, entry_name)
    return r.JS_Zip_Entry_OpenByName(zip_handle, entry_name)
end

    
--- Zip Error String.
-- Returns a descriptive string for the given error code.
-- @param error_num integer
-- @return error_str string
function JS:zip_error_string(error_num)
    return r.JS_Zip_ErrorString(error_num)
end

    
--- Zip Extract.
-- Extracts an existing Zip file to the specified folder.
-- @param zip_file string
-- @param output_folder string
-- @return integer
function JS:zip_extract(zip_file, output_folder)
    return r.JS_Zip_Extract(zip_file, output_folder)
end

    
--- Zip List All Entries.
-- Returns the number of entries and a zero-separated and double-zero-terminated
-- string of entry names.
-- @param zip_handle identifier
-- @return list string
function JS:zip_list_all_entries(zip_handle)
    local retval, list = r.JS_Zip_ListAllEntries(zip_handle)
    if retval then
        return list
    else
        return nil
    end
end

    
--- Zip Open.
-- Opens a zip archive using the given mode, which can be either "READ" or "WRITE"
-- (or simply 'r' or 'w').
-- @param zip_file string
-- @param mode string
-- @param compression_level integer
function JS:zip_open(zip_file, mode, compression_level)
    local retval, retval = r.JS_Zip_Open(zip_file, mode, compression_level)
    if retval then
        return 
    else
        return nil
    end
end

return JS
