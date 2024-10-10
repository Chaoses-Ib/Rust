# Serialization
- Zero-copy deserialization
  - [rkyv: Zero-copy deserialization framework for Rust](https://github.com/rkyv/rkyv)
    - [Easier way to use archived and unarchived types together · Issue #167 · rkyv/rkyv](https://github.com/rkyv/rkyv/issues/167)
    - [Unaligned Buffer, only in Debug mode · Issue #218 · rkyv/rkyv](https://github.com/rkyv/rkyv/issues/218)
    - [Add optional support for serde's data model - Issue #329 - rkyv/rkyv](https://github.com/rkyv/rkyv/issues/329)
    - [Provide macros to derive rkyv traits on foreign types - Issue #400 - rkyv/rkyv](https://github.com/rkyv/rkyv/issues/400)
  - [zerocopy](https://github.com/google/zerocopy)
  - [Alkahest](https://github.com/zakarumych/alkahest)

- [Serde](https://serde.rs/) ([GitHub](https://github.com/serde-rs/serde))
  - [Enum representations](https://serde.rs/enum-representations.html)
    - Externally tagged
    - Internally tagged
    - Adjacently tagged
    - Untagged
  - [Serialize enum as number - Serde](https://serde.rs/enum-number.html)

  Formats:
  - [serde\_json: Strongly typed JSON library for Rust](https://github.com/serde-rs/json)

- [Bincode](https://github.com/bincode-org/bincode)

  [Serialization specification](https://github.com/bincode-org/bincode/blob/trunk/docs/spec.md)

- [speedy](https://github.com/koute/speedy)

- [Abomonation: A mortifying serialization library for Rust](https://github.com/TimelyDataflow/abomonation)

## Benchmarks
- [Rust serialization benchmark](https://github.com/djkoloski/rust_serialization_benchmark)
- [Rust serialization: What's ready for production today? - LogRocket Blog](https://blog.logrocket.com/rust-serialization-whats-ready-for-production-today/)
