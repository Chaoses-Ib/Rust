# Benchmarking
- [test (unstable)](https://doc.rust-lang.org/beta/unstable-book/library-features/test.html)
- [Criterion.rs: Statistics-driven benchmarking library for Rust](https://github.com/bheisler/criterion.rs)

  [Advanced Configuration](https://bheisler.github.io/criterion.rs/book/user_guide/advanced_configuration.html)
  - The default sample count is 100.

There can be multiple `[[bench]]` in `Cargo.toml`:
- When running `cargo bench`, benches from all targets will benchmakred (the same as `cargo bench --all-targets`).
- To only benchmark a specified target, use `cargo bench --bench [<NAME>]`