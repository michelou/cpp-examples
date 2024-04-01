# <span id="top">Modernes C++ Examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://isocpp.org/" rel="external"><img src="../docs/images/cpp_logo.png" width="100" alt="C++ project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <a href="."><strong><code>grimm-examples\</code></strong></a> contains <a href="https://isocpp.org/" rel="external" title="ISO C++">ISO C++</a> code examples coming from Grimm's training website <a href="https://www.modernescpp.com/" rel="external">Modernes C++</a>.<br/>
  It also includes build scripts (<a href="https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_01.html" rel="external">bash scripts</a>, <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) for experimenting with <a href="https://isocpp.org/" rel="external">C++</a> on a Windows machine.
  </td>
  </tr>
</table>

The code examples presented below can be built/run with the following command line tools:

| Build&nbsp;tool | Build&nbsp;file | Parent&nbsp;file | Environment(s) |
|:----------------|:----------------|:-----------------|:---------------|
| [**`cmd.exe`**][cmd_cli] | [`build.bat`](./templateMethod/build.bat) | &nbsp; | Windows only |
| [**`make.exe`**][make_cli] | [`Makefile`](./templateMethod/Makefile) | [`Makefile.inc`](./Makefile.inc) | Any <sup><b>a)</b></sup> |
| [**`sh.exe`**][sh_cli] | [`build.sh`](./templateMethod/build.sh) | &nbsp; | Any <sup><b>a)</b></sup> |
<div style="margin:0 0 0 10px;font-size:80%;">
<sup><b>a)</b></sup> Here "Any" means "tested on Windows, Cygwin, MSYS2 and UNIX".<
</div>

## <span id="templateMethod">`templateMethod` Example</span>

Source file [`templateMethod.cpp`](./templateMethod/src/main/cpp/templateMethod.cpp).

<pre style="font-size:80%;">
<b>&gt; <a href="./templateMethod/build.bat">build</a> -verbose clean run</b>
Toolset: MSVC/MSBuild, Project: templateMethod
Configuration: Release, Platform: x64
Generate configuration files into directory "build"
Generate executable "templateMethod.exe"
Execute "build\Release\templateMethod.exe"

readData
sortData
writeData


sortData
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.gnu.org/software/make/manual/html_node/Running.html">make</a> TOOLSET=clang clean run</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"C:/opt/LLVM-15.0.6/bin/clang.exe"  --std=c++17 -O2 -Wall -Wno-unused-variable  -o build/Release/templateMethod.exe src/main/cpp/templateMethod.cpp
build/Release/templateMethod.exe
&nbsp;
readData
[.. <i>(same output)</i> ..]
</pre>

## <span id="visitor">`visitor` Example</span> [**&#x25B4;**](#top)

Source file [`visitor.cpp`](./visitor/src/main/cpp/visitor.cpp).

<pre style="font-size:80%;">
<b>&gt; <a href="./visitor/build.bat">build</a> -verbose clean run</b>
Toolset: MSVC/MSBuild, Project: visitor
Configuration: Release, Platform: x64
Generate configuration files into directory "build"
Generate executable "visitor.exe"
Execute "build\Release\visitor.exe"

Visiting engine
Visiting front left wheel
Visiting front right wheel
Visiting back left wheel
Visiting back right wheel
Visiting body
Visiting engine
Visiting car

Starting my engine
Kicking my front left wheel
Kicking my front right wheel
Kicking my back left wheel
Kicking my back right wheel
Moving my body
Starting my engine
Starting my car
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.gnu.org/software/make/manual/html_node/Running.html">make</a> TOOLSET=gcc clean run</b>
C:/opt/msys64/usr/bin/rm.exe -rf "build"
"C:/opt/msys64/mingw64/bin/g++.exe"  --std=c++17 -O2 -Wall -Wno-unused-variable  -o build/Release/visitor.exe src/main/cpp/visitor.cpp
build/Release/visitor.exe

Visiting engine
[.. <i>(same output)</i> ..]
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/April 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[cmd_cli]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
[make_cli]: https://www.gnu.org/software/make/manual/html_node/Running.html
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
