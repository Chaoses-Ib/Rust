# Type Layout
[The Rust Reference](https://doc.rust-lang.org/reference/type-layout.html)

## [Representations](https://doc.rust-lang.org/reference/type-layout.html#representations)
All user-defined composite types (`struct`s, `enum`s, and `union`s) have a **representation** that specifies what the layout is for the type. The possible representations for a type are:
- [Default](https://doc.rust-lang.org/reference/type-layout.html#the-default-representation)
- [`C`](https://doc.rust-lang.org/reference/type-layout.html#the-c-representation)
- The [primitive representations](https://doc.rust-lang.org/reference/type-layout.html#primitive-representations)
- [`transparent`](https://doc.rust-lang.org/reference/type-layout.html#the-transparent-representation)

[Other reprs - The Rustonomicon](https://doc.rust-lang.org/beta/nomicon/other-reprs.html)

## Memory alignment
The alignment may be raised or lowered with the `align` and `packed` modifiers respectively.

Dereferencing an unaligned pointer is undefined behavior:
- May panic in debug.

  ```rust
  pub fn main() {
      let p: *const u32 = unsafe { std::mem::transmute(3u64) };
      let a: &u32 = unsafe { &*p };
      println!("{}", a);
  }
  
  // thread 'main' panicked at /app/example.rs:3:28:
  // misaligned pointer dereference: address must be a multiple of 0x4 but is 0x3
  // note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
  // thread caused non-unwinding panic. aborting.
  // Program terminated with signal: SIGSEGV
  ```

  One can use `std::mem::transmute` to bypass this check. For example:
  ```rust
  #[cfg(debug_assertions)]
  let a: &u32 = unsafe { std::mem::transmute(p) };
  #[cfg(not(debug_assertions))]
  let a: &u32 = unsafe { &*p };
  ```

Operations that works with unaligned pointers:
- [std::ptr::addr\_of](https://doc.rust-lang.org/stable/std/ptr/macro.addr_of.html)
- [std::ptr::read\_unaligned](https://doc.rust-lang.org/stable/std/ptr/fn.read_unaligned.html), [str::ptr::write\_unaligned](https://doc.rust-lang.org/stable/std/ptr/fn.write_unaligned.html)
  - [1725-unaligned-access - The Rust RFC Book](https://rust-lang.github.io/rfcs/1725-unaligned-access.html)

[aligned\_ptr: A Rust library that ensures a pointer is aligned correctly for dereferencing](https://github.com/toku-sa-n/aligned_ptr)