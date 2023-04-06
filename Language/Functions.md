# Functions
In Rust, the return value of the function is synonymous with the value of the final expression in the block of the body of a function:
```rust
fn five() -> i32 {
    5
}
```

You can return early from a function by using the `return` keyword and specifying a value, but most functions return the last expression implicitly.

For most implementations, the default stack size is 2MiB, but it's 4MiB for WebAssembly.[^stack-tiger]

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


[^stack-tiger]: [What is the size limit of thread's stack in rust? - The Rust Programming Language Forum](https://users.rust-lang.org/t/what-is-the-size-limit-of-threads-stack-in-rust/11867)