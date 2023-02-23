# Smart Pointers
A **pointer** is a general concept for a variable that contains an address in memory. **Smart pointers**, on the other hand, are data structures that act like a pointer but also have additional metadata and capabilities.

- [std::boxed::Box](https://doc.rust-lang.org/std/boxed/)

## Deref coercion
**Deref coercion** converts a reference to a type that implements the `Deref` trait into a reference to another type. For example, deref coercion can convert `&String` to `&str` because `String` implements the `Deref` trait such that it returns `&str`.