# <span id="top">C++ Examples</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://isocpp.org/" rel="external"><img src="../docs/images/cpp_logo.png" width="100" alt="C++ project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <a href="."><strong><code>examples\</code></strong></a> contains <a href="https://isocpp.org/" rel="external" title="ISO C++">ISO C++</a> code examples coming from various websites - mostly from the <a href="https://isocpp.org/" rel="external" title="ISO C++">C++</a> project.<br/>
  It also includes build scripts (<a href="https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_01.html" rel="external">Bash scripts</a>, <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://bazel.build/rules/lib/globals/module" rel="external">Bazel files</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) for experimenting with <a href="https://isocpp.org/" rel="external">C++</a> on a Windows machine.</td>
  </tr>
</table>

The code examples presented below can be built/run with the following command line tools:

| Build&nbsp;tool | Build&nbsp;file | Parent&nbsp;file | Environment(s) |
|:----------------|:----------------|:-----------------|:---------------|
| [**`bazel.exe`**][bazel_cli] | [`MODULE.bazel`](./hello/MODULE.bazel) | | Windows |
| [**`cmd.exe`**][cmd_cli] | [`build.bat`](./hello/build.bat) | &nbsp; | Windows only |
| [**`make.exe`**][make_cli] | [`Makefile`](./hello/Makefile) | [`Makefile.inc`](./Makefile.inc) | Any <sup><b>a)</b></sup> |
| [**`sh.exe`**][sh_cli] | [`build.sh`](./hello/build.sh) | &nbsp; | Any <sup><b>a)</b></sup> |
<div style="margin:0 0 0 10px;font-size:80%;">
<sup><b>a)</b></sup> Here "Any" means "tested on Windows, Cygwin, MSYS2 and UNIX".<br/>&nbsp;
</div>

## <span id="hello">`hello` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/finsdtr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./hello/build.bat">build.bat</a>
|   <a href="./hello//build.sh">build.sh</a>
|   <a href="./hello/CMakeLists.txt">CMakeLists.txt</a>
|   <a href="./hello/Doxyfile">Doxyfile</a>
|   <a href="./hello/Makefile">Makefile</a>
|   <a href="./hello/MODULE.bazel">MODULE.bazel</a>
\---<b>src</b>
    |   <a href="./hello/src/BUILD.bazel">BUILD.bazel</a>
    \---<b>main</b>
        +---<b>cpp</b>
        |       <a href="./hello/src/main.cpp">main.cpp</a>
        \---<b>resources</b>
                <a href="./hello/src/main/resources/hello.png">hello.png</a>
                <a href="./hello/src/main/resources/hello.txt">hello.txt</a>
</pre>

Batch file [**`build.bat`**](./hello/build.bat) generates the `hello.exe` executable using one of the options [`-bcc`][bcc_cli], [`-clang`][clang_cli], [`-gcc`][gcc_cli], [`-icx`][icx_cli], <span style="white-space: nowrap;">[`-msvc`][cl_cli]</span> (default) or [`occ`][occ_cli] :

<pre style="font-size:80%;">
<b>&gt; <a href="./hello/build.bat">build</a> -verbose clean run</b>
Delete directory "build"
Toolset: MSVC/MSBuild, Project: hello
Configuration: Release, Platform: x64
Current directory is: "F:\examples\hello\build"
Generate configuration files into directory "build"
Generate executable "hello.exe"
Execute "build\Release\hello.exe"
Hello, World!
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="./hello/build.bat">build</a> -clang -verbose clean compile</b>
Delete directory "build"
Toolset: Clang/GNU Make, Project: hello
Generate configuration files into directory "build"
Generate executable "hello.exe"
Execute "build\hello.exe"
Hello, World!
</pre>

