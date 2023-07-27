---
title: Why We Created LFortran
date: 2019-04-30
tags: ["Fortran", "Announcement"]
author: "[Ondřej Čertík](https://ondrejcertik.com/), [Peter Brady](https://github.com/pbrady), [Pieter Swart](https://cnls.lanl.gov/External/people/Pieter_Swart.php)"
type: post
---

We recently open sourced [LFortran], an interactive Fortran compiler built on
top of LLVM that we have been developing for the last 1.5 years. It is a work
in progress and at the link you can find what works already, what is planned
and a roadmap.

Here is our motivation.


# Why are almost no new scientific or engineering software projects started in Fortran?

Usually (in our neck of the woods) C++ is chosen instead. The following are the
most cited reasons for such a choice:

* lack of GPU support (no [Kokkos] equivalent)
* Need for more advanced data structures than a multidimensional array
* Better, more modern tools in C++ (testing, IDE support, ...)
* Lack of generic programming in Fortran (e.g., to write a single subroutine
  that works for both single and double precision)
* More libraries that one can readily use in C++
* C++ after C++11 is actively maintained, has a wide community
* Fortran has a bad reputation at CS departments.


# Fortran usage

Fortran used to be a very popular language for scientific computing from 1960s
all the way through 1980s and early 1990s. The lack of interactivity forced
many new users to pick other languages and tools, including MATLAB and later
Python and Julia. The growing lack of modern tools and a growing failure of
Fortran compilers to develop to their full potential (such as GPU support, IDE
support, etc.) is forcing developers of large production codes to move to C++.


# How to fix that

## Interactivity

One approach is to take a language like Python and try to make it as fast as
possible, while preserving the interactivity and ease of use. One is forced to
modify the language a bit so that the compiler can reason about types. That is
the approach that Julia took.

The other approach is to take our current compiled production languages: C++
and Fortran and try to see how interactive one can make them without
sacrificing speed (i.e., without modifying the language). For C++ this has been
done using the [cling] interactive compiler. However, the C++ syntax is not as
intuitive as Fortran or Python (both of which have a very similar syntax for
array operations). The Fortran language when used interactively (e.g., in a
Jupyter notebook) allows similar look and feel as Python or MATLAB, enabling
rapid prototyping and exploratory workflow. The same code however offers
superior performance when compiled with a good mature compiler, such as the
Intel Fortran compiler, because it is just Fortran after all.


## Compiler

We believe the root of the problem is a lack of a modern Fortran compiler with
the following features:

* Open source (permissive license)
* Create executables (static and dynamic binaries)
* Interactive usage (Jupyter notebook)
* Multiplatform:
  * First class native support for Windows, Mac, Linux and HPC
  * Works well with other (especially C++, but also Fortran!) compilers: MSVC,
    g++, clang++, gfortran, Intel Fortran...
  * GPU support (similarly how NumBa works on GPU via LLVM)
* Able to compile the latest Fortran standard (2018)
* Designed as a library, modular design with a priority of being easy to
  contribute to
* Large and active community around the compiler that contributes to the
  development, thus supporting many tools that people build on top:
  * IDE support
  * Language interoperability: automatic wrappers to and from other languages
    (C, C++, Python, Julia, MATLAB, ...)
  * Code refactoring
  * Automatic transformation of code to older Fortran standard that other
    Fortran compilers can compile --- allowing developers to use the latest
    standard, and still be able to use current Fortran compilers
  * Better debugger (`IPython.embed()` for Fortran)
  * New real types: arbitrary precision floating point, automatic
    differentiation type, interval arithmetics ([Arb]) etc.
  * "Safe mode": the compiler will warn about "obsolete" usage, and will check
    arrays, pointers and other things to never segfault in Debug mode
  * Allow projects to restrict what Fortran features are allowed and not
    allowed for their particular project (the compiler will give errors on the
    CI when new pull request contains forbidden code)

