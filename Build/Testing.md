# Testing
[The Rust Programming Language](https://doc.rust-lang.org/book/ch11-00-testing.html)

[multitest](https://github.com/dzamlo/multitest/)

## Unit tests
`src/lib.rs`:
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
`tests/integration_test.rs`:
```rust
use adder;

#[test]
fn it_adds_two() {
    assert_eq!(4, adder::add_two(2));
}
```

## Documentation comments as tests
[The Rust Programming Language](https://doc.rust-lang.org/book/ch14-02-publishing-to-crates-io.html#making-useful-documentation-comments)

## Conditional compilation
Features:
- `--features`
- [cargo-hack: Cargo subcommand to provide various options useful for testing and continuous integration.](https://github.com/taiki-e/cargo-hack)
- [cargo-all-features: A Cargo subcommand to build and test all feature flag combinations.](https://github.com/frewsxcv/cargo-all-features)

[Test/build all combinations of features - Issue #4803 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/4803)