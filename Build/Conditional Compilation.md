# Conditional Compilation
[The Rust Reference](https://doc.rust-lang.org/reference/conditional-compilation.html)

- `#[cfg]` attribute
  - [cfg-if: A if/elif-like macro for Rust `#[cfg]` statements](https://github.com/rust-lang/cfg-if)
- `cfg!` macro

## [rustc](rustc/README.md)
Conditional compilation:
- Cargo feature
- Environment variable
  - Build script
- [`#![feature(cfg_version)]`](https://doc.rust-lang.org/beta/unstable-book/language-features/cfg-version.html)
- [dtolnay/rustversion: Conditional compilation according to rustc compiler version](https://github.com/dtolnay/rustversion) (formerly [`select-rustc`](https://crates.io/crates/select-rustc))
  - [Disable unstable feature - Issue #8](https://github.com/dtolnay/rustversion/issues/8)
    - Still need a build script
    - [Tracking issue for custom inner attributes - Issue #54726 - rust-lang/rust](https://github.com/rust-lang/rust/issues/54726)
    - [Ability to enable unstable feature in tests - Issue #18](https://github.com/dtolnay/rustversion/issues/18)
  - [rustversion::before(date) matches stable version - Issue #26](https://github.com/dtolnay/rustversion/issues/26)
- [djc/rustc-version-rs](https://github.com/djc/rustc-version-rs)

[Conditional experimental rustc feature? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/conditional-experimental-rustc-feature/70005)

[rust - Conditional unstable rustc feature? - Stack Overflow](https://stackoverflow.com/questions/70632072/conditional-unstable-rustc-feature/70640030#70640030)

[Add unstable feature only if compiled on nightly - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/add-unstable-feature-only-if-compiled-on-nightly/27886)

## Cargo features
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/features.html)

```toml
[features]
default = ["ico", "webp"]
bmp = []
png = []
ico = ["bmp", "png"]
webp = []
```

```rust
#[cfg(feature = "webp")]
pub mod webp;
```

```sh
cargo --features foo,bar
```