# Packages
A **package** is a bundle of one or more crates that provides a set of functionality. A package can contain as many binary crates as you like, but at most only one library crate. A package contains a _Cargo.toml_ file that describes how to build those crates.

[Appendix: Glossary - The Cargo Book](https://doc.rust-lang.org/cargo/appendix/glossary.html#package)

> A *package* is a collection of source files and a `Cargo.toml` [*manifest*](https://doc.rust-lang.org/cargo/appendix/glossary.html#manifest) file which describes the package. A package has a name and version which is used for specifying dependencies between packages.
> 
> A package contains multiple [*targets*](https://doc.rust-lang.org/cargo/appendix/glossary.html#target), each of which is a [*crate*](https://doc.rust-lang.org/cargo/appendix/glossary.html#crate). The `Cargo.toml` file describes the type of the crates (binary or library) within the package, along with some metadata about each one --- how each is to be built, what their direct dependencies are, etc., as described throughout this book.
> 
> The *package root* is the directory where the package's `Cargo.toml` manifest is located. (Compare with [*workspace root*](https://doc.rust-lang.org/cargo/appendix/glossary.html#workspace).)
> 
> The [*package ID specification*](https://doc.rust-lang.org/cargo/reference/pkgid-spec.html), or *SPEC*, is a string used to uniquely reference a specific version of a package from a specific source.
> 
> Small to medium sized Rust projects will only need a single package, though it is common for them to have multiple crates.
> 
> Larger projects may involve multiple packages, in which case Cargo [*workspaces*](https://doc.rust-lang.org/cargo/appendix/glossary.html#workspace) can be used to manage common dependencies and other related metadata between the packages.

## Environment variables
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/environment-variables.html#environment-variables-cargo-sets-for-crates)

- `CARGO_PKG_NAME`, `CARGO_CRATE_NAME`, `CARGO_BIN_NAME`
- `CARGO_PKG_VERSION`
- `CARGO_PKG_DESCRIPTION`
- `CARGO_PKG_AUTHORS` (colon separated list)
- `CARGO_PKG_HOMEPAGE`
- `CARGO_PKG_REPOSITORY`
- `CARGO_PKG_LICENSE`
- `CARGO_PKG_README` (path)
- `CARGO_PRIMARY_PACKAGE`

[How to get Cargo pkg version of top level crate? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/how-to-get-cargo-pkg-version-of-top-level-crate/110141)
- Macros

## Targets
Cargo follows the following conventions on finding crate roots:
- `src/main.rs` is the crate root of a binary crate with the same name as the package.
- `src/lib.rs` is the crate root of a library crate with the same name as the package.
- Each file in `src/bin` is a separate binary create.

[Allow dependencies that only apply to specific cargo targets (bin, example, etc.) - Issue #1982 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/1982)
- Workspaces
- Features
- [Cargo target features by ehuss - Pull Request #3374 - rust-lang/rfcs](https://github.com/rust-lang/rfcs/pull/3374#issuecomment-1714289532)
 
  > I'm going to close this RFC for a few reasons. I think some of the behaviors around feature unification are going to result in some hazards that will make it difficult to use and cause problems that people would then need to figure out how to work around. The `cargotest` workflow in particular would be unable to test without the features enabled. I also agree that the indirect nature of using this mechanism to specify per-target dependencies is not obvious, so I worry about making things too confusing, along with being unable to isolate those dependencies between targets. It also doesn't help to have two similarly named fields, which can be confusing. I've also been hesitant to move forward with this since I started writing it due to the level of complexity in the implementation that appeared (I only started it because I thought it would have been relatively easy).

- [How can I specify binary-only dependencies? - Stack Overflow](https://stackoverflow.com/questions/35711044/how-can-i-specify-binary-only-dependencies)
- [Why doesn't rust have bin-dependencies? : r/rust](https://www.reddit.com/r/rust/comments/1fi32rm/why_doesnt_rust_have_bindependencies/)

如果不能隔离依赖，支持 lib + bin target 还有什么意义？
- [axo blog - It's a library AND a binary](https://blog.axo.dev/2024/03/its-a-lib-and-a-bin)