#import "@local/ib:0.1.0": *
#title[`std`: The Rust Standard Library]
#a-badge[https://doc.rust-lang.org/std/]

#a[A `no_std` Rust Environment - The Embedded Rust Book][https://docs.rust-embedded.org/book/intro/no-std.html]

= Crate features
Also in `core`:
- `optimize_for_size`: Choose algorithms that are optimized for binary size instead of runtime performance
- `debug_refcell`: Make `RefCell` store additional debugging information, which is printed out when a borrow error occurs

`std`-only:
- `backtrace`
- `backtrace-trace-only`: Disable symbolization in backtraces.
- `panic-unwind`
  - `panic_abort` is always depended.
- `compiler-builtins-c`
- `compiler-builtins-mem`
- `compiler-builtins-no-f16-f128`
- `llvm-libunwind`
- `system-llvm-libunwind`
- `std_detect_file_io`
- `std_detect_dlsym_getauxval`
- `windows_raw_dylib`: Enable using `raw-dylib` for Windows imports.

  This will eventually be the default.

Cargo default: `panic-unwind,backtrace,default`

= External crate dependencies (`rustc-dep-of-std`)
- `cfg-if`
- `hashbrown`
- `rustc-demangle`

Target:
- ```rs cfg(not(all(windows, target_env = "msvc", not(target_vendor = "uwp"))))```
  - `miniz_oxide`
  - `addr2line`
- ```rs cfg(not(all(windows, target_env = "msvc")))```
  - `libc`
- ```rs cfg(not(all(windows, target_env = "msvc", not(target_vendor = "uwp"))))```
  - `object`
- ```rs cfg(any(all(target_family = "wasm", target_os = "unknown"), target_os = "xous", target_os = "vexos", all(target_vendor = "fortanix", target_env = "sgx")))```
  - `dlmalloc`
- `x86_64-fortanix-unknown-sgx`
  - `fortanix-sgx-abi`
- ```rs cfg(target_os = "motor")```
  - `moto-rt`
- ```rs cfg(target_os = "hermit")```
  - `hermit-abi`
- ```rs cfg(target_os = "wasi")```
  - `wasi`
- ```rs cfg(all(target_os = "wasi", target_env = "p2"))```
  - `wasip2`
- ```rs cfg(all(target_os = "wasi", target_env = "p3"))```
  - `wasip2`
- ```rs cfg(target_os = "uefi")```
  - `r-efi`
  - `r-efi-alloc`
- ```rs cfg(target_os = "vexos")```
  - `vex-sdk`

= `build-std`
#a[rust-lang/wg-cargo-std-aware: Repo for working on "std aware cargo"][https://github.com/rust-lang/wg-cargo-std-aware]

Src:
- `rustup component add rust-src --toolchain nightly`
- `$(rustc --print sysroot)/lib/rustlib/src/rust/library`

Cargo:
- `build_std`
  - Default: `std`/`core`
  - `std`, including `core,alloc,proc_macro,panic_unwind,compiler_builtins`, and `test` if testing
  - `core`, including `compiler_builtins`
- `build_std_features`
  - Default: `panic-unwind,backtrace,default`

`.cargo/config.toml`:
```toml
[unstable]
build-std = []
build-std-features = []
```

#a[`cargo/src/cargo/core/compiler/standard_lib.rs`][https://github.com/rust-lang/cargo/blob/94c368ad2b9db0f0da5bdd8421cea13786ce4412/src/cargo/core/compiler/standard_lib.rs]
