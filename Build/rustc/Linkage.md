# Linkage
[The Rust Reference](https://doc.rust-lang.org/reference/linkage.html)

[Cargo Targets - The Cargo Book](https://doc.rust-lang.org/cargo/reference/cargo-targets.html)

## [`crate-type`](https://doc.rust-lang.org/cargo/reference/cargo-targets.html#the-crate-type-field)
> This can only be specified for libraries and examples. Binaries, tests, and benchmarks are always the "bin" crate type.

- Examples

  ```toml
  [[example]]
  name = "foo"
  crate-type = ["staticlib"]
  ```
  Cargo will only find `foo` example at `examples\foo.rs` or `examples\foo\main.rs`. Please specify `example.path` if you want to use a non-default path.

  [How to correctly use crate-type in `[[example]]`? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/how-to-correctly-use-crate-type-in-example/68541)

  [What's the right way to declare & run "crate-type" examples? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/whats-the-right-way-to-declare-run-crate-type-examples/108385)
  - Workspace member

- CLI
  
  [3180-cargo-cli-crate-type - The Rust RFC Book](https://rust-lang.github.io/rfcs/3180-cargo-cli-crate-type.html)
  - `cargo rustc --crate-type cdylib`

  [bltavares/cargo-crate-type: Utility to modify Cargo.toml and define the crate type](https://github.com/bltavares/cargo-crate-type)

  [Is it possible to override the crate-type specified in Cargo.toml from the command line when calling cargo build? - Stack Overflow](https://stackoverflow.com/questions/65012484/is-it-possible-to-override-the-crate-type-specified-in-cargo-toml-from-the-comma)

- [Ability to set crate-type depending on target - Issue #4881 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/4881)
  - [Support `[target.'cfg(...)'.lib]` sections - Issue #12260 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/12260)

## External blocks
[The Rust Reference](https://doc.rust-lang.org/reference/items/external-blocks.html)

ABI:
- `Rust`
- `C` (default)
- `system` (`C` / `stdcall`)
- x86
  - `cdecl`, `stdcall`
  - `win64`, `sysv64`
- ARM: `aapcs`
- `fastcall`, `thiscall`
- UEFI: `efiapi`

### `link` attribute
[The Rust Reference](https://doc.rust-lang.org/reference/items/external-blocks.html#the-link-attribute)

- `name`
- `kind`
  - `static`
  - `dylib`
    - Windows: [`raw-dylib`](https://doc.rust-lang.org/reference/items/external-blocks.html#dylib-versus-raw-dylib)

      `#[cfg_attr(windows, link(name = "libwsutil.dll", kind = "raw-dylib"))]`
  - macOS: `framework`
- `modifiers`
  - `static`
    - `bundle`
    - `whole-archive`
  - [`verbatim`](https://doc.rust-lang.org/rustc/command-line-arguments.html#linking-modifiers-verbatim)
  
    > rustc itself won’t add any target-specified library prefixes or suffixes (like lib or .a) to the library name, and will try its best to ask for the same thing from the linker.

  [2951-native-link-modifiers - The Rust RFC Book](https://rust-lang.github.io/rfcs/2951-native-link-modifiers.html)

[`link_name` attribute](https://doc.rust-lang.org/reference/items/external-blocks.html#the-link_name-attribute)

### [`rustc -l`](https://doc.rust-lang.org/rustc/command-line-arguments.html#option-l-link-lib)
`-l [KIND[:MODIFIERS]=]NAME[:RENAME]`
- `NAME` shouldn't include the extension, like in `link` attribute

[`cargo::rustc-link-lib=LIB`](https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-link-lib)

Unused lib that missing dependencies will not cause link error.

[Where should I place a static library so I can link it with a Rust program? - Stack Overflow](https://stackoverflow.com/questions/43826572/where-should-i-place-a-static-library-so-i-can-link-it-with-a-rust-program)

[Link a C static library to rust cargo project : r/rust](https://www.reddit.com/r/rust/comments/14hyynm/link_a_c_static_library_to_rust_cargo_project/)

## Symbol mangling
[The rustc book](https://doc.rust-lang.org/rustc/symbol-mangling/index.html)

- [`no_mangle` attribute](https://doc.rust-lang.org/reference/abi.html#the-no_mangle-attribute)

  `#[unsafe(no_mangle)]` since Rust 2024

- `#[unsafe(export_name = "exported_symbol_name")]`

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
  - `Symbol` cannot be externally constructed
  - [Windows](https://github.com/nagisa/rust_libloading/blob/master/src/os/windows/mod.rs)
  - Used by bindgen
  - [sharedlib: A cross-platform shared library loader.](https://github.com/Tyleo/sharedlib)

- [szymonwieloch/dlopen: Rust library for opening and working with dynamic link libraries.](https://github.com/szymonwieloch/rust-dlopen)
  - [ahmed-masud/dlopen](https://github.com/ahmed-masud/rust-dlopen)
    - **[dlopen2](https://github.com/OpenByteDev/dlopen2)**
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

## [→CRT](https://github.com/Chaoses-Ib/Cpp/blob/main/Build/CRT.md)
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
- Or build others with `/MT`

  [feat: use static release CRT - Chaoses-Ib/IbEverythingExt@8a0cdaf](https://github.com/Chaoses-Ib/IbEverythingExt/commit/8a0cdafb3a2faac354bb47f79da99b01d4c066d3)
- [The MSVC CRT library is not overrideable by other build systems - Issue #107570 - rust-lang/rust](https://github.com/rust-lang/rust/issues/107570)
- [Windows MSVC CRT linking - Issue #211 - rust-lang/libs-team](https://github.com/rust-lang/libs-team/issues/211)
- [CXX how to get a MSVCRTD-based debug-build LIB on Windows : r/rust](https://www.reddit.com/r/rust/comments/14wjxih/cxx_how_to_get_a_msvcrtdbased_debugbuild_lib_on/)

[Document how to get a MSVCRTD-based debug-build LIB on Windows - Issue #880 - dtolnay/cxx](https://github.com/dtolnay/cxx/issues/880)
```rust
if env::var("TARGET").is_ok_and(|s| s.contains("windows-msvc")) {
    // MSVC compiler suite
    // if Ok("debug".to_owned()) == env::var("PROFILE") {
    if env::var("CFLAGS").is_ok_and(|s| s.contains("/MDd")) {
        // debug runtime flag is set

        // Don't link the default CRT
        println!("cargo::rustc-link-arg=/nodefaultlib:msvcrt");
        // Link the debug CRT instead
        println!("cargo::rustc-link-arg=/defaultlib:msvcrtd");
    }
}
```
