# [Cargo](https://doc.rust-lang.org/cargo)
[GitHub](https://github.com/rust-lang/cargo), [The Rust Programming Language](https://doc.rust-lang.org/book/ch14-00-more-about-cargo.html)

[The Cargo Book](https://doc.rust-lang.org/cargo/index.html)

## Dependencies
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html)

## Workspaces
[The Rust Programming Language](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html)

A **workspace** is a set of packages that share the same `Cargo.lock` and output directory.

## [→Features](Conditional%20Compilation.md#cargo-features)

## Profiles
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/profiles.html), [The Rust Programming Language](https://doc.rust-lang.org/book/ch14-01-release-profiles.html)

The default settings for the `dev` profile are:
```toml
[profile.dev]
opt-level = 0
debug = true
split-debuginfo = '...'  # Platform-specific.
debug-assertions = true
overflow-checks = true
lto = false
panic = 'unwind'
incremental = true
codegen-units = 256
rpath = false
```

The `test` profile inherits the settings from the `dev` profile.

The default settings for the `release` profile are:
```toml
[profile.release]
opt-level = 3
debug = false
split-debuginfo = '...'  # Platform-specific.
debug-assertions = false
overflow-checks = false
lto = false
panic = 'unwind'
incremental = false
codegen-units = 16
rpath = false
```

The `bench` profile inherits the settings from the `release` profile.

## Registries
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/registries.html)

- [crates.io](https://crates.io/)