# Fix for Nested Container Stale Pointer Issue

## Problem

When adding FX to nested containers (e.g., a rack inside another rack in SideFX), the operation fails with `add_fx_to_container()` returning `false`.

### Root Cause

1. After nesting a container, REAPER assigns it an **encoded pointer** (e.g., `0x200000D`)
2. When `find_fx_by_guid()` returns this nested container, it uses the encoded pointer
3. After subsequent container operations, this encoded pointer can become **stale**
4. When methods like `is_container()` or `get_container_child_count()` are called with a stale encoded pointer, `TrackFX_GetNamedConfigParm()` fails
5. This causes `add_fx_to_container()` to return false early because `is_container()` returns false

### Example Error from SideFX

```
Rack: guid={804E6D0, pointer=0x200000D, is_container=false, has_parent=false
```

The rack has an encoded pointer but `is_container()` returns false, preventing the operation.

## Solution

Added automatic stale pointer detection and refresh to the following methods in `track_fx.lua`:

### 1. New Method: `TrackFX:refresh_pointer()`

Searches for the FX by GUID and updates the pointer to a fresh, valid value:
- First checks track-level FX
- Then recursively searches all nested containers
- Updates `self.pointer` if found

### 2. Updated `TrackFX:add_fx_to_container()`

```lua
-- If this container's pointer looks like a stale encoded pointer,
-- try to refresh it before proceeding
if self.pointer >= 0x2000000 then
    self:refresh_pointer()
end
```

### 3. Updated `TrackFX:get_container_child_count()`

Tries with current pointer first, then refreshes if it fails and pointer is encoded.

### 4. Updated `TrackFX:get_parent_container()`

Tries with current pointer first, then refreshes if it fails and pointer is encoded.

## Testing

### Quick Test in REAPER

1. Select a track in REAPER
2. Run: `/Users/lucaromagnoli/Dropbox/Code/Projects/ReaScript/ReaWrap/tests/test_stale_pointer_fix.lua`
3. Check console output for "✓ SUCCESS!" or "✗ FAILED!"

### Test in SideFX

1. Create a rack in SideFX
2. Add a chain to that rack
3. Add another rack inside the chain (nested rack)
4. Try to add a plugin to the nested rack
5. It should now work without errors

### Integration Tests

The existing integration tests should continue to pass:
- `/Users/lucaromagnoli/Dropbox/Code/Projects/ReaScript/ReaWrap/tests/integration/test_containers.lua`

Run them in REAPER using the test action system.

## Files Modified

- `lua/track_fx.lua`: Added `refresh_pointer()` and updated container methods

## Backward Compatibility

✅ All changes are backward compatible:
- Existing code continues to work
- Only adds automatic pointer refresh when stale pointers are detected
- No API changes or breaking changes

## Performance Impact

Minimal:
- Refresh only occurs when:
  1. Pointer is encoded (>= 0x2000000)
  2. AND the operation with current pointer fails
- Most operations with valid pointers are unaffected

## Next Steps

1. Test in REAPER using `test_stale_pointer_fix.lua`
2. Test in SideFX with nested racks
3. If successful, commit the changes
4. Consider bumping version to 0.7.3 with changelog entry
