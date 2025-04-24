# Command Line Interface
[Command Line Applications in Rust](https://rust-cli.github.io/book/index.html)

Libraries:
- [std::env::args](https://doc.rust-lang.org/1.39.0/std/env/fn.args.html)

- [clap](#clap)

- [Google/Argh: Rust derive-based argument parsing optimized for code size](https://github.com/google/argh)

- [bpaf: Command line parser with applicative interface](https://github.com/pacak/bpaf)

- [Lexopt: Minimalist pedantic command line parser](https://github.com/blyxxyz/lexopt)

Discussions:
- 2024-03 [Choosing a Library for CLI development in Rust : r/rust](https://www.reddit.com/r/rust/comments/1bs7f83/choosing_a_library_for_cli_development_in_rust/)

  > I think clap is standard.
  > 
  > With that said, I've been moving some things to `lexopt`. But I think that's less an "alternative" to clap and more an alternative approach altogether. It exists at a lower level of abstraction. For example, I just wrote a little CLI tool the other evening and I [used lexopt for it](https://github.com/BurntSushi/dotfiles/blob/55d29578bff7befd0c7263aaa61f653ffe23bd22/bin/rust/freq/main.rs#L414). (I also migrated ripgrep to `lexopt`, but that was for multiple reasons, including a bit more control over how CLI args are parsed.)

  > Personally I use bpaf instead of clap. It's much smaller and faster to compile. Clap adds 200-300 KiB to the binary, while bpaf is 10x smaller. Not that I really need it, but neither do I need all the clap's features.

## [clap](https://github.com/clap-rs/clap)
> A full featured, fast Command Line Argument Parser for Rust

[clap::\_derive::\_tutorial](https://docs.rs/clap/latest/clap/_derive/_tutorial/index.html)

Used by Cargo.

### Args
- [`Arg`](https://docs.rs/clap/latest/clap/struct.Arg.html)
- Conflicted short option names are checked at runtime rather than compile time.
- `Path`

  [Accepting file paths as arguments in Clap](https://www.rustadventure.dev/introducing-clap/clap-v4/accepting-file-paths-as-arguments-in-clap)

  [Parse Path with clap and throw error on invalid path - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/parse-path-with-clap-and-throw-error-on-invalid-path/94443)
  
- Multiple values
  - `multiple_occurrences`: `-c 1 -c 2 ...` (default)
  - [`value_delimiter = ','`](https://docs.rs/clap/latest/clap/builder/struct.Arg.html#method.value_delimiter): `--features a,b,c`
  - [`num_args`](https://docs.rs/clap/latest/clap/struct.Arg.html#method.num_args): `-c 1 2 ... -d`

  [How to populate a `Vec<String>`? - clap-rs/clap - Discussion #3788](https://github.com/clap-rs/clap/discussions/3788)

  [clap\_derive: Vec/Option<Vec> behavior is inconsistent with other types - Issue #1772 - clap-rs/clap](https://github.com/clap-rs/clap/issues/1772)
  > * `bool`: a flag
  > * `Option<_>`: not required
  > * `Option<Option<_>>` is not required and when it is present, the value is not required
  > * `Vec<_>`: multiple occurrences, optional
  >   * optional: `Vec` implies 0 or more, so should not imply required
  > * `Option<Vec<_>>`: multiple occurrences, optional
  >   * optional: Use over `Vec` to detect when no option being present when
  >     using multiple values

  `required = true` implies `min_values = 1..` for `Vec<_>`

  ~~[`min_values` when using Parser not respected - Issue #3259 - clap-rs/clap](https://github.com/clap-rs/clap/issues/3259)~~

### [Subcommands](https://docs.rs/clap/latest/clap/_derive/_tutorial/index.html#subcommands)
[Handling arguments and subcommands - Rain's Rust CLI recommendations](https://rust-cli-recommendations.sunshowers.io/handling-arguments.html)

- [`Subcommand`](https://docs.rs/clap/latest/clap/trait.Subcommand.html)
- [`InferSubcommands`](https://docs.rs/clap/2.24.2/clap/enum.AppSettings.html#variant.InferSubcommands)
- [`args_conflicts_with_subcommands`](https://docs.rs/clap/latest/clap/struct.Command.html#method.args_conflicts_with_subcommands)
- Default subcommand

  ```rust
  #[derive(Parser)]
  #[clap(args_conflicts_with_subcommands = true)]
  struct Cli {
      #[clap(subcommand)]
      command: Option<Commands>,

      #[clap(flatten)]
      code: CodeArgs,
  }

  #[derive(Subcommand)]
  enum Commands {
      Setup(SetupArgs),
      Code(CodeArgs),
  }

  #[derive(Args)]
  struct SetupArgs;

  #[derive(Args)]
  struct CodeArgs {
      // For required args:
      // `args_conflicts_with_subcommands` will override `required = true`
      // Option cannot be alised by use or type
      #[clap(long, required = true)]
      name: Option<String>,
  }

  match cli.command.unwrap_or(Commands::Code(cli.code)) {
      ...
  }
  ```
  [Default subcommand - Issue #975 - clap-rs/clap](https://github.com/clap-rs/clap/issues/975)

  [Set default subcommand via Derive API - Issue #3857 - clap-rs/clap](https://github.com/clap-rs/clap/issues/3857)
  - [Built-in default subcommand support - Issue #4442 - clap-rs/clap](https://github.com/clap-rs/clap/issues/4442)
