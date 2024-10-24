# TUI
## Libraries
- [inquire: A Rust library for building interactive prompts](https://github.com/mikaelmello/inquire)

Discussions:
- 2021-09 [CLI UI library for Rust : r/rust](https://www.reddit.com/r/rust/comments/pxhl4d/cli_ui_library_for_rust/)

## Styling
Streams:
- [anstyle: ANSI text styling](https://github.com/rust-cli/anstyle)
  - anstream
    - Stripping colors for non-terminals
    - Respecting env variables like [`NO_COLOR`](https://no-color.org/) or [`CLICOLOR`](https://bixense.com/clicolors/)
    - Windows: Falling back to the wincon API where [`ENABLE_VIRTUAL_TERMINAL_PROCESSING`](https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences#output-sequences) is unsupported
    - Used by Cargo
    - ~~[Using anstream with tracing\_appender's `RollingFileAppender` - Issue #220](https://github.com/rust-cli/anstyle/issues/220)~~

    [anstream: simplifying terminal styling](https://epage.github.io/blog/2023/03/anstream-simplifying-terminal-styling/)

- [termcolor: Cross platform terminal colors for Rust.](https://github.com/BurntSushi/termcolor)
  - Works on Windows 7+
  
    [No console colors on Windows 7 - Issue #55769 - rust-lang/rust](https://github.com/rust-lang/rust/issues/55769)

    [Windows / Colors are displayed as codes - Issue #4722 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/4722)

  - Previously used by Cargo.

[Migrate from termcolor to anstream - Issue #12627 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/12627)

Strings:
- [colored: Coloring terminal so simple you already know how to do it !](https://github.com/colored-rs/colored)

- [owo-colors: A zero-allocation no\_std-compatible zero-cost way to add color to your Rust terminal](https://github.com/jam1garner/owo-colors)
  - More-or-less a drop-in replacement for `colored`, allowing `colored` to work in a `no_std` environment.

- [rust-ansi-term: Rust library for ANSI terminal colours and styles (bold, underline)](https://github.com/ogham/rust-ansi-term#basic-usage) (discontinued)
  - [nu-ansi-term: Rust library for ANSI terminal colours and styles (bold, underline) - Nushell project fork](https://github.com/nushell/nu-ansi-term)

    Not work on Windows 7 and 8.
    
    On Windows 10, the application must enable ANSI support first:
    ```rust
    // ENABLE_VIRTUAL_TERMINAL_PROCESSING
    let enabled = nu_ansi_term::enable_ansi_support();
    ```
    Without this, the ANSI will only work in Windows Terminal, but not in Windows Console Host (conhost).

- [inline\_colorization: format!(Lets the user {color\_red}colorize{color\_reset} the and {style\_underline}style the output{style\_reset} text using inline variables);](https://github.com/eliasjonsson023/inline_colorization)