cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

#set(MAIN "lambda-simple" CACHE STRING "lambda-simple")

project(lambda-simple VERSION 0.1.0 LANGUAGES CXX)

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMAKE_CXX_FLAGS "/nologo /O2 /EHsc /wd4141 /wd4146 /wd4244 /wd4267 /wd4624 /wd4996")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "-O2 -Wall")
else()
    set(CMAKE_CXX_FLAGS "-O2")
endif()
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(SOURCE_DIR src/main/cpp)

#Lambda expressions
add_executable(lambda-simple ${SOURCE_DIR}/lambda-expression-simple.cpp)
add_executable(lambda-value ${SOURCE_DIR}/lambda-expression-value-capture.cpp)
add_executable(lambda-reference ${SOURCE_DIR}/lambda-expression-reference-capture.cpp)
add_executable(lambda-this ${SOURCE_DIR}/lambda-expression-this-capture.cpp)
