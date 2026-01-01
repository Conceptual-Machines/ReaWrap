# Changelog

All notable changes to ReaWrap will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
