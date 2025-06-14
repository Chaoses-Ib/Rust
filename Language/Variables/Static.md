# Static Items
[The Rust Reference](https://doc.rust-lang.org/reference/items/static-items.html)

## Mutable statics
> If a static item is declared with the `mut` keyword, then it is allowed to be modified by the program. One of Rust's goals is to make concurrency bugs hard to run into, and this is obviously a very large source of race conditions or other bugs
> 
> For this reason, an `unsafe` block is required when either reading or writing a mutable static variable. Care should be taken to ensure that modifications to a mutable static are safe with respect to other threads running in the same process.

[What's the "correct" way of doing static mut in 2024 Rust? - embedded - The Rust Programming Language Forum](https://users.rust-lang.org/t/whats-the-correct-way-of-doing-static-mut-in-2024-rust/120403/17)
> The correct way to deal with `static mut` is to only work through raw pointers. This means you create a pointer via `&raw mut GLOBAL`, and then use pointer methods ([std::ptr - Rust](https://doc.rust-lang.org/std/ptr/index.html)) to work with it. So no `*ptr = val;`, instead use `ptr.write(val)`. Similarly, reads are done via `ptr.read()`. This way you never create any references, and thus not at risk of violating aliasing rules (although see [this](https://internals.rust-lang.org/t/aliasing-of-raw-pointers/21746) discussion).
> 
> `static GLOBAL: UnsafeCell<T>` is functionally the same. You just can't accidentally create a `&mut` to its contents via a method call. Surprisingly, `GLOBAL += 1` or `GLOBAL.add_assign(1)` don't trigger the `static_mut_refs` warning.

`unsafe { &*&raw const STATIC }` / `unsafe { &mut *&raw mut STATIC }`

> Mutable statics have the same restrictions as normal statics, except that the type does not have to implement the `Sync` trait.

[→Lazy initialization](../../Libraries/Paradigms/Object-oriented.md#lazy-evaluation)

## Generic statics
- [Different static variables for different instances of a generic function - Issue #2130 - rust-lang/rfcs](https://github.com/rust-lang/rfcs/issues/2130)

- Macros / duplicates
  
  Only static declarations only to be duplicated for each type.

  [Is there a more elegant way to write generic static variables in Rust? - Stack Overflow](https://stackoverflow.com/questions/75582901/is-there-a-more-elegant-way-to-write-generic-static-variables-in-rust)

- Type maps

  Type maps have a cost.

  - [generic\_singleton: A rust library crate for creating generic singletons](https://github.com/WalterSmuts/generic_singleton)
    - [Add crates.io and docs.rs badges to README by Chaoses-Ib - Pull Request #4](https://github.com/WalterSmuts/generic_singleton/pull/4)
  - [generic\_static](https://github.com/hukumka/generic_static)

- [Any way to create a generic static? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/any-way-to-create-a-generic-static/73556)
