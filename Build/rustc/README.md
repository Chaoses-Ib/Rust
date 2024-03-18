# rustc
[The rustc book](https://doc.rust-lang.org/rustc/what-is-rustc.html)

## Target platforms
### Cross-compilation
- `rustup target list`
- `rustup show`, `rustup target list --installed`
- `rustup target add i686-pc-windows-msvc`
- `cargo build --target=i686-pc-windows-msvc`

[Cross-compilation - The rustup book](https://rust-lang.github.io/rustup/cross-compilation.html)

- [cross: "Zero setup" cross compilation and "cross testing" of Rust crates](https://github.com/cross-rs/cross)

  [PSA: For cross-compiling please use the "Cross" tool. : rust](https://www.reddit.com/r/rust/comments/18z5g3g/psa_for_crosscompiling_please_use_the_cross_tool/)

### Windows
- v1.78 (2024-02): [Updated baseline standards for Windows targets | Rust Blog](https://blog.rust-lang.org/2024/02/26/Windows-7.html)

  `x86_64-win7-windows-msvc` and `i686-win7-windows-msvc`

  [Windows support schedule 2024 - Issue #651 - rust-lang/compiler-team](https://github.com/rust-lang/compiler-team/issues/651)

  [Windows: Use ProcessPrng for random keys by ChrisDenton - Pull Request #121337 - rust-lang/rust](https://github.com/rust-lang/rust/pull/121337)

Resources:
- [winres: Create and set windows icons and metadata for executables with a rust build script](https://github.com/mxre/winres)
  - Metainformation (like program version and description) is taken from `Cargo.toml`'s `[package]` section.

    `homepage` is not used.
- [rust-embed-resource: A Cargo build script library to handle compilation and inclusion of Windows resources, in the most resilient fashion imaginable](https://github.com/nabijaczleweli/rust-embed-resource)