# Data Structures
## Arrays
### Vectors

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

  [Worse memory usage than old stdlib hashmap due to growth factor differences. · Issue #304 · rust-lang/hashbrown](https://github.com/rust-lang/hashbrown/issues/304)
  - `(capacity() * 8 / 7).next_power_of_two() * (sizeof(K) + sizeof(V) + sizeof(u8))`

  [Measuring the overhead of HashMaps in Rust | nicole@web](https://ntietz.com/blog/rust-hashmap-overhead/)

[Measure the memory usage of HashMap better · Issue #6908 · servo/servo](https://github.com/servo/servo/issues/6908)