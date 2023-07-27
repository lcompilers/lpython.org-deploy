---
title: Comparison of Languages for Numerical Computing
date: 2019-05-07
tags: ["Fortran", "Scientific Computing"]
author: "[Ondřej Čertík](https://ondrejcertik.com/), [Peter Brady](https://github.com/pbrady), [Chris Elrod](https://github.com/chriselrod)"
type: post
draft: true
---

We recently open sourced [LFortran][lfortran doc], an interactive Fortran
compiler built on top of LLVM that we have been developing for the last 1.5
years. It is a work in progress, at the link you can find what works already,
what is planned and a roadmap.

In order to better understand the motivation, let us step back and imagine we
are designing a completely new language. Here are the requirements we would like
our new language to satisfy.

# Requirements

## Language Features

We would like a language designed for a specific domain: *array oriented
scientific computing*. In particular, we would like it to have the following
features:

* Easy to use and interactive: it must feel like using Python, Julia or MATLAB.
* Compile to executables: similarly to C, C++, Go, Rust or Fortran.
* Performance: must be easy to write code that runs fast.
* Contain basic mathematics in the core language (rich array operations,
  complex numbers, exponentiation, special functions).
* Be more restricting (and higher level) than languages like C or C++, so that
  the resulting code is easier to maintain and write and easier for the
  compilers to optimize. There is one canonical way to do things and you don’t
  have to worry about memory allocation (most of the times).
* Statically typed (to help facilitate writing large applications).
* Easy interoperation with other languages (C++, Python, Julia, ...):
  we want to literally just "use" code written in other languages without
  writing manual wrappers.

An important point is that having all the basic elements in the language
itself greatly simplifies both writing and reading fast, robust code. Writing
and reading is simplified because there is a single standard set of
functions/constructs. No need to wonder what class the array operations are
coming from, what the member functions are, how well it will be maintained in
5 years, how well optimized it is/will be, etc. All the basics are in the
language itself: fast, robust, and standard for all to read and write --- and
for the compiler writers to optimize at the machine level.

## Tooling

We want modern tooling for the language:

* Runs on multi-core CPUs and GPUs.
* Open source compiler (BSD licensed)
* The compiler runs on all platforms (Linux, Mac, Windows, HPC machines).
* The generated code works well with other compilers (so that one can mix and
  match code with C++ and Fortran compilers, including from GNU, Intel or
  Microsoft, on all platforms).
* Be able to manipulate the language code in both syntax and semantic
  representations easily, so that there can be a rich ecosystem of tools
  written for the language.

# Search for a language

Now we search for a language which satisfies our requirements. We will
discuss existing languages.

## General overview

First let us do an overview of the most popular languages and why they
do not satisfy our requirements:

* [MATLAB] satisfies most requirements, but it is not fast (requiring to write
  performance critical parts in other language such as C++), nor statically
  typed and it is not open source.
