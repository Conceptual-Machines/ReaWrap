# Minimal test extension to verify ReaWrap works
cmake_minimum_required(VERSION 3.15)

# Find REAPER SDK
if(NOT REAWRAP_REAPER_SDK_PATH)
    message(FATAL_ERROR "REAWRAP_REAPER_SDK_PATH must be set to build examples")
endif()

# Simple test extension
add_library(reaper_test_reawrap MODULE test_reawrap.cpp)

target_link_libraries(reaper_test_reawrap PRIVATE ReaWrap)

# Include directories
target_include_directories(reaper_test_reawrap PRIVATE
    ${REAWRAP_REAPER_SDK_PATH}
    ${CMAKE_CURRENT_SOURCE_DIR}/../../WDL  # If WDL is available
)

# Platform-specific settings
if(APPLE)
    set_target_properties(reaper_test_reawrap PROPERTIES SUFFIX ".dylib")
    target_link_options(reaper_test_reawrap PRIVATE -undefined dynamic_lookup)
elseif(WIN32)
    set_target_properties(reaper_test_reawrap PROPERTIES SUFFIX ".dll")
else()
    set_target_properties(reaper_test_reawrap PROPERTIES SUFFIX ".so")
endif()
