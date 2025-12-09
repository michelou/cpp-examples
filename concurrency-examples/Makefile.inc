ifeq ($(OS),Windows_NT)
ifndef BCC_HOME
$(error Variable BCC_HOME is not set)
endif
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
LLVM_PATH   = $(subst \,/,$(LLVM_HOME))
MSYS_PATH   = $(subst \,/,$(MSYS_HOME))
#
BCC         = $(subst \,/,$(BCC_HOME))/bin/bcc32c.exe
CC          = $(MSYS_PATH)/usr/bin/g++.exe
CL          = $(subst \,/,$(MSVC_HOME))/bin/Host$(ARCH)/$(ARCH)/cl.exe
CLANG       = $(LLVM_PATH)/bin/clang.exe
CP          = $(MSYS_PATH)/usr/bin/cp.exe
CPPCHECK    = $(MSYS_PATH)/mingw64/bin/cppcheck.exe
ECHO        = $(MSYS_PATH)/usr/bin/echo.exe
FIND        = $(MSYS_PATH)/usr/bin/find.exe
ICX         = $(subst \,/,$(ONEAPI_ROOT))/compiler/latest/bin/icx.exe
LLC         = $(LLVM_PATH)/bin/llc.exe
LLVM_CONFIG = $(LLVM_PATH)/bin/llvm-config.exe
MKDIR       = $(MSYS_PATH)/usr/bin/mkdir.exe
RM          = $(MSYS_PATH)/usr/bin/rm.exe
TEST        = $(MSYS_PATH)/usr/bin/test.exe
TOUCH       = $(MSYS_PATH)/usr/bin/touch.exe
#
MSVC_INCPATH   = $(subst \,/,$(MSVC_HOME))/include
MSVC_LIBPATH   = $(subst \,/,$(MSVC_HOME))/lib/$(ARCH)
WINSDK_INCROOT = $(subst \,/,$(WINSDK_HOME))/include
WINSDK_INCPATH = $(WINSDK_INCROOT)/$(shell cd "$(WINSDK_INCROOT)" && ls -d [0-9]*/ | tail -n 1)
WINSDK_LIBROOT = $(subst \,/,$(WINSDK_HOME))/lib
WINSDK_LIBPATH = $(WINSDK_LIBROOT)/$(shell cd "$(WINSDK_LIBROOT)" && ls -d [0-9]*/ | tail -n 1)
MINGW_XXX      = $(MSYS_PATH)/mingw64/include
MINGW_INCPATH  = $(MSYS_PATH)/mingw64/x86_64-w64-mingw32/include
MINGW_LIBPATH  = $(MSYS_PATH)/mingw64/x86_64-w64-mingw32/lib
ICX_LIBPATH    = $(subst \,/,$(ONEAPI_ROOT))/compiler/latest/lib
else
TARGET_EXT  =
PSEP        = :
BCC         = 
CC          = g++
CL          = cl
CLANG       = clang
CP          = cp
CPPCHECK    = cppcheck
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
