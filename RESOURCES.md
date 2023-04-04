# <span id="top">ISO C++ Resources</span> <span style="size:20%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;;min-width:100px;"><a href="https://isocpp.org/" rel="external"><img src="docs/images/cpp_logo.png" width="100" alt="ISO C++"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://isocpp.org/" rel="external">ISO C++</a> related resources that caught our attention.
  </td>
  </tr>
</table>

## <span id="articles">Articles</span>

- [Using GCC with MinGW](https://code.visualstudio.com/docs/cpp/config-mingw), January 2022.
- [Red Hat Developer](https://developers.redhat.com/) articles :
  - [New C++ features in GCC 12][article_placek] by Marek Polacek, April 2022.
  - [The state of static analysis in the GCC 12 compiler][article_malcolm] by David Malcolm, April 2022.
  - [Enforce code consistency with clang-format][article_guelton_format] by Serge Guelton, February 2022.
  - [Porting your code to C++17 with GCC 11](https://developers.redhat.com/articles/2021/08/06/porting-your-code-c17-gcc-11) by Marek Polacek, August 2021.
  - [Optimizing the Clang compiler’s line-to-offset mapping][article_guelton_mapping] by Serge Guelton, May 2021.
- [C++: generating a native interface automatically][article_dinechin] by Christophe de Dinechin, February 2021.
- [The Edge of C++][article_ferenc] by Deák Ferenc, October 2020.
- [Internals of Compiling - Journey from C/C++ program to an Executable][article_gautham] by Adwaith Gautham, June 2018.
- [Mixing C and C++ Code in the Same Program][article_clamage] by Stephen Clamage, February 2011.
- [The C Family of Languages: Interview with Dennis Ritchie, Bjarne Stroustrup, and James Gosling][article_ritchie], July 2000.

## <span id="blogs">Blogs</span>

- [Sutter's Blog](https://herbsutter.com/) :
  - [C++23 “Pandemic Edition” is complete](https://herbsutter.com/2023/02/13/c23-pandemic-edition-is-complete-trip-report-winter-iso-c-standards-meeting-issaquah-wa-usa/), February 2023.
  - [Autumn ISO C++ standards meeting (Kona)](https://herbsutter.com/2022/11/) by Herb Sutter, November 2022.
- [Conan Blog](https://blog.conan.io/) :
  - [Understanding the different flavors of Clang C and C++ compilers in Windows](https://blog.conan.io/2022/10/13/Different-flavors-Clang-compiler-Windows.html) by X, October 2022.
- [David Mazières's blog](https://www.scs.stanford.edu/~dm/blog/) :
  - [C++20 idioms for parameter packs](https://www.scs.stanford.edu/~dm/blog/param-pack.html), June 2022.
  - [C++ value categories and decltype demystified](https://www.scs.stanford.edu/~dm/blog/decltype.html), June 2021.
  - [Recursive macros with C++20 ](https://www.scs.stanford.edu/~dm/blog/va-opt.html), June 2021.
  - [My tutorial and take on C++20 coroutines](https://www.scs.stanford.edu/~dm/blog/c++-coroutines.html), February 2021.
- [Fekir's Blog](https://fekir.info/) :
  - [When you cannot call hidden friends in C++](https://fekir.info/post/when-you-cannot-call-hidden-friends-in-cpp/), October 2022.
  - [Type erased view types in C++](https://fekir.info/post/type-erased-view-types-in-cpp/), September 2022.
  - [Macros usages in C++](https://fekir.info/post/macro-usages-in-cpp/), October 2021.
  - [C++ performance guidelines](https://fekir.info/post/cpp-perf-guidelines/), January 2021.
  - [Detect member variables since C++11](https://fekir.info/post/detect-member-variables/), June 2019.
- [Microsoft C++ Team Blog](https://devblogs.microsoft.com/cppblog/category/cplusplus/):
  - [Code Analysis Improvements in Visual Studio 17.6](https://devblogs.microsoft.com/cppblog/code-analysis-improvements-in-visual-studio-17-6/) by Gabor Horvath, March 2023.
  - [Convert Macros to Constexpr](https://devblogs.microsoft.com/cppblog/convert-macros-to-constexpr/) by Augustin Popa, June 2018.
- [Modernes C++](http://www.modernescpp.com/) by Rainer Grimm :
  - [Type Erasure](http://www.modernescpp.com/index.php/type-erasure), April 2022.
  - [Software Design with Traits and Tag Dispatching](http://www.modernescpp.com/index.php/softwaredesign-with-traits-and-tag-dispatching), March 2022.
  - [Mixins](http://www.modernescpp.com/index.php/mixins), March 2022.
- [Modern C++ In-Depth — Move Semantics, Part 2][blog_kootker_2] by Ralph Kootker, March 2022.
- [Modern C++ In-Depth — Move Semantics, Part 1][blog_kootker_1] by Ralph Kootker, March 2022.
- [Fluent **{**C**++}**](https://www.fluentcpp.com/):
  - [The Evolutions of Lambdas in C++14, C++17 and C++20](https://www.fluentcpp.com/2021/12/13/the-evolutions-of-lambdas-in-c14-c17-and-c20/), December 2021.
  - [Strong Types for Safe Indexing in Collections – Part 2](https://www.fluentcpp.com/2021/11/04/strong-types-for-safe-indexing-in-collections-part-2/), November 2021.
  - [Strong Types for Safe Indexing in Collections – Part 1](https://www.fluentcpp.com/2021/10/31/strong-types-for-safe-indexing-in-collections-part-1/), October 2021.
  - [How to Define Comparison Operators by Default in C++](https://www.fluentcpp.com/2021/08/23/how-to-define-comparison-operators-by-default-in-c/), August 2021.
  - [Extended Aggregate Initialisation in C++17](https://www.fluentcpp.com/2021/07/17/extended-aggregate-initialisation-in-c17/), July 2021.
  - [How to Return Several Values from a Function in C++](https://www.fluentcpp.com/2021/07/09/how-to-return-several-values-from-a-function-in-c/), July 2021.
- [The Old New Thing Blog](https://devblogs.microsoft.com/oldnewthing/) (Microsoft) :
  - [Compiler error message metaprogramming: Helping to find the conflicting macro definition](https://devblogs.microsoft.com/oldnewthing/20211206-00/?p=106002) by Raymond Chen, December 2021.
- [The C++ Programming Language](https://www.stroustrup.com/C++.html) by Bjarne Stroustrup, October 2021.
- [cstdlib in C++ – Explained](https://www.incredibuild.com/blog/cstdlib-in-c-explained) by Dori Exterman, September 2021.
- [How to use type traits?](https://www.sandordargo.com/blog/2021/04/14/how-to-use-type-traits) by Sandor Dargo, May 2021.
- [Structures and classes in C++](https://www.embedded.com/structures-and-classes-in-c/) by Colin Walls, September 2020.
- [C++ Lambda Under the Hood](https://medium.com/software-design/c-lambda-under-the-hood-9b5cd06e550a) by [EventHelix](https://www.eventhelix.com/), June 2019.
- [OpenGenus C++ Blog](https://iq.opengenus.org/tag/cpp/):
  - [Advanced C++ topics](https://iq.opengenus.org/advanced-cpp-topics/) by Reshma Patil.
  - [Different ways to terminate a program in C++](https://iq.opengenus.org/different-ways-to-terminate-program-in-cpp/) by Subhrajit Dhar.
  - [Struct inheritance in C++](https://iq.opengenus.org/struct-inheritance-in-cpp/) by Harshit Raj.
- [RedHat Developer Blog](https://developers.redhat.com/new) :
  - [2022 Fall C++ Standards Committee Meeting trip report](https://developers.redhat.com/blog/2023/02/09/2022-fall-c-standards-committee-meeting-trip-report), February 2023.
  - [The joys and perils of aliasing in C and C++, Part 2](https://developers.redhat.com/blog/2020/06/03/the-joys-and-perils-of-aliasing-in-c-and-c-part-2) by Martin Sebor, June 2020.
  - [The joys and perils of C and C++ aliasing, Part 1](https://developers.redhat.com/blog/2020/06/02/the-joys-and-perils-of-c-and-c-aliasing-part-1) by Martin Sebor, June 2020.
- [C++11 threads, affinity and hyperthreading][blog_bendersky_2016] by Eli Bendersky, January 2016.
- [Variadic templates in C++][blog_benderksy_2014] by Eli Bendersky, October 2014.

## <span id="books">Books</span> [**&#x25B4;**](#top)

- [The C++ Standard Library][book_grimm_2023] (4<sup>th</sup> Ed.) by Rainer Grimm, March 2023.<br/><span style="font-size:80%;">(Leanpub, 344 pages)</span> 
- [Concurrency_with Modern C++][book_grimm] by Rainer Grimm, February 2022.<br/><span style="font-size:80%;">(Leanpub, 475 pages)</span>
- [Design Patterns in Modern C++20][book_nesteruk] (2<sup>nd</sup> Ed.) by Dmitri Nesteruk, 2022.<br/><span style="font-size:80%;">(Nesteruk, ISBN 978-1-4842-7294-7, 390 pages)</span>
- [C++20 - The Complete Guide][book_josuttis] by Nicolai M. Josuttis, December 2021.<br/><span style="font-size:80%;">(Leanpub, 474 pages)</span>
- [Demystified Object-Oriented Programming with C++ ][book_kirk] by Dorothy R. Kirk, March 2021.<br/><span style="font-size:80%;">(Packt Publishing, ISBN 978-1-8392-1883-5, 568 pages)</span>
- [Professional C++][book_gregoire] (<sup>5th</sup> Ed) by Marc Gregoire, February 2021.<br/><span style="font-size:80%;">(Wiley, ISBN 978-1-1196-9540-0, 1312 pages)</span>
- [Real-Time C++][book_kormanyos] (4<sup>th</sup> Ed.) by Christopher Kormanyos, 2021.<br/><span style="font-size:80%;">(Springer, ISBN 978-3-6626-2995-6, 510 pages)</span>
- [C++ Early Objects][book_gaddis] (10<sup>th</sup> Ed.) by Tony Gaddis et al., 2020.<br/><span style="font-size:80%;">(Pearson, ISBN 978-0-13-523500-3)</span>
- [C++ Distilled][book_pohl] by Ira Pohl, July 2007.<br/><span style="font-size:80%;">(Pearson, ISBN 978-0-2016-9587-8, 210 pages)</span>

## <span id="papers">Papers</span>

- [C++ Standards Committee Papers](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/): [2019](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2019/), [2020](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2020/), [2021](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/), [2022](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2022/).

## <span id="news">News</span> [**&#x25B4;**](#top)

- [GCC Announcements](https://gcc.gnu.org/pipermail/gcc-announce/) :
  - [GCC 12.2 Released](https://gcc.gnu.org/pipermail/gcc-announce/2022/000174.html), August 2022.
  - [GCC 12.1 Released](https://gcc.gnu.org/pipermail/gcc/2022-May/238653.html), May 2022.
  - [GCC 11.3 Released](https://gcc.gnu.org/pipermail/gcc-announce/2022/000170.html), April 2022.
  - [GCC 11.1 Released](https://gcc.gnu.org/pipermail/gcc-announce/2021/000166.html), April 2021.
  - [GCC 10.3 Released](https://gcc.gnu.org/pipermail/gcc-announce/2021/000165.html), April 2021
  - [GCC 10.1 Released](https://gcc.gnu.org/pipermail/gcc-announce/2020/000163.html), May 2020.

## <span id="tools">Tools</span> [**&#x25B4;**](#top)

- [Astrée](https://www.absint.com/astree/) &ndash; a fast and sound static analyzer for C/C++.
- [C++ Insights](https://cppinsights.io/about.html) &ndash; a Clang-based tool which does a source to source transformation.
- [Conan](https://conan.io/downloads.html) &ndash; a C/C++ package manager.
- [RuleChecker](https://www.absint.com/rulechecker/) &ndash; a static analyzer that automatically checks your C or C++ code for compliance with MISRA rules, CERT recom­mendations, and other coding guidelines.

## <span id="tutorials">Tutorials</span>

- [Beginner's Guide to Linkers](https://www.lurklurk.org/linkers/linkers.html) by David Drysdale, 2010.
- [C++ Core Guidelines][tutorial_stroustrup] by Bjarne Stroustrup and Herb Sutter, April 2022.
- [C++ Reference](https://en.cppreference.com/w/): [C++11](https://en.cppreference.com/w/cpp/11), [C++14](https://en.cppreference.com/w/cpp/14), [C++17](https://en.cppreference.com/w/cpp/17), [C++20](https://en.cppreference.com/w/cpp/20), [C++23](https://en.cppreference.com/w/cpp/23).

## <span id="videos">Videos</span>

- [Things that Matter][video_meyers] by Scott Meyers, 2017.

***

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2023* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- href links -->

[article_clamage]: https://www.oracle.com/technical-resources/articles/it-infrastructure/mixing-c-and-cplusplus.html
[article_dinechin]: ttps://grenouillebouillie.wordpress.com/2021/02/07/c-generating-a-native-interface-automatically/
[article_ferenc]: https://accu.org/journals/overload/28/159/deak/
[article_gautham]: https://www.pwnthebox.net/reverse/engineering/and/binary/exploitation/series/2018/06/21/internals-of-compiling-Journey-from-C-program-to-an-executable.html
[article_guelton_format]: https://developers.redhat.com/articles/2022/02/25/enforce-code-consistency-clang-format
[article_guelton_mapping]: https://developers.redhat.com/blog/2021/05/04/optimizing-the-clang-compilers-line-to-offset-mapping
[article_malcolm]: https://developers.redhat.com/articles/2022/04/12/state-static-analysis-gcc-12-compiler
[article_placek]: https://developers.redhat.com/articles/2022/04/25/new-c-features-gcc-12
[article_ritchie]: http://www.gotw.ca/publications/c_family_interview.htm
[blog_benderksy_2014]: https://eli.thegreenplace.net/2014/variadic-templates-in-c/
[blog_bendersky_2016]: https://eli.thegreenplace.net/2016/c11-threads-affinity-and-hyperthreading/
[blog_kootker_2]: https://medium.com/factset/modern-c-in-depth-move-semantics-part-2-4c53e90d5f2
[blog_kootker_1]: https://medium.com/factset/modern-c-in-depth-move-semantics-part-1-8a29d33944e4
[book_gaddis]: https://www.pearson.com/store/p/starting-out-with-c-early-objects/P100002716184/9780135213698
[book_gregoire]: https://www.wiley.com/en-us/Professional+C%2B%2B%2C+5th+Edition-p-9781119695400
[book_grimm]: https://leanpub.com/concurrencywithmodernc
[book_grimm_2023]: https://leanpub.com/cpplibrary
[book_josuttis]: https://cppstd20.com/
[book_kirk]: https://www.packtpub.com/product/demystifying-object-oriented-programming-with-c/9781839218835
[book_kormanyos]: https://www.springer.com/gp/book/9783662629956
[book_nesteruk]: https://www.springerprofessional.de/en/design-patterns-in-modern-c-20/19833000
[book_pohl]: https://www.amazon.com/Distilled-Concise-Reference-Style-Guide/dp/0201695871
[tutorial_stroustrup]: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines
[video_meyers]: https://dconf.org/2017/talks/meyers.html
