# Concurrency
- [parking_lot: Compact and efficient synchronization primitives for Rust. Also provides an API for creating custom synchronization primitives.](https://github.com/Amanieu/parking_lot)
- [Crossbeam: Tools for concurrent programming in Rust](https://github.com/crossbeam-rs/crossbeam)

[Concurrency — list of Rust libraries/crates // Lib.rs](https://lib.rs/concurrency)

## Parallelism
- [Rayon: A data parallelism library for Rust](https://github.com/rayon-rs/rayon)

  [Rayon: data parallelism in Rust - Baby Steps](https://smallcultfollowing.com/babysteps/blog/2015/12/18/rayon-data-parallelism-in-rust/)

  `par_iter()` 和 `iter().par_bridge()` 是不同的，前者的性能可能更高。
  - [impl par_iter for other std collections. · Issue #88 · rayon-rs/rayon](https://github.com/rayon-rs/rayon/issues/88)
  - [Is it necessary to collect non-linear collections into `Vec`? · Issue #358 · rayon-rs/rayon](https://github.com/rayon-rs/rayon/issues/358)