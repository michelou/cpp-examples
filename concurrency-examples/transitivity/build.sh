#!/usr/bin/env bash
#
# Copyright (c) 2018-2024 Stéphane Micheloud
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
<<<<<<< HEAD
    $DEBUG && echo "$DEBUG_LABEL $1" 1>&2
=======
    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $1" 1>&2
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
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

<<<<<<< HEAD
    if $TIMER; then
=======
    if [[ $TIMER -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        local TIMER_END=$(date +'%s')
        local duration=$((TIMER_END - TIMER_START))
        echo "Total execution time: $(date -d @$duration +'%H:%M:%S')" 1>&2
    fi
    debug "EXITCODE=$EXITCODE"
    exit $EXITCODE
}

args() {
<<<<<<< HEAD
    [[ $# -eq 0 ]] && HELP=true && return 1
=======
    [[ $# -eq 0 ]] && HELP=1 && return 1
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec

    for arg in "$@"; do
        case "$arg" in
        ## options
        -bcc)         TOOLSET=bcc ;;
        -cl)          TOOLSET=msvc ;;
        -clang)       TOOLSET=clang ;;
<<<<<<< HEAD
        -debug)       DEBUG=true ;;
        -gcc)         TOOLSET=gcc ;;
        -help)        HELP=true ;;
        -icx)         TOOLSET=icx ;;
        -msvc)        TOOLSET=msvc ;;
        -occ)         TOOLSET=occ ;;
        -timer)       TIMER=true ;;
        -verbose)     VERBOSE=true ;;
=======
        -debug)       DEBUG=1 ;;
        -gcc)         TOOLSET=gcc ;;
        -help)        HELP=1 ;;
        -icx)         TOOLSET=icx ;;
        -msvc)        TOOLSET=msvc ;;
        -occ)         TOOLSET=occ ;;
        -timer)       TIMER=1 ;;
        -verbose)     VERBOSE=1 ;;
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        -*)
            error "Unknown option $arg"
            EXITCODE=1 && return 0
            ;;
        ## subcommands
<<<<<<< HEAD
        clean)   CLEAN=true ;;
        compile) COMPILE=true ;;
        doc)     DOC=true ;;
        help)    HELP=true ;;
        lint)    LINT=true ;;
        run)     COMPILE=true && RUN=true ;;
=======
        clean)   CLEAN=1 ;;
        compile) COMPILE=1 ;;
        help)    HELP=1 ;;
        lint)    LINT=1 ;;
        run)     COMPILE=1 && RUN=1 ;;
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        *)
            error "Unknown subcommand $arg"
            EXITCODE=1 && return 0
            ;;
        esac
    done
    debug "Options    : PROJECT_CONFIG=$PROJECT_CONFIG TIMER=$TIMER TOOLSET=$TOOLSET VERBOSE=$VERBOSE"
<<<<<<< HEAD
    debug "Subcommands: CLEAN=$CLEAN COMPILE=$COMPILE DOC=$DOC HELP=$HELP RUN=$RUN"
=======
    debug "Subcommands: CLEAN=$CLEAN COMPILE=$COMPILE HELP=$HELP RUN=$RUN"
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
    debug "Variables  : GIT_HOME=$GIT_HOME"
    debug "Variables  : LLVM_HOME=$LLVM_HOME"
    debug "Variables  : MSVS_HOME=$MSVS_HOME"
    debug "Variables  : MSYS_HOME=$MSYS_HOME"
    debug "Variables  : ONEAPI_ROOT=$ONEAPI_ROOT"
    debug "Variables  : ORANGEC_HOME=$ORANGEC_HOME"
    # See http://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display/
<<<<<<< HEAD
    $TIMER && TIMER_START=$(date +"%s")
=======
    [[ $TIMER -eq 1 ]] && TIMER_START=$(date +"%s")
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
}

