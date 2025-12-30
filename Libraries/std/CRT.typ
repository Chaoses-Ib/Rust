#import "@local/ib:0.1.0": *
#show: ib
#title[C/Compiler Runtime Library (CRT)]
#a-badge(body: [$arrow$C++])[https://github.com/Chaoses-Ib/Cpp/blob/main/Build/CRT.md]

#a[Windows: Does Rust need the x86/x64 C runtime to be initalized? - Rust Internals][https://internals.rust-lang.org/t/windows-does-rust-need-the-x86-x64-c-runtime-to-be-initalized/11581]

= No CRT
- `staticlib`
  - `build-std` + `panic=immediate-abort`
  
    Using `build-std` is not enough, `panic=immediate-abort` must also be set to avoid panic handling.
    - `std::panicking::panic_with_hook` calls `std::io::Write::write_all`, requring `__chkstk`, `__imp_NtWriteFile`.
    ```toml
    [unstable]
    build-std = []
    build-std-features = []
    ```
  - ```rs #![no_std]```
  - [ ] #a[Add a "slim" staticlib variant that does not include a copy of std - Issue \#111594 - rust-lang/rust][https://github.com/rust-lang/rust/issues/111594]

  #a[Rust 1.79+ stdlib is unusable with MSVC when creating static libraries - Issue \#129020 - rust-lang/rust][https://github.com/rust-lang/rust/issues/129020]

  #a[Don't leak non-exported symbols from staticlibs - Issue \#104707 - rust-lang/rust][https://github.com/rust-lang/rust/issues/104707]

#a[Static linking for rust without glibc - scratch image - help - The Rust Programming Language Forum][https://users.rust-lang.org/t/static-linking-for-rust-without-glibc-scratch-image/112279]

= Rust implementations
- #a([$arrow$compiler-builtins], <compiler-builtins>)

- ```rs #[unsafe(no_mangle)]``` + third-party implementation
  - ```rs #[inline]``` can't work stably, whether ```rs extern "C"``` or not.
    
    #a[Emit `unused_attributes` for `#[inline]` on exported functions by Noratrieb - Pull Request \#138842 - rust-lang/rust][https://github.com/rust-lang/rust/pull/138842]
    - #q[what should we do if we want add inlinehint in llvm ir and effects the optimization during LTO]

- #a[`#![no_builtins]`][https://doc.rust-lang.org/reference/attributes/codegen.html#the-no_builtins-attribute]

  #q[Disable optimization of certain code patterns related to calls to library functions that are assumed to exist.]

  #q[Whether library functions call lowering/optimization is disabled in LLVM
  for this target unconditionally.]
  #footnote[#a[`rust/compiler/rustc_target/src/spec/mod.rs` - rust-lang/rust][https://github.com/rust-lang/rust/blob/15f7c553a377bd027a0e2061695766c35c8600d1/compiler/rustc_target/src/spec/mod.rs#L2458]]

  - Doesn't guarantee to inline `memcpy()`, etc.
  - #a[`#![no_builtins]` should prevent a crate from participating in LTO - Issue \#35540 - rust-lang/rust][https://github.com/rust-lang/rust/issues/35540]

    #q[This attribute is needed to prevent LLVM from optimizing a `memcpy` implementation into a recursive call. However this attribute is not preserved in LTO builds: the attribute only works if it is set at the top-level crate.

    Since crates containing implementations of built-in functions aren't meant to be called directly, they don't benefit from LTO and should be linked as a separate object.

    One workaround (using rlibc as an example) is to first compile a `rlibc_inner` crate as a staticlib with `#![no_builtins]`, and then compile the `rlibc` crate as a rlib which links to `rlibc_inner.a`.]

  #a[Expand `no_builtins` documentation - Issue \#542 - rust-lang/reference][https://github.com/rust-lang/reference/issues/542]

- [ ] Implementation of a pure Rust target for Windows (no libc, no msvc, no mingw).
  
  #a[Tracking issue for RFC 2627: `#[link(kind="raw-dylib")]` - Issue \#58713 - rust-lang/rust][https://github.com/rust-lang/rust/issues/58713]

  #a[Pre-RFC: Remove Rust's dependency on Visual Studio in 4 (...complex?) steps - compiler - Rust Internals][https://internals.rust-lang.org/t/pre-rfc-remove-rusts-dependency-on-visual-studio-in-4-complex-steps/16708]

== #a[rust-lang/compiler-builtins: Rust implementations of compiler-rt and libm][https://github.com/rust-lang/compiler-builtins]
<compiler-builtins>
- Math
  - `libm`
  - Weak linkage (unless `windows-gnu` or `cygwin`)

  `core`:
  - #a[Tracking Issue for `core_float_math` - Issue \#137578 - rust-lang/rust][https://github.com/rust-lang/rust/issues/137578]

- `mem` feature: `memcpy`, `memmove`, `memset`, `memcmp`, `bcmp`, `strlen`
  - Weak linkage (unless `windows-gnu` or `cygwin`)
    ```rs
    #[cfg(not(feature = "mangled-names"))]
    #[cfg_attr(not(any(all(windows, target_env = "gnu"), target_os = "cygwin")), linkage = "weak")]
    ```
  - #a[memcpy and co. are really unoptimized - Issue \#339][https://github.com/rust-lang/compiler-builtins/issues/339]

