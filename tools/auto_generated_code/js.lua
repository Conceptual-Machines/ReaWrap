-- 0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
-- @section integer
-- @cmd_i_d integer
-- @return integer 
function JS:actions__count_shortcuts(section, cmd_i_d)
    return r.JS_Actions_CountShortcuts(section, cmd_i_d)
end

-- 0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
-- @section integer
-- @cmd_i_d integer
-- @shortcutidx integer
-- @return boolean 
function JS:actions__delete_shortcut(section, cmd_i_d, shortcutidx)
    return r.JS_Actions_DeleteShortcut(section, cmd_i_d, shortcutidx)
end

-- If the shortcut index is higher than the current number of shortcuts, it will add a new shortcut.
-- @section integer
-- @cmd_i_d integer
-- @shortcutidx integer
-- @return boolean 
function JS:actions__do_shortcut_dialog(section, cmd_i_d, shortcutidx)
    return r.JS_Actions_DoShortcutDialog(section, cmd_i_d, shortcutidx)
end

-- 0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
-- @section integer
-- @cmd_i_d integer
-- @shortcutidx integer
-- @return string 
function JS:actions__get_shortcut_desc(section, cmd_i_d, shortcutidx)
    local retval, desc = r.JS_Actions_GetShortcutDesc(section, cmd_i_d, shortcutidx)
    if retval then
        return desc
    end
end

-- Returns the unsigned byte at address[offset]. Offset is added as steps of 1 byte each.
-- @pointer identifier
-- @offset integer
-- @return number 
function JS:byte(pointer, offset)
    return r.JS_Byte(pointer, offset)
end

-- 1 if successful, otherwise -1 = windowHWND is not a window, -3 = Could not obtain the original window process, -4 = sysBitmap is not a LICE bitmap, -5 = sysBitmap is not a system bitmap, -6 = Could not obtain the window HDC, -7 = Error when subclassing to new window process.
-- @window_h_w_n_d identifier
-- @dstx integer
-- @dsty integer
-- @dstw integer
-- @dsth integer
-- @sys_bitmap identifier
-- @srcx integer
-- @srcy integer
-- @srcw integer
-- @srch integer
-- @auto_update unsupported
-- @return integer 
function JS:composite(window_h_w_n_d, dstx, dsty, dstw, dsth, sys_bitmap, srcx, srcy, srcw, srch, auto_update)
    return r.JS_Composite(window_h_w_n_d, dstx, dsty, dstw, dsth, sys_bitmap, srcx, srcy, srcw, srch, auto_update)
end

--  * If delay times have not previously been set for this window, prev time values are 0.
-- @window_h_w_n_d identifier
-- @min_time number
-- @max_time number
-- @num_bitmaps_when_max integer
-- @return number, number, number 
function JS:composite__delay(window_h_w_n_d, min_time, max_time, num_bitmaps_when_max)
    local retval, prev_min_time, prev_max_time, prev_bitmaps = r.JS_Composite_Delay(window_h_w_n_d, min_time, max_time, num_bitmaps_when_max)
    if retval then
        return prev_min_time, prev_max_time, prev_bitmaps
    end
end

-- retval is the number of linked bitmaps found, or negative if an error occured.
-- @window_h_w_n_d identifier
-- @return string 
function JS:composite__list_bitmaps(window_h_w_n_d)
    local retval, list = r.JS_Composite_ListBitmaps(window_h_w_n_d)
    if retval then
        return list
    end
end

-- If no bitmap is specified, all bitmaps composited to the window will be unlinked -- even those by other scripts.
-- @window_h_w_n_d identifier
-- @bitmap identifier
-- @auto_update unsupported
function JS:composite__unlink(window_h_w_n_d, bitmap, auto_update)
    return r.JS_Composite_Unlink(window_h_w_n_d, bitmap, auto_update)
end

-- retval is 1 if a file was selected, 0 if the user cancelled the dialog, and -1 if an error occurred.
-- @caption string
-- @initial_folder string
-- @return string 
function JS:dialog__browse_for_folder(caption, initial_folder)
    local retval, folder = r.JS_Dialog_BrowseForFolder(caption, initial_folder)
    if retval then
        return folder
    end
end

--  * REAPER's IDE and ShowConsoleMsg only display strings up to the first \0 byte. If multiple files were selected, only the first substring containing the path will be displayed. This is not a problem for Lua or EEL, which can access the full string beyond the first \0 byte as usual.
-- @window_title string
-- @initial_folder string
-- @initial_file string
-- @extension_list string
-- @allow_multiple boolean
-- @return string 
function JS:dialog__browse_for_open_files(window_title, initial_folder, initial_file, extension_list, allow_multiple)
    local retval, file_names = r.JS_Dialog_BrowseForOpenFiles(window_title, initial_folder, initial_file, extension_list, allow_multiple)
    if retval then
        return file_names
    end
end

-- extensionList is as described for JS_Dialog_BrowseForOpenFiles.
-- @window_title string
-- @initial_folder string
-- @initial_file string
-- @extension_list string
-- @return string 
function JS:dialog__browse_for_save_file(window_title, initial_folder, initial_file, extension_list)
    local retval, file_name = r.JS_Dialog_BrowseForSaveFile(window_title, initial_folder, initial_file, extension_list)
    if retval then
        return file_name
    end
end

-- Returns the 8-byte floating point value at address[offset]. Offset is added as steps of 8 bytes each.
-- @pointer identifier
-- @offset integer
-- @return number 
function JS:double(pointer, offset)
    return r.JS_Double(pointer, offset)
end

-- retval is 0 if successful, negative if not.
-- @file_path string
-- @return number, string, string, string, number, number, number, number, number, number, number 
function JS:file__stat(file_path)
    local retval, size, accessed_time, modified_time, c_time, device_i_d, device_special_i_d, inode, mode, num_links, owner_user_i_d, owner_group_i_d = r.JS_File_Stat(file_path)
    if retval then
        return size, accessed_time, modified_time, c_time, device_i_d, device_special_i_d, inode, mode, num_links, owner_user_i_d, owner_group_i_d
    end
end

-- WARNING: On WindowsOS, GDI_Blit does not perform alpha multiplication of the source bitmap. For proper color rendering, a separate pre-multiplication step is therefore required, using either LICE_Blit or LICE_ProcessRect.
-- @dest_h_d_c identifier
-- @dstx integer
-- @dsty integer
-- @source_h_d_c identifier
-- @srcx integer
-- @srxy integer
-- @width integer
-- @height integer
-- @mode string
function JS:g_d_i__blit(dest_h_d_c, dstx, dsty, source_h_d_c, srcx, srxy, width, height, mode)
    return r.JS_GDI_Blit(dest_h_d_c, dstx, dsty, source_h_d_c, srcx, srxy, width, height, mode)
end

-- @color integer
-- @return identifier 
function JS:g_d_i__create_fill_brush(color)
    return r.JS_GDI_CreateFillBrush(color)
end

-- Note: Text color must be set separately.
-- @height integer
-- @weight integer
-- @angle integer
-- @italic boolean
-- @underline boolean
-- @strike boolean
-- @font_name string
-- @return identifier 
function JS:g_d_i__create_font(height, weight, angle, italic, underline, strike, font_name)
    return r.JS_GDI_CreateFont(height, weight, angle, italic, underline, strike, font_name)
end

-- @width integer
-- @color integer
-- @return identifier 
function JS:g_d_i__create_pen(width, color)
    return r.JS_GDI_CreatePen(width, color)
