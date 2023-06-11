# <span id="top">Playing with C++ on Windows</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://isocpp.org/" rel="external"><img src="docs/images/cpp_logo.png" width="100" alt="ISO C++ project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://isocpp.org/" rel="external" title="ISO C++">C++</a> code examples coming from various websites and books.<br/>
  It also includes build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) for experimenting with <a href="https://isocpp.org/" rel="external">ISO C++</a> on a Windows machine.
  </td>
  </tr>
</table>

[Ada][ada_examples], [Akka][akka_examples], [Dart][dart_examples], [Deno][deno_examples], [Flix][flix_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kafka][kafka_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples] and [WiX Toolset][wix_examples] are other topics we are continuously investigating.

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [CMake 3.26][cmake_downloads] ([*release notes*][cmake_relnotes])
- [Git 2.41][git_releases] ([*release notes*][git_relnotes])
- [LLVM 16][llvm_downloads] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][llvm_relnotes])
- [MSYS2][msys2_downloads] <sup id="anchor_01">[1](#footnote_01)</sup>
- [oneAPI DPC++ 2023.1][intel_dpc] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][intel_dpc_relnotes])
- [Visual Studio Community 2019][vs2019_downloads] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][vs2019_relnotes])
- [Windows SDK 10][winsdk_downloads] ([*release notes*][winsdk_relnotes])

Optionally one may also install the following software:

- [Bazel 6.2 LTS][bazel_downloads] ([*release notes*][bazel_relnotes])
- [Cppcheck 2.10][cppcheck_downloads] <sup id="anchor_03">[3](#footnote_03)</sup> ([*changelog*][cppcheck_changelog])
- [Doxygen 1.9][doxygen_downloads] ([*changelog*][doxygen_changelog])
- [Embarcadero C++ 7.30 Compiler][bcc_downloads]
- [Visual Studio Community 2022][vs2022_downloads] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][vs2022_relnotes])
- [Visual Studio Code 1.78][vscode_downloads] ([*release notes*][vscode_relnotes])

