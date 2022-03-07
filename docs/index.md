## LPython

LPython is an ahead-of-time compiler for Python, built using the Abstract Semantic Representation (ASR) technology. Part of the
[LCompilers](https://lcompilers.org) collection.

LPython is written in C++, and it has multiple backends to generate code, including [LLVM](https://llvm.org/) and C++.
The compiler has been open-sourced under the BSD license, available at [github.com/lcompilers/lpython](https://github.com/lcompilers/lpython).
It is designed as a library with separate building blocks -- the parser, Abstract Syntax Tree [AST], Abstract Semantic Representation [ASR], semantic phase, codegen -- that are all exposed to the user or developer in a natural way to make it easy to contribute back. It works on Windows, Linux, and Mac OS.
The speed of LPython comes from the high-level optimizations done at the ASR level, as well as the low-level optimizations that the
LLVM can do. In addition, it is remarkably easy to customize the backends.

It is in heavy development, currently in pre-alpha stage, and aims to give the best possible performance for array-oriented code. Remarks and suggestions are very welcome.

Any questions? Ask us on Zulip [![project chat](https://img.shields.io/badge/zulip-join_chat-brightgreen.svg)](https://lfortran.zulipchat.com/)
or our [mailing list](https://groups.io/g/lfortran).

Links to other available Python compilers:

* [Cython](https://cython.org/)
* [Pythran](https://pythran.readthedocs.io/en/latest/)
* [Numba](https://numba.pydata.org/)
* [Transonic](https://transonic.readthedocs.io/en/latest/index.html)
* [Nuitka](https://nuitka.net/)
* [Seq-lang](https://seq-lang.org/)
* [Pytorch](https://pytorch.org/)
* [JAX](https://github.com/google/jax)
* [Weld](https://www.weld.rs/)
* [CuPy](https://cupy.dev/)
* [Pyccel](https://github.com/pyccel/pyccel)
* [uarray](https://github.com/Quansight-Labs/uarray)
* [PyPy](https://doc.pypy.org/en/latest/)
* [Pyston](https://github.com/pyston/pyston)
* [Hope](https://github.com/jakeret/hope)
* [Shedskin](https://github.com/shedskin/shedskin)
* [Grumpy](https://github.com/google/grumpy)
* [Jython](https://www.jython.org/)
* [IronPython](https://ironpython.net/)
* [PyJs](http://pyjs.org/)