end

-- @g_d_i_object identifier
function JS:g_d_i__delete_object(g_d_i_object)
    return r.JS_GDI_DeleteObject(g_d_i_object)
end

--  * align: Combination of: "TOP", "VCENTER", "LEFT", "HCENTER", "RIGHT", "BOTTOM", "WORDBREAK", "SINGLELINE", "NOCLIP", "CALCRECT", "NOPREFIX" or "ELLIPSIS"
-- @device_h_d_c identifier
-- @text string
-- @len integer
-- @left integer
-- @top integer
-- @right integer
-- @bottom integer
-- @align) string
-- @return integer 
function JS:g_d_i__draw_text(device_h_d_c, text, len, left, top, right, bottom, align))
    return r.JS_GDI_DrawText(device_h_d_c, text, len, left, top, right, bottom, align))
end

-- @device_h_d_c identifier
-- @left integer
-- @top integer
-- @right integer
-- @bottom integer
function JS:g_d_i__fill_ellipse(device_h_d_c, left, top, right, bottom)
    return r.JS_GDI_FillEllipse(device_h_d_c, left, top, right, bottom)
end

-- packedX and packedY are strings of points, each packed as "<i4".
-- @device_h_d_c identifier
-- @packed_x string
-- @packed_y string
-- @num_points integer
function JS:g_d_i__fill_polygon(device_h_d_c, packed_x, packed_y, num_points)
    return r.JS_GDI_FillPolygon(device_h_d_c, packed_x, packed_y, num_points)
end

-- @device_h_d_c identifier
-- @left integer
-- @top integer
-- @right integer
-- @bottom integer
function JS:g_d_i__fill_rect(device_h_d_c, left, top, right, bottom)
    return r.JS_GDI_FillRect(device_h_d_c, left, top, right, bottom)
end

-- @device_h_d_c identifier
-- @left integer
-- @top integer
-- @right integer
-- @bottom integer
-- @xrnd integer
-- @yrnd integer
function JS:g_d_i__fill_round_rect(device_h_d_c, left, top, right, bottom, xrnd, yrnd)
    return r.JS_GDI_FillRoundRect(device_h_d_c, left, top, right, bottom, xrnd, yrnd)
end

-- Returns the device context for the client area of the specified window.
-- @window_h_w_n_d identifier
-- @return identifier 
function JS:g_d_i__get_client_d_c(window_h_w_n_d)
    return r.JS_GDI_GetClientDC(window_h_w_n_d)
end

-- WARNING: Only available on Windows, not Linux or macOS.
-- @return identifier 
function JS:g_d_i__get_screen_d_c()
    return r.JS_GDI_GetScreenDC()
end

-- @g_u_i_element string
-- @return integer 
function JS:g_d_i__get_sys_color(g_u_i_element)
    return r.JS_GDI_GetSysColor(g_u_i_element)
end

-- @device_h_d_c identifier
-- @return integer 
function JS:g_d_i__get_text_color(device_h_d_c)
    return r.JS_GDI_GetTextColor(device_h_d_c)
end

-- Returns the device context for the entire window, including title bar and frame.
-- @window_h_w_n_d identifier
-- @return identifier 
function JS:g_d_i__get_window_d_c(window_h_w_n_d)
    return r.JS_GDI_GetWindowDC(window_h_w_n_d)
end

-- @device_h_d_c identifier
-- @x1 integer
-- @y1 integer
-- @x2 integer
-- @y2 integer
function JS:g_d_i__line(device_h_d_c, x1, y1, x2, y2)
    return r.JS_GDI_Line(device_h_d_c, x1, y1, x2, y2)
end

-- packedX and packedY are strings of points, each packed as "<i4".
-- @device_h_d_c identifier
-- @packed_x string
-- @packed_y string
-- @num_points integer
function JS:g_d_i__polyline(device_h_d_c, packed_x, packed_y, num_points)
    return r.JS_GDI_Polyline(device_h_d_c, packed_x, packed_y, num_points)
end

-- NOTE: Any GDI HDC should be released immediately after drawing, and deferred scripts should get and release new DCs in each cycle.
-- @device_h_d_c identifier
-- @window_h_w_n_d identifier
-- @return integer 
function JS:g_d_i__release_d_c(device_h_d_c, window_h_w_n_d)
    return r.JS_GDI_ReleaseDC(device_h_d_c, window_h_w_n_d)
end

-- Activates a font, pen, or fill brush for subsequent drawing in the specified device context.
-- @device_h_d_c identifier
-- @g_d_i_object identifier
-- @return identifier 
function JS:g_d_i__select_object(device_h_d_c, g_d_i_object)
    return r.JS_GDI_SelectObject(device_h_d_c, g_d_i_object)
end

-- @device_h_d_c identifier
-- @x integer
-- @y integer
-- @color integer
function JS:g_d_i__set_pixel(device_h_d_c, x, y, color)
    return r.JS_GDI_SetPixel(device_h_d_c, x, y, color)
end

-- @device_h_d_c identifier
-- @color integer
function JS:g_d_i__set_text_bk_color(device_h_d_c, color)
    return r.JS_GDI_SetTextBkColor(device_h_d_c, color)
end

-- @device_h_d_c identifier
-- @mode integer
function JS:g_d_i__set_text_bk_mode(device_h_d_c, mode)
    return r.JS_GDI_SetTextBkMode(device_h_d_c, mode)
end

-- @device_h_d_c identifier
-- @color integer
function JS:g_d_i__set_text_color(device_h_d_c, color)
    return r.JS_GDI_SetTextColor(device_h_d_c, color)
end

-- WARNING: On WindowsOS, GDI_Blit does not perform alpha multiplication of the source bitmap. For proper color rendering, a separate pre-multiplication step is therefore required, using either LICE_Blit or LICE_ProcessRect.
-- @dest_h_d_c identifier
-- @dstx integer
-- @dsty integer
-- @dstw integer
-- @dsth integer
-- @source_h_d_c identifier
-- @srcx integer
-- @srxy integer
-- @srcw integer
-- @srch integer
-- @mode string
function JS:g_d_i__stretch_blit(dest_h_d_c, dstx, dsty, dstw, dsth, source_h_d_c, srcx, srxy, srcw, srch, mode)
    return r.JS_GDI_StretchBlit(dest_h_d_c, dstx, dsty, dstw, dsth, source_h_d_c, srcx, srxy, srcw, srch, mode)
end

-- Returns the 4-byte signed integer at address[offset]. Offset is added as steps of 4 bytes each.
-- @pointer identifier
-- @offset integer
-- @return number 
function JS:int(pointer, offset)
    return r.JS_Int(pointer, offset)
end

-- Hue is rolled over, saturation and value are clamped, all 0..1. (Alpha remains unchanged.)
-- @bitmap identifier
-- @hue number
-- @saturation number
-- @value number
function JS:l_i_c_e__alter_bitmap_h_s_v(bitmap, hue, saturation, value)
    return r.JS_LICE_AlterBitmapHSV(bitmap, hue, saturation, value)
end

-- Hue is rolled over, saturation and value are clamped, all 0..1. (Alpha remains unchanged.)
-- @bitmap identifier
-- @x integer
-- @y integer
-- @w integer
-- @h integer
-- @hue number
-- @saturation number
-- @value number
function JS:l_i_c_e__alter_rect_h_s_v(bitmap, x, y, w, h, hue, saturation, value)
    return r.JS_LICE_AlterRectHSV(bitmap, x, y, w, h, hue, saturation, value)