help() {
    cat << EOS
Usage: $BASENAME { <option> | <subcommand> }

  Options:
    -bcc         use BCC/GNU Make toolset instead of MSVC/MSBuild
    -cl          use MSVC/MSBuild toolset (default)
    -clang       use Clang/GNU Make toolset instead of MSVC/MSBuild
    -debug       print commands executed by this script
    -gcc         use GCC/GNU Make toolset instead of MSVC/MSBuild
    -icx         use Intel oneAPI C++ toolset instead of MSVC/MSBuild
    -msvc        use MSVC/MSBuild toolset (alias for option -cl)
    -occ         use LADSoft Orange C++ toolset instead of MSVC/MSBuild
    -timer       print total execution time
    -verbose     print progress messages

  Subcommands:
    clean        delete generated files
    compile      compile C++ source files
<<<<<<< HEAD
    doc          generate HTML documentation with Doxygen
    help         print this help message
    lint         analyze C++ source files with Cppcheck
    run          execute the generated executable
=======
    help         print this help message
    lint         analyze C++ source files with Cppcheck
    run          execute the generated executable "$PROJECT_NAME$TARGET_EXT"
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
EOS
}

clean() {
    if [[ -d "$TARGET_DIR" ]]; then
<<<<<<< HEAD
        if $DEBUG; then
            debug "rm -rf \"$TARGET_DIR\""
        elif $VERBOSE; then
=======
        if [[ $DEBUG -eq 1 ]]; then
            debug "Delete directory $TARGET_DIR"
        elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
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
<<<<<<< HEAD
    local cppcheck_opts="--platform=$CPPCHECK_PLATFORM $cppcheck_opts"
    if $DEBUG; then
        debug "$CPPCHECK_CMD $cppcheck_opts $SOURCE_DIR" 1>&2
    elif $VERBOSE; then
=======
    if [[ $DEBUG -eq 1 ]]; then
        debug "$CPPCHECK_CMD $CPPCHECK_OPTS$ $SOURCE_DIR" 1>&2
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        echo "Analyze C++ source files in directory \"${SOURCE_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "$CPPCHECK_CMD $cppcheck_opts $SOURCE_DIR"
    if [[ $? -ne 0 ]]; then
<<<<<<< HEAD
        error "Failed to check C++ source files in directory \"${SOURCE_DIR/$ROOT_DIR\//}\""
=======
        error "Failed to check C++ source files"
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
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
    occ)   toolset_name="LADSoft Orange C++" ;;
    *)     toolset_name="MSVC/MSBuild" ;;
    esac
<<<<<<< HEAD
    $VERBOSE && echo "Toolset: $toolset_name, Project: $PROJECT_NAME" 1>&2
=======
    [[ $VERBOSE -eq 1 ]] && echo "Toolset: $toolset_name, Project: $PROJECT_NAME" 1>&2
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
    
    compile_$TOOLSET
}