In the same way command [`make.exe`][make_cli] reads its configuration from file [`Makefile`](./hello/Makefile) and generates the `hello.exe` executable using variable `TOOLSET`, e.g. `TOOLSET=clang` (respectively [`bcc`][bcc_cli], [`gcc`][gcc_cli], [`icx`][icx_cli], [`msvc`][cl_cli] or [`occ`][occ_cli]) :

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.gnu.org/software/make/manual/html_node/Running.html" rel="external">make</a> TOOLSET=bcc clean build</b>
"C:/opt/msys64/usr/bin/rm.exe" -rf "build"
"c:/opt/BCC-7.30-32bit/bin/bcc32c.exe"  -I "src" -q -w  -o build/hello.exe src/main/cpp/main.cpp -lq
src/main/cpp/main.cpp:
&nbsp;
<b>&gt; <a href="https://www.gnu.org/software/make/manual/html_node/Running.html" rel="external">make</a> TOOLSET=clang clean build</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"C:/opt/LLVM-19.1.0/bin/clang.exe"  --std=c++20 -O2 -Wall -Wno-unused-variable  -o build/Release/hello.exe src/main/cpp/main.cpp
&nbsp;
<b>&gt; <a href="https://www.gnu.org/software/make/manual/html_node/Running.html" rel="external">make</a> TOOLSET=icx clean build</b>
"C:/opt/msys64/usr/bin/rm.exe" -rf "build"
"C:/Program Files (x86)/Intel/oneAPI//compiler/latest/windows/bin/icx.exe"  -nologo -Qstd=c++20 -O2 -Wall -Wno-unused-variable  -o build/Release/hello.exe src/main/cpp/main.cpp -link -libpath:"C:/Program Files (x86)/Intel/oneAPI//compiler/latest/windows/compiler/lib/intel64"
&nbsp;
<b>&gt; <a href="https://www.gnu.org/software/make/manual/html_node/Running.html" rel="external">make</a> TOOLSET=occ clean build</b>
"C:/opt/msys64/usr/bin/rm.exe" -rf "build"
"C:/opt/orangec/bin/occ.exe"  --nologo -std=c++14  -o build/hello.exe src/main/cpp/main.cpp
</pre>