For instance our development environment looks as follows (*June 2023*) <sup id="anchor_02">[2](#footnote_02)</sup>:

<pre style="font-size:80%;">
C:\opt\bazel-6.2.1\                      <i>( 47 MB)</i>
C:\opt\BCC-10.2\                         <i>(194 MB)</i>
C:\opt\cmake-3.26.4-windows-x86_64\      <i>(100 MB)</i>
C:\opt\doxygen-1.9.7\                    <i>(120 MB)</i>
C:\opt\Git-2.41.0\                       <i>(358 MB)</i>
C:\opt\LLVM-16.0.5\                      <i>(3.1 GB)</i>
C:\opt\msys64\                           <i>(2.8 GB)</i>
C:\opt\VSCode\                           <i>(341 MB)</i>
c:\Program Files\Cppcheck\               <i>( 35 MB)</i>
C:\Program Files\Microsoft Visual Studio\2022\Community\        <i>(4.4 GB)</i>
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\  <i>(4.2 GB)</i>
C:\Program Files (x86)\Intel\oneAPI\     <i>(3.3 GB)</i>
C:\Program Files (x86)\Windows Kits\10\  <i>(6.7 GB)</i>
</pre>

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

## <span id="commands">Batch commands</span>

### **`setenv.bat`** <sup id="anchor_03">[3](#footnote_03)</sup>

Command [**`setenv.bat`**](setenv.bat) is executed once to setup our development environment; it makes external tools such as [**`bazel.exe`**][bazel_cli] and [**`git.exe`**][git_cli] directly available from the command prompt.

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a></b>
Tool versions:
   bazel 6.2.1, bcc32c 7.30, clang 16.0.5, gcc 12.2.0, icx 2023.1.0
   cmake 3.26.4, cl 19.29.30137, cppcheck 2.10, doxygen 1.9.7, msbuild 16.11.2.50704
   diff 3.9, git 2.41.0.windows.1

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> bazel git</b>
C:\opt\bazel-6.2.1\bazel.exe
C:\opt\Git-2.41.0\bin\git.exe
C:\opt\Git-2.41.0\mingw64\bin\git.exe
</pre>

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***C++ Compilers*** [↩](#anchor_01)

<dl><dd>
The installed development tools for Windows give us access to the following C++ compilers:
</dd>
<dd>
<table>
<tr><th>Devtool</th><th>C++&nbsp;Compiler</th><th>Version</th><th>ISO Standards <sup><b>a)</b></sup></th></tr>
<tr><td><a href="https://www.embarcadero.com">Embarcadero</a></td><td><a href="https://www.embarcadero.com/free-tools/ccompiler"><code><b>bcc32c.exe</b></code></a></td><td>7.30</td><td>11</td></tr>
<tr><td><a href="https://llvm.org/">LLVM</a></td><td><a href="https://clang.llvm.org/docs/UsersManual.html#basic-usage"><code><b>clang.exe</b></code></a></td><td>15.0.x</td><td><a href="https://clang.llvm.org/cxx_status.html">98, 11, 14, 17, 20, 2b</a> <sup><b>b)</b></sup></td></tr>
<tr><td><a href="https://visualstudio.microsoft.com/">MSVS</a></td><td><a href="https://docs.microsoft.com/en-us/cpp/build/reference/compiler-command-line-syntax"><code><b>cl.exe</b></code></a></td><td>19.29.30141</td><td><a href="https://docs.microsoft.com/en-us/cpp/build/reference/std-specify-language-standard-version">14, 17, 20</a></td></tr>
<tr><td><a href="https://www.msys2.org/">MSYS2</a></td><td><a href="https://man7.org/linux/man-pages/man1/g++.1.html"><code><b>g++.exe</b></code></a></td><td>12.2.0</td><td><a href="https://gcc.gnu.org/projects/cxx-status.html">98, 11, 14, 17, 20, 23</a> <sup><b>b)</b></sup></td></tr>
<tr><td><a href="https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html" rel="external">oneAPI</a><br/>&nbsp;(Intel)</td><td><a href="https://www.intel.com/content/www/us/en/develop/documentation/oneapi-dpcpp-cpp-compiler-dev-guide-and-reference/top/compiler-setup/use-the-command-line/invoke-the-compiler.html"><code><b>icx.exe</b></code></td><td>2023.1.0</td><td><a href="https://www.intel.com/content/www/us/en/develop/documentation/cpp-compiler-developer-guide-and-reference/top/compiler-reference/compiler-options/compiler-option-details/language-options/std-qstd.html" rel="external">11, 14, <b>17</b>, 20</a></td></tr>
</table>
<div style="margin:0 0 0 10px;font-size:80%;">
<sup><b>a)</b></sup> Standard specified with compiler option, e.g. <code><b>-std=c++17</b></code>; starting with version 2023.0 oneAPI uses C++17 as the default C++ language.<br/>
<sup><b>b)</b></sup> ISO standard 23 <i>partially</i> supported.<br/>
</div>
</dd></dl>