compile_bcc() {
    export CC="$BCC_CMD"
    export CXX="$BCC_CMD"
    export MAKE="$MAKE_CMD"
    export RC="$WINDRES_CMD"

    local cmake_opts="-G \"Unix Makefiles\""

    pushd "$TARGET_DIR"
<<<<<<< HEAD
    $DEBUG && debug "Current directory is: $PWD" 1>&2

    if $DEBUG; then
        debug "$CMAKE_CMD $cmake_opts .."
    elif $VERBOSE; then
=======
    [[ $DEBUG -eq 1 ]] && debug "Current directory is: $PWD" 1>&2

    if [[ $DEBUG -eq 1 ]]; then
        debug "$CMAKE_CMD $cmake_opts .."
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        echo "Generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "$CMAKE_CMD $cmake_opts .."
    if [[ $? -ne 0 ]]; then
        popd
<<<<<<< HEAD
        error "Failed to generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\""
=======
        error "Failed to generate configuration files into directory  \"${TARGET_DIR/$ROOT_DIR\//}\""
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        cleanup 1
    fi
    local make_opts=
    
<<<<<<< HEAD
    if $DEBUG; then
        debug "$MAKE_CMD $make_opts"
    elif $VERBOSE; then
=======
    if [[ $DEBUG -eq 1 ]]; then
        debug "$MAKE_CMD $make_opts"
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        echo "Generate executable \"$PROJECT_NAME\"" 1>&2
    fi
    eval "$MAKE_CMD $make_opts"
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to geenerate executable \"$PROJECT_NAME\""
        cleanup 1
    fi
    popd
<<<<<<< HEAD
    if $DEBUG; then
        debug "cp $(mixed_path $BCC_HOME)/bin/cc32*mt.dll $TARGET_DIR/"
    elif $VERBOSE; then
=======
    if [[ $DEBUG -eq 1 ]]; then
        debug "cp $(mixed_path $BCC_HOME)/bin/cc32*mt.dll $TARGET_DIR/"
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
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
<<<<<<< HEAD
    $DEBUG && debug "Current directory is: $PWD" 1>&2

    if $DEBUG; then
        debug "$CMAKE_CMD $cmake_opts .."
    elif $VERBOSE; then
=======
    [[ $DEBUG -eq 1 ]] && debug "Current directory is: $PWD" 1>&2

    if [[ $DEBUG -eq 1 ]]; then
        debug "$CMAKE_CMD $cmake_opts .."
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        echo "Generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "\"$CMAKE_CMD\" $cmake_opts .."
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
    local make_opts=

<<<<<<< HEAD
    if $DEBUG; then
        debug "$MAKE_CMD $make_opts"
    elif $VERBOSE; then
=======
    if [[ $DEBUG -eq 1 ]]; then
        debug "$MAKE_CMD $make_opts"
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        echo "Generate executable \"$PROJECT_NAME$TARGET_EXT\"" 1>&2
    fi
    eval "$MAKE_CMD $make_opts"
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to geenerate executable \"$PROJECT_NAME$TARGET_EXT\""
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
<<<<<<< HEAD
    $DEBUG && debug "Current directory is: $PWD" 1>&2

    if $DEBUG; then
        debug "$CMAKE_CMD $cmake_opts .."
    elif $VERBOSE; then
=======
    [[ $DEBUG -eq 1 ]] && debug "Current directory is: $PWD" 1>&2

    if [[ $DEBUG -eq 1 ]]; then
        debug "$CMAKE_CMD $cmake_opts .."
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        echo "Generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "\"$CMAKE_CMD\" $cmake_opts .."
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to generate configuration files into directory \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
    local make_opts=--silent

<<<<<<< HEAD
    if $DEBUG; then
        debug "$MAKE_CMD $make_opts"
    elif $VERBOSE; then
=======
    if [[ $DEBUG -eq 1 ]]; then
        debug "$MAKE_CMD $make_opts"
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        echo "Generate executable \"$PROJECT_NAME$TARGET_EXT\"" 1>&2
    fi
    eval "$MAKE_CMD $make_opts"
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to generate executable \"$PROJECT_NAME$TARGET_EXT\""
        cleanup 1
    fi
    popd
}

