# Coroutines
Coroutines (formerly generators)

- [coroutines - The Rust Unstable Book](https://doc.rust-lang.org/beta/unstable-book/language-features/coroutines.html)

  [RFC 2033](https://github.com/rust-lang/rfcs/blob/master/text/2033-experimental-coroutines.md)
  - [Tracking issue for RFC 2033: Experimentally add coroutines to Rust · Issue #43122 · rust-lang/rust](https://github.com/rust-lang/rust/issues/43122)

  ```rust
  use std::{ops::{Coroutine, CoroutineState}, pin::Pin};

  fn generator(s: &str) -> impl Coroutine<Yield = &str, Return = i32> {
      #[coroutine] move || {
          yield s;
          0
      }
  }

  fn test() {
      let mut gen = generator("hello");
      assert_eq!(Pin::new(&mut gen).resume(()), CoroutineState::Yielded("hello"));
      assert_eq!(Pin::new(&mut gen).resume(()), CoroutineState::Complete(0));
  }
  ```

  - [propane: generators](https://github.com/withoutboats/propane)

    相比直接使用 `Coroutine` 有更加严格的限制，在存在复杂 borrowing 时不推荐使用。

  - [Error E0626](https://doc.rust-lang.org/error_codes/E0626.html): borrow may still be in use when coroutine yields.

    At present, it is not permitted to have a yield that occurs while a borrow is still in scope. To resolve this error, the borrow must either be "contained" to a smaller scope that does not overlap the yield or else eliminated in another way.

    - `xxx` → `into_xxx`

  - Error E0391: cycle detected when computing type of `...`.

    ```rust
    fn generator(s: &str) -> Pin<Box<dyn Coroutine<Yield = &str, Return = i32> + 'a>> {
      Box::pin(move || {
        // ...
      })
    }
    ```
    [asynchronous - Recursive async functions calling each other: cycle detected - Stack Overflow](https://stackoverflow.com/questions/74737595/recursive-async-functions-calling-each-other-cycle-detected)

  - Coroutines cannot be parallelized. Though one can wrap a coroutine to an iterator and use Rayon's [`ParallelBridge`](https://docs.rs/rayon/latest/rayon/iter/trait.ParallelBridge.html) to parallelize the consuming part.

- [3513-gen-blocks - The Rust RFC Book](https://rust-lang.github.io/rfcs/3513-gen-blocks.html)
  
  > We could support using `await` in `gen async` blocks in a similar way to how we support `?` being used within `gen` blocks. Without a solution for self-referential generators, we'd have the limitation that these blocks could not hold references across `await` points.

  [Tracking Issue for `gen` blocks and functions - Issue #117078 - rust-lang/rust](https://github.com/rust-lang/rust/issues/117078)

- [genawaiter: Stackless generators on stable Rust.](https://github.com/whatisaphone/genawaiter)

  [Do not wait for Rust generators | Medium](https://david-delassus.medium.com/do-not-wait-for-rust-generators-9e7753465f59)
- [::next-gen: Safe generators on stable Rust.](https://github.com/danielhenrymantilla/next-gen-rs)

Stackful:
- [Generator-rs: rust stackful generator library](https://github.com/Xudong-Huang/generator-rs)

[Rust generator benchmark: Benchmarking different Rust generator libraries in a real world use case.](https://github.com/Tuupertunut/rust-generator-benchmark)

## Async
- [`std::async_iter`](https://doc.rust-lang.org/nightly/std/async_iter/index.html)

  [Tracking Issue for `#![feature(async_iterator)]` - Issue #79024 - rust-lang/rust](https://github.com/rust-lang/rust/issues/79024)

- `async gen`

  [Introduce support for `async gen` blocks by compiler-errors - Pull Request #118420 - rust-lang/rust](https://github.com/rust-lang/rust/pull/118420#event-11197765508)
  - [async generators on nightly Rust : r/rust](https://www.reddit.com/r/rust/comments/18e0grb/async_generators_on_nightly_rust/)

  Bridge to [`futures_core::stream::Stream`](https://docs.rs/futures-core/latest/futures_core/stream/trait.Stream.html)?

- [futures-async-stream: Async stream for Rust and the futures crate.](https://github.com/taiki-e/futures-async-stream)
  - [Procedural macros provided by futures-async-stream cannot handle expressions in macros - Issue #4](https://github.com/taiki-e/futures-async-stream/issues/4)

  [coroutines-stream/simple.rs](coroutines-stream/src/bin/simple.rs)

- [tokio-rs/async-stream: Asynchronous streams for Rust using async & await notation](https://github.com/tokio-rs/async-stream)

  [coroutines-stream/progress.rs](coroutines-stream/src/bin/progress.rs)

- [async-gen: Async generator in stable rust using async/await](https://github.com/nurmohammed840/async-gen)

  > It is similar to [async-stream](https://docs.rs/async-stream/latest/async_stream/), But closely mimics the [Coroutine API](https://doc.rust-lang.org/std/ops/trait.Coroutine.html), Allowing the generator also return a value upon completion, in addition to yielding intermediate values.
- [stream\_generator: Allows to easily generate streams with async/await.](https://github.com/Riateche/stream_generator)

  [Announcing stream\_generator (creates a stream from an async generator function) - announcements - The Rust Programming Language Forum](https://users.rust-lang.org/t/announcing-stream-generator-creates-a-stream-from-an-async-generator-function/50655)
- [gen-stream: impl Stream for (your own) Generator](https://github.com/vorot93/gen-stream)
