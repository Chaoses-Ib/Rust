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

### Move
```rust
let s1 = String::from("hello");
let s2 = s1;
func(s2);
```

Rust will never automatically create “deep” copies of your data. Therefore, any _automatic_ copying can be assumed to be inexpensive in terms of runtime performance.

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
