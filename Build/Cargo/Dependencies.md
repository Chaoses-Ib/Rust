# Dependencies
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html)

- When `add`, if dependencies under `[dependencies]` are in alphabetical order, the added dependency will follow suit.

[cargo-udeps: Find unused dependencies in Cargo.toml](https://github.com/est31/cargo-udeps)

## Upgrading
[cargo-edit: A utility for managing cargo dependencies from the command line.](https://github.com/killercup/cargo-edit)

[\[SOLVED\] Update Cargo.toml after "cargo update" - The Rust Programming Language Forum](https://users.rust-lang.org/t/solved-update-cargo-toml-after-cargo-update/19442/2)
- cargo-edit: `cargo upgrade`
  - `cargo upgrade --incompatible`
- [cargo-upgrades](https://gitlab.com/kornelski/cargo-upgrades)

## Renaming dependencies
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

## [Git dependencies](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html#specifying-dependencies-from-git-repositories)
- > Cargo assumes that we intend to use the latest commit on the default branch to build our package if we only specify the repo URL.

  > You can combine the `git` key with the `rev`, `tag`, or `branch` keys to be more specific about which commit to use. Anything that is not a branch or a tag falls under `rev` key. This can be a commit hash like `rev = "4c59b707"`, or a named reference exposed by the remote repository such as `rev = "refs/pull/493/head"`.

[Authentication](https://doc.rust-lang.org/cargo/appendix/git-authentication.html):
- `failed to authenticate when downloading repository`

  > attempted to find username/password via git's `credential.helper` support, but failed
  > 
  > if the git CLI succeeds then [`net.git-fetch-with-cli`](https://doc.rust-lang.org/cargo/reference/config.html#netgit-fetch-with-cli) may help

- > Windows users will need to make sure that the `sh` shell is available in your `PATH`. This typically is available with the Git for Windows installation.

## Binary dependencies
[3028-cargo-binary-dependencies - The Rust RFC Book](https://rust-lang.github.io/rfcs/3028-cargo-binary-dependencies.html)
- [Tracking Issue for RFC 3028: Allow "artifact dependencies" on bin, cdylib, and staticlib crates - Issue #9096 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/9096)

See also [build scripts](Scripts.md).
