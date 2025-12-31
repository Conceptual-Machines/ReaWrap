# Contributing to ReaWrap

Thank you for your interest in contributing to ReaWrap!

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a branch for your changes
4. Make your changes
5. Submit a pull request

## Code Style

### C++
- Follow the existing code style
- Use `namespace ReaWrap`
- Methods return `Track*` for chaining where appropriate
- Use camelCase for method names: `setName()`, `addInstrument()`
- Document all public methods

### Lua
- Follow existing Lua style
- Use snake_case for method names: `set_name()`, `add_instrument()`
- Document with LDoc comments

## Adding New Features

1. **API Parity**: If adding to C++, consider adding to Lua (and vice versa)
2. **Documentation**: Update docs in `docs/api/`
3. **Examples**: Add examples in `docs/examples/`
4. **Tests**: Add tests in `cpp/tests/` or `lua/tests/`

## Testing

### C++
```bash
cd cpp
mkdir build && cd build
cmake .. -DREAWRAP_BUILD_TESTS=ON
make
ctest
```

### Lua
Run tests in REAPER's script console or use the test runner.

## Documentation

- API docs go in `docs/api/`
- Guides go in `docs/guides/`
- Examples go in `docs/examples/`

## Pull Request Process

1. Update README.md if needed
2. Update CHANGELOG.md
3. Ensure all tests pass
4. Update documentation
5. Submit PR with clear description

## Questions?

Open an issue or start a discussion!
