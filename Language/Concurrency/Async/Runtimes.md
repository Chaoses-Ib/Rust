# Async Runtimes
## [Tokio](https://tokio.rs/)
[GitHub](https://github.com/tokio-rs/tokio), [Docs.rs](https://docs.rs/tokio/latest/tokio/)

> A runtime for writing reliable asynchronous applications with Rust. Provides I/O, networking, scheduling, timers, ...

- `spawn()` for non-blocking (<10~100μs), `spawn_blocking()`/`block_in_place()` for blocking, perfer one big `spawn_blocking()`.
  - Not every `async` function is equal, some will hang you.

- [Multi-threaded runtime](https://docs.rs/tokio/latest/tokio/runtime/index.html#multi-threaded-runtime-behavior-at-the-time-of-writing)

  > A multi thread runtime has a fixed number of worker threads, which are all created on startup. The multi thread runtime maintains one global queue, and a local queue for each worker thread. The local queue of a worker thread can fit at most 256 tasks. If more than 256 tasks are added to the local queue, then half of them are moved to the global queue to make space.
  > 
  > If both the local queue and global queue is empty, then the worker thread will attempt to steal tasks from the local queue of another worker thread. Stealing is done by moving half of the tasks in one local queue to another local queue.

  - Even multi-threaded runtime may entirely block if one worker thread blocks (on IO).
    - Use [`tokio::task::block_in_place()`](https://docs.rs/tokio/latest/tokio/task/index.html#block_in_place) (which `spawn_blocking()` internally)
    - Using `spawn_blocking()` is more efficient, but it requires `'static`
    - tokio-console
    - [tokio-blocked: Detect blocking code in Tokio async tasks. (Rust)](https://github.com/theduke/tokio-blocked)

    [One bad task can halt all executor progress forever - Issue #4730](https://github.com/tokio-rs/tokio/issues/4730)
    - [rt: make the LIFO slot in the multi-threaded scheduler stealable - Issue #4941](https://github.com/tokio-rs/tokio/issues/4941)
    - [rt: Tolerate slow task polls - Issue #6315](https://github.com/tokio-rs/tokio/issues/6315)

    > This is a pretty ugly performance wart. Our team has independently hit this issue twice, where some singular task takes longer than the developer expects and this results in 100ms+ of latency for API requests that we otherwise expect to complete very quickly.  
    > The fact that one pathological task is able to harm a bunch of otherwise good API requests is alarming behavior.

    > Yes, 20ms is definitely too long. In [my article on blocking](https://ryhl.io/blog/async-what-is-blocking/), I recommend 10μs to 100μs as an upper limit.
    > 
    > A silver lining of the above is that the issue can only really happen when all threads are idle and a single incoming IO event arrives, so it will not happen while the runtime is under load.

  - Blocking [`thread_keep_alive()`](https://docs.rs/tokio/latest/tokio/runtime/struct.Builder.html#method.thread_keep_alive) defaults to 10s

  [Unexpected behavior of tokio multithreaded runtime with a single worker thread - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/unexpected-behavior-of-tokio-multithreaded-runtime-with-a-single-worker-thread/123827)

- `spawn()` and `spawn_blocking()` requires `'static` as the caller may be cancalled
  - [`tokio::task::block_in_place()`](https://docs.rs/tokio/latest/tokio/task/index.html#block_in_place)

  [rust - Why does `tokio::spawn` requires a `'static` lifetime if I immediately await it? - Stack Overflow](https://stackoverflow.com/questions/74865493/why-does-tokiospawn-requires-a-static-lifetime-if-i-immediately-await-it)

  [Working around the `'static` requirement in `tokio::task::spawn_blocking` - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/working-around-the-static-requirement-in-tokio-spawn-blocking/89831)

  [rust - How to choose between `block_in_place` and `spawn_blocking`? - Stack Overflow](https://stackoverflow.com/questions/70986783/how-to-choose-between-block-in-place-and-spawn-blocking)

- `spawn_blocking()` is for sync functions, what about functions mixed with sync and async?
  - `spawn_blocking()` + `block_on()`

    > This runs the given future on the current thread, blocking until it is complete, and yielding its resolved result. Any tasks or timers which the future spawns internally will be executed on the runtime.
  - MT: `tokio::task::block_in_place()`
  - [`async_bridge`: A bridge between synchronous and async code for mixed sync/async programming](https://github.com/cvkem/async_bridge)
  - [rust - When should you use Tokio's `spawn_blocking`? - Stack Overflow](https://stackoverflow.com/questions/74547541/when-should-you-use-tokios-spawn-blocking)

- [Is it okay to start multiple tokio runtimes for different parts of the app? - The Rust Programming Language Forum](https://users.rust-lang.org/t/is-it-okay-to-start-multiple-tokio-runtimes-for-different-parts-of-the-app/39974)
  - Pro: Avoid starvation
  - Con: More overhead

- IO
  - Only really async for networks, sync (`spawn_blocking()`) for files and pipes
    - May create unnecessary multiple/nested `spawn_blocking()`
    - Inefficient for many small reads/writes (stream as fast as possible)
    - Consider using one big `spawn_blocking()` instead

    [Why tokio uses blocking file io under the hood? - Issue #2926](https://github.com/tokio-rs/tokio/issues/2926)

    [Does Tokio on Linux use blocking IO or not? : r/rust](https://www.reddit.com/r/rust/comments/1kaxyq3/does_tokio_on_linux_use_blocking_io_or_not/)
    > On every platform, tokio uses mio for network I/O, which indeed is “truly” asynchronous. For file-based I/O, tokio just executes synchronous calls in a dedicated thread-pool, so they are not asynchronous from the point of view of the system: https://github.com/tokio-rs/tokio/blob/master/tokio/src/fs/read.rs

- [tokio-console: a debugger for async rust!](https://github.com/tokio-rs/console)
