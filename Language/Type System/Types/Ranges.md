# Ranges
- [std::ops::Range](https://doc.rust-lang.org/std/ops/struct.Range.html)
- [Ranges: A generic replacement for the core/std range types.](https://gitlab.com/bit-refined/ranges/)
- [range\_map\_vec: A Rust crate that implements a range map data structure backed by a Vec.](https://github.com/microsoft/range_map_vec)
- [every-range: Iterator that "fill in" missing ranges, i.e. the gap between two consecutive ranges](https://github.com/vallentin/every-range)

## ID pools
- [id-pool: Create and recycle integer ids using a ranged pool](https://github.com/adamsky/id-pool)
  ```rust
  pub struct IdPool {
      /// List of available id ranges
      free: Vec<Range>,
      /// Number of ids currently in use
      used: usize,
  }
  ```
  - Serialization: Serde

- [reusable-id-pool](https://github.com/davepollack/nushift/tree/master/reusable-id-pool)
  ```rust
  struct ReusableIdPoolInternal {
      frontier: u64,
      free_list: Vec<u64>,
  }
  ```