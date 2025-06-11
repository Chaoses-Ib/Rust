# Object-oriented Programming
## Once
- [std::sync::Once](https://doc.rust-lang.org/std/sync/struct.Once.html)

  ```rust
  if #[cfg(any(
      target_os = "linux",
      target_os = "android",
      all(target_arch = "wasm32", target_feature = "atomics"),
      target_os = "freebsd",
      target_os = "openbsd",
      target_os = "dragonfly",
      target_os = "fuchsia",
      target_os = "hermit",
  ))] {
      mod futex;
      pub use futex::{Once, OnceState};
  } else if #[cfg(any(
      windows,
      target_family = "unix",
      all(target_vendor = "fortanix", target_env = "sgx"),
      target_os = "solid_asp3",
  ))] {
      mod queue;
      pub use queue::{Once, OnceState};
  } else {
      pub use crate::sys::once::{Once, OnceState};
  }
  ```

  [Underrust: What is the cost of sync::Once? - Graham King](https://darkcoding.net/software/cost-of-sync-once/)

  No thread-unsafe version?

- [std::cell::OnceCell](https://doc.rust-lang.org/stable/std/cell/struct.OnceCell.html), [std::sync::OnceLock](https://doc.rust-lang.org/stable/std/sync/struct.OnceLock.html) (v1.70)

  A cell which can be written to only once.

  `OnceCell`:
  ```rust
  pub struct OnceCell<T> {
      inner: UnsafeCell<Option<T>>,
  }
  ```
  `OnceCell` provides interior mutability, has no addtional runtime cost compared to `Option`, but at the cost of being `!Sync`.

  `OnceLock`:
  ```rust
  pub struct OnceLock<T> {
      once: Once,
      // Whether or not the value is initialized is tracked by `once.is_completed()`.
      value: UnsafeCell<MaybeUninit<T>>,
  }
  ```

  [After years of work and discussion, `once_cell` has been merged into `std` and stabilized : rust](https://www.reddit.com/r/rust/comments/126qaai/after_years_of_work_and_discussion_once_cell_has/)

  [Tracking Issue for `once_cell_try` - Issue #109737 - rust-lang/rust](https://github.com/rust-lang/rust/issues/109737)

- [once_cell: Rust library for single assignment cells and lazy statics without macros](https://github.com/matklad/once_cell)

`OnceCell`/`OnceLock` has an access cost. What if I know the cell must be inited when access?
- `OnceCell.get().unwrap_unchecked()`
- `UnsafeCell`
- [`MaybeUninit`](https://doc.rust-lang.org/std/mem/union.MaybeUninit.html)

  > You can think of `MaybeUninit<T>` as being a bit like `Option<T>` but without any of the run-time tracking and without any of the safety checks.

  > Note that dropping a `MaybeUninit<T>` will never call `T`'s drop code. It is your responsibility to make sure `T` gets dropped if it got initialized.

## Lazy evaluation 
- `OnceCell`

  ```rust
  use std::collections::HashMap;
  use std::sync::OnceLock;

  fn hashmap() -> &'static HashMap<u32, &'static str> {
      static HASHMAP: OnceLock<HashMap<u32, &str>> = OnceLock::new();
      HASHMAP.get_or_init(|| {
          let mut m = HashMap::new();
          m.insert(0, "foo");
          m.insert(1, "bar");
          m.insert(2, "baz");
          m
      })
  }

  fn main() {
      // First access to `HASHMAP` initializes it
      println!("The entry for `0` is \"{}\".", hashmap().get(&0).unwrap());

      // Any further access to `HASHMAP` just returns the computed value
      println!("The entry for `1` is \"{}\".", hashmap().get(&1).unwrap());
  }
  ```

- [std::cell::LazyCell](https://doc.rust-lang.org/std/cell/struct.LazyCell.html), [std::sync::LazyLock](https://doc.rust-lang.org/std/sync/struct.LazyLock.html) (v1.80)

  A value which is initialized on the first access.

- [lazy-static.rs: A small macro for defining lazy evaluated static variables in Rust.](https://github.com/rust-lang-nursery/lazy-static.rs)

  [Performance overhead of using `lazy_static`? : rust](https://www.reddit.com/r/rust/comments/me5mmj/performance_overhead_of_using_lazy_static/)