Having such a compiler will catalyze creation of modern tools based on it, and
by nurturing and encouraging the community to build upon it, this has a
potential to make Fortran cool again.

Currently a lot of Fortran users use Fortran because they have to (for legacy
codes), but are not necessarily very excited about it. The aim of LFortran is
to make people want to use Fortran, want to try the newest toys (whether
Jupyter Notebook, or interactive debugging, or nice IDE support, MATLAB, Julia
or Python style interactive exploratory development workflow, etc.). Bring the
excitement of new modern things into Fortran. However, underneath it is still
the same old Fortran, and one can still use the mature, stable and well-tested
Fortran compilers that produce highly optimized binaries, such as Intel
Fortran, which is still the state-of-the-art when it comes to performance.


# How to bootstrap it

The first users will be people who develop algorithms (in Python, MATLAB or
Julia) that initially will be ok that only a subset of Fortran works for now.
As we build a community of users and eventually developers, the Fortran
compiler will support more and more features, until the whole Fortran 2018
standard works, but that will take years.

However, our compiler can parse GFortran module files, and so very soon it will
be possible to literally "use" any module compiled by GFortran, interactively.
That will allow the use of production codes right away, and also for anything
that LFortran does not yet implement one could then simply write a module,
compile with GFortran and use it in LFortran.

When Ondřej started [SymPy], he was facing very analogous challenges: Computer
Algebra Systems (such as Maxima, Axiom and others) were notorious for being
huge and complicated, hard to contribute to (thus very small developer
community), and hard to use as a library. But starting a project from scratch
would mean it would take 10 years before the SymPy library could be usable by
users used to all the rich and mature features of Maple, Mathematica, Maxima or
Axiom. But Ondřej has done it anyway, the first users were people who only
needed a subset of the features, but wanted to use a modern, well-designed
library that is easy to use and easy to develop.

We are developing LFortran in the same way: first only a subset of Fortran is
implemented, but the library either delivers or is close to delivering on all
the other features listed above (interactivity, language interoperability,
etc.) to make it useful for the first users and recruit developers from our
first users.

The other approach to attract developers is that the compiler uses modern
design and technologies: LLVM, interactivity of a compiled language, Jupyter
notebooks, simple syntax and semantic representation of the language, etc.

Fortran already has a large community, which is an advantage (people already
know Fortran), but also a disadvantage (LFortran will only become useful to
most of the current Fortran community only in several years). As such, we want
to recruit the initial community from Python, MATLAB and Julia users, who know
and appreciate the advantage of exploratory work, and who develop new research
algorithms. Only as LFortran becomes more and more mature, the current Fortran
community will be able to use it also.

We expect the main key factor in Fortran uptake will be when people can see
that you can use Fortran in the modern ways like you can do Python or Julia,
and by providing modern nice features and tools in the compiler, attracting
talent from the Python scientific community as well as the compiler community
(LLVM and other).


**Trackbacks:**

* [Twitter](https://twitter.com/OndrejCertik/status/1123238987643047936)
* [Hacker News I](https://news.ycombinator.com/item?id=19795262)
* [Hacker News II](https://news.ycombinator.com/item?id=19788526)
* [Reddit I](https://www.reddit.com/r/fortran/comments/bjbkc7/why_we_created_lfortran_interactive_fortran/)
* [Reddit II](https://www.reddit.com/r/programming/comments/bjayc0/why_we_created_lfortran_interactive_fortran/)
* [Jacob Williams](http://degenerateconic.com/fortran-and-llvm/)
* [Hackaday](https://hackaday.com/2019/05/03/fortran-goes-interactive/)

[LFortran]: https://lfortran.org/ "LFortran Webpage"
[cling]: https://github.com/root-project/cling
[Kokkos]: https://github.com/kokkos/kokkos
[Arb]: http://arblib.org/
[SymPy]: https://sympy.org/

<!-- LA-UR-19-23884 -->
