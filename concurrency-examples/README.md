# <span id="top">Book <i>Concurrency with Modern C++</i></span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://isocpp.org/" rel="external"><img src="../docs/images/cpp_logo.png" width="120" alt="C++ project"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <a href="."><b><code>concurrency-examples\</code></b></a> contains <a href="https://isocpp.org/" alt="C++">C++</a> code examples from the book <a href="https://leanpub.com/concurrencywithmodernc" rel="external">Concurrency with Modern C++</a> by Rainer Grimm (Leanpub, 2023).<br/>
  It also includes several build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_01.html" rel="external">bash scripts</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) for running the example on a Windows machine.
  </td>
  </tr>
</table>

## <span id="acquireConsume">`acquireConsume` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./acquireConsume/build.bat">build.bat</a>
|   <a href="./acquireConsume/build.sh">build.sh</a></a>
|   <a href="./acquireConsume/CMakeLists.txt">CMakeLists.txt
|   <a href="./acquireConsume/Doxyfile">Doxyfile</a>
|   <a href="./acquireConsume/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>cpp</b>
                <a href="./acquireConsume/src/main/cpp/acquireConsume.cpp">acquireConsume.cpp</a>
</pre>

Command [`build.bat`](./acquireConsume/build.bat)`run` generates and executes the C++ program `target\acquireConsume.exe` (with options `-bcc`, `-clang`, `-gcc`, `-icx` and `-msvc` to specify a compiler).

<pre style="font-size:80%;">
<b>&gt; <a href="./acquireConsume/build.bat">build</a> -verbose -gcc run</b>
Toolset: GCC/GNU Make, Project: acquireConsume
Generate configuration files into directory "build"
Generate executable "acquireConsume.exe"
Execute "build\acquireConsume.exe"

*p2: C++11
data: 2011
atoData: 2014
</pre>

One may also run  command [`make`](https://linux.die.net/man/1/make)`run` :

<pre style="font-size:80%;">
<b>&gt; <a href="https://linux.die.net/man/1/make">make</a> clean run</b>
"C:/opt/msys64/usr/bin/rm.exe" -rf "build"
"C:/opt/msys64/mingw64/bin/g++.exe"  --std=c++17 -O2 -Wall -Wno-unused-variable  -o build/Release/acquireConsume.exe src/main/cpp/acquireConsume.cpp
build/Release/acquireConsume.exe

*p2: C++11
data: 2011
atoData: 2014
</pre>

## <span id="fetch_mult">`fetch_mult` Example</span> [**&#x25B4;**](#top)

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./fetch_mult/build.bat">build.bat</a>
|   <a href="./fetch_mult/CMakeLists.txt">CMakeLists.txt</a>
|   <a href="./fetch_mult/Makefile">Makefile</a>
\---<b>src</b>
    \---main</b>
        \---cpp</b>
                <a href="./fetch_mult/src/fetch_mult.cpp">fetch_mult.cpp</a>
</pre>

Command [`build.bat`](./fetch_mult/build.bat)`-verbose clean run` (with options `-clang`, `-gcc`, `-icx` and `-msvc`) generates and executes the program `build\Release\fetch_mult.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="./fetch_mult/build.bat">build</a> -verbose clean run</b>
Delete directory "build"
Toolset: MSVC/MSBuild, Project: fetch_mult
Configuration: Release, Platform: x64
Generate configuration files into directory "build"
Generate executable "fetch_mult.exe"
Execute "build\Release\fetch_mult.exe"
5
25
</pre>

Command [`make`]()`TOOLSET=icx clean run` generates and executes the program `build\Release\fetch_mult.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="https://linux.die.net/man/1/make">make</a> TOOLSET=icx clean run</b>
"C:/opt/msys64/usr/bin/rm.exe" -rf "build"
"C:/Program Files (x86)/Intel/oneAPI//compiler/latest/windows/bin/icx.exe"  -Qstd=c++17 -O2 -Fe"build/Release/fetch_mult.exe"  -o build/Release/fetch_mult.exe src/main/cpp/fetch_mult.cpp -link -libpath:"X:/VC/Tools/MSVC/14.36.32532//lib/x64" -libpath:"C:/Program Files (x86)/Windows Kits/10/lib/10.0.22000.0/ucrt/x64" -libpath:"C:/Program Files (x86)/Windows Kits/10/lib/10.0.22000.0/um/x64" -libpath:"C:/Program Files (x86)/Intel/oneAPI//compiler/latest/windows/compiler/lib" -libpath:"C:/Program Files (x86)/Intel/oneAPI//compiler/latest/windows/compiler/lib/intel64"
build/Release/fetch_mult.exe
5
25
</pre>

## <span id="transitivity">`transitivity` Example</span> [**&#x25B4;**](#top)

This example has the following directory structure :

<pre style="font-size:80%;">
<b&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./transitvity/build.bat">build.bat</a>
|   <a href="./transitvity/CMakeLists.txt">CMakeLists.txt</a>
|   <a href="./transitvity/Makefile">Makefile</a>
\---src
    \--<b>-main</b>
        \---<b>cpp</b>
                <a href="./transitivity.cpp`](./transitivity/src/transitivity.cpp">transitivity.cpp</a>
</pre>

Command [`build.bat`](./transitivity/build.bat)`-verbose clean run` (with options `-bcc`, `-clang`, `-gcc`, `-icx` and `-msvc`) generates and executes the program `build\Release\transitivity.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="./transitivity/build.bat">build</a> -verbose clean run</b>
Delete directory "build"
Toolset: MSVC/MSBuild, Project: transitivity
Configuration: Release, Platform: x64
Generate configuration files into directory "build"
Generate executable "transitivity.exe"
Execute "build\Release\transitivity.exe"

1 2 3
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- href links -->
