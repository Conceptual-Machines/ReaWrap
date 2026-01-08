# Changelog

All notable changes to ReaWrap will be documented in this file.

## [0.8.0] - 2026-01-07

### Added
- `Context:with_table(id, columns, flags, fn)` - Execute function with automatic table cleanup
- `Context:with_child(id, width, height, child_flags, window_flags, fn)` - Execute function with automatic child region cleanup
- `Context:with_tree_node(label, flags, fn)` - Execute function with automatic tree node cleanup
- Closure-based helpers use pcall to ensure cleanup even on errors, preventing ImGui state corruption

## [0.7.4] - 2026-01-07

### Added
- `TrackFX:create_param_link()` - Create parameter modulation link from source FX to target parameter
- `TrackFX:remove_param_link()` - Remove parameter modulation link from target parameter
- `TrackFX:get_param_link_info()` - Query parameter link information (active, effect, param, scale)

### Fixed
- Fixed `TrackFX:get_param()` to return actual parameter value instead of min/max bounds
  - Was incorrectly returning `(min_val, max_val)` instead of `(param_value, min_val, max_val)`
  - This caused discrete parameter controls to always read 0.0 instead of actual state

## [0.7.3] - 2026-01-05

### Fixed
- Fixed nested container stale pointer issues that prevented adding FX to nested containers
  - `TrackFX:add_fx_to_container()` now automatically refreshes stale pointers before operations
  - `TrackFX:get_container_child_count()` and `TrackFX:get_parent_container()` now handle stale pointers gracefully

### Added
- `TrackFX:refresh_pointer()` method to refresh stale encoded pointers by re-searching for FX by GUID

## [0.7.2] - 2026-01-04

### Fixed
- Fixed `TrackFX:move_out_of_container()` to return boolean instead of nil. The function now properly verifies the move by re-finding the FX by GUID and checking if the parent is nil.

## [0.7.1] - 2026-01-04

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.1] - 2026-01-04

### Added
- ImGui `Col` constants: `FrameBg`, `FrameBgHovered`, `FrameBgActive`, `SliderGrab`, `SliderGrabActive`
- ImGui drawing method: `draw_list_add_rect()` for rectangle outlines
- Pre-commit hook: `no-commit-to-branch` to protect main branch

## [0.7.0] - 2026-01-04

### Added
- ImGui cursor/position methods: `get_cursor_screen_pos()`, `set_cursor_screen_pos()`, `get_mouse_pos()`, `set_keyboard_focus_here()`
- ImGui font methods: `push_font()`, `pop_font()`
- ImGui drawing methods: `get_window_draw_list()`, `draw_list_add_rect_filled()`, `draw_list_add_line()`, `draw_list_add_text()`
- ImGui widget: `v_slider_double()`
- ImGui flag constants: `WindowFlags.HorizontalScrollbar`, `Col.ChildBg`, `StyleVar.*` (WindowPadding, FramePadding, etc.)

### Changed
- `push_style_var()` now supports Vec2 style variables (two values for WindowPadding, FramePadding, etc.)

## [0.6.5] - 2026-01-04

### Fixed
- `TrackFX:get_named_config_param()` now returns `nil` instead of throwing an error when parameter is not found
  - This is correct behavior for optional parameters like `param.X.plink.*` which return false when not set

## [0.6.4] - 2026-01-01

### Added
- `theme.from_reaper_theme()` function to dynamically generate ImGui themes from REAPER's current theme colors
  - Reads `col_main_bg`, `col_main_text`, `col_main_edge`, and other theme colors via `GetThemeColor` API
  - Ensures text colors are readable with automatic contrast adjustment
  - Makes child windows darker than main window for visual distinction
  - Converts REAPER's BGR color format to RGBA for ImGui

## [0.6.3] - 2026-01-01

### Fixed
- `TrackFX:add_fx_to_container()` now correctly handles nested containers
  - Fixed `calc_container_dest_idx()` to find container's position within parent
  - Properly calculates destination index for nested container hierarchies

### Added
- Integration tests for container operations (`tests/integration/test_containers.lua`)
  - Tests for top-level and nested container creation
  - Tests for FX movement in and out of containers
  - Tests for `Track:add_fx_to_new_container()` with nested structures

## [0.6.2] - Skipped

*Note: Version 0.6.2 was skipped by mistake. The changes intended for 0.6.2 were released in 0.6.3.*

## [0.6.1] - 2026-01-01

### Fixed
- `Context:begin_child()` now supports `window_flags` parameter for horizontal scrollbar

## [0.6.0] - 2026-01-01

### Added
- **ImGui drag-drop API**
  - `Context:begin_drag_drop_source()` / `end_drag_drop_source()`
  - `Context:begin_drag_drop_target()` / `end_drag_drop_target()`
  - `Context:set_drag_drop_payload()` / `accept_drag_drop_payload()` / `get_drag_drop_payload()`
