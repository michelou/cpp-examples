#!/usr/bin/env bash
#
# Copyright (c) 2018-2023 Stéphane Micheloud
#
# Licensed under the MIT License.
#

##############################################################################
## Subroutines

getHome() {
    local source="${BASH_SOURCE[0]}"
    while [[ -h "$source" ]]; do
        local linked="$(readlink "$source")"
        local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
        source="$dir/$(basename "$linked")"
    done
    ( cd -P "$(dirname "$source")" && pwd )
}

debug() {
    local DEBUG_LABEL="[46m[DEBUG][0m"
    $DEBUG && echo "$DEBUG_LABEL $1" 1>&2
}

warning() {
    local WARNING_LABEL="[46m[WARNING][0m"
    echo "$WARNING_LABEL $1" 1>&2
}

error() {
    local ERROR_LABEL="[91mError:[0m"
    echo "$ERROR_LABEL $1" 1>&2
}

# use variables EXITCODE, TIMER_START
cleanup() {
    [[ $1 =~ ^[0-1]$ ]] && EXITCODE=$1

    if $TIMER; then
        local TIMER_END=$(date +'%s')
        local duration=$((TIMER_END - TIMER_START))
        echo "Total execution time: $(date -d @$duration +'%H:%M:%S')" 1>&2
    fi
    debug "EXITCODE=$EXITCODE"
    exit $EXITCODE
}

args() {
    [[ $# -eq 0 ]] && HELP=true && return 1

    for arg in "$@"; do
        case "$arg" in
        ## options
        -bcc)         TOOLSET=bcc ;;
        -cl)          TOOLSET=msvc ;;
        -clang)       TOOLSET=clang ;;
        -debug)       DEBUG=true ;;
        -gcc)         TOOLSET=gcc ;;
        -help)        HELP=true ;;
        -icx)         TOOLSET=icx ;;
        -msvc)        TOOLSET=msvc ;;
        -timer)       TIMER=true ;;
        -verbose)     VERBOSE=true ;;
        -*)
            error "Unknown option $arg"
            EXITCODE=1 && return 0
            ;;
        ## subcommands
        clean)   CLEAN=true ;;
        compile) COMPILE=true ;;
        help)    HELP=true ;;
        lint)    LINT=true ;;
        run)     COMPILE=true && RUN=true ;;
        *)
            error "Unknown subcommand $arg"
            EXITCODE=1 && return 0
            ;;
        esac
    done
    debug "Options    : PROJECT_CONFIG=$PROJECT_CONFIG TIMER=$TIMER TOOLSET=$TOOLSET VERBOSE=$VERBOSE"
    debug "Subcommands: CLEAN=$CLEAN COMPILE=$COMPILE HELP=$HELP RUN=$RUN"
    debug "Variables  : GIT_HOME=$GIT_HOME"
    debug "Variables  : LLVM_HOME=$LLVM_HOME"
    debug "Variables  : MSVS_HOME=$MSVS_HOME"
    debug "Variables  : MSYS_HOME=$MSYS_HOME"
    debug "Variables  : ONEAPI_ROOT=$ONEAPI_ROOT"
    # See http://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display/
    $TIMER && TIMER_START=$(date +"%s")
}

help() {
    cat << EOS
Usage: $BASENAME { <option> | <subcommand> }

  Options:
    -bcc         use BCC/GNU Make toolset instead of MSVC/MSBuild
    -cl          use MSVC/MSBuild toolset (default)
    -clang       use Clang/GNU Make toolset instead of MSVC/MSBuild
    -debug       display commands executed by this script
    -gcc         use GCC/GNU Make toolset instead of MSVC/MSBuild
    -icx         use Intel oneAPI C++ toolset instead of MSVC/MSBuild
    -msvc        use MSVC/MSBuild toolset (alias for option -cl)
    -timer       display total execution time
    -verbose     display progress messages

  Subcommands:
    clean        delete generated files
    compile      compile C++ source files
    help         display this help message
    lint         analyze C++ source files with Cppcheck
    run          execute the generated executable
EOS
}