Finally command [`bazel.exe`][bazel_cli] reads its configuration from file [`MODULE.bazel`](./hello/MODULE.bazel) and generates the `hello.exe` executable into the output directory `bazel-bin\`.

<pre style="font-size:80%;">
<b>&gt; <a href="https://bazel.build/reference/command-line-reference" rel="external">bazel</a> clean & bazel build ...</b>
INFO: Starting clean.
INFO: Analyzed target //src:hello (70 packages loaded, 481 targets configured).
INFO: From Compiling src/main/cpp/main.cpp:
main.cpp
INFO: Found 1 target...
Target //src:hello up-to-date:
  bazel-bin/src/hello.exe
INFO: Elapsed time: 2.172s, Critical Path: 1.29s
INFO: 6 processes: 4 internal, 2 local.
INFO: Build completed successfully, 6 total actions
&nbsp;
<b>&gt; bazel-bin\src\hello.exe</b>
Hello, World!
</pre>

<!--=========================================================================-->

## <span id="call-by-copy">`call-by-copy` Example</span> [**&#x25B4;**](#top)

This example comes from [stackoverflow] post [*What is object slicing?*](https://stackoverflow.com/questions/274626/what-is-object-slicing); it has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./call-by-copy/00download.txt">00download.txt</a>
|   <a href="./call-by-copy/build.bat">build.bat</a>
|   <a href="./call-by-copy/build.sh">build.sh</a>
|   <a href="./call-by-copy/CMakeLists.txt">CMakeLists.txt</a>
|   <a href="./call-by-copy/Doxyfile">Doxyfile</a>
|   <a href="./call-by-copy/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>cpp</b>
                <a href="./call-by-copy/src/main/cpp/Main.cpp">Main.cpp</a>
</pre>

Batch file [**`build.bat`**](./call-by-copy/build.bat) generates the `call-by-copy.exe` executable using one of the options `bcc`, `-clang`, `-gcc`, <span style="white-space: nowrap;">`-icx`</span> or `-msvc` :

<pre style="font-size:80%;">
<b>&gt; <a href="./call-by-copy/build.bat">build</a> -msvc -verbose clean compile</b>
Delete directory "build"
Toolset: MSVC/MSBuild, Project: call-by-copy
Configuration: Release, Platform: x64
Generate configuration files into directory "build"
Generate executable "call-by-copy.exe"
</pre>

In the same way command [`make.exe`][make_cli] reads its configuration from file [`Makefile`¨](./call-by-copy/Makefile) and generates the `call-by-copy.exe` executable using variable `TOOLSET`, e.g. `TOOLSET=msvc` (or `bcc`, `clang`, `gcc`, `icx`) :

<pre style="font-size:80%;">
<b>&gt; <a href="">make</a> TOOLSET=msvc clean build</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"%MSVC_HOME%/bin\Hostx64/x64/cl.exe"  -nologo -std:c++17 -EHsc -I"%MSVC_HOME%/include" -I"%WINSDK_HOME%/include/10.0.22000.0/ucrt" -I"%WINSDK_HOME%/include/10.0.22000.0/um"  -Fe"build/Release/call-by-copy.exe" src/main/cpp/Main.cpp -link -libpath:"%MSVC_HOME%/lib/x64" -libpath:"%WINSDK_HOME%/lib/10.0.22000.0/ucrt/x64" -libpath:"%WINSDK_HOME%/lib/10.0.22000.0/um/x64" Main.cpp
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="">make</a> TOOLSET=bcc clean build</b>
"/usr/bin/rm.exe" -rf "build"
"C:/opt/BCC-10.2/bin/bcc32c.exe"  -I "src" -q -w  -o build/call-by-copy.exe src/main/cpp/Main.cpp -lq
src/main/cpp/Main.cpp:
</pre>

<!--======================================================================-->

## <span id="class-dispatching">`class-dispatching` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./class-dispatching/build.bat">build.bat</a>
|   <a href="./class-dispatching/build.sh">build.sh</a>
|   <a href="./class-dispatching/CMakeLists.txt">CMakeLists.txt</a>
|   <a href="./class-dispatching/Doxyfile">Doxyfile</a>
|   <a href="./class-dispatching/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>cpp</b>
                <a href="./class-dispatching/src/main/cpp/Main.cpp">Main.cpp</a>
</pre>

Command [`build.bat`](./class-dispatching/build.bat) generates the `class-dispatching.exe` executable using one of the options `-bcc`, `-clang`, <span style="white-space: nowrap;">`-gcc`</span>, `-icx` or `-msvc` (default).

<pre style="font-size:80%;">
<b>&gt; <a href="./class-dispatching/build.bat">build</a> -msvc -verbose clean run</b>
Delete directory "build"
Toolset: MSVC/MSBuild, Project: class-dispatching
Configuration: Release, Platform: x64
Generate configuration files into directory "build"
Generate executable "class-dispatching.exe"
Execute "build\Release\class-dispatching.exe"
Base Dervied1foo 10
Base Derived2foo 20
</pre>

## <span id="func-destructuring">`func-destructuring`Example</span>

This example <sup id="anchor_01">[1](#footnote_01)</sup> comes from Fekirs's blog post ["Destructure a C++ function"](https://fekir.info/post/destructure-cpp-function/); it has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./func-destructuring/00download.txt">00download.txt</a>
|   <a href="./func-destructuring/build.bat">build.bat</a>
|   <a href="./func-destructuring/CMakeLists.txt">CMakeLists.txt</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>cpp</b>
                <a href="./func-destructuring/src/main/cpp/main.cpp">main.cpp</a>
</pre>

<!--=======================================================================-->

## <span id="move-constructor">`move-constructor` Example</span> [**&#x25B4;**](#top)

This example comes from [INVIVOO] post "[A la redécouverte du C++ : &amp;&amp; et std::mov](https://blog.invivoo.com/decouverte-du-cplusplus-et-stdmove/)". It has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./move-constructor/00download.txt">00download.txt
|   <a href="./move-constructor/build.bat">build.bat
|   <a href="./move-constructor/CMakeLists.txt">CMakeLists.txt
|   <a href="./move-constructor/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>cpp</b>
                <a href="./move-constructor/src/main/cpp/Main.cpp">Main.cpp</a>
</pre>

Command [`build.bat`](./move-constructor/build.bat) generates the `move-constructor.exe` executable using one of the options `-bcc`, `-clang`, <span style="white-space: nowrap;">`-gcc`</span>, `-icx` or `-msvc` :

<pre style="font-size:80%;">
<b>&gt; <a href="./move-constructor/build.bat">build</a> -clang -verbose clean compile</b>
Delete directory "build"
Toolset: Clang/GNU Make, Project: move-constructor
Generate configuration files into directory "build"
Generate executable "move-constructor.exe"
</pre>

In the same way command [`make.exe`][make_cli] reads the hand-written [`Makefile`](./move-constructor/Makefile) and invokes one of five C++ compilers to generate executable `move-constructor.exe` using variable `TOOLSET`, e.g. `TOOLSET=clang` (or [`gcc`][gcc_cli], [`icx`][icx_cli], [`msvc`][cl_cli], [`occ`][occ_cli]) :

<pre style="font-size:80%;">
<b>&gt; <a href="">make</a> TOOLSET=clang clean build</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"C:/opt/LLVM-16.0.6//bin/clang.exe"  --std=c++17 -O2 -Wall -Wno-unused-variable  -o build/Release/move-constructor.exe src/main/cpp/Main.cpp
</pre>

## <span id="tuple-iterators">`tuple-iterators` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./tuple-iterators/build.bat">build.bat</a>
|   <a href="./tuple-iterators/build.sh">build.sh</a>
|   <a href="./tuple-iterators/CMakeLists.txt">CMakeLists.txt</a>
|   <a href="./tuple-iterators/Doxyfile">Doxyfile</a>
|   <a href="./tuple-iterators/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>cpp</b>
                <a href="./tuple-iterators/src/main/cpp/Main.cpp">Main.cpp</a>
</pre>

Batch file [`build.bat`](./tuple-iterators/build.bat) generates the `tuple-iterators.exe` executable using one of the options `bcc`, `-clang`, `-gcc`, <span style="white-space: nowrap;">`-icx`</span> or `-msvc` (default) :

<pre style="font-size:80%;">
<b>&gt; <a href="./tuple-iterators/build.bat">build</a> -gcc -verbose clean compile</b>
Delete directory "build"
Toolset: GCC/GNU Make, Project: tuple-iterators
Generate configuration files into directory "build"
Generate executable "tuple-iterators.exe"
</pre>

In the same way command [`make.exe`][make_cli] reads the hand-written [`Makefile`](./tuple-iterators/Makefile) and invokes one of five C++ compilers to generate executable `tuple-iterators.exe` using variable `TOOLSET`, e.g. `TOOLSET=gcc` (or `bcc`, `clang`, `icx`, `msvc`) :

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.gnu.org/software/make/manual/html_node/Running.html" rel="external">make</a> TOOLSET=gcc clean build</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"C:/opt/msys64/mingw64/bin/g++.exe"  --std=c++17 -O2 -Wall -Wno-unused-variable  -o build/Release/tuple-iterators.exe src/main/cpp/Main.cpp
</pre>

<!--=======================================================================-->

## <span id="visitor-pattern">`visitor-pattern` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./visitor-pattern/build.bat">build.bat</a>
|   <a href="./visitor-pattern/build.sh">build.sh</a>
|   <a href="./visitor-pattern/CMakeLists.txt">CMakeLists.txt</a>
|   <a href="./visitor-pattern/Doxyfile">Doxyfile</a>
|   <a href="./visitor-pattern/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>cpp</b>
                <a href="./visitor-pattern/src/main/cpp/Main.cpp">Main.cpp</a>
</pre>

Batch files [**`build.bat`**](./visitor-pattern/build.bat)`-verbose run` generates and executes the C++ program `build\Release\visitor-pattern.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="./visitor-pattern/build.bat">build</a> -verbose run</b>
Toolset: MSVC/MSBuild, Project: visitor-pattern
Configuration: Release, Platform: x64
Generate configuration files into directory "build"
Generate executable "visitor-pattern.exe"
Execute "build\Release\visitor-pattern.exe"
do Up on This
do Up on That
do Up on TheOther
do Down on This
do Down on That
do Down on TheOther
</pre>

