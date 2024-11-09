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
  - [Internal buffering disrupts format-specific deserialization features - Issue #1183](https://github.com/serde-rs/serde/issues/1183)
  - [Enum representations](https://serde.rs/enum-representations.html)
    - Externally tagged
    - Internally tagged
      - [Optional tag for internally tagged enum - Issue #2231](https://github.com/serde-rs/serde/issues/2231)
        - Untagged + Internally tagged
          
          [rust - How can I deserialize an enum with an optional internal tag? - Stack Overflow](https://stackoverflow.com/questions/61216723/how-can-i-deserialize-an-enum-with-an-optional-internal-tag)
        - ~~Internally tagged + untagged~~
    - Adjacently tagged
    - Untagged
      - [serde-untagged: Serde Visitor for deserializing untagged enums](https://github.com/dtolnay/serde-untagged)
      - [Better message when failing to match any variant of an untagged enum - Issue #2157](https://github.com/serde-rs/serde/issues/2157)
      - [Untagged enums with empty variants (de)serialize in unintuitive ways - Issue #1560](https://github.com/serde-rs/serde/issues/1560)
  - [Serialize enum as number - Serde](https://serde.rs/enum-number.html)

  Types:
  - [`#[serde(with = "module")]`](https://serde.rs/field-attrs.html#with)
    - `$module::{serialize, deserialize}`
  - [Serialize `[u8]` as a base64 or hex? - Issue #661](https://github.com/serde-rs/serde/issues/661)
  - [serde\_with: Custom de/serialization helpers to use in combination with serde's `with`-annotation and with the improved `serde_as\`-annotation.](https://github.com/jonasbb/serde_with/)
    - [`#[serde_as]`](https://docs.rs/serde_with/3.11.0/serde_with/guide/serde_as/index.html)
      - `LocalType as {SerializeAs<RemoteType>, DeserializeAs<'de, RemoteType>}`
      - 😈`serde_as`, provided by `serde_with`, different from `serde(with)`
    - `#[skip_serializing_none]` (must be placed *before* the `#[derive]` attribute)
    - [base64](https://docs.rs/serde_with/latest/serde_with/base64/index.html)
  - [base64-serde: Integration between rust-base64 and serde](https://github.com/marshallpierce/base64-serde)

  Formats:
  - [serde\_json: Strongly typed JSON library for Rust](https://github.com/serde-rs/json)

- [Bincode](https://github.com/bincode-org/bincode)

  [Serialization specification](https://github.com/bincode-org/bincode/blob/trunk/docs/spec.md)

- [speedy](https://github.com/koute/speedy)

- [Abomonation: A mortifying serialization library for Rust](https://github.com/TimelyDataflow/abomonation)

## Benchmarks
- [Rust serialization benchmark](https://github.com/djkoloski/rust_serialization_benchmark)
- [Rust serialization: What's ready for production today? - LogRocket Blog](https://blog.logrocket.com/rust-serialization-whats-ready-for-production-today/)
