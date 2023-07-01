# Variables
- Variables are immutable by default.
- You can shadow a variable by a new variable with the same name.
- Constants are always immutable. You aren't allowed to use `mut` with constants.

## Ownership
- Each value in Rust has an _owner_.
- There can only be one owner at a time.
- When the owner goes out of scope, the value will be dropped.

### Copy
```rust
let x = 5;
let y = x;
func(y);
```

If a type implements the `Copy` trait, variables that use it do not move, but rather are trivially copied, making them still valid after assignment to another variable.

Rust will never automatically create “deep” copies of your data. Therefore, any _automatic_ copying can be assumed to be inexpensive in terms of runtime performance.

### Move
```rust
let s1 = String::from("hello");
let s2 = s1;
func(s2);
```

### Clone
```rust
let s1 = String::from("hello");
let s2 = s1.clone();
```

### References and borrowing
A **reference** is like a pointer in that it’s an address we can follow to access the data stored at that address; that data is owned by some other variable. **Borrowing** is the action of creating a reference. 

```rust
fn main() {
    let s1 = String::from("hello");
    let len = calculate_length(&s1);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

References are immutable by default. You can create a mutable reference with `&mut`:

```rust
fn main() {
    let mut s = String::from("hello");
    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

A reference’s scope starts from where it is introduced and continues through the last time that reference is used (which is called non-lexical lifetimes). Mutable references have one big restriction: if you have a mutable reference to a value, you can have no other references to that value.

[`ref`](https://doc.rust-lang.org/std/keyword.ref.html) annotates pattern bindings to make them borrow rather than move.

### Slices
**Slices** let you reference a contiguous sequence of elements in a collection rather than the whole collection.

```rust
let a = [1, 2, 3, 4, 5];
let slice : &[i32] = &a[1..3];
```

#### String slices
```rust
let s = String::from("hello world");
let hello : &str = &s[0..5];
let world = &s[6..11];
```

String literals are string slices.

### Interior mutability
[RefCell\<T\> and the Interior Mutability Pattern - The Rust Programming Language](https://doc.rust-lang.org/book/ch15-05-interior-mutability.html)

```rust
pub trait Messenger {
    fn send(&self, msg: &str);
}

pub struct LimitTracker<'a, T: Messenger> {
    messenger: &'a T,
    value: usize,
    max: usize,
}

impl<'a, T> LimitTracker<'a, T>
where
    T: Messenger,
{
    pub fn new(messenger: &'a T, max: usize) -> LimitTracker<'a, T> {
        LimitTracker {
            messenger,
            value: 0,
            max,
        }
    }

    pub fn set_value(&mut self, value: usize) {
        self.value = value;

        let percentage_of_max = self.value as f64 / self.max as f64;

        if percentage_of_max >= 1.0 {
            self.messenger.send("Error: You are over your quota!");
        } else if percentage_of_max >= 0.9 {
            self.messenger
                .send("Urgent warning: You've used up over 90% of your quota!");
        } else if percentage_of_max >= 0.75 {
            self.messenger
                .send("Warning: You've used up over 75% of your quota!");
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::cell::RefCell;

    struct MockMessenger {
        sent_messages: RefCell<Vec<String>>,
    }

    impl MockMessenger {
        fn new() -> MockMessenger {
            MockMessenger {
                sent_messages: RefCell::new(vec![]),
            }
        }
    }

    impl Messenger for MockMessenger {
        fn send(&self, message: &str) {
            self.sent_messages.borrow_mut().push(String::from(message));
        }
    }

    #[test]
    fn it_sends_an_over_75_percent_warning_message() {
        // --snip--

        assert_eq!(mock_messenger.sent_messages.borrow().len(), 1);
    }
}
```

Note that `RefCell<T>` does not work for multithreaded code. `Mutex<T>` is the thread-safe version of `RefCell<T>`.

### Self-referential structs
在 Rust 中，结构体的引用字段的生命期必须大于结构体本身，即必须在 drop 完成之前都可用，而对结构体字段的引用的生命期是与结构体本身相同的，因此一个结构无法包含对自己的字段的引用。

这个问题有以下一些绕过方法：
- `Option<T>`
- `unsafe`
- `Pin<T>`
- [ouroboros: Easy self-referential struct generation for Rust.](https://github.com/joshua-maros/ouroboros)
- `Rc` + `Weak`
- 修改设计

这些方法要么需要 `unsafe`，要么用起来很麻烦，或者限制很大，我们在设计时应该尽量避免 self-referential structs 的出现。

[结构体中的自引用 - Rust语言圣经](https://course.rs/advance/circle-self-ref/self-referential.html)

[Self-referential types for fun and profit | More Stina Blog!](https://morestina.net/blog/1868/self-referential-types-for-fun-and-profit)

[Self Referential Structs in Rust (Part 1)](https://arunanshub.hashnode.dev/self-referential-structs-in-rust)

## Drop
[Does Rust free up the memory of overwritten variables? - Stack Overflow](https://stackoverflow.com/questions/48227347/does-rust-free-up-the-memory-of-overwritten-variables)
- Shadowed variables will be dropped when they go out of scope (not immediately after shadowing).

  ```rust
  struct Noisy;
  impl Drop for Noisy {
      fn drop(&mut self) {
          eprintln!("Dropped")
      }
  }
  
  fn main() {
      eprintln!("0");
      let thing = Noisy;
      eprintln!("1");
      let thing = Noisy;
      eprintln!("2");
  }
  ```
  ```
  0
  1
  2
  Dropped
  Dropped
  ```
