cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(tuple-iterators VERSION 1.0.0 LANGUAGES CXX)

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMAKE_CXX_FLAGS "/nologo /O2 /EHsc")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "-O2 -Wall")
else()
    set(CMAKE_CXX_FLAGS "-O2")
endif()
set(CMAKE_CXX_STANDARD 17)

#include_directories(include)

file(GLOB SOURCES src/main/cpp/*.cpp src/main/cpp/*.h)

add_executable(tuple-iterators ${SOURCES})
