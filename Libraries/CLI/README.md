# Command Line Interface
[Command Line Applications in Rust](https://rust-cli.github.io/book/index.html)

Libraries:
- [std::env::args](https://doc.rust-lang.org/1.39.0/std/env/fn.args.html)

- [clap: A full featured, fast Command Line Argument Parser for Rust](https://github.com/clap-rs/clap)
  - [clap::\_derive::\_tutorial](https://docs.rs/clap/latest/clap/_derive/_tutorial/index.html)
  - Args
    - Conflicted short option names are checked at runtime rather than compile time.
    - `Path`
  
      [Accepting file paths as arguments in Clap](https://www.rustadventure.dev/introducing-clap/clap-v4/accepting-file-paths-as-arguments-in-clap)

      [Parse Path with clap and throw error on invalid path - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/parse-path-with-clap-and-throw-error-on-invalid-path/94443)

  Used by Cargo.

- [Google/Argh: Rust derive-based argument parsing optimized for code size](https://github.com/google/argh)

- [bpaf: Command line parser with applicative interface](https://github.com/pacak/bpaf)

- [Lexopt: Minimalist pedantic command line parser](https://github.com/blyxxyz/lexopt)

Discussions:
- 2024-03 [Choosing a Library for CLI development in Rust : r/rust](https://www.reddit.com/r/rust/comments/1bs7f83/choosing_a_library_for_cli_development_in_rust/)

  > I think clap is standard.
  > 
  > With that said, I've been moving some things to `lexopt`. But I think that's less an "alternative" to clap and more an alternative approach altogether. It exists at a lower level of abstraction. For example, I just wrote a little CLI tool the other evening and I [used lexopt for it](https://github.com/BurntSushi/dotfiles/blob/55d29578bff7befd0c7263aaa61f653ffe23bd22/bin/rust/freq/main.rs#L414). (I also migrated ripgrep to `lexopt`, but that was for multiple reasons, including a bit more control over how CLI args are parsed.)

  > Personally I use bpaf instead of clap. It's much smaller and faster to compile. Clap adds 200-300 KiB to the binary, while bpaf is 10x smaller. Not that I really need it, but neither do I need all the clap's features.