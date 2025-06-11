# Functions
In Rust, the return value of the function is synonymous with the value of the final expression in the block of the body of a function:
```rust
fn five() -> i32 {
    5
}
```

You can return early from a function by using the `return` keyword and specifying a value, but most functions return the last expression implicitly.
- Implicitly return
- `return`
- `?`
- `!` (not actually function level but process level)

> 除了隐式返回和 `return`，还有两种情况不用自己返回，一种是 `?`，返回错误的专用语法，另一种是 `!`，调用了终止程序的函数就不用写返回了

For most implementations, the default stack size is 2MiB, but it's 4MiB for WebAssembly.[^stack-tiger]

## Function pointers
[The Rust Programming Language](https://doc.rust-lang.org/book/ch19-05-advanced-functions-and-closures.html#function-pointers)

- How to write a generic function pointer?
  - `T: Copy + ...`
  - `assert_eq!(mem::size_of::<T>(), mem::size_of::<fn()>())`
  - `transmute_copy(&f)` / `*(&f as *const _ as *const T)`

    See [transmutes with generics](Type%20System/Conversions.md#with-generics).

  Applications: [dynamic linking](../Build/rustc/Linkage.md#cdylib)

## Closures
[The Rust Programming Language](https://doc.rust-lang.org/book/ch13-01-closures.html)

Rust’s **closures** are anonymous functions you can save in a variable or pass as arguments to other functions.

```rust
fn  add_one_v1   (x: u32) -> u32 { x + 1 }
let add_one_v2 = |x: u32| -> u32 { x + 1 };
let add_one_v3 = |x|             { x + 1 };
let add_one_v4 = |x|               x + 1  ;
```

```rust
let list = vec![1, 2, 3];
let only_borrows = || println!("From closure: {:?}", list);
let mut borrows_mutably = || list.push(7);
thread::spawn(move || println!("From thread: {:?}", list))
    .join()
    .unwrap();
```

The way a closure captures and handles values from the environment affects which traits the closure implements, and traits are how functions and structs can specify what kinds of closures they can use:
- `FnOnce` applies to closures that can be called once. All closures implement at least this trait, because all closures can be called. A closure that moves captured values out of its body will only implement `FnOnce` and none of the other `Fn` traits, because it can only be called once.
  - `FnOnce` must be owned to call. This means one can't use `&dyn FnOnce`, but only `&mut dyn FnMut`.

    [rust - How to use a reference to a FnOnce closure? - Stack Overflow](https://stackoverflow.com/questions/54491654/how-to-use-a-reference-to-a-fnonce-closure)
- `FnMut` applies to closures that don’t move captured values out of their body, but that might mutate the captured values. These closures can be called more than once.
- `Fn` applies to closures that don’t move captured values out of their body and that don’t mutate captured values, as well as closures that capture nothing from their environment. These closures can be called more than once without mutating their environment, which is important in cases such as calling a closure multiple times concurrently.

Functions can implement all three of the `Fn` traits too.

```rust
impl<T> Option<T> {
    pub fn unwrap_or_else<F>(self, f: F) -> T
    where
        F: FnOnce() -> T
    {
        match self {
            Some(x) => x,
            None => f(),
        }
    }
}
```

### Recursion
[recursion - Is it possible to make a recursive closure in Rust? - Stack Overflow](https://stackoverflow.com/questions/16946888/is-it-possible-to-make-a-recursive-closure-in-rust)

不要递归创建 closure：
- [rust - Error: reached the recursion limit while instantiating `func::<[closure]>` - Stack Overflow](https://stackoverflow.com/questions/54613966/error-reached-the-recursion-limit-while-instantiating-funcclosure)

[explicit_tail_calls](https://github.com/phi-go/rfcs/blob/guaranteed-tco/text/0000-explicit-tail-calls.md)
- [Tracking Issue for Explicit Tail Calls - Issue #112788 - rust-lang/rust](https://github.com/rust-lang/rust/issues/112788)


[^stack-tiger]: [What is the size limit of thread's stack in rust? - The Rust Programming Language Forum](https://users.rust-lang.org/t/what-is-the-size-limit-of-threads-stack-in-rust/11867)