end

-- LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
-- @bitmap identifier
-- @cx number
-- @cy number
-- @r number
-- @min_angle number
-- @max_angle number
-- @color integer
-- @alpha number
-- @mode string
-- @antialias boolean
function JS:l_i_c_e__arc(bitmap, cx, cy, r, min_angle, max_angle, color, alpha, mode, antialias)
    return r.JS_LICE_Arc(bitmap, cx, cy, r, min_angle, max_angle, color, alpha, mode, antialias)
end

-- @reaperarray identifier
-- @return integer 
function JS:l_i_c_e__array_all_bitmaps(reaperarray)
    return r.JS_LICE_ArrayAllBitmaps(reaperarray)
end

-- LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
-- @bitmap identifier
-- @xstart number
-- @ystart number
-- @xctl1 number
-- @yctl1 number
-- @xctl2 number
-- @yctl2 number
-- @xend number
-- @yend number
-- @tol number
-- @color integer
-- @alpha number
-- @mode string
-- @antialias boolean
function JS:l_i_c_e__bezier(bitmap, xstart, ystart, xctl1, yctl1, xctl2, yctl2, xend, yend, tol, color, alpha, mode, antialias)
    return r.JS_LICE_Bezier(bitmap, xstart, ystart, xctl1, yctl1, xctl2, yctl2, xend, yend, tol, color, alpha, mode, antialias)
end

--  * "ALPHAMUL", which overwrites the destination with a per-pixel alpha-multiplied copy of the source. (Similar to first clearing the destination with 0x00000000 and then blitting with "COPY,ALPHA".)
-- @dest_bitmap identifier
-- @dstx integer
-- @dsty integer
-- @source_bitmap identifier
-- @srcx integer
-- @srcy integer
-- @width integer
-- @height integer
-- @alpha number
-- @mode string
function JS:l_i_c_e__blit(dest_bitmap, dstx, dsty, source_bitmap, srcx, srcy, width, height, alpha, mode)
    return r.JS_LICE_Blit(dest_bitmap, dstx, dsty, source_bitmap, srcx, srcy, width, height, alpha, mode)
end

-- LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
-- @bitmap identifier
-- @cx number
-- @cy number
-- @r number
-- @color integer
-- @alpha number
-- @mode string
-- @antialias boolean
function JS:l_i_c_e__circle(bitmap, cx, cy, r, color, alpha, mode, antialias)
    return r.JS_LICE_Circle(bitmap, cx, cy, r, color, alpha, mode, antialias)
end

-- @bitmap identifier
-- @color integer
function JS:l_i_c_e__clear(bitmap, color)
    return r.JS_LICE_Clear(bitmap, color)
end

-- @is_sys_bitmap boolean
-- @width integer
-- @height integer
-- @return identifier 
function JS:l_i_c_e__create_bitmap(is_sys_bitmap, width, height)
    return r.JS_LICE_CreateBitmap(is_sys_bitmap, width, height)
end

-- @return identifier 
function JS:l_i_c_e__create_font()
    return r.JS_LICE_CreateFont()
end

-- Deletes the bitmap, and also unlinks bitmap from any composited window.
-- @bitmap identifier
function JS:l_i_c_e__destroy_bitmap(bitmap)
    return r.JS_LICE_DestroyBitmap(bitmap)
end

-- @l_i_c_e_font identifier
function JS:l_i_c_e__destroy_font(l_i_c_e_font)
    return r.JS_LICE_DestroyFont(l_i_c_e_font)
end

-- @bitmap identifier
-- @x integer
-- @y integer
-- @c integer
-- @color integer
-- @alpha number
-- @mode) integer
function JS:l_i_c_e__draw_char(bitmap, x, y, c, color, alpha, mode))
    return r.JS_LICE_DrawChar(bitmap, x, y, c, color, alpha, mode))
end

-- @bitmap identifier
-- @l_i_c_e_font identifier
-- @text string
-- @text_len integer
-- @x1 integer
-- @y1 integer
-- @x2 integer
-- @y2 integer
-- @return integer 
function JS:l_i_c_e__draw_text(bitmap, l_i_c_e_font, text, text_len, x1, y1, x2, y2)
    return r.JS_LICE_DrawText(bitmap, l_i_c_e_font, text, text_len, x1, y1, x2, y2)
end

-- LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
-- @bitmap identifier
-- @cx number
-- @cy number
-- @r number
-- @color integer
-- @alpha number
-- @mode string
-- @antialias boolean
function JS:l_i_c_e__fill_circle(bitmap, cx, cy, r, color, alpha, mode, antialias)
    return r.JS_LICE_FillCircle(bitmap, cx, cy, r, color, alpha, mode, antialias)
end

-- LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
-- @bitmap identifier
-- @packed_x string
-- @packed_y string
-- @num_points integer
-- @color integer
-- @alpha number
-- @mode string
function JS:l_i_c_e__fill_polygon(bitmap, packed_x, packed_y, num_points, color, alpha, mode)
    return r.JS_LICE_FillPolygon(bitmap, packed_x, packed_y, num_points, color, alpha, mode)
end

-- LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
-- @bitmap identifier
-- @x integer
-- @y integer
-- @w integer
-- @h integer
-- @color integer
-- @alpha number
-- @mode string
function JS:l_i_c_e__fill_rect(bitmap, x, y, w, h, color, alpha, mode)
    return r.JS_LICE_FillRect(bitmap, x, y, w, h, color, alpha, mode)
end

-- LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
-- @bitmap identifier
-- @x1 integer
-- @y1 integer
-- @x2 integer
-- @y2 integer
-- @x3 integer
-- @y3 integer
-- @color integer
-- @alpha number
-- @mode string
function JS:l_i_c_e__fill_triangle(bitmap, x1, y1, x2, y2, x3, y3, color, alpha, mode)
    return r.JS_LICE_FillTriangle(bitmap, x1, y1, x2, y2, x3, y3, color, alpha, mode)
end

-- @bitmap identifier
-- @return identifier 
function JS:l_i_c_e__get_d_c(bitmap)
    return r.JS_LICE_GetDC(bitmap)
end

-- @bitmap identifier
-- @return integer 
function JS:l_i_c_e__get_height(bitmap)
    return r.JS_LICE_GetHeight(bitmap)
end

-- Returns the color of the specified pixel.
-- @bitmap identifier
-- @x integer
-- @y integer
-- @return number 
function JS:l_i_c_e__get_pixel(bitmap, x, y)
    return r.JS_LICE_GetPixel(bitmap, x, y)
end

-- @bitmap identifier
-- @return integer 
function JS:l_i_c_e__get_width(bitmap)
    return r.JS_LICE_GetWidth(bitmap)
end

-- @bitmap identifier
-- @dstx integer
-- @dsty integer
-- @dstw integer
-- @dsth integer
-- @ir number
-- @ig number
-- @ib number
-- @ia number
-- @drdx number
-- @dgdx number
-- @dbdx number
-- @dadx number
-- @drdy number
-- @dgdy number
-- @dbdy number
-- @dady number
-- @mode string
function JS:l_i_c_e__grad_rect(bitmap, dstx, dsty, dstw, dsth, ir, ig, ib, ia, drdx, dgdx, dbdx, dadx, drdy, dgdy, dbdy, dady, mode)
    return r.JS_LICE_GradRect(bitmap, dstx, dsty, dstw, dsth, ir, ig, ib, ia, drdx, dgdx, dbdx, dadx, drdy, dgdy, dbdy, dady, mode)
