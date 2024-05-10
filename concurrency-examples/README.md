# <span id="top">Book <i>Concurrency with Modern C++</i></span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

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

This example consists of source file [`acquireConsume.cpp`](./acquireConsume/src/main/cpp/acquireConsume.cpp) and build script [`build.bat`](./acquireConsume/build.bat) (with options `-bcc`, `-clang`, `-gcc`, `-icx` and `-msvc`).

<pre style="font-size:80%;">
<b>&gt; <a href="./acquireConsume/build.bat">build</a> -verbose -gcc run</b>
Toolset: GCC/GNU Make, Project: acquireConsume
Generate configuration files into directory "build"
Generate executable "acquireConsume.exe"
Execute "build\acquireConsume.exe"

*p2: C++11
data: 2011
atoData: 2014
&nbsp;
<b>&gt; <a href="https://linux.die.net/man/1/make">make</a> clean run</b>
"C:/opt/msys64/usr/bin/rm.exe" -rf "build"
"C:/opt/msys64/mingw64/bin/g++.exe"  --std=c++17 -O2 -Wall -Wno-unused-variable  -o build/Release/acquireConsume.exe src/main/cpp/acquireConsume.cpp
build/Release/acquireConsume.exe

*p2: C++11
data: 2011
atoData: 2014
</pre>

## <span id="fetch_mult">`fetch_mult` Example</span>

This example consists of source file [`fetch_mult.cpp`](./fetch_mult/src/fetch_mult.cpp) and build script [`build.bat`](./fetch_mult/build.bat) (with options `-clang`, `-gcc`, `-icx` and `-msvc`).

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
&nbsp;
<b>&gt; <a href="https://linux.die.net/man/1/make">make</a> TOOLSET=icx clean run</b>
"C:/opt/msys64/usr/bin/rm.exe" -rf "build"
"C:/Program Files (x86)/Intel/oneAPI//compiler/latest/windows/bin/icx.exe"  -Qstd=c++17 -O2 -Fe"build/Release/fetch_mult.exe"  -o build/Release/fetch_mult.exe src/main/cpp/fetch_mult.cpp -link -libpath:"X:/VC/Tools/MSVC/14.36.32532//lib/x64" -libpath:"C:/Program Files (x86)/Windows Kits/10/lib/10.0.22000.0/ucrt/x64" -libpath:"C:/Program Files (x86)/Windows Kits/10/lib/10.0.22000.0/um/x64" -libpath:"C:/Program Files (x86)/Intel/oneAPI//compiler/latest/windows/compiler/lib" -libpath:"C:/Program Files (x86)/Intel/oneAPI//compiler/latest/windows/compiler/lib/intel64"
build/Release/fetch_mult.exe
5
25
</pre>

## <span id="transitivity">`transitivity` Example</span>

This example consists of source file [`transitivity.cpp`](./transitivity/src/transitivity.cpp) and build script [`build.bat`](./transitivity/build.bat) (with options `-bcc`, `-clang`, `-gcc`, `-icx` and `-msvc`).

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

*[mics](https://lampwww.epfl.ch/~michelou/)/May 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- href links -->
