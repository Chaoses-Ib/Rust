
# Shared-state Concurrency
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-03-shared-state.html)

Or just avoid sharing.

## Atomic types
[std::sync::atomic](https://doc.rust-lang.org/std/sync/atomic/index.html)

[`atomic_bitfield`: Bitfield abstraction for Rust's core atomic types](https://github.com/amiraeva/atomic_bitfield)

### Atomic `Arc`
> It’s a good tool if you have some data that is very frequently read but infrequently modified, like configuration or an in-memory database that answers millions of queries per second, but is replaced only every 5 minutes. The canonical example for this is routing tables ‒ you want to read them with every passing packet, but you change them only when routing changes.

- [vorner/arc-swap: Support atomic operations on Arc itself](https://github.com/vorner/arc-swap)
  - [ArcSwapOption in arc\_swap - Rust](https://docs.rs/arc-swap/latest/arc_swap/type.ArcSwapOption.html)

  [arc\_swap::docs::performance - Rust](https://docs.rs/arc-swap/latest/arc_swap/docs/performance/index.html)

  [Tricks In Arc Swap | Vorner's random stuff](https://vorner.github.io/2019/04/06/tricks-in-arc-swap.html)

  [Stabilizing Arc Swap | Vorner's random stuff](https://vorner.github.io/2020/10/31/stabilizing-arc-swap.html) ([r/rust](https://www.reddit.com/r/rust/comments/jlztu7/stabilizing_arcswap/))

- [aarc: Atomically updatable variants of Arc and Weak for lock-free concurrency.](https://github.com/aarc-rs/aarc)

  > Instead of protecting in-place updates with locks, an alternative approach is to perform copy-on-write updates by atomically installing pointers. To avoid use-afer-free, mechanisms for safe memory reclamation (SMR) are typically utilized (i.e. hazard pointers, epoch-based reclamation). `aarc` uses the blazingly fast algorithm provided by the [`fast-smr`](https://github.com/aarc-rs/fast-smr) crate and builds on top of it, hiding unsafety and providing convenient RAII semantics through reference-counted pointers.

[SyncCow: A thread-safe clone-on-write container for fast concurrent writing and reading : r/rust](https://www.reddit.com/r/rust/comments/102cdmg/synccow_a_threadsafe_cloneonwrite_container_for/)
> `arc-swap` is good if you were going to share around "old" data anyway after creating old data, because it comes out already shared, with very low overheads to achieve that (down to sharding the read end of the data structure). It seems pretty unbeatable if you need to keep processing some requests based on whatever was the current config/data when the requests started \[1\].
>
> `sync_cow` may be better if you mostly need to incrementally update existing data in-place. I see this done with techniques like Left-Right so there's clearly a demand for it, especially when you need to be sure that only two copies exist, not an arbitrary number of copies held by an arbitrary number of running tasks.

## Synchronization primitives
- [parking_lot: Compact and efficient synchronization primitives for Rust. Also provides an API for creating custom synchronization primitives.](https://github.com/amanieu/parking_lot)
- [Crossbeam: Tools for concurrent programming in Rust](https://github.com/crossbeam-rs/crossbeam)
- [spin-rs: Spin-based synchronization primitives](https://github.com/mvdnes/spin-rs)
- [`rcu_clean::ArcRcu`](https://docs.rs/rcu-clean/latest/rcu_clean/struct.ArcRcu.html)
  - Interior mutability

Owned guards:
- [parking_lot: Compact and efficient synchronization primitives for Rust. Also provides an API for creating custom synchronization primitives.](https://github.com/Amanieu/parking_lot)
  
  [Add arc-based mutex locks to the `lock_api` crate · Issue #273 · Amanieu/parking_lot](https://github.com/Amanieu/parking_lot/issues/273)
- [RwLock in tokio::sync](https://docs.rs/tokio/1.29.1/tokio/sync/struct.RwLock.html#method.read_owned)
- [Add owned guard types to standard library - libs - Rust Internals](https://internals.rust-lang.org/t/add-owned-guard-types-to-standard-library/14912/5)

[Need a read-preferring "RwLock" : r/rust](https://www.reddit.com/r/rust/comments/1dd6vcl/need_a_readpreferring_rwlock/)

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
