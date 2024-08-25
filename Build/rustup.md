# rustup
[Install Rust - Rust Programming Language](https://www.rust-lang.org/tools/install)

~1 GiB

[The rustup book](https://rust-lang.github.io/rustup/)

## Overrides
[The rustup book](https://rust-lang.github.io/rustup/overrides.html)

`rust-toolchain.toml`:
```toml
[toolchain]
channel = "nightly"
targets = [ "x86_64-pc-windows-msvc" ]
```
- 缺失时 rustup 会自动下载。
- `nightly-2024-01-02` 对应的是 rustc `2024-01-01`

[How to switch between Rust stable version and nightly verison in VSCode? - Editors and IDEs - The Rust Programming Language Forum](https://users.rust-lang.org/t/how-to-switch-between-rust-stable-version-and-nightly-verison-in-vscode/61429)

[cargo-toolchain: Utility to get information on active rustup toolchains](https://github.com/ian-fox/cargo-toolchain)