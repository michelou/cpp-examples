ifeq ($(OS),Windows_NT)
ifndef BCC_HOME
ifeq ($(TOOLSET),bcc)
$(error Variable BCC_HOME is not set)
endif
endif
ifndef LLVM_HOME
ifeq ($(TOOLSET),clang)
$(error Variable LLVM_HOME is not set)
endif
endif
ifndef MSVC_HOME
ifeq ($(TOOLSET),msvc)
$(error Variable MSVC_HOME is not set)
endif
endif
ifndef MSYS_HOME
ifeq ($(TOOLSET),gcc)
$(error Variable MSYS_HOME is not set)
endif
endif
ifndef ONEAPI_ROOT
ifeq ($(TOOLSET),icx)
$(error Variable ONEAPI_ROOT is not set)
endif
endif
ifndef ORANGEC_HOME
ifeq ($(TOOLSET)occ)
$(error Variable ORANGEC_HOME is not set)
endif
endif
ifndef WINSDK_HOME
ifeq ($(TOOLSET),clang)
$(error Variable WINSDK_HOME is not set)
else ifeq ($(TOOLSET),msvc)
$(error Variable WINSDK_HOME is not set)
endif
endif

ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
ARCH = x64
else
ARCH = x86
endif

TARGET_EXT  = .exe
PSEP        = ;
BCC         = $(subst \,/,$(BCC_HOME))/bin/bcc32c.exe
CC          = $(subst \,/,$(MSYS_HOME))/usr/bin/g++.exe
CL          = $(subst \,/,$(MSVC_HOME))/bin/Host$(ARCH)/$(ARCH)/cl.exe
CLANG       = $(subst \,/,$(LLVM_HOME))/bin/clang.exe
DOXYGEN     = $(subst \,/,$(DOXYGEN_HOME))/doxygen.exe
ICX         = $(subst \,/,$(ONEAPI_ROOT))/compiler/latest/bin/icx.exe
LLC         = $(subst \,/,$(LLVM_HOME))/bin/llc.exe
LLVM_CONFIG = $(subst \,/,$(LLVM_HOME))/bin/llvm-config.exe
OCC         = $(subst \,/,$(ORANGEC_HOME))/bin/occ.exe
## $(MSYS_HOME)\usr\bin\{cp.exe, make.exe, wget.exe}
CP          = /usr/bin/cp.exe
CPPCHECK    = /mingw64/bin/cppcheck.exe
ECHO        = /usr/bin/echo.exe
FIND        = /usr/bin/find.exe
MKDIR       = /usr/bin/mkdir.exe
RM          = /usr/bin/rm.exe
TEST        = /usr/bin/test.exe
TOUCH       = /usr/bin/touch.exe
#
MSVC_INCPATH   = $(subst \,/,$(MSVC_HOME))/include
MSVC_LIBPATH   = $(subst \,/,$(MSVC_HOME))/lib/$(ARCH)
WINSDK_INCROOT = $(subst \,/,$(WINSDK_HOME))/include
WINSDK_INCPATH = $(WINSDK_INCROOT)/$(shell cd "$(WINSDK_INCROOT)" && ls -d [0-9]*/ | tail -n 1)
WINSDK_LIBROOT = $(subst \,/,$(WINSDK_HOME))/lib
WINSDK_LIBPATH = $(WINSDK_LIBROOT)/$(shell cd "$(WINSDK_LIBROOT)" && ls -d [0-9]*/ | tail -n 1)
MINGW_XXX      = $(subst \,/,$(MSYS_HOME))/mingw64/include
MINGW_INCPATH  = $(subst \,/,$(MSYS_HOME))/mingw64/x86_64-w64-mingw32/include
MINGW_LIBPATH  = $(subst \,/,$(MSYS_HOME))/mingw64/x86_64-w64-mingw32/lib
ONEAPI_LIBPATH = $(subst \,/,$(ONEAPI_ROOT))/compiler/latest/compiler/lib
else
TARGET_EXT  =
PSEP        = :
BCC         = 
CC          = g++
CL          = cl
CLANG       = clang
CP          = cp
CPPCHECK    = cppcheck
DOXYGEN     = doxygen
ECHO        = echo
FIND        = find
ICX         = icx
LLC         = llc
LLVM_CONFIG = llvm-config
MKDIR       = mkdir
OCC         = occ
RM          = rm
TEST        = test
TOUCH       = touch
endif