end

-- @bitmap identifier
-- @return boolean 
function JS:l_i_c_e__is_flipped(bitmap)
    return r.JS_LICE_IsFlipped(bitmap)
end

-- LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
-- @bitmap identifier
-- @x1 number
-- @y1 number
-- @x2 number
-- @y2 number
-- @color integer
-- @alpha number
-- @mode string
-- @antialias boolean
function JS:l_i_c_e__line(bitmap, x1, y1, x2, y2, color, alpha, mode, antialias)
    return r.JS_LICE_Line(bitmap, x1, y1, x2, y2, color, alpha, mode, antialias)
end

-- @return string 
function JS:l_i_c_e__list_all_bitmaps()
    local retval, list = r.JS_LICE_ListAllBitmaps()
    if retval then
        return list
    end
end

-- Returns a system LICE bitmap containing the JPEG.
-- @filename string
-- @return identifier 
function JS:l_i_c_e__load_j_p_g(filename)
    return r.JS_LICE_LoadJPG(filename)
end

-- Returns a system LICE bitmap containing the PNG.
-- @filename string
-- @return identifier 
function JS:l_i_c_e__load_p_n_g(filename)
    return r.JS_LICE_LoadPNG(filename)
end

-- @text string
-- @return number, number 
function JS:l_i_c_e__measure_text(text)
    return r.JS_LICE_MeasureText(text)
end

-- reaper.JS_LICE_Blit(bitmap, x, y, bitmap, x, y, w, h, 0.5, "ADD").
-- @bitmap identifier
-- @x integer
-- @y integer
-- @w integer
-- @h integer
-- @mode string
-- @operand number
-- @return boolean 
function JS:l_i_c_e__process_rect(bitmap, x, y, w, h, mode, operand)
    return r.JS_LICE_ProcessRect(bitmap, x, y, w, h, mode, operand)
end

-- LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
-- @bitmap identifier
-- @x integer
-- @y integer
-- @color number
-- @alpha number
-- @mode string
function JS:l_i_c_e__put_pixel(bitmap, x, y, color, alpha, mode)
    return r.JS_LICE_PutPixel(bitmap, x, y, color, alpha, mode)
end

-- @bitmap identifier
-- @width integer
-- @height integer
function JS:l_i_c_e__resize(bitmap, width, height)
    return r.JS_LICE_Resize(bitmap, width, height)
end

-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to enable per-pixel alpha blending.
-- @dest_bitmap identifier
-- @dstx integer
-- @dsty integer
-- @dstw integer
-- @dsth integer
-- @source_bitmap identifier
-- @srcx number
-- @srcy number
-- @srcw number
-- @srch number
-- @angle number
-- @rotxcent number
-- @rotycent number
-- @cliptosourcerect boolean
-- @alpha number
-- @mode string
function JS:l_i_c_e__rotated_blit(dest_bitmap, dstx, dsty, dstw, dsth, source_bitmap, srcx, srcy, srcw, srch, angle, rotxcent, rotycent, cliptosourcerect, alpha, mode)
    return r.JS_LICE_RotatedBlit(dest_bitmap, dstx, dsty, dstw, dsth, source_bitmap, srcx, srcy, srcw, srch, angle, rotxcent, rotycent, cliptosourcerect, alpha, mode)
end

-- LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
-- @bitmap identifier
-- @x number
-- @y number
-- @w number
-- @h number
-- @cornerradius integer
-- @color integer
-- @alpha number
-- @mode string
-- @antialias boolean
function JS:l_i_c_e__round_rect(bitmap, x, y, w, h, cornerradius, color, alpha, mode, antialias)
    return r.JS_LICE_RoundRect(bitmap, x, y, w, h, cornerradius, color, alpha, mode, antialias)
end

-- LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to enable per-pixel alpha blending.
-- @dest_bitmap identifier
-- @dstx integer
-- @dsty integer
-- @dstw integer
-- @dsth integer
-- @src_bitmap identifier
-- @srcx number
-- @srcy number
-- @srcw number
-- @srch number
-- @alpha number
-- @mode string
function JS:l_i_c_e__scaled_blit(dest_bitmap, dstx, dsty, dstw, dsth, src_bitmap, srcx, srcy, srcw, srch, alpha, mode)
    return r.JS_LICE_ScaledBlit(dest_bitmap, dstx, dsty, dstw, dsth, src_bitmap, srcx, srcy, srcw, srch, alpha, mode)
end

-- Sets all pixels that match the given color's RGB values to fully transparent, and all other pixels to fully opaque.  (All pixels' RGB values remain unchanged.)
-- @bitmap identifier
-- @color_r_g_b integer
function JS:l_i_c_e__set_alpha_from_color_mask(bitmap, color_r_g_b)
    return r.JS_LICE_SetAlphaFromColorMask(bitmap, color_r_g_b)
end

-- @l_i_c_e_font identifier
-- @color integer
function JS:l_i_c_e__set_font_bk_color(l_i_c_e_font, color)
    return r.JS_LICE_SetFontBkColor(l_i_c_e_font, color)
end

-- @l_i_c_e_font identifier
-- @color integer
function JS:l_i_c_e__set_font_color(l_i_c_e_font, color)
    return r.JS_LICE_SetFontColor(l_i_c_e_font, color)
end

-- "VERTICAL", "BOTTOMUP", "NATIVE", "BLUR", "INVERT", "MONO", "SHADOW" or "OUTLINE".
-- @l_i_c_e_font identifier
-- @g_d_i_font identifier
-- @more_formats string
function JS:l_i_c_e__set_font_from_g_d_i(l_i_c_e_font, g_d_i_font, more_formats)
    return r.JS_LICE_SetFontFromGDI(l_i_c_e_font, g_d_i_font, more_formats)
end

--  * forceBaseline is an optional boolean parameter that ensures compatibility with all JPEG viewers by preventing too low quality, "cubist" settings.
-- @filename string
-- @bitmap LICE_IBitmap
-- @retval ReaType
-- @quality integer
-- @force_baseline unsupported
-- @return boolean 
function JS:l_i_c_e__write_j_p_g(filename, bitmap, retval, quality, force_baseline)
    return r.JS_LICE_WriteJPG(filename, bitmap, retval, quality, force_baseline)
end

-- @filename string
-- @bitmap LICE_IBitmap
-- @retval ReaType
-- @want_alpha boolean
-- @return boolean 
function JS:l_i_c_e__write_p_n_g(filename, bitmap, retval, want_alpha)
    return r.JS_LICE_WritePNG(filename, bitmap, retval, want_alpha)
end

-- @listview_h_w_n_d identifier
-- @index integer
-- @partial_o_k boolean
function JS:list_view__ensure_visible(listview_h_w_n_d, index, partial_o_k)
    return r.JS_ListView_EnsureVisible(listview_h_w_n_d, index, partial_o_k)
end

-- Returns the index of the next selected list item with index greater that the specified number. Returns -1 if no selected items left.
-- @listview_h_w_n_d identifier
-- @index integer
-- @return integer 
function JS:list_view__enum_sel_items(listview_h_w_n_d, index)
    return r.JS_ListView_EnumSelItems(listview_h_w_n_d, index)
end

-- Returns the index and text of the focused item, if any.
-- @listview_h_w_n_d identifier
-- @return string 
function JS:list_view__get_focused_item(listview_h_w_n_d)
    local retval, text = r.JS_ListView_GetFocusedItem(listview_h_w_n_d)
    if retval then
        return text
    end
