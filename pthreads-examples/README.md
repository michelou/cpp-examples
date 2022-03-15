# <span id="top">C++ Examples with POSIX threads</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://isocpp.org/"><img src="../docs/images/cpp_logo.png" width="100" alt="C++ project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <a href="."><strong><code>pthreads-examples\</code></strong></a> contains <a href="hhttps://isocpp.org/" rel="external" title="ISO C++">C++</a> code examples from various websites which use POSIX threads on Windows.<br/>
  It also includes build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a>, Makefiles) for experimenting with <a href="hhttps://isocpp.org/" rel="external">C++</a> on a Windows machine.
  </td>
  </tr>
</table>

The code examples presented below can be built/run with the following tools:

| Build&nbsp;tool | Configuration file | Parent file | Environment(s) |
|:----------------|:-------------------|:------------|:---------------|
| [`build.bat`](./fib/build.bat) | *none* | &nbsp; | Windows only |
| [`make.exe`][make_cli] | [`Makefile`](./fib/Makefile) | [`Makefile.inc`](./Makefile.inc) | Any <sup><b>a)</b></sup> |
<div style="font-size:80%;">
<sup><b>a)</b></sup> Here "Any" means "tested on Windows, Cygwin, MSYS2 and UNIX".<br/>&nbsp;
</div>

> **&#9755;** **You're warned !!**<br/>
> The following projects differ from those presented in document [`examples\README.md`](../examples/README.md) in two important ways :
> 1. We invoke ***directly*** the 3 C++ compilers [Clang][clang_cli], [GCC][gcc_cli] and [MSVC][msvc_cli], i.e. we do not rely on tools such as [CMake][cmake_cli], [GNU Make][make_cli] or [MSBuild][msbuild_cli] to manage the build configurations.
> 1. When working with [Clang][clang_cli] and [MSVC][msvc_cli] we need to add the[`Pthreads-win32`][pthreads_win32] library as an external dependency to support POSIX threads on Windows.
>
> Concretely, we impose ourselves the delicate exercise of managing all the compiler options by hand.<br/>**NB.** This exercise is of course only realistic for small projects (in our case "demo" projects).

## <span id="fib">`fib`</span>