compile_icx() {
<<<<<<< HEAD
    local oneapi_libpath="$ONEAPI_ROOT/compiler/latest/compiler/lib;$ONEAPI_ROOT/compiler/latest/compiler/lib/intel64"

    local icx_flags="-Qstd=$CXX_STD -O2 -Fe\"$(mixed_path $TARGET_DIR/$PROJECT_NAME.exe)\""
    $DEBUG && icx_flags="-debug:all -v $icx_flags"

    local source_files=
    local n=0
    for f in $(find "$CPP_SOURCE_DIR/" -type f -name "*.cpp" 2>/dev/null); do
=======
    local oneapi_libpath="$ONEAPI_ROOT/compiler/latest\windows\compiler\lib;$ONEAPI_ROOT%compiler/latest\windows\compiler\lib\intel64"

    local icx_flags="-Qstd=$CXX_STD -O2 -Fe\"$(mixed_path $TARGET_DIR/$PROJECT_NAME.exe)\""
    [[ $DEBUG -eq 1 ]] && icx_flags="-debug:all -v $icx_flags"

    local source_files=
    local n=0
    for f in $(find "$SOURCE_DIR/" -type f -name "*.cpp" 2>/dev/null); do
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        source_files="$source_files \"$f\""
        n=$((n + 1))
    done
    if [[ $n -eq 0 ]]; then
        warning "No C++ source file found"
        return 1
    fi
    local s=; [[ $n -gt 1 ]] && s="s"
    local n_files="$n C++ source file$s"
<<<<<<< HEAD
    if $DEBUG; then
        debug "\"$ICX_CMD\" $icx_flags $source_files"
    elif $VERBOSE; then
=======
    if [[ $DEBUG -eq 1 ]]; then
        debug "\"$ICX_CMD\" $icx_flags $source_files"
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
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
    
<<<<<<< HEAD
    $VERBOSE && echo "Configuration: $PROJECT_CONFIG, Platform: $PROJECT_PLATFORM" 1>&2
    
    pushd "$TARGET_DIR"
    $DEBUG && debug "Current directory is: $PWD" 1>&2
    
    if $DEBUG; then
        debug "\"$MSVS_CMAKE_CMD\" $cmake_opts .."
    elif $VERBOSE; then
=======
    [[ $VERBOSE -eq 1 ]] && echo "Configuration: $PROJECT_CONFIG, Platform: $PROJECT_PLATFORM" 1>&2
    
    pushd "$TARGET_DIR"
    [[ $DEBUG -eq 1 ]] && debug "Current directory is: $PWD" 1>&2
    
    if [[ $DEBUG -eq 1 ]]; then
        debug "\"$MSVS_CMAKE_CMD\" $cmake_opts .."
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
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
<<<<<<< HEAD
    if $DEBUG; then
        debug "\"$MSBUILD_CMD\" $msbuild_opts \"$PROJECT_NAME.sln\""
    elif $VERBOSE; then
        echo "Generate executable \"PROJECT_NAME$TARGET_EXT\"" 1>&2
    fi
=======
    
    if [[ $DEBUG -eq 1 ]]; then
        debug "\"$MSBUILD_CMD\" $msbuild_opts \"$PROJECT_NAME.sln\""
    elif [[ $VERBOSE -eq 1 ]]; then
        echo "Generate executable \"PROJECT_NAME$TARGET_EXT\"" 1>&2
    fi
    echo "1111111111111111111111 $PWD"
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
    eval "\"$MSBUILD_CMD\" $msbuild_opts \"$PROJECT_NAME.sln\""
    if [[ $? -ne 0 ]]; then
        popd
        error "Failed to generate executable \"$PROJECT_NAME$TARGET_EXT\""
        cleanup 1
    fi
    popd
}

compile_occ() {
<<<<<<< HEAD
    local occ_flags="--nologo -std=c++17 /o\"$(mixed_path $TARGET_DIR)/$PROJECT_NAME.exe\""
=======
    local occ_flags="--nologo -std=c++14 /o\"$(mixed_path $TARGET_DIR)/$PROJECT_NAME.exe\""
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec

    local source_files=
    local n=0
    for f in $(find "$SOURCE_DIR/" -type f -name "*.cpp" 2>/dev/null); do
        source_files="$source_files \"$(mixed_path $f)\""
        n=$((n + 1))
    done
    if [[ $n -eq 0 ]]; then
        warning "No C++ source file found"
        return 1
    fi
    local s=; [[ $n -gt 1 ]] && s="s"
    local n_files="$n C++ source file$s"
<<<<<<< HEAD
    if $DEBUG; then
        debug "\"$OCC_CMD\" $occ_flags $source_files"
    elif $VERBOSE; then
=======
    if [[ $DEBUG -eq 1 ]]; then
        debug "\"$OCC_CMD\" $occ_flags $source_files"
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        echo "Compile $n_files to directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "\"$OCC_CMD\" $occ_flags $source_files"
    if [[ $? -ne 0 ]]; then
        error "Failed to compile $n_files to directory \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
}

