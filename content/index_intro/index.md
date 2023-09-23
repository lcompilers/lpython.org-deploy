---
headless: true
date: 2023-07-28
---

LPython aggressively optimizes type-annotated Python code. It has several
backends, including LLVM, C, C++, and WASM. LPython’s primary tenet is speed.

LPython is in alpha stage (meaning users enthusiastically participate in bug
reporting and fixing). LPython will compile more of Python in the future, and
accumulate more optimizations, experimental and production-ready. LPython makes
it easy to write new back-ends for custom, exotic, or unusual hardware.
Release blog post: [LPython: Novel, Fast, Retargetable Python Compiler](https://lpython.org/blog/2023/07/lpython-novel-fast-retargetable-python-compiler/).

Main repository at GitHub:
[https://github.com/lcompilers/lpython](https://github.com/lcompilers/lpython)
{{< github_lpython_button >}}

Try LPython in your browser using WebAssembly: https://dev.lpython.org/

Any questions? Ask us on Zulip [![project chat](https://img.shields.io/badge/zulip-join_chat-brightgreen.svg)](https://lfortran.zulipchat.com/#narrow/stream/311866-LPython).
