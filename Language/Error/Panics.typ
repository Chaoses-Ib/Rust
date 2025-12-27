#import "@local/ib:0.1.0": *
#title[Panics]
#a[`std::panic` - Rust][https://doc.rust-lang.org/std/macro.panic.html]

= No panic
- #a[dtolnay/no-panic: Attribute macro to require that the compiler prove a function can't ever panic][https://github.com/dtolnay/no-panic]

= Panic strategies
#a[Codegen Options - The rustc book][https://doc.rust-lang.org/rustc/codegen-options/index.html#panic]
- `immediate-abort`: terminate the process upon panic, and do not call any panic hooks.
- `abort`: terminate the process upon panic.
- `unwind`: unwind the stack upon panic.

Panic handling coloring:
- If any crate in the crate graph uses `immediate-abort`, every crate in the graph must use `immediate-abort`.
  - i.e. require `build-std`.
  
    ```sh error: the crate `core` was compiled with a panic strategy which is incompatible with `immediate-abort` ```
- If any crate in the crate graph uses `abort`, the final binary (`bin`, `dylib`, `cdylib`, `staticlib`) must also use `abort`.
- If `std` is used as a `dylib` with `unwind`, the final binary must also use `unwind`.

#a[Disable panic in small bare metal systems - embedded - The Rust Programming Language Forum][https://users.rust-lang.org/t/disable-panic-in-small-bare-metal-systems/76296]

== `immediate-abort`
- Calls ```rs __rust_abort()``` in
  ```rs std::panicking::begin_panic()```
  and ```rs rust_eh_personality()```.
  - x86: `UD2` (`0F 0B`)

Config:
- `Cargo.toml`:
  ```toml
  cargo-features = ["panic-immediate-abort"]

  [package]
  # ...

  [profile.release]
  panic = "immediate-abort"
  ```
- `.cargo/config.toml`:
  ```toml
  [unstable]
  build-std = []
  build-std-features = []
  panic-immediate-abort = true

  [profile.release]
  panic = "immediate-abort"
  ```
