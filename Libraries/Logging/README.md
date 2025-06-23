# Logging
- [log: Logging implementation for Rust](https://github.com/rust-lang/log)

  ```rust
  #[allow(unused_imports)]
  #[macro_use(trace, info, debug, warn, error)]
  extern crate log;
  ```

  The evaluation of arguments is lazy.

  [Structured Logging - Issue #149 - rust-lang/log](https://github.com/rust-lang/log/issues/149)

  [how to disable logging for certain crates : r/rust](https://www.reddit.com/r/rust/comments/85qp50/how_to_disable_logging_for_certain_crates/)

  Implementations:
  - [`env_logger`: A logging implementation for `log` which is configured via an environment variable.](https://github.com/rust-cli/env_logger)
  - [`fern`: Simple, efficient logging for Rust](https://github.com/daboross/fern)
  - [`win_dbg_logger`](https://docs.rs/win_dbg_logger/*/win_dbg_logger/)
  - [`log-once`: Helper macros for logging events only once.](https://github.com/Luthaf/log-once)
  - [rust-log-panics: A panic hook which logs panics rather than printing them.](https://github.com/sfackler/rust-log-panics)
  - [privacy-log: rust-lang/log without file names and line](https://github.com/wcampbell0x2a/privacy-log)

- [→tracing](tracing/README.md)

- [slog: Structured, contextual, extensible, composable logging for Rust](https://github.com/slog-rs/slog)

  [Slog vs tracing: Which one do you prefer : rust](https://www.reddit.com/r/rust/comments/kdo29n/slog_vs_tracing_which_one_do_you_prefer/)

- [defmt: Efficient, deferred formatting for logging on embedded systems](https://github.com/knurling-rs/defmt)
  - Compile-time filtering
  - Output object format must be ELF
  - Custom linking (linker script) is required
  - Single, global logger instance (but using multiple channels is possible)

- [flashlog: A Rust logging library. It's lazy, thus fast.](https://github.com/JunbeomL22/flashlog)

[What's your approach to logging and tracing in production Rust code? : rust](https://www.reddit.com/r/rust/comments/182vkod/whats_your_approach_to_logging_and_tracing_in/)

[Blocking prints in async code : rust](https://www.reddit.com/r/rust/comments/qhoevk/blocking_prints_in_async_code/)

## Compile-time filtering
- log
  - [crate/module specific log levels at compile time - Issue #387](https://github.com/rust-lang/log/issues/387)
    - [hnj2/log](https://github.com/hnj2/log/tree/compile-time-filters)

      [hnj2/compile-time-filter-tests: A collection of tests for the compile\_time\_filters feature for the rust-lang/log crate.](https://github.com/hnj2/compile-time-filter-tests)
- [→tracing](tracing/README.md#compile-time-filtering)
- defmt: [Filtering - defmt book](https://defmt.ferrous-systems.com/filtering)
- [esp-println: compile time module level log filtering - Issue #1578 - esp-rs/esp-hal](https://github.com/esp-rs/esp-hal/issues/1578)

## Testing
[^log-test]

- Macro aliasing
  ```rust
  #[allow(unused_imports)]
  #[cfg(not(test))] 
  use log::{error, warn, info, debug, trace};

  #[allow(unused_imports)]
  #[cfg(test)]
  use std::{eprintln as error, eprintln as warn, eprintln as info, eprintln as debug, eprintln as trace};
  ```
  Not compatible with `tracing`.

- [test-log: A replacement of the `#[test]` attribute that initializes logging and/or tracing infrastructure before running tests.](https://github.com/d-e-s-o/test-log)

  ```rust
  #[cfg(test)]
  #[macro_use(test)]
  extern crate test_log;
  ```
  - By default, only `ERROR` logs are printed.
    - `$env:RUST_LOG='debug'`
    - [Allow to set default log level - Issue #25 - d-e-s-o/test-log](https://github.com/d-e-s-o/test-log/issues/25)
  - When used with `tracing`, requries `tracing-subscriber` with `env-filter` feature enabled.

- [tracing-test: Access and evaluate tracing logs in async and sync tests.](https://github.com/dbrgn/tracing-test)

  ```rust
  #[traced_test]
  #[test]
  ```

[^log-test]: [Is it possible to use Rust's log info for tests? - Stack Overflow](https://stackoverflow.com/questions/67087597/is-it-possible-to-use-rusts-log-info-for-tests)

## Tools
- [Log Analyzer Pro (lap)](https://github.com/MrCasCode/log-analyzer-pro)
- [rust-logviewer: A simple log viewer UI for typical Rust logs](https://github.com/cfsamson/rust-logviewer)
- [mlv: Mini Log Viewer](https://github.com/ewpratten/mlv)
  - egui
  - Cannot filter
  - Highlight doesn't work?
  - Cannot drag and drop