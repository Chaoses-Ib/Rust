# [Cargo](https://doc.rust-lang.org/cargo)
[GitHub](https://github.com/rust-lang/cargo), [The Rust Programming Language](https://doc.rust-lang.org/book/ch14-00-more-about-cargo.html)

[The Cargo Book](https://doc.rust-lang.org/cargo/index.html)

## Dependencies
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html)

Renaming dependencies:
```toml
[package]
name = "mypackage"
version = "0.0.1"

[dependencies]
foo = "0.1"
bar = { git = "https://github.com/example/project.git", package = "foo" }
baz = { version = "0.1", registry = "custom", package = "foo" }
```

```rust
extern crate foo; // crates.io
extern crate bar; // git repository
extern crate baz; // registry `custom`
```

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

## Build scripts
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/build-scripts.html)

[Need a reliable way to get the target dir from the build script - Issue #9661 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/9661)

[Copy files to target directory after build, before run - Issue #1759 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/1759)
- [copy\_to\_output: A small rust library to copy files/folders from the project directory to the output directory](https://github.com/samwoodhams/copy_to_output)

  [`out_path` will be broken if `get_cargo_target_dir()` succeeds - Issue #9](https://github.com/samwoodhams/copy_to_output/issues/9)

- ```rust
  use std::fs;

  /// https://github.com/rust-lang/cargo/issues/9661#issuecomment-1722358176
  fn get_cargo_target_dir() -> Result<std::path::PathBuf, Box<dyn std::error::Error>> {
      let out_dir = std::path::PathBuf::from(std::env::var("OUT_DIR")?);
      let profile = std::env::var("PROFILE")?;
      let mut target_dir = None;
      let mut sub_path = out_dir.as_path();
      while let Some(parent) = sub_path.parent() {
          if parent.ends_with(&profile) {
              target_dir = Some(parent);
              break;
          }
          sub_path = parent;
      }
      let target_dir = target_dir.ok_or("not found")?;
      Ok(target_dir.to_path_buf())
  }

  fn main() {
      let target = get_cargo_target_dir().unwrap();
      #[cfg(target_os = "windows")]
      fs::copy("../libs/simple/libsimple.dll", target.join("libsimple.dll")).unwrap();
      #[cfg(target_os = "macos")]
      fs::copy("../libs/simple/libsimple.dylib", target.join("libsimple.dylib"),).unwrap();
  }
  ```

## Registries
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/registries.html)

- [crates.io](https://crates.io/)

  [Publishing on crates.io - The Cargo Book](https://doc.rust-lang.org/cargo/reference/publishing.html)