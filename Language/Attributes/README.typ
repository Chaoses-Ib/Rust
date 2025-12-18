#import "@local/ib:0.1.0": *
#title[Attributes]
#a-badge[https://doc.rust-lang.org/nightly/reference/attributes.html]

= Nop attribute
Applications:
- Avoid dozens of ```rs #[cfg_attr(...)]``` (by ```rs #[cfg(...)] use```)

  For example:
  ```rs
  #[cfg(any(test, not(feature = "wasm")))]
  pub use nop_macros::nop as wasm_func;
  #[cfg(all(not(test), feature = "wasm"))]
  pub use wasm_minimal_protocol::wasm_func;
  ```
- Metadata

Implementations:
- Built-in attributes
  - No input
    - Function: ```rs #[inline]```
    - Statics: ```rs #[used]```

  `error: cannot use a built-in attribute through an import`
  - #a[Built-in attributes are treated differently vs prelude attributes, unstable built-in attributes can name-collide with stable macro, and built-in attributes can break back-compat - Issue \#134963 - rust-lang/rust][https://github.com/rust-lang/rust/issues/134963]

- #a[Techcable/nop-macros: Procedural macros that do nothing, allowing attributes to be used as metadata.][https://github.com/Techcable/nop-macros.rust]
  ```rs
  #[proc_macro_attribute]
  pub fn nop(_attr: TokenStream, item: TokenStream) -> TokenStream {
      item
  }
  ```
