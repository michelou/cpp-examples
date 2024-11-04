# <span id="top">Playing with C++ on Windows</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://isocpp.org/" rel="external"><img src="docs/images/cpp_logo.png" width="100" alt="ISO C++ project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://isocpp.org/" rel="external" title="ISO C++">C++</a> code examples coming from various websites and books.<br/>
  It also includes build scripts (<a href="https://www.gnu.org/software/bash/manual/bash.html" rel="external">bash scripts</a>, <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) for experimenting with <a href="https://isocpp.org/" rel="external">C++</a> on a Windows machine.</td>
  </tr>
</table>

[Ada][ada_examples], [Akka][akka_examples], [COBOL][cobol_examples], [Dafny][dafny_examples], [Dart][dart_examples], [Deno][deno_examples], [Docker][docker_examples], [Erlang][erlang_examples], [Flix][flix_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kafka][kafka_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Modula-2][m2_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples], [WiX Toolset][wix_examples] and [Zig][zig_examples] are other topics we are continuously investigating.

> **&#9755;** Read the document <a href="https://www.geeksforgeeks.org/history-of-c/" rel="external">"History of C++"</a> to get a quick overview of the evolution of C++.

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [CMake 3.31][cmake_downloads] ([*release notes*][cmake_relnotes])
- [Git 2.47][git_releases] ([*release notes*][git_relnotes])
- [LLVM 17][llvm_downloads] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][llvm_relnotes])
- [MSYS2 2024][msys2_downloads] <sup id="anchor_01">[1](#footnote_01)</sup> <sup id="anchor_02">[2](#footnote_02)</sup> ([*changelog*][msys2_changelog])
- [oneAPI DPC++ 2024][intel_dpc] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][intel_dpc_relnotes])
- [Visual Studio Community 2019][vs2019_downloads] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][vs2019_relnotes])
- [Windows SDK 10][winsdk_downloads] ([*release notes*][winsdk_relnotes])

Optionally one may also install the following software:
<!--
- [Cppcheck 2.12][cppcheck_downloads] <sup id="anchor_03">[3](#footnote_03)</sup> ([*changelog*][cppcheck_changelog])
-->
- [Bazel 7.4 LTS][bazel_downloads] ([*release notes*][bazel_relnotes])
- [ConEmu 2023][conemu_downloads] ([*release notes*][conemu_relnotes])
- [Doxygen 1.12][doxygen_downloads] ([*changelog*][doxygen_changelog])
- [Embarcadero C++ 7.30 Compiler][bcc_downloads]
- [LLVM 19][llvm_19_downloads] ([*release notes*][llvm_19_relnotes])
- [OrangeC 6.73][orangec_downloads] ([*release notes*][orangec_relnotes])
- [Visual Studio Code 1.95][vscode_downloads] ([*release notes*][vscode_relnotes])
- [Visual Studio Community 2022][vs2022_downloads] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][vs2022_relnotes])

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a [Windows installer][windows_installer]. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][unix_opt] directory on Unix).

