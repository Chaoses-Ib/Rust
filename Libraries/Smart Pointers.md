# Smart Pointers
[The Rust Programming Language](https://doc.rust-lang.org/book/ch15-00-smart-pointers.html)

A **pointer** is a general concept for a variable that contains an address in memory. **Smart pointers**, on the other hand, are data structures that act like a pointer but also have additional metadata and capabilities.

- [std::boxed::Box](https://doc.rust-lang.org/std/boxed/)
  - `into_raw()`

    [Box: What is the difference between leak and into\_raw for raw pointers? : r/rust](https://www.reddit.com/r/rust/comments/12o02se/box_what_is_the_difference_between_leak_and_into/)

    [Can Box::leak be complemented with Box::into\_raw? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/can-box-leak-be-complemented-with-box-into-raw/82669)
  - `into_inner()` ([unstable](https://github.com/rust-lang/rust/issues/80437))
    - `*`

    [rust - How do I get an owned value out of a `Box`? - Stack Overflow](https://stackoverflow.com/questions/42264041/how-do-i-get-an-owned-value-out-of-a-box)

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

- Shallow clone

  [collections: Add `shallow_copy` method to Cow which always reborrows data by ipetkov - Pull Request #33777 - rust-lang/rust](https://github.com/rust-lang/rust/pull/33777)

  [Cow::clone should do shallow copies? - Issue #34284 - rust-lang/rust](https://github.com/rust-lang/rust/issues/34284)
  - [Cow is not Copy-On-Write - Issue #50160 - rust-lang/rust](https://github.com/rust-lang/rust/issues/50160)

  [Add `shallow_clone()` method to Cow which always reborrows data - Issue #283 - rust-lang/libs-team](https://github.com/rust-lang/libs-team/issues/283)
  - [Jens Getreu's blog - How to shallow clone a Cow](https://blog.getreu.net/20241005-how_to_shallow_clone_a_cow-blog/)

  ```rust
  pub fn shallow_clone(&'a self) -> Self {
      Self {
          data: Cow::Borrowed(self.data.as_ref()),
      }
  }
  ```
  - [PonasKovas/shallowclone](https://github.com/PonasKovas/shallowclone)

[beef: Faster, more compact implementation of std::borrow::Cow](https://github.com/maciejhirsz/beef)
- `beef::Cow` is 3 words wide: pointer, length, and capacity. It stores the ownership tag in capacity.
- `beef::lean::Cow` is 2 words wide, storing length, capacity, and the ownership tag all in one word.

[supercow - Rust](https://docs.rs/supercow/latest/supercow/)
