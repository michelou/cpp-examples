cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

project(algebraic_concepts VERSION 1.0.0 LANGUAGES CXX)

if(MSVC)
    set(CMAKE_CXX_FLAGS "/nologo /O2 /EHsc /wd4141 /wd4146 /wd4244 /wd4267 /wd4624 /wd4996")
else()
    set(CMAKE_CXX_FLAGS "-O2 -Wall")
endif()
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

#include_directory(include)

file(GLOB SOURCES src/*.cpp src/*.h)

add_executable(algebraic_concepts ${SOURCES})
