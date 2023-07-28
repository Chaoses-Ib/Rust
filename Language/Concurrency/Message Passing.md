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
