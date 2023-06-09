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

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_TARGET_DIR=%_ROOT_DIR%build"
set "_TARGET_DOCS_DIR=%_TARGET_DIR%\docs"

if not exist "%MSVS_CMAKE_HOME%\bin\cmake.exe" (
    echo %_ERROR_LABEL% Microsoft CMake installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MSVS_CMAKE_CMD=%MSVS_CMAKE_HOME%\bin\cmake.exe"

set _CPPCHECK_CMD=
if exist "%MSYS_HOME%\mingw64\bin\cppcheck.exe" (
    set "_CPPCHECK_CMD=%MSYS_HOME%\mingw64\bin\cppcheck.exe"
)
if not exist "%DOXYGEN_HOME%\bin\doxygen.exe" (
    echo %_ERROR_LABEL% Doxygen installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_DOXYGEN_CMD=%DOXYGEN_HOME%\bin\doxygen.exe"

if not exist "%MSYS_HOME%\usr\bin\make.exe" (
    echo %_ERROR_LABEL% MSYS2 installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAKE_CMD=%MSYS_HOME%\usr\bin\make.exe"

if not exist "%MSYS_HOME%\mingw64\bin\gcc.exe" (
    echo %_ERROR_LABEL% MSYS installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GCC_CMD=%MSYS_HOME%\mingw64\bin\gcc.exe"
set "_GXX_CMD=%MSYS_HOME%\mingw64\bin\g++.exe"
set "_WINDRES_CMD=%MSYS_HOME%\mingw64\bin\windres.exe"

if not exist "%LLVM_HOME%\bin\clang.exe" (
    echo %_ERROR_LABEL% LLVM installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CLANG_CMD=%LLVM_HOME%\bin\clang.exe"
set "_CLANGXX_CMD=%LLVM_HOME%\bin\clang++.exe"

if not exist "%ONEAPI_ROOT%\compiler\latest\windows\bin\icx.exe" (
    echo %_ERROR_LABEL% Intel oneAPI installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_ICX_CMD=%ONEAPI_ROOT%\compiler\latest\windows\bin\icx.exe"

if not exist "%MSVS_MSBUILD_HOME%\bin\MSBuild.exe" (
    echo %_ERROR_LABEL% MSBuild installation directory not found 1>&2
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
set _DOC=0
set _DOC_OPEN=0
set _DUMP=0
set _HELP=0
set _LINT=0
set _RUN=0
set _TIMER=0
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
    ) else if "%__ARG%"=="-icx" ( set _TOOLSET=icx
    ) else if "%__ARG%"=="-msvc" ( set _TOOLSET=msvc
    ) else if "%__ARG%"=="-open" ( set _DOC_OPEN=1
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
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
    ) else if "%__ARG%"=="doc" ( set _DOC=1
    ) else if "%__ARG%"=="dump" ( set _COMPILE=1& set _DUMP=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="lint" ( set _LINT=1
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

if %_LINT%==1 if not defined _CPPCHECK_CMD (
    echo %_WARNING_LABEL% Cppcheck installation not found 1>&2
    set _LINT=0
)
if %_TOOLSET%==clang ( set _TOOLSET_NAME=LLVM/Clang
) else if %_TOOLSET%==gcc ( set _TOOLSET_NAME=MSYS/GCC
) else if %_TOOLSET%==icx ( set _TOOLSET_NAME=OpenAPI ICX
) else ( set _TOOLSET_NAME=MSBuild/MSVC
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _CXX_STD=%_CXX_STD% _TIMER=%_TIMER% _TOOLSET=%_TOOLSET% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DOC=%_DOC% _DUMP=%_DUMP% _LINT=%_LINT% _RUN=%_RUN% 1>&2
    echo %_DEBUG_LABEL% Variables  : "CPPCHECK_HOME=%CPPCHECK_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "DOXYGEN_HOME=%DOXYGEN_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "GIT_HOME=%GIT_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "LLVM_HOME=%LLVM_HOME%" ^(clang^) 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSVC_HOME=%MSVC_HOME%" ^(cl^) 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSYS_HOME=%MSYS_HOME%" ^(gcc^) 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
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
echo     %__BEG_O%-cl%__END%         use MSVC/MSBuild toolset (default)
echo     %__BEG_O%-clang%__END%      use Clang/GNU Make toolset instead of MSVC/MSBuild
echo     %__BEG_O%-debug%__END%      display commands executed by this script
echo     %__BEG_O%-gcc%__END%        use GCC/GNU Make toolset instead of MSVC/MSBuild
echo     %__BEG_O%-icx%__END%        use oneAPI ICX toolset instead of MSVC/MSBuild
echo     %__BEG_O%-msvc%__END%       use MSVC/MSBuild toolset ^(alias for option %__BEG_O%-cl%__END%^)
echo     %__BEG_O%-verbose%__END%    display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%       delete generated files
echo     %__BEG_O%compile%__END%     generate executable
echo     %__BEG_O%doc%__END%         generate HTML documentation with %__BEG_N%Doxygen%__END%
echo     %__BEG_O%dump%__END%        dump PE/COFF infos for generated executable
echo     %__BEG_O%help%__END%        display this help message
echo     %__BEG_O%lint%__END%        analyze C++ source files with %__BEG_N%Cppcheck%__END%
echo     %__BEG_O%run%__END%         run the generated executable "%__BEG_O%%_PROJ_NAME%.exe%__END%"
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
if %_TOOLSET%==gcc ( set __CPPCHECK_OPTS=--template=gcc --std=c++14
) else if %_TOOLSET%==msvc ( set __CPPCHECK_OPTS=--template=vs --std=c++17
) else ( set __CPPCHECK_OPTS=--std=c++14
)
set __CPPCHECK_OPTS=--platform=win64 %__CPPCHECK_OPTS%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CPPCHECK_CMD%" %__CPPCHECK_OPTS% "%_SOURCE_DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Analyze C++ source files in directory "!_SOURCE_DIR=%_ROOT_DIR%=!" 1>&2
)
call "%_CPPCHECK_CMD%" %__CPPCHECK_OPTS% "%_SOURCE_DIR%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Found errors while analyzing C++ source files in directory "!_SOURCE_DIR=%_ROOT_DIR%=!" 1>&2
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
) else if %_TOOLSET%==icx ( set __TOOLSET_NAME=oneAPI ICX
) else ( set __TOOLSET_NAME=MSVC/MSBuild
)
if %_VERBOSE%==1 echo Toolset: %__TOOLSET_NAME%, Project: %_PROJ_NAME% 1>&2

call :compile_%_TOOLSET%
endlocal
goto :eof

:compile_bcc
set "CC=%_BCC32C_CMD%"
set "CXX=%_BCC32C_CMD%"
set "MAKE=%_MAKE_CMD%"
set "RC=%_WINDRES_CMD%"

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

:compile_gcc
set "CC=%_GCC_CMD%"
set "CXX=%_GXX_CMD%"
set "MAKE=%_MAKE_CMD%"
set "RC=%_WINDRES_CMD%"

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

:compile_icx
set __ICX_FLAGS=-nologo -Qstd=%_CXX_STD% -O2 -Fe"%_TARGET_DIR%\%_PROJ_NAME%.exe"
if %_DEBUG%==1 set __ICX_FLAGS=-debug:all %__ICX_FLAGS%

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
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" ( set __ARCH=x64
) else ( set __ARCH=x86
)
set __LIB_VERSION=
for /f %%i in ('dir /ad /b "%WINSDK_HOME%\Lib\10*" 2^>NUL') do set __LIB_VERSION=%%i
if not defined __LIB_VERSION (
    echo %_ERROR_LABEL% Windows SDK library path not found 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem alternative: define environment variable "LIB" with the 5 library paths listed below.
set __LINK_FLAGS=-link
set __LINK_FLAGS=%__LINK_FLAGS% -libpath:"%MSVC_HOME%lib\%__ARCH%"
set __LINK_FLAGS=%__LINK_FLAGS% -libpath:"%WINSDK_HOME%\Lib\%__LIB_VERSION%\um\%__ARCH%"
set __LINK_FLAGS=%__LINK_FLAGS% -libpath:"%WINSDK_HOME%\Lib\%__LIB_VERSION%\ucrt\%__ARCH%"
set __LINK_FLAGS=%__LINK_FLAGS% -libpath:"%ONEAPI_ROOT%compiler\latest\windows\compiler\lib"
set __LINK_FLAGS=%__LINK_FLAGS% -libpath:"%ONEAPI_ROOT%compiler\latest\windows\compiler\lib\intel64"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_ICX_CMD%" %__ICX_FLAGS% %__SOURCE_FILES% %__LINK_FLAGS% 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directoy "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_ICX_CMD%" %__ICX_FLAGS% %__SOURCE_FILES% %__LINK_FLAGS% %_STDERR_REDIRECT%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directoy "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_msvc
set __CMAKE_OPTS=-Thost=%_PROJ_PLATFORM% -A %_PROJ_PLATFORM% -Wdeprecated

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
if not %_TOOLSET%==msvc ( set "__TARGET_DIR=%_TARGET_DIR%\%_PROJ_CONFIG%"
) else if %_TOOLSET%==icx ( set "__TARGET_DIR=%_TARGET_DIR%"
) else ( set "__TARGET_DIR=%_TARGET_DIR%"
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
if %_TOOLSET%==msvc ( set "__TARGET_DIR=%_TARGET_DIR%\%_PROJ_CONFIG%"
) else ( set "__TARGET_DIR=%_TARGET_DIR%"
)
set "__EXE_FILE=%__TARGET_DIR%\%_PROJ_NAME%.exe"
if not exist "%__EXE_FILE%" (
    echo %_ERROR_LABEL% Executable "%_PROJ_NAME%.exe" not found 1>&2
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

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total execution time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal