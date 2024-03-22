
# Shared-state Concurrency
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-03-shared-state.html)

## Atomic types
[std::sync::atomic](https://doc.rust-lang.org/std/sync/atomic/index.html)

[`atomic_bitfield`: Bitfield abstraction for Rust's core atomic types](https://github.com/amiraeva/atomic_bitfield)

[aarc: Atomically updatable variants of Arc and Weak for lock-free concurrency.](https://github.com/aarc-rs/aarc)

## Synchronization primitives
- [parking_lot: Compact and efficient synchronization primitives for Rust. Also provides an API for creating custom synchronization primitives.](https://github.com/amanieu/parking_lot)
- [Crossbeam: Tools for concurrent programming in Rust](https://github.com/crossbeam-rs/crossbeam)
- [spin-rs: Spin-based synchronization primitives](https://github.com/mvdnes/spin-rs)

Owned guards:
- [parking_lot: Compact and efficient synchronization primitives for Rust. Also provides an API for creating custom synchronization primitives.](https://github.com/Amanieu/parking_lot)
  
  [Add arc-based mutex locks to the `lock_api` crate · Issue #273 · Amanieu/parking_lot](https://github.com/Amanieu/parking_lot/issues/273)
- [RwLock in tokio::sync](https://docs.rs/tokio/1.29.1/tokio/sync/struct.RwLock.html#method.read_owned)
- [Add owned guard types to standard library - libs - Rust Internals](https://internals.rust-lang.org/t/add-owned-guard-types-to-standard-library/14912/5)

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
