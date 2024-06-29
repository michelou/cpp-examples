@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)

set _BAZEL_PATH=
set _GIT_PATH=
set _MSVS_PATH=
set _MSYS_PATH=
@rem set _ONEAPI_PATH=
set _VSCODE_PATH=

call :bazel
if not %_EXITCODE%==0 goto end

call :bcc
if not %_EXITCODE%==0 goto end

call :doxygen
if not %_EXITCODE%==0 goto end

call :cmake
if not %_EXITCODE%==0 goto end

call :llvm 15
if not %_EXITCODE%==0 goto end

call :msys
if not %_EXITCODE%==0 goto end

call :msvs
if not %_EXITCODE%==0 goto end

call :oneapi
if not %_EXITCODE%==0 goto end

call :orangec
if not %_EXITCODE%==0 goto end

call :winsdk 10
if not %_EXITCODE%==0 goto end

call :git
if not %_EXITCODE%==0 goto end

call :vscode
if not %_EXITCODE%==0 (
    @rem optional
    set _EXITCODE=0
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m

@rem we define _RESET in last position to avoid crazy console output with type command
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m
set _RESET=[0m
goto :eof

@rem input parameter: %*
@rem output parameters: _BASH, _HELP, _VERBOSE
:args
set _BASH=0
set _HELP=0
set _VERBOSE=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-bash" ( set _BASH=1
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto args_loop
:args_done
call :drive_name "%_ROOT_DIR%"
if not %_EXITCODE%==0 goto :eof
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _BASH=%_BASH% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _HELP=%_HELP% 1>&2
    echo %_DEBUG_LABEL% Variables  : _DRIVE_NAME=%_DRIVE_NAME% 1>&2
)
goto :eof

@rem input parameter: %1: path to be substituted
@rem output parameter: _DRIVE_NAME (2 characters: letter + ':')
:drive_name
set "__GIVEN_PATH=%~1"
@rem remove trailing path separator if present
if "%__GIVEN_PATH:~-1,1%"=="\" set "__GIVEN_PATH=%__GIVEN_PATH:~0,-1%"

@rem https://serverfault.com/questions/62578/how-to-get-a-list-of-drive-letters-on-a-system-through-a-windows-shell-bat-cmd
set __DRIVE_NAMES=F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:
for /f %%i in ('wmic logicaldisk get deviceid ^| findstr :') do (
    set "__DRIVE_NAMES=!__DRIVE_NAMES:%%i=!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(WMIC^) 1>&2
if not defined __DRIVE_NAMES (
    echo %_ERROR_LABEL% No more free drive name 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "tokens=1,2,*" %%f in ('subst') do (
    set "__SUBST_DRIVE=%%f"
    set "__SUBST_DRIVE=!__SUBST_DRIVE:~0,2!"
    set "__SUBST_PATH=%%h"
    if "!__SUBST_DRIVE!"=="!__GIVEN_PATH:~0,2!" (
        set _DRIVE_NAME=!__SUBST_DRIVE:~0,2!
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    ) else if "!__SUBST_PATH!"=="!__GIVEN_PATH!" (
        set "_DRIVE_NAME=!__SUBST_DRIVE!"
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    )
)
for /f "tokens=1,2,*" %%i in ('subst') do (
    set __USED=%%i
    call :drive_names "!__USED:~0,2!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(SUBST^) 1>&2

set "_DRIVE_NAME=!__DRIVE_NAMES:~0,2!"
if /i "%_DRIVE_NAME%"=="%__GIVEN_PATH:~0,2%" goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% subst "%_DRIVE_NAME%" "%__GIVEN_PATH%" 1>&2
) else if %_VERBOSE%==1 ( echo Assign drive %_DRIVE_NAME% to path "!__GIVEN_PATH:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
)
subst "%_DRIVE_NAME%" "%__GIVEN_PATH%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to assign drive %_DRIVE_NAME% to path "!__GIVEN_PATH:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=Used drive name
@rem output parameter: __DRIVE_NAMES
:drive_names
set "__USED_NAME=%~1"
set "__DRIVE_NAMES=!__DRIVE_NAMES:%__USED_NAME%=!"
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-bash%__END%       start Git bash shell instead of Windows command prompt
echo     %__BEG_O%-debug%__END%      print commands executed by this script
echo     %__BEG_O%-verbose%__END%    print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        print this help message
goto :eof

@rem output parameters: _BAZEL_HOME, _BAZEL_PATH
:bazel
set _BAZEL_HOME=
set _BAZEL_PATH=

set __BAZEL_CMD=
for /f "delims=" %%f in ('where bazel.exe 2^>NUL') do set "__BAZEL_CMD=%%f"
if defined __BAZEL_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Bazel executable found in PATH 1>&2
    for /f "delims=" %%i in ("%__BAZEL_CMD%") do set "_BAZEL_HOME=%%~dpi"
    @rem keep _BAZEL_PATH undefined since executable already in path
    goto :eof
) else if defined BAZEL_HOME (
    set "_BAZEL_HOME=%BAZEL_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable BAZEL_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\bazel\" ( set "_BAZEL_HOME=!__PATH!\bazel"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\bazel-*" 2^>NUL') do set "_BAZEL_HOME=!__PATH!\%%f"
        if not defined _BAZEL_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\bazel-*" 2^>NUL') do set "_BAZEL_HOME=!__PATH!\%%f"
        )
    )
    if defined _BAZEL_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Bazel installation directory "!_BAZEL_HOME!" 1>&2
    )
)
if not exist "%_BAZEL_HOME%\bazel.exe" (
    echo %_ERROR_LABEL% Bazel executable not found ^("%_BAZEL_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_BAZEL_PATH=;%_BAZEL_HOME%"
goto :eof

@rem output parameter: _BCC_HOME
:bcc
set _BCC_HOME=

set __BCC_CMD=
for /f "delims=" %%f in ('where bcc32c.exe 2^>NUL') do set __BCC_CMD=%%f
if defined __BCC_CMD (
    for /f "delims=" %%i in ("%__BCC_CMD%") do set "__BCC_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__BCC_BIN_DIR!.") do set "_BCC_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of BCC executable found in PATH 1>&2
) else if defined BCC_HOME (
    set "_BCC_HOME=%BCC_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable BCC_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\bcc\" ( set "_BCC_HOME=!__PATH!\bcc"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\bcc-*" 2^>NUL') do set "_BCC_HOME=!__PATH!\%%f"
        if not defined _BCC_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\bcc-*" 2^>NUL') do set "_BCC_HOME=!__PATH!\%%f"
        )
    )
    if defined _BCC_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default BCC installation directory "!_BCC_HOME!" 1>&2
    )
)
if not exist "%_BCC_HOME%\bin\bcc32c.exe" (
    echo %_WARNING_LABEL% BCC executable not found ^("%_BCC_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _DOXYGEN_HOME
:doxygen
set _DOXYGEN_HOME=

set __DOXYGEN_CMD=
for /f "delims=" %%f in ('where doxygen.exe 2^>NUL') do set __DOXYGEN_CMD=%%f
if defined __DOXYGEN_CMD (
    for /f "delims=" %%i in ("%__DOXYGEN_CMD%") do set "_DOXYGEN_HOME=%%~dpi"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Doxygen executable found in PATH 1>&2
) else if defined DOXY_HOME (
    set "_DOXYGEN_HOME=%DOXY_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable DOXY_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\doxygen\" ( set "_DOXYGEN_HOME=!__PATH!\doxygen"
    ) else (
       for /f "delims=" %%f in ('dir /ad /b "!__PATH!\doxygen-*" 2^>NUL') do set "_DOXYGEN_HOME=!__PATH!\%%f"
        if not defined _DOXYGEN_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\doxygen-*" 2^>NUL') do set "_DOXYGEN_HOME=!__PATH!\%%f"
        )
    )
    if defined _DOXYGEN_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Doxygen installation directory "!_DOXYGEN_HOME!" 1>&2
    )
)
if not exist "%_DOXYGEN_HOME%\doxygen.exe" (
    echo %_ERROR_LABEL% Doxygen executable not found ^("%_DOXYGEN_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _CMAKE_HOME
:cmake
set _CMAKE_HOME=
@rem set _CMAKE_PATH=

set __CMAKE_CMD=
for /f "delims=" %%f in ('where cmake.exe 2^>NUL') do set "__CMAKE_CMD=%%f"
if defined __CMAKE_CMD (
    for /f "delims=" %%i in ("%__CMAKE_CMD%") do set "__CMAKE_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__CMAKE_BIN_DIR!.") do set "_CMAKE_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of CMake executable found in PATH 1>&2
    @rem keep _CMAKE_PATH undefined since executable already in path
    goto :eof
) else if defined CMAKE_HOME (
    set "_CMAKE_HOME=%CMAKE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable CMAKE_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\cmake\" ( set "_CMAKE_HOME=!__PATH!\cmake"
    ) else (
       for /f "delims=" %%f in ('dir /ad /b "!__PATH!\cmake-*" 2^>NUL') do set "_CMAKE_HOME=!__PATH!\%%f"
        if not defined _CMAKE_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\cmake-*" 2^>NUL') do set "_CMAKE_HOME=!__PATH!\%%f"
        )
    )
    if defined _CMAKE_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default CMake installation directory "!_CMAKE_HOME!" 1>&2
    )
)
if not exist "%_CMAKE_HOME%\bin\cmake.exe" (
    echo %_ERROR_LABEL% cmake executable not found ^("%_CMAKE_HOME%"^) 1>&2
    set _CMAKE_HOME=
    set _EXITCODE=1
    goto :eof
)
@rem set "_CMAKE_PATH=;%_CMAKE_HOME%\bin"
goto :eof

