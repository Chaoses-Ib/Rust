# Generators
- [generators - The Rust Unstable Book](https://doc.rust-lang.org/beta/unstable-book/language-features/generators.html)

  [RFC 2033](https://github.com/rust-lang/rfcs/blob/master/text/2033-experimental-coroutines.md)
  - [Tracking issue for RFC 2033: Experimentally add coroutines to Rust · Issue #43122 · rust-lang/rust](https://github.com/rust-lang/rust/issues/43122)

  ```rust
  use std::{ops::{Generator, GeneratorState}, pin::Pin};

  fn generator(s: &str) -> impl Generator<Yield = &str, Return = i32> {
      move || {
          yield s;
          0
      }
  }

  fn test() {
      let mut gen = generator("hello");
      assert_eq!(Pin::new(&mut gen).resume(()), GeneratorState::Yielded("hello"));
      assert_eq!(Pin::new(&mut gen).resume(()), GeneratorState::Complete(0));
  }
  ```

  - [propane: generators](https://github.com/withoutboats/propane)

    相比直接使用 `Generator` 有更加严格的限制，在存在复杂 borrowing 时不推荐使用。

  - [Error E0626](https://doc.rust-lang.org/error_codes/E0626.html): borrow may still be in use when generator yields.

    At present, it is not permitted to have a yield that occurs while a borrow is still in scope. To resolve this error, the borrow must either be "contained" to a smaller scope that does not overlap the yield or else eliminated in another way.

  - Error E0391: cycle detected when computing type of `...`.

    ```rust
    fn generator(s: &str) -> Pin<Box<dyn Generator<Yield = &str, Return = i32> + 'a>> {
      Box::pin(move || {
        // ...
      })
    }
    ```
    [asynchronous - Recursive async functions calling each other: cycle detected - Stack Overflow](https://stackoverflow.com/questions/74737595/recursive-async-functions-calling-each-other-cycle-detected)

- [genawaiter: Stackless generators on stable Rust.](https://github.com/whatisaphone/genawaiter)

  [Do not wait for Rust generators | Medium](https://david-delassus.medium.com/do-not-wait-for-rust-generators-9e7753465f59)
- [::next-gen: Safe generators on stable Rust.](https://github.com/danielhenrymantilla/next-gen-rs)

Stackful:
- [Generator-rs: rust stackful generator library](https://github.com/Xudong-Huang/generator-rs)

[Rust generator benchmark: Benchmarking different Rust generator libraries in a real world use case.](https://github.com/Tuupertunut/rust-generator-benchmark)