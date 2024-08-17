# Linkage
[The Rust Reference](https://doc.rust-lang.org/reference/linkage.html)

[Cargo Targets - The Cargo Book](https://doc.rust-lang.org/cargo/reference/cargo-targets.html)

## `staticlib`
[micahsnyder/cmake-rust-demo: A project that demonstrates building a C application with CMake that has Rust static library components](https://github.com/micahsnyder/cmake-rust-demo)

[→CXX](/Language/FFI.md#cxx)

What if the library links other C libraries?
- At leasy it's possible to bundle them yourself.
  
  [linux - How to merge two "ar" static libraries into one? - Stack Overflow](https://stackoverflow.com/questions/3821916/how-to-merge-two-ar-static-libraries-into-one)

- They are bundled. The filenames in the final `.lib` are absolute paths to the `.obj` files, instead of `{crate}-{hash1}.{crate}.{hash2}-cgu-{n}-rcgu.o`.

  The header files may be found at `%USERPROFILE%\.cargo\registry\src\index.crates.io-6f17d22bba15001f\foo-sys-0.1.0\include`.

  Cargo is nearly a C++ package manager.

  [How much work would be involved to use Cargo for C++? : r/rust](https://www.reddit.com/r/rust/comments/1d2d5ub/how_much_work_would_be_involved_to_use_cargo_for_c/)

## `dylib`
[Rust Plugins - Rust Tutorials](https://zicklag.github.io/rust-tutorials/rust-plugins.html)
- [Appendix A: Rust Library Types - Rust Tutorials](https://zicklag.github.io/rust-tutorials/appendix-a.html)

  [What is the Difference Between `dylib` and `cdylib` - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/what-is-the-difference-between-dylib-and-cdylib/28847)

[ABI stability guarantee of dylib vs cdylib - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/abi-stability-guarantee-of-dylib-vs-cdylib/50879)

## `cdylib`
Libraries:
- [libloading: Bindings around the platform's dynamic library loading primitives with greatly improved memory safety.](https://github.com/nagisa/rust_libloading/)
  - [sharedlib: A cross-platform shared library loader.](https://github.com/Tyleo/sharedlib)

- [szymonwieloch/dlopen: Rust library for opening and working with dynamic link libraries.](https://github.com/szymonwieloch/rust-dlopen)
  - [ahmed-masud/dlopen](https://github.com/ahmed-masud/rust-dlopen)
    - [dlopen2](https://github.com/OpenByteDev/dlopen2)
      - [Comparison with other libraries](https://github.com/OpenByteDev/dlopen2#comparison-with-other-libraries)
      - Warning: structure field / method `MyFunc` should have a snake case name
        ```rust
        #[allow(non_snake_case)]
        #[derive(WrapperApi)]
        struct Api {
            #[allow(non_snake_case)]
            MyFunc: ...
        }
        ```
        `#[allow(non_snake_case)] struct Api` is not enough.

- [abi\_stable\_crates: Rust-to-Rust ffi,ffi-safe equivalents of std types,and creating libraries loaded at startup.](https://github.com/rodrimati1992/abi_stable_crates)

- [dl\_api: The easiest, simplest and safest way to load dynamic (shared object) libraries from Rust!](https://github.com/AldaronLau/dl_api) (discontinued)

Windows-only:
- [windows-dll: Macro for dynamically loading windows dll functions](https://github.com/thisKai/rust-windows-dll)
- [rusty-memory-loadlibrary: Load DLLs from memory with rust](https://github.com/malware-unicorn/rusty-memory-loadlibrary)
- [reflective\_pe\_dll\_loader: A reflective PECOFF DLL loader](https://github.com/JohnScience/reflective_pe_dll_loader)
- [valarauca/dynlib: Use DLL's in Rust](https://github.com/valarauca/dynlib) (discontinued)
- [DLL loader in Rust. Going down the rabbit hole with Rust... | by Dan Groner | Medium](https://medium.com/@dangroner/dlls-in-rust-e1322da511da)

## CRT
[How to link CRT statically when building with MSVC? : r/rust](https://www.reddit.com/r/rust/comments/ekts0d/how_to_link_crt_statically_when_building_with_msvc/)

`.cargo/config.toml`:
```toml
[target.x86_64-pc-windows-msvc]
rustflags = ["-C", "target-feature=+crt-static"]
```

```toml
[target.'cfg(all(target_os = "windows", target_env = "msvc"))']
rustflags = ["-C", "target-feature=+crt-static"]
```

[rustc always links against non-debug Windows runtime - Issue #39016 - rust-lang/rust](https://github.com/rust-lang/rust/issues/39016)
- `$env:CFLAGS=$env:CXXFLAGS='/MTd'`
- [The MSVC CRT library is not overrideable by other build systems - Issue #107570 - rust-lang/rust](https://github.com/rust-lang/rust/issues/107570)
- [Windows MSVC CRT linking - Issue #211 - rust-lang/libs-team](https://github.com/rust-lang/libs-team/issues/211)
- [CXX how to get a MSVCRTD-based debug-build LIB on Windows : r/rust](https://www.reddit.com/r/rust/comments/14wjxih/cxx_how_to_get_a_msvcrtdbased_debugbuild_lib_on/)