end

-- Returns the text and state of specified item.
-- @listview_h_w_n_d identifier
-- @index integer
-- @sub_item integer
-- @return string, number 
function JS:list_view__get_item(listview_h_w_n_d, index, sub_item)
    return r.JS_ListView_GetItem(listview_h_w_n_d, index, sub_item)
end

-- @listview_h_w_n_d identifier
-- @return integer 
function JS:list_view__get_item_count(listview_h_w_n_d)
    return r.JS_ListView_GetItemCount(listview_h_w_n_d)
end

-- Returns client coordinates of the item.
-- @listview_h_w_n_d identifier
-- @index integer
-- @return number, number, number, number 
function JS:list_view__get_item_rect(listview_h_w_n_d, index)
    local retval, left, top, right, bottom = r.JS_ListView_GetItemRect(listview_h_w_n_d, index)
    if retval then
        return left, top, right, bottom
    end
end

-- Warning: this function uses the Win32 bitmask values, which differ from the values used by WDL/swell.
-- @listview_h_w_n_d identifier
-- @index integer
-- @return integer 
function JS:list_view__get_item_state(listview_h_w_n_d, index)
    return r.JS_ListView_GetItemState(listview_h_w_n_d, index)
end

-- @listview_h_w_n_d identifier
-- @index integer
-- @sub_item integer
-- @return string 
function JS:list_view__get_item_text(listview_h_w_n_d, index, sub_item)
    return r.JS_ListView_GetItemText(listview_h_w_n_d, index, sub_item)
end

-- @listview_h_w_n_d identifier
-- @return integer 
function JS:list_view__get_selected_count(listview_h_w_n_d)
    return r.JS_ListView_GetSelectedCount(listview_h_w_n_d)
end

-- @listview_h_w_n_d identifier
-- @return integer 
function JS:list_view__get_top_index(listview_h_w_n_d)
    return r.JS_ListView_GetTopIndex(listview_h_w_n_d)
end

-- @listview_h_w_n_d identifier
-- @client_x integer
-- @client_y integer
-- @return number, number, number 
function JS:list_view__hit_test(listview_h_w_n_d, client_x, client_y)
    return r.JS_ListView_HitTest(listview_h_w_n_d, client_x, client_y)
end

--  * retval: Number of selected items found; negative or zero if an error occured.
-- @listview_h_w_n_d identifier
-- @return string 
function JS:list_view__list_all_sel_items(listview_h_w_n_d)
    local retval, items = r.JS_ListView_ListAllSelItems(listview_h_w_n_d)
    if retval then
        return items
    end
end

-- Warning: this function uses the Win32 bitmask values, which differ from the values used by WDL/swell.
-- @listview_h_w_n_d identifier
-- @index integer
-- @state integer
-- @mask integer
function JS:list_view__set_item_state(listview_h_w_n_d, index, state, mask)
    return r.JS_ListView_SetItemState(listview_h_w_n_d, index, state, mask)
end

-- Currently, this fuction only accepts ASCII text.
-- @listview_h_w_n_d identifier
-- @index integer
-- @sub_item integer
-- @text string
function JS:list_view__set_item_text(listview_h_w_n_d, index, sub_item, text)
    return r.JS_ListView_SetItemText(listview_h_w_n_d, index, sub_item, text)
end

-- Example: reaper.JS_Localize("Actions", "common", "", 20)
-- @u_s_english string
-- @lang_pack_section string
-- @return string 
function JS:localize(u_s_english, lang_pack_section)
    return r.JS_Localize(u_s_english, lang_pack_section)
end

--  * The address of each MIDI editor window is stored in the provided reaper.array. Each address can be converted to a REAPER object (HWND) by the function JS_Window_HandleFromAddress.
-- @reaperarray identifier
-- @return integer 
function JS:m_i_d_i_editor__array_all(reaperarray)
    return r.JS_MIDIEditor_ArrayAll(reaperarray)
end

--  * list: Comma-separated string of hexadecimal values. Each value is an address that can be converted to a HWND by the function Window_HandleFromAddress.
-- @return string 
function JS:m_i_d_i_editor__list_all()
    local retval, list = r.JS_MIDIEditor_ListAll()
    if retval then
        return list
    end
end

-- Allocates memory for general use by functions that require memory buffers.
-- @size_bytes integer
-- @return identifier 
function JS:mem__alloc(size_bytes)
    return r.JS_Mem_Alloc(size_bytes)
end

-- Frees memory that was previously allocated by JS_Mem_Alloc.
-- @malloc_pointer identifier
-- @return boolean 
function JS:mem__free(malloc_pointer)
    return r.JS_Mem_Free(malloc_pointer)
end

-- Copies a packed string into a memory buffer.
-- @malloc_pointer identifier
-- @offset integer
-- @packed_string string
-- @string_length integer
-- @return boolean 
function JS:mem__from_string(malloc_pointer, offset, packed_string, string_length)
    return r.JS_Mem_FromString(malloc_pointer, offset, packed_string, string_length)
end

-- On Linux and macOS, retrieves a handle to the last cursor set by REAPER or its extensions via SWELL.
-- @return identifier 
function JS:mouse__get_cursor()
    return r.JS_Mouse_GetCursor()
end

--  * flags, state: The parameter and the return value both use the same format as gfx.mouse_cap. For example, to get the states of the left mouse button and the ctrl key, use flags = 0b00000101.
-- @flags integer
-- @return integer 
function JS:mouse__get_state(flags)
    return r.JS_Mouse_GetState(flags)
end

-- If successful, returns a handle to the cursor, which can be used in JS_Mouse_SetCursor.
-- @cursor_number integer
-- @return identifier 
function JS:mouse__load_cursor(cursor_number)
    return r.JS_Mouse_LoadCursor(cursor_number)
end

-- If successful, returns a handle to the cursor, which can be used in JS_Mouse_SetCursor.
-- @path_and_file_name string
-- @force_new_load unsupported
-- @return identifier 
function JS:mouse__load_cursor_from_file(path_and_file_name, force_new_load)
    return r.JS_Mouse_LoadCursorFromFile(path_and_file_name, force_new_load)
end

-- Sets the mouse cursor.  (Only lasts while script is running, and for a single "defer" cycle.)
-- @cursor_handle identifier
function JS:mouse__set_cursor(cursor_handle)
    return r.JS_Mouse_SetCursor(cursor_handle)
end

--  * On macOS, screen coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
-- @x integer
-- @y integer
-- @return boolean 
function JS:mouse__set_position(x, y)
    return r.JS_Mouse_SetPosition(x, y)
end

-- Returns the version of the js_ReaScriptAPI extension.
-- @return number 
function JS:rea_script_a_p_i__version()
    return r.JS_ReaScriptAPI_Version()
end

-- Returns the memory contents starting at address[offset] as a packed string. Offset is added as steps of 1 byte (char) each.
-- @pointer identifier
-- @offset integer
-- @length_chars integer
-- @return string 
function JS:string(pointer, offset, length_chars)
    local retval, buf = r.JS_String(pointer, offset, length_chars)
    if retval then
        return buf
    end
end

--  * Auto-repeated KEYDOWN messages are ignored.
-- @cutoff_time number
-- @return string 
function JS:v_keys__get_down(cutoff_time)
    return r.JS_VKeys_GetDown(cutoff_time)
end