- **ImGui selectable size parameters** - `Context:selectable()` now accepts `size_x` and `size_y`
- **ImGui modifier key detection**
  - `Context:is_shift_down()` / `is_ctrl_down()` / `is_alt_down()`
  - `Context:get_key_mods()`
- `TrackFX:move_out_of_container()` - Move FX back to main chain

## [0.5.0] - 2026-01-01

### Added
- `Track:find_fx_by_guid()` - Find FX by stable GUID (recursive search)
- `Track:add_fx_to_new_container()` - Create container and move FX into it
- `TrackFX:delete()` - Delete FX from track
- `TrackFX:move_to_container()` - Move FX into container

### Fixed
- Container addressing formula for `add_fx_to_container`
- `Track:create_container()` with position parameter

## [0.4.1] - 2026-01-01

### Added
- **ImGui TreeNodeFlags** - Tree node display flags
- **ImGui InputTextFlags** - Input text behavior flags

## [0.4.0] - 2026-01-01

### Added
- **Plugins module** (`lua/plugins.lua`)
  - `Plugins.scan()` - Scan all installed FX using `EnumInstalledFX`
  - `Plugins.iter_all()` - Iterate over all plugins
  - `Plugins.iter_instruments()` - Iterate over instruments (VSTi, AUi, CLAPi)
  - `Plugins.iter_effects()` - Iterate over effects
  - `Plugins.iter_search(query)` - Search and iterate matching plugins
  - `Plugins.find(name)` - Find plugin by exact name
  - `PluginScanner` class with format/manufacturer filtering
  - `PluginInfo` with parsed name, format, manufacturer, is_instrument
  - Deduplication with format preferences (VST3 > VST > AU > JS)
- Integration test for plugins module

## [0.3.2] - 2026-01-01

### Added
- **ImGui ID stack methods**
  - `Context:push_id(id)` - Push string or number ID onto stack
  - `Context:pop_id()` - Pop ID from stack
- `Context:set_next_item_width(width)` - Set width for next widget

## [0.3.1] - 2026-01-01

### Added
- `Window:defer_action(fn)` - Queue actions to run after frame completes
- Integration tests for core classes and ImGui (`tests/integration/`)

### Changed
- **ImGui deferred close pattern** - `Window:close()` is now safe to call during `on_draw`
  - Context destruction is deferred until after the frame completes
  - Prevents "expected valid ImGui_Context*" errors
- Updated for ReaImGui 0.9+ compatibility
  - Config flags passed directly to `ImGui_CreateContext()`
  - Contexts are garbage collected (no explicit destroy needed)

## [0.3.0] - 2025-12-31

### Added
- **ImGui wrapper module** (`lua/imgui/`)
  - `imgui.Context` - Context wrapper with shorthand methods (no ctx passing)
  - `imgui.Window` - OOP window management with lifecycle callbacks
  - `imgui.Modal` - Modal dialog support
  - `Window.confirm()` / `Window.alert()` - Quick dialog helpers
  - `imgui.theme` - Theme system with pre-built themes
    - `theme.Dark`, `theme.Light`, `theme.Reaper`, `theme.HighContrast`
    - Color utilities: `rgba()`, `hex()`, `brighten()`, `with_alpha()`
    - `theme.create()`, `theme.extend()` for custom themes
  - Flag constant shortcuts (`WindowFlags`, `ChildFlags`, `Cond`, `Col`, `Key`)
- Comprehensive ImGui mock for unit testing
- 33 new unit tests for ImGui wrapper

## [0.2.0] - 2025-12-31

### Added
- **Container support (Reaper 7+)**
  - `TrackFX:is_container()` - Check if FX is a container
  - `TrackFX:get_container_child_count()` - Get number of child FX
  - `TrackFX:get_container_children()` - Get array of child TrackFX objects
  - `TrackFX:iter_container_children()` - Iterator over children
  - `TrackFX:get_parent_container()` - Get parent container
  - `TrackFX:get_container_depth()` - Get nesting depth
  - `TrackFX:get/set_container_channels()` - Internal channel count
  - `TrackFX:get/set_container_input_pins()` - Input pin count
  - `TrackFX:get/set_container_output_pins()` - Output pin count
  - `TrackFX:add_fx_to_container()` - Move FX into container
  - `TrackFX:copy_fx_to_container()` - Copy FX into container
  - `Track:create_container()` - Create new container on track
  - `Track:get_all_fx_flat()` - Get flat list including nested FX
  - `Track:iter_all_fx_flat()` - Iterator over all FX
- `version.lua` module for version checking
- Pre-commit hooks configuration

### Changed
- Bumped version to 0.2.0

## [0.1.0] - 2025-11-25

### Added
- Initial release with reorganized structure
- Lua modules: track, track_fx, take, take_fx, item, project, pcm, audio_accessor, helpers
- C++ implementation (experimental)
- Documentation generation with LDoc

## [0.0.1] - 2022-06-17

### Added
- Initial prototype
