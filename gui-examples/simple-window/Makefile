TOOLSET ?= gcc
CXXSTD ?= c++17

include ../Makefile.inc

PROJECT_NAME   ?= $(shell basename $(CURDIR))
PROJECT_CONFIG ?= Release

SOURCE_DIR = src
TARGET_DIR = build
TARGET_EXE_DIR = $(TARGET_DIR)/$(PROJECT_CONFIG)

ifeq ($(TOOLSET),msvc)
CXX = $(CL)
CXXFLAGS = -nologo -std:$(CXXSTD) -EHsc -I"$(MSVC_INCPATH)" -I"$(WINSDK_INCPATH)shared" -I"$(WINSDK_INCPATH)ucrt" -I"$(WINSDK_INCPATH)um" -Fo"$(TARGET_DIR)/"
CXXLINK = -link -libpath:"$(MSVC_LIBPATH)" -libpath:"$(WINSDK_LIBPATH)ucrt/$(ARCH)" -libpath:"$(WINSDK_LIBPATH)um/$(ARCH)" 
else ifeq ($(TOOLSET),gcc)
CXX = $(CC)
CXXFLAGS = --std=$(CXXSTD) -O2 -Wall -Wno-unused-variable
CXXLINK = -Wl,--subsystem,windows
else ifeq ($(TOOLSET),clang)
CXX = $(CLANG)
CXXFLAGS = --std=$(CXXSTD) -O2 -Wall -Wno-unused-variable
CXXLINK =
endif
CXXVARS =

##############################################################################
## main rules

SOURCES = $(wildcard $(SOURCE_DIR)/*.cpp)
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

clean:
	"$(RM)" -rf "$(TARGET_DIR)"

run: build
	$(TARGET)

##############################################################################
## phony

.PHONY: all build clean run

.SUFFIXES:
.SUFFIXES: .c .o .obj .exe