@rem output parameters: _MSYS_HOME, _MSYS_PATH
:msys
set _MSYS_HOME=
set _MSYS_PATH=

set __MAKE_CMD=
for /f "delims=" %%f in ('where make.exe 2^>NUL') do set "__MAKE_CMD=%%f"
if defined __MAKE_CMD (
    for /f "delims=" %%i in ("%__MAKE_CMD%") do set "__MAKE_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__MAKE_BIN_DIR!.") do set "_MSYS_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of GNU Make executable found in PATH 1>&2
    @rem keep _MSYS_PATH undefined since executable already in path
    goto :eof
) else if defined MSYS_HOME (
    set "_MSYS_HOME=%MSYS_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MSYS_HOME 1>&2
) else (
    set "__PATH=%ProgramFiles%"
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\msys*" 2^>NUL') do set "_MSYS_HOME=!__PATH!\%%f"
    if not defined _MSYS_HOME (
        set __PATH=C:\opt
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\msys*" 2^>NUL') do set "_MSYS_HOME=!__PATH!\%%f"
    )
)
if not exist "%_MSYS_HOME%\usr\bin\make.exe" (
    echo %_ERROR_LABEL% GNU Make executable not found ^("%_MSYS_HOME%"^) 1>&2
    set _MSYS_HOME=
    set _EXITCODE=1
    goto :eof
)
@rem 1st path -> (make.exe, python.exe), 2nd path -> gcc.exe
set "_MSYS_PATH=;%_MSYS_HOME%\usr\bin;%_MSYS_HOME%\mingw64\bin"
goto :eof

