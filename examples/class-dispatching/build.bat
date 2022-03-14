@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
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
if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile
    if not !_EXITCODE!==0 goto end
)
if %_DUMP%==1 (
    call :dump
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    call :run
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

set "__CMAKE_LIST_FILE=%_ROOT_DIR%CMakeLists.txt"
if not exist "%__CMAKE_LIST_FILE%" (
    echo %_ERROR_LABEL% File CMakeLists.txt not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set _PROJ_NAME=main
for /f "tokens=1,2,* delims=( " %%f in ('findstr /b project "%__CMAKE_LIST_FILE%" 2^>NUL') do set "_PROJ_NAME=%%g"
set _PROJ_CONFIG=Release
set _PROJ_PLATFORM=x64

set "_TARGET_DIR=%_ROOT_DIR%build"
set "_TARGET_EXE_DIR=%_TARGET_DIR%\%_PROJ_CONFIG%"

if not exist "%MSVS_CMAKE_HOME%\bin\cmake.exe" (
    echo %_ERROR_LABEL% Microsoft CMake installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MS_CMAKE_CMD=%MSVS_CMAKE_HOME%\bin\cmake.exe"

if not exist "%MSYS_HOME%\usr\bin\make.exe" (
    echo %_ERROR_LABEL% MSYS2 installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAKE_CMD=%MSYS_HOME%\usr\bin\make.exe"

if not exist "%DOXYGEN_HOME%\bin\doxygen.exe" (
    echo %_ERROR_LABEL% Doxygen installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_DOXYGEN_CMD=%DOXYGEN_HOME%\bin\doxygen.exe"

if not exist "%MSVS_MSBUILD_HOME%\bin\MSBuild.exe" (
    echo %_ERROR_LABEL% MS Visual Studio installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MSBUILD_CMD=%MSVS_MSBUILD_HOME%\bin\MSBuild.exe"

set _PELOOK_CMD=pelook.exe
goto :eof

@rem input parameter: %*
@rem output parameters: _CLEAN, _COMPILE, _RUN, _DEBUG, _TOOLSET, _VERBOSE
:args
set _CLEAN=0
set _COMPILE=0
set _CXX_STD=c++17
set _DUMP=0
set _HELP=0
set _RUN=0
set _TOOLSET=msvc
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-cl" ( set _TOOLSET=msvc
    ) else if "%__ARG%"=="-clang" ( set _TOOLSET=clang
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-gcc" ( set _TOOLSET=gcc
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-msvc" ( set _TOOLSET=msvc
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if "%__ARG%"=="dump" ( set _COMPILE=1& set _DUMP=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
set _STDOUT_REDIRECT=1^>NUL
if %_DEBUG%==1 set _STDOUT_REDIRECT=1^>CON

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _CXX_STD=%_CXX_STD% _TOOLSET=%_TOOLSET% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DUMP=%_DUMP% _RUN=%_RUN% 1>&2
    echo %_DEBUG_LABEL% Variables  : "LLVM_HOME=%LLVM_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSVS_HOME=%MSVS_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSVS_CMAKE_HOME=%MSVS_CMAKE_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSVS_MSBUILD_HOME=%MSVS_MSBUILD_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSYS_HOME=%MSYS_HOME%" 1>&2
)
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -cl         use MSVC/MSBuild toolset ^(default^)
echo     -clang      use Clang/GNU Make toolset instead of MSVC/MSBuild
echo     -debug      show commands executed by this script
echo     -gcc        use GCC/GNU Make toolset instead of MSVC/MSBuild
echo     -msvc       use MSVC/MSBuild toolset ^(alias for option -cl^)
echo     -verbose    display progress messages
echo.
echo   Subcommands:
echo     clean       delete generated files
echo     compile     generate executable
echo     dump        dump PE/COFF infos for generated executable
echo     help        display this help message
echo     run         run the generated executable
goto :eof

:clean
call :rmdir "%_TARGET_DIR%"
goto :eof

@rem input parameter: %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
setlocal
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

if %_TOOLSET%==clang ( set __TOOLSET_NAME=Clang/GNU Make
) else if %_TOOLSET%==gcc ( set __TOOLSET_NAME=GCC/GNU Make
) else ( set __TOOLSET_NAME=MSVC/MSBuild
)
if %_VERBOSE%==1 echo Toolset: %__TOOLSET_NAME%, Project: %_PROJ_NAME% 1>&2

call :compile_%_TOOLSET%
endlocal
goto :eof

:compile_clang
set "CC=%LLVM_HOME%\bin\clang.exe"
set "CXX=%LLVM_HOME%\bin\clang++.exe"
set "MAKE=%MSYS_HOME%\usr\bin\make.exe"
set "RC=%MSYS_HOME%\mingw64\bin\windres.exe"

set "__CMAKE_CMD=%CMAKE_HOME%\bin\cmake.exe"
set __CMAKE_OPTS=-G "Unix Makefiles"

pushd "%_TARGET_DIR%"
if %_DEBUG%==1 echo %_DEBUG_LABEL% Current directory is: "%CD%" 1>&2

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %__CMAKE_CMD% %__CMAKE_OPTS% .. 1>&2
) else if %_VERBOSE%==1 ( echo Generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%__CMAKE_CMD%" %__CMAKE_OPTS% .. %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MAKE_CMD%" %_MAKE_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate executable "%_PROJ_NAME%.exe" 1>&2
)
call "%_MAKE_CMD%" %_MAKE_OPTS% %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate executable "%_PROJ_NAME%.exe" 1>&2
    set _EXITCODE=1
    goto :eof
)
popd
goto :eof

:compile_gcc
set "CC=%MSYS_HOME%\mingw64\bin\gcc.exe"
set "CXX=%MSYS_HOME%\mingw64\bin\g++.exe"
set "MAKE=%MSYS_HOME%\usr\bin\make.exe"
set "RC=%MSYS_HOME%\mingw64\bin\windres.exe"

set "__CMAKE_CMD=%CMAKE_HOME%\bin\cmake.exe"
set __CMAKE_OPTS=-G "Unix Makefiles"

pushd "%_TARGET_DIR%"
if %_DEBUG%==1 echo %_DEBUG_LABEL% Current directory is: "%CD%" 1>&2

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%__CMAKE_CMD%" %__CMAKE_OPTS% .. 1>&2
) else if %_VERBOSE%==1 ( echo Generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%__CMAKE_CMD%" %__CMAKE_OPTS% .. %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set __MAKE_OPTS=

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MAKE_CMD%" %__MAKE_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate executable "%_PROJ_NAME%.exe" 1>&2
)
call "%_MAKE_CMD%" %__MAKE_OPTS% %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate executable "%_PROJ_NAME%.exe" 1>&2
    set _EXITCODE=1
    goto :eof
)
popd
goto :eof

:compile_msvc
set __MS_CMAKE_OPTS=-Thost=%_PROJ_PLATFORM% -A %_PROJ_PLATFORM% -Wdeprecated

if %_VERBOSE%==1 echo Configuration: %_PROJ_CONFIG%, Platform: %_PROJ_PLATFORM% 1>&2

pushd "%_TARGET_DIR%"
if %_DEBUG%==1 echo %_DEBUG_LABEL% Current directory is: "%CD%" 1>&2

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MS_CMAKE_CMD%" %__MS_CMAKE_OPTS% .. 1>&2
) else if %_VERBOSE%==1 ( echo Generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_MS_CMAKE_CMD%" %__MS_CMAKE_OPTS% .. %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set __MSBUILD_OPTS=/nologo /p:Configuration=%_PROJ_CONFIG% /p:Platform="%_PROJ_PLATFORM%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MSBUILD_CMD%" %__MSBUILD_OPTS% "%_PROJ_NAME%.sln" 1>&2
) else if %_VERBOSE%==1 ( echo Generate executable "%_PROJ_NAME%.exe" 1>&2
)
call "%_MSBUILD_CMD%" %__MSBUILD_OPTS% "%_PROJ_NAME%.sln" %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate executable "%_PROJ_NAME%.exe" 1>&2
    set _EXITCODE=1
    goto :eof
)
popd
goto :eof

