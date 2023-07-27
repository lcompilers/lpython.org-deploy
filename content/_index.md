# Feature Highlights

LFortran is in development, there are features that work today, and there are
features that are being implemented.

## Works today

* **Full Fortran 2018 parser**  
    LFortran can parse any Fortran 2018 syntax to AST (Abstract Syntax Tree)
    and format it back as Fortran source code (`lfortran fmt`).

* **Interactive, Jupyter support**  
    LFortran can be used as a Jupyter kernel, allowing Python/Julia-style rapid
    prototyping and an exploratory workflow (`conda install jupyter lfortran`).
    It can also be used from the command-line with an interactive prompt
    (REPL).

* **Clean, modular design, usable as a library**  
    LFortran is structured around two independent modules, AST (Abstract Syntax
    Tree) and ASR (Abstract Semantic Representation), both of which are
    standalone (completely independent of the rest of LFortran) and users are
    encouraged to use them independently for other applications and build tools
    on top. See the [Design](https://docs.lfortran.org/design/) and
    [Developer Tutorial](https://docs.lfortran.org/developer_tutorial/) documents for
    more details.

* **Create executables**  
    It can create executables just like other Fortran compilers.

* **Runs on Linux, Mac, Windows and WebAssembly**  
    All four platforms are regularly tested by our CI.

* **Several backends**
    The LLVM can be used to compile to binaries and for interactive usage. The
    C++ backend translates Fortran code to a readable C++ code. The x86 backend
    allows very fast compilation directly to x86 machine code. The WebAssembly
    backend can quickly generate WASM.


## Under Development

These features are under development:

* **Full Fortran 2018 support**  
    The parser can now parse all of Fortran 2018 syntax to AST. A smaller
    subset can be transformed into ASR and even smaller subset compiled via
    LLVM to machine code. We are now working on extending the subset that
    LFortran can fully compile until we reach full Fortran 2018 support.

* **Support for diverse hardware**  
    LLVM makes it possible to run LFortran on diverse hardware and take
    advantage of native Fortran language constructs (such as `do concurrent`)
    on multi-core CPUs and GPUs.

Please vote on issues in our [issue tracker] that you want us to prioritize
(feel free to create new ones if we are missing anything).


[static]: https://nbviewer.jupyter.org/gist/certik/f1d28a486510810d824869ab0c491b1c
[interactive]: https://mybinder.org/v2/gl/lfortran%2Fweb%2Flfortran-binder/master?filepath=Demo.ipynb

[issue tracker]: https://github.com/lfortran/lfortran/issues
