---
title: Why to Use Fortran For New Projects
date: 2019-05-07
tags: ["Fortran", "Motivation"]
author: "[John Pask](https://pls.llnl.gov/people/staff-bios/physics/pask-j), [Ondřej Čertík](https://ondrejcertik.com/)"
type: post
---


We received a lot of positive feedback on our LFortran [announcement]. Most
generally like the idea and tool, and expressed interest to hear a bit more on
why we think Fortran is a superior language in its domain and why it makes
sense to use Fortran for new projects.

## Why Fortran?

Fortran was designed from the ground up to naturally and simply translate
mathematics to code that compiles and runs at maximum speed. And being
specifically targeted for such fundamentally computational tasks, it contains a
broad range of key functionality within the language itself, standard across
all platforms, with no need for external libraries that may or may not be well
optimized or maintained, at present or down the road.

Some highlights:

* Multidimensional arrays which can be allocated and indexed as the
  math/science dictates (not restricted to start at 0 or 1) and can be sliced
  as desired (as, e.g., in MATLAB);
* Operators which operate naturally upon the aforementioned arrays/matrices, as
  they do scalars;
* Complex numbers;
* Special functions;
* Structures and pointers for more general data representation.

Because the essentials are contained in the language itself, it is simple to
read and write, without need of choosing from among or deciphering a
proliferation of external classes to do the same thing. And because the
essentials are self-contained, compilers can provide detailed compile-time
(e.g., argument mismatch) and run-time (e.g., memory access) checks, as well as
highly optimized executables, directly from natural, readable code without need
of extensive optimization heroics by the developer.

If you are interested in learning more, please see our webpage at
[fortran90.org] with recommended practices for writing code, side by side
comparison with Python/NumPy, links to other online Fortran resources and
books, and an FAQ.

The above distinguishing aspects, among many others, have made Fortran the
language of choice in high-performance computing for decades. Indeed, by virtue
of the simplicity of expressing the desired mathematics and corresponding ease
of maintenance by application scientists/engineers (i.e., by the users
themselves), the majority of HPC application codes in widest use today are
written mostly or completely in Fortran (e.g., 7 out of the top 10 HPC codes
from this 2017 [NVIDIA survey] are written in Fortran). And yet, new projects
are being started in Fortran less and less, despite its manifest advantages.

The reasons for this, we believe, are clear, ranging from lack of freely
available and modern tooling to lack of exposure in the education pipeline, as
elaborated in our previous blog post.

The goal of this project is to address these needs and, in so doing, bring the
significant advantages of Fortran to the full range of computational science
and engineering applications which stand to benefit.

**Trackbacks:**

* [Twitter](https://twitter.com/OndrejCertik/status/1125782465493123072)

[announcement]: https://lfortran.org/blog/2019/04/why-we-created-lfortran/
[fortran90.org]: https://www.fortran90.org/
[NVIDIA survey]: https://www.nvidia.com/content/intersect-360-HPC-application-support.pdf

<!-- LA-UR-19-24165 -->
