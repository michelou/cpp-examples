cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(acquireConsume VERSION 1.0.0 LANGUAGES CXX)

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMAKE_CXX_FLAGS "/nologo /O2 /EHsc")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "-O2 -Wall")
else()
    set(CMAKE_CXX_FLAGS "-O2")
endif()
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

include_directories(${MSYS_HOME}/clang64/include)

file(GLOB SOURCES src/main/cpp/*.cpp src/main/cpp/*.h)

add_executable(acquireConsume ${SOURCES})