@rem input parameter: %1=LLVM major version
@rem output parameter: _LLVM_HOME
:llvm
set _LLVM_HOME=

set __DISTRO=llvm-%~1
set __CLANG_CMD=
for /f "delims=" %%f in ('where clang.exe 2^>NUL') do set "__CLANG_CMD=%%f"
if defined __CLANG_CMD (
    for /f "delims=" %%i in ("%__CLANG_CMD%") do set "__LLVM_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__LLVM_BIN_DIR!.") do set "_LLVM_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Clang executable found in PATH 1>&2
) else if defined LLVM_HOME (
    set "_LLVM_HOME=%LLVM_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable LLVM_HOME 1>&2
) else (
    set "__PATH=%ProgramFiles%"
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\%__DISTRO%*" 2^>NUL') do set "_LLVM_HOME=!__PATH!\%%f"
    if not defined _LLVM_HOME (
        set __PATH=C:\opt
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\%__DISTRO%*" 2^>NUL') do set "_LLVM_HOME=!__PATH!\%%f"
    )
)
if not exist "%_LLVM_HOME%\bin\clang.exe" (
    echo %_ERROR_LABEL% clang executable not found ^("%_LLVM_HOME%"^) 1>&2
    set _LLVM_HOME=
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameters: _MSVC_HOME, _MSVS_MSBUILD_HOME, _MSVS_CMAKE_CMD, _MSVS_HOME, _MSVS_PATH
@rem Visual Studio 2019
:msvs
set _MSVC_HOME=
set _MSVS_MSBUILD_HOME=
set _MSVS_CMAKE_HOME=
set _MSVS_HOME=
set _MSVS_PATH=

for /f "delims=" %%f in ('"%_ROOT_DIR%bin\vswhere.exe" -property installationPath 2^>NUL') do (
    set "_MSVS_HOME=%%f"
)
if not exist "%_MSVS_HOME%\" (
    echo %_WARNING_LABEL% Could not find installation directory for Microsoft Visual Studio 2019 1>&2
    echo        ^(see https://github.com/oracle/graal/blob/master/compiler/README.md^) 1>&2
    @rem set _EXITCODE=1
    goto :eof
)
call :subst_path "%_MSVS_HOME%"
if not %_EXITCODE%==0 goto :eof
set "_MSVS_HOME=%_SUBST_PATH%"

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set __MSVC_ARCH=\Hostx64\x64
    set __MSBUILD_ARCH=\amd64
) else (
    set __MSVC_ARCH=\Hostx86\x86
    set __MSBUILD_ARCH=
)
for /f "delims=" %%f in ('where /r "%_MSVS_HOME%" cl.exe ^| findstr "%__MSVC_ARCH%" 2^>NUL') do (
    set "_MSVC_HOME=%%~dpf"
    set "_MSVC_HOME=!_MSVC_HOME:bin%__MSVC_ARCH%\=!"
)
if not exist "%_MSVC_HOME%\bin%__MSVC_ARCH%\" (
    echo %_WARNING_LABEL% Could not find installation directory for MSVC compiler 1>&2
    echo        ^(see https://github.com/oracle/graal/blob/master/compiler/README.md^) 1>&2
    @rem set _EXITCODE=1
    goto :eof
)
set "_MSVS_MSBUILD_HOME=%_MSVS_HOME%\MSBuild\Current"
if not exist "%_MSVS_MSBUILD_HOME%\bin%__MSBUILD_ARCH%\MSBuild.exe" (
    echo %_ERROR_LABEL% Could not find Microsoft Build tool ^("%_MSVS_HOME%"^) 1>&2
    set _MSVS_MSBUILD_HOME=
    set _EXITCODE=1
    goto :eof
)
set "_MSVS_CMAKE_HOME=%_MSVS_HOME%\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake"
if not exist "%_MSVS_CMAKE_HOME%\bin\cmake.exe" (
    echo %_ERROR_LABEL% Could not find Microsoft CMake tool ^("%_MSVS_HOME%"^) 1>&2
    set _MSVS_CMAKE_HOME=
    set _EXITCODE=1
    goto :eof
)
set "_MSVS_PATH=;%_MSVC_HOME%\bin%__MSVC_ARCH%;%_MSVS_MSBUILD_HOME%\bin%__MSBUILD_ARCH%"
goto :eof