--  * Auto-repeated KEYDOWN messages are ignored.
-- @cutoff_time number
-- @return string 
function JS:v_keys__get_state(cutoff_time)
    return r.JS_VKeys_GetState(cutoff_time)
end

-- Note: Mouse buttons and modifier keys are not (currently) reliably detected, and JS_Mouse_GetState can be used instead.
-- @cutoff_time number
-- @return string 
function JS:v_keys__get_up(cutoff_time)
    return r.JS_VKeys_GetUp(cutoff_time)
end

-- Returns: If keyCode refers to a single key, the intercept state of that key is returned.  If keyCode = -1, the state of the key that is most strongly blocked (highest intercept state) is returned.
-- @key_code integer
-- @intercept integer
-- @return integer 
function JS:v_keys__intercept(key_code, intercept)
    return r.JS_VKeys_Intercept(key_code, intercept)
end

-- @handle identifier
-- @return number 
function JS:window__address_from_handle(handle)
    return r.JS_Window_AddressFromHandle(handle)
end

--  * The addresses are stored in the provided reaper.array, and can be converted to REAPER objects (HWNDs) by the function JS_Window_HandleFromAddress.
-- @parent_h_w_n_d identifier
-- @reaperarray identifier
-- @return integer 
function JS:window__array_all_child(parent_h_w_n_d, reaperarray)
    return r.JS_Window_ArrayAllChild(parent_h_w_n_d, reaperarray)
end

--  * The addresses are stored in the provided reaper.array, and can be converted to REAPER objects (HWNDs) by the function JS_Window_HandleFromAddress.
-- @reaperarray identifier
-- @return integer 
function JS:window__array_all_top(reaperarray)
    return r.JS_Window_ArrayAllTop(reaperarray)
end

--  * exact: Match entire title exactly, or match substring of title.
-- @title string
-- @exact boolean
-- @reaperarray identifier
-- @return integer 
function JS:window__array_find(title, exact, reaperarray)
    return r.JS_Window_ArrayFind(title, exact, reaperarray)
end

-- @window_h_w_n_d identifier
function JS:window__attach_resize_grip(window_h_w_n_d)
    return r.JS_Window_AttachResizeGrip(window_h_w_n_d)
end

-- WARNING: This function does not yet work on Linux.
-- @window_h_w_n_d identifier
function JS:window__attach_topmost_pin(window_h_w_n_d)
    return r.JS_Window_AttachTopmostPin(window_h_w_n_d)
end

--  * On all platforms, client coordinates are relative to the upper left corner of the client area.
-- @window_h_w_n_d identifier
-- @x integer
-- @y integer
-- @return number, number 
function JS:window__client_to_screen(window_h_w_n_d, x, y)
    return r.JS_Window_ClientToScreen(window_h_w_n_d, x, y)
end

-- NOTE: On Linux and macOS, the window contents are only updated *between* defer cycles, so the window cannot be animated by for/while loops within a single defer cycle.
-- @title string
-- @class_name string
-- @x integer
-- @y integer
-- @w integer
-- @h integer
-- @style string
-- @owner_h_w_n_d identifier
-- @return string 
function JS:window__create(title, class_name, x, y, w, h, style, owner_h_w_n_d)
    local retval, style_ = r.JS_Window_Create(title, class_name, x, y, w, h, style, owner_h_w_n_d)
    if retval then
        return style_
    end
end

-- Destroys the specified window.
-- @window_h_w_n_d identifier
function JS:window__destroy(window_h_w_n_d)
    return r.JS_Window_Destroy(window_h_w_n_d)
end

-- Enables or disables mouse and keyboard input to the specified window or control.
-- @window_h_w_n_d identifier
-- @enable boolean
function JS:window__enable(window_h_w_n_d, enable)
    return r.JS_Window_Enable(window_h_w_n_d, enable)
end

-- WARNING: If using mode -1, any BitBlt()/StretchBlt() MUST have the source bitmap persist. If it is resized after Blit it could cause crashes.
-- @window_h_w_n_d identifier
-- @return integer 
function JS:window__enable_metal(window_h_w_n_d)
    return r.JS_Window_EnableMetal(window_h_w_n_d)
end

--  * exact: Match entire title, or match substring of title.
-- @title string
-- @exact boolean
-- @return identifier 
function JS:window__find(title, exact)
    return r.JS_Window_Find(title, exact)
end

--  * exact: Match entire title length, or match substring of title. In both cases, matching is not case sensitive.
-- @parent_h_w_n_d identifier
-- @title string
-- @exact boolean
-- @return identifier 
function JS:window__find_child(parent_h_w_n_d, title, exact)
    return r.JS_Window_FindChild(parent_h_w_n_d, title, exact)
end

-- (The ID of a window may be retrieved by JS_Window_GetLongPtr.)
-- @parent_h_w_n_d identifier
-- @i_d integer
-- @return identifier 
function JS:window__find_child_by_i_d(parent_h_w_n_d, i_d)
    return r.JS_Window_FindChildByID(parent_h_w_n_d, i_d)
end

--  * title: An empty string, "", will match all windows. (Search is not case sensitive.)
-- @parent_h_w_n_d identifier
-- @child_h_w_n_d identifier
-- @class_name string
-- @title string
-- @return identifier 
function JS:window__find_ex(parent_h_w_n_d, child_h_w_n_d, class_name, title)
    return r.JS_Window_FindEx(parent_h_w_n_d, child_h_w_n_d, class_name, title)
end

--  * exact: Match entire title length, or match substring of title. In both cases, matching is not case sensitive.
-- @title string
-- @exact boolean
-- @return identifier 
function JS:window__find_top(title, exact)
    return r.JS_Window_FindTop(title, exact)
end

--  * On macOS, screen coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
-- @x integer
-- @y integer
-- @return identifier 
function JS:window__from_point(x, y)
    return r.JS_Window_FromPoint(x, y)
end

-- WARNING: May not be fully implemented on macOS and Linux.
-- @window_h_w_n_d identifier
-- @return string 
function JS:window__get_class_name(window_h_w_n_d)
    return r.JS_Window_GetClassName(window_h_w_n_d)
end

--  * On macOS, screen coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
-- @window_h_w_n_d identifier
-- @return number, number, number, number 
function JS:window__get_client_rect(window_h_w_n_d)
    local retval, left, top, right, bottom = r.JS_Window_GetClientRect(window_h_w_n_d)
    if retval then
        return left, top, right, bottom
    end
end

-- @window_h_w_n_d identifier
-- @return number, number 
function JS:window__get_client_size(window_h_w_n_d)
    local retval, width, height = r.JS_Window_GetClientSize(window_h_w_n_d)
    if retval then
        return width, height
    end
end

-- Retrieves a HWND to the window that has the keyboard focus, if the window is attached to the calling thread's message queue.
-- @return identifier 
function JS:window__get_focus()
    return r.JS_Window_GetFocus()
end

-- Retrieves a HWND to the top-level foreground window (the window with which the user is currently working).
-- @return identifier 
function JS:window__get_foreground()
    return r.JS_Window_GetForeground()
end

-- If the function fails, the return value is 0.
-- @window_h_w_n_d identifier
-- @info string
-- @return number 
function JS:window__get_long(window_h_w_n_d, info)
    return r.JS_Window_GetLong(window_h_w_n_d, info)
end

-- If the function fails, a null pointer is returned.
-- @window_h_w_n_d identifier
-- @info string
-- @return identifier 
function JS:window__get_long_ptr(window_h_w_n_d, info)
    return r.JS_Window_GetLongPtr(window_h_w_n_d, info)