This example comes from GitHub repository [`microsoft/vscode-cpptols`](https://github.com/microsoft/vscode-cpptools/tree/main/Code%20Samples) and consists of the source files [`src\main\cpp\main.cpp`](./fib/src/main/cpp/main.cpp), [`src\main\cpp\thread.h`](./fib/src/main/cpp/thread.h) and [`src\main\cpp\thread.cpp`](./fib/src/main/cpp/thread.cpp).

Batch file [`build.bat`](./fib/build.bat) matches what the user would run from the command prompt (use option `-debug` to see the execution details). We give one the options `-clang`, `-gcc` or `-msvc` to specify the C++ compiler :

<pre style="font-size:80%;">
<b>&gt; <a href="fib/build.bat">build</a> -verbose clean compile</b>
Delete directory "target"
Toolset: GCC
Compile 2 C++ source files to directoy "target"
&nbsp;
<b>&gt; <a href="fib/build.bat">build</a> -verbose -clang clean compile</b>
Delete directory "target"
Toolset: Clang
Compile 2 C++ source files to directoy "target"
Copy file "pthreadVC2.dll" to directory "target"
&nbsp;
<b>&gt; <a href="fib/build.bat">build</a> -verbose -msvc clean compile</b>
Delete directory "target"
Toolset: MSVC
Compile 2 C++ source files to directoy "target"
Copy file "pthreadVC2.dll" to directory "target"
</pre>

> **:mag_right:** DLL file `pthreadVC2.dll` of the [`Pthreads-win32`][pthreads_win32] external library is copied to the output directory when specifying option `-clang` or `-msvc` : 
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b build\Release</b>
> fib.exe
> pthreadVC2.dll
> </pre>

## <span id="myTurn">`myTurn`</span>

This example comes from the YouTube video [*How to create and join threads in C*](https://www.youtube.com/watch?v=uA8X5zNOGw8) from Jacob Sorber and consists of the single source file [`src\main\cpp\threads.cpp`](./fib/src/main/cpp/threads.cpp).

We run [`make.exe`][make_cli] which reads the build configuration from file [`Makefile`](./myTurn/Makefile). We give to variable `TOOLSET` one of the values `clang`, `gcc` or `msvc` to specify the C++ compiler :

<pre style="font-size:80%;">
<b>&gt; <a href="https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_node/make_86.html">make</a> TOOLSET=gcc clean run</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"C:/opt/msys64/mingw64/bin/g++.exe"  --std=c++17 -O2\
 -lpthread -Wall -Wno-unused-variable -Wno-unused-but-set-variable\
 -o build/Release/myTurn.exe src/main/cpp/threads.cpp
build/Release/myTurn.exe
My Turn! 1/8
Your Turn! 1/3
My Turn! 2/8
My Turn! 3/8
My Turn! 4/8
Your Turn! 2/3
My Turn! 5/8
My Turn! 6/8
Your Turn! 3/3
My Turn! 7/8
My Turn! 8/8
&nbsp;
<b>&gt; <a href="https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_node/make_86.html">make</a> TOOLSET=clang clean run</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"$(LLVM_HOME)/bin/clang.exe"  --std=c++17 -O2\
 -D_TIMESPEC_DEFINED -I"../pthreads-win32/include"\
 -L"../pthreads-win32/lib/x64" -lpthreadVC2 -Wall -Wno-unused-variable\
 -o build/Release/myTurn.exe src/main/cpp/threads.cpp
"C:/opt/msys64/usr/bin/cp.exe" "../pthreads-win32/dll/x64/pthreadVC2.dll" "build/Release/"
build/Release/myTurn.exe
My Turn! 1/8
Your Turn! 1/3
My Turn! 2/8
My Turn! 3/8
Your Turn! 2/3
My Turn! 4/8
My Turn! 5/8
Your Turn! 3/3
My Turn! 6/8
My Turn! 7/8
My Turn! 8/8
&nbsp;
<b>&gt; <a href="https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_node/make_86.html">make</a> TOOLSET=msvc clean run</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"$(MSVC_HOME)/bin/Hostx64/x64/cl.exe"  -nologo -std:c++17 -EHsc\
 -I"$(MSVC_HOME)/include" -I"$(WINSDK_HOME)/include/10.0.22000.0/ucrt"\
 -I"$(WINSDK_HOME)/include/10.0.22000.0/um"\
 -D_TIMESPEC_DEFINED -I"../pthreads-win32/include" -Fo"build/"\
 -Fe"build/Release/myTurn.exe" src/main/cpp/threads.cpp\
 -link -libpath:"$(MSVC_HOME)/lib/x64" -libpath:"$(WINSDK_HOME)/lib/10.0.22000.0/ucrt/x64"\
 -libpath:"$(WINSDK_HOME)/lib/10.0.22000.0/um/x64"\
 -defaultlib:"../pthreads-win32/lib/x64/pthreadVC2" -machine:x64
threads.cpp
"C:/opt/msys64/usr/bin/cp.exe" "../pthreads-win32/dll/x64/pthreadVC2.dll" "build/Release/"
build/Release/myTurn.exe
My Turn! 1/8
Your Turn! 1/3
My Turn! 2/8
My Turn! 3/8
Your Turn! 2/3
My Turn! 4/8
My Turn! 5/8
Your Turn! 3/3
My Turn! 6/8
My Turn! 7/8
My Turn! 8/8
</pre>


## <span id="pThreadDemo">`pThreadDemo`</span>

This example comes from the YouTube video [*Using Pthread In Windows*](https://www.youtube.com/watch?v=TearrHVpGcE) and consists of the single source file [`src\main\cpp\pThreadDemo.cpp`](./pThreadDemo/src/main/cpp/pThreadDemo.cpp).

Batch file [`build.bat`](./pThreadDemo/build.bat) matches what the user would run from the command prompt (use option `-debug` to see the execution details). We give one the options `-clang`, `-gcc` or `-msvc` to specify the C++ compiler :

<pre style="font-size:80%;">
<b>&gt; <a href="./pThreadDemo/build.bat">build</a> -verbose -gcc clean run</b>
Delete directory "target"
Toolset: GCC
Compile 1 C++ source file to directory "target"
Execute "target\pThreadDemo.exe"
Creating thread 0
Creating thread 1
Creating thread 2
Creating thread 3
Creating thread 4
&nbsp;
<b>&gt; <a href="./pThreadDemo/build.bat">build</a> -verbose -clang clean run</b>
Delete directory "target"
Toolset: Clang
Compile 1 C++ source file to directory "target"
Copy file "pthreadVC2.dll" to directory "target"
Execute "target\pThreadDemo.exe"
Creating thread 0
Creating thread 1
Creating thread 2
Creating thread 3
Creating thread 4
&nbsp;
<b>&gt; <a href="./pThreadDemo/build.bat">build</a> -verbose -msvc clean run</b>
Delete directory "target"
Toolset: MSVC
Compile 1 C++ source file to directory "target"
Copy file "pthreadVC2.dll" to directory "target"
Execute "target\pThreadDemo.exe"
Creating thread 0
Creating thread 1
Creating thread 2
Creating thread 3
Creating thread 4
</pre>

<!--
## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> ***Batch files and coding conventions*** [↩](#anchor_01)

<dl><dd>
See section 4 "Tweak the &lt;thread&gt; C++ header" in blog post <a href="http://hectorhon.blogspot.com/2018/05/building-libpqxx-on-msys2-mingw-64-bit.html" rel="external"><i>Building libpqxx on MSYS2 MinGW 64 bit</i></a>.
</dd></dl>
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2022* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[clang_cli]: https://clang.llvm.org/docs/ClangCommandLineReference.html#introduction
[cmake_cli]: https://cmake.org/cmake/help/latest/manual/cmake.1.html
[gcc_cli]: https://man7.org/linux/man-pages/man1/g++.1.html
[make_cli]: https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_node/make_86.html
[msbuild_cli]: https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-command-line-reference
[msvc_cli]: https://docs.microsoft.com/en-us/cpp/build/reference/compiler-command-line-syntax
[pthreads_win32]: https://sourceware.org/pthreads-win32/
