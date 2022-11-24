# Functions
In Rust, the return value of the function is synonymous with the value of the final expression in the block of the body of a function:
```rust
fn five() -> i32 {
    5
}
```

You can return early from a function by using the `return` keyword and specifying a value, but most functions return the last expression implicitly.