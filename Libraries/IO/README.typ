#import "@local/ib:0.1.0": *
#title[I/O]
= `no_std` I/O
#a[Using ```rs std::io::{Read, Write, Cursor}``` in a nostd environment - Issue \#48331 - rust-lang/rust][https://github.com/rust-lang/rust/issues/48331]

- #a[embedded-io][https://crates.io/crates/embedded-io]
  #a-badge[https://github.com/rust-embedded/embedded-hal]
  #a-badge[https://docs.rs/embedded-io/]
  - #a[`embedded_io_adapters`][https://docs.rs/embedded-io-adapters/]
  - #a[\[Feature Request\] Provide `Cursor` Implementation in `embedded-io` - Issue \#631][https://github.com/rust-embedded/embedded-hal/issues/631]
  - `heapless`
- #a[core2: The bare essentials of std::io for use in `no_std`. Alloc support is optional.][https://github.com/technocreatives/core2]
  #a-badge[https://crates.io/crates/core2]
  (discontinued)
  - Most complete
  - Used by `libflate`, `multihash`
  - #a[no-std-io][https://github.com/no-std-io/no-std-io]
    #a-badge[https://docs.rs/no_std_io/]
    #a-badge[https://crates.io/crates/no-std-io]
    (discontinued)
- #a[ciborium-io][https://crates.io/crates/ciborium-io]
- #a[`core_io`: Rust `std::io` with all the parts that don't work in core removed.][https://github.com/jethrogb/rust-core_io]
  (discontinued)

#t[1712]
#a[Alternative to `io::Cursor` in `no_std` environments - libs - Rust Internals][https://internals.rust-lang.org/t/alternative-to-io-cursor-in-no-std-environments/6350]

#t[2502]
#a[Std::io handling in a `no_std`, core::io environment - status and future? - help - The Rust Programming Language Forum][https://users.rust-lang.org/t/std-io-handling-in-a-no-std-core-io-environment-status-and-future/126351]
