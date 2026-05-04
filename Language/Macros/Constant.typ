#import "/lib.typ": *
#title[Constant Generation]
- #a[databake][https://github.com/unicode-org/icu4x/tree/main/utils/databake]
  #a-badge[https://docs.rs/databake/]
  - Based on `quote`.
  - #a[`borrows_size()`][https://docs.rs/databake/latest/databake/trait.BakeSize.html]
  - Some types are not `const`.
  - No transcode support.
  - An example that deserializes config from env at compile time and then generates constants:
    #a[databake][./databake]

- #a[const-gen: A crate for generating (relatively) complex compile-time constants in rust][https://github.com/Eolu/const-gen]
  #a-badge[https://crates.io/crates/const-gen]
  #a-badge[https://www.reddit.com/r/rust/comments/n1z0qy/constgen_a_crate_for_generating_compiletime/]

- JSON
  #footnote[#a[Generate const struct from json file - help - The Rust Programming Language Forum][https://users.rust-lang.org/t/generate-const-struct-from-json-file/126694]]
  #footnote[#a[rust - Deserialize file using serde_json at compile time - Stack Overflow][https://stackoverflow.com/questions/58359340/deserialize-file-using-serde-json-at-compile-time]]
  - #a[uneval: Uneval your data into Rust code][https://github.com/Cerber-Ursi/uneval]
    (discontinued)
    - #q[using uneval to try to build a slice results in a `vec!`, and also `from_tuple` is not const fn
      this means that it will be completely impossible to use the generated code as a constant initializer, which is needed if you want to have zero runtime overhead.]
  - #a[WKHAllen/schema-struct: Generate Rust struct definitions from JSON schemas at compile-time.][https://github.com/WKHAllen/schema-struct]
  - #a[abdullah-albanna/schema2struct: Convert a JSON schema into Rust structs for efficient and type-safe data management.][https://github.com/abdullah-albanna/schema2struct]
  - #a[abdullah-albanna/json_to_struct: Convert JSON into Rust structs for efficient and type-safe data management.][https://github.com/abdullah-albanna/json_to_struct]
    #a-badge[https://docs.rs/json_to_struct/]

- #a[vitiral/build_const: library for creating importable constants from build.rs or a script][https://github.com/vitiral/build_const]
  #a-badge[https://docs.rs/build_const/latest/build_const/]
  (discontinued)

#a[Generating static arrays during compile time in Rust - DEV Community][https://dev.to/rustyoctopus/generating-static-arrays-during-compile-time-in-rust-10d8]

#footnote[#a[rust - Generating constants at compile time from file content - Stack Overflow][https://stackoverflow.com/questions/66340266/generating-constants-at-compile-time-from-file-content]]
#footnote[#a[(How) can I define a const in cargo and use it in Rust as a const later - help - The Rust Programming Language Forum][https://users.rust-lang.org/t/how-can-i-define-a-const-in-cargo-and-use-it-in-rust-as-a-const-later/66566]]