@rem input parameter: %1=directory path
@rem output parameter: _SUBST_PATH
:subst_path
set "_SUBST_PATH=%~1"
set __DRIVE_NAME=X:
set __ASSIGNED_PATH=
for /f "tokens=1,2,*" %%f in ('subst ^| findstr /b "%__DRIVE_NAME%" 2^>NUL') do (
    if not "%%h"=="%_SUBST_PATH%" (
        echo %_WARNING_LABEL% Drive %__DRIVE_NAME% already assigned to %%h 1>&2
        goto :eof
    )
    set "__ASSIGNED_PATH=%%h"
)
if not defined __ASSIGNED_PATH (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% subst "%__DRIVE_NAME%" "%_SUBST_PATH%" 1>&2
    subst "%__DRIVE_NAME%" "%_SUBST_PATH%"
    if not !ERRORLEVEL!==0 (
        set _EXITCODE=1
        goto :eof
    )
)
set _SUBST_PATH=%__DRIVE_NAME%
goto :eof

@rem output parameters: _ONEAPI_ROOT
:oneapi
set _ONEAPI_ROOT=

set __ICX_CMD=
for /f "delims=" %%f in ('where icx.exe 2^>NUL') do set "__ICX_CMD=%%f"
if defined __ICX_CMD (
    for /f "delims=" %%i in ("%__ICX_CMD%") do set "__ICX_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__ICX_BIN_DIR!.") do set "_ONEAPI_ROOT=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Intel DPC++ compiler executable found in PATH 1>&2
) else if defined ONEAPI_ROOT (
    set "_ONEAPI_ROOT=%ONEAPI_ROOT%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable ONEAPI_ROOT 1>&2
) else (
    set "_ONEAPI_ROOT=%ProgramFiles(x86)%\Intel\oneAPI"
)
if not exist "%_ONEAPI_ROOT%\compiler\latest\bin\icx.exe" (
    echo %_WARNING_LABEL% Intel DPC++ compiler executable not found ^("%_ONEAPI_ROOT%"^) 1>&2
    set _ONEAPI_ROOT=
    @rem set _EXITCODE=1
    goto :eof
)
@rem set "_ONEAPI_PATH=%_ONEAPI_ROOT%\compiler\latest\bin"
goto :eof

