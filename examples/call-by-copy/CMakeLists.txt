cmake_minimum_required(VERSION 3.20)

project(call-by-copy VERSION 1.0.0 LANGUAGES CXX)

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMAKE_CXX_FLAGS "/nologo /O2 /EHsc /wd4141 /wd4146 /wd4244 /wd4267 /wd4624 /wd4996")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "-O2 -Wall")
else()
    set(CMAKE_CXX_FLAGS "-O2")
endif()
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

#include_directory(include)

file(GLOB SOURCES src/main/cpp/*.cpp src/main/cpp/*.h)

add_executable(call-by-copy ${SOURCES})
