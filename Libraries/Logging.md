# Logging
- [log: Logging implementation for Rust](https://github.com/rust-lang/log)

  ```rust
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

- [tracing](#tracing-application-level-tracing-for-rust)

- [slog: Structured, contextual, extensible, composable logging for Rust](https://github.com/slog-rs/slog)

  [Slog vs tracing: Which one do you prefer : rust](https://www.reddit.com/r/rust/comments/kdo29n/slog_vs_tracing_which_one_do_you_prefer/)

[What's your approach to logging and tracing in production Rust code? : rust](https://www.reddit.com/r/rust/comments/182vkod/whats_your_approach_to_logging_and_tracing_in/)

[Blocking prints in async code : rust](https://www.reddit.com/r/rust/comments/qhoevk/blocking_prints_in_async_code/)

## [tracing: Application level tracing for Rust.](https://github.com/tokio-rs/tracing)
[Docs.rs](https://docs.rs/tracing/latest/tracing/)

From `log`:
- `log!()` → `event!()`
- `log_enabled!()` → `event_enabled!()`
- [→Non-const event level](#levels)

### Levels
```rust
#[repr(usize)]
enum LevelInner {
    /// Designates very low priority, often extremely verbose, information.
    Trace = 0,
    /// Designates lower priority information.
    Debug = 1,
    /// Designates useful information.
    Info = 2,
    /// Designates hazardous situations.
    Warn = 3,
    /// Designates very serious errors.
    Error = 4,
}
```
- The comparisons is inverted.
  
  > The discriminants for the `LevelInner` enum are assigned in "backwards" order, with `TRACE` having the *lowest* value. However, we want `TRACE` to compare greater-than all other levels.

- `level_enabled!()`
  ```rust
  macro_rules! level_enabled {
      ($lvl:expr) => {
          $lvl <= $crate::level_filters::STATIC_MAX_LEVEL
              && $lvl <= $crate::level_filters::LevelFilter::current()
      };
  }
  ```
  Is `STATIC_MAX_LEVEL` always larger than `LevelFilter::current()`?

- `macro_use`
  ```rust
  #[macro_use(trace, info, debug, warn, error)]
  extern crate tracing;
  ```

- [Non-const event level - Issue #2730 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/2730)

### [`tracing_subscriber`](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/)
- `DEFAULT_MAX_LEVEL` is `INFO`.

- Dynamic layers
  - A `Layer` wrapped in an `Option` also implements the `Layer` trait. This allows individual layers to be enabled or disabled at runtime while always producing a `Subscriber` of the same type.
  - If a `Layer` may be one of several different types, note that` Box<dyn Layer<S> + Send + Sync>` implements `Layer`. This may be used to erase the type of a `Layer`. The `Layer::boxed` method is provided to make boxing a `Layer` more convenient, but `Box::new` may be used as well.
  - If a variable number of `Layer` is needed and those `Layer`s have different types, a `Vec` of boxed `Layer` trait objects may be used.
  - If the number of layers *changes* at runtime, a `Vec` of subscribers can be used alongside the `reload` module to add or remove subscribers dynamically at runtime.

  [Unable to dynamically configure with builder - Issue #575 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/575)

- ANSI: [→nu-ansi-term](TUI/README.md#styling)
  
  [ANSI broken on Windows 10 - Issue #445 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/445)

  [`tracing-subscriber` should not use `nu-ansi-term` and prefer another crate like `owo_colors` or `colored` - Issue #2759 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/2759)

- `with_writer` replaces the writer, rather than combining them.

  [Multiple Writers or Subscribers - Issue #971 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/971)

- [`fmt::time`](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/fmt/time/index.html)

  [rust - How to set custom timestamp format using tracing-subscriber? - Stack Overflow](https://stackoverflow.com/questions/76678749/how-to-set-custom-timestamp-format-using-tracing-subscriber)

  At least one feature of `chrono` and `time` has to be enabled to use time format.

What will happen if writer's `write` returns `Err`?

### [`tracing_appender`](https://docs.rs/tracing-appender/latest/tracing_appender/)
- [`non_blocking`](https://docs.rs/tracing-appender/latest/tracing_appender/non_blocking/index.html)
  - If `WorkerGuard` is dropped, events will be *silently ignored*.
- To write to files, use [`RollingFileAppender`](https://docs.rs/tracing-appender/latest/tracing_appender/rolling/index.html).
- `RollingFileAppender` will *panic* if it failed to open the log file.

  Example message:
  ```
  initializing rolling file appender failed: InitError { context: "failed to create initial log file", source: Os { code: 5, kind: PermissionDenied, message: "拒绝访问。" } }
  ```

### [tracing-panic: A custom panic hook to capture panic info in your telemetry pipeline](https://github.com/LukeMathWalker/tracing-panic)
- No `backtrace` support.

Alternative:
```rust
fn panic_log_hook(panic_info: &std::panic::PanicInfo) {
    let backtrace = std::backtrace::Backtrace::force_capture();

    let thread = std::thread::current();
    let thread = thread.name().unwrap_or("<unnamed>");

    let msg = match panic_info.payload().downcast_ref::<&'static str>() {
        Some(s) => *s,
        None => match panic_info.payload().downcast_ref::<String>() {
            Some(s) => &**s,
            None => "Box<Any>",
        },
    };

    // If you are using Sentry, since Sentry will capture panics itself, use warn instead of error to avoid reporting the panic twice
    match panic_info.location() {
        Some(location) => {
            error!(
                thread,
                msg,
                %location,
                %backtrace,
                "A panic occurred"
            );
        }
        None => error!(thread, msg, %backtrace, "A panic occurred"),
    }
}

let prev_hook = std::panic::take_hook();
std::panic::set_hook(Box::new(move |panic_info| {
    panic_log_hook(panic_info);
    prev_hook(panic_info);
}));
```

### Tools
- [tracing-tree](https://github.com/davidbarsky/tracing-tree)
- [tokio-console: a debugger for async rust!](https://github.com/tokio-rs/console)
- OpenTelemetry
  - [Jaeger: open source, distributed tracing platform](https://www.jaegertracing.io/)
- [Log Analyzer Pro (lap)](https://github.com/MrCasCode/log-analyzer-pro)
- [rust-logviewer: A simple log viewer UI for typical Rust logs](https://github.com/cfsamson/rust-logviewer)

[tracing: Provide a GUI/Console-Based Visualization of Spans and Events - Issue #884 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/884)

[\[Ask r/rust\] What is your best way to consume `tracing` logs? : r/rust](https://www.reddit.com/r/rust/comments/153yags/ask_rrust_what_is_your_best_way_to_consume/)

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