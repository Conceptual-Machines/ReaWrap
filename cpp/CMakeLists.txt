cmake_minimum_required(VERSION 3.15)
project(ReaWrap VERSION 0.1.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Options
option(REAWRAP_BUILD_EXAMPLES "Build example programs" ON)
option(REAWRAP_BUILD_TESTS "Build test programs" OFF)

# Include directories
include_directories(include)

# Source files
set(REAWRAP_SOURCES
    src/ReaperAPI.cpp
    src/Track.cpp
    src/Item.cpp
    src/Project.cpp
)

# Create library
add_library(ReaWrap STATIC ${REAWRAP_SOURCES})

# Install
install(TARGETS ReaWrap
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(DIRECTORY include/ReaWrap
    DESTINATION include
    FILES_MATCHING PATTERN "*.h"
)

# Examples
if(REAWRAP_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

# Tests
if(REAWRAP_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

