# Data Structures
- [heapless: Heapless, `static` friendly data structures](https://github.com/japaric/heapless)

## Arrays
- [Syncbuf: A small library of append-only, thread-safe, lock-free data structures.](https://github.com/bplevin36/syncbuf)

  Can `push` with `&self`, but cannot mutate items.

### Vectors
- [rust-smallvec: "Small vector" optimization for Rust: store up to a small number of items on the stack](https://github.com/servo/rust-smallvec)
- [tinyvec: Just, really the littlest Vec you could need. So smol.](https://github.com/Lokathor/tinyvec)
- [thin-vec: A Vec That Has a Smaller size_of](https://github.com/Gankra/thin-vec)
- [Dup-Indexer: Create a non-duplicated index from Strings, static str, Vec, or Box values](https://github.com/nyurik/dup-indexer)

### Segment vectors
- [segvec: SegVec data structure for rust. Similar to Vec, but allocates memory in chunks of increasing size.](https://github.com/mccolljr/segvec/)

- [typed-arena: The arena, a fast but limited type of allocator](https://github.com/thomcc/rust-typed-arena)

  Can `alloc` with `&self`, and returns `&mut T`.

- [boxcar: A concurrent, append-only vector.](https://github.com/ibraheemdev/boxcar)

  Can `push` with `&self`.

- [aovec: Append-only concurrent vector](https://docs.rs/aovec/latest/aovec/)

  Can `push` with `&self`, but cannot mutate items.

### Bit arrays
- [bit-vec: A Vec of Bits](https://github.com/contain-rs/bit-vec)
- [bitvec_simd](https://github.com/gccfeli/bitvec_simd)
- [bitvec: A crate for managing memory bit by bit](https://github.com/ferrilab/bitvec)
- [bitmaps: Bitmap types for Rust](https://github.com/bodil/bitmaps)
- [bsuccinct-rs: Succinct data structures and other libraries for Rust](https://github.com/beling/bsuccinct-rs)
- [RoaringBitmap: A better compressed bitset in Rust](https://github.com/RoaringBitmap/roaring-rs)

Benchmarks:
- [bitvec_simd](https://github.com/gccfeli/bitvec_simd#performance)

### Linear maps
- [LinearMap in heapless](https://docs.rs/heapless/latest/heapless/struct.LinearMap.html)
- [linear-map: A map backed by a vector](https://github.com/contain-rs/linear-map)

## Hash tables
- [hashbrown: Rust port of Google's SwissTable hash map](https://github.com/rust-lang/hashbrown)

  [The Swiss Army Knife of Hashmaps | Arrow of Code](https://blog.waffles.space/2018/12/07/deep-dive-into-hashbrown/)

  [Replace HashMap implementation with SwissTable (as an external crate) by Amanieu · Pull Request #58623 · rust-lang/rust](https://github.com/rust-lang/rust/pull/58623)

  [Worse memory usage than old stdlib hashmap due to growth factor differences. · Issue #304 · rust-lang/hashbrown](https://github.com/rust-lang/hashbrown/issues/304)
  - `(capacity() * 8 / 7).next_power_of_two() * (sizeof(K) + sizeof(V) + sizeof(u8))`

  [Measuring the overhead of HashMaps in Rust | nicole@web](https://ntietz.com/blog/rust-hashmap-overhead/)

- [micromap: 📈 A much faster (for very small maps!) alternative of Rust HashMap, which doesn't use hashing and doesn't use heap](https://github.com/yegor256/micromap)

- [litemap: a highly simplistic “flat” key-value map based off of a single sorted vector](https://docs.rs/litemap/latest/litemap/)

[micromap Benchmark](https://github.com/yegor256/micromap#benchmark)

[Measure the memory usage of HashMap better · Issue #6908 · servo/servo](https://github.com/servo/servo/issues/6908)

### Concurrent hash tables
- [DashMap: Blazing fast concurrent HashMap for Rust.](https://github.com/xacrimon/dashmap)

[conc-map-bench](https://github.com/xacrimon/conc-map-bench)

### Ordered hash tables
- [indexmap: A hash table with consistent order and fast iteration; access items by key or sequence index](https://github.com/bluss/indexmap)
- [linked-hash-map: A HashMap wrapper that holds key-value pairs in insertion order](https://github.com/contain-rs/linked-hash-map)

## Cache
- [cached: Rust cache structures and easy function memoization](https://github.com/jaemk/cached)
- [EVLRU: An eventually consistent LRU designed for lock-free concurrent reads](https://github.com/Bajix/evlru)