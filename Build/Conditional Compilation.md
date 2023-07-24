# Conditional Compilation
[The Rust Reference](https://doc.rust-lang.org/reference/conditional-compilation.html)

## Cargo features
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/features.html)

```toml
[features]
default = ["ico", "webp"]
bmp = []
png = []
ico = ["bmp", "png"]
webp = []
```

```rust
#[cfg(feature = "webp")]
pub mod webp;
```

```sh
cargo --features foo,bar
```