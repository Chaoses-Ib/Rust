# rustc
[The rustc book](https://doc.rust-lang.org/rustc/what-is-rustc.html), [GitHub](https://github.com/rust-lang/rust/tree/master/compiler)

[Rust Compiler Development Guide](https://rustc-dev-guide.rust-lang.org/)

## API
[rustc\_driver and rustc\_interface - Rust Compiler Development Guide](https://rustc-dev-guide.rust-lang.org/rustc-driver.html)

- [rustc\_driver - Rust](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_driver/)
- [rustc\_interface - Rust](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_interface/)

[Peeking at compiler-internal data (for fun and profit) - YouTube](https://www.youtube.com/watch?v=SKmd5A-1cSE)

## Nightly
[Downside to using rust nightly as a default toolchain? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/downside-to-using-rust-nightly-as-a-default-toolchain/62428)
> For some projects we have been using nightly for over a year now. In production. Because the Rocket web framework required features from nightly. Nothing bad has happened.
> 
> The trick is that "nightly", which implies not stable, not totally tested and liable to change at anytime, requires that if you have a working system you have to be able to get back to that exact night that it worked if some new nightly breaks things. So that you can keep operating running. You have to be prepared dive in and "fix" your code if a new nightly does break anything.

Make sure all your tests passed after updating the nightly version.

Install a specific nightly version:
```sh
rustup install nightly-2024-02-28
rustup default nightly-2024-02-28
```

## CLI
[Command-line Arguments - The rustc book](https://doc.rust-lang.org/rustc/command-line-arguments.html)

## Target platforms
[Targets - The rustc book](https://doc.rust-lang.org/rustc/targets/index.html)

[Platform Support - The rustc book](https://doc.rust-lang.org/rustc/platform-support.html)

### Cross-compilation
- `rustup target list`
- `rustup show`, `rustup target list --installed`
- `rustup target add i686-pc-windows-msvc`
- `cargo build --target=i686-pc-windows-msvc`

[Cross-compilation - The rustup book](https://rust-lang.github.io/rustup/cross-compilation.html)

- [cross: "Zero setup" cross compilation and "cross testing" of Rust crates](https://github.com/cross-rs/cross)

  [PSA: For cross-compiling please use the "Cross" tool. : rust](https://www.reddit.com/r/rust/comments/18z5g3g/psa_for_crosscompiling_please_use_the_cross_tool/)

- Multi-target build

  Changing target will break incremental build (`.rustc_info.json`):
  ```sh
  cargo build
  cargo build --target i686-pc-windows-msvc
  ```

  The solution is to build multiple targets at once:
  ```sh
  cargo build --target x86_64-pc-windows-msvc --target i686-pc-windows-msvc
  ```
  However, this will make the output directory of host target be `target/x86_64-pc-windows-msvc`, and break other the incremental build of other members in the workspace, if any.

  Another solution is to use different target directories:
  ```sh
  cargo build
  cargo build --target i686-pc-windows-msvc --target-dir ./target/32
  ```

  [Tracking issues for the `-Zmultitarget` feature - Issue #8176 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/8176)

  [Per crate build target in workspace - Issue #7004 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/7004)
  - No multi-target support.

  [Running cross and cargo builds for different targets breaks incremental compilation - Issue #551 - cross-rs/cross](https://github.com/cross-rs/cross/issues/551)

- [How to build for tier 3 target not included in `rustup target list`? - Stack Overflow](https://stackoverflow.com/questions/67352828/how-to-build-for-tier-3-target-not-included-in-rustup-target-list)

### Windows
- `#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]`

- v1.78 (2024-02): [Updated baseline standards for Windows targets | Rust Blog](https://blog.rust-lang.org/2024/02/26/Windows-7.html)

  `x86_64-win7-windows-msvc` and `i686-win7-windows-msvc`
  - [\*-win7-windows-msvc - The rustc book](https://doc.rust-lang.org/rustc/platform-support/win7-windows-msvc.html)

  [Windows support schedule 2024 - Issue #651 - rust-lang/compiler-team](https://github.com/rust-lang/compiler-team/issues/651)

  [Windows: Use ProcessPrng for random keys by ChrisDenton - Pull Request #121337 - rust-lang/rust](https://github.com/rust-lang/rust/pull/121337)

Resources:
- [winres: Create and set windows icons and metadata for executables with a rust build script](https://github.com/mxre/winres)
  - Metainformation (like program version and description) is taken from `Cargo.toml`'s `[package]` section.

    `homepage` is not used.
- [rust-embed-resource: A Cargo build script library to handle compilation and inclusion of Windows resources, in the most resilient fashion imaginable](https://github.com/nabijaczleweli/rust-embed-resource)