end

-- Returns NULL if the window is unowned or if the function otherwise fails.
-- @window_h_w_n_d identifier
-- @return identifier 
function JS:window__get_parent(window_h_w_n_d)
    return r.JS_Window_GetParent(window_h_w_n_d)
end

--  * The pixel at (right, bottom) lies immediately outside the rectangle.
-- @window_h_w_n_d identifier
-- @return number, number, number, number 
function JS:window__get_rect(window_h_w_n_d)
    local retval, left, top, right, bottom = r.JS_Window_GetRect(window_h_w_n_d)
    if retval then
        return left, top, right, bottom
    end
end

-- (Refer to documentation for Win32 C++ function GetWindow.)
-- @window_h_w_n_d identifier
-- @relation string
-- @return identifier 
function JS:window__get_related(window_h_w_n_d, relation)
    return r.JS_Window_GetRelated(window_h_w_n_d, relation)
end

--  * Leftmost or topmost visible pixel position, as well as the visible page size, the range minimum and maximum, and scroll box tracking position.
-- @window_h_w_n_d identifier
-- @scrollbar string
-- @return number, number, number, number, number 
function JS:window__get_scroll_info(window_h_w_n_d, scrollbar)
    local retval, position, page_size, min, max, track_pos = r.JS_Window_GetScrollInfo(window_h_w_n_d, scrollbar)
    if retval then
        return position, page_size, min, max, track_pos
    end
end

-- Returns the title (if any) of the specified window.
-- @window_h_w_n_d identifier
-- @return string 
function JS:window__get_title(window_h_w_n_d)
    return r.JS_Window_GetTitle(window_h_w_n_d)
end

-- wantWork: Returns the work area of the display, which excludes the system taskbar or application desktop toolbars.
-- @x1 integer
-- @y1 integer
-- @x2 integer
-- @y2 integer
-- @want_work boolean
-- @return number, number, number, number 
function JS:window__get_viewport_from_rect(x1, y1, x2, y2, want_work)
    return r.JS_Window_GetViewportFromRect(x1, y1, x2, y2, want_work)
end

-- Converts an address to a handle (such as a HWND) that can be utilized by REAPER and other API functions.
-- @address number
-- @return identifier 
function JS:window__handle_from_address(address)
    return r.JS_Window_HandleFromAddress(address)
end

-- Similar to the Win32 function InvalidateRect.
-- @window_h_w_n_d identifier
-- @left integer
-- @top integer
-- @right integer
-- @bottom integer
-- @erase_background boolean
-- @return boolean 
function JS:window__invalidate_rect(window_h_w_n_d, left, top, right, bottom, erase_background)
    return r.JS_Window_InvalidateRect(window_h_w_n_d, left, top, right, bottom, erase_background)
end

-- Determines whether a window is a child window or descendant window of a specified parent window.
-- @parent_h_w_n_d identifier
-- @child_h_w_n_d identifier
-- @return boolean 
function JS:window__is_child(parent_h_w_n_d, child_h_w_n_d)
    return r.JS_Window_IsChild(parent_h_w_n_d, child_h_w_n_d)
end

-- Determines the visibility state of the window.
-- @window_h_w_n_d identifier
-- @return boolean 
function JS:window__is_visible(window_h_w_n_d)
    return r.JS_Window_IsVisible(window_h_w_n_d)
end

-- NOTE: Since REAPER v5.974, windows can be checked using the native function ValidatePtr(windowHWND, "HWND").
-- @window_h_w_n_d identifier
-- @return boolean 
function JS:window__is_window(window_h_w_n_d)
    return r.JS_Window_IsWindow(window_h_w_n_d)
end

-- Each value is an address that can be converted to a HWND by the function Window_HandleFromAddress.
-- @parent_h_w_n_d identifier
-- @return string 
function JS:window__list_all_child(parent_h_w_n_d)
    local retval, list = r.JS_Window_ListAllChild(parent_h_w_n_d)
    if retval then
        return list
    end
end

--  * list: A comma-separated string of hexadecimal values. Each value is an address that can be converted to a HWND by the function Window_HandleFromAddress.
-- @return string 
function JS:window__list_all_top()
    local retval, list = r.JS_Window_ListAllTop()
    if retval then
        return list
    end
end

--  * exact: Match entire title exactly, or match substring of title.
-- @title string
-- @exact boolean
-- @return string 
function JS:window__list_find(title, exact)
    local retval, list = r.JS_Window_ListFind(title, exact)
    if retval then
        return list
    end
end

-- Deprecated - use GetViewportFromRect instead.
-- @x1 integer
-- @y1 integer
-- @x2 integer
-- @y2 integer
-- @want_work boolean
-- @return number, number, number, number 
function JS:window__monitor_from_rect(x1, y1, x2, y2, want_work)
    return r.JS_Window_MonitorFromRect(x1, y1, x2, y2, want_work)
end

--  * Equivalent to calling JS_Window_SetPosition with NOSIZE, NOZORDER, NOACTIVATE and NOOWNERZORDER flags set.
-- @window_h_w_n_d identifier
-- @left integer
-- @top integer
function JS:window__move(window_h_w_n_d, left, top)
    return r.JS_Window_Move(window_h_w_n_d, left, top)
end

-- In the case of windows that are listed among the Action list's contexts (such as the Media Explorer), the commandIDs of the actions in the Actions list may be used.
-- @window_h_w_n_d identifier
-- @command_i_d integer
-- @return boolean 
function JS:window__on_command(window_h_w_n_d, command_i_d)
    return r.JS_Window_OnCommand(window_h_w_n_d, command_i_d)
end

-- * Equivalent to calling JS_Window_SetPosition with NOMOVE, NOZORDER, NOACTIVATE and NOOWNERZORDER flags set.
-- @window_h_w_n_d identifier
-- @width integer
-- @height integer
function JS:window__resize(window_h_w_n_d, width, height)
    return r.JS_Window_Resize(window_h_w_n_d, width, height)
end

--  * On all platforms, client coordinates are relative to the upper left corner of the client area.
-- @window_h_w_n_d identifier
-- @x integer
-- @y integer
-- @return number, number 
function JS:window__screen_to_client(window_h_w_n_d, x, y)
    return r.JS_Window_ScreenToClient(window_h_w_n_d, x, y)
end

-- Sets the keyboard focus to the specified window.
-- @window_h_w_n_d identifier
function JS:window__set_focus(window_h_w_n_d)
    return r.JS_Window_SetFocus(window_h_w_n_d)
end

-- Brings the specified window into the foreground, activates the window, and directs keyboard input to it.
-- @window_h_w_n_d identifier
function JS:window__set_foreground(window_h_w_n_d)
    return r.JS_Window_SetForeground(window_h_w_n_d)
end

-- info: "USERDATA", "WNDPROC", "DLGPROC", "ID", "EXSTYLE" or "STYLE", and only on WindowOS, "INSTANCE" and "PARENT".
-- @window_h_w_n_d identifier
-- @info string
-- @value number
-- @return number 
function JS:window__set_long(window_h_w_n_d, info, value)
    return r.JS_Window_SetLong(window_h_w_n_d, info, value)
end

-- Transparency can only be applied to top-level windows. If windowHWND refers to a child window, the entire top-level window that contains windowHWND will be made transparent.
-- @window_h_w_n_d identifier
-- @mode string
-- @value number
-- @return boolean 
function JS:window__set_opacity(window_h_w_n_d, mode, value)
    return r.JS_Window_SetOpacity(window_h_w_n_d, mode, value)
