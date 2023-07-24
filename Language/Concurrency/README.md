# Concurrency
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-00-concurrency.html)

## Threads
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-01-threads.html)

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let v = vec![1, 2, 3];

    let handle = thread::spawn(move || {
        println!("Here's a vector: {:?}", v);
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }

    handle.join().unwrap();
}
```

We often use the `move` keyword with closures passed to `thread::spawn` because the closure will then take ownership of the values it uses from the environment, thus transferring ownership of those values from one thread to another.

### Scoped threads
[std::thread::scope](https://doc.rust-lang.org/stable/std/thread/fn.scope.html)

Scoped threads 必须在 scope 返回前 join 所有线程，如何将 scope 作为一个变量保存？不过即使可以将 scope 保存为变量，依然很难让 struct 与 thread 拥有同样的生命周期，因为这会导致产生 self-referential struct。
- [std::thread::JoinGuard (and scoped) are unsound because of reference cycles · Issue #24292 · rust-lang/rust](https://github.com/rust-lang/rust/issues/24292)
- [Thread living as long as a struct ? : rust](https://www.reddit.com/r/rust/comments/7iuzy8/thread_living_as_long_as_a_struct/)

### Thread pools
- [threadpool: A very simple thread pool for parallel task execution](https://github.com/rust-threadpool/rust-threadpool)
- [unblock: A thread pool for isolating blocking](https://github.com/botika/unblock)
- [messaging-thread-pool: Rust message based thread pool crate](https://github.com/cainem/messaging-thread-pool)


## The Sync and Send traits
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-04-extensible-concurrency-sync-and-send.html)

The `Send` marker trait indicates that ownership of values of the type implementing `Send` can be transferred between threads. Almost all primitive types are `Send`, aside from raw pointers. Any type composed entirely of `Send` types is automatically marked as `Send` as well.

The `Sync` marker trait indicates that it is safe for the type implementing `Sync` to be referenced from multiple threads.

- `Rc<T>` is not `Sync` and `Send`. Use `Arc<T>` instead.
- `RefCell<T>` and the family of related `Cell<T>` types are not `Sync`. Use `Mutex<T>` instead.
- [`MutexGuard<T>`](https://doc.rust-lang.org/std/sync/struct.MutexGuard.html) is `Sync` but not `Send`.

  See [asynchronous - Is the Sync trait a strict subset of the Send trait; what implements Sync without Send? - Stack Overflow](https://stackoverflow.com/questions/68704717/is-the-sync-trait-a-strict-subset-of-the-send-trait-what-implements-sync-withou) for details.

### Wrappers
[Mutex\<Rc\> Why can't I pass it between threads? - SoByte](https://www.sobyte.net/post/2022-02/rust-mutex-send/)
- [Understanding Rust Thread Safety](https://onesignal.com/blog/thread-safety-rust/)

```rust
impl<T: ?Sized + Send> Send for Mutex<T>
impl<T: ?Sized + Send> Sync for Mutex<T>

impl<T: ?Sized + Send> Send for RwLock<T>
impl<T: ?Sized + Send + Sync> Sync for RwLock<T>

impl<T: ?Sized + Send + Sync> Send for Arc<T>
impl<T: ?Sized + Send + Sync> Sync for Arc<T>

