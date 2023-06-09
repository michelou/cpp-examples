cmake_minimum_required(VERSION 3.20)

project(visitor-pattern VERSION 1.0.0 LANGUAGES CXX)

if(MSVC)
    set(CMAKE_CXX_FLAGS "/nologo /O2 /EHsc")
elseif(CLANG)
    ##https://docwiki.embarcadero.com/RADStudio/Sydney/en/BCC32.EXE,_the_C%2B%2B_32-bit_Command-Line_Compiler
    set(CMAKE_CXX_FLAGS "-O2")
else()
    ##set(CMAKE_CXX_FLAGS "-O2 -Wall")
    set(CMAKE_CXX_FLAGS "-O2")
endif()
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

#include_directory(include)

file(GLOB SOURCES src/main/cpp/*.cpp src/main/cpp/*.h)

add_executable(visitor-pattern ${SOURCES})
