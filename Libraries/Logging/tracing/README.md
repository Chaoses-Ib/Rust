# [tracing: Application level tracing for Rust.](https://github.com/tokio-rs/tracing)
[Docs.rs](https://docs.rs/tracing/latest/tracing/)

From `log`:
- `log!()` → `event!()`
- `log_enabled!()` → `event_enabled!()`
- [→Non-const event level](#levels)
- [`tracing_log`](https://docs.rs/tracing-log/)
- Larger binary size?

[Custom Logging in Rust Using tracing and tracing-subscriber | Bryan Burgers](https://burgers.io/custom-logging-in-rust-using-tracing)

## [Compile-time filtering](https://docs.rs/tracing/latest/tracing/level_filters/index.html#compile-time-filters)
> Trace verbosity levels can be statically disabled at compile time via Cargo features, similar to the [`log` crate](https://docs.rs/log/latest/log/#compile-time-filters). Trace instrumentation at disabled levels will be skipped and will not even be present in the resulting binary unless the verbosity level is specified dynamically. This level is configured separately for release and debug builds. The features are:
- `max_level_off`
- `max_level_{error,warn,info,debug,trace}`
- `release_max_level_off`
- `release_max_level_{error,warn,info,debug,trace}`

But tracing features are global and cannot be adjusted for specific crates. Workarounds:
- [tracing: Consider Switching compile-time filters from Cargo features to `RUSTFLAGS` - Issue #2081](https://github.com/tokio-rs/tracing/issues/2081)

  > I think this can also enable more fine-grained compile-time control, like enabling/disabling events per crate. When the env variable is present, tracing can replace all event macros with procedural macros, then use [`caller_modpath`](https://github.com/Shizcow/caller_modpath) to retrieve the caller's module path, and then filter the events according to the env variable. Though `caller_modpath` requires nightly feature and I'm not sure how big the compile time impact would be.
  > 
  > Currently control like this can only be done by duplicating dummy macros per crate, not only cumbersome but also hard to extend (like adding per-crate compile-time level filters). Providing a built-in control mechanism from tracing would be great.

- [core: introduce statically discoverable metadata - Issue #969](https://github.com/tokio-rs/tracing/issues/969)
- Dummy macros

  Must be duplicated for every crate wanting to control the log.

  e.g. [compio-log](https://crates.io/crates/compio-log)

[Turn off tracing at compile time for specific crate - The Rust Programming Language Forum](https://users.rust-lang.org/t/turn-off-tracing-at-compile-time-for-specific-crate/104337)

[Is there a performance cost in adding many tracing, #\[instrument calls as opposed to log...!() ? or neither matters if we set the log lines high enough ? : r/rust](https://www.reddit.com/r/rust/comments/x9nypb/is_there_a_performance_cost_in_adding_many/)

## [Metadata](https://docs.rs/tracing/latest/tracing/struct.Metadata.html)
- All data has to be `'static` except `fields`.

- [tracing-dynamic: A small library to allow you to create dynamic attributes on spans and events.](https://github.com/BrynCooke/tracing-dynamic)

### Targets
- Can only be `&'static str`.
  - And there is no direct API to pass non-const `&'static str`
- Can be empty, but not `None`. It may still be formatted as `:`.

### Levels
```rust
[repr(usize)]
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
  #[allow(unused_imports)]
  #[macro_use(trace, info, debug, warn, error)]
  extern crate tracing;
  ```

- [Non-const event level - Issue #2730 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/2730)

## [Spans](https://docs.rs/tracing/latest/tracing/span/index.html)
- > **Warning**: in asynchronous code that uses async/await syntax, `Span::enter` should be used very carefully or avoided entirely. Holding the drop guard returned by `Span::enter` across `.await` points will result in incorrect traces.
  - [`Span::in_scope`](https://docs.rs/tracing/latest/tracing/struct.Span.html#method.in_scope) (sync)
  - [`Future::instrument` combinator](https://docs.rs/tracing/latest/tracing/trait.Instrument.html)
    - `#[instrument]`

- [Span relationships](https://docs.rs/tracing/latest/tracing/span/index.html#span-relationships)
  - Only leaf span is formatted by default

- [`#[instrument]`](https://docs.rs/tracing-attributes/latest/tracing_attributes/attr.instrument.html)
  - Default level: `INFO`
  - `#[instrument(name = "", skip_all, fields(v = arg))]`

[Tracing: No span info output to appender - The Rust Programming Language Forum](https://users.rust-lang.org/t/tracing-no-span-info-output-to-appender/122017/3)

## [`tracing_subscriber`](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/)
- `DEFAULT_MAX_LEVEL` is `INFO`.

- The APIs of subscribers and layers are similar but different.

- Dynamic layers
  - A `Layer` wrapped in an `Option` also implements the `Layer` trait. This allows individual layers to be enabled or disabled at runtime while always producing a `Subscriber` of the same type.
  - If a `Layer` may be one of several different types, note that` Box<dyn Layer<S> + Send + Sync>` implements `Layer`. This may be used to erase the type of a `Layer`. The `Layer::boxed` method is provided to make boxing a `Layer` more convenient, but `Box::new` may be used as well.
  - If a variable number of `Layer` is needed and those `Layer`s have different types, a `Vec` of boxed `Layer` trait objects may be used.
  - If the number of layers *changes* at runtime, a `Vec` of subscribers can be used alongside the `reload` module to add or remove subscribers dynamically at runtime.

  [Unable to dynamically configure with builder - Issue #575 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/575)

- ANSI: [→nu-ansi-term](../../TUI/README.md#styling)
  
  [ANSI broken on Windows 10 - Issue #445 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/445)

  [`tracing-subscriber` should not use `nu-ansi-term` and prefer another crate like `owo_colors` or `colored` - Issue #2759 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/2759)

- `with_writer` replaces the writer, rather than combining them.

  [Multiple Writers or Subscribers - Issue #971 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/971)

- [`fmt::time`](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/fmt/time/index.html)

  [rust - How to set custom timestamp format using tracing-subscriber? - Stack Overflow](https://stackoverflow.com/questions/76678749/how-to-set-custom-timestamp-format-using-tracing-subscriber)

  At least one feature of `chrono` and `time` has to be enabled to use time format.

  ```rust
  let timer = tracing_subscriber::fmt::time::ChronoLocal::new("%m-%d %H:%M:%S".to_string());
  ```

What will happen if writer's `write` returns `Err`?

### Filters
[filter](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/index.html):
- [LevelFilter](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/struct.LevelFilter.html)
- [Targets](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/targets/struct.Targets.html)
  - All modules start with the prefix will be filtered (`test` -> `test`, `test_server`, ...), and `test::` doesn't work
  - Default level can be set by string like `=debug`
- [EnvFilter](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/struct.EnvFilter.html)
- [FilterExt](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/trait.FilterExt.html)
  - `and`, `or`, `not`
  - `boxed`
    - Conflicting with `Layer`

## [`tracing_appender`](https://docs.rs/tracing-appender/latest/tracing_appender/)
- [`non_blocking`](https://docs.rs/tracing-appender/latest/tracing_appender/non_blocking/index.html)
  - If `WorkerGuard` is dropped, events will be *silently ignored*.
- To write to files, use [`RollingFileAppender`](https://docs.rs/tracing-appender/latest/tracing_appender/rolling/index.html).
- `RollingFileAppender` will *panic* if it failed to open the log file.

  Example message:
  ```
  initializing rolling file appender failed: InitError { context: "failed to create initial log file", source: Os { code: 5, kind: PermissionDenied, message: "拒绝访问。" } }
  ```

## Serialization
- Store as text and then parse
- Store as JSON

Libraries:
- [tracing-bunyan-formatter: A Layer implementation for tokio-rs/tracing providing Bunyan formatting for events and spans.](https://github.com/LukeMathWalker/tracing-bunyan-formatter)
- [tracing-serde-structured: An alternative, structured, adapter for serializing tracing types using serde](https://github.com/jamesmunns/tracing-serde-structured)

## [tracing-panic: A custom panic hook to capture panic info in your telemetry pipeline](https://github.com/LukeMathWalker/tracing-panic)
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

## Tools
- [tracing-tree](https://github.com/davidbarsky/tracing-tree)
- [tokio-console: a debugger for async rust!](https://github.com/tokio-rs/console)
- OpenTelemetry
  - [Jaeger: open source, distributed tracing platform](https://www.jaegertracing.io/)

[tracing: Provide a GUI/Console-Based Visualization of Spans and Events - Issue #884 - tokio-rs/tracing](https://github.com/tokio-rs/tracing/issues/884)

[\[Ask r/rust\] What is your best way to consume `tracing` logs? : r/rust](https://www.reddit.com/r/rust/comments/153yags/ask_rrust_what_is_your_best_way_to_consume/)