For instance our development environment looks as follows (*November 2024*) <sup id="anchor_03">[3](#footnote_03)</sup>:

<pre style="font-size:80%;">
C:\opt\bazel\                            <i>( 51 MB)</i>
C:\opt\BCC-10.2\                         <i>(194 MB)</i>
C:\opt\cmake\                            <i>(112 MB)</i>
C:\opt\ConEmu\                           <i>( 26 MB)</i>
C:\opt\doxygen\                          <i>(120 MB)</i>
C:\opt\Git\                              <i>(367 MB)</i>
C:\opt\LLVM-17.0.6\                      <i>(3.1 GB)</i>
C:\opt\LLVM-19.1.3\                      <i>(2.0 GB)</i>
C:\opt\msys64\                           <i>(2.8 GB)</i>
C:\opt\orangec\                          <i>( 74 MB)</i>
C:\opt\VSCode\                           <i>(341 MB)</i>
C:\Program Files\Microsoft Visual Studio\2022\Community\        <i>(4.4 GB)</i>
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\  <i>(4.2 GB)</i>
C:\Program Files (x86)\Intel\oneAPI\     <i>(3.3 GB)</i>
C:\Program Files (x86)\Windows Kits\10\  <i>(6.7 GB)</i>
</pre>
<!--
c:\Program Files\Cppcheck\               <i>( 35 MB)</i>
-->

> **:mag_right:** [Git for Windows][git_releases] provides a BASH emulation used to run [**`git.exe`**][git_docs] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

## <span id="structure">Directory structure</span> [**&#x25B4;**](#top)

This project is organized as follows:
<pre style="font-size:80%;">
bin\
concurrency-examples\{<a href="concurrency-examples/README.md">README.md</a>, <a href="concurrency-examples/acquireConsume/">acquireConsume</a>, etc.}
dmc3-examples\{<a href="dmc3-examples/README.md">README.md</a>, <a href="dmc3-examples/cpp20_algebraic_concepts">cpp20_algebraic_concepts</a>, etc.}
docs\
examples\{<a href="examples/README.md">README.md</a>, <a href="examples/call-by-copy/">call-by-copy</a>, <a href="examples/class-dispatching/">class-dispatching</a>, etc.}
grimm-examples\{<a href="grimm-examples/README.md">README.md</a>, <a href="grimm-examples/templateMethod/">templateMethod</a>, <a href="grimm-examples/visitor/">visitor</a>, etc.}
gui-examples\{<a href="gui-examples/README.md">README.md</a>, <a href="gui-examples/simple-window/">simple-window</a>, etc.}
pthreads-examples\{<a href="pthreads-examples/README.md">README.md</a>, <a href="pthreads-examples/fib/">fib</a>, <a href="pthreads-examples/myTurn/">myTurn</a>, etc.}
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="setenv.bat">setenv.bat</a>
</pre>

where

- directory [**`bin\`**](bin/) contains utility tools.
- directory [**`concurreny-examples`**](concurrency-examples/) contains [C++][cpp_lang] code examples from Grimm's book (see [`README.md`](concurrency-examples/README.md) file).
- directory [**`docs\`**](docs/) contains [C++][cpp_lang] related papers/articles.
- directory [**`examples\`**](mastering-rust/) contains [C++][cpp_lang] code examples (see [`README.md`](examples/README.md) file).
- directory [**`grimm-examples`**](grimm-examples/) contains [C++][cpp_lang] code examples from Grimm's website (see [`README.md`](grimm-examples/README.md) file).
- directory [**`gui-examples`**](gui-examples/) contains [C++][cpp_lang] code examples depending on the [Win32 API][win32_api].
- directory [**`pthreads-examples\`**](pthreads-examples/) contains [C++][cpp_lang] code examples (see [`README.md`](pthreads-examples/README.md) file).
- file **`README.md`** is the [Markdown][github_markdown] document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) is the [Markdown][github_markdown] document presenting external resources.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

<!--
We also define a virtual drive **`R:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> R: <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\workspace\rust-examples</b>
> </pre>
-->

## <span id="commands">Batch commands</span> [**&#x25B4;**](#top)

### **`setenv.bat`** <sup id="anchor_04">[4](#footnote_04)</sup>

We execute command [**`setenv`**](setenv.bat) once to setup our development environment; it makes external tools such as [**`bazel.exe`**][bazel_cli], [**`git.exe`**][git_cli] and [**`sh.exe`**][sh_cli] directly available from the command prompt.

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a></b>
Tool versions:
   bazel 7.4.0, bcc32c 7.30, clang 17.0.6, gcc 13.2.0, icx 2024.2.1, occ 6.73.8
   cmake 3.31.0, cl 19.36.33523, cppcheck 2.15.0, doxygen 1.12.0, msbuild 17.11.2.32701
   git 2.47.0, diff 3.10, bash 5.2.37(1)

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> bazel git sh</b>
C:\opt\bazel\bazel.exe
C:\opt\Git\bin\git.exe
C:\opt\Git\mingw64\bin\git.exe
C:\opt\Git\bin\sh.exe
C:\opt\msys64\usr\bin\sh.exe
C:\opt\Git\usr\bin\sh.exe
</pre>

Command [**`setenv help`**](./setenv.bat) displays the help messsage :

<pre style="font-size:80%;">
<b>&gt; <a href="./setenv.bat">setenv help</a></b>
Usage: setenv { &lt;option> | &lt;subcommand> }
&nbsp;
  Options:
    -bash       start Git bash shell instead of Windows command prompt
    -debug      print commands executed by this script
    -verbose    print progress messages
&nbsp;
  Subcommands:
    help        print this help message
</pre>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***C++ Compilers*** [↩](#anchor_01)

<dl><dd>
The installed development tools for Windows give us access to the following C++ compilers:
</dd>
<dd>
<table>
<tr><th>Devtool</th><th>C++&nbsp;Compiler</th><th>Version</th><th>ISO Standards <sup><b>a)</b></sup></th></tr>
<tr><td><a href="https://www.embarcadero.com">Embarcadero</a></td><td><a href="https://www.embarcadero.com/free-tools/ccompiler"><code><b>bcc32c.exe</b></code></a></td><td>7.30</td><td>11</td></tr>
<tr><td><a href="https://llvm.org/">LLVM</a></td><td><a href="https://clang.llvm.org/docs/UsersManual.html#basic-usage"><code><b>clang.exe</b></code></a></td><td><a href="https://discourse.llvm.org/t/llvm-17-0-6-released/75281">17.0.x</a</td><td><a href="https://clang.llvm.org/cxx_status.html">98, 11, 14, 17, 20, 2b</a> <sup><b>b)</b></sup></td></tr>
<tr><td><a href="https://visualstudio.microsoft.com/">MSVS</a><br/>(Microsoft)</td><td><a href="https://docs.microsoft.com/en-us/cpp/build/reference/compiler-command-line-syntax"><code><b>cl.exe</b></code></a></td><td><a href="https://learn.microsoft.com/en-us/visualstudio/releases/2022/release-notes">19.41.34120</a></td><td><a href="https://docs.microsoft.com/en-us/cpp/build/reference/std-specify-language-standard-version">14, 17, 20</a></td></tr>
<tr><td><a href="https://www.msys2.org/">MSYS2</a></td><td><a href="https://man7.org/linux/man-pages/man1/g++.1.html"><code><b>g++.exe</b></code></a></td><td><a href="https://gcc.gnu.org/gcc-13/" rel="external">13.3.0</a></td><td><a href="https://gcc.gnu.org/projects/cxx-status.html">98, 11, 14, 17, 20, 23</a> <sup><b>b)</b></sup></td></tr>
<tr>
  <td><a href="https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html" rel="external">oneAPI</a><br/>&nbsp;(Intel)</td>
  <td><a href="https://www.intel.com/content/www/us/en/develop/documentation/oneapi-dpcpp-cpp-compiler-dev-guide-and-reference/top/compiler-setup/use-the-command-line/invoke-the-compiler.html"><code><b>icx.exe</b></code></td>
  <td><a href="https://www.intel.com/content/www/us/en/developer/articles/release-notes/intel-oneapi-dpc-c-compiler-release-notes.html" rel="external">2024.2.1</a></td>
  <td><a href="https://www.intel.com/content/www/us/en/develop/documentation/cpp-compiler-developer-guide-and-reference/top/compiler-reference/compiler-options/compiler-option-details/language-options/std-qstd.html" rel="external">11, 14, <b>17</b>, 20</a></td>
