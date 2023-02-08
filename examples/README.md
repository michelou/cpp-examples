# <span id="top">C++ Examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://isocpp.org/" rel="external"><img src="../docs/images/cpp_logo.png" width="100" alt="C++ project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <a href="."><strong><code>examples\</code></strong></a> contains <a href="https://isocpp.org/" rel="external" title="ISO C++">ISO C++</a> code examples coming from various websites - mostly from the <a href="https://isocpp.org/" rel="external" title="ISO C++">C++</a> project.<br/>
  It also includes build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) for experimenting with <a href="https://isocpp.org/" rel="external">C++</a> on a Windows machine.
  </td>
  </tr>
</table>

The code examples presented below can be built/run with the following command line tools:

| Build&nbsp;tool | Configuration file | Parent file | Environment(s) |
|:----------------|:-------------------|:------------|:---------------|
| [`build.bat`](./hello/build.bat) | *none* | &nbsp; | Windows only |
| [`make.exe`][make_cli] | [`Makefile`](./hello/Makefile) | [`Makefile.inc`](./Makefile.inc) | Any <sup><b>a)</b></sup> |
<div style="margin:0 0 0 10px;font-size:80%;">
<sup><b>a)</b></sup> Here "Any" means "tested on Windows, Cygwin, MSYS2 and UNIX".<br/>&nbsp;
</div>

## <span id="hello">`hello` Example</span>

This example consists of one source file [`src\main.cpp`](./hello/src/main.cpp).

Command [**`build.bat`**](./hello/build.bat) invokes one of four C++ compilers to generate executable `hello.exe` using the options `-clang`, `-gcc`, `-icx` or `-msvc` :

<pre style="font-size:80%;">
<b>&gt; <a href="./hello/build.bat">build</a> -clang -verbose clean compile</b>
Delete directory "build"
Toolset: Clang/GNU Make, Project: hello
Generate configuration files into directory "build"
Generate executable "hello.exe"
</pre>

In the same way command [`make.exe`][make_cli] reads the hand-written [`Makefile`](./hello/Makefile) and invokes one of four C++ compilers to generate executable `hello.exe` using variable `TOOLSET`, e.g. `TOOLSET=clang` (or [`gcc`][gcc_cmd], `icx`, `msvc`) :

<pre style="font-size:80%;">
<b>&gt; <a href="">make</a> TOOLSET=clang clean build</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"C:/opt/LLVM-15.0.6//bin/clang.exe"  --std=c++17 -O2 -Wall -Wno-unused-variable  -o build/Release/hello.exe src/main.cpp
&nbsp;
<b>&gt; <a href="">make</a> TOOLSET=icx clean build</b>
"C:/opt/msys64/usr/bin/rm.exe" -rf "build"
"C:/Program Files (x86)/Intel/oneAPI//compiler/latest/windows/bin/icx.exe"  -nologo -Qstd=c++17 -O2 -Wall -Wno-unused-variable  -o build/Release/hello.exe src/main.cpp -link -libpath:"C:/Program Files (x86)/Intel/oneAPI//compiler/latest/windows/compiler/lib/intel64"
</pre>

## <span id="call-by-copy">`call-by-copy` Example</span> [**&#x25B4;**](#top)

