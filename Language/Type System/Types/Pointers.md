# Pointer Types
[The Rust Reference](https://doc.rust-lang.org/reference/types/pointer.html)

[Warn that `*const T as *mut T` is Undefined Behavior - Issue #66136 - rust-lang/rust](https://github.com/rust-lang/rust/issues/66136)
- Use `UnsafeCell` instead. See [interior mutability](../../Variables/README.md#interior-mutability) for details.

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

> An important difference between `Deref` and the others is that `Deref` can only be implemented once for a given type, while `Borrow` and `AsRef` can have multiple impls.

> `AsRef` has the same signature as `Borrow`, but `Borrow` is different in few aspects:
> - Unlike `AsRef`, `Borrow` has a blanket impl for any `T`, and can be used to accept either a reference or a value.
> - `Borrow` also requires that `Hash`, `Eq` and `Ord` for borrowed value are equivalent to those of the owned value. For this reason, if you want to borrow only a single field of a struct you can implement `AsRef`, but not `Borrow`.

> `Deref` is different from the other two: one type can only be derefed to one target type, and `*d` always has the same type.
> 
> `Borrow` and `AsRef` both give a reference to the underlying data, but `Borrow` requires that the original type and the borrowed type have the same behavior, while `AsRef` does not have the same requirement.
>
> For example `String` and `str` behave the same; `String` only has some extra features but otherwise is not different, and has the same order when sorted for example. Therefore `impl Borrow<str> for String` makes sense. However, if you have a wrapper type to reverse the sorting order (see `ReversedOrderString` below), you must *not* implement `Borrow<str> for ReversedOrderString`.

## [→Smart pointers](../../../Libraries/Smart%20Pointers.md)

## Metadata
[Rust Pointer Metadata](https://bd103.github.io/blog/2023-08-06-ptr-metadata)

## Tagged pointers
- [ointers: What do you call a pointer we stole the high bits off? An ointer.](https://github.com/irrustible/ointers)

See also [pointer enums](Enumerations.md#pointer-enums).