:dump
if not %_TOOLSET%==msvc ( set "__TARGET_DIR=%_TARGET_DIR%"
) else ( set "__TARGET_DIR=%_TARGET_DIR%\%_PROJ_CONFIG%"
)
set "__EXE_FILE=%__TARGET_DIR%\%_PROJ_NAME%.exe"
if not exist "%__EXE_FILE%" (
    echo %_ERROR_LABEL% Executable "%_PROJ_NAME%.exe" not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __PELOOK_OPTS=

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_PELOOK_CMD%" %__PELOOK_OPTS% !__EXE_FILE:%_ROOT_DIR%=! 1>&2
) else if %_VERBOSE%==1 ( echo Dump PE/COFF infos for executable "!__EXE_FILE:%_ROOT_DIR%=!" 1>&2
)
echo executable:           !__EXE_FILE:%_ROOT_DIR%=!
call "%_PELOOK_CMD%" %__PELOOK_OPTS% "%__EXE_FILE%" | findstr "signature machine linkver modules"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to dump executable "!__EXE_FILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:run
if not %_TOOLSET%==msvc ( set "__TARGET_DIR=%_TARGET_DIR%"
) else ( set "__TARGET_DIR=%_TARGET_DIR%\%_PROJ_CONFIG%"
)
set "__EXE_FILE=%__TARGET_DIR%\%_PROJ_NAME%.exe"
if not exist "%__EXE_FILE%" (
    echo %_ERROR_LABEL% Executable "!__EXE_FILE:%_ROOT_DIR%=!" not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%__EXE_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Execute "!__EXE_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%__EXE_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute "!__EXE_FILE:%_ROOT_DIR%=!" ^(status: %ERRORLEVEL%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
