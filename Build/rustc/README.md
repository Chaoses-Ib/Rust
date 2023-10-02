# rustc
[The rustc book](https://doc.rust-lang.org/rustc/what-is-rustc.html)

## Target platforms
### Windows
Resources:
- [winres: Create and set windows icons and metadata for executables with a rust build script](https://github.com/mxre/winres)
  - Metainformation (like program version and description) is taken from `Cargo.toml`'s `[package]` section.

    `homepage` is not used.
- [rust-embed-resource: A Cargo build script library to handle compilation and inclusion of Windows resources, in the most resilient fashion imaginable](https://github.com/nabijaczleweli/rust-embed-resource)