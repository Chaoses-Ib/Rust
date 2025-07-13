# Profiles
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

## Performance
The following `Cargo.toml` settings are recommended if best performance is desired:
```toml
[profile.release]
lto = "fat"
codegen-units = 1
# panic = "abort"
```

Maybe also in `.cargo/config`:
```toml
[build]
rustflags = ["-C", "target-cpu=native"]
```

[Build Configuration - The Rust Performance Book](https://nnethercote.github.io/perf-book/build-configuration.html)

[Cheap tricks for high-performance Rust - Pascal's Scribbles](https://deterministic.space/high-performance-rust.html)

[Compiling for maximum performance : r/rust](https://www.reddit.com/r/rust/comments/lyck1u/compiling_for_maximum_performance/)

## Dependencies
> Cargo only looks at the profile settings in the `Cargo.toml` manifest at the root of the workspace. Profile settings defined in dependencies will be ignored.

[Workspace "profile ignored" warning discounts the possibility of publishing binary crates which use profile settings - Issue #8264 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/8264)
> profiles for the non root package will be ignored, specify profiles at the workspace root:
> - package:   /home/daboross/workspace/subcrate/Cargo.toml
> - workspace: /home/daboross/workspace/Cargo.toml

[Cargo does not install binaries with the profiles as defined in the installed package - Issue #11599 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/11599)
