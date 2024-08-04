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

set _DEBUG_LABEL=[%_BASENAME%]
set _ERROR_LABEL=Error:
set _WARNING_LABEL=Warning:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_TARGET_OBJ_DIR=%_TARGET_DIR%\obj"

if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" ( set _ARCH=x64
) else ( set _ARCH=x86
)
if not exist "%LLVM_HOME%\bin\clang++.exe" (
    echo %_ERROR_LABEL% LLVM installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CLANG_CMD=%LLVM_HOME%\bin\clang++.exe"

if not exist "%MSYS_HOME%\usr\bin\g++.exe" (
    echo %_ERROR_LABEL% MSYS2 installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CXX_CMD=%MSYS_HOME%\usr\bin\g++.exe"

if not exist "%ONEAPI_ROOT%\compiler\latest\bin\icx.exe" (
    echo %_ERROR_LABEL% oneAPI installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_ICX_CMD=%ONEAPI_ROOT%\compiler\latest\bin\icx.exe"

@rem use newer PowerShell version if available
where /q pwsh.exe
if %ERRORLEVEL%==0 ( set _PWSH_CMD=pwsh.exe
) else ( set _PWSH_CMD=powershell.exe
)
goto :eof

@rem input parameter: %*
@rem output parameters: _CLEAN, _COMPILE, _RUN, _DEBUG, _TOOLSET, _VERBOSE
:args
set _CLEAN=0
set _COMPILE=0
set _CXX_STD=c++17
set _HELP=0
set _RUN=0
set _TOOLSET=gcc
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
    if "%__ARG%"=="-clang" ( set _TOOLSET=clang
    )else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-gcc" ( set _TOOLSET=gcc
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-icx" ( set _TOOLSET=icx
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

for /f %%i in ("%~dp0.") do set _PROJECT_NAME=%%~ni
set "_TARGET=%_TARGET_DIR%\%_PROJECT_NAME%.exe"

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _CXX_STD=%_CXX_STD% _TOOLSET=%_TOOLSET% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _RUN=%_RUN% 1>&2
    echo %_DEBUG_LABEL% Variables  : "LLVM_HOME=%LLVM_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSVS_HOME=%MSVS_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSVS_CMAKE_HOME=%MSVS_CMAKE_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSVS_MSBUILD_HOME=%MSVS_MSBUILD_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "MSYS_HOME=%MSYS_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "ONEAPI_ROOT=%ONEAPI_ROOT%" 1>&2
)
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -clang      use Clang toolset instead of GCC
echo     -debug      print commands executed by this script
echo     -gcc        use GCC toolset ^(default^)
echo     -icx        use oneAPI toolset instead of GCC
echo     -msvc       use MSVC toolset instead of GCC
echo     -verbose    print progress messages
echo.
echo   Subcommands:
echo     clean       delete generated files
echo     compile     generate executable
echo     help        print this help message
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
if not exist "%_TARGET_OBJ_DIR%" mkdir "%_TARGET_OBJ_DIR%"

call :action_required "%_TARGET%" "%_SOURCE_DIR%\main\cpp\*.cpp" "%_SOURCE_DIR%\main\cpp\*.h"
if %_ACTION_REQUIRED%==0 goto :eof

if %_TOOLSET%==clang ( set __TOOLSET_NAME=Clang
) else if %_TOOLSET%==gcc ( set __TOOLSET_NAME=GCC
) else if %_TOOLSET%==icx ( set __TOOLSET_NAME=oneAPI
) else ( set __TOOLSET_NAME=MSVC
)
if %_VERBOSE%==1 echo Toolset: %__TOOLSET_NAME% 1>&2

call :compile_%_TOOLSET%

@rem save _EXITCODE value into parent environment
endlocal & set _EXITCODE=%_EXITCODE%
goto :eof

:compile_clang
set "__PTHREADS_INCPATH=..\pthreads-win32\include"
set "__PTHREADS_LIBPATH=..\pthreads-win32\lib\%_ARCH%"
set __PTHREADS_LIBNAME=pthreadVC2

set __CLANG_FLAGS=-g --std=%_CXX_STD% -O0 -D_TIMESPEC_DEFINED
set __CLANG_FLAGS=%__CLANG_FLAGS% -I"%__PTHREADS_INCPATH%" -l%__PTHREADS_LIBNAME%
set __CLANG_FLAGS=%__CLANG_FLAGS% -Wall -Wno-unused-variable
set __CLANG_FLAGS=%__CLANG_FLAGS% -L"%__PTHREADS_LIBPATH%" -o "%_TARGET%"

set __SOURCE_FILES=
set __N=0
for /f "delims=" %%f in ('dir /b /s "%_SOURCE_DIR%\main\cpp\*.cpp"') do (
    set __SOURCE_FILES=!__SOURCE_FILES! "%%f"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No C++ source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% C++ source file
) else ( set __N_FILES=%__N% C++ source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CLANG_CMD%" %__CLANG_FLAGS% %__SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directoy "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_CLANG_CMD%" %__CLANG_FLAGS% %__SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directoy "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__DLL_FILE=..\pthreads-win32\dll\%_ARCH%\%__PTHREADS_LIBNAME%.dll"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% copy /y "%__DLL_FILE%" "%_TARGET_DIR%\" 1^>NUL 1>&2
) else if %_VERBOSE%==1 ( echo Copy file "%__PTHREADS_LIBNAME%.dll" to directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
copy /y "%__DLL_FILE%" "%_TARGET_DIR%\" 1>NUL
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to copy file "%__PTHREADS_LIBNAME%.dll" to directoy "!_TARGET_DIR:%_ROOT_DIR%=!"
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_gcc
set "__PTHREADS_INCPATH=..\pthreads-win32\include"
set "__PTHREADS_LIBPATH=..\pthreads-win32\lib\%_ARCH%"
set __PTHREADS_LIBNAME=pthreadVC2

set __CXX_FLAGS=-g --std=%_CXX_STD% -O0 -o "%_TARGET%" -I"%__PTHREADS_INCPATH%"
set __CXX_FLAGS=%__CXX_FLAGS% -L"%__PTHREADS_LIBPATH%" -l%__PTHREADS_LIBNAME%
set __CXX_FLAGS=%__CXX_FLAGS% -Wall -Wno-unused-variable -Wno-unused-but-set-variable

set __LINK_FLAGS=-Xlinker -L"%__PTHREADS_LIBPATH%" -l%__PTHREADS_LIBNAME%

set __SOURCE_FILES=
set __N=0
for /f "delims=" %%f in ('dir /b /s "%_SOURCE_DIR%\main\cpp\*.cpp"') do (
    set __SOURCE_FILES=!__SOURCE_FILES! "%%f"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No C++ source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% C++ source file
) else ( set __N_FILES=%__N% C++ source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CXX_CMD%" %__CXX_FLAGS% %__SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_CXX_CMD%" %__CXX_FLAGS% %__SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_icx
set "__PTHREADS_INCPATH=..\pthreads-win32\include"
set "__PTHREADS_LIBPATH=..\pthreads-win32\lib\%_ARCH%"
set __PTHREADS_LIBNAME=pthreadVC2

set "__ONEAPI_LIBPATH=%ONEAPI_ROOT%\compiler\latest\lib"

set __ICX_FLAGS=-nologo -Qstd=%_CXX_STD% -D_TIMESPEC_DEFINED
set __ICX_FLAGS=%__ICX_FLAGS% -Wall -Wno-unused-variable -Wno-unused-but-set-variable
set __ICX_FLAGS=%__ICX_FLAGS% -I"%__PTHREADS_INCPATH%" -o "%_TARGET%"

set __LINK_FLAGS=-link -libpath:"%__ONEAPI_LIBPATH%"
set __LINK_FLAGS=%__LINK_FLAGS% -libpath:"%__PTHREADS_LIBPATH%" "%__PTHREADS_LIBNAME%.lib"

set __SOURCE_FILES=
set __N=0
for /f "delims=" %%f in ('dir /b /s "%_SOURCE_DIR%\main\cpp\*.cpp"') do (
    set __SOURCE_FILES=!__SOURCE_FILES! "%%f"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No C++ source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% C++ source file
) else ( set __N_FILES=%__N% C++ source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_ICX_CMD%" %__ICX_FLAGS% %__SOURCE_FILES% %__LINK_FLAGS% 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directoy "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_ICX_CMD%" %__ICX_FLAGS% %__SOURCE_FILES% %__LINK_FLAGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directoy "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem we either copy the library dependency or alter the PATH variable at execution time
set "__DLL_FILE=..\pthreads-win32\dll\%_ARCH%\%__PTHREADS_LIBNAME%.dll"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% copy /y "%__DLL_FILE%" "%_TARGET_DIR%\" 1^>NUL 1>&2
) else if %_VERBOSE%==1 ( echo Copy file "%__PTHREADS_LIBNAME%.dll" to directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
copy /y "%__DLL_FILE%" "%_TARGET_DIR%\" 1>NUL
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to copy file "%__PTHREADS_LIBNAME%.dll" to directoy "!_TARGET_DIR:%_ROOT_DIR%=!"
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_msvc
if not exist "%MSVC_HOME%\bin\host%_ARCH%\%_ARCH%\cl.exe" (
    echo %_ERROR_LABEL% Microsoft C++ compiler not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__MSVC_CMD=%MSVC_HOME%\bin\host%_ARCH%\%_ARCH%\cl.exe"

set "__MSVC_INCPATH=%MSVC_HOME%\include"
set "__MSVC_LIBPATH=%MSVC_HOME%\lib\%_ARCH%"
for /f "delims=" %%f in ('dir /ad /b "%WINSDK_HOME%\include\*"') do (
    set "__WINSDK_INCPATH=%WINSDK_HOME%\include\%%f"
)
for /f "delims=" %%f in ('dir /ad /b "%WINSDK_HOME%\lib\*"') do (
    set "__WINSDK_LIBPATH=%WINSDK_HOME%\lib\%%f"
)
set __PTHREADS_INCPATH=..\pthreads-win32\include
set __PTHREADS_LIBPATH=..\pthreads-win32\lib\%_ARCH%
set __PTHREADS_LIBNAME=pthreadVC2

set __MSVC_FLAGS=/nologo /std:%_CXX_STD% /EHsc /D_TIMESPEC_DEFINED
set __MSVC_FLAGS=%__MSVC_FLAGS% /I"%__MSVC_INCPATH%"
set __MSVC_FLAGS=%__MSVC_FLAGS% /I"%__WINSDK_INCPATH%\ucrt"
set __MSVC_FLAGS=%__MSVC_FLAGS% /I"%__WINSDK_INCPATH%\um"
set __MSVC_FLAGS=%__MSVC_FLAGS% /I"%__PTHREADS_INCPATH%"
set __MSVC_FLAGS=%__MSVC_FLAGS% /Fo"%_TARGET_OBJ_DIR%/" /Fe"%_TARGET%"

set __LINK_FLAGS=-link -libpath:"%__MSVC_LIBPATH%"
set __LINK_FLAGS=%__LINK_FLAGS% -libpath:"%__WINSDK_LIBPATH%\ucrt\%_ARCH%"
set __LINK_FLAGS=%__LINK_FLAGS% -libpath:"%__WINSDK_LIBPATH%\um\%_ARCH%"
set __LINK_FLAGS=%__LINK_FLAGS% -libpath:"%__PTHREADS_LIBPATH%" "%__PTHREADS_LIBNAME%.lib"

set __SOURCE_FILES=
set __N=0
for /f "delims=" %%f in ('dir /b /s "%_SOURCE_DIR%\main\cpp\*.cpp"') do (
    set __SOURCE_FILES=!__SOURCE_FILES! "%%f"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No C++ source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% C++ source file
) else ( set __N_FILES=%__N% C++ source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%__MSVC_CMD%" %__MSVC_FLAGS% %__SOURCE_FILES% %__LINK_FLAGS% 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directoy "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%__MSVC_CMD%" %__MSVC_FLAGS% %__SOURCE_FILES% %__LINK_FLAGS% 1>NUL
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directoy "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__DLL_FILE=..\pthreads-win32\dll\%_ARCH%\%__PTHREADS_LIBNAME%.dll"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% copy /y "%__DLL_FILE%" "%_TARGET_DIR%\" 1^>NUL 1>&2
) else if %_VERBOSE%==1 ( echo Copy file "%__PTHREADS_LIBNAME%.dll" to directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
copy /y "%__DLL_FILE%" "%_TARGET_DIR%\" 1>NUL
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to copy file "%__PTHREADS_LIBNAME%.dll" to directoy "!_TARGET_DIR:%_ROOT_DIR%=!"
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: 1=target file 2,3,..=path (wildcards accepted)
@rem output parameter: _ACTION_REQUIRED
:action_required
set "__TARGET_FILE=%~1"

set __PATH_ARRAY=
set __PATH_ARRAY1=
:action_path
shift
set "__PATH=%~1"
if not defined __PATH goto action_next
set __PATH_ARRAY=%__PATH_ARRAY%,'%__PATH%'
set __PATH_ARRAY1=%__PATH_ARRAY1%,'!__PATH:%_ROOT_DIR%=!'
goto action_path

:action_next
set __TARGET_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "gci -recurse -path %__PATH_ARRAY:~1% -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _ACTION_REQUIRED=%_NEWER%
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% %__TARGET_TIMESTAMP% Target : '%__TARGET_FILE%' 1>&2
    echo %_DEBUG_LABEL% %__SOURCE_TIMESTAMP% Sources: %__PATH_ARRAY:~1% 1>&2
    echo %_DEBUG_LABEL% _ACTION_REQUIRED=%_ACTION_REQUIRED% 1>&2
) else if %_VERBOSE%==1 if %_ACTION_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No action required ^(%__PATH_ARRAY1:~1%^) 1>&2
)
goto :eof

@rem output parameter: _NEWER
:newer
set __TIMESTAMP1=%~1
set __TIMESTAMP2=%~2

set __DATE1=%__TIMESTAMP1:~0,8%
set __TIME1=%__TIMESTAMP1:~-6%

set __DATE2=%__TIMESTAMP2:~0,8%
set __TIME2=%__TIMESTAMP2:~-6%

if %__DATE1% gtr %__DATE2% ( set _NEWER=1
) else if %__DATE1% lss %__DATE2% ( set _NEWER=0
) else if %__TIME1% gtr %__TIME2% ( set _NEWER=1
) else ( set _NEWER=0
)
goto :eof

:run
if not exist "%_TARGET%" (
    echo %_ERROR_LABEL% Target file "!_TARGET:%_ROOT_DIR%=!" not found 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem set __TARGET_ARGS=--block

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_TARGET%" 1>&2
) else if %_VERBOSE%==1 ( echo Execute "!_TARGET:%_ROOT_DIR%=!" 1>&2
)
call "%_TARGET%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute "!_TARGET:%_ROOT_DIR%=!" 1>&2
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
