# Dependencies
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html)

- When `add`, if dependencies under `[dependencies]` are in alphabetical order, the added dependency will follow suit.

[cargo-udeps: Find unused dependencies in Cargo.toml](https://github.com/est31/cargo-udeps)

## Versions
- [Major-open semver range does not properly unify with closed semver ranges - Issue #9029 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/9029)

  > Cargo will always take the maximal major version of such a requirement: if one dependency requires `riscv = "0.7.0"`, and another dependency requires `riscv = ">=0.7.0, <0.9.0"`, then Cargo will install both v0.7.0 and v0.8.0, unless you carefully use `cargo update --precise` to manually unify the versions.

  > Cargos resolver (with in the one-per-major constraints) attempts to optimize for "getting everyone the most recent they can use" and does not optimize for "have the fewest versions".

  > Understandable, and almost certainly the correct target for private dependencies. Just very unfortunate for public dependencies, where it's not so much wanting to "have the fewest versions" as wanting not to "expected type `rgb::RGBA`, found type `rgb::RGBA`".

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

## Overriding dependencies
[Overriding Dependencies - The Cargo Book](https://doc.rust-lang.org/cargo/reference/overriding-dependencies.html)

Replace (deprecated):
```toml
[replace]
"foo:0.1.0" = { git = 'https://github.com/example/foo.git' }
"bar:1.0.2" = { path = 'my/local/bar' }
```

Patch:
```toml
[patch.crates-io]
uuid = { path = "../path/to/uuid" }

uuid = { git = 'https://github.com/uuid-rs/uuid.git' }

[patch."https://github.com/your/repository"]
my-library = { path = "../my-library/path" }
```
> whereas `[replace]` globally changes the source for an existing version of a crate, `[prepublish]` *adds* a new version of a crate. This works very nicely with Cargo's dependency resolution.

> This will effectively add the local checked out version of `uuid` to the crates.io registry for our local package. Next up we need to ensure that our lock file is updated to use this new version of `uuid` so our package uses the locally checked out copy instead of one from crates.io. The way `[patch]` works is that it'll load the dependency at `../path/to/uuid` and then whenever crates.io is queried for versions of `uuid` it'll *also* return the local version.
>
> This means that the version number of the local checkout is significant and will affect whether the patch is used. Our manifest declared `uuid = "1.0"` which means we'll only resolve to `>= 1.0.0, < 2.0.0`, and Cargo's greedy resolution algorithm also means that we'll resolve to the maximum version within that range. Typically this doesn't matter as the version of the git repository will already be greater or match the maximum version published on crates.io, but it's important to keep this in mind!

- If the new version is not compatible, how to forcely override the versions of indirect dependencies used in dependencies?
  - Patch all dependencies used it
    - `>=0.1, <0.3`, see [versions](#versions).
  - [dtolnay/semver-trick: How to avoid complicated coordinated upgrades](https://github.com/dtolnay/semver-trick)

    > If you want to fake it, the way out is to utilize [the "semver trick"](https://github.com/dtolnay/semver-trick). Replace `riscv@0.7` with a fresh local package that also identifies as `riscv@0.7`, which consists solely of a dependency on `riscv@0.10` and a `pub use riscv::*;`. Do the same for `riscv@0.8` with another distinct package that also just `pub use`s `riscv@0.10`'s contents.

  [allow overriding dependency major version - Issue #5640 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/5640)

  [Inconsistent cargo \[patch\] for transitive dependencies? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/inconsistent-cargo-patch-for-transitive-dependencies/90942)

  [Can i override the dependency \*of a dependency\*? : r/rust](https://www.reddit.com/r/rust/comments/1cc431v/can_i_override_the_dependency_of_a_dependency/)
  > For incompatible version changes you'll need to change the dependency, by patching/vendoring/etc.

- `patch` is global-only / infectious

  > Cargo only looks at the patch settings in the `Cargo.toml` manifest at the root of the workspace. Patch settings defined in dependencies will be ignored.

  If you patch a dependency with a local `path`, downstreams using your package as a Git dependency cannot use the patched dependency without patching their root workspace too. This leads to abstraction leak.
  
  While if you use `path` direcrly, they can. But it then requires to duplicate `path` in every relevant `Cargo.toml`. This is only doable when there are no cyclic dependencies, i.e., no external dependencies in your package is using your package.

  One solution is to add both of them.

  [Handle cyclic dependencies by baloo - Pull Request #997 - RustCrypto/formats](https://github.com/RustCrypto/formats/pull/997)

  [Publishing a crate with patched dependencies - Issue #13222 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/13222)

- [Support patching one with another package from the same source - Issue #9227 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/9227#issuecomment-1697916963)