- Stack checking
  - `__rust_probestack()`
    #footnote[#a[Bringing Stack Clash Protection to Clang / X86 --- the Open Source Way - The LLVM Project Blog][https://blog.llvm.org/posts/2021-01-05-stack-clash-protection/]]
  - `___chkstk_ms()` on `windows-gnu`, `cygwin` and `uefi`.

  函数栈大于 4KiB 时，在入口遍历下栈来保证触发 guard。

  #a[Allow for disabling the stack check in a target file - Issue \#34269 - rust-lang/rust][https://github.com/rust-lang/rust/issues/34269]
  - #a[How can you disable stack checking? - Issue \#65751][https://github.com/rust-lang/rust/issues/65751]
  - #a[`__rust_probestack` in binary despite no callers, LTO, and disabling stack-probes. - Issue \#88274][https://github.com/rust-lang/rust/issues/88274]

- #a[multiple rlib candidates for `compiler_builtins` found - Issue \#334][https://github.com/rust-lang/compiler-builtins/issues/334]
  ```rs
  #![feature(rustc_private)]
  extern crate compiler_builtins;
  pub use compiler_builtins::*;
  ```
  - #a[`compiler_builtins` seems to be missing symbols - Issue \#53 - rust-lang/wg-cargo-std-aware][https://github.com/rust-lang/wg-cargo-std-aware/issues/53]

- [-] #a[Potential to add `#[inline]` attributes where possible - Issue \#844][https://github.com/rust-lang/compiler-builtins/issues/844]

== Third-party implementations
- #a[rust-embedded-community/tinyrlibc: Tiny C library written in Rust][https://github.com/rust-embedded-community/tinyrlibc]
  - `str*`
  - `rand`
  - `*snprintf`
  - `*alloc`
  - `signal`
  - No `mem*`

    Well, `tinyrlibc` has no feature of `rlibc` but lots of other features...

  ```rs
  pub use tinyrlibc::*;
  ```

- #a[alexcrichton/rlibc][https://github.com/alexcrichton/rlibc]
  (discontinued)
  - `mem*` only

- `strlen()`
  ```rs
  use core::ffi::c_char;

  #[unsafe(no_mangle)]
  const unsafe fn strlen(s: *const c_char) -> usize {
      let mut len = 0;

      // SAFETY: Outer caller has provided a pointer to a valid C string.
      while unsafe { *s.add(len) } != 0 {
          len += 1;
      }

      len
  }
  ```

=== Linux
- #a[mustang: Rust programs written entirely in Rust][https://github.com/sunfishcode/mustang]
  - #a[Origin: Program startup and thread support written in Rust][https://github.com/sunfishcode/origin]
  - #a[c-ward: An implementation of libc written in Rust][https://github.com/sunfishcode/c-ward]
  - #a[Eyra: Rust programs written entirely in Rust][https://github.com/sunfishcode/eyra]
- #a[Redox C Library (relibc)][https://gitlab.redox-os.org/redox-os/relibc/]
  #a-badge[https://github.com/redox-os/relibc]

=== Windows
- #a[dot-asm/min-crt-poc: Trimmed-down MinGW DLL entry point in Rust][https://github.com/dot-asm/min-crt-poc]
- #a[safedv/Rustic64: 64-bit, position-independent implant template for Windows in Rust.][https://github.com/safedv/Rustic64]

= C implementations
- libc
- MSVC/Windows CRT
- #a[Newlib][https://sourceware.org/newlib/]

== Static CRT
#a[How to link CRT statically when building with MSVC? : r/rust][https://www.reddit.com/r/rust/comments/ekts0d/how_to_link_crt_statically_when_building_with_msvc/]

`.cargo/config.toml`:
```toml
[target.x86_64-pc-windows-msvc]
rustflags = ["-C", "target-feature=+crt-static"]
```

```toml
[target.'cfg(all(target_os = "windows", target_env = "msvc"))']
rustflags = ["-C", "target-feature=+crt-static"]
```

== Debug CRT
#a[rustc always links against non-debug Windows runtime - Issue #39016 - rust-lang/rust][https://github.com/rust-lang/rust/issues/39016]
- ```pwsh $env:CFLAGS=$env:CXXFLAGS='/MTd'```
- Or build others with `/MT`

  #a[feat: use static release CRT - Chaoses-Ib/IbEverythingExt\@8a0cdaf][https://github.com/Chaoses-Ib/IbEverythingExt/commit/8a0cdafb3a2faac354bb47f79da99b01d4c066d3]
- #a[The MSVC CRT library is not overrideable by other build systems - Issue #107570 - rust-lang/rust][https://github.com/rust-lang/rust/issues/107570]
- #a[Windows MSVC CRT linking - Issue #211 - rust-lang/libs-team][https://github.com/rust-lang/libs-team/issues/211]
- #a[CXX how to get a MSVCRTD-based debug-build LIB on Windows : r/rust][https://www.reddit.com/r/rust/comments/14wjxih/cxx_how_to_get_a_msvcrtdbased_debugbuild_lib_on/]

#a[Document how to get a MSVCRTD-based debug-build LIB on Windows - Issue #880 - dtolnay/cxx][https://github.com/dtolnay/cxx/issues/880]
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
