# Comments
[The Rust Reference](https://doc.rust-lang.org/reference/comments.html)

## Documentation
[The rustdoc book](https://doc.rust-lang.org/rustdoc/what-is-rustdoc.html)

[The `#[doc]` attribute - The rustdoc book](https://doc.rust-lang.org/rustdoc/write-documentation/the-doc-attribute.html)
- [`alias`](https://doc.rust-lang.org/rustdoc/write-documentation/the-doc-attribute.html#alias)

`//!` cannot be used on struct fields and enum variants.

[Can I document a struct in a comment block? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/can-i-document-a-struct-in-a-comment-block/96515)

[Documenting a struct and its fields in the same comment - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/documenting-a-struct-and-its-fields-in-the-same-comment/116529)

[rustdoc support for per-parameter documentation - Issue #57525 - rust-lang/rust](https://github.com/rust-lang/rust/issues/57525)

### [Reflection](Type%20System/Reflection.md)
- bevy-reflect
  ```rust
  #[derive(bevy_reflect::Reflect)]
  pub enum MyEnum {
      /// Desc 1
      A = 1,
      /// Desc 2
      B = 2,
  }

  use bevy_reflect::Typed;

  let docs = match MyEnum::type_info() {
      bevy_reflect::TypeInfo::Enum(enum_info) => enum_info
          .iter()
          .map(|v| v.docs().unwrap().to_string())
          .collect(),
      _ => todo!(),
  };
  ```

- struct-metadata
  ```rust
  #[derive(struct_metadata::Described)]
  pub enum MyEnum {
      /// Desc 1
      A = 1,
      /// Desc 2
      B = 2,
  }

  use struct_metadata::Described;

  let docs = match MyEnum::metadata().kind {
      struct_metadata::Kind::Enum { name, variants } => variants
          .into_iter()
          .map(|v| v.docs.unwrap().join(""))
          .collect(),
      _ => todo!(),
  };
  ```