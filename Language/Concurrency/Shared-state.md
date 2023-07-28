
# Shared-state Concurrency
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-03-shared-state.html)

## Atomic types
[std::sync::atomic](https://doc.rust-lang.org/std/sync/atomic/index.html)

## Synchronization primitives
- [parking_lot: Compact and efficient synchronization primitives for Rust. Also provides an API for creating custom synchronization primitives.](https://github.com/amanieu/parking_lot)
- [Crossbeam: Tools for concurrent programming in Rust](https://github.com/crossbeam-rs/crossbeam)
- [spin-rs: Spin-based synchronization primitives](https://github.com/mvdnes/spin-rs)

### Mutexes
_Mutex_ is an abbreviation for _mutual exclusion_, as in, a mutex allows only one thread to access some data at any given time.

[std::sync::Mutex\<T\>](https://doc.rust-lang.org/std/sync/struct.Mutex.html)

```rust
use std::sync::Mutex;

fn main() {
    let m = Mutex::new(5);

    {
        let mut num = m.lock().unwrap();
        *num = 6;
    }

    println!("m = {:?}", m);
}
```

The call to `lock` _returns_ a smart pointer called `MutexGuard`, wrapped in a `LockResult` that we handled with the call to `unwrap`. The `MutexGuard` smart pointer implements `Deref` to point at our inner data; the smart pointer also has a `Drop` implementation that releases the lock automatically when a `MutexGuard` goes out of scope, which happens at the end of the inner scope.

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();

            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

## Data structures
See [Data Structures](../../Libraries/Data%20Structures.md).
