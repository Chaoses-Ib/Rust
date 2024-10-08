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

## Targets
Cargo follows the following conventions on finding crate roots:
- `src/main.rs` is the crate root of a binary crate with the same name as the package.
- `src/lib.rs` is the crate root of a library crate with the same name as the package.
- Each file in `src/bin` is a separate binary create.
