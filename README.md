# <span id="top">ISO C++ on Microsoft Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://isocpp.org/" rel="external"><img src="docs/images/cpp_logo.png" width="100" alt="C++ logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://isocpp.org/" rel="external" title="ISO C++">C++</a> code examples coming from various websites and books.<br/>
  It also includes build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, Makefiles) for experimenting with <a href="hhttps://isocpp.org/" rel="external">C++</a> on a Windows machine.
  </td>
  </tr>
</table>

[Ada][ada_examples], [Akka][akka_examples], [Deno][deno_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples] and [Wix][wix_examples] are other topics we are continuously investigating.

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [Git 2.35][git_downloads] ([*release notes*][git_relnotes])
- [LLVM 12][llvm_downloads] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][llvm_relnotes])
- [Microsoft Visual Studio Community 2019][vs2019_downloads] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][vs2019_relnotes])
- [MSYS2][msys2_downloads] <sup id="anchor_01">[1](#footnote_01)</sup>
- [Windows SDK 10][winsdk_downloads] ([*release notes*][winsdk_relnotes])

Optionally one may also install the following software:

- [Bazel 5][bazel_downloads] ([*release notes*][bazel_relnotes])

For instance our development environment looks as follows (*March 2022*) <sup id="anchor_02">[2](#footnote_02)</sup>:

<pre style="font-size:80%;">
C:\opt\bazel-5.0.0\                      <i>(  41 MB)</i>
C:\opt\Git-2.35.1\                       <i>( 282 MB)</i>
C:\opt\LLVM-12.0.1\                      <i>(3.39 GB)</i>
C:\opt\msys64\                           <i>(2.85 GB)</i>
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\  <i>(4.17 GB)</i>
C:\Program Files (x86)\Windows Kits\10\  <i>(6.75 GB)</i>
</pre>

> **:mag_right:** Git for Windows provides a BASH emulation used to run [**`git`**][git_docs] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

## <span id="structure">Directory structure</span>

This project is organized as follows:
<pre style="font-size:80%;">
bin\
docs\
examples\{<a href="examples/README.md">README.md</a>, <a href="examples/call-by-copy/">call-by-copy</a>, <a href="examples/class-dispatching/">class-dispatching</a>, etc.}
pthreads-examples\{<a href="pthreads-examples/README.md">README.md</a>, <a href="pthreads-examples/fib/">fib</a>, <a href="pthreads-examples/myTurn/">myTurn</a>, etc.}
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="setenv.bat">setenv.bat</a>
</pre>

where

- directory [**`bin\`**](bin/) contains utility tools.
- directory [**`docs\`**](docs/) contains [C++][cpp_lang] related papers/articles.
- directory [**`examples\`**](mastering-rust/) contains [C++][cpp_lang] code examples (see [`README.md`](examples/README.md) file).
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

## <span id="footnotes">Footnotes</span>

<a id="footnote_01">[1]</a> ***C++ Compilers*** [↩](#anchor_01)

<dl><dd>
With the installed development tools for Windows we have access to 3 C++ compilers:
</dd>
<dd>
<table>
<tr><th>Devtool</th><th>C++&nbsp;Compiler</th><th>Version</th><th>ISO Standards <sup><b>a)</b></sup></th></tr>
<tr><td><a href="https://llvm.org/">LLVM</a></td><td><a href="https://clang.llvm.org/docs/UsersManual.html#basic-usage"><code><b>clang.exe</b></code></a></td><td>12.0.1</td><td><a href="https://clang.llvm.org/cxx_status.html">98, 11, 14, 17, 20, 2b</a> <sup><b>b)</b></sup></td></tr>
<tr><td><a href="https://visualstudio.microsoft.com/free-developer-offers/">MSVS</a></td><td><a href="https://docs.microsoft.com/en-us/cpp/build/reference/compiler-command-line-syntax"><code><b>cl.exe</b></code></a></td><td>19.29.30141</td><td><a href="https://docs.microsoft.com/en-us/cpp/build/reference/std-specify-language-standard-version">14, 17, 20</a></td></tr>
<tr><td><a href="https://www.msys2.org/">MSYS2</a></td><td><a href="https://man7.org/linux/man-pages/man1/g++.1.html"><code><b>g++.exe</b></code></a></td><td>11.2.0</td><td><a href="https://gcc.gnu.org/projects/cxx-status.html">98, 11, 14, 17, 20, 23</a> <sup><b>b)</b></sup></td></tr>
</table>
<div style="margin:0 0 0 10px;font-size:80%;">
<sup><b>a)</b></sup> Standard specified with compiler option, e.g. <code><b>-std=c++17</b></code>.<br/>
<sup><b>b)</b></sup> ISO standard 23 <i>partially</i> supported.
</div>
</dd></dl>

<a id="footnote_02">[2]</a> ***Downloads*** [↩](#anchor_02)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://github.com/bazelbuild/bazel/releases/tag/5.0.0">bazel-5.0.0-windows-x86_64.zip</a>    <i>( 43 MB)</i>
<a href="https://github.com/llvm/llvm-project/releases/tag/llvmorg-12.0.1">llvm-12.0.1.src.tar.xz</a>            <i>( 31 MB)</i>
<a href="http://repo.msys2.org/distrib/x86_64/">msys2-x86_64-20190524.exe</a>         <i>( 86 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.35.1-64-bit.7z.exe</a>  <i>( 41 MB)</i>
<a href="https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/">winsdksetup.exe</a>                   <i>(1.3 MB)</i>
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2022* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples
[akka_examples]: https://github.com/michelou/akka-examples
[bazel_downloads]: https://github.com/bazelbuild/bazel/releases/tag/5.0.0
[bazel_relnotes]: https://blog.bazel.build/2020/06/17/bazel-3-3.html
[cpp_lang]: https://isocpp.org/
[deno_examples]: https://github.com/michelou/deno-examples
[git_docs]: https://git-scm.com/docs/git
[git_downloads]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.31.0.txt
[github_markdown]: https://github.github.com/gfm/
[golang_examples]: https://github.com/michelou/golang-examples
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[haskell_examples]: https://github.com/michelou/haskell-examples
[kotlin_examples]: https://github.com/michelou/kotlin-examples
[llvm_downloads]: https://github.com/llvm/llvm-project/releases/tag/llvmorg-12.0.1
[llvm_examples]: https://github.com/michelou/llvm-examples
[llvm_relnotes]: https://releases.llvm.org/12.0.1/docs/ReleaseNotes.html
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
[spring_examples]: https://github.com/michelou/spring-examples
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[vs2019_downloads]: https://visualstudio.microsoft.com/en/downloads/
[vs2019_relnotes]: https://docs.microsoft.com/en-us/visualstudio/releases/2019/release-notes
[winsdk_downloads]: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/
[winsdk_relnotes]: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/#relnote
[wix_examples]: https://github.com/michelou/wix-examples
