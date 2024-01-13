cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(crash_course VERSION 1.0.0 LANGUAGES CXX)

if(MSVC)
    set(CMAKE_CXX_FLAGS "/nologo /O2 /EHsc /wd4141 /wd4146 /wd4244 /wd4267 /wd4624 /wd4996")
else()
    set(CMAKE_CXX_FLAGS "-O2 -Wall")
endif()
set(CMAKE_CXX_STANDARD 17)

#include_directories(include)

file(GLOB SOURCES src/*.cpp src/*.h)

add_executable(crash_course ${SOURCES})
