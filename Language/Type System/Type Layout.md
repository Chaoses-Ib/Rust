# Type Layout
[The Rust Reference](https://doc.rust-lang.org/reference/type-layout.html)

## [Representations](https://doc.rust-lang.org/reference/type-layout.html#representations)
All user-defined composite types (`struct`s, `enum`s, and `union`s) have a **representation** that specifies what the layout is for the type. The possible representations for a type are:
- [Default](https://doc.rust-lang.org/reference/type-layout.html#the-default-representation)
- [`C`](https://doc.rust-lang.org/reference/type-layout.html#the-c-representation)
- The [primitive representations](https://doc.rust-lang.org/reference/type-layout.html#primitive-representations)
- [`transparent`](https://doc.rust-lang.org/reference/type-layout.html#the-transparent-representation)

The alignment may be raised or lowered with the `align` and `packed` modifiers respectively.