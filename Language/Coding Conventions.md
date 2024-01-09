# Coding Conventions
[The Rust Style Guide](https://doc.rust-lang.org/nightly/style-guide/)
- [2436-style-guide - The Rust RFC Book](https://rust-lang.github.io/rfcs/2436-style-guide.html)

[Style Guidelines](https://doc.rust-lang.org/1.0.0/style/README.html)
- [What happened to this style guide : rust](https://www.reddit.com/r/rust/comments/t4ec3z/what_happened_to_this_style_guide/)

[Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)

## Naming conventions
[Naming conventions](https://doc.rust-lang.org/1.0.0/style/style/naming/README.html)

[Naming convention for crates - rust-lang/api-guidelines - Discussion #29](https://github.com/rust-lang/api-guidelines/discussions/29)
- `kebab-case` or `snake_case`

[What's the convention on variables that share reserved (keyword) names? : learnrust](https://www.reddit.com/r/learnrust/comments/scmviz/whats_the_convention_on_variables_that_share/)
- Using a shorter or longer version, e.g. `ref` => `reference` / `order_reference`, `type` => `ty` / `order_type`
    
- Adding an underscore to the end (not the beginning, as that disables unused lints for a field / variable)
    
- Inventing different spellings of the same word, e.g. `azync`/ `krate`

## [rustfmt](https://github.com/rust-lang/rustfmt)
[Configuration Options](https://rust-lang.github.io/rustfmt/?version=v1.6.0&search=)

Skip:
- `#[rustfmt::skip]`
- `#![cfg_attr(rustfmt, rustfmt_skip)]`

  [rust - Is there a stable way to tell Rustfmt to skip an entire file - Stack Overflow](https://stackoverflow.com/questions/59247458/is-there-a-stable-way-to-tell-rustfmt-to-skip-an-entire-file)

[Could rustfmt format Cargo.toml ? - Issue #4091 - rust-lang/rustfmt](https://github.com/rust-lang/rustfmt/issues/4091)
- [Even Better TOML - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml)

  It does not fully follow the conventions, which requires in the `[package]` setion `name` and `version` should be placed before other sorted keys and `description` should be placed at the end.

Formatting on save:
- VS Code[^save-vsc]

  ```rust
  "[rust]": {
      "editor.defaultFormatter": "rust-lang.rust-analyzer",
      "editor.formatOnSave": true
  }
  ```


[^save-vsc]: [visual studio code - How to run cargo fmt on save in vscode? - Stack Overflow](https://stackoverflow.com/questions/67859926/how-to-run-cargo-fmt-on-save-in-vscode)