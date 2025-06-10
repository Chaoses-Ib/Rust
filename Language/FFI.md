# Foreign Function Interface
[→Linkage](../Build/rustc/Linkage.md)

- [Diplomat: Experimental Rust tool for generating FFI definitions allowing many other languages to call Rust code](https://github.com/rust-diplomat/diplomat/)

  [Supported languages](https://github.com/rust-diplomat/diplomat/tree/main/tool/src): C, C++, JS, C#, Kotlin, Dart.
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

## *-sys packages
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/build-scripts.html#-sys-packages)
> There are a number of benefits earned from having this convention of native-library-related packages:
> - Common dependencies on `foo-sys` alleviates the rule about one package per value of `links`.
> - Other `-sys` packages can take advantage of the `DEP_NAME_KEY=value` environment variables to better integrate with other packages. See the ["Using another `sys` crate"](https://doc.rust-lang.org/cargo/reference/build-script-examples.html#using-another-sys-crate) example.
> - A common dependency allows centralizing logic on discovering `libfoo` itself (or building it from source).
> - These dependencies are easily [overridable](https://doc.rust-lang.org/cargo/reference/build-scripts.html#overriding-build-scripts).

[What's the benefit of releasing a -sys crate in Rust? : r/rust](https://www.reddit.com/r/rust/comments/14ztogb/whats_the_benefit_of_releasing_a_sys_crate_in_rust/)

## C
[FFI - The Rustonomicon](https://doc.rust-lang.org/nomicon/ffi.html)

Libraries:
- [std::ffi](https://doc.rust-lang.org/std/ffi/)
  - `c_char` (`u8`/`i8`)
  - `CStr`, `CString`
  - `OsStr`, `OsString`

  [ffi: how to free memory of pointer created in rust? - Issue #19564 - denoland/deno](https://github.com/denoland/deno/issues/19564)

- [FFI Support: A crate to help expose Rust functions over the FFI.](https://github.com/mozilla/ffi-support)
- [libc: Raw bindings to platform APIs for Rust](https://github.com/rust-lang/libc)

C to Rust:
- [bindgen: Automatically generates Rust FFI bindings to C (and some C++) libraries.](https://github.com/rust-lang/rust-bindgen)
  - `--use-core`
  - Enums
    - `--rustified-enum`
  - Dynamic
    - `#[link]`: `--allowlist-item .* --merge-extern-blocks`
      - PowerShell
        ```pwsh
        (Get-Content src/sys.rs) -replace 'unsafe extern', ('#[link(name = "example", kind = "raw-dylib")]' + "`n" + 'unsafe extern') | Set-Content src/sys.rs
        ```
      - [Support for raw-dylib for Windows - Issue #2833 - rust-lang/rust-bindgen](https://github.com/rust-lang/rust-bindgen/issues/2833)
      - [Dynamic Linking Support (windows-msvc) - Issue #2548 - rust-lang/rust-bindgen](https://github.com/rust-lang/rust-bindgen/issues/2548)
    - libloading: `--allowlist-item .* --dynamic-loading example --dynamic-link-require-all`
  - [CLI](https://rust-lang.github.io/rust-bindgen/command-line-usage.html)
- [C2Rust: Migrate C code to Rust](https://github.com/immunant/c2rust)

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
- `bool`

  [What is the correct type for returning a C99 `bool` to Rust via the FFI? - Stack Overflow](https://stackoverflow.com/questions/47705093/what-is-the-correct-type-for-returning-a-c99-bool-to-rust-via-the-ffi)

  [Is `bool` FFI-safe? - Issue #95184 - rust-lang/rust](https://github.com/rust-lang/rust/issues/95184)

  If the return type is `bool`, the high (24) bits of the return value are not guaranteed to be zeros. If the return value is treated as an integer, use `r & 0xFF != 0` to check for `true`.

## C++
- CXX
  - [cxx-async: Simple interoperability between C++ coroutines and asynchronous Rust](https://github.com/pcwalton/cxx-async)

- [Zngur: A C++/Rust interop tool](https://github.com/HKalbasi/zngur)

  [How it compares to other tools - Zngur](https://hkalbasi.github.io/zngur/how_it_compares.html)

  [r/rust](https://www.reddit.com/r/rust/comments/174y6dw/announcing_zngur_a_crust_interop_tool/)
  
  [Hacker News](https://news.ycombinator.com/item?id=41271273)

- [rust-cpp: Embed C++ directly inside your rust code!](https://github.com/mystor/rust-cpp)

- [BuFFI: A tool to generate ergonomic, buffer-based C++ APIs.](https://github.com/GiGainfosystems/BuFFI)

  [BuFFI: Generate ergonomic C++ APIs for your Rust code : r/rust](https://www.reddit.com/r/rust/comments/1gouxoc/buffi_generate_ergonomic_c_apis_for_your_rust_code/)

- [vtable-rs: Set of traits and macros to help dealing with C++ virtual method FFI](https://github.com/tremwil/vtable-rs)
  - COM?

C++ to Rust:
- Autocxx

Rust to C++:
- Zngur
- Diplomat
- cbindgen

### [CXX](https://github.com/dtolnay/cxx)
> Safe interop between Rust and C++.

```rust
#[cxx::bridge]
mod ffi {
    // Any shared structs, whose fields will be visible to both languages.
    struct BlobMetadata {
        size: usize,
        tags: Vec<String>,
    }

    extern "Rust" {
        // Zero or more opaque types which both languages can pass around
        // but only Rust can see the fields.
        type MultiBuf;

        // Functions implemented in Rust.
        fn next_chunk(buf: &mut MultiBuf) -> &[u8];
    }

    unsafe extern "C++" {
        // One or more headers with the matching C++ declarations for the
        // enclosing extern "C++" block. Our code generators don't read it
        // but it gets #include'd and used in static assertions to ensure
        // our picture of the FFI boundary is accurate.
        include!("demo/include/blobstore.h");

        // Zero or more opaque types which both languages can pass around
        // but only C++ can see the fields.
        type BlobstoreClient;

        // Functions implemented in C++.
        fn new_blobstore_client() -> UniquePtr<BlobstoreClient>;
        fn put(&self, parts: &mut MultiBuf) -> u64;
        fn tag(&self, blobid: u64, tag: &str);
        fn metadata(&self, blobid: u64) -> BlobMetadata;
    }
}
```
- Usable, but far from mature.

- `#include` relative to `.` or `..` is not supported in Cargo builds. Use a path starting with the crate name.
  
  This means the used header files must be in a subdirectory of the crate root.
    
  A workaround is to make stub headers in the crate that include the actual headers by relative paths.

- Since everything is generated to a single header file, it is very easy to cause circular dependencies if the C++ and Rust sides use types from each other.

- Only documents in the `ffi` module will be included in the generated header file.

- [Functions with explicit lifetimes](https://cxx.rs/extern-rust.html#functions-with-explicit-lifetimes)

- [Error handling](https://cxx.rs/binding/result.html)

- Tests

  [Writing tests with CXX code causes linker issues - Issue #1318 - dtolnay/cxx](https://github.com/dtolnay/cxx/issues/1318)

  [LNK2019 unresolved symbol for Vec<SharedStruct> using MSVC - Issue #1362 - dtolnay/cxx](https://github.com/dtolnay/cxx/issues/1362)

  [Adding C++ Code in Rust cxx bridge unit tests - Issue #898 - dtolnay/cxx](https://github.com/dtolnay/cxx/issues/898)

  [cxx::bridge behind a feature - Issue #1325 - dtolnay/cxx](https://github.com/dtolnay/cxx/issues/1325)

  [Rust and C++ Unit testing with cxx : r/rust](https://www.reddit.com/r/rust/comments/nt4qkm/rust_and_c_unit_testing_with_cxx/)

Types:
- [Shared types](https://cxx.rs/shared.html)

- Use `rust::` types if you want to be friendlier to Rust users, and `std::` types if you want to be friendlier to C++ users.

- [`rust::Str`](https://cxx.rs/binding/str.html)/[`rust::String`](https://cxx.rs/binding/string.html)
  - Constructors throws `std::invalid_argument` if not utf-8.
  - `rust::String` can also be constructed by `lossy()`.
  - `data()` has no null terminator.
  - Not documented in header files, but only in the book.

- [How to use opaque types in threads? - Issue #1175 - dtolnay/cxx](https://github.com/dtolnay/cxx/issues/1175)

  `unsafe impl Sync for ffi::MyClass {}`

- `std::optional`

  [Support rust `Option` and C++ `std::optional` - Issue #87](https://github.com/dtolnay/cxx/issues/87)

- `std::expected`

  [Non-exception based Result return value in C++ - Issue #1052 - dtolnay/cxx](https://github.com/dtolnay/cxx/issues/1052)

- Bit flags
  
  [Derive bitwise BitAnd and BitOr for shared enums - Issue #736 - dtolnay/cxx](https://github.com/dtolnay/cxx/issues/736)

- `std::string_view`

  [Support for std::string\_view (C++17) - Issue #734 - dtolnay/cxx](https://github.com/dtolnay/cxx/issues/734)

[CMake](https://cxx.rs/build/cmake.html):
- [paandahl/cpp-with-rust: Minimal application mixing C++ and Rust](https://github.com/paandahl/cpp-with-rust)

Windows:
```cpp
// -I"rs/include"
// -I"rs/target/cxxbridge/rs/src"
// /MD

#ifdef _DEBUG
#pragma comment(lib, "../target/debug/rs.lib")
#else
#pragma comment(lib, "../target/release/rs.lib")
#endif
#pragma comment(lib, "Synchronization.lib")
#pragma comment(lib, "Userenv.lib")
#pragma comment(lib, "Ntdll.lib")

#include "../target/cxxbridge/rs/src/lib.rs.h"

// #include "../target/cxxbridge/rs/src/lib.rs.cc"
```
See also [CRT](../Build/rustc/Linkage.md#crt).

### [Autocxx](https://github.com/google/autocxx)
> Tool for safe ergonomic Rust/C++ interop driven from existing C++ headers

[Make templated C++ types useful - Issue #349](https://github.com/google/autocxx/issues/349)

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