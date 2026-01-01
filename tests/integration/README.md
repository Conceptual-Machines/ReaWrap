# ReaWrap ImGui Integration Tests

These tests run **inside REAPER** with the real ReaImGui extension to verify
that the ReaWrap ImGui wrapper works correctly in a real environment.

## Prerequisites

- REAPER installed
- ReaImGui extension installed (via ReaPack)
- ReaWrap library accessible

## Running the Tests

### Automated Tests

Run `test_imgui_integration.lua` as a ReaScript in REAPER:

1. Open REAPER
2. Go to **Actions** → **Show action list**
3. Click **New action...** → **Load ReaScript...**
4. Navigate to `ReaWrap/tests/integration/test_imgui_integration.lua`
5. Click **Open**
6. Run the action

This will:
- Run all integration tests
- Show results in a popup window
- Log results to the REAPER console

### Visual/Interactive Tests

Run `test_imgui_visual.lua` as a ReaScript to manually verify widgets:

1. Load and run `test_imgui_visual.lua` in REAPER
2. A window will appear with tabs for different widget types
3. Interact with all widgets to verify they work correctly
4. Check the "Info" tab for diagnostic information

## What's Tested

### test_imgui_integration.lua

- ReaImGui availability and version
- Context creation and destruction
- All window, condition, color, and key flag constants
- Theme system (rgba, hex, brighten, with_alpha)
- Pre-built themes existence and validity
- Theme creation and extension
- Window class instantiation and options
- All Context method existence (widgets, layout, tables, trees, popups, menus, tabs, style, utility)

### test_imgui_visual.lua

Interactive tests for:
- Buttons (regular, small, disabled)
- Checkboxes
- Radio buttons
- Sliders (int and float)
- Input fields (text, int, float)
- Selectables
- Groups and same_line layout
- Tables with headers
- Tree nodes
- Child windows
- Theme switching
- Theme color utilities
- Window/content metrics

## Adding New Tests

To add automated tests, add a new test function to `test_imgui_integration.lua`:

```lua
TestRunner:add("Test name", function()
    TestRunner:assert(condition, "Error message")
    TestRunner:assert_equals(expected, actual)
    TestRunner:assert_type("string", value)
    TestRunner:assert_not_nil(value)
end)
```

For visual tests, add new sections to the appropriate tab drawing function
in `test_imgui_visual.lua`.
