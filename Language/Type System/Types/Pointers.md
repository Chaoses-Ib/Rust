# Pointer Types
[The Rust Reference](https://doc.rust-lang.org/reference/types/pointer.html)

## Deref coercion
[The Rust Programming Language](https://doc.rust-lang.org/book/ch15-02-deref.html)

**Deref coercion** converts a reference to a type that implements the `Deref` trait into a reference to another type. For example, deref coercion can convert `&String` to `&str` because `String` implements the `Deref` trait such that it returns `&str`.

- [Borrow in std::borrow - Rust](https://doc.rust-lang.org/std/borrow/trait.Borrow.html)
- [AsRef in std::convert - Rust](https://doc.rust-lang.org/std/convert/trait.AsRef.html)

[Borrow and AsRef - The Rust Programming Language v1](https://web.mit.edu/rust-lang_v1.25/arch/amd64_ubuntu1404/share/doc/rust/html/book/first-edition/borrow-and-asref.html)

[Difference among Deref, Borrow, and AsRef : rust (reddit.com)](https://www.reddit.com/r/rust/comments/ex50zg/difference_among_deref_borrow_and_asref/):
> `Deref` is the mechanism for the dereferencing operator and coercions.
> 
> `Borrow` has its own distinct purpose: it allows types representing different ownership forms of an underlying data type to work interchangeably, in contexts like collection lookups. Complemented with the `ToOwned` trait, it is also used in the generic implementation of `Cow`. It would be great if it also worked with operators, but this is not possible without [some work on the language](https://github.com/rust-lang/rfcs/pull/2578).
> 
> `AsRef` is a trait for explicit conversions with the semantics of a by-reference conversion at a negligible runtime cost.

## [→Smart pointers](../../../Libraries/Smart%20Pointers.md)