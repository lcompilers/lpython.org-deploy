# Feature Highlights

LPython is in heavy development, there are features that work today, and there are
features that are being implemented.

## Works today

* **Best possible performance for numerical, array-oriented code**  
    LPython gives you the speed you need for your numerical, array-oriented code. With LPython, you can write Python code that is as fast as C or C++. This is because LPython compiles your code to optimized machine code, which is the fastest way to run code on a computer.

* **Code compatability with CPython**  
    If LPython compiles and runs a code, then it will run in CPython.

* **Seamless interoperability with CPython**  
    LPython can call functions in CPython libraries. This feature permits “break-out” to Numpy, TensorFlow, PyTorch, and even to matplotlib. The break-outs will run at ordinary (slow) Python speeds, but LPython accelerates the mathematical portions to near maximum speed.

* **Just-In-Time (JIT) compilation**  
    LPython also supports Just-in-time compilation which requires only decorating Python function with @lpython. One can also specify the desired backend, as in, `@lpython(backend=“c”)` or `@lpython(backend=“llvm”)`. Only C is supported at present; LLVM and others will be added in the near future.

* **Clean, modular design, usable as a library**  
    LPython is structured around two independent modules, AST (Abstract Syntax
    Tree) and ASR (Abstract Semantic Representation), both of which are
    standalone (completely independent of the rest of LPython) and users are
    encouraged to use them independently for other applications and build tools
    on top. See the [Design](https://docs.lfortran.org/design/) and
    [Developer Tutorial](https://docs.lfortran.org/developer_tutorial/) documents for
    more details.

* **Create executables**  
    It can create fast optimized executables unlike other interpreted compilers.

* **Runs on Linux, Mac, Windows and WebAssembly**  
    All four platforms are regularly tested by our CI.

* **Several backends**  
    The LLVM can be used to compile to binaries and for interactive usage. The
    C/C++ backend translates Python code to a readable C/C++ code. The x86 backend
    allows very fast compilation directly to x86 machine code. The WebAssembly
    backend can quickly generate WASM.


## Under Development

These features are under development:

* **Interactive, Jupyter support**  
    LPython is coming soon to Jupyter. It can be used as a Jupyter kernel,
    allowing Python/Julia-style rapid prototyping and an exploratory
    workflow (`conda install jupyter lpython`).
    It can also be used from the command-line with an interactive prompt
    (REPL).

* **Support for diverse hardware**  
    LLVM makes it possible to run LPython on diverse hardware.
    We plan to support a wide range of hardware platforms, including:

    CPUs: compile Python code to run on CPUs of all architectures, including x86, ARM, and POWER.
    GPUs: compile Python code to run on GPUs from NVIDIA, AMD, and Intel.
    TPUs: compile Python code to run on TPUs from Google.

Please vote on issues in our [issue tracker] that you want us to prioritize
(feel free to create new ones if we are missing anything).


[issue tracker]: https://github.com/lcompilers/lpython/issues
