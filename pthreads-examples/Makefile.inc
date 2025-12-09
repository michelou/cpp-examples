ifeq ($(OS),Windows_NT)
ifndef LLVM_HOME
$(error Variable LLVM_HOME is not set)
endif
ifndef MSVC_HOME
$(error Variable MSVC_HOME is not set)
endif
ifndef MSYS_HOME
$(error Variable MSYS_HOME is not set)
endif
ifndef ONEAPI_ROOT
$(error Variable ONEAPI_ROOT is not set)
endif
ifndef WINSDK_HOME
$(error Variable WINSDK_HOME is not set)
endif

ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
ARCH = x64
else
ARCH = x86
endif

TARGET_EXT  = .exe
PSEP        = ;
CL          = $(subst \,/,$(MSVC_HOME))/bin/Host$(ARCH)/$(ARCH)/cl.exe
CLANG       = $(subst \,/,$(LLVM_HOME))/bin/clang.exe
ICX         = $(subst \,/,$(ONEAPI_ROOT))/compiler/latest/bin/icx.exe
LLC         = $(subst \,/,$(LLVM_HOME))/bin/llc.exe
LLVM_CONFIG = $(subst \,/,$(LLVM_HOME))/bin/llvm-config.exe
## $(MSYS_HOME)\usr\bin\{cp.exe, make.exe, wget.exe}
CC          = /usr/bin/g++.exe
CP          = /usr/bin/cp.exe
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
WINSDK_INCPATH = $(WINSDK_INCROOT)/$(shell cd "$(WINSDK_INCROOT)" && ls -d */ | tail -n 1)
WINSDK_LIBROOT = $(subst \,/,$(WINSDK_HOME))/lib
WINSDK_LIBPATH = $(WINSDK_LIBROOT)/$(shell cd "$(WINSDK_LIBROOT)" && ls -d */ | tail -n 1)
MINGW_INCPATH  = $(subst \,/,$(MSYS_HOME))/mingw64/x86_64-w64-mingw32/include
MINGW_LIBPATH  = $(subst \,/,$(MSYS_HOME))/mingw64/x86_64-w64-mingw32/lib
ICX_LIBPATH    = $(subst \,/,$(ONEAPI_ROOT))/compiler/latest/lib
else
TARGET_EXT  =
PSEP        = :
CC          = g++
CL          = cl
CLANG       = clang
CP          = cp
ECHO        = echo
FIND        = find
ICX         = icx
LLC         = llc
LLVM_CONFIG = llvm-config
MKDIR       = mkdir
RM          = rm
TEST        = test
TOUCH       = touch
endif