impl<T: Send> Send for Sender<T>
impl<T> !Sync for Sender<T>
```

Wrappers:
- [SyncWrapper: A mutual exclusion primitive that relies on static type information only.](https://github.com/Actyx/sync_wrapper)
  
  ```rust
  impl<T> Sync for SyncWrapper<T>
  ```
  利用 borrow checker 实现的零开销 Mutex，不过使用限制比 Mutex 更大。

- [SendWrapper](https://github.com/thk1/send_wrapper)
  
  > This Rust crate implements a wrapper type called `SendWrapper` which allows you to move around non-`Send` types between threads, as long as you access the contained value only from within the original thread. You also have to make sure that the wrapper is dropped from within the original thread. If any of these constraints is violated, a panic occurs.

  SendWrapper 只是将 `Send` 的编译期检查推迟成了运行时检查，比 `unsafe impl Send` 安全点。

- [Fragile: Utility wrapper to send non send types to other threads safely](https://github.com/mitsuhiko/fragile)

`Send` 理论上也可以通过包装实现，例如创建一个 dispatch 线程来创建不支持 `Send` 的对象，在其它线程调用对象的 proxy 时通知 dispatch 线程执行，再将支持 `Send` 或序列化的结果返回给调用线程，不过目前只有部分实现：

- [ThreadIsolated](https://github.com/jgallagher/thread_isolated/)

  通过 Send closure 来实现对 `!Send` 对象的跨线程使用。

- async/await

  通过 Tokio 的 current thread scheduler 和 SendWrapper 实现：

  ```rust
  struct UnsendableStruct {
      // Rc<T> is !Send + !Sync
      pub v: Rc<u32>,
  }
  
  fn main() {
      // !Send + !Sync
      let unsendable_value = UnsendableStruct { v: 42.into() };
      // Send + Sync, panic if not accessed from the same thread
      let pesudo_sendable_value = send_wrapper::SendWrapper::new(unsendable_value);
      // bypass lifetime check, another way is to use scoped thread
      let pesudo_sendable_value_arc = Arc::new(pesudo_sendable_value);
  
      // runtime with current thread scheduler
      let rt = tokio::runtime::Builder::new_current_thread()
          .enable_time()
          .build()
          .unwrap();
      let rt = Arc::new(rt);
  
      println!("1. read v {:?} in thread {:?}", pesudo_sendable_value_arc.v, thread::current().id());
  
      let mut t;
      {
          let rt = rt.clone();
          let pesudo_sendable_value_arc = pesudo_sendable_value_arc.clone();
          t = thread::spawn(move || {
              println!("2/3. spawn future in thread {:?}", thread::current().id());
              // don't use rt.block_on, it will run the future in the current thread
              let handle = rt.spawn(async move {
                  let v = &pesudo_sendable_value_arc.v;
                  println!("4. future read v {:?} in thread {:?}", v, thread::current().id());
                  v.as_ref().clone()
              });
  
              // don't use rt.block_on
              let senable_result = futures::executor::block_on(handle).unwrap();
              println!("5. read future's sendable result {:?} in thread {:?}", senable_result, thread::current().id());
          });
      }
  
      rt.block_on(async move {
          println!("2/3. read v {:?} in thread {:?}", pesudo_sendable_value_arc.v, thread::current().id());
  
          // yield
          // using tokio::task::yield_now doesn't work
          tokio::time::sleep(std::time::Duration::from_secs(1)).await;
  
          println!("6. read v {:?} in thread {:?}", pesudo_sendable_value_arc.v, thread::current().id());
      });
  
      t.join().unwrap();
  }
  ```
  ```
  1. read v 42 in thread ThreadId(1)
  2/3. read v 42 in thread ThreadId(1)
  2/3. spawn future in thread ThreadId(2)
  1. future read v 42 in thread ThreadId(1)
  2. read future's sendable result 42 in thread ThreadId(2)
  3. read v 42 in thread ThreadId(1)
  ```
  
  Tokio 只有 current thread scheduler 和 multi thread scheduler，前者会在调用 `block_on` 时在当前线程执行 task。要实现 task 只在某一线程执行，就需要只在那个线程执行 `block_on`。这样的话，其它线程在提交 task 后就需要用另外的 runtime 或 futures::`block_on` 来等待 task 完成。只要小心一些，不是什么大问题。
  
  可以实现在 task 中引用 executor 线程的变量，不过需要用 SendWrapper 包装一下，将 Send 和 Sync 的检查推迟到运行时。  
  
  关于其它的 async 框架，async_std 似乎只能直接 block_on，没有更复杂的 executor；smol 虽然有个 LocalExecutor，但只能在创建的线程中使用，没法实现跨线程提交 task。
  
  总的来说，用 async/await 还是比用 channel 和 callback 的方案更简洁和灵活，不过 async/await 对 Rust 特性的使用更复杂，处理某些特殊场景可能会费些功夫。

## Shared-state concurrency
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-03-shared-state.html)

### Atomic types
[std::sync::atomic](https://doc.rust-lang.org/std/sync/atomic/index.html)

### Synchronization primitives
- [parking_lot: Compact and efficient synchronization primitives for Rust. Also provides an API for creating custom synchronization primitives.](https://github.com/amanieu/parking_lot)
- [Crossbeam: Tools for concurrent programming in Rust](https://github.com/crossbeam-rs/crossbeam)
- [spin-rs: Spin-based synchronization primitives](https://github.com/mvdnes/spin-rs)

#### Mutexes
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

### Data structures
- [Crossbeam: Tools for concurrent programming in Rust](https://github.com/crossbeam-rs/crossbeam)
- [left-right: A lock-free, read-optimized, concurrency primitive.](https://github.com/jonhoo/left-right)
- [Concread: Concurrently Readable Data Structures for Rust](https://github.com/kanidm/concread)

  [What is Concrete? - Concrete](https://docs.zama.ai/concrete/)
- [flashmap: A lock-free, partially wait-free, eventually consistent, concurrent hashmap.](https://github.com/Cassy343/flashmap)
- [concurrent-map: lock-free B+ tree](https://github.com/komora-io/concurrent-map)
- [Scalable Concurrent Containers: High performance containers and utilities for concurrent and asynchronous programming](https://github.com/wvwwvwwv/scalable-concurrent-containers)
- [triple-buffer: Implementation of triple buffering in Rust](https://github.com/HadrienG2/triple-buffer)
- [resman: Runtime managed resource borrowing.](https://github.com/azriel91/resman)


## Message passing
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