end

-- Only on WindowsOS: If parentHWND is not specified, the desktop window becomes the new parent window.
-- @child_h_w_n_d identifier
-- @parent_h_w_n_d identifier
-- @return identifier 
function JS:window__set_parent(child_h_w_n_d, parent_h_w_n_d)
    return r.JS_Window_SetParent(child_h_w_n_d, parent_h_w_n_d)
end

--  * flags: Any combination of the standard flags, of which "NOMOVE", "NOSIZE", "NOZORDER", "NOACTIVATE", "SHOWWINDOW", "FRAMECHANGED" and "NOCOPYBITS" should be valid cross-platform.
-- @window_h_w_n_d identifier
-- @left integer
-- @top integer
-- @width integer
-- @height integer
-- @z_order string
-- @flags string
-- @return string, string 
function JS:window__set_position(window_h_w_n_d, left, top, width, height, z_order, flags)
    local retval, z_order_, flags_ = r.JS_Window_SetPosition(window_h_w_n_d, left, top, width, height, z_order, flags)
    if retval then
        return z_order_, flags_
    end
end

-- NOTE: API functions can scroll REAPER's windows, but cannot zoom them.  Instead, use actions such as "View: Zoom to one loop iteration".
-- @window_h_w_n_d identifier
-- @scrollbar string
-- @position integer
-- @return boolean 
function JS:window__set_scroll_pos(window_h_w_n_d, scrollbar, position)
    return r.JS_Window_SetScrollPos(window_h_w_n_d, scrollbar, position)
end

-- On Linux and macOS, "MAXIMIZE" has not yet been implmented, and the remaining styles may appear slightly different from their WindowsOS counterparts.
-- @window_h_w_n_d identifier
-- @style string
-- @return string 
function JS:window__set_style(window_h_w_n_d, style)
    local retval, style_ = r.JS_Window_SetStyle(window_h_w_n_d, style)
    if retval then
        return style_
    end
end

-- Changes the title of the specified window. Returns true if successful.
-- @window_h_w_n_d identifier
-- @title string
-- @return boolean 
function JS:window__set_title(window_h_w_n_d, title)
    return r.JS_Window_SetTitle(window_h_w_n_d, title)
end

-- * InsertAfterHWND: For compatibility with older versions, this parameter is still available, and is optional. If ZOrder is "INSERTAFTER", insertAfterHWND must be a handle to the window behind which windowHWND will be placed in the Z order, equivalent to setting ZOrder to this HWND; otherwise, insertAfterHWND is ignored and can be left out (or it can simply be set to the same value as windowHWND).
-- @window_h_w_n_d identifier
-- @z_order string
-- @insert_after_h_w_n_d identifier
-- @return boolean 
function JS:window__set_z_order(window_h_w_n_d, z_order, insert_after_h_w_n_d)
    return r.JS_Window_SetZOrder(window_h_w_n_d, z_order, insert_after_h_w_n_d)
end

--  * state: One of the following options: "SHOW", "SHOWNA" (or "SHOWNOACTIVATE"), "SHOWMINIMIZED", "HIDE", "NORMAL", "SHOWNORMAL", "SHOWMAXIMIZED", "SHOWDEFAULT" or "RESTORE". On Linux and macOS, only the first four options are fully implemented.
-- @window_h_w_n_d identifier
-- @state string
function JS:window__show(window_h_w_n_d, state)
    return r.JS_Window_Show(window_h_w_n_d, state)
end

-- Similar to the Win32 function UpdateWindow.
-- @window_h_w_n_d identifier
function JS:window__update(window_h_w_n_d)
    return r.JS_Window_Update(window_h_w_n_d)
end

-- Keyboard events are usually *not* received by any individual window. To intercept keyboard events, use the VKey functions.
-- @window_h_w_n_d identifier
-- @message string
-- @pass_through boolean
-- @return integer 
function JS:window_message__intercept(window_h_w_n_d, message, pass_through)
    return r.JS_WindowMessage_Intercept(window_h_w_n_d, message, pass_through)
end

--  * To check whether a message type is being blocked or passed through, Peek the message type, or retrieve the entire List of intercepts.
-- @window_h_w_n_d identifier
-- @messages string
-- @return integer 
function JS:window_message__intercept_list(window_h_w_n_d, messages)
    return r.JS_WindowMessage_InterceptList(window_h_w_n_d, messages)
end

-- Returns a string with a list of all message types currently being intercepted for the specified window.
-- @window_h_w_n_d identifier
-- @return string 
function JS:window_message__list_intercepts(window_h_w_n_d)
    local retval, list = r.JS_WindowMessage_ListIntercepts(window_h_w_n_d)
    if retval then
        return list
    end
end

-- Returns 1 if successful, 0 if the message type is not yet being intercepted, or -2 if the argument could not be parsed.
-- @window_h_w_n_d identifier
-- @message string
-- @pass_through boolean
-- @return integer 
function JS:window_message__pass_through(window_h_w_n_d, message, pass_through)
    return r.JS_WindowMessage_PassThrough(window_h_w_n_d, message, pass_through)
end

--  * wParamHigh, lParamLow and lParamHigh are signed, whereas wParamLow is unsigned.
-- @window_h_w_n_d identifier
-- @message string
-- @return boolean, number, number, number, number, number 
function JS:window_message__peek(window_h_w_n_d, message)
    local retval, passed_through, time, w_param_low, w_param_high, l_param_low, l_param_high = r.JS_WindowMessage_Peek(window_h_w_n_d, message)
    if retval then
        return passed_through, time, w_param_low, w_param_high, l_param_low, l_param_high
    end
end

--  * Useful for simulating mouse clicks and calling mouse modifier actions from scripts.
-- @window_h_w_n_d identifier
-- @message string
-- @w_param number
-- @w_param_high_word integer
-- @l_param number
-- @l_param_high_word integer
-- @return boolean 
function JS:window_message__post(window_h_w_n_d, message, w_param, w_param_high_word, l_param, l_param_high_word)
    return r.JS_WindowMessage_Post(window_h_w_n_d, message, w_param, w_param_high_word, l_param, l_param_high_word)
end

--  * messages: "WM_SETCURSOR,WM_MOUSEHWHEEL" or "0x0020,0x020E", for example.
-- @window_h_w_n_d identifier
-- @messages string
-- @return integer 
function JS:window_message__release(window_h_w_n_d, messages)
    return r.JS_WindowMessage_Release(window_h_w_n_d, messages)
end

-- Release script intercepts of window messages for all windows.
function JS:window_message__release_all()
    return r.JS_WindowMessage_ReleaseAll()
end

-- Release script intercepts of window messages for specified window.
-- @window_h_w_n_d identifier
function JS:window_message__release_window(window_h_w_n_d)
    return r.JS_WindowMessage_ReleaseWindow(window_h_w_n_d)
end

--  * Useful for simulating mouse clicks and calling mouse modifier actions from scripts.
-- @window_h_w_n_d identifier
-- @message string
-- @w_param number
-- @w_param_high_word integer
-- @l_param number
-- @l_param_high_word integer
-- @return integer 
function JS:window_message__send(window_h_w_n_d, message, w_param, w_param_high_word, l_param, l_param_high_word)
    return r.JS_WindowMessage_Send(window_h_w_n_d, message, w_param, w_param_high_word, l_param, l_param_high_word)
end

