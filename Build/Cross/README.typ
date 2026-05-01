#import "/lib.typ": *
#title[Cross-compilation]
LLVM and rustc themselves support cross-compilation.
But reality is a mess.

= Linux
- ``` error: linker `cc` not found ```
  #footnote[#a[linux - How do I fix the Rust error "linker 'cc' not found" for Debian on Windows 10? - Stack Overflow][https://stackoverflow.com/questions/52445961/how-do-i-fix-the-rust-error-linker-cc-not-found-for-debian-on-windows-10]]
  - ```sh apt install gcc``` (0.18 GB)
    - ```sh apt install build-essential``` (0.25 GB)
  - ```sh apt install clang & CC=clang``` (0.82 GB)

  #q[
  You need either gcc or clang installed as linker driver. The new lld default only makes rustc tell gcc/clang to use lld as the underlying linker.
  You still need gcc or clang as wrapper to tell the linker where to find system libraries and which flags to link with. This is true for all unix platforms.
  Only on Windows, wasm and embedded platforms does rustc directly invoke the linker.]
  #footnote[#a[Rust 1.90 and LLD - The Rust Programming Language Forum][https://users.rust-lang.org/t/rust-1-90-and-lld/134056]]

- Use `x86_64-unknown-linux-musl` instead
  #footnote[#a[Error: "linker 'cc' not found" when cross compiling a rust project from windows to linux using cargo - Stack Overflow][https://stackoverflow.com/questions/63739813/error-linker-cc-not-found-when-cross-compiling-a-rust-project-from-windows]]

#a[Faster linking times with 1.90.0 stable on Linux using the LLD linker | Rust Blog][https://blog.rust-lang.org/2025/09/01/rust-lld-on-1.90.0-stable/]
#a-badge[https://www.reddit.com/r/rust/comments/1n5yty9/faster_linking_times_with_1900_stable_on_linux/]

= Windows
- `lib`, `rlib` and `staticlib` don't need `link.exe`, but `bin`, `dylib` and `cdylib` do.
  - For C/Rust projects, using Rust as a `staticlib` would be easier than the other way around for cross-compilation.

  ```sh
  cargo build --target x86_64-pc-windows-msvc
    Compiling hello v0.1.0 (/root/dev/rs/hello)
  error: linker `link.exe` not found
    |
    = note: No such file or directory (os error 2)

  note: the msvc targets depend on the msvc linker but `link.exe` was not found

  note: please ensure that Visual Studio 2017 or later, or Build Tools for Visual Studio were installed with the Visual C++ option

  note: VS Code is a different product, and is not sufficient

  error: could not compile `hello` (bin "hello") due to 1 previous error
  ```
  
- #a[rust-cross/cargo-xwin: Cross compile Cargo project to Windows MSVC target with ease][https://github.com/rust-cross/cargo-xwin]

- #a[msvc-wine][https://github.com/Chaoses-Ib/Cpp/blob/main/Build/Build%20Systems/MSBuild/Linux.typ]:
  ```sh cargo rustc --target x86_64-pc-windows-msvc --crate-type cdylib -- -Clinker="/opt/msvc/bin/x64/link"```

- lld
  #footnote[#a[Using LLD as the linker on windows : r/rust][https://www.reddit.com/r/rust/comments/nivznh/using_lld_as_the_linker_on_windows/]]
  - #a[Use lld by default on x64 msvc windows - Issue \#71520 - rust-lang/rust][https://github.com/rust-lang/rust/issues/71520]
  
- #a[The RAD Linker][https://github.com/EpicGamesExt/raddebugger#the-rad-linker]

- MinGW: `x86_64-pc-windows-gnu`
  #footnote[#a[Cross-compile a Rust application from Linux to Windows - Stack Overflow][https://stackoverflow.com/questions/31492799/cross-compile-a-rust-application-from-linux-to-windows]]

#a[`cross-toolchains/docker/Dockerfile.x86_64-pc-windows-msvc-cross` at main - cross-rs/cross-toolchains][https://github.com/cross-rs/cross-toolchains/blob/main/docker/Dockerfile.x86_64-pc-windows-msvc-cross]

= Zig
- #a[rust-cross/cargo-zigbuild: Compile Cargo project with zig as linker][https://github.com/rust-cross/cargo-zigbuild]

= #a[cross][https://github.com/cross-rs/cross]
#q["Zero setup" cross compilation and "cross testing" of Rust crates]

- ```sh cargo install cross --git https://github.com/cross-rs/cross```
- Inactive

  #a["Couldn't install toolchain" - Issue \#1649][https://github.com/cross-rs/cross/issues/1649]

  #a[Updated release? [0.2.6?] [0.3.0?] - Discussion \#1290][https://github.com/cross-rs/cross/discussions/1290]

- Adding dependencies to existing images
  #footnote[#a[cross/docs/custom\_images.md at main - cross-rs/cross][https://github.com/cross-rs/cross/blob/main/docs/custom_images.md#adding-dependencies-to-existing-images]]

  ```toml
  [workspace.metadata.cross.target.x86_64-unknown-linux-gnu]
  pre-build = [
      "dpkg --add-architecture $CROSS_DEB_ARCH",
      "apt-get update && apt-get install --assume-yes protobuf-compiler:$CROSS_DEB_ARCH",
  ]
  ```
  Simply ```sh apt-get install protobuf-compiler``` will cause error.

#a[PSA: For cross-compiling please use the "Cross" tool. : rust][https://www.reddit.com/r/rust/comments/18z5g3g/psa_for_crosscompiling_please_use_the_cross_tool/]
