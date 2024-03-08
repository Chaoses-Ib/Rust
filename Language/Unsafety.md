# Unsafety
[The Rust Reference](https://doc.rust-lang.org/reference/unsafety.html)

[The Rustonomicon](https://doc.rust-lang.org/stable/nomicon/)

`unchecked` functions may still do checks if `debug_assertions` is enabled.
- `get_unchecked()`: To avoid the bound checks, use `*slice.as_ptr().offset(i)` instead.
  
  [`get_unchecked` and friends should do bound checks in debug mode. - Issue #36976 - rust-lang/rust](https://github.com/rust-lang/rust/issues/36976)

`slice::from_raw_parts()`:
- [Prevent undefined behavior in `context_buffer.rs` by DouglasDwyer - Pull Request #81 - steffengy/schannel-rs](https://github.com/steffengy/schannel-rs/pull/81)

[glandium.org » Blog Archive » When undefined behavior causes a nonsensical error (in Rust)](https://glandium.org/blog/?p=4354)
- ~~[`debug_asserts` within libstd are not hit unless using `-Zbuild-std` - Issue #120539 - rust-lang/rust](https://github.com/rust-lang/rust/issues/120539)~~