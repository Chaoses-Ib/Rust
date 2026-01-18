#import "@local/ib:0.1.0": *
#show: ib
#md(```
# Conditional Compilation
[The Rust Reference](https://doc.rust-lang.org/reference/conditional-compilation.html)

- `#[cfg]` attribute
  - [cfg-if: A if/elif-like macro for Rust `#[cfg]` statements](https://github.com/rust-lang/cfg-if)
  - `cfg_select!` (`cfg_match!`) macro

    [Add the `cfg_match!` macro by c410-f3r - Pull Request #115416 - rust-lang/rust](https://github.com/rust-lang/rust/pull/115416)
    - [Tracking issue for `cfg_select` (formerly `cfg_match`) - Issue #115585 - rust-lang/rust](https://github.com/rust-lang/rust/issues/115585)

    [A match-like version of the `cfg_if` crate has been added to the standard library : r/rust](https://www.reddit.com/r/rust/comments/16qu8ub/a_matchlike_version_of_the_cfg_if_crate_has_been/)
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
```)
= Set configuration options
- For `rustc`, arbitrary-set configuration options are set using the
  #a[`--cfg`][https://doc.rust-lang.org/rustc/command-line-arguments.html#--cfg-configure-the-compilation-environment]
  flag.
- Configuration values for a specified target can be displayed with
  ```sh rustc --print cfg --target $TARGET```
  .

Cargo:
- [ ] #a[Tracking Issue: Exposing `RUSTFLAGS` in cargo][https://github.com/rust-lang/cargo/issues/12739]

  #a[Pre-RFC: Mutually-excusive, global features - tools and infrastructure / cargo - Rust Internals][https://internals.rust-lang.org/t/pre-rfc-mutually-excusive-global-features/19618]
- Global
  - Envrionment variables: #a[`RUSTFLAGS`][https://doc.rust-lang.org/nightly/cargo/reference/config.html#buildrustflags]
- Per profile

  #a[Allow specifying rustflags per profile - Issue \#7878][https://github.com/rust-lang/cargo/issues/7878]
- [ ] Per package
- Root package
  - `config.toml`: `rustflags = ["--cfg", "k=v"]`
  - ```sh rustc -- --cfg k=v```
- Dumping: `cargo rustc --print cfg`

  #a[Obtain the Cargo compiler configuration for use in subcommands without building the package - Issue \#8923 - rust-lang/cargo][https://github.com/rust-lang/cargo/issues/8923]

#a[aes: feature flags are not additive - Issue \#245 - RustCrypto/block-ciphers][https://github.com/RustCrypto/block-ciphers/issues/245]
- #a[How to compose with configuration flags ? - Issue \#316 - RustCrypto/block-ciphers][https://github.com/RustCrypto/block-ciphers/issues/316]
- #a[Improving/simplifying `cfg` attributes for target features - Issue \#18 - RustCrypto/meta][https://github.com/RustCrypto/meta/issues/18]

#q[
A problem of the `cfg` attributes approach is that it can only be set via the `RUSTFLAGS` environment variable.
While RustCrypto's docs says "or by modifying `.cargo/config`", it only affects the root package, not dependencies (either via `rustflags` or `[env]`).
Per-package `cfg`/`RUSTFLAGS` is not yet supported (https://github.com/rust-lang/cargo/issues/12739), and even per-profile is not stable (https://github.com/rust-lang/cargo/issues/10271).
Having to set the environment variable makes the build on different platforms (shells) more complex.
(And compared to setting Cargo features, setting `RUSTFLAGS` will cause all packages to be recompiled.)

#q[First off, these all are selecting one of many options and are mutually exclusive at a crate level. `cfg` attributes make that possible in ways crate features don.t
This would both be consistent across crates and simplify the logic in regard to conflicting attributes.]

I'm a bit confused what this means. Cargo features are just `cfg`s with the key as `feature`.
The only difference I can see is `cfg` can be set without adding the descendant dependency to the root package's `Cargo.toml`.
But this is at the cost of making build harder (e.g. https://github.com/rust-lang/cargo/issues/5376), sometimes even not possible (https://github.com/tokio-rs/tokio/issues/7254), as `cfg` is badly supported by Cargo.
And mutually exclusive Cargo features are actually more widely used (like `rustls`, `reqwest`, `tracing`, `flate2`, `inkwell`) and work fine. Maybe the use of `cfg` attributes should be reconsidered?
]

#md(````
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

- How to enable some features only in development?
  
  - `dev-dependencies`
    ```toml
    [dev-dependencies]
    ib-matcher = { features = ["pinyin", "romaji"], path = "." }
    ```
    All tests will enable these features, even with `--no-default-features`.

  - [`required-features`](https://doc.rust-lang.org/cargo/reference/cargo-targets.html#the-required-features-field)
  
    ```toml
    [[test]]
    name = "foo"
    required-features = ["cfg-if"]
    ```
````)