Using build option `-gcc` we get the following output (same with option `-clang`, `-icx` or `-occ`) :

<pre style="font-size:80%;">
<b>&gt; <a href="./visitor-pattern/build.bat">build</a> -verbose -gcc clean run</b>
Delete directory "build"
Toolset: GCC/GNU Make, Project: visitor-pattern
Generate configuration files into directory "build"
Generate executable "visitor-pattern.exe"
Execute "build\visitor-pattern.exe"
do Up on This
do Up on That
do Up on TheOther
do Down on This
do Down on That
do Down on TheOther
</pre>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> **Support for <code>static_assert</code>** [↩](#anchor_01)

<dl><dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
G:\examples\func-destructuring
&nbsp;
<b>&gt; <a href="./func-destructuring/build.bat">build</a> -debug -clang clean run</b>
[build] Options    : _CXX_STD=c++17 _TOOLSET=clang _VERBOSE=0
[build] Subcommands: _CLEAN=1 _COMPILE=1 _DOC=0 _DUMP=0 _LINT=0 _RUN=1
[build] Variables  : "BCC_HOME=C:\opt\BCC-10.2"
[build] Variables  : "CMAKE_HOME=C:\opt\cmake"
[build] Variables  : "DOXYGEN_HOME=C:\opt\doxygen"
[build] Variables  : "GIT_HOME=C:\opt\Git"
[build] Variables  : "LLVM_HOME=C:\opt\LLVM-15.0.7" (clang)
[build] Variables  : "MSVS_HOME=X:"
[build] Variables  : "MSVS_CMAKE_HOME=X:\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake"
[build] Variables  : "MSVS_MSBUILD_HOME=X:\MSBuild\Current"
[build] Variables  : "MSYS_HOME=C:\opt\msys64" (gcc)
[build] Variables  : "ONEAPI_ROOT=C:\Program Files (x86)\Intel\oneAPI" (icx)
[build] Variables  : "ORANGEC_HOME=C:\opt\orangec" (occ)
[build] rmdir /s /q "G:\examples\func-destructuring\build"
[build] Current directory is: "G:\examples\func-destructuring\build"
[build] "C:\opt\cmake\bin\cmake.exe" -G "Unix Makefiles" ..
-- The CXX compiler identification is Clang 15.0.7 with GNU-like command-line
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: C:/opt/LLVM-15.0.7/bin/clang++.exe - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done (2.5s)
-- Generating done (0.0s)
-- Build files have been written to: G:/examples/func-destructuring/build
[build] "C:\opt\msys64\usr\bin\make.exe"
[ 50%] Building CXX object CMakeFiles/func-destructuring.dir/src/main/cpp/main.cpp.obj
In file included from G:/examples/func-destructuring/src/main/cpp/main.cpp:3:
In file included from X:\VC\Tools\MSVC\14.39.33519\include\tuple:8:
X:\VC\Tools\MSVC\14.39.33519\include\yvals_core.h:892:1: error: static assertion failed: error STL1000: Unexpected compiler version, expected Clang 16.0.0 or
      newer.
_EMIT_STL_ERROR(STL1000, "Unexpected compiler version, expected Clang 16.0.0 or newer.");
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
X:\VC\Tools\MSVC\14.39.33519\include\yvals_core.h:516:44: note: expanded from macro '_EMIT_STL_ERROR'
#define _EMIT_STL_ERROR(NUMBER, MESSAGE)   static_assert(false, "error " #NUMBER ": " MESSAGE)
                                           ^             ~~~~~
1 error generated.
make[2]: *** [CMakeFiles/func-destructuring.dir/build.make:76: CMakeFiles/func-destructuring.dir/src/main/cpp/main.cpp.obj] Error 1
make[1]: *** [CMakeFiles/Makefile2:83: CMakeFiles/func-destructuring.dir/all] Error 2
make: *** [Makefile:91: all] Error 2
Error: Failed to generate executable "func-destructuring.exe"
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/December 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[bazel_cli]: https://bazel.build/reference/command-line-reference
[bcc_cli]: https://docwiki.embarcadero.com/RADStudio/Sydney/en/C%2B%2B_Compiler
[cl_cli]: https://learn.microsoft.com/en-us/cpp/build/reference/compiler-command-line-syntax
[clang_cli]: https://clang.llvm.org/docs/UsersManual.html#basic-usage
[cmd_cli]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
[gcc_cli]: https://gcc.gnu.org/onlinedocs/gcc/Invoking-GCC.html
[icx_cli]: https://www.intel.com/content/www/us/en/docs/dpcpp-cpp-compiler/developer-guide-reference/2023-2/use-the-command-line.html
[invivoo]: https://www.invivoo.com/
[make_cli]: https://www.gnu.org/software/make/manual/html_node/Running.html
[occ_cli]: https://orangec.readthedocs.io/en/latest/occ/OCC%20Command%20Line/
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
[stackoverflow]: https://stackoverflow.com/
