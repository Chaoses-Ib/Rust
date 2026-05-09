#import "@local/ib:0.1.0": *
#title[Bit Fields]
#a[Add bitfields support by Andy-Python-Programmer · Pull Request \#3113 · rust-lang/rfcs][https://github.com/rust-lang/rfcs/pull/3113]
- #a[Rust wanted features · Issue \#354 · Rust-for-Linux/linux][https://github.com/Rust-for-Linux/linux/issues/354]

#a[rust - How to implement bitwise operations on a bitflags enum? - Stack Overflow][https://stackoverflow.com/questions/43509560/how-to-implement-bitwise-operations-on-a-bitflags-enum]

= Libraries
- #a[bitflags: A macro to generate structures which behave like bitflags][https://github.com/bitflags/bitflags]

- #a[Enumflags: Rust library for typesystem-assisted bitflags.][https://github.com/meithecatte/enumflags2]

== Struct
- #a[Bitfield Struct: Procedural macro for bitfields.][https://github.com/wrenger/bitfield-struct-rs]
  #a-badge[https://crates.io/crates/bitfield-struct]

  ```rust
  /// Define your type like this with the bitfield attribute
  #[bitfield(u8)]
  struct MyByte {
      /// The first field occupies the least significant bits
      #[bits(4)]
      kind: usize,
      /// Booleans are 1 bit large
      system: bool,
      /// The bits attribute specifies the bit size of this field
      #[bits(2)]
      level: usize,
      /// The last field spans over the most significant bits
      present: bool
  }
  // The macro creates three accessor functions for each field:
  // <name>, with_<name> and set_<name>
  let my_byte = MyByte::new(]
      .with_kind(15]
      .with_system(false]
      .with_level(3]
      .with_present(true);

  assert!(my_byte.present());
  ```
  - #a[Public getter and private setter for one field - Issue \#25][https://github.com/wrenger/bitfield-struct-rs/issues/25]
  - #a[Converters instead of traits to support external types - Issue \#26][https://github.com/wrenger/bitfield-struct-rs/issues/26]
    - ```rs #[bits(3, from = option_enum_from_bits, into = option_enum_into_bits)]```

#strike[
- #a[gregorygaines/bitfields-rs: Rust macro for generating flexible bitfields, useful for low-level code (embedded or emulators).][https://github.com/gregorygaines/bitfields-rs]
  #a-badge[https://crates.io/crates/bitfields]
  #a-badge[https://www.reddit.com/r/rust/comments/1hfkohx/rust_macro_for_generating_flexible_bitfields/]
]

- #a[rust-bitfield: This crate provides macros to generate bitfield-like struct.][https://github.com/dzamlo/rust-bitfield]
  - Used by `pdb-rs`

  ```rust
  bitfield!{
      struct IpV4Header(MSB0 [u8]);
      u32;
      get_version, _: 3, 0;
      get_ihl, _: 7, 4;
      get_dscp, _: 13, 8;
      get_ecn, _: 15, 14;
      get_total_length, _: 31, 16;
      get_identification, _: 47, 31;
      get_df, _: 49;
      get_mf, _: 50;
      get_fragment_offset, _: 63, 51;
      get_time_to_live, _: 71, 64;
      get_protocol, _: 79, 72;
      get_header_checksum, _: 95, 79;
      get_source_address, _: 127, 96;
      get_destination_address, _: 159, 128;
  }
  ```

- `bindgen`: #a[Using Bitfields - The bindgen User Guide][https://rust-lang.github.io/rust-bindgen/using-bitfields.html]

== Generic integers
#footnote[#a[Generic Integers V2: It's Time by clarfonthey - Pull Request \#3686 - rust-lang/rfcs][https://github.com/rust-lang/rfcs/pull/3686]]

Especially suitable for integral fields, but kinda verbose for others.

- #a[bilge: Use bitsized types as if they were a feature of rust.][https://github.com/hecatia-elegua/bilge]
  #a-badge[https://docs.rs/bilge/]
  (inactive)
  - Based on #a[`arbitrary-int`][https://github.com/danlehmann/arbitrary-int].
    - Must be like ```rs u42::from_u64(d)``` instead of ```rs (d as u64).into()```.
    - #a[make setters work with basic types - Issue \#75][https://github.com/hecatia-elegua/bilge/issues/75]
  - No builders, but can be used with other builder libraries, like `bon`.
  - #a[comparison with bitfield-struct-rs? - Issue \#98][https://github.com/hecatia-elegua/bilge/issues/98]
  - #a[Provide a big endian example - Issue \#7][https://github.com/hecatia-elegua/bilge/issues/7]

- #a[modular-bitfield: Macro to generate bitfields for structs that allow for modular use of enums.][https://github.com/modular-bitfield/modular-bitfield]
  #a-badge[https://crates.io/crates/modular-bitfield]

- #a[bitfield: Rust crate for bitfields and bit-enums][https://github.com/danlehmann/bitfield]

== Atomic
- #a[`atomic_bitfield`: Bitfield abstraction for Rust's core atomic types][https://github.com/amiraeva/atomic_bitfield]

== Dynamic
- #a[sharksforarms/deku: Declarative binary reading and writing: bit-level, symmetric, serialization/deserialization][https://github.com/sharksforarms/deku]
  #a-badge[https://docs.rs/deku/latest/deku/#reducing-parser-code-size]
  #a-badge[https://crates.io/crates/deku]
  - A lot of stars but only few downloads?
