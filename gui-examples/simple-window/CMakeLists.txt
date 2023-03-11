cmake_minimum_required(VERSION 3.20)

project(simple-window VERSION 1.0.0 LANGUAGES CXX)

if(MSVC)
    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_FLAGS "/O2 /EHsc /wd4141 /wd4146 /wd4244 /wd4267 /wd4624 /wd4996")
    ## see https://stackoverflow.com/questions/64993943/what-where-is-scrt-common-main-seh
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /entry:WinMainCRTStartup")
else()
    set(CMAKE_CXX_STANDARD 14)
    set(CMAKE_CXX_FLAGS "-O2 -Wall")
endif()

    
#include_directory(include)

file(GLOB SOURCES src/*.cpp src/*.h)

add_executable(simple-window ${SOURCES})
