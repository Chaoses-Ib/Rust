# Foreign Function Interface
- [Diplomat: Experimental Rust tool for generating FFI definitions allowing many other languages to call Rust code](https://github.com/rust-diplomat/diplomat/)

  [Supported languages](https://github.com/rust-diplomat/diplomat/tree/main/tool/src): C, C++, JS, C#, Dart.
  - [Support for free functions - Issue #392 - rust-diplomat/diplomat](https://github.com/rust-diplomat/diplomat/issues/392)
  - No support for bit flags.
  
  [diplomat - Rust](https://docs.rs/diplomat/latest/diplomat/)
  - [`diplomat/feature_tests/src/attrs.rs`](https://github.com/rust-diplomat/diplomat/blob/main/feature_tests/src/attrs.rs)

- [cbindgen: A project for generating C bindings from Rust code](https://github.com/eqrion/cbindgen)

  Supported languages: C, C++, Cython.
  - Support `bitflags`.

- [UniFFI: a multi-language bindings generator for rust](https://github.com/mozilla/uniffi-rs)

  Supported languages: Kotlin, Swift, Python, Ruby.
  - C#: [uniffi-bindgen-cs](https://github.com/NordSecurity/uniffi-bindgen-cs) (≥ .NET 6)
  - Go: [uniffi-bindgen-go](https://github.com/NordSecurity/uniffi-bindgen-go)

- [Interoptopus: The polyglot bindings generator for your library (C#, C, Python, …) 🐙](https://github.com/ralfbiedert/interoptopus) (inactive)

  Supported languages: C#, C, Python.

- [flapigen: Tool for connecting programs or libraries written in Rust with other languages](https://github.com/Dushistov/flapigen-rs)

  Supported languages: C++, Java.

[Comparing UniFFI with Diplomat - mozilla/uniffi-rs](https://github.com/mozilla/uniffi-rs/blob/main/docs/diplomat-and-macros.md)

## C
[FFI - The Rustonomicon](https://doc.rust-lang.org/nomicon/ffi.html)

Libraries:
- [std::ffi](https://doc.rust-lang.org/std/ffi/)
- [FFI Support: A crate to help expose Rust functions over the FFI.](https://github.com/mozilla/ffi-support)
- [libc: Raw bindings to platform APIs for Rust](https://github.com/rust-lang/libc)

C to Rust:
- [bindgen: Automatically generates Rust FFI bindings to C (and some C++) libraries.](https://github.com/rust-lang/rust-bindgen)

Rust to C:
- cbindgen
- Diplomat
  - `CStr` or `*const c_char` is not supported.

    Workaround:
    ```rust
    pub fn is_match_u8(pattern: &str, haystack: &str) -> bool {
        todo!()
    }

    pub fn is_match_u8c(pattern: &u8, haystack: &u8) -> bool {
        (|| -> Result<bool, Utf8Error> {
            Ok(Self::is_match_u8(
                unsafe { CStr::from_ptr(pattern as *const _ as *const i8) }.to_str()?,
                unsafe { CStr::from_ptr(haystack as *const _ as *const i8) }.to_str()?,
            ))
        })()
        .unwrap_or(false)
    }
    ```
- [safer_ffi: Write safer FFI code in Rust without polluting it with unsafe code](https://github.com/getditto/safer_ffi)
  - Strings still need FFI types.

    [`string_concat `- `safer_ffi` User Guide](https://getditto.github.io/safer_ffi/simple-examples/string_concat.html)
  - [Idea: provide specialized support for specific languages - Issue #18 - getditto/safer\_ffi](https://github.com/getditto/safer_ffi/issues/18)
- Interoptopus

Problems:
- Lifetimes
- Error handling

## C++
- [CXX: Safe interop between Rust and C++](https://github.com/dtolnay/cxx)
  - [Functions with explicit lifetimes](https://cxx.rs/extern-rust.html#functions-with-explicit-lifetimes)
  - [Error handling](https://cxx.rs/binding/result.html)
  
  Bit flags:
  - [Derive bitwise BitAnd and BitOr for shared enums - Issue #736 - dtolnay/cxx](https://github.com/dtolnay/cxx/issues/736)

C++ to Rust:
- [Autocxx: Tool for safe ergonomic Rust/C++ interop driven from existing C++ headers](https://github.com/google/autocxx)

Rust to C++:
- Diplomat
- cbindgen

## .NET
- P/Invoke
  - Diplomat
  - [uniffi-bindgen-cs](https://github.com/NordSecurity/uniffi-bindgen-cs)
  - Interoptopus
    - 只支持 ASCII 编码，会将 String 编码为 ANSI 后作为 [AsciiPointer](https://docs.rs/interoptopus/latest/interoptopus/patterns/string/struct.AsciiPointer.html "interoptopus::patterns::string::AsciiPointer struct") 传入。
    - 可以传入数组作为 [FFISlice](https://docs.rs/interoptopus/latest/interoptopus/patterns/slice/struct.FFISlice.html)。
    - 可以检查 Result 并抛出 InteropException。
    - 可以通过 [panics_and_errors_to_ffi_enum](https://docs.rs/interoptopus/latest/interoptopus/patterns/result/fn.panics_and_errors_to_ffi_enum.html) 捕获 panic。
  - C
  
    [How we integrate Rust with C#](https://blog.datalust.co/rust-at-datalust-how-we-integrate-rust-with-csharp/)
    - [A hybrid Rust + C# example](https://github.com/KodrAus/rust-csharp-ffi#getting-started)
  
    [Getting started with FFI: Rust & Unity](https://blog.testdouble.com/posts/2018-01-02-unity-rust-ffi-getting-started/)
  - C++

- Mixed assemblies
  - C++ + C++/CLI

- CLR host
  - [netcorehost: A .NET Core hosting library written in Rust with included bindings for nethost and hostfxr.](https://github.com/OpenByteDev/netcorehost)

- [Managed Rust](https://github.com/Chaoses-Ib/.NET/blob/main/Languages/Rust/README.md)

- IPC/RPC

[.NET to Rust bindgen experiments: Tried different approaches for generating dotnet to Rust bindings](https://github.com/CBenoit/dotnet-to-rust-bindgen-experiments)

## Python
- [PyO3: Rust bindings for the Python interpreter](https://github.com/PyO3/pyo3)
- cbindgen
- UniFFI
- Interoptopus
- [RustPython: A Python Interpreter written in Rust](https://github.com/RustPython/RustPython)
- [inline-python: Inline Python code directly in your Rust code](https://github.com/fusion-engineering/inline-python)
- [pythonvm-rust: An incomplete stackless interpreter of Python bytecode, written in Rust.](https://github.com/ProgVal/pythonvm-rust) (discontinued)
- [RsPython: Rust implementation of the python language](https://github.com/windelbouwman/rspython) (discontinued)

Tools:
- [maturin: Build and publish crates with pyo3, rust-cpython and cffi bindings as well as rust binaries as python packages](https://github.com/PyO3/maturin)

[Calling Rust from Python](https://blog.frankel.ch/rust-from-python/) ([Hacker News](https://news.ycombinator.com/item?id=37811953))