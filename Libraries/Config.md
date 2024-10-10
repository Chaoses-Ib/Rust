# Configuration
- [config-rs: ⚙️ Layered configuration system for Rust applications (with strong support for 12-factor applications).](https://github.com/mehcode/config-rs)

- [rust-cli/confy: 🛋 Zero-boilerplate configuration management in Rust](https://github.com/rust-cli/confy)
  - [Documentation / ease of use for default configuration file - Issue #89 - rust-cli/confy](https://github.com/rust-cli/confy/issues/89)
  - Only files.
    - [Compatibility with CLI parsing - Issue #6 - rust-cli/confy](https://github.com/rust-cli/confy/issues/6)

  [Using config files - Command Line Applications in Rust](https://rust-cli.github.io/book/in-depth/config-files.html)

- [Figment: A hierarchical configuration library so con-free, it's unreal.](https://github.com/sergiobenitez/figment)
  - `cargo add figment --features toml`, `cargo add serde --features derive`
  - [Conflict Resolution](https://docs.rs/figment/latest/figment/struct.Figment.html#conflict-resolution)

- [Confique: Type-safe, layered, light-weight, `serde`-based configuration library](https://github.com/LukasKalbertodt/confique) (inactive)
  - Easily generate configuration "templates"
  - `cargo add confique --no-default-features --features toml`
  - ~~[error\[E0463\]: can't find crate for `serde` - Issue #38](https://github.com/LukasKalbertodt/confique/issues/38)~~
  
  [Comparison with other libraries/solutions](https://github.com/LukasKalbertodt/confique#comparison-with-other-librariessolutions)

- [Uclicious: Uclicious is a flexible reduced boilerplate configuration framework.](https://github.com/andoriyu/uclicious)

- [SCL: A simple configuration language](https://github.com/Keats/scl)

Discussions:
- 2022-12 [How do you manage configuration in rust? : r/rust](https://www.reddit.com/r/rust/comments/zmicie/how_do_you_manage_configuration_in_rust/)
- 2024-02 [What's the best practice for configuration : r/rust](https://www.reddit.com/r/rust/comments/1akmv4j/whats_the_best_practice_for_configuration/)