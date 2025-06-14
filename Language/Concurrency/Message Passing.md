# Message Passing
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-02-message-passing.html)

A **channel** is a general programming concept by which data is sent from one thread to another.

```rust
// multiple producer, single consumer
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let val = String::from("hello");
        tx.send(val).unwrap();
        let val = String::from("world");
        tx.send(val).unwrap();
    });

    let received = rx.recv().unwrap();
    println!("Got: {}", received);

    for received in rx {
        println!("Got: {}", received);
    }
}
```

A channel is said to be _closed_ if either the transmitter or receiver half is dropped. When the channel is closed, iteration with the receiver will end.

Libraries:
- `std::sync`
  - [channel in std::sync::mpsc - Rust](https://doc.rust-lang.org/std/sync/mpsc/fn.channel.html)
  - [sync\_channel in std::sync::mpsc - Rust](https://doc.rust-lang.org/std/sync/mpsc/fn.sync_channel.html)
- [futures\_channel - Rust](https://docs.rs/futures-channel/latest/futures_channel/)
  - No doc examples
  - `rx.next().await`
  - [api: consider changing `mpsc::Receiver::try_next` for future\_channels v0.4. - Issue #2936 - rust-lang/futures-rs](https://github.com/rust-lang/futures-rs/issues/2936)
    - [channel: Add recv by cmrschwarz - Pull Request #2947 - rust-lang/futures-rs](https://github.com/rust-lang/futures-rs/pull/2947)
- [`crossbeam-channel`](https://docs.rs/crossbeam-channel/latest/crossbeam_channel/)
- [Flume: A safe and fast multi-producer, multi-consumer channel.](https://github.com/zesterer/flume)
- [Kanal: The fast sync and async channel that Rust deserves](https://github.com/fereidani/kanal)
- [bus: Efficient, lock-free, bounded Rust broadcast channel](https://github.com/jonhoo/bus)

[Is there an easy way to have a channel that sends in blocking mode, receives in async mode? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/is-there-an-easy-way-to-have-a-channel-that-sends-in-blocking-mode-receives-in-async-mode/117183/14)

## Oneshot channels
- `std::sync::mpsc::sync_channel(1)`
- `Arc<OnceLock<T>>`
  - Sync
  - Can only get `&T`

    [rust - How can I determine if I have a unique Arc when it's dropped? - Stack Overflow](https://stackoverflow.com/questions/64816028/how-can-i-determine-if-i-have-a-unique-arc-when-its-dropped)
- `futures_channel::oneshot`
  - Async recv
- [faern/oneshot: Oneshot Rust channel working both in and between sync and async environments](https://github.com/faern/oneshot)

[Semantic one-shot channel - Issue #985 - crossbeam-rs/crossbeam](https://github.com/crossbeam-rs/crossbeam/issues/985)

[Optimize the oneshot case - Issue #199 - crossbeam-rs/crossbeam](https://github.com/crossbeam-rs/crossbeam/issues/199)

## Interruptible blocking
[`std::sync::mpsc::Receiver::recv_timeout()`](https://doc.rust-lang.org/stable/std/sync/mpsc/struct.Receiver.html#method.recv_timeout)

Async/await:
- `tokio::select!`

- `tokio::sync::oneshot`

  ```rust
  tokio::time::timeout(std::time::Duration::from_secs(1), oneshot_rx).await;
  ```
  Can only recv once.

- Cancellation tokens

  [`tokio_util::sync::CancellationToken`](https://docs.rs/tokio-util/latest/tokio_util/sync/struct.CancellationToken.html)

[Graceful Shutdown | Tokio - An asynchronous Rust runtime](https://tokio.rs/tokio/topics/shutdown)

[Is there a rust feature for async analogous to the `recv_timeout` function? - Stack Overflow](https://stackoverflow.com/questions/68279793/is-there-a-rust-feature-for-async-analogous-to-the-recv-timeout-function)