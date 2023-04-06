# Concurrency
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-00-concurrency.html)

## The Sync and Send traits
[The Rust Programming Language](https://doc.rust-lang.org/book/ch16-04-extensible-concurrency-sync-and-send.html)

The `Send` marker trait indicates that ownership of values of the type implementing `Send` can be transferred between threads. Almost all primitive types are `Send`, aside from raw pointers. Any type composed entirely of `Send` types is automatically marked as `Send` as well.

The `Sync` marker trait indicates that it is safe for the type implementing `Sync` to be referenced from multiple threads.

- `Rc<T>` is not `Sync` and `Send`. Use `Arc<T>` instead.
- `RefCell<T>` and the family of related `Cell<T>` types are not `Sync`. Use `Mutex<T>` instead.
