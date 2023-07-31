# Memory Management
## Memory allocators
[Allocator traits and std::heap · Issue #32838 · rust-lang/rust](https://github.com/rust-lang/rust/issues/32838)

- [Mimalloc Rust: A Rust wrapper over Microsoft's MiMalloc memory allocator](https://github.com/purpleprotocol/mimalloc_rust)

  [mimalloc: a compact general purpose allocator with excellent performance : rust](https://www.reddit.com/r/rust/comments/c3qc9z/mimalloc_a_compact_general_purpose_allocator_with/)

  [Rust Mimalloc v0.1.30 has just been released! : rust](https://www.reddit.com/r/rust/comments/y2yr5i/rust_mimalloc_v0130_has_just_been_released/)

- [jemallocator: Rust allocator using jemalloc as a backend](https://github.com/gnzlbg/jemallocator)

  Windows is not supported.

  [Jemalloc was just removed from the standard library 🎉 - announcements - Rust Internals](https://internals.rust-lang.org/t/jemalloc-was-just-removed-from-the-standard-library/8759)

- [Rulloc: General purpose memory allocator written in Rust.](https://github.com/antoniosarosi/rulloc)

- [Allocators in Rust](https://github.com/ezrosent/allocators-rs) (discontinued)

  [Announcing elfmalloc, a pure Rust allocator that's competitive on performance with jemalloc - announcements - The Rust Programming Language Forum](https://users.rust-lang.org/t/announcing-elfmalloc-a-pure-rust-allocator-thats-competitive-on-performance-with-jemalloc/12693)

- [sharded-slab: a lock-free concurrent slab](https://github.com/hawkw/sharded-slab)

Bump allocators:
- [bumpalo: A fast bump allocation arena for Rust](https://github.com/fitzgen/bumpalo)

## Profiling
[Measuring Memory Usage in Rust](https://rust-analyzer.github.io/blog/2020/12/04/measuring-memory-usage-in-rust.html)

Allocators:
- [cap: An allocator that can track and limit memory usage.](https://github.com/alecmocatta/cap)

- [dhat-rs: Heap profiling and ad hoc profiling for Rust programs.](https://github.com/nnethercote/dhat-rs)

- [heaptrack: A heap memory profiler for Linux](https://github.com/KDE/heaptrack)

  [Profiling heap allocation in rust | FlakM blog](https://flakm.github.io/posts/heap_allocation/)

Traits:
- [deepsize: A rust crate to find the total size of an object, on the stack and on the heap](https://github.com/Aeledfyr/deepsize/)

- [memuse: Traits for inspecting memory usage of Rust types](https://github.com/str4d/memuse)

- [/get-size: Determine the size in bytes an object occupies inside RAM.](https://github.com/DKerp/get-size)