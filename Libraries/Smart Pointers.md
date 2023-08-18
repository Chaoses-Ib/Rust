# Smart Pointers
[The Rust Programming Language](https://doc.rust-lang.org/book/ch15-00-smart-pointers.html)

A **pointer** is a general concept for a variable that contains an address in memory. **Smart pointers**, on the other hand, are data structures that act like a pointer but also have additional metadata and capabilities.

- [std::boxed::Box](https://doc.rust-lang.org/std/boxed/)

  [The Rust Programming Language](https://doc.rust-lang.org/book/ch15-01-box.html)

- [std::rc](https://doc.rust-lang.org/std/rc/index.html)

  [The Rust Programming Language](https://doc.rust-lang.org/book/ch15-04-rc.html)

  [Reference Cycles Can Leak Memory - The Rust Programming Language](https://doc.rust-lang.org/book/ch15-06-reference-cycles.html)

[Confused between Box, Rc, Cell, Arc - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/confused-between-box-rc-cell-arc/10946)

## Clone-on-write
[Cow in std::borrow - Rust](https://doc.rust-lang.org/std/borrow/enum.Cow.html)

[Optimizations That Aren't, Or Are They?](https://oribenshir.github.io/afternoon_rusting/blog/copy-on-write)

[ownership - Is it possible to return either a borrowed or owned type in Rust? - Stack Overflow](https://stackoverflow.com/questions/36706429/is-it-possible-to-return-either-a-borrowed-or-owned-type-in-rust)

[ToOwned in std::borrow - Rust](https://doc.rust-lang.org/std/borrow/trait.ToOwned.html)

[beef: Faster, more compact implementation of std::borrow::Cow](https://github.com/maciejhirsz/beef)
- `beef::Cow` is 3 words wide: pointer, length, and capacity. It stores the ownership tag in capacity.
- `beef::lean::Cow` is 2 words wide, storing length, capacity, and the ownership tag all in one word.