clean() {
    if [[ -d "$TARGET_DIR" ]]; then
        if $DEBUG; then
            debug "Delete directory $TARGET_DIR"
        elif $VERBOSE; then
            echo "Delete directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
        fi
        rm -rf "$TARGET_DIR"
        [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    fi
    if [[ -f "$ROOT_DIR/CMakeCache.txt" ]]; then
        rm -f "$ROOT_DIR/CMakeCache.txt"
        [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    fi
}

lint() {
    # C++ support in GCC, MSVC and Clang:
    # https://gcc.gnu.org/projects/cxx-status.html
    # https://docs.microsoft.com/en-us/cpp/build/reference/std-specify-language-standard-version
    # https://clang.llvm.org/cxx_status.html
    case "$TOOLSET" in
    gcc)   cppcheck_opts="--template=gcc --std=c++14" ;;
    msvc)  cppcheck_opts="--template=vs --std=c++17" ;;
    *)     cppcheck_opts="=--std=c++14" ;;
    esac
    if $DEBUG; then
        debug "$CPPCHECK_CMD $CPPCHECK_OPTS$ $SOURCE_DIR" 1>&2
    elif $VERBOSE; then
        echo "Analyze C++ source files in directory ${SOURCE_DIR/$ROOT_DIR\//}" 1>&2
    fi
    eval "$CPPCHECK_CMD $cppcheck_opts $SOURCE_DIR"
    if [[ $? -ne 0 ]]; then
        error "Failed to check C++ source files"
        cleanup 1
    fi
}

compile() {
    [[ -d "$TARGET_DIR" ]] || mkdir -p "$TARGET_DIR"

    case "$TOOLSET" in
    bcc)   toolset_name="BCC/GNU Make" ;;
    clang) toolset_name="Clang/GNU Make" ;;
    gcc)   toolset_name="GCC/GNU Make" ;;
    icx)   toolset_name="Intel oneAPI C++" ;;
    *)     toolset_name="MSVC/MSBuild" ;;
    esac
    $VERBOSE && echo "Toolset: $toolset_name, Project: $PROJECT_NAME" 1>&2
    
    compile_$TOOLSET
}

compile_bcc() {
    export CC="$BCC_CMD"
    export CXX="$BCC_CMD"
    export MAKE="$MAKE_CMD"
    export RC="$WINDRES_CMD"

    local cmake_opts="-G \"Unix Makefiles\""

    pushd "$TARGET_DIE"
    $DEBUG && debug "Current directory is: $PWD" 1>&2

    if $DEBUG; then
        debug "$CMAKE_CMD $cmake_opts .."
    elif $VERBOSE; then
        echo "Generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "$CMAKE_CMD $cmake_opts .."
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to generate configuration files into directory  \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
    local make_opts=
    
    if $DEBUG; then
        debug "$MAKE_CMD $make_opts"
    elif $VERBOSE; then
        echo "Generate executable \"$PROJECT_NAME\"" 1>&2
    fi
    eval "$MAKE_CMD $make_opts"
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to geenerate executable \"$PROJECT_NAME\""
        cleanup 1
    fi
    popd
    if $DEBUG; then
        debug "cp $(mixed_path $BCC_HOME)/bin/cc32*mt.dll $TARGET_DIR/"
    elif $VERBOSE; then
        echo "Copy DLL file to directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    cp "$(mixed_path $BCC_HOME)/bin/cc32*mt.dll $TARGET_DIR/"
    if [[ $? -ne 0 ]]; then
        error "Failed to copy DLL file to directory \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
}

compile_clang() {
    export CC="$CLANG_CMD"
    export CXX="$(mixed_path $LLVM_HOME)/bin/clang++.exe"
    export MAKE="$MAKE_CMD"
    export RC="$WINDRES_CMD"

    local cmake_opts="-G \"Unix Makefiles\""

    pushd "$TARGET_DIR"
    $DEBUG && debug "Current directory is: $PWD" 1>&2

    if $DEBUG; then
        debug "$CMAKE_CMD $cmake_opts .."
    elif $VERBOSE; then
        echo "Generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "\"$CMAKE_CMD\" $cmake_opts .."
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
    local make_opts=

    if $DEBUG; then
        debug "$MAKE_CMD $make_opts"
    elif $VERBOSE; then
        echo "Generate executable \"$PROJECT_NAME.exe\"" 1>&2
    fi
    eval "$MAKE_CMD $make_opts"
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to geenerate executable \"$PROJECT_NAME.exe\""
        cleanup 1
    fi
    popd
}

