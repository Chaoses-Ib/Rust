# Concurrency
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-00-concurrency.html)

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

`Send` 理论上也可以通过包装实现，例如创建一个 dispatch 线程来创建不支持 `Send` 的对象，在其它线程调用对象的 proxy 时通知 dispatch 线程执行，再将支持 `Send` 或序列化的结果返回给调用线程，不过目前并没有类似实现。