<span id="footnote_02">[2]</span> ***Downloads*** [↩](#anchor_02)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://github.com/bazelbuild/bazel/releases/tag/6.2.1">bazel-6.2.1-windows-x86_64.zip</a>                     <i>( 43 MB)</i>
<a href="" rel="external">BCC102.zip</a>                                         <i>( 45 MB)</i>
<a href="https://cmake.org/download/">cmake-3.26.4-windows-x86_64.zip</a>                    <i>( 38 MB)</i>
<a href="https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html#dpcpp-cpp">w_dpcpp-cpp-compiler_p_2023.1.0.25932_offline.exe</a>  <i>(1.2 GB)</i>
<a href="https://github.com/llvm/llvm-project/releases/tag/llvmorg-16.0.5">LLVM-16.0.5-win64.exe</a>                              <i>(263 MB)</i>
<a href="http://repo.msys2.org/distrib/x86_64/">msys2-x86_64-20190524.exe</a>                          <i>( 86 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.41.0-64-bit.7z.exe</a>                   <i>( 46 MB)</i>
<a href="https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/">winsdksetup.exe</a>                                    <i>(1.3 MB)</i>
</pre>
</dd></dl>

<span id="footnote_03">[3]</span> **`setenv.bat` *usage*** [↩](#anchor_03)

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
Concretely, <code><b>setenv.bat</b></code> in our GitHub projects which depend on Visual Studio (e.g. <a href="https://github.com/michelou/cpp-examples"><code>michelou/cpp-examples</code></a>) do invoke <code><b>VsDevCmd.bat</b></code> (resp. <code><b>vcvarall.bat</b></code> for older Visual Studio versions) to setup the Visual Studio tools on the command prompt. 
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/June 2023* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples
[akka_examples]: https://github.com/michelou/akka-examples
[bazel_cli]: https://docs.bazel.build/versions/master/command-line-reference.html
[bazel_downloads]: https://github.com/bazelbuild/bazel/releases/tag/6.2.1
[bazel_relnotes]: https://blog.bazel.build/2022/12/19/bazel-6.0.html
[bcc_downloads]: https://www.embarcadero.com/free-tools/ccompiler
[clang_cli]: https://clang.llvm.org/docs/ClangCommandLineReference.html
[cmake_cli]: https://cmake.org/cmake/help/latest/manual/cmake.1.html
[cmake_downloads]: https://cmake.org/download/
[cmake_relnotes]: https://cmake.org/cmake/help/v3.26/release/3.26.html
[cpp_lang]: https://isocpp.org/
[cppcheck_changelog]: https://github.com/danmar/cppcheck/releases
[cppcheck_downloads]: http://cppcheck.sourceforge.net/#download
[dart_examples]: https://github.com/michelou/dart-examples
[deno_examples]: https://github.com/michelou/deno-examples
[doxygen_changelog]: https://www.doxygen.nl/manual/changelog.html
[doxygen_downloads]: https://www.doxygen.nl/download.html#srcbin
[flix_examples]: https://github.com/michelou/flix-examples
[git_cli]: https://git-scm.com/docs/git
[git_docs]: https://git-scm.com/docs/git
[git_releases]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.41.0.txt
[github_markdown]: https://github.github.com/gfm/
[golang_examples]: https://github.com/michelou/golang-examples
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[haskell_examples]: https://github.com/michelou/haskell-examples
[intel_dpc]: https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html#dpcpp-cpp
[intel_dpc_relnotes]: https://www.intel.com/content/www/us/en/developer/articles/release-notes/intel-oneapi-dpc-c-compiler-release-notes.html
[kafka_examples]: https://github.com/michelou/kafka-examples
[kotlin_examples]: https://github.com/michelou/kotlin-examples
[llvm_downloads]: https://github.com/llvm/llvm-project/releases/tag/llvmorg-16.0.5
[llvm_examples]: https://github.com/michelou/llvm-examples
[llvm_relnotes]: https://releases.llvm.org/16.0.0/docs/ReleaseNotes.html
[man1_awk]: https://www.linux.org/docs/man1/awk.html
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[man1_file]: https://www.linux.org/docs/man1/file.html
[man1_grep]: https://www.linux.org/docs/man1/grep.html
[man1_more]: https://www.linux.org/docs/man1/more.html
[man1_mv]: https://www.linux.org/docs/man1/mv.html
[man1_rmdir]: https://www.linux.org/docs/man1/rmdir.html
[man1_sed]: https://www.linux.org/docs/man1/sed.html
[man1_wc]: https://www.linux.org/docs/man1/wc.html
[msys2_downloads]: http://repo.msys2.org/distrib/x86_64/
[nodejs_examples]: https://github.com/michelou/nodejs-examples
[rust_examples]: https://github.com/michelou/rust-examples
[scala3_examples]: https://github.com/michelou/dotty-examples
[spark_examples]: https://github.com/michelou/spark-examples
[spring_examples]: https://github.com/michelou/spring-examples
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[vs2019_downloads]: https://visualstudio.microsoft.com/en/downloads/
[vs2019_relnotes]: https://docs.microsoft.com/en-us/visualstudio/releases/2019/release-notes
[vs2022_downloads]: https://visualstudio.microsoft.com/en/downloads/
[vs2022_relnotes]: https://docs.microsoft.com/en-us/visualstudio/releases/2022/release-notes
[vscode_downloads]: https://code.visualstudio.com/#alt-downloads
[vscode_relnotes]: https://code.visualstudio.com/updates/
[win32_api]: https://learn.microsoft.com/en-us/windows/win32/api/
[winsdk_downloads]: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/
[winsdk_relnotes]: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/#relnote
[wix_examples]: https://github.com/michelou/wix-examples
