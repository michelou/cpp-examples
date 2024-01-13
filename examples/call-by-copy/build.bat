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
if %_LINT%==1 (
    call :lint
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile
    if not !_EXITCODE!==0 goto end
)
if %_DOC%==1 (
    call :doc
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
set _STDOUT_REDIRECT=1^>NUL
if %_DEBUG%==1 set _STDOUT_REDIRECT=1^>CON

set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

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
set "_EXE_NAME=%_PROJ_NAME%.exe"

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_SOURCE_MAIN_DIR=%_SOURCE_DIR%\main\cpp"
set "_TARGET_DIR=%_ROOT_DIR%build"
set "_TARGET_DOCS_DIR=%_TARGET_DIR%\docs"

set _CMAKE_CMD=
if exist "%CMAKE_HOME%\bin\cmake.exe" (
    set "_CMAKE_CMD=%CMAKE_HOME%\bin\cmake.exe"
)
set _MSVS_CMAKE_CMD=
if exist "%MSVS_CMAKE_HOME%\bin\cmake.exe" (
    set "_MSVS_CMAKE_CMD=%MSVS_CMAKE_HOME%\bin\cmake.exe"
)
set _CPPCHECK_CMD=
if exist "%MSYS_HOME%\mingw64\bin\cppcheck.exe" (
    set "_CPPCHECK_CMD=%MSYS_HOME%\mingw64\bin\cppcheck.exe"
)
if not exist "%MSYS_HOME%\usr\bin\make.exe" (
    echo %_ERROR_LABEL% GNU Make executable not found ^(MSYS installation directory^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAKE_CMD=%MSYS_HOME%\usr\bin\make.exe"

if not exist "%DOXYGEN_HOME%\doxygen.exe" (
    echo %_ERROR_LABEL% Doxygen installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_DOXYGEN_CMD=%DOXYGEN_HOME%\doxygen.exe"

if not exist "%MSYS_HOME%\usr\bin\gcc.exe" (
    echo %_ERROR_LABEL% GCC package not installed 1>&2
    echo %_ERROR_LABEL% ^(use command "pacman.exe -S gcc"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GCC_CMD=%MSYS_HOME%\usr\bin\gcc.exe"
set "_GXX_CMD=%MSYS_HOME%\usr\bin\g++.exe"

if not exist "%MSYS_HOME%\usr\bin\windres.exe" (
    echo %_ERROR_LABEL% GNU windres executable not found ^(MSYS installation directory^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_WINDRES_CMD=%MSYS_HOME%\usr\bin\windres.exe"

if not exist "%LLVM_HOME%\bin\clang.exe" (
    echo %_ERROR_LABEL% LLVM installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CLANG_CMD=%LLVM_HOME%\bin\clang.exe"
set "_CLANGXX_CMD=%LLVM_HOME%\bin\clang++.exe"

set _ICX_CMD=
if exist "%ONEAPI_ROOT%\compiler\latest\bin\icx.exe" (
    set "_ICX_CMD=%ONEAPI_ROOT%\compiler\latest\bin\icx.exe"
)
set _BCC32C_CMD=
if exist "%BCC_HOME%\bin\bcc32c.exe" (
    set "_BCC32C_CMD=%BCC_HOME%\bin\bcc32c.exe"
)
set _OCC_CMD=
if exist "%ORANGEC_HOME%\bin\occ.exe" (
    set "_OCC_CMD=%ORANGEC_HOME%\bin\occ.exe"
)
set _MSBUILD_CMD=
if exist "%MSVS_MSBUILD_HOME%\bin\MSBuild.exe" (
    set "_MSBUILD_CMD=%MSVS_MSBUILD_HOME%\bin\MSBuild.exe"
)
set _PELOOK_CMD=pelook.exe
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _RESET=[0m
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m

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
goto :eof

@rem input parameter: %*
@rem output parameters: _CLEAN, _COMPILE, _RUN, _DEBUG, _TOOLSET, _VERBOSE
:args
set _CLEAN=0
set _COMPILE=0
set _CXX_STD=c++17
set _DOC=0
set _DOC_OPEN=0
set _DUMP=0
set _HELP=0
set _LINT=0
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
    if "%__ARG%"=="-bcc" ( set _TOOLSET=bcc
    ) else if "%__ARG%"=="-cl" ( set _TOOLSET=msvc
    ) else if "%__ARG%"=="-clang" ( set _TOOLSET=clang
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-gcc" ( set _TOOLSET=gcc
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-icx" ( set _TOOLSET=icx
    ) else if "%__ARG%"=="-msvc" ( set _TOOLSET=msvc
    ) else if "%__ARG%"=="-occ" ( set _TOOLSET=occ
    ) else if "%__ARG%"=="-open" ( set _DOC_OPEN=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if "%__ARG%"=="doc" ( set _DOC=1
    ) else if "%__ARG%"=="dump" ( set _COMPILE=1& set _DUMP=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="lint" ( set _LINT=1
    ) else if "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
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

if %_LINT%==1 if not defined _CPPCHECK_CMD (
    echo %_WARNING_LABEL% Cppcheck installation not found 1>&2
    set _LINT=0
)
if %_TOOLSET%==bcc (
    if not defined _CMAKE_CMD (
        echo %_ERROR_LABEL% CMake installation not found 1>&2
        set _EXITCODE=1
        goto :eof
    )
    if not defined _BCC32C_CMD (
        echo %_WARNING_LABEL% BCC installation not found ^(use MSVC instead^) 1>&2
        set _TOOLSET=msvc
    )
)
if %_TOOLSET%==gcc (
    if not defined _CMAKE_CMD (
        echo %_ERROR_LABEL% CMake installation not found 1>&2
        set _EXITCODE=1
        goto :eof
    )
    if not defined _GCC_CMD (
        echo %_WARNING_LABEL% GCC installation not found ^(use MSVC instead^) 1>&2
        set _TOOLSET=msvc
    )
)
if %_TOOLSET%==icx (
    if not defined _CMAKE_CMD (
        echo %_ERROR_LABEL% CMake installation not found 1>&2
        set _EXITCODE=1
        goto :eof
    )
    if not defined _ICX_CMD (
        echo %_WARNING_LABEL% OpenAPI installation not found ^(use MSVC instead^) 1>&2
        set _TOOLSET=msvc
    )
)
if %_TOOLSET%==msvc (
    if not defined _MSVS_CMAKE_CMD (
        echo %_ERROR_LABEL% MSVS installation not found 1>&2
        set _EXITCODE=1
        goto :eof
    )
    if not defined _MSBUILD_CMD (
        echo %_ERROR_LABEL% MSVS installation not found 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
if %_TOOLSET%==occ if not defined _OCC_CMD (
    echo %_WARNING_LABEL% OrangeC installation not found ^(use MSVC instead^) 1>&2
    set _TOOLSET=msvc
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _CXX_STD=%_CXX_STD% _TOOLSET=%_TOOLSET% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DOC=%_DOC% _DUMP=%_DUMP% _LINT=%_LINT% _RUN=%_RUN% 1>&2
    if defined _BCC32C_CMD echo %_DEBUG_LABEL% Variables  : "BCC_HOME=%BCC_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "CMAKE_HOME=%CMAKE_HOME%" 1>&2
    if defined _DOXYGEN_CMD echo %_DEBUG_LABEL% Variables  : "DOXYGEN_HOME=%DOXYGEN_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "GIT_HOME=%GIT_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "LLVM_HOME=%LLVM_HOME%" ^(clang^) 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSVS_HOME=%MSVS_HOME%" ^(cl^) 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSVS_CMAKE_HOME=%MSVS_CMAKE_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSVS_MSBUILD_HOME=%MSVS_MSBUILD_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSYS_HOME=%MSYS_HOME%" ^(gcc^) 1>&2
    if defined ONEAPI_ROOT echo %_DEBUG_LABEL% Variables  : "ONEAPI_ROOT=%ONEAPI_ROOT%" ^(icx^) 1>&2
    if defined ORANGEC_HOME echo %_DEBUG_LABEL% Variables  : "ORANGEC_HOME=%ORANGEC_HOME%" ^(occ^) 1>&2
)
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
echo     %__BEG_O%-bcc%__END%        use BCC/GNU Make toolset instead of MSVC/MSBuild
echo     %__BEG_O%-cl%__END%         use MSVC/MSBuild toolset ^(default^)
echo     %__BEG_O%-clang%__END%      use Clang/GNU Make toolset instead of MSVC/MSBuild
echo     %__BEG_O%-debug%__END%      print commands executed by this script
echo     %__BEG_O%-gcc%__END%        use GCC/GNU Make toolset instead of MSVC/MSBuild
echo     %__BEG_O%-icx%__END%        use Intel oneAPI C++ toolset instead of MSVC/MSBuild
echo     %__BEG_O%-msvc%__END%       use MSVC/MSBuild toolset ^(alias for option %__BEG_O%-cl%__END%^)
echo     %__BEG_O%-occ%__END%        use Orange C++ toolset instead of MSVC/MSBuild
echo     %__BEG_O%-open%__END%       open generated HTML documentation ^(subcommand %__BEG_O%doc%__END%^)
echo     %__BEG_O%-verbose%__END%    print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%       delete generated files
echo     %__BEG_O%compile%__END%     generate executable
echo     %__BEG_O%doc%__END%         generate HTML documentation with %__BEG_N%Doxygen%__END%
echo     %__BEG_O%dump%__END%        dump PE/COFF infos for generated executable
echo     %__BEG_O%help%__END%        print this help message
echo     %__BEG_O%lint%__END%        analyze C++ source files with %__BEG_N%Cppcheck%__END%
echo     %__BEG_O%run%__END%         run the generated executable "%__BEG_O%%_EXE_NAME%%__END%"
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
    echo %_ERROR_LABEL% Failed to delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:lint
@rem C++ support in GCC, MSVC and Clang:
@rem https://gcc.gnu.org/projects/cxx-status.html
@rem https://docs.microsoft.com/en-us/cpp/build/reference/std-specify-language-standard-version
@rem https://clang.llvm.org/cxx_status.html
if %_TOOLSET%==gcc ( set __CPPCHECK_OPTS=--template=gcc --std=%_CXX_STD%
) else if %_TOOLSET%==icx ( set set __CPPCHECK_OPTS=--std=%_CXX_STD%
) else if %_TOOLSET%==msvc ( set __CPPCHECK_OPTS=--template=vs --std=%_CXX_STD%
) else ( set __CPPCHECK_OPTS=--std=c++14
)
set __CPPCHECK_OPTS=--platform=win64 %__CPPCHECK_OPTS%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CPPCHECK_CMD%" %__CPPCHECK_OPTS% "%_SOURCE_MAIN_DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Analyze C++ source files in directory "!_SOURCE_MAIN_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_CPPCHECK_CMD%" %__CPPCHECK_OPTS% "%_SOURCE_MAIN_DIR%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Found errors while analyzing C++ source files in directory "!_SOURCE_MAIN_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
setlocal
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

if %_TOOLSET%==bcc ( set __TOOLSET_NAME=BCC/GNU Make
) else if %_TOOLSET%==clang ( set __TOOLSET_NAME=Clang/GNU Make
) else if %_TOOLSET%==gcc ( set __TOOLSET_NAME=GCC/GNU Make
) else if %_TOOLSET%==icx ( set __TOOLSET_NAME=Intel oneAPI C++
) else if %_TOOLSET%==occ ( set __TOOLSET_NAME=LADSoft Orange C++
) else ( set __TOOLSET_NAME=MSVC/MSBuild
)
if %_VERBOSE%==1 echo Toolset: %__TOOLSET_NAME%, Project: %_PROJ_NAME% 1>&2

call :compile_%_TOOLSET%

@rem save _EXITCODE value into parent environment
endlocal & set _EXITCODE=%_EXITCODE%
goto :eof

:compile_bcc
set "CC=%_BCC32C_CMD%"
set "CXX=%_BCC32C_CMD%"
set "MAKE=%_MAKE_CMD%"
set "RC=%_WINDRES_CMD%"

set __CMAKE_OPTS=-G "Unix Makefiles"

pushd "%_TARGET_DIR%"
if %_DEBUG%==1 echo %_DEBUG_LABEL% Current directory is: "%CD%" 1>&2

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CMAKE_CMD%" %__CMAKE_OPTS% .. 1>&2
) else if %_VERBOSE%==1 ( echo Generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_CMAKE_CMD%" %__CMAKE_OPTS% .. %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set __MAKE_OPTS=
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MAKE_CMD%" %__MAKE_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate executable "%_EXE_NAME%" 1>&2
)
call "%_MAKE_CMD%" %__MAKE_OPTS% %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate executable "%_EXE_NAME%" 1>&2
    set _EXITCODE=1
    goto :eof
)
popd
if %_DEBUG%==1 ( echo copy "%BCC_HOME%\bin\cc32*mt.dll" "%_TARGET_DIR%\" 1>&2
) else if %_VERBOSE%==1 ( echo Copy DLL file to directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
copy "%BCC_HOME%\bin\cc32*mt.dll" "%_TARGET_DIR%\" %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to copy DLL file to directory "%_TARGET_DIR%" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_clang
set "CC=%_CLANG_CMD%"
set "CXX=%_CLANGXX_CMD%"
set "MAKE=%_MAKE_CMD%"
set "RC=%_WINDRES_CMD%"

set __CMAKE_OPTS=-G "Unix Makefiles"

pushd "%_TARGET_DIR%"
if %_DEBUG%==1 echo %_DEBUG_LABEL% Current directory is: "%CD%" 1>&2

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CMAKE_CMD%" %__CMAKE_OPTS% .. 1>&2
) else if %_VERBOSE%==1 ( echo Generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_CMAKE_CMD%" %__CMAKE_OPTS% .. %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set __MAKE_OPTS=

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MAKE_CMD%" %__MAKE_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate executable "%_EXE_NAME%" 1>&2
)
call "%_MAKE_CMD%" %__MAKE_OPTS% %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate executable "%_EXE_NAME%" 1>&2
    set _EXITCODE=1
    goto :eof
)
popd
goto :eof

:compile_gcc
set "CC=%_GCC_CMD%"
set "CXX=%_GXX_CMD%"
set "MAKE=%_MAKE_CMD%"
set "RC=%_WINDRES_CMD%"

set __CMAKE_OPTS=-G "Unix Makefiles"

pushd "%_TARGET_DIR%"
if %_DEBUG%==1 echo %_DEBUG_LABEL% Current directory is: "%CD%" 1>&2

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CMAKE_CMD%" %__CMAKE_OPTS% .. 1>&2
) else if %_VERBOSE%==1 ( echo Generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_CMAKE_CMD%" %__CMAKE_OPTS% .. %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set __MAKE_OPTS=

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MAKE_CMD%" %__MAKE_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate executable "%_EXE_NAME%" 1>&2
)
call "%_MAKE_CMD%" %__MAKE_OPTS% %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate executable "%_EXE_NAME%" 1>&2
    set _EXITCODE=1
    goto :eof
)
popd
goto :eof

:compile_icx
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" ( set __ARCH=x64
) else ( set __ARCH=x86
)
set "__MSVC_LIBPATH=%MSVC_HOME%lib\%__ARCH%"
set "__ONEAPI_LIBPATH=%ONEAPI_ROOT%\compiler\latest\lib;%ONEAPI_ROOT%\compiler\latest\lib\intel64"
set __LIB_VERSION=
for /f "delims=" %%i in ('dir /ad /b "%WINSDK_HOME%\Lib\10*" 2^>NUL') do set __LIB_VERSION=%%i
if not defined __LIB_VERSION (
    echo %_ERROR_LABEL% Windows SDK library path not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__WINSDK_LIBPATH=%WINSDK_HOME%\Lib\%__LIB_VERSION%\um\%__ARCH%;%WINSDK_HOME%\Lib\%__LIB_VERSION%\ucrt\%__ARCH%"

set __ICX_FLAGS=-nologo -Qstd=%_CXX_STD% -O2 -Fe"%_TARGET_DIR%\%_EXE_NAME%"
if %_DEBUG%==1 set __ICX_FLAGS=-debug:all %__ICX_FLAGS%

set __SOURCE_FILES=
set __N=0
for /f "delims=" %%f in ('dir /b /s "%_SOURCE_MAIN_DIR%\*.cpp"') do (
    set __SOURCE_FILES=!__SOURCE_FILES! "%%f"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No C++ source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% C++ source file
) else ( set __N_FILES=%__N% C++ source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_ICX_CMD%" %__ICX_FLAGS% %__SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directoy "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
set "__LIB=%LIB%"
set "LIB=%__WINSDK_LIBPATH%;%__ONEAPI_LIBPATH%;%__MSVC_LIBPATH%"
if %_DEBUG%==1 echo %_DEBUG_LABEL% "LIB=%LIB%" 1>&2

call "%_ICX_CMD%" %__ICX_FLAGS% %__SOURCE_FILES% %_STDERR_REDIRECT%
if not %ERRORLEVEL%==0 (
    set "LIB=%__LIB%"
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directoy "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set "LIB=%__LIB%"
goto :eof

:compile_msvc
set __CMAKE_OPTS="-Thost=%_PROJ_PLATFORM%" -A %_PROJ_PLATFORM% -Wdeprecated

if %_VERBOSE%==1 echo Configuration: %_PROJ_CONFIG%, Platform: %_PROJ_PLATFORM% 1>&2

pushd "%_TARGET_DIR%"
if %_DEBUG%==1 echo %_DEBUG_LABEL% Current directory is: "%CD%" 1>&2

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MSVS_CMAKE_CMD%" %__CMAKE_OPTS% .. 1>&2
) else if %_VERBOSE%==1 ( echo Generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_MSVS_CMAKE_CMD%" %__CMAKE_OPTS% .. %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate configuration files into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set __MSBUILD_OPTS=/nologo "/p:Configuration=%_PROJ_CONFIG%" "/p:Platform=%_PROJ_PLATFORM%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MSBUILD_CMD%" %__MSBUILD_OPTS% "%_PROJ_NAME%.sln" 1>&2
) else if %_VERBOSE%==1 ( echo Generate executable "%_EXE_NAME%" 1>&2
)
call "%_MSBUILD_CMD%" %__MSBUILD_OPTS% "%_PROJ_NAME%.sln" %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to generate executable "%_EXE_NAME%" 1>&2
    set _EXITCODE=1
    goto :eof
)
popd
goto :eof

:compile_occ
set __OCC_OPTS=--nologo -std=c++14 /o"%_TARGET_DIR%\%_PROJ_NAME%.exe"

set __SOURCE_FILES=
set __N=0
for /f "delims=" %%f in ('dir /b /s "%_SOURCE_DIR%\*.cpp"') do (
    set __SOURCE_FILES=!__SOURCE_FILES! "%%f"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No C++ source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% C++ source file
) else ( set __N_FILES=%__N% C++ source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_OCC_CMD%" %__OCC_OPTS% %__SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Generate executable "%_PROJ_NAME%.exe" 1>&2
)
call "%_OCC_CMD%" %__OCC_OPTS% %__SOURCE_FILES% %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate executable "%_PROJ_NAME%.exe" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:doc
@rem must be the same as property OUTPUT_DIRECTORY in file Doxyfile
if not exist "%_TARGET_DOCS_DIR%" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% mkdir "%_TARGET_DOCS_DIR%" 1>&2
    mkdir "%_TARGET_DOCS_DIR%"
)
set "__DOXYFILE=%_ROOT_DIR%Doxyfile"
if not exist "%__DOXYFILE%" (
    echo %_ERROR_LABEL% Doxygen configuration file not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __DOXYGEN_OPTS=-s

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_DOXYGEN_CMD%" %__DOXYGEN_OPTS% "%__DOXYFILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Generate HTML documentation 1>&2
)
call "%_DOXYGEN_CMD%" %__DOXYGEN_OPTS% "%__DOXYFILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate HTML documentation 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__INDEX_FILE=%_TARGET_DOCS_DIR%\html\index.html"
if %_DOC_OPEN%==1 (
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% start "%_BASENAME%" "%__INDEX_FILE%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Open HTML documentation in default browser 1>&2
    )
    start "%_BASENAME%" "%__INDEX_FILE%"
)
goto :eof

:dump
if %_TOOLSET%==msvc ( set "__TARGET_DIR=%_TARGET_DIR%\%_PROJ_CONFIG%"
) else ( set "__TARGET_DIR=%_TARGET_DIR%"
)
set "__EXE_FILE=%__TARGET_DIR%\%_EXE_NAME%"
if not exist "%__EXE_FILE%" (
    echo %_ERROR_LABEL% Executable "%_EXE_NAME%" not found ^(%_TOOLSET%^) 1>&2
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
if %_TOOLSET%==msvc ( set "__TARGET_DIR=%_TARGET_DIR%\%_PROJ_CONFIG%"
) else ( set "__TARGET_DIR=%_TARGET_DIR%"
)
set "__EXE_FILE=%__TARGET_DIR%\%_EXE_NAME%"
if not exist "%__EXE_FILE%" (
    echo %_ERROR_LABEL% Executable "!__EXE_FILE:%_ROOT_DIR%=!" not found ^(%_TOOLSET%^) 1>&2
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
