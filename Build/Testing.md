# Testing
[The Rust Programming Language](https://doc.rust-lang.org/book/ch11-00-testing.html)

## Unit tests
src/lib.rs:
```rust
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert_eq!(result, 4);
    }
}
```

## Integration tests
tests/integration_test.rs:
```rust
use adder;

#[test]
fn it_adds_two() {
    assert_eq!(4, adder::add_two(2));
}
```

## Documentation comments as tests
[The Rust Programming Language](https://doc.rust-lang.org/book/ch14-02-publishing-to-crates-io.html#making-useful-documentation-comments)