compile_gcc() {
    export CC="$GCC_CMD"
    export CXX="$GXX_CMD"
    export MAKE="$MAKE_CMD"
    export RC="$WINDRES_CMD"

    local cmake_opts="-G \"Unix Makefiles\""

    pushd "$TARGET_DIR"
    $DEBUG && debug "Current directory is: $PWD" 1>&2

    if $DEBUG; then
        debug "$CMAKE_CMD $cmake_opts .."
    elif $VERBOSE; then
        echo "Generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "\"$CMAKE_CMD\" $cmake_opts .."
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
    local make_opts=--silent

    if $DEBUG; then
        debug "$MAKE_CMD $make_opts"
    elif $VERBOSE; then
        echo "Generate executable \"$PROJECT_NAME\"" 1>&2
    fi
    eval "$MAKE_CMD $make_opts"
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to generate executable \"$PROJECT_NAME\""
        cleanup 1
    fi
    popd
}

compile_icx() {
    local oneapi_libpath="$ONEAPI_ROOT/compiler/latest\windows\compiler\lib;$ONEAPI_ROOT%compiler/latest\windows\compiler\lib\intel64"

    local icx_flags="-Qstd=$CXX_STD -O2 -Fe\"$TARGET_DIR/$PROJECT_NAME.exe\""
    $DEBUG && icx_flags="-debug:all $icx_flags"

    local source_files=
    local n=0
    for f in $(find "$SOURCE_DIR/" -type f -name "*.cpp" 2>/dev/null); do
        source_files="$source_files \"$f\""
        n=$((n + 1))
    done
    if [[ $n -eq 0 ]]; then
        warning "No C++ source file found"
        return 1
    fi
    local s=; [[ $n -gt 1 ]] && s="s"
    local n_files="$n C++ source file$s"
    if $DEBUG; then
        debug "\"$ICX_CMD\" $icx_flags $source_files"
    elif $VERBOSE; then
        echo "Compile $n_files to directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "\"$ICX_CMD\" $icx_flags $source_files"
    if [[ $? -ne 0 ]]; then
        error "Failed to compile $n_files to directory \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
}

compile_msvc() {
    local cmake_opts="-Thost=$PROJECT_PLATFORM -A $PROJECT_PLATFORM -Wdeprecated"
    
    $VERBOSE && echo "Configuration: $PROJECT_CONFIG, Platform: $PROJECT_PLATFORM" 1>&2
    
    pushd "$TARGET_DIR"
    $DEBUG && debug "Current directory is: $PWD" 1>&2
    
    if $DEBUG; then
        debug "\"$MSVS_CMAKE_CMD\" $cmake_opts .."
    elif $VERBOSE; then
        echo "Generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "\"$MSVS_CMAKE_CMD\" $cmake_opts .."
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
    # MSBuild options must start with '-' (instead of '/').
    local msbuild_opts="-nologo \"-p:Configuration=$PROJECT_CONFIG\" \"-p:Platform=$PROJECT_PLATFORM\""
    
    if $DEBUG; then
        debug "\"$MSBUILD_CMD\" $msbuild_opts \"$PROJECT_NAME.sln\""
    elif $VERBOSE; then
        echo "Generate executable \"PROJECT_NAME.exe\"" 1>&2
    fi
    eval "\"$MSBUILD_CMD\" $msbuild_opts \"$PROJECT_NAME.sln\""
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to generate executable \"$PROJECT_NAME.exe\""
        cleanup 1
    fi
    popd
}

