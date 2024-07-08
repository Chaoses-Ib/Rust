# Workspaces
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/workspaces.html)

A **workspace** is a set of packages that share the same `Cargo.lock` and output directory.

- > If you don't use a Virtual Workspace you are essentially saying the entire project exists to produce that one root Package.

  > Both approaches make sense in different contexts. I personally prefer virtual workspaces because it makes cargo (and other tools) default to operating on all packages at once, which is usually what I want (e.g. I want `cargo test` to test the entire workspace, I want `cargo fmt` to format the whole workspace, and so on).

- Virtual workspace defaulting to `resolver = "1"` despite one or more workspace members being on edition 2021 which implies `resolver = "2"`
  
  ```sh
  warning: virtual workspace defaulting to `resolver = "1"` despite one or more workspace members being on edition 2021 which implies `resolver = "2"`
  note: to keep the current resolver, specify `workspace.resolver = "1"` in the workspace root's manifest
  note: to use the edition 2021 resolver, specify `workspace.resolver = "2"` in the workspace root's manifest
  note: for more details see https://doc.rust-lang.org/cargo/reference/resolver.html#resolver-versions
  ```
  ```toml
  [workspace]
  members = ["member1", "member2"]
  resolver = "2"
  ```

[1525-cargo-workspace - The Rust RFC Book](https://rust-lang.github.io/rfcs/1525-cargo-workspace.html)

[The Rust Programming Language](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html)

[More Complex Workspaces - cargo-dist](https://opensource.axo.dev/cargo-dist/book/workspaces/workspace-guide.html)