</tr>
<tr>
  <td><a href="https://github.com/LADSoft/OrangeC#orangec">OrangeC</a><br/>(LADSoft)</td>
  <td><a href="https://orangec.readthedocs.io/en/latest/occ/OCC%20Command%20Line/"><code><b>occ.exe</b></code></a></td>
  <td><a href="https://github.com/LADSoft/OrangeC/releases/tag/Orange-C-v6.73.1">6.73</a></td>
  <td>11, 14</td>
</tr>
</table>
<div style="margin:0 0 0 10px;font-size:80%;">
<sup><b>a)</b></sup> Standard specified with compiler option, e.g. <code><b>-std=c++17</b></code>; starting with version 2023.0 oneAPI uses C++17 as the default C++ language.<br/>
<sup><b>b)</b></sup> ISO standard 23 <i>partially</i> supported.<br/>
</div>
</dd></dl>

<span id="footnote_02">[2]</span> ***Cppcheck*** [↩](#anchor_02)

<dl><dd>
<a href="https://cppcheck.sourceforge.io" rel="external">Cppcheck</a> for Windows is available either as <a href="https://cppcheck.sourceforge.io/#download">Windows installer</a> or as <a href="https://packages.msys2.org/package/mingw-w64-x86_64-cppcheck" rel="external">MSYS2 package</a>.

Since our project depends on <a href="https://www.msys2.org/" rel="external">MSYS2</a> we choose to install the MSYS2 package <a href="https://packages.msys2.org/package/mingw-w64-x86_64-cppcheck"><code>mingw-w64-x86_64-cppcheck</code></a> :
<pre style="font-size:80%;">
<b>&gt; %MSYS_HOME%\usr\bin\<a href="https://archlinux.org/pacman/" rel="external">pacman.exe</a> -Ss cppcheck</b>
clangarm64/mingw-w64-clang-aarch64-cppcheck 2.15.0-1
    static analysis of C/C++ code (mingw-w64)
mingw64/mingw-w64-x86_64-cppcheck 2.15.0-1 [installed]
    static analysis of C/C++ code (mingw-w64)
ucrt64/mingw-w64-ucrt-x86_64-cppcheck 2.15.0-1
    static analysis of C/C++ code (mingw-w64)
clang64/mingw-w64-clang-x86_64-cppcheck 2.15.0-1
    static analysis of C/C++ code (mingw-w64)
&nbsp;
<b>&gt; %MSYS_HOME%\usr\bin\pacman.exe -Syu <a href="https://packages.msys2.org/package/mingw-w64-x86_64-cppcheck" rel="external">mingw-w64-x86_64-cppcheck</a></b>
:: Synchronizing package databases...
[...]
Packages (10) less-643-1  libgnutls-3.8.1-1  mingw-w64-x86_64-bzip2-1.0.8-2  mingw-w64-x86_64-gcc-13.2.0-2  mingw-w64-x86_64-gcc-ada-13.2.0-2
              mingw-w64-x86_64-gcc-libs-13.2.0-2  mingw-w64-x86_64-headers-git-11.0.0.r107.gd367cc9d7-2  mingw-w64-x86_64-pcre-8.45-1
              mingw-w64-x86_64-wineditline-2.206-1  mingw-w64-x86_64-cppcheck-2.15.0-1

Total Installed Size:  388.66 MiB
Net Upgrade Size:       20.34 MiB

:: Proceed with installation? [Y/n]
:: Retrieving packages...
[...]
&nbsp;
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/where" rel="external">where</a> /r %MSYS_HOME% cppcheck.exe</b>
C:\opt\msys64\mingw64\bin\cppcheck.exe
</pre>
</dd>
<dd>
<blockquote>
<b>Reminder</b>: How we created our MSYS2 installation (installation directory: <code>MSYS_HOME=C:\opt\msys64</code>) :
<table style="font-size:90%;">
<tr style="margin:0;padding:0;"><td><b>Executed&nbsp;command</b></td><td><b>Used&nbsp;size&nbsp;(MB)</b></td></tr>
<tr><td><code><a href="https://repo.msys2.org/distrib/x86_64/">msys2-x86_64-20240727.exe</a></code></td><td>304</td></tr>
<tr><td><code>%MSYS_HOME%\usr\bin\<a href="https://www.msys2.org/docs/package-management/" rel="external">pacman.exe</a> -S make</code></td><td>310</td></tr>
<tr><td><code>%MSYS_HOME%\usr\bin\<a href="https://www.msys2.org/docs/package-management/" rel="external">pacman.exe</a> -S gcc</code></td><td>798</td></tr>
<tr><td><code>%MSYS_HOME%\usr\bin\<a href="https://www.msys2.org/docs/package-management/" rel="external">pacman.exe</a> -S automake</code></td><td>812</td></tr>
<tr><td><code>%MSYS_HOME%\usr\bin\<a href="https://www.msys2.org/docs/package-management/" rel="external">pacman.exe</a> -S mingw-w64-x86_64-cppcheck</code></td><td>843</td></tr>
<tr><td><code>%MSYS_HOME%\usr\bin\<a href="https://www.msys2.org/docs/package-management/" rel="external">pacman.exe</a> -S texinfo</code></td><td>854</td></tr>
<tr><td><i>(to be updated)</i></td><td>..</td></tr>
</table>
</blockquote>
</dd></dl>

<!--=======================================================================-->

<span id="footnote_03">[3]</span> ***Downloads*** [↩](#anchor_03)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="https://github.com/bazelbuild/bazel/releases/">bazel-7.4.0-windows-x86_64.zip</a>                  <i>( 50 MB)</i>
<a href="https://www.embarcadero.com/free-tools/ccompiler" rel="external">BCC102.zip</a> (Embarcadero)                        <i>( 45 MB)</i>
<a href="https://cmake.org/download/">cmake-3.31.0-rc3-windows-x86_64.zip</a>             <i>( 38 MB)</i>
<a href="https://github.com/Maximus5/ConEmu/releases/tag/v23.07.24" rel="external">ConEmuPack.230724.7z</a>                            <i>(  5 MB)</i>
<a href="https://github.com/llvm/llvm-project/releases/tag/llvmorg-17.0.6">LLVM-17.0.6-win64.exe</a>                           <i>(263 MB)</i>
<a href="">LLVM-19.1.3-win64.exe</a>                           <i>(336 MB)</i>
<a href="https://repo.msys2.org/distrib/x86_64/">msys2-x86_64-20240727.exe</a>                       <i>( 86 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.47.0-64-bit.7z.exe</a>                <i>( 46 MB)</i>
<a href="https://code.visualstudio.com/Download#" rel="external">VSCode-win32-x64-1.95.0.zip</a>                     <i>(131 MB)</i>
<a href="https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html#dpcpp-cpp">w_dpcpp-cpp-compiler_p_2024.2.1.83_offline.exe</a>  <i>(1.2 GB)</i>
<a href="https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/">winsdksetup.exe</a>                                 <i>(1.3 MB)</i>
<a href="https://github.com/LADSoft/OrangeC/releases">ZippedBinaries6738.zip</a> (OrangeC)                <i>( 22 MB)</i>
</pre>
</dd></dl>

<span id="footnote_04">[4]</span> **`setenv.bat` *usage*** [↩](#anchor_04)

<dl><dd>
<a href=./setenv.bat><code><b>setenv.bat</b></code></a> has specific environment variables set that enable us to use command-line developer tools more easily.
</dd>
<dd>It is similar to the setup scripts described on the page <a href="https://learn.microsoft.com/en-us/visualstudio/ide/reference/command-prompt-powershell" rel="external">"Visual Studio Developer Command Prompt and Developer PowerShell"</a> of the <a href="https://learn.microsoft.com/en-us/visualstudio/windows" rel="external">Visual Studio</a> online documentation.
</dd>
<dd>
For instance we can quickly check that the two scripts <code><b>Launch-VsDevShell.ps1</b></code> and <code><b>VsDevCmd.bat</b></code> are indeed available in our Visual Studio 2019 installation :
<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/where" rel="external">where</a> /r "C:\Program Files (x86)\Microsoft Visual Studio" *vsdev*</b>
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\Launch-VsDevShell.ps1
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\vsdevcmd\core\vsdevcmd_end.bat
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\vsdevcmd\core\vsdevcmd_start.bat
</pre>
</dd>
<dd>
Concretely, in our GitHub projects which depend on Visual Studio (e.g. <a href="https://github.com/michelou/cpp-examples"><code>michelou/cpp-examples</code></a>), <a href=./setenv.bat><code><b>setenv.bat</b></code></a> does invoke <code><b>VsDevCmd.bat</b></code> (resp. <code><b>vcvarall.bat</b></code> for older Visual Studio versions) to setup the Visual Studio tools on the command prompt. 
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples?tab=readme-ov-file#playing-with-ada-on-windows
[akka_examples]: https://github.com/michelou/akka-examples?tab=readme-ov-file#playing-with-akka-on-windows
[bazel_cli]: https://docs.bazel.build/versions/master/command-line-reference.html
[bazel_downloads]: https://github.com/bazelbuild/bazel/releases/tag/7.4.0
[bazel_relnotes]: https://github.com/bazelbuild/bazel/releases/tag/7.4.0
<!--
7.0.0 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-700-2023-12-11
6.4.0 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-640-2023-10-19
6.3.2 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-632-2023-08-08
6.3.0 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-630-2023-07-24
6.2.1 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-621-2023-06-02
6.2.0 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-620-2023-05-09
7.0.2 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-702-2024-01-25
7.1.0 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-710-2024-03-11
7.1.1 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-711-2024-03-21
7.1.2 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-712-2024-05-08
7.2.1 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-721-2024-06-25
7.3.1 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-731-2024-08-19
7.3.2 -> https://github.com/bazelbuild/bazel/blob/master/CHANGELOG.md#release-732-2024-10-01
7.4.0 -> https://github.com/bazelbuild/bazel/releases/tag/7.4.0
-->
[bcc_downloads]: https://www.embarcadero.com/free-tools/ccompiler
[clang_cli]: https://clang.llvm.org/docs/ClangCommandLineReference.html
[cmake_cli]: https://cmake.org/cmake/help/latest/manual/cmake.1.html
[cmake_downloads]: https://cmake.org/download/
[cmake_relnotes]: https://cmake.org/cmake/help/v3.31/release/3.31.html
[cobol_examples]: https://github.com/michelou/cobol-examples#top
[conemu_downloads]: https://github.com/Maximus5/ConEmu/releases
[conemu_relnotes]: https://conemu.github.io/blog/2023/07/24/Build-230724.html
[cpp_lang]: https://isocpp.org/
[cppcheck_changelog]: https://github.com/danmar/cppcheck/releases#top
[cppcheck_downloads]: http://cppcheck.sourceforge.net/#download
[dafny_examples]: https://github.com/michelou/dafny-examples#top
[dart_examples]: https://github.com/michelou/dart-examples#top
[deno_examples]: https://github.com/michelou/deno-examples#top
[docker_examples]: https://github.com/michelou/docker-examples#top
[doxygen_changelog]: https://www.doxygen.nl/manual/changelog.html
[doxygen_downloads]: https://www.doxygen.nl/download.html#srcbin
[erlang_examples]: https://github.com/michelou/erlang-examples#top
[flix_examples]: https://github.com/michelou/flix-examples#top
[git_cli]: https://git-scm.com/docs/git
[git_docs]: https://git-scm.com/docs/git
[git_releases]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.47.0.txt
[github_markdown]: https://github.github.com/gfm/
[golang_examples]: https://github.com/michelou/golang-examples#top
[graalvm_examples]: https://github.com/michelou/graalvm-examples#top
[haskell_examples]: https://github.com/michelou/haskell-examples#top
[intel_dpc]: https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html#dpcpp-cpp
[intel_dpc_relnotes]: https://www.intel.com/content/www/us/en/developer/articles/release-notes/intel-oneapi-dpc-c-compiler-release-notes.html
[kafka_examples]: https://github.com/michelou/kafka-examples#top
[kotlin_examples]: https://github.com/michelou/kotlin-examples#top
[llvm_downloads]: https://github.com/llvm/llvm-project/releases/tag/llvmorg-17.0.6
[llvm_examples]: https://github.com/michelou/llvm-examples#top
[llvm_relnotes]: https://discourse.llvm.org/t/llvm-17-0-6-released/75281
<!--
14.0.6 -> https://discourse.llvm.org/t/llvm-14-0-6-release/63431
15.0.7 -> https://discourse.llvm.org/t/llvm-15-0-7-release/67638
16.0.4 -> https://discourse.llvm.org/t/16-0-4-release/70692
17.0.4 -> https://discourse.llvm.org/t/llvm-17-0-4-released/74548
17.0.6 -> https://discourse.llvm.org/t/llvm-17-0-6-released/75281
-->
[llvm_19_downloads]: https://github.com/llvm/llvm-project/releases/tag/llvmorg-19.1.1
[llvm_19_relnotes]: https://discourse.llvm.org/t/llvm-19-1-1-released/82321
<!--
19.1.1 -> https://github.com/llvm/llvm-project/releases/tag/llvmorg-19.1.1
-->
[m2_examples]: https://github.com/michelou/m2-examples#top
[man1_awk]: https://www.linux.org/docs/man1/awk.html
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[man1_file]: https://www.linux.org/docs/man1/file.html
[man1_grep]: https://www.linux.org/docs/man1/grep.html
[man1_more]: https://www.linux.org/docs/man1/more.html
[man1_mv]: https://www.linux.org/docs/man1/mv.html
[man1_rmdir]: https://www.linux.org/docs/man1/rmdir.html
[man1_sed]: https://www.linux.org/docs/man1/sed.html
[man1_wc]: https://www.linux.org/docs/man1/wc.html
[msys2_changelog]: https://github.com/msys2/setup-msys2/blob/main/CHANGELOG.md
[msys2_downloads]: http://repo.msys2.org/distrib/x86_64/
[nodejs_examples]: https://github.com/michelou/nodejs-examples#top
[orangec_downloads]: https://github.com/LADSoft/OrangeC/releases
[orangec_relnotes]: https://github.com/LADSoft/OrangeC/releases/tag/Orange-C-v6.73.1
[rust_examples]: https://github.com/michelou/rust-examples#top
[scala3_examples]: https://github.com/michelou/dotty-examples#top
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
[spark_examples]: https://github.com/michelou/spark-examples#top
[spring_examples]: https://github.com/michelou/spring-examples#top
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples#top
[unix_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[vs2019_downloads]: https://visualstudio.microsoft.com/en/downloads/
[vs2019_relnotes]: https://docs.microsoft.com/en-us/visualstudio/releases/2019/release-notes
[vs2022_downloads]: https://visualstudio.microsoft.com/en/downloads/
[vs2022_relnotes]: https://docs.microsoft.com/en-us/visualstudio/releases/2022/release-notes
[vscode_downloads]: https://code.visualstudio.com/#alt-downloads
[vscode_relnotes]: https://code.visualstudio.com/updates/
[win32_api]: https://learn.microsoft.com/en-us/windows/win32/api/
[windows_installer]: https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-portal
[winsdk_downloads]: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/
[winsdk_relnotes]: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/#relnote
[wix_examples]: https://github.com/michelou/wix-examples#top
[zig_examples]: https://github.com/michelou/zig-examples#top
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