mixed_path() {
    if [[ -x "$CYGPATH_CMD" ]]; then
        $CYGPATH_CMD -am "$*"
    elif $mingw || $msys; then
        echo "$*" | sed 's|/|\\\\|g'
    else
        echo "$*"
    fi
}

dump() {
    echo "dump"
}

run() {
    local target_dir=
    if [[ $TOOLSET == "msvc" ]]; then target_dir="$TARGET_DIR/$PROJECT_CONFIG"
    else target_dir="$TARGET_DIR"
    fi
    local exe_file="$target_dir/$PROJECT_NAME.exe"
    if [[ ! -f "$exe_file" ]]; then
        error "Executable \"${exe_file/$ROOT_DIR\//}\" not found"
        cleanup 1
    fi
    if $DEBUG; then
        debug "$exe_file"
    elif $VERBOSE; then
        echo "Execute \"${exe_file/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "$exe_file"
    if [[ $? -ne 0 ]]; then
        error "Failed to execute \"${exe_file/$ROOT_DIR\//}\"" 1>&2
        cleanup 1
    fi
}

##############################################################################
## Environment setup

BASENAME=$(basename "${BASH_SOURCE[0]}")

EXITCODE=0

ROOT_DIR="$(getHome)"

SOURCE_DIR="$ROOT_DIR/src"
TARGET_DIR="$ROOT_DIR/build"

CLEAN=false
COMPILE=false
DEBUG=false
HELP=false
LINT=false
MAIN_CLASS="me.opc.se.bare.Main"
MAIN_ARGS=
RUN=false
TIMER=false
TOOLSET=msvc
VERBOSE=false

COLOR_START="[32m"
COLOR_END="[0m"

cygwin=false
mingw=false
msys=false
darwin=false
case "$(uname -s)" in
  CYGWIN*) cygwin=true ;;
  MINGW*)  mingw=true ;;
  MSYS*)   msys=true ;;
  Darwin*) darwin=true      
esac
unset CYGPATH_CMD
PSEP=":"
if $cygwin || $mingw || $msys; then
    CYGPATH_CMD="$(which cygpath 2>/dev/null)"
    [[ -n "$GRAALVM_HOME" ]] && GRAALVM_HOME="$(mixed_path $GRAALVM_HOME)"
	PSEP=";"
    BCC_CMD="$(mixed_path $BCC_HOME)/bin/bcc32c.exe"
    CLANG_CMD="$(mixed_path $LLVM_HOME)/bin/clang.exe"
    CMAKE_CMD="$(mixed_path $CMAKE_HOME)/bin/cmake.exe"
    CPPCHECK_CMD="$(mixed_path $MSYS_HOME)/mingw64/bin/cppcheck.exe"
    GCC_CMD="$(mixed_path $MSYS_HOME)/mingw64/bin/gcc.exe"
    ICX_CMD="$(mixed_path $ONEAPI_ROOT)/compiler/latest/windows/bin/icx.exe"
    MAKE_CMD="$(mixed_path $MSYS_HOME)/usr/bin/make.exe"
    MSBUILD_CMD="$(mixed_path $MSVS_MSBUILD_HOME)/bin/MSBuild.exe"
    MSVS_CMAKE_CMD="$(mixed_path $MSVS_CMAKE_HOME)/bin/cmake.exe"
    WINDRES_CMD="$(mixed_path $MSYS_HOME)/mingw64/bin/windres.exe"
else
    CLANG_CMD=clang
    CMAKE_CMD=cmake
    CPPCHECK_CMD=cppcheck
    GCC_CMD=gcc
    MAKE_CMD=make
fi

PROJECT_CONFIG="Release"
PROJECT_PLATFORM="x64"
PROJECT_NAME="$(basename $ROOT_DIR)"

CXX_STD="c++17"

args "$@"
[[ $EXITCODE -eq 0 ]] || cleanup 1

##############################################################################
## Main

$HELP && help && cleanup

if $CLEAN; then
    clean || cleanup 1
fi
if $LINT; then
    lint || cleanup 1
fi
if $COMPILE; then
    compile || cleanup 1
fi
if $RUN; then
    run || cleanup 1
fi
cleanup
