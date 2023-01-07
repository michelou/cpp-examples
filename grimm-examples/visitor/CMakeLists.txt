cmake_minimum_required(VERSION 3.14)

project(visitor VERSION 1.0.0 LANGUAGES CXX)

if(MSVC)
    set(CMAKE_CXX_FLAGS "/nologo /O2 /EHsc")
else()
    set(CMAKE_CXX_FLAGS "-O2 -Wall")
endif()
set(CMAKE_CXX_STANDARD 17)

#include_directory(include)

file(GLOB SOURCES src/main/cpp/*.cpp src/main/cpp/*.h)

add_executable(visitor ${SOURCES})
