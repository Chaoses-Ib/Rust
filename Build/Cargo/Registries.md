# Registries
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/registries.html)

[how to update crate registry (index) using cargo - Stack Overflow](https://stackoverflow.com/questions/63748045/how-to-update-crate-registry-index-using-cargo)
- `cargo update --dry-run`

[cargo publish - The Cargo Book](https://doc.rust-lang.org/cargo/commands/cargo-publish.html)

Registries:
- [crates.io](https://crates.io/)

## Workspaces
[Cargo Workspaces - The Rust Programming Language](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html)
> If you publish the crates in the workspace to [crates.io](https://crates.io/), each crate in the workspace will need to be published separately. Like `cargo test`, we can publish a particular crate in our workspace by using the `-p` flag and specifying the name of the crate we want to publish.

[Publishing workspace crates - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/publishing-workspace-crates/64281)
> `path` applies only inside your workspace. When you upload, it becomes a regular dependency that will be resolved by looking at [crates.io](http://crates.io/). This means that
> - You need a `version` in the dependency declaration, not just a `path`.
> - You must publish the packages in dependency order --- `foo` before anything that depends on `foo`.

[How do you publish your cargo workspace packages without `cargo publish --all`? : r/rust](https://www.reddit.com/r/rust/comments/a39er8/how_do_you_publish_your_cargo_workspace_packages/)
> it is perfectly valid to have path *and* version entries for the same dependency: When you build locally, Cargo will use the path dependency. When you publish / someone builds your package from crates.io, Cargo will user the version dependency.

- Is it possible to publish a package and its local dependencies as a single crate?

  - [lpenz/rust-sourcebundler: Bundle the source code of a binary in a crate into a single .rs file to be used in single-file programming competition sites](https://github.com/lpenz/rust-sourcebundler)
  - [cargo-merge - crates.io: Rust Package Registry](https://crates.io/crates/cargo-merge)

- [cargo publish multiple packages at once - Issue #1169 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/1169)
