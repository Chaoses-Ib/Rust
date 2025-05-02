# Serialization
- Zero-copy deserialization
  - [rkyv: Zero-copy deserialization framework for Rust](https://github.com/rkyv/rkyv)
    - [Easier way to use archived and unarchived types together · Issue #167 · rkyv/rkyv](https://github.com/rkyv/rkyv/issues/167)
    - [Unaligned Buffer, only in Debug mode · Issue #218 · rkyv/rkyv](https://github.com/rkyv/rkyv/issues/218)
    - [Add optional support for serde's data model - Issue #329 - rkyv/rkyv](https://github.com/rkyv/rkyv/issues/329)
    - [Provide macros to derive rkyv traits on foreign types - Issue #400 - rkyv/rkyv](https://github.com/rkyv/rkyv/issues/400)
  - [zerocopy](https://github.com/google/zerocopy)
  - [Alkahest](https://github.com/zakarumych/alkahest)

- [Serde](#serde)

- [Bincode](https://github.com/bincode-org/bincode)

  [Serialization specification](https://github.com/bincode-org/bincode/blob/trunk/docs/spec.md)

- [speedy](https://github.com/koute/speedy)

- [Abomonation: A mortifying serialization library for Rust](https://github.com/TimelyDataflow/abomonation)

## Benchmarks
- [Rust serialization benchmark](https://github.com/djkoloski/rust_serialization_benchmark)
- [Rust serialization: What's ready for production today? - LogRocket Blog](https://blog.logrocket.com/rust-serialization-whats-ready-for-production-today/)

## Formatting
- Seriously limited by the orhpan rule

Implmentations:
- [`std::fmt::Formatter`](https://doc.rust-lang.org/std/fmt/struct.Formatter.html)
  - Creating

    [\[ACP\] Provide an interface for creating instances of fmt::Formatter - Issue #286 - rust-lang/libs-team](https://github.com/rust-lang/libs-team/issues/286)
    > Creating a custom [`Formatter`](https://doc.rust-lang.org/std/fmt/struct.Formatter.html) at runtime as well as modifying an existing `Formatter` is currently not supported, one can only use the `Formatter`s passed in by the formatting macros. Being able to create and modify them could be useful for multiple use cases:
    > 1. Calling the formatting code of contained fields with a modified formatting parameter
    > 2. Exposing different formatting methods for different representations/data points on one struct
    > 3. Exposing formatting methods that require additional data
    > 4. Writing libraries that provide enhanced formatting capabilities

    [Tracking Issue for `FormattingOptions` - Issue #118117 - rust-lang/rust](https://github.com/rust-lang/rust/issues/118117)

  - `Display`

  - `Debug`
    - Pretty print
      - Every element in `Vec` will take a line

      Workarounds:
      - `\b(\d+,)\r?\n\s+` -> `$1 `
      - `^\s+(\d+,)\r?\n` -> `$1 `
        - Break folding
      - Let LLM format again

      [Thoughts on `dbg!` pretty printing? : r/rust](https://www.reddit.com/r/rust/comments/1cp9rv8/thoughts_on_dbg_pretty_printing/)

- [tabled: An easy to use library for pretty print tables of Rust structs and enums.](https://github.com/zhiburt/tabled)

  [Tabled - An easy to use library for pretty print tables of Rust structs and enums. : r/rust](https://www.reddit.com/r/rust/comments/nqrkyh/tabled_an_easy_to_use_library_for_pretty_print/)

- [pretty.rs: Wadler-style pretty-printing combinators in Rust](https://github.com/Marwes/pretty.rs)

## [Serde](https://serde.rs/)
[GitHub](https://github.com/serde-rs/serde)
- [Internal buffering disrupts format-specific deserialization features - Issue #1183](https://github.com/serde-rs/serde/issues/1183)

[Enum representations](https://serde.rs/enum-representations.html):
- Unit variants → string enums
- Externally tagged
- Internally tagged
  - [Optional tag for internally tagged enum - Issue #2231](https://github.com/serde-rs/serde/issues/2231)
    - Untagged + Internally tagged
      
      [rust - How can I deserialize an enum with an optional internal tag? - Stack Overflow](https://stackoverflow.com/questions/61216723/how-can-i-deserialize-an-enum-with-an-optional-internal-tag)
    - ~~Internally tagged + untagged~~
- Adjacently tagged
- Untagged
  - [serde-untagged: Serde Visitor for deserializing untagged enums](https://github.com/dtolnay/serde-untagged)
  - [serde\_sated: serde-sated (sane adjacently tagged enum deserialization \[with untagged variant\])](https://github.com/muttleyxd/serde_sated)
  - [Better message when failing to match any variant of an untagged enum - Issue #2157](https://github.com/serde-rs/serde/issues/2157)
  - [Untagged enums with empty variants (de)serialize in unintuitive ways - Issue #1560](https://github.com/serde-rs/serde/issues/1560)
- [Serialize enum as number - Serde](https://serde.rs/enum-number.html)
- [serde\_literals: Add support for serialising and deserialising literals directly into enum unit variants.](https://github.com/andrewlowndes/serde_literals)
- [serde-versioning: A drop-in replacement for serde Deserialize with built-in versioning](https://github.com/vic1707/serde-versioning)
- `Result` is externally tagged
  ```rust
  let r: Result<(), Error> = Err(Error::Code(ErrorCode::Unknown));
  assert_eq!(serde_json::to_string(&r).unwrap(), r#"{"Err":{"Code":1}}"#);

  let r: Result<(), Error> = Ok(());
  assert_eq!(serde_json::to_string(&r).unwrap(), r#"{"Ok":null}"#);
  ```

  Untagged: `#[serde(untagged)]` must be added to the type to work, and attrs can only be added to own types.
  - New types
    - [either::serde\_untagged](https://docs.rs/either/latest/either/serde_untagged/index.html)
  - Don't use `#[serde(untagged)]`
    ```rust
    fn result_from_untagged<T, E>(s: &str) -> Result<Result<T, E>, serde_json::Error>
    where
        T: serde::de::DeserializeOwned,
        E: serde::de::DeserializeOwned,
    {
        match serde_json::from_str::<E>(s) {
            Ok(v) => Ok(v),
            Err(_) => return serde_json::from_str(s).map(Ok),
        }
        .map(Err)
    }
    ```
    
    <details>

    ```rust
    pub fn res_from_str<T>(s: &str) -> Result<Result<T, ResponseError>, serde_json::Error>
    where
        T: serde::de::DeserializeOwned,
    {
        match serde_json::from_str::<ResponseError>(s) {
            Ok(e) => Ok(e),
            Err(_) => return serde_json::from_str(s).map(Ok),
        }
        .map(Err)
    }
    ```
    ```rust
    pub fn res_from_str<T>(s: &str) -> Result<Result<T, Error>, serde_json::Error>
    where
        T: serde::de::DeserializeOwned,
    {
        match serde_json::from_str::<ResponseError>(s) {
            Ok(e) => Ok(e),
            Err(_) => return serde_json::from_str(s).map(Ok),
        }
        .map(Error::from)
        .map(Err)
    }
    ```
    ```rust
    pub fn res_from_str<T>(s: &str) -> Result<T, Error>
    where
        T: serde::de::DeserializeOwned,
    {
        match serde_json::from_str::<ResponseError>(s) {
            Ok(e) => Err(e.into()),
            Err(_) => Ok(serde_json::from_str(s)?),
        }
    }
    ```
    </details>

  [rust - How customize serialization of a result-type using serde? - Stack Overflow](https://stackoverflow.com/questions/76604700/how-customize-serialization-of-a-result-type-using-serde)

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