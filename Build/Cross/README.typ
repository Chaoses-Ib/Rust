#import "/lib.typ": *
#title[Cross-compilation]

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
