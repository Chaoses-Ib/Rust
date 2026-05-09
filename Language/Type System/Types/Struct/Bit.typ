#import "@local/ib:0.1.0": *
#title[Bit Fields]
#a[rust - How to implement bitwise operations on a bitflags enum? - Stack Overflow][https://stackoverflow.com/questions/43509560/how-to-implement-bitwise-operations-on-a-bitflags-enum]

= Libraries
- #a[bitflags: A macro to generate structures which behave like bitflags][https://github.com/bitflags/bitflags]

- #a[Enumflags: Rust library for typesystem-assisted bitflags.][https://github.com/meithecatte/enumflags2]

- #a[Bitfield Struct: Procedural macro for bitfields.][https://github.com/wrenger/bitfield-struct-rs]

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

- #a[rust-bitfield: This crate provides macros to generate bitfield-like struct.][https://github.com/dzamlo/rust-bitfield]

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

- #a[`atomic_bitfield`: Bitfield abstraction for Rust's core atomic types][https://github.com/amiraeva/atomic_bitfield]