@rem output parameters: _ORANGEC_HOME
:orangec
set _ORANGEC_HOME=

set __OCC_CMD=
for /f "delims=" %%f in ('where occ.exe 2^>NUL') do set "__OCC_CMD=%%f"
if defined __OCC_CMD (
    for /f "delims=" %%i in ("%__OCC_CMD%") do set "__OCC_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__OCC_BIN_DIR!.") do set "_ORANGEC_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of OrangeC compiler executable found in PATH 1>&2
) else if defined ORANGEC_HOME (
    set "_ORANGEC_HOME=%ORANGEC_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable ORANGEC_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\orangec\" ( set "_ORANGEC_HOME=!__PATH!\orangec"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\orangec*" 2^>NUL') do set "_ORANGEC_HOME=!__PATH!\%%f"
        if not defined _ORANGEC_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\orangec*" 2^>NUL') do set "_ORANGEC_HOME=!__PATH!\%%f"
        )
    )
    if defined _ORANGEC_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default OrangeC installation directory "!_ORANGEC_HOME!" 1>&2
    )
)
if not exist "%_ORANGEC_HOME%\bin\occ.exe" (
    echo %_WARNING_LABEL% OrangeC compiler executable not found ^("%_ORANGEC_HOME%"^) 1>&2
    set _ORANGEC_HOME=
    @rem set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=Windows SDK version
@rem output parameter: _WINSDK_HOME
:winsdk
set "__VERSION=%~1"

if not exist "%ProgramFiles(x86)%\Windows Kits\%__VERSION%" (
    echo %_WARNING_LABEL% Windows SDK %__VERSION% installation not found 1>&2
    @rem set _EXITCODE=1
    goto :eof
)
set "_WINSDK_HOME=%ProgramFiles(x86)%\Windows Kits\%__VERSION%"
goto :eof

@rem output parameters: _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f "delims=" %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    for /f "delims=" %%i in ("%__GIT_CMD%") do set "__GIT_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__GIT_BIN_DIR!\.") do set "_GIT_HOME=%%~dpf"
    @rem Executable git.exe is present both in bin\ and \mingw64\bin\
    if not "!_GIT_HOME:mingw=!"=="!_GIT_HOME!" (
        for /f "delims=" %%f in ("!_GIT_HOME!\.") do set "_GIT_HOME=%%~dpf"
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    @rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "_GIT_HOME=!__PATH!\Git"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
    if defined _GIT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Git installation directory "!_GIT_HOME!" 1>&2
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^("%_GIT_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\usr\bin;%_GIT_HOME%\mingw64\bin"
goto :eof

@rem output parameters: _VSCODE_HOME, _VSCODE_PATH
:vscode
set _VSCODE_HOME=
set _VSCODE_PATH=

set __CODE_CMD=
for /f "delims=" %%f in ('where code.exe 2^>NUL') do set "__CODE_CMD=%%f"
if defined __CODE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of VSCode executable found in PATH 1>&2
    @rem keep _VSCODE_PATH undefined since executable already in path
    goto :eof
) else if defined VSCODE_HOME (
    set "_VSCODE_HOME=%VSCODE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable VSCODE_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\VSCode\" ( set "_VSCODE_HOME=!__PATH!\VSCode"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\VSCode-1*" 2^>NUL') do set "_VSCODE_HOME=!__PATH!\%%f"
        if not defined _VSCODE_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\VSCode-1*" 2^>NUL') do set "_VSCODE_HOME=!__PATH!\%%f"
        )
    )
    if defined _VSCODE_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default VSCode installation directory "!_VSCODE_HOME!" 1>&2
    )
)
if not exist "%_VSCODE_HOME%\code.exe" (
    echo %_WARNING_LABEL% VSCode executable not found ^("%_VSCODE_HOME%"^) 1>&2
    if exist "%_VSCODE_HOME%\Code - Insiders.exe" (
        echo %_WARNING_LABEL% It looks like you've installed an Insider version of VSCode 1>&2
    )
    set _EXITCODE=1
    goto :eof
)
set "_VSCODE_PATH=;%_VSCODE_HOME%"
goto :eof

