# I/O
[std::io](https://doc.rust-lang.org/nightly/std/io/index.html)

- `StringWriter`
  - `Vec<u8>`
  - [`arrow::StringWriter`](https://github.com/apache/arrow-rs/blob/1fa7afdb84857e10b8749be01b8fb3fae09baf93/arrow/src/util/string_writer.rs)
  - [`tracing_test::MockWriter`](https://github.com/dbrgn/tracing-test/blob/0ed1c1ca42f0224a75070a7d7425ec1a2270dfd0/tracing-test/src/subscriber.rs)

  [How do I write to an in-memory buffered String? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/how-do-i-write-to-an-in-memory-buffered-string/45035)

- [tracing-fmt-smart-writer: Better writer for tracing-subscriber's fmt module](https://github.com/DoumanAsh/tracing-fmt-smart-writer)

## Stdio
[Stdio in std::process - Rust](https://doc.rust-lang.org/std/process/struct.Stdio.html)

[How do I print output without a trailing newline in Rust? - Stack Overflow](https://stackoverflow.com/questions/37531903/how-do-i-print-output-without-a-trailing-newline-in-rust)

[Reading from a processes stdout without placing it all in memory at once - Stack Overflow](https://stackoverflow.com/questions/32012986/reading-from-a-processes-stdout-without-placing-it-all-in-memory-at-once)

[How to capture the content of stdout/stderr when I cannot change the code that prints? - Stack Overflow](https://stackoverflow.com/questions/72185130/how-to-capture-the-content-of-stdout-stderr-when-i-cannot-change-the-code-that-p)

[How do I read the output of a child process without blocking in Rust? - Stack Overflow](https://stackoverflow.com/questions/34611742/how-do-i-read-the-output-of-a-child-process-without-blocking-in-rust)

[Display *and* capture STDOUT and STDERR from a Command - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/display-and-capture-stdout-and-stderr-from-a-command/81296)