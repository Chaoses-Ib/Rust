# Dependencies
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html)

### Upgrading
[cargo-edit: A utility for managing cargo dependencies from the command line.](https://github.com/killercup/cargo-edit)

[\[SOLVED\] Update Cargo.toml after "cargo update" - The Rust Programming Language Forum](https://users.rust-lang.org/t/solved-update-cargo-toml-after-cargo-update/19442/2)
- cargo-edit: `cargo upgrade`
- [cargo-upgrades](https://gitlab.com/kornelski/cargo-upgrades)

### Renaming dependencies
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