This example comes from [stackoverflow] post [*What is object slicing?*](https://stackoverflow.com/questions/274626/what-is-object-slicing) and consists of one source file [`src\main\cpp\Main.cpp`](./call-by-copy/src/main/cpp/Main.cpp).

Command [**`build.bat`**](./call-by-copy/build.bat) invokes one of four C++ compilers to generate executable `call-by-copy.exe` using the options `-clang`, `-gcc`, `icx` or `-msvc` :

<pre style="font-size:80%;">
<b>&gt; <a href="./call-by-copy/build.bat">build</a> -msvc -verbose clean compile</b>
Delete directory "build"
Toolset: MSVC/MSBuild, Project: call-by-copy
Configuration: Release, Platform: x64
Generate configuration files into directory "build"
Generate executable "call-by-copy.exe"
</pre>

In the same way command [`make.exe`][make_cli] invokes one of four C++ compilers to generate executable `call-by-copy.exe` using variable `TOOLSET`, e.g. `TOOLSET=msvc` (or `clang`, `gcc`, `icx`) :

<pre style="font-size:80%;">
<b>&gt; <a href="">make</a> TOOLSET=msvc clean build</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"%MSVC_HOME%/bin\Hostx64/x64/cl.exe"  -nologo -std:c++17 -EHsc -I"%MSVC_HOME%/include" -I"%WINSDK_HOME%/include/10.0.22000.0/ucrt" -I"%WINSDK_HOME%/include/10.0.22000.0/um"  -Fe"build/Release/call-by-copy.exe" src/main/cpp/Main.cpp -link -libpath:"%MSVC_HOME%/lib/x64" -libpath:"%WINSDK_HOME%/lib/10.0.22000.0/ucrt/x64" -libpath:"%WINSDK_HOME%/lib/10.0.22000.0/um/x64" Main.cpp
</pre>

## <span id="class-dispatching">`class-dispatching` Example</span>

This example consists of one source file [`src\main\cpp\Main.cpp`](./class-dispatching/src/main/cpp/Main.cpp).

Command [`build.bat`](./class-dispatching/build.bat) invokes one of four C++ compilers to generate executable `class-dispatching.exe` using the options `-clang`, `-gcc`, `-icx` or `-msvc`.

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

## <span id="move-constructor">`move-constructor` Example</span> [**&#x25B4;**](#top)

This example comes from [INVIVOO] post "[A la redécouverte du C++ : &amp;&amp; et std::mov](https://blog.invivoo.com/decouverte-du-cplusplus-et-stdmove/)" and consists of one source file [`src\main\cpp\Main.cpp`](./move-constructor/src/main/cpp/Main.cpp).

Command [`build.bat`](./move-constructor/build.bat) invokes one of four C++ compilers to generate executable `move-constructor.exe` using the options `-clang`, `-gcc`, `-icx` or `-msvc` :

<pre style="font-size:80%;">
<b>&gt; <a href="./move-constructor/build.bat">build</a> -clang -verbose clean compile</b>
Delete directory "build"
Toolset: Clang/GNU Make, Project: move-constructor
Generate configuration files into directory "build"
Generate executable "move-constructor.exe"
</pre>

In the same way command [`make.exe`][make_cli] reads the hand-written [`Makefile`](./move-constructor/Makefile) and invokes one of four C++ compilers to generate executable `move-constructor.exe` using variable `TOOLSET`, e.g. `TOOLSET=clang` (or [`gcc`][gcc_cmd], `icx`, `msvc`) :

<pre style="font-size:80%;">
<b>&gt; <a href="">make</a> TOOLSET=clang clean build</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"C:/opt/LLVM-15.0.6//bin/clang.exe"  --std=c++17 -O2 -Wall -Wno-unused-variable  -o build/Release/move-constructor.exe src/main/cpp/Main.cpp
</pre>

## <span id="tuple-iterators">`tuple-iterators` Example</span>

This example consists of one source file [`src\main\cpp\Main.cpp`](./tuple-iterators/src/main/cpp/Main.cpp).

Command [`build.bat`](./tuple-iterators/build.bat) invokes one of four C++ compilers to generate executable `tuple-iterators.exe` using the options `-clang`, `-gcc`, `-icx` or `-msvc` :

<pre style="font-size:80%;">
<b>&gt; <a href="./tuple-iterators/build.bat">build</a> -gcc -verbose clean compile</b>
Delete directory "build"
Toolset: GCC/GNU Make, Project: tuple-iterators
Generate configuration files into directory "build"
Generate executable "tuple-iterators.exe"
</pre>

In the same way command [`make.exe`][make_cli] invokes one of four C++ compilers to generate executable `tuple-iterators.exe` using variable `TOOLSET`, e.g. `TOOLSET=gcc` (or `clang`, `icx`, `msvc`) :

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.gnu.org/software/make/manual/html_node/Running.html" rel="external">make</a> TOOLSET=gcc clean build</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"C:/opt/msys64/mingw64/bin/g++.exe"  --std=c++17 -O2 -Wall -Wno-unused-variable  -o build/Release/tuple-iterators.exe src/main/cpp/Main.cpp
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/February 2023* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[bazel_cli]: https://bazel.build/reference/command-line-reference
[gcc_cmd]: https://gcc.gnu.org/onlinedocs/gcc/Invoking-GCC.html
[invivoo]: https://www.invivoo.com/
[make_cli]: https://www.gnu.org/software/make/manual/html_node/Running.html
[stackoverflow]: https://stackoverflow.com/
