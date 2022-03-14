TOOLSET ?= gcc
CXXSTD ?= c++17

include ../Makefile.inc

PROJECT_NAME   ?= $(shell basename $(CURDIR))
PROJECT_CONFIG ?= Release

SOURCE_DIR = src
TARGET_DIR = build
TARGET_EXE_DIR = $(TARGET_DIR)/$(PROJECT_CONFIG)

## PTHREADS_ROOTPATH = target/pthreads/build/native
## PTHREADS_INCPATH = $(PTHREADS_ROOTPATH)/include
## PTHREADS_LIBPATH = $(PTHREADS_ROOTPATH)/lib/v110/$(ARCH)/$(PROJECT_CONFIG)/static/cdecl

PTHREADS_ROOTPATH = pthreads-win32
PTHREADS_INCPATH = $(PTHREADS_ROOTPATH)/include
PTHREADS_LIBPATH = $(PTHREADS_ROOTPATH)/lib/$(ARCH)

ifeq ($(TOOLSET),msvc)
CXX = $(CL)
CXXFLAGS = -nologo -std:$(CXXSTD) -EHsc -I"$(MSVC_INCPATH)" -I"$(WINSDK_INCPATH)ucrt" -I"$(WINSDK_INCPATH)um" -DHAVE_STRUCT_TIMESPEC -I"$(PTHREADS_INCPATH)" -Fo"$(TARGET_DIR)/"
CXXLINK = -link -libpath:"$(MSVC_LIBPATH)" -libpath:"$(WINSDK_LIBPATH)ucrt/$(ARCH)" -libpath:"$(WINSDK_LIBPATH)um/$(ARCH)" -defaultlib:"$(PTHREADS_LIBPATH)/pthreadVC2" -machine:$(ARCH)
else ifeq ($(TOOLSET),gcc)
CXX = $(CC)
CXXFLAGS = --std=$(CXXSTD) -O2 -I"$(PTHREADS_INCPATH)" -lpthread -Wall -Wno-unused-variable
CXXLINK =
else ifeq ($(TOOLSET),clang)
CXX = $(CLANG)
CXXFLAGS = --std=$(CXXSTD) -O2 -I"$(MINGW_XXX)" -I"$(MINGW_INCPATH)" -lpthread -Wall -Wno-unused-variable
CXXLINK =
endif
CXXVARS =

##############################################################################
## main rules

SOURCES = $(wildcard $(SOURCE_DIR)/main/cpp/*.cpp)
TARGET  = $(TARGET_EXE_DIR)/$(PROJECT_NAME)$(EXE_EXT)

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
	$(RM) -rf "$(TARGET_DIR)"

run: build
	$(TARGET)

##############################################################################
## phony

.PHONY: all build clean run

.SUFFIXES:
.SUFFIXES: .c .o .exe
