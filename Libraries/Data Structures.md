# Data Structures
- [heapless: Heapless, `static` friendly data structures](https://github.com/japaric/heapless)
- [thincollections: Alternate implementations of vector/map/set for Rust](https://github.com/mohrezaei/thincollections/tree/master)
- [ecow: Compact, clone-on-write vector and string.](https://github.com/typst/ecow)

Concurrent:
- [Crossbeam: Tools for concurrent programming in Rust](https://github.com/crossbeam-rs/crossbeam#data-structures)
- [Scalable Concurrent Containers: High performance containers and utilities for concurrent and asynchronous programming](https://github.com/wvwwvwwv/scalable-concurrent-containers)

## Arrays
- [Syncbuf: A small library of append-only, thread-safe, lock-free data structures.](https://github.com/bplevin36/syncbuf)

  Can `push` with `&self`, but cannot mutate items.

### Vectors
- [std::vec](https://doc.rust-lang.org/std/vec/index.html)

  [Storing Lists of Values with Vectors - The Rust Programming Language](https://doc.rust-lang.org/book/ch08-01-vectors.html)

  [When does `vec.into_iter().map(...).collect()` reallocate and when doesn't it? : r/rust](https://www.reddit.com/r/rust/comments/16hx79e/when_does_vecinto_itermapcollect_reallocate_and/)
  - [`map_in_place`: A rust library for reusing heap allocations](https://github.com/tormol/map_in_place)
  
- [rust-smallvec: "Small vector" optimization for Rust: store up to a small number of items on the stack](https://github.com/servo/rust-smallvec)
- [tinyvec: Just, really the littlest Vec you could need. So smol.](https://github.com/Lokathor/tinyvec)
- [thin-vec: A Vec That Has a Smaller size_of](https://github.com/Gankra/thin-vec)
- [staticvec: Implements a fixed-capacity stack-allocated Vec alternative backed by an array, using const generics.](https://github.com/slightlyoutofphase/staticvec/)
- [sorted-vec: Create and maintain collections of sorted elements.](https://gitlab.com/spearman/sorted-vec)
- [Dup-Indexer: Create a non-duplicated index from Strings, static str, Vec, or Box values](https://github.com/nyurik/dup-indexer)
- [RleVec: A rust crate providing a vector like struct that stores data as runs of identical values.](https://github.com/veldsla/rle_vec)
- [rt_vec: Runtime managed mutable borrowing from a vec.](https://github.com/azriel91/rt_vec/tree/main)
  
  ```rust
  pub struct RtVec<V>(Vec<Cell<V>>);
  ```

### Segment vectors
- [segvec: SegVec data structure for rust. Similar to Vec, but allocates memory in chunks of increasing size.](https://github.com/mccolljr/segvec/)
  - `Send + Sync`

  ```rust
  pub struct SegVec<T, C: MemConfig = Exponential<1>> {
      len: usize,
      segments: detail::Segments<T>,
      config: C,
  }
  ```

- [typed-arena: The arena, a fast but limited type of allocator](https://github.com/thomcc/rust-typed-arena)
  - Can `alloc` with `&self`, and returns `&mut T`.
  - `Send + !Sync`

- [boxcar: A concurrent, append-only vector.](https://github.com/ibraheemdev/boxcar)
  - Can `push` with `&self`.
  - `Send + Sync`
  - Faster than `Mutex<Vec>`, but slower than `thread_local::ThreadLocal<RefCell<Vec>>`.

  ```rust
  pub struct Vec<T> {
      // a counter used to retrieve a unique index to push to.
      //
      // this value may be more than the true length as it will
      // be incremented before values are actually stored.
      inflight: AtomicU64,
      // buckets of length 32, 64 .. 2^63
      buckets: [Bucket<T>; BUCKETS],
      // the number of initialized elements in this vector
      count: AtomicUsize,
  }
  ```

- [aovec: Append-only concurrent vector](https://docs.rs/aovec/latest/aovec/)
  - Can `push` with `&self`, but cannot mutate items.

### Bit arrays
- [bit-vec: A Vec of Bits](https://github.com/contain-rs/bit-vec)
  - [Unchecked get and set by florin-saftoiu - Pull Request #69 - contain-rs/bit-vec](https://github.com/contain-rs/bit-vec/pull/69)
- [bitvec_simd](https://github.com/gccfeli/bitvec_simd)
- [bitvec: A crate for managing memory bit by bit](https://github.com/ferrilab/bitvec)
- [bit_field](https://github.com/phil-opp/rust-bit-field)

  A simple crate which provides the BitField trait, which provides methods for operating on individual bits and ranges of bits on Rust's integral types.

- [bitmaps: Bitmap types for Rust](https://github.com/bodil/bitmaps)
- [bsuccinct-rs: Succinct data structures and other libraries for Rust](https://github.com/beling/bsuccinct-rs)
- [RoaringBitmap: A better compressed bitset in Rust](https://github.com/RoaringBitmap/roaring-rs)

Benchmarks:
- [bitvec_simd](https://github.com/gccfeli/bitvec_simd#performance)

### Linear maps
- [LinearMap in heapless](https://docs.rs/heapless/latest/heapless/struct.LinearMap.html)
- [linear-map: A map backed by a vector](https://github.com/contain-rs/linear-map)

### Type maps
- [→Enum maps](/Language/Type%20System/Types/Enumerations.md#data-types)

- [AnyMap: A safe and convenient store for one value of each type](https://github.com/chris-morgan/anymap)

  A type-safe wrapper around `HashMap<TypeId, Box<dyn Any>>` (where `TypeId` is in fact `u128`).

- [TypeMap: A typesafe store keyed by types and containing different types of values.](https://github.com/reem/rust-typemap)

## Queues
- [std::collections::VecDeque](https://doc.rust-lang.org/stable/std/collections/struct.VecDeque.html)

## Trees
Concurrent:
- [concurrent-map: lock-free B+ tree](https://github.com/komora-io/concurrent-map)

## Buffers
- [left-right: A lock-free, read-optimized, concurrency primitive.](https://github.com/jonhoo/left-right)
- [Concread: Concurrently Readable Data Structures for Rust](https://github.com/kanidm/concread)

  [What is Concrete? - Concrete](https://docs.zama.ai/concrete/)
- [triple-buffer: Implementation of triple buffering in Rust](https://github.com/HadrienG2/triple-buffer)

## Cache
- [cached: Rust cache structures and easy function memoization](https://github.com/jaemk/cached)
  - [Is it completely impossible to cache generic functions? - Issue #139](https://github.com/jaemk/cached/issues/139)
  - [How to aproach generics ? - Issue #80](https://github.com/jaemk/cached/issues/80)
- [cache-macro: A procedural attribute macro to automatically cache the results of a function call with given args.](https://github.com/tylerreisinger/cache-macro)
- [EVLRU: An eventually consistent LRU designed for lock-free concurrent reads](https://github.com/Bajix/evlru)