---
title: "LFortran Breakthrough: Now Building Legacy and Modern Minpack"
date: 2023-05-02
tags: ["Fortran", "Announcement"]
author: "[Ondřej Čertík](https://ondrejcertik.com/), [Brian Beckman](https://www.linkedin.com/in/brianbeckman), [Gagandeep Singh](https://github.com/czgdp1807), [Thirumalai Shaktivel](https://www.linkedin.com/in/thirumalai-shaktivel/), [Rohit Goswami](https://rgoswami.me), [Smit Lunagariya](https://www.linkedin.com/in/smit-lunagariya-356b93179/), [Ubaid Shaikh](https://www.ubaidshaikh.me/), [Pranav Goswami](https://www.linkedin.com/in/pranavgoswami1/)"
type: post
draft: false
---

Two days ago on April 30, 2023 was the 4th anniversary of LFortran's
[initial release]. Our initial prototype in 2019 was in Python. Since then we
have rewritten to C++ for speed and robustness. In 2021 we announced an [MVP].

In this update, we are happy to announce that [LFortran](https://github.com/lfortran/lfortran) can compile and run both
legacy and modern Minpack. We'll start off by taking a look at the current
compilation status and benchmarks of minpack. From there, we'll provide an
overview of where LFortran is currently at and share our next steps going
forward.

# Minpack Overview

Let us briefly recall why MINPACK is of importance to the wider community and makes a good test case.

> MINPACK is a collection of Fortran subroutines for solving nonlinear equations and nonlinear least squares problems. It is a fundamental component of many scientific and engineering applications, and has been widely used since its release in the 1970s. Its importance extends to modern data science, as it forms the core of the optimization routines used in the popular Python library, SciPy. The MINPACK algorithms provide robust and efficient solutions to nonlinear optimization problems, and have been critical in fields such as physics, chemistry, and engineering, among others. The availability of MINPACK in both Fortran and Python has enabled efficient and effective solutions to complex problems across multiple domains.
> --- ChatGPT 3.5 / Wikipedia

We can now compile Minpack to executables, both legacy (verbatim from
the [SciPy] Python library) and modern ([fortran-lang/minpack]), both are now
tested at our CI for every commit to LFortran.

Here is how you can try it yourself by installing the latest version (0.19.0) of `lfortran` using Conda:
```console
$ conda create -n lfenv -c conda-forge lfortran=0.19.0
$ conda activate lfenv
$ git clone https://github.com/fortran-lang/minpack
$ cd minpack
$ lfortran -c src/minpack.f90
$ lfortran examples/example_hybrd.f90
FINAL L2 NORM OF THE RESIDUALS 1.19263583475980921e-08 NUMBER OF FUNCTION EVALUATIONS 14 EXIT PARAMETER 1 FINAL APPROXIMATE SOLUTION

-5.70654511600659053e-01
-6.81628342291230593e-01
-7.01732452563471165e-01
-7.04212940083752348e-01
-7.01369047627288800e-01
-6.91865643379914186e-01
-6.65792012154689195e-01
-5.96034201280816633e-01
-4.16412062998471999e-01
```
The results can be verified against GFortran:
```console
$ gfortran src/minpack.f90 examples/example_hybrd.f90 && ./a.out
     FINAL L2 NORM OF THE RESIDUALS  0.1192636D-07

     NUMBER OF FUNCTION EVALUATIONS        14

     EXIT PARAMETER                         1

     FINAL APPROXIMATE SOLUTION

      -0.5706545D+00 -0.6816283D+00 -0.7017325D+00
      -0.7042129D+00 -0.7013690D+00 -0.6918656D+00
      -0.6657920D+00 -0.5960342D+00 -0.4164121D+00
```

## Performance

Some preliminary benchmarks have been run, and the results are very promising as can be seen in the table below:

| Compiler & Flags                  | Ubuntu 22.04 Relative Execution Time (n=523) | Mac M1 2020 Relative Execution Time (n=523) | Apple M1 2020 MacBook Pro macOS Ventura 13.3.1 Relative Execution Time (n=825) | Apple M1 Max Relative Execution Time (n=523) |
| ---------------------------------- | ------------------------------------ | ----------------------------------- | ------------------------------------------- | ----------------------------------- |
| GFortran with -ffast-math           | 1.000 (0.196 s)                      | 1.000 (0.641 s)                      | 1.000 (0.350 s)                             | 1.000 (0.090 s)                      |
| LFortran --fast                     | 4.299 (0.842 s)                      | 1.196 (0.641 s)                      | 1.829 (0.766 s)                             | 1.778 (0.160 s)                      |
| GFortran without -ffast-math        | 2.418 (0.474 s)                      | 1.078 (0.692 s)                      | 1.686 (0.590 s)                             | 1.667 (0.150 s)                      |
| Clang -O3 -ffast-math               | -                                    | -                                    | 1.886 (0.660 s)                             | -                                   |
| LFortran, Clang with -ffast-math    | 1.265 (0.248 s)                      | -                                    | -                                           | -                                   |

These results show the relative execution times of different compilers and compiler flags on four different machines.

The first column shows the compiler and flags used. The second, third, fourth, and fifth columns show the relative execution time of each compiler and flag combination on Ubuntu 22.04, Mac M1 2020, Apple M1 2020 MacBook Pro macOS Ventura 13.3.1, and Apple M1 Max, respectively. The times are given in seconds within brackets.

For example, on Ubuntu 22.04, GFortran with `-ffast-math` had an execution time of 0.196 seconds, and all other compilers/flags were compared to this time. On Mac M1 2020, the same code compiled with GFortran and `-ffast-math` had an execution time of 0.641 seconds, which is why the relative execution time for GFortran on this machine is also 1.000.

The `lfortran --fast` version enables "safe" optimizations in LLVM, but not
"fast-math" optimizations yet (if you know how to do it, please send us a PR).
For now we can test the "fast-math" optimizations by first saving to LLVM IR
and then using Clang with `-ffast-math`.

Our design allows us to do high level optimizations in our intermediate
representation which we call Abstract Semantic Representation (ASR). We already
have quite a few ASR to ASR passes, but they are currently mostly used to
simplify ASR for easier lowering to LLVM. Once we can compile most Fortran
codes, we will focus more on implementing various optimizations as ASR to ASR
passes. However, as you can see from the benchmarks, we are already within a
factor of 2x against GFortran, a mature open source optimizing compiler (if we
compare either "fast-math" optimizations in both, or turn it off in both).
Consequently we believe we will be able to close the gap in the future and
provide the high performance that Fortran users expect.

# LFortran Tenets

- **Fast:** The LFortran compiler must be fast to compile user's code and the generated executable must be fast to run in Release mode. The C++ code of the compiler itself must be fast to build (currently it takes about 25s on Apple M1 Max).
- **Agile Development:** Minutes to days to merge a Pull Request (PR).
- **Low Budget:** Not attached to a big corporation, does not require big budget. Scrappy startup flavor effort. Just a handful of people managed to bring in 4 years from nothing to Minpack.
- **Easy to Retarget:** Many backends already: LLVM, C, C++, WASM, Julia, x64. More planned (Python, Fortran, arm64).
- **Flexible Backends:** Must run on any hardware.
- **Maximum Performance:** Our goal is maximum performance on all hardware (CPU, GPU, APU, HPC, WASM, etc.).
- **Easy to Change Surface Language:** We currently have [LFortran] and [LPython]. We plan to add more frontends (C, C++, etc.).
- **Interactive and Binary Compiler:** Compile interactively (Jupyter notebook) and to binaries.
- **Clear Roadmap:** Focused clean development.


## Current Status

* LFortran LLVM binary compilation: alpha (556 tests and legacy/modern Minpack)
* Free-form parser: beta (should be able to parse any code, close to 1000 tests)
* Fixed-form parser: alpha (can parse all of SciPy, but not necessarily all other
  fixed-form code; about 100 tests and all of SciPy)
* Interactivity (Jupyter notebook): alpha
* Online version via WASM ([dev.lfortran.org](https://dev.lfortran.org/)): alpha
* Backends:
  * LLVM: alpha (409 integration tests, 147 reference tests)
  * C/C++: alpha (52 integration tests, 40 reference tests)
  * Julia: alpha (45 reference tests)
  * WASM: alpha (180 integration tests)
  * x64 (via WASM): alpha (19 integration tests, 2 reference tests)
* Language features that fully compile and work:
  * Large subset of F77, F90 and F95:
    * All primitive types (integer, real, complex, logical, character), 32 and
      64 bit
    * Multi-dimensional arrays
    * Derived types
    * Function Callbacks
    * Nested functions (closures)
    * Many intrinsic functions (trigonometric, clock, sum/any/, etc.)
    * Generic procedures
    * `iso_c_binding` (F2003)
  * Almost every significant feature of F95, F03, F08 and F18 has at least a prototype
    mode, including type bound procedures, inheritance, do concurrent, etc.
  * Prototype of F202Y generics (templates)

Note: *alpha* means it is expected to break (you have to workaround
the limitations), *beta* means it is expected to work (but have bugs) and *production*
means it is expected to have no bugs.

Here are the stages of development:

| Stage          | Expectation     | Tests      | Who provides tests |
| -------------- | --------------- | ---------- | ------------------ |
| **prototype**  | breaks          | 0 - 100    | author (biased)    |
| **alpha**      | breaks          | 100 - 500  | internal customers |
| **beta**       | works, has bugs | 500 - 1000 | external customers |
| **production** | works, no bugs  | > 1000     | everyone           |

And we list the number of tests that we have for each part of LFortran, so you
can get an idea of the development status and robustness.

The overall status of LFortran is *alpha*, using the default compilation to
binary via LLVM. As you can see, it is much closer to beta than a prototype,
but we are not beta yet.


## Timeline and Prognosis

* 0 years (April 30, 2019): [initial release]
* 2.5 years (September 23, 2021): [MVP]
* 4 years (April 30, 2023): Minpack runs

Is our progress fast or slow? Generally it takes about 3-5 years to create a
compiler from scratch for a large mainstream language, and about 10 years to get
a production mature industry-strength compiler with optimizations. Our team is
still small. In the initial stages it was just the efforts of a single person
(Ondřej) working part time. Over the last 1.5 years we first had two and now
around 5 people working part time.
Overall we believe we are on schedule, with increasing momentum and new features rolling in on a weekly basis.

Consider our contributors over time, compared against the "classic" `flang`, an industrial effort:

![lfortran vs flang](https://gitlab.com/lfortran/web/www.lfortran.org/uploads/da7205b9ef33f6496b98b4ace0f3d4f8/github-contributor-over-time-20230502.png "Contributors over time compared to `flang`, [with this tool](https://git-contributor.com/?chart=contributorOverTime&repo=lfortran/lfortran,flang-compiler/flang)")

A more telling picture is from the standard Github visual:

![lfortran github time](https://gitlab.com/lfortran/web/www.lfortran.org/uploads/95196b49eb59c62e93e4ba6de806bc90/image.png "Contributions over time")

Where we see much of the effort was single handedly Ondřej for the first 2.5
years. Then over the last 1.5 years others joined. Ondřej also took almost 1
year off to [bootstrap] fortran-lang around 2020.


# What's Next?

We have funding and a small team working on compiling the Fortran Package
Manager ([fpm]) and the rest of [SciPy]. We are always looking for more
contributors, if you are interested, please get in touch.

Our immediate focus is on compiling as many Fortran codes as possible, starting
with `fpm` and `SciPy`. After we can compile and run large parts of the Fortran
ecosystem, we will focus on interactivity, runtime performance and various
tools built on top such as language servers, running on hardware accelerators,
running online (WASM), Fortran to C++, Python and Julia translation, etc.


# Acknowledgements

We want to thank:

* [GSI Technology](https://www.gsitechnology.com/)
* [LANL](https://lanl.gov/)
* [NumFOCUS](https://numfocus.org/)
* [Sovereign Tech Fund (STF)](https://sovereigntechfund.de/en/)
* [QuantStack](https://quantstack.net/)
* [Google Summer of Code](https://summerofcode.withgoogle.com/)
* Our GitHub, OpenCollective and NumFOCUS sponsors
* All our contributors (51 so far!)


# Discussions

* Twitter: https://twitter.com/lfortranorg/status/1653421763261501440
* Fortran Discourse: https://fortran-lang.discourse.group/t/lfortran-can-now-build-legacy-and-modern-minpack/5718


[SciPy]: https://github.com/scipy/scipy/tree/f797ac7721310c7bd98bae416be1bed9975b4203/scipy/optimize/minpack
[fortran-lang/minpack]: https://github.com/fortran-lang/minpack
[initial release]: https://lfortran.org/blog/2019/04/why-we-created-lfortran/
[MVP]: https://lfortran.org/blog/2021/09/lfortran-minimum-viable-product-mvp/
[fpm]: https://github.com/fortran-lang/fpm
[dev.lfortran.org]: https://dev.lfortran.org/
[bootstrap]: https://ondrejcertik.com/blog/2021/03/resurrecting-fortran/
[LFortran]: https://lfortran.org/
[LPython]: https://lpython.org/
