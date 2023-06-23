# Error Handling
Rust groups errors into two major categories:
- Recoverable
- Unrecoverable

Most languages don’t distinguish between these two kinds of errors and handle both in the same way, using mechanisms such as exceptions. Rust doesn’t have exceptions. Instead, it has the type `Result<T, E>` for recoverable errors and the `panic!` macro that stops execution when the program encounters an unrecoverable error.

## Unrecoverable errors: panic!
By default, panics will print a failure message, unwind, clean up the stack, and quit. By setting the `RUST_BACKTRACE` environment variable to `1`, you can also have Rust display the call stack when a panic occurs to make it easier to track down the source of the panic.

Panic 仅会结束当前 thread，而不是结束整个 process。
- [rust - How can I cause a panic on a thread to immediately end the main thread? - Stack Overflow](https://stackoverflow.com/questions/35988775/how-can-i-cause-a-panic-on-a-thread-to-immediately-end-the-main-thread)

Handling:
- [std::panic::set_hook](https://doc.rust-lang.org/std/panic/fn.set_hook.html)
- [std::panic::catch_unwind](https://doc.rust-lang.org/std/panic/fn.catch_unwind.html)

## Recoverable errors: Result
[std::result](https://doc.rust-lang.org/std/result/index.html)
```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

### Error
[std::error::Error](https://doc.rust-lang.org/std/error/trait.Error.html)
```rust
pub trait Error: Debug + Display {
    // The lower-level source of this error, if any.
    fn source(&self) -> Option<&(dyn Error + 'static)> { ... }

    // Deprecated since 1.42.0: use the Display impl or to_string().
    // Error messages are typically concise lowercase sentences without trailing punctuation.
    fn description(&self) -> &str { ... }

    // Deprecated since 1.33.0: replaced by Error::source, which can support downcasting.
    fn cause(&self) -> Option<&dyn Error> { ... }

    // Provides type based access to context intended for error reports.
    fn provide<'a>(&'a self, demand: &mut Demand<'a>) { ... }
}
```

- [anyhow: Flexible concrete Error type built on std::error::Error](https://github.com/dtolnay/anyhow)
  - [eyre: A trait object based error handling type for easy idiomatic error handling and reporting in Rust applications](https://github.com/yaahc/eyre)
- [thiserror: derive(Error) for struct and enum error types](https://github.com/dtolnay/thiserror)
- [Quick Error: A rust-macro which makes errors easy to write](https://github.com/tailhook/quick-error)
- [rust-lang-deprecated/failure: Error management](https://github.com/rust-lang-deprecated/failure)
- [rust-lang-deprecated/error-chain: Error boilerplate for Rust](https://github.com/rust-lang-deprecated/error-chain)

### Propagating errors
```rust
use std::fs::File;
use std::io::{self, Read};

fn read_username_from_file() -> Result<String, io::Error> {
    let username_file_result = File::open("hello.txt");

    let mut username_file = match username_file_result {
        Ok(file) => file,
        Err(e) => return Err(e),
    };

    let mut username = String::new();

    match username_file.read_to_string(&mut username) {
        Ok(_) => Ok(username),
        Err(e) => Err(e),
    }
}
```

Or use the `?` operator:
```rust
use std::fs::File;
use std::io;
use std::io::Read;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut username_file = File::open("hello.txt")?;
    let mut username = String::new();
    username_file.read_to_string(&mut username)?;
    Ok(username)
}
```

`main` can also return a `Result<(), E>`:
```rust
use std::error::Error;
use std::fs::File;

fn main() -> Result<(), Box<dyn Error>> {
    let greeting_file = File::open("hello.txt")?;
    
    Ok(())
}
```

## Stack traces
[backtrace-rs: Backtraces in Rust](https://github.com/rust-lang/backtrace-rs)