mixed_path() {
    if [[ -x "$CYGPATH_CMD" ]]; then
        $CYGPATH_CMD -am "$*"
<<<<<<< HEAD
    elif $mingw || $msys; then
=======
    elif [[ $(($mingw + $msys)) -gt 0 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
        echo "$*" | sed 's|/|\\\\|g'
    else
        echo "$*"
    fi
}

<<<<<<< HEAD
doc() {
    ## must be the same as property OUTPUT_DIRECTORY in file Doxyfile
    if [[ ! -d "$TARGET_DOCS_DIR" ]]; then
        $DEBUG && debug "mkdir \"$TARGET_DOCS_DIR\""
        mkdir "$TARGET_DOCS_DIR"
    fi
    local doxyfile="$(dirname "$ROOT_DIR")/Doxyfile"
    if [[ ! -f "$doxyfile" ]]; then
        error "Doxygen configuration file not found"
        cleanup 1
    fi
    local doxygen_opts=-s
    if $DEBUG; then
        debug "\"$DOXYGEN\" $doxygen_opts \"$doxyfile\""
    elif $VERBOSE; then
       echo "Generate HTML documentation" 1>&2
    fi
    eval "\"$DOXYGEN\" $doxygen_opts \"$doxyfile\""
    if [[ $? -ne 0 ]]; then
        error "Failed to generate HTML documentation" 1>&2
        cleanup 1
    fi
}

=======
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
dump() {
    echo "dump"
}

run() {
    local target_dir=
    if [[ $TOOLSET == "msvc" ]]; then target_dir="$TARGET_DIR/$PROJECT_CONFIG"
    else target_dir="$TARGET_DIR"
    fi
<<<<<<< HEAD
    local exe_file="$target_dir/$PROJECT_NAME.exe"
=======
    local exe_file="$target_dir/$PROJECT_NAME$TARGET_EXT"
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
    if [[ ! -f "$exe_file" ]]; then
        error "Executable \"${exe_file/$ROOT_DIR\//}\" not found"
        cleanup 1
    fi
<<<<<<< HEAD
    if $DEBUG; then
        debug "$exe_file"
    elif $VERBOSE; then
=======
    if [[ $DEBUG -eq 1 ]]; then
        debug "$exe_file"
    elif [[ $VERBOSE -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
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
<<<<<<< HEAD
CPP_SOURCE_DIR="$SOURCE_DIR/main/cpp"
TARGET_DIR="$ROOT_DIR/build"
TARGET_DOCS_DIR="$TARGET_DIR/docs"

CLEAN=false
COMPILE=false
DEBUG=false
DOC=false
HELP=false
LINT=false
MAIN_CLASS="transitivity"
MAIN_ARGS=
RUN=false
TIMER=false
TOOLSET=msvc
VERBOSE=false
=======
TARGET_DIR="$ROOT_DIR/build"

## We refrain from using `true` and `false` which are Bash commands
## (see https://man7.org/linux/man-pages/man1/false.1.html)
CLEAN=0
COMPILE=0
DEBUG=0
HELP=0
LINT=0
RUN=0
TIMER=0
TOOLSET=msvc
VERBOSE=0
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec

COLOR_START="[32m"
COLOR_END="[0m"

<<<<<<< HEAD
cygwin=false
mingw=false
msys=false
darwin=false
case "$(uname -s)" in
    CYGWIN*) cygwin=true ;;
    MINGW*)  mingw=true ;;
    MSYS*)   msys=true ;;
    Darwin*) darwin=true
=======
cygwin=0
mingw=0
msys=0
darwin=0
case "$(uname -s)" in
    CYGWIN*) cygwin=1 ;;
    MINGW*)  mingw=1 ;;
    MSYS*)   msys=1 ;;
    Darwin*) darwin=1      
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
esac
unset CYGPATH_CMD
PSEP=":"
TARGET_EXT=
<<<<<<< HEAD
if $cygwin || $mingw || $msys; then
=======
if [[ $(($cygwin + $mingw + $msys)) -gt 0 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
    CYGPATH_CMD="$(which cygpath 2>/dev/null)"
    [[ -n "$GRAALVM_HOME" ]] && GRAALVM_HOME="$(mixed_path $GRAALVM_HOME)"
	PSEP=";"
    TARGET_EXT=".exe"
    BCC_CMD="$(mixed_path $BCC_HOME)/bin/bcc32c.exe"
    CLANG_CMD="$(mixed_path $LLVM_HOME)/bin/clang.exe"
    CMAKE_CMD="$(mixed_path $CMAKE_HOME)/bin/cmake.exe"
    CPPCHECK_CMD="$(mixed_path $MSYS_HOME)/mingw64/bin/cppcheck.exe"
<<<<<<< HEAD
    CPPCHECK_PLATFORM=win64
    DOXYGEN="$(mixed_path $DOXYGEN_HOME)/doxygen.exe"
    GCC_CMD="$(mixed_path $MSYS_HOME)/usr/bin/gcc.exe"
=======
    GCC_CMD="$(mixed_path $MSYS_HOME)/usr/bin/gcc.exe"
    GXX_CMD="$(mixed_path $MSYS_HOME)/usr/bin/g++.exe"
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
    ICX_CMD="$(mixed_path $ONEAPI_ROOT)/compiler/latest/windows/bin/icx.exe"
    MAKE_CMD="$(mixed_path $MSYS_HOME)/usr/bin/make.exe"
    MSBUILD_CMD="$(mixed_path $MSVS_MSBUILD_HOME)/bin/MSBuild.exe"
    MSVS_CMAKE_CMD="$(mixed_path $MSVS_CMAKE_HOME)/bin/cmake.exe"
    OCC_CMD="$(mixed_path $ORANGEC_HOME)/bin/occ.exe"
    WINDRES_CMD="$(mixed_path $MSYS_HOME)/mingw64/bin/windres.exe"
else
    CLANG_CMD=clang
    CMAKE_CMD=cmake
    CPPCHECK_CMD=cppcheck
<<<<<<< HEAD
    CPPCHECK_PLATFORM=native
    DOXYGEN=doxygen
    GCC_CMD=gcc
    MAKE_CMD=make
    OCC_CMD=occ
=======
    GCC_CMD=gcc
    GXX=g++
    MAKE_CMD=make
    OCC=occ
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
fi

PROJECT_CONFIG="Release"
PROJECT_PLATFORM="x64"
PROJECT_NAME="$(basename $ROOT_DIR)"

CXX_STD="c++17"

args "$@"
[[ $EXITCODE -eq 0 ]] || cleanup 1

##############################################################################
## Main

<<<<<<< HEAD
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
if $DOC; then
    doc || cleanup 1
fi
if $RUN; then
=======
[[ $HELP -eq 1 ]] && help && cleanup

if [[ $CLEAN -eq 1 ]]; then
    clean || cleanup 1
fi
if [[ $LINT -eq 1 ]]; then
    lint || cleanup 1
fi
if [[ $COMPILE -eq 1 ]]; then
    compile || cleanup 1
fi
if [[ $RUN -eq 1 ]]; then
>>>>>>> a02d601eb2f6db4cf587548321f88f736103e1ec
    run || cleanup 1
fi
cleanup
