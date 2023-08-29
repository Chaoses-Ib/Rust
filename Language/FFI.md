# Foreign Function Interface
- [UniFFI: a multi-language bindings generator for rust](https://github.com/mozilla/uniffi-rs)

  Supported languages: Kotlin, Swift, Python, Ruby.
  - C#: [uniffi-bindgen-cs](https://github.com/NordSecurity/uniffi-bindgen-cs)
  - Go: [uniffi-bindgen-go](https://github.com/NordSecurity/uniffi-bindgen-go)

- [Interoptopus: The polyglot bindings generator for your library (C#, C, Python, …) 🐙](https://github.com/ralfbiedert/interoptopus)

  Supported languages: C#, C, Python.

- [flapigen: Tool for connecting programs or libraries written in Rust with other languages](https://github.com/Dushistov/flapigen-rs)

  Supported languages: C++, Java.

## C
[FFI - The Rustonomicon](https://doc.rust-lang.org/nomicon/ffi.html)

Libraries:
- [bindgen: Automatically generates Rust FFI bindings to C (and some C++) libraries.](https://github.com/rust-lang/rust-bindgen)
- [cbindgen: A project for generating C bindings from Rust code](https://github.com/eqrion/cbindgen)
- [safer_ffi: Write safer FFI code in Rust without polluting it with unsafe code](https://github.com/getditto/safer_ffi)
- [std::ffi](https://doc.rust-lang.org/std/ffi/)
- [FFI Support: A crate to help expose Rust functions over the FFI.](https://github.com/mozilla/ffi-support)

Problems:
- Lifetimes
- Error handling

## C++
- [CXX: Safe interop between Rust and C++](https://github.com/dtolnay/cxx)
  - [Functions with explicit lifetimes](https://cxx.rs/extern-rust.html#functions-with-explicit-lifetimes)
  - [Error handling](https://cxx.rs/binding/result.html)
- [Autocxx: Tool for safe ergonomic Rust/C++ interop driven from existing C++ headers](https://github.com/google/autocxx)

## .NET
- P/Invoke
  - [uniffi-bindgen-cs](https://github.com/NordSecurity/uniffi-bindgen-cs)
  - [Interoptopus](https://github.com/ralfbiedert/interoptopus)
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
