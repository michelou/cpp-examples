##
## Copyright (c) 2018-2025 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

TOOLSET ?= gcc
CXXSTD ?= c++17

include ../Makefile.inc

PROJECT_NAME   ?= $(shell basename $(CURDIR))
PROJECT_CONFIG ?= Release

SOURCE_DIR = src
TARGET_DIR = build
TARGET_EXE_DIR = $(TARGET_DIR)/$(PROJECT_CONFIG)

PTHREADS_ROOTPATH = ../pthreads-win32
PTHREADS_INCPATH = $(PTHREADS_ROOTPATH)/include
PTHREADS_LIBPATH = $(PTHREADS_ROOTPATH)/lib/$(ARCH)
PTHREADS_LIBNAME=pthreadVC2

ifeq ($(TOOLSET),msvc)
CXX = $(CL)
CXXFLAGS = -nologo -std:$(CXXSTD) -EHsc -I"$(MSVC_INCPATH)" -I"$(WINSDK_INCPATH)ucrt" -I"$(WINSDK_INCPATH)um" -D_TIMESPEC_DEFINED -I"$(PTHREADS_INCPATH)" -Fo"$(TARGET_DIR)/"
CXXLINK = -link -libpath:"$(MSVC_LIBPATH)" -libpath:"$(WINSDK_LIBPATH)ucrt/$(ARCH)" -libpath:"$(WINSDK_LIBPATH)um/$(ARCH)" -defaultlib:"$(PTHREADS_LIBPATH)/$(PTHREADS_LIBNAME)" -machine:$(ARCH)
else ifeq ($(TOOLSET),gcc)
CXX = $(CC)
CXXFLAGS = --std=$(CXXSTD) -O2 -lpthread -Wall -Wno-unused-variable -Wno-unused-but-set-variable
CXXLINK =
else ifeq ($(TOOLSET),clang)
CXX = $(CLANG)
CXXFLAGS = --std=$(CXXSTD) -O2 -D_TIMESPEC_DEFINED -I"$(PTHREADS_INCPATH)" -L"$(PTHREADS_LIBPATH)" -l$(PTHREADS_LIBNAME) -Wall -Wno-unused-variable
CXXLINK =
endif
CXXVARS =

##############################################################################
## main rules

SOURCES = $(wildcard $(SOURCE_DIR)/main/cpp/*.cpp)
TARGET  = $(TARGET_EXE_DIR)/$(PROJECT_NAME)$(TARGET_EXT)

all: build run

build: $(TARGET)

$(TARGET): $(SOURCES)
	@$(TEST) -d "$(TARGET_EXE_DIR)" || $(MKDIR) -p "$(TARGET_EXE_DIR)"
ifeq ($(TOOLSET),msvc)
	@## https://docs.microsoft.com/en-us/cpp/build/reference/output-file-f-options
	"$(CXX)" $(CXXDEBUG) $(CXXFLAGS) $(CXXVARS) -Fe"$@" $^ $(CXXLINK)
else
	"$(CXX)" $(CXXDEBUG) $(CXXFLAGS) $(CXXVARS) -o $@ $^ $(CXXLINK)
endif
ifneq ($(TOOLSET),gcc)
	"$(CP)" "$(PTHREADS_ROOTPATH)/dll/$(ARCH)/$(PTHREADS_LIBNAME).dll" "$(TARGET_EXE_DIR)/"
endif

clean:
	$(RM) -rf "$(TARGET_DIR)"

run: build
	$(TARGET)

##############################################################################
## phony

.PHONY: all build clean run

.SUFFIXES:
.SUFFIXES: .c .o .obj .exe
