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
- [Flume: A safe and fast multi-producer, multi-consumer channel.](https://github.com/zesterer/flume)
- [Kanal: The fast sync and async channel that Rust deserves](https://github.com/fereidani/kanal)
- [bus: Efficient, lock-free, bounded Rust broadcast channel](https://github.com/jonhoo/bus)

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