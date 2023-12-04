# Logging
- [log: Logging implementation for Rust](https://github.com/rust-lang/log)

  ```rust
  #[macro_use(trace, info, debug, warn, error)]
  extern crate log;
  ```

  The evaluation of arguments is lazy.

  [Structured Logging - Issue #149 - rust-lang/log](https://github.com/rust-lang/log/issues/149)

  Implementations:
  - [`env_logger`: A logging implementation for `log` which is configured via an environment variable.](https://github.com/rust-cli/env_logger)
  - [`fern`: Simple, efficient logging for Rust](https://github.com/daboross/fern)
  - [`win_dbg_logger`](https://docs.rs/win_dbg_logger/*/win_dbg_logger/)
  - [`log-once`: Helper macros for logging events only once.](https://github.com/Luthaf/log-once)

- [tracing](#tracing-application-level-tracing-for-rust)

- [slog: Structured, contextual, extensible, composable logging for Rust](https://github.com/slog-rs/slog)

  [Slog vs tracing: Which one do you prefer : rust](https://www.reddit.com/r/rust/comments/kdo29n/slog_vs_tracing_which_one_do_you_prefer/)

[What's your approach to logging and tracing in production Rust code? : rust](https://www.reddit.com/r/rust/comments/182vkod/whats_your_approach_to_logging_and_tracing_in/)

[Blocking prints in async code : rust](https://www.reddit.com/r/rust/comments/qhoevk/blocking_prints_in_async_code/)

## [tracing: Application level tracing for Rust.](https://github.com/tokio-rs/tracing)
[Docs.rs](https://docs.rs/tracing/latest/tracing/)

- [`tracing_subscriber`](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/)
  - `with_writer` replaces the writer, rather than combining them.

  - [`fmt::time`](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/fmt/time/index.html)
  
    [rust - How to set custom timestamp format using tracing-subscriber? - Stack Overflow](https://stackoverflow.com/questions/76678749/how-to-set-custom-timestamp-format-using-tracing-subscriber)

    At least one feature of `chrono` and `time` has to be enabled to use time format.

  What will happen if writer's `write` returns `Err`?

- [`tracing_appender`](https://docs.rs/tracing-appender/latest/tracing_appender/)
  - [`non_blocking`](https://docs.rs/tracing-appender/latest/tracing_appender/non_blocking/index.html)
  - To write to files, use [`RollingFileAppender`](https://docs.rs/tracing-appender/latest/tracing_appender/rolling/index.html).

## Testing
[^log-test]

- Macro aliasing
  ```rust
  #[cfg(not(test))] 
  use log::{error, warn, info, debug, trace};

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

  When used with `tracing`, requries `tracing-subscriber` with `env-filter` feature enabled.

- [tracing-test: Access and evaluate tracing logs in async and sync tests.](https://github.com/dbrgn/tracing-test)


[^log-test]: [Is it possible to use Rust's log info for tests? - Stack Overflow](https://stackoverflow.com/questions/67087597/is-it-possible-to-use-rusts-log-info-for-tests)