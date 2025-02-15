# [Cargo](https://doc.rust-lang.org/cargo)
[GitHub](https://github.com/rust-lang/cargo), [The Rust Programming Language](https://doc.rust-lang.org/book/ch14-00-more-about-cargo.html)

[The Cargo Book](https://doc.rust-lang.org/cargo/index.html)

[Unstable Features - The Cargo Book](https://doc.rust-lang.org/cargo/reference/unstable.html)

- [cargo-temp: A CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies](https://github.com/yozhgoor/cargo-temp)

## Build commands
- [cargo run](https://doc.rust-lang.org/cargo/commands/cargo-run.html)
- cargo check
  - Build passes but check fails
    - Also very slow, blocking user actions for a long time if the editor runs it on every file save
    - `cargo clean` + `cargo cache -a`
    - ["cargo check" (incorrectly) shows compiler errors that are not present when running "cargo build" - Issue #9971 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/9971)
    - [cargo check shows errors when there are none and code compiles and runs cleanly otherwise - Issue #12145 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/12145)
- [bacon: background rust code check](https://github.com/Canop/bacon)
  - 会导致 VS Code 终端的路径超链接失效
  - How to `run` with args? `bacon -- xx` will break `check`
- [watchexec: Executes commands in response to file modifications](https://github.com/watchexec/watchexec) (discontinued)
  - [cargo-watch: Watches over your Cargo project's source.](https://github.com/watchexec/cargo-watch) (discontinued)
    - `cargo binstall cargo-watch`
    - `scoop install cargo-watch`
    - `cargo watch -x run`

    [Cargo watch has been a game changer in productivity : r/rust](https://www.reddit.com/r/rust/comments/1fsxeo0/cargo_watch_has_been_a_game_changer_in/)

    [Cargo Watch is on life support : r/rust](https://www.reddit.com/r/rust/comments/1ftc7cj/cargo_watch_is_on_life_support/?share_id=dMUg4LLxMdbom3kPzxxcV)

- [cargo-cache: manage cargo cache (${CARGO\_HOME}, ~/.cargo/), print sizes of dirs and remove dirs selectively](https://github.com/matthiaskrgr/cargo-cache)
  ```sh
  > cargo cache -a
  Clearing cache...

  Cargo cache 'C:\Users\Chaoses\.cargo':

  Total:                                   11.32 GB => 2.81 GB
    30 installed binaries:                           199.56 MB
    Registry:                              10.06 GB => 2.58 GB
      2 registry indices:                              1.81 GB
      3594 crate archives:                           761.15 MB
      3594 => 0 crate source checkouts:        7.48 GB => 0  B
    Git db:                                1.06 GB => 34.81 MB
      18 bare git repos:                              34.81 MB
      32 => 0 git repo checkouts:              1.02 GB => 0  B

  Size changed 11.32 GB => 2.81 GB (-8.51 GB, -75.17%)
  ```

## Installation
- [cargo install](https://doc.rust-lang.org/cargo/commands/cargo-install.html)
- [cargo-binstall: Binary installation for rust projects](https://github.com/cargo-bins/cargo-binstall)
  - `scoop install cargo-binstall`
  
  Cargo as a system package manager?
- [cargo-quickinstall: pre-compiled binary packages for `cargo install`](https://github.com/cargo-bins/cargo-quickinstall)