* Established languages such as [C], [C++], [Go], [Swift], [C#], [Java], or
  [Rust] as well as new languages such as [Zig], [Pony], [V] or [Jai] are not
  specifically designed for scientific computing, they do not have the basic
  mathematics in the language, one must use some multidimensional array library
  (such as [XTensor] or [Kokkos] for C++) and the syntax is not as natural as
  in MATLAB. In addition, some of these languages are easy to learn (Go), but
  not always as performing, some other (C++, Rust) allow writing high
  performance code with enough effort, but have a steep learning curve. Also
  they are typically not interactive, and while many can be made interactive
  (e.g., [cling] and [xeus-cling] for C++), the usage is not as smooth as with
  Python. Of these languages, C++ is the most viable candidate and it will be
  discussed in more detail below.
* [Python] with [NumPy] is easy to use, interactive and open source, but not as
  performing, which requires one to rewrite production code into other
  languages such as C++. Also it is not statically typed, which makes it harder
  to write and maintain large production codes. [Ruby] has similar issues as
  Python from the perspective of our analysis.
* Python extensions such as [Cython], [NumBa] or [Pythran] requires one to
  understand both Python as well as the details of a particular extension, thus
  the learning curve is actually pretty steep in order to produce fast code.
  Also while they allow to produce executables, they are not interactive like
  Python itself.

## Potential candidates

We have identified only 4 candidates that could satisfy our requirements: C++,
Fortran, Julia and Chapel. We will discuss what we see as the pros and cons of
each:

* [Chapel] pros:

    * Designed for array oriented scientific computing
    * Parallel features in the language

    Cons:

    * Lack of interactivity
    * Not quite as fast as C++ or Fortran yet
    * New language
    * Does not have a vibrant community

* [Julia] pros:

    * Interactive like Python, but performance much closer to C++ or Fortran
    * Looks more like Python/MATLAB: domain scientists can use it
    * Ability to write high-performance implementations of various algorithms
    * Composability
    * Multiple dispatch
    * Metaprogramming based on hygienic macros
    * Vibrant community, modern tooling
    * Rich ecosystem of packages for almost everything that are simple to
      install and use (Python has a similar ecosystem, but C++, Fortran or
      Chapel do not have that)

    Cons:

    * Does not always enforce static typing (the Julia compiler can
      sometimes infer type Any, which will be slow)
    * Garbage collector must be worked around for attaining maximum performance
    * Focus is more on making working implementations as easy as possible,
      rather than making optimized implementations as easy as possible;
      C++/Fortran lean in the latter direction
    * Ahead-of-time compilation to static executables is not yet as easy as
      with C++ or Fortran
    * New language

* [C++] pros:

    * High performance
    * Established language, building on 34 years of expertise
    * Possible to write code that is very fast in Release mode, but safe in
      Debug mode
    * Vibrant community, modern tooling
    * Used for HPC (3 out of top 10 codes written in C++ [1])
    * Multi-paradigm language, allowing to write libraries such as [Kokkos],
      that make C++ usable for multi-core CPUs and GPUs today

    Cons:

    * Steep learning curve
    * Very complex language
    * Can be tricky to match Fortran’s performance (possible with
      extra effort)
    * Arguably the math code does not look as simple as Fortran
    * Array operations not part of the language (worse error messages, slower
      compile times for Kokkos, compared to Fortran)
    * Large C++ projects require having developers with CS (computer science)
      skills on a team
    * Interactive usage (via [xeus-cling]) not as smooth as Python yet (see,
      e.g., this [issue][xeus-cling issue]), and C++ is more verbose than
      Python for interactive usage

* [Fortran] pros:

    * Satisfies all language requirements (easy to learn, high performance,
      mathematics in the language, etc.)
    * Established language, building on 62 years of expertise
    * Used for HPC (7 out of top 10 codes written in Fortran [1])
    * Compared to C++, Fortran codes are easier to maintain by domain
      scientists/physicists themselves

    Cons:

    * Lack of interactivity
    * Lack of modern architectures support (GPU)
    * Lack of modern tooling (IDE support, language
      interoperability, debugging, ...)
    * Missing vibrant community (standards committee adding
      features without a prototype in any compiler; missing ecosystem of easy
      to install packages like Julia has)
    * Lack of generic programming: codes often use C macros for simple things,
      not possible to write libraries like Kokkos
    * While Fortran is still used a lot for already existing production codes,
      not many new projects choose Fortran
    * There are efforts of migrating from Fortran to C++ (but not the other way
      around)

References:  
[1] According to the 2017 NVidia survey [HPC User Site Census][] (pdf), 7 out
of the top 10 HPC codes are written in Fortran (ANSYS-Fluent, Gaussian, VASP,
Abaqus, NCAR-WRF, ANSYS, LS-DYNA), the other 3 are in C++ (GROMACS,
NAMD, OpenFOAM).

## Conclusion:

As of today (April 2019), the Fortran language is the only one that has pretty
much all the features that satisfy our requirements and as a nice bonus it is
an established language, the Cons come from the tooling. But tooling can be
fixed with a modern compiler and a community around it, and that is the
motivation why we created LFortran.

It is important to also point out that all the languages will keep evolving.
Each has started from a different starting point (more static or more dynamic,
fewer or more parallel features, less or more specific to numerical computing),
and all such efforts are worthwhile to pursue.

# LFortran

LFortran is a modern open-source (BSD licensed) interactive Fortran compiler
built on top of LLVM. It can execute user's code interactively to allow
exploratory work (much like Python, MATLAB or Julia) as well as compile to
binaries with the goal to run user's code on modern architectures such as
multi-core CPUs and GPUs.

It allows Fortran to be used in a Jupyter notebook (see the
[static][lfortran 1] or [interactive][lfortran 2] example notebook), it has a
command line REPL, but it also compiles to executables. More importantly, it
has a very modular design (see the [Developer Tutorial]), which keeps the
compiler easy to understand and clean, and at the same time allowing tools to
be written on top.  Right now only a small subset of Fortran is supported, but
the goal is to eventually support all of the latest standard (Fortran 2018).
The [main][lfortran doc] documentation page lists the current features, the
planned features and a roadmap.

We are trying the Fortran compiler to be nicely designed as a library with a
nice Python API. SymPy does this to symbolic mathematics --- instead of using
some symbolic manipulation software as a black box, it nicely gives you access
to the symbolic tree as a Python library and you can do things with it. With
LFortran we are trying to do the same: instead of using the compiler as a black
box, it nicely exposes Fortran as an
[AST and ASR trees/representations][lfortran design], allowing people to write
tools on top.

## Domain specific versus general purpose

An important fundamental difference between C++ and Fortran to keep in mind is
that C++ is more *general purpose* and so one can write libraries like Kokkos
or XTensor that allow to use C++ on multi-core CPUs and GPUs, which has the
advantage that C++ can get the job done today, but a disadvantage that the
compiler does not understand the domain, and thus generates worse error
messages and takes long time to compile.

Fortran, on the other hand, is more *domain specific* and so one must implement
all such support in the language itself, which has the advantage that the
compiler understands the domain and can compile quickly and give good error
messages and semantic checks, but a disadvantage that if the compilers for the
language are lacking, then there is no good path forward. We are trying to fix
that with LFortran.

# Related projects

## Burst compiler in Unity

[Unity] is a commercial game engine used by hundreds of games. In a [blog
post][unity 1] they describe how they are moving away from C++ to C# with a
custom compiler toolchain (called Burst) in order to gain:

* performance
* access to the toolchain to more easily improve performance of the compiler
* more easily see and control the machine code generated
* easier and safer language
* optimization granularity

[Here][unity 2] is a worked out example where C# with Burst delivers a better
performance than C++.

There is a good [talk][unity vid] by Andreas Fredriksson about the compiler and
how it works. The motivation and approach pretty much directly translates to
LFortran also (we use Fortran instead of C#, as our goal is numerical
scientific array oriented computing, while Burst's goal is to optimize Unity,
but the approach is very similar).

See also a follow up [blog post][unity 3].

## Other interactive compilers

Many traditionally compiled languages have a REPL (read-eval-print loop).
C++ has [cling][] (and [xeus-cling] for
Jupyter support).
Swift has a [REPL][Swift REPL].
Rust has an open
[issue][Rust REPL] for implementing a proper REPL.
Julia has a [REPL][Julia REPL].

## Flang and F18

[Flang] is an LLVM based Fortran compiler developed by NVIDIA, and it is
based on a PGI compiler, which has a long history. As a result, the source code
is not the most approachable. For that reason, they decided to also develop a
new front end from scratch, called [f18]. F18 has been recently
[accepted][f18 llvm] to LLVM itself. Neither Flang nor f18 is interactive.

We have been discussing with the Flang project manager at NVIDIA to figure out
how to join forces so that LFortran can use f18, for example as a parser.



[lfortran doc]: https://docs.lfortran.org/ "LFortran Documentation"
[lfortran design]: https://docs.lfortran.org/design/
[lfortran 1]: https://nbviewer.jupyter.org/gist/certik/f1d28a486510810d824869ab0c491b1c
[lfortran 2]: https://mybinder.org/v2/gl/lfortran%2Fweb%2Flfortran-binder/master?filepath=Demo.ipynb
[Developer Tutorial]: https://docs.lfortran.org/developer_tutorial/

[MATLAB]: https://www.mathworks.com/products/matlab.html
[C]: https://en.wikipedia.org/wiki/C_(programming_language)
[C++]: https://isocpp.org/
[Go]: https://golang.org/
[Swift]: https://swift.org/
[C#]: https://en.wikipedia.org/wiki/C_Sharp_(programming_language)
[Java]: https://en.wikipedia.org/wiki/Java_(programming_language)
[Rust]: https://www.rust-lang.org/
[Zig]: https://ziglang.org/
[Pony]: https://www.ponylang.io/
[V]: https://vlang.io/
[Jai]: https://inductive.no/jai/
[XTensor]: http://quantstack.net/xtensor
[Kokkos]: https://github.com/kokkos/kokkos
[cling]: https://github.com/root-project/cling
[xeus-cling]: https://github.com/QuantStack/xeus-cling
[xeus-cling issue]: https://github.com/QuantStack/xeus-cling/issues/91
[Python]: https://www.python.org/
[NumPy]: http://www.numpy.org/
[Ruby]: https://www.ruby-lang.org
[Cython]: https://cython.org/
[NumBa]: http://numba.pydata.org/
[Pythran]: https://pythran.readthedocs.io
[Chapel]: https://chapel-lang.org/
[Julia]: https://julialang.org/
[Fortran]: https://en.wikipedia.org/wiki/Fortran
[HPC User Site Census]: https://www.nvidia.com/content/intersect-360-HPC-application-support.pdf

[Unity]: https://en.wikipedia.org/wiki/Unity_(game_engine)
[Unity 1]: http://lucasmeijer.com/posts/cpp_unity/
[Unity 2]: https://aras-p.info/blog/2018/03/28/Daily-Pathtracer-Part-3-CSharp-Unity-Burst/
[Unity 3]: https://blogs.unity3d.com/2019/02/26/on-dots-c-c/
[Unity vid]: https://www.youtube.com/watch?v=NF6kcNS6U80

[Julia REPL]: https://docs.julialang.org/en/v1/stdlib/REPL/index.html
[Swift REPL]: https://developer.apple.com/swift/blog/?id=18
[Rust REPL]: https://github.com/rust-lang/rfcs/issues/655

[Flang]: https://github.com/flang-compiler/flang
[f18]: https://github.com/flang-compiler/f18
[f18 llvm]: https://lists.llvm.org/pipermail/llvm-dev/2019-April/131703.html

<!-- LA-UR-19-23406 -->
