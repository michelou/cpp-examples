cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(parallel-sum VERSION 1.0.0 LANGUAGES CXX)

if(MSVC)
    set(CMAKE_CXX_FLAGS "/nologo /O2 /EHsc")
else()
    set(CMAKE_CXX_FLAGS "-O2 -Wall")
endif()
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

#include_directories(include)

file(GLOB SOURCES src/*.cpp src/*.h)

add_executable(parallel-sum ${SOURCES})
