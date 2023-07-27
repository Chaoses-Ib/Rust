# Data Structures
## Arrays
- [Syncbuf: A small library of append-only, thread-safe, lock-free data structures.](https://github.com/bplevin36/syncbuf)

### Vectors
- [rust-smallvec: "Small vector" optimization for Rust: store up to a small number of items on the stack](https://github.com/servo/rust-smallvec)
- [tinyvec: Just, really the littlest Vec you could need. So smol.](https://github.com/Lokathor/tinyvec)
- [thin-vec: A Vec That Has a Smaller size_of](https://github.com/Gankra/thin-vec)

### Segment vectors
- [segvec: SegVec data structure for rust. Similar to Vec, but allocates memory in chunks of increasing size.](https://github.com/mccolljr/segvec/)
- [boxcar: A concurrent, append-only vector.](https://github.com/ibraheemdev/boxcar)
- [aovec: Append-only concurrent vector](https://docs.rs/aovec/latest/aovec/)

### Bit arrays
- [bit-vec: A Vec of Bits](https://github.com/contain-rs/bit-vec)
- [bitvec_simd](https://github.com/gccfeli/bitvec_simd)
- [bitvec: A crate for managing memory bit by bit](https://github.com/ferrilab/bitvec)
- [bitmaps: Bitmap types for Rust](https://github.com/bodil/bitmaps)
- [bsuccinct-rs: Succinct data structures and other libraries for Rust](https://github.com/beling/bsuccinct-rs)
- [RoaringBitmap: A better compressed bitset in Rust](https://github.com/RoaringBitmap/roaring-rs)

Benchmarks:
- [bitvec_simd](https://github.com/gccfeli/bitvec_simd#performance)

## Hash tables
- [hashbrown: Rust port of Google's SwissTable hash map](https://github.com/rust-lang/hashbrown)

  [Replace HashMap implementation with SwissTable (as an external crate) by Amanieu · Pull Request #58623 · rust-lang/rust](https://github.com/rust-lang/rust/pull/58623)

  [Worse memory usage than old stdlib hashmap due to growth factor differences. · Issue #304 · rust-lang/hashbrown](https://github.com/rust-lang/hashbrown/issues/304)
  - `(capacity() * 8 / 7).next_power_of_two() * (sizeof(K) + sizeof(V) + sizeof(u8))`

  [Measuring the overhead of HashMaps in Rust | nicole@web](https://ntietz.com/blog/rust-hashmap-overhead/)

- [DashMap: Blazing fast concurrent HashMap for Rust.](https://github.com/xacrimon/dashmap)

[conc-map-bench](https://github.com/xacrimon/conc-map-bench)

[Measure the memory usage of HashMap better · Issue #6908 · servo/servo](https://github.com/servo/servo/issues/6908)

## Cache
- [cached: Rust cache structures and easy function memoization](https://github.com/jaemk/cached)
- [EVLRU: An eventually consistent LRU designed for lock-free concurrent reads](https://github.com/Bajix/evlru)