@rem input parameter: %1=verbose flag
:print_env
set __VERBOSE=%~1
set __VERSIONS_LINE1=
set __VERSIONS_LINE2=
set __VERSIONS_LINE3=
set __WHERE_ARGS=
where /q "%BAZEL_HOME%:bazel.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('"%BAZEL_HOME%\bazel.exe" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% bazel %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%BAZEL_HOME%:bazel.exe"
)
where /q "%BCC_HOME%\bin:bcc32c.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%BCC_HOME%\bin\bcc32c.exe" --version 2^>^&1 ^| findstr C++') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% bcc32c %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%BCC_HOME%\bin:bcc32c.exe"
)
where /q "%LLVM_HOME%\bin:clang.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%LLVM_HOME%\bin\clang.exe" --version 2^>^&1 ^| findstr version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% clang %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%LLVM_HOME%\bin:clang.exe"
)
where /q "%MSYS_HOME%\mingw64\bin:gcc.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-7,*" %%i in ('"%MSYS_HOME%\mingw64\bin\gcc.exe" --version 2^>^&1 ^| findstr gcc') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% gcc %%o,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MSYS_HOME%\mingw64\bin:gcc.exe"
)
where /q "%ONEAPI_ROOT%\compiler\latest\windows\bin:icx.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-11,12,*" %%a in ('"%ONEAPI_ROOT%\compiler\latest\windows\bin\icx.exe" /v 2^>^&1 ^| findstr Version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% icx %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%ONEAPI_ROOT%\compiler\latest\windows\bin:icx.exe"
)
where /q "%ORANGEC_HOME%\bin:occ.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,*" %%i in ('"%ORANGEC_HOME%\bin\occ.exe" --version 2^>^&1 ^| findstr Version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% occ %%l"
    set __WHERE_ARGS=%__WHERE_ARGS% "%ORANGEC_HOME%\bin:occ.exe"
)
where /q "%CMAKE_HOME%\bin:cmake.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%CMAKE_HOME%\bin\cmake.exe" --version ^| findstr version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% cmake %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%CMAKE_HOME%\bin:cmake.exe"
)
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" ( set __CL_BIN_DIR=Bin\Hostx64\x64
) else ( set __CL_BIN_DIR=Bin\Hostx86\x86
)
where /q "%MSVC_HOME%\%__CL_BIN_DIR%:cl.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-6,7,*" %%i in ('"%MSVC_HOME%\%__CL_BIN_DIR%\cl.exe" 2^>^&1 ^| findstr /i version') do (
        @rem Trick: version string contains the special character "&nbsp;" !
        set "__VERSION_STR=%%n"
        setlocal enabledelayedexpansion
        set "__VERSIONS_LINE2=%__VERSIONS_LINE2% !__VERSION_STR:version=cl!,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%MSVC_HOME%\%__CL_BIN_DIR%:cl.exe"
)
where /q "%MSYS_HOME%\mingw64\bin:cppcheck.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('"%MSYS_HOME%\mingw64\bin\cppcheck.exe" --version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% cppcheck %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MSYS_HOME%\mingw64\bin:cppcheck.exe"
)
where /q "%DOXYGEN_HOME%:doxygen.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('"%DOXYGEN_HOME%\doxygen.exe" -v 2^>^&1') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% doxygen %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%DOXYGEN_HOME%:doxygen.exe"
)
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" ( set __BIN_DIR=Bin\amd64
) else ( set __BIN_DIR=Bin
)
where /q "%MSVS_HOME%\MSBuild\Current\%__BIN_DIR%:msbuild.exe"
if %ERRORLEVEL%==0 (
    for /f %%i in ('"%MSVS_HOME%\MSBuild\Current\%__BIN_DIR%\msbuild.exe" -version ^| findstr /b [0-9]') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% msbuild %%i"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MSVS_HOME%\MSBuild\Current\%__BIN_DIR%:msbuild.exe"
)
where /q "%GIT_HOME%\bin:git.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%GIT_HOME%\bin\git.exe" --version') do (
        for /f "delims=. tokens=1,2,3,*" %%a in ("%%k") do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% git %%a.%%b.%%c,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:git.exe"
)
where /q "%GIT_HOME%\usr\bin:diff.exe"
if %ERRORLEVEL%==0 (
   for /f "tokens=1-3,*" %%i in ('"%GIT_HOME%\usr\bin\diff.exe" --version ^| findstr diff') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% diff %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\usr\bin:diff.exe"
)
where /q "%GIT_HOME%\bin:bash.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,4,*" %%i in ('"%GIT_HOME%\bin\bash.exe" --version ^| findstr bash') do (
        set "__VERSION=%%l"
        set "__VERSIONS_LINE3=%__VERSIONS_LINE3% bash !__VERSION:-release=!"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:bash.exe"
)
echo Tool versions:
echo   %__VERSIONS_LINE1%
echo   %__VERSIONS_LINE2%
echo   %__VERSIONS_LINE3%
if %__VERBOSE%==1 if defined __WHERE_ARGS (
    @rem if %_DEBUG%==1 echo %_DEBUG_LABEL% where %__WHERE_ARGS%
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do (
        set "__LINE=%%p"
        setlocal enabledelayedexpansion
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
    echo Environment variables: 1>&2
    if defined BAZEL_HOME echo    "BAZEL_HOME=%BAZEL_HOME%" 1>&2
    if defined BCC_HOME echo    "BCC_HOME=%BCC_HOME%" 1>&2
    if defined CMAKE_HOME echo    "CMAKE_HOME=%CMAKE_HOME%" 1>&2
    if defined DOXYGEN_HOME echo    "DOXYGEN_HOME=%DOXYGEN_HOME%" 1>&2
    if defined GIT_HOME echo    "GIT_HOME=%GIT_HOME%" 1>&2
    if defined LLVM_HOME echo    "LLVM_HOME=%LLVM_HOME%" 1>&2
    if defined MSVS_CMAKE_HOME echo    "MSVS_CMAKE_HOME=%MSVS_CMAKE_HOME%" 1>&2
    if defined MSVS_MSBUILD_HOME echo    "MSVS_MSBUILD_HOME=%MSVS_MSBUILD_HOME%" 1>&2
    if defined MSVS_HOME echo    "MSVS_HOME=%MSVS_HOME%" 1>&2
    if defined MSYS_HOME echo    "MSYS_HOME=%MSYS_HOME%" 1>&2
    if defined ONEAPI_ROOT echo    "ONEAPI_ROOT=%ONEAPI_ROOT%" 1>&2
    if defined ORANGEC_HOME echo    "ORANGEC_HOME=%ORANGEC_HOME%" 1>&2
    if defined VSCODE_HOME echo    "VSCODE_HOME=%VSCODE_HOME%" 1>&2
    if defined WINSDK_HOME echo    "WINSDK_HOME=%WINSDK_HOME%" 1>&2
    echo Path associations: 1>&2
    for /f "delims=" %%i in ('subst') do (
        set "__LINE=%%i"
        setlocal enabledelayedexpansion
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined BAZEL_HOME set "BAZEL_HOME=%_BAZEL_HOME%"
        if not defined BCC_HOME set "BCC_HOME=%_BCC_HOME%"
        if not defined CMAKE_HOME set "CMAKE_HOME=%_CMAKE_HOME%"
        if not defined DOXYGEN_HOME set "DOXYGEN_HOME=%_DOXYGEN_HOME%"
        if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
        if not defined LLVM_HOME set "LLVM_HOME=%_LLVM_HOME%"
        if not defined MSVS_CMAKE_HOME set "MSVS_CMAKE_HOME=%_MSVS_CMAKE_HOME%"
        if not defined MSVS_MSBUILD_HOME set "MSVS_MSBUILD_HOME=%_MSVS_MSBUILD_HOME%"
        if not defined MSVS_HOME set "MSVS_HOME=%_MSVS_HOME%"
        if not defined MSVC_HOME set "MSVC_HOME=%_MSVC_HOME%"
        if not defined MSYS_HOME set "MSYS_HOME=%_MSYS_HOME%"
        if not defined ONEAPI_ROOT set "ONEAPI_ROOT=%_ONEAPI_ROOT%"
        if not defined ORANGEC_HOME set "ORANGEC_HOME=%_ORANGEC_HOME%"
        if not defined VSCODE_HOME set "VSCODE_HOME=%VSCODE_HOME%"
        if not defined WINSDK_HOME set "WINSDK_HOME=%_WINSDK_HOME%"
        @rem We prepend %_GIT_HOME%\bin to hide C:\Windows\System32\bash.exe
        set "PATH=%_GIT_HOME%\bin;%PATH%%_BAZEL_PATH%%_MSYS_PATH%%_MSVS_PATH%%_GIT_PATH%%_VSCODE_PATH%;%_ROOT_DIR%bin"
        call :print_env %_VERBOSE%
        if not "%CD:~0,2%"=="%_DRIVE_NAME%" (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% cd /d %_DRIVE_NAME% 1>&2
            cd /d %_DRIVE_NAME%
        )
        if %_BASH%==1 (
            @rem see https://conemu.github.io/en/GitForWindows.html
            if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_HOME%\usr\bin\bash.exe --login 1>&2
            cmd.exe /c "%_GIT_HOME%\usr\bin\bash.exe --login"
        )
        if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
        for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
    )
)
