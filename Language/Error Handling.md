# Error Handling
Rust groups errors into two major categories:
- Recoverable
- Unrecoverable

Most languages don’t distinguish between these two kinds of errors and handle both in the same way, using mechanisms such as exceptions. Rust doesn’t have exceptions. Instead, it has the type `Result<T, E>` for recoverable errors and the `panic!` macro that stops execution when the program encounters an unrecoverable error.

## Unrecoverable errors: panic!
By default, panics will print a failure message, unwind, clean up the stack, and quit. By setting the `RUST_BACKTRACE` environment variable to `1`, you can also have Rust display the call stack when a panic occurs to make it easier to track down the source of the panic.

[Item 18: Don't panic - Effective Rust](https://www.lurklurk.org/effective-rust/panic.html)

Panic 仅会结束当前 thread，而不是结束整个 process。
- [rust - How can I cause a panic on a thread to immediately end the main thread? - Stack Overflow](https://stackoverflow.com/questions/35988775/how-can-i-cause-a-panic-on-a-thread-to-immediately-end-the-main-thread)

Handling:
- [std::panic::set_hook](https://doc.rust-lang.org/std/panic/fn.set_hook.html)
- [std::panic::catch_unwind](https://doc.rust-lang.org/std/panic/fn.catch_unwind.html)
- [std::thread::panicking](https://doc.rust-lang.org/std/thread/fn.panicking.html)

只处理特定线程的 panic：
- `set_hook` 并在 hook 中识别 [`ThreadId`](https://doc.rust-lang.org/std/thread/struct.ThreadId.html)。
- 在目标线程中初始化一个变量，在它的 drop 实现中通过 `thread::panicking` 来检测 panic。

Unwinding:
- [How does Rust know whether to run the destructor during stack unwind? - Stack Overflow](https://stackoverflow.com/questions/39750841/how-does-rust-know-whether-to-run-the-destructor-during-stack-unwind)

[no-panic as a language feature - Issue #49 - rust-lang/project-error-handling](https://github.com/rust-lang/project-error-handling/issues/49)

[Should we add an panic interface that reports the error via the panic handler but unconditionally aborts? - Issue #34 - rust-lang/project-error-handling](https://github.com/rust-lang/project-error-handling/issues/34)

### Aborting panics
A panic in Rust is not always implemented via unwinding, but can be implemented by aborting the process as well. This function only catches unwinding panics, not those that abort the process.

- Stack overflow

  [Great stack overflow error messages - Issue #51405 - rust-lang/rust](https://github.com/rust-lang/rust/issues/51405)

  [How to diagnose a `stack overflow` issue's cause? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/how-to-diagnose-a-stack-overflow-issues-cause/17320)

  [How can I catch a stack overflow in a Rust child thread? - Stack Overflow](https://stackoverflow.com/questions/68029361/how-can-i-catch-a-stack-overflow-in-a-rust-child-thread)

- [`std::alloc::handle_alloc_error`](https://doc.rust-lang.org/std/alloc/fn.handle_alloc_error.html)
  
  > If the binary links against `std` (typically the case), then print a message to standard error and abort the process. This behavior can be replaced with [`set_alloc_error_hook`](https://doc.rust-lang.org/std/alloc/fn.set_alloc_error_hook.html) and [`take_alloc_error_hook`](https://doc.rust-lang.org/std/alloc/fn.take_alloc_error_hook.html). Future versions of Rust may panic by default instead.

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

### Check and wrap `unwrap()`
`Vec<Option<_>>`:
```rust
let options: Vec<Option<_>>;
if options
    .iter()
    .any(|option| option.is_none())
{
    return false;
}
// fn options<'a>(
//     self: &'a mut Self,
// ) -> impl Iterator<Item = &'a mut Vec<InternalSearchResult>> {
//     self
//         .options
//         .iter_mut()
//         .map(|option| option.as_mut().unwrap())
// }
macro_rules! options {
    ($session:expr) => {
        $self
            .options
            .iter_mut()
            .map(|option| option.as_mut().unwrap())
    };
}
```

## Stack traces
- [std::backtrace](https://doc.rust-lang.org/std/backtrace/index.html) (v1.65)
- [backtrace-rs: Backtraces in Rust](https://github.com/rust-lang/backtrace-rs) (v1.40)
  - [Please report MSRV in README and add a CI job to check compatibility - Issue #336](https://github.com/rust-lang/backtrace-rs/issues/336)

## Process termination
`exit` 会在做一些清理后正常退出，但 `abort` 会直接用异常指令让程序崩溃：
```rust
pub fn exit(code: i32) -> ! {
    crate::rt::cleanup() {
        static CLEANUP: Once = Once::new();
        CLEANUP.call_once(|| unsafe {
            // Flush stdout and disable buffering.
            crate::io::cleanup() {
                let mut initialized = false;
                let stdout = STDOUT.get_or_init(|| {
                    initialized = true;
                    ReentrantMutex::new(RefCell::new(LineWriter::with_capacity(0, stdout_raw())))
                });

                if !initialized {
                    // The buffer was previously initialized, overwrite it here.
                    // We use try_lock() instead of lock(), because someone
                    // might have leaked a StdoutLock, which would
                    // otherwise cause a deadlock here.
                    if let Some(lock) = stdout.try_lock() {
                        *lock.borrow_mut() = LineWriter::with_capacity(0, stdout_raw());
                    }
                }
            }
            // SAFETY: Only called once during runtime cleanup.
            sys::cleanup() {
                net::cleanup() {
                    // only perform cleanup if network functionality was actually initialized
                    if let Some(cleanup) = WSA_CLEANUP.get() {
                        unsafe {
                            cleanup();
                        }
                    }
                }
            }
        });
    }
    crate::sys::os::exit(code)
}

pub fn abort() -> ! {
    crate::sys::abort_internal() {
        #[allow(unused)]
        const FAST_FAIL_FATAL_APP_EXIT: usize = 7;
        #[cfg(not(miri))] // inline assembly does not work in Miri
        unsafe {
            cfg_if::cfg_if! {
                if #[cfg(any(target_arch = "x86", target_arch = "x86_64"))] {
                    core::arch::asm!("int $$0x29", in("ecx") FAST_FAIL_FATAL_APP_EXIT);
                    crate::intrinsics::unreachable();
                } else if #[cfg(all(target_arch = "arm", target_feature = "thumb-mode"))] {
                    core::arch::asm!(".inst 0xDEFB", in("r0") FAST_FAIL_FATAL_APP_EXIT);
                    crate::intrinsics::unreachable();
                } else if #[cfg(target_arch = "aarch64")] {
                    core::arch::asm!("brk 0xF003", in("x0") FAST_FAIL_FATAL_APP_EXIT);
                    crate::intrinsics::unreachable();
                }
            }
        }
        crate::intrinsics::abort();
    }
}
```

Windows:
- Both `exit()` and `abort()` cannot guarantee the process to be immediately killed on Windows, only `TerminateProcess()` works.
- `abort()` will exit the process with code 0xC000001D (-1073741795).

[rust - When is `std::process::exit` O.K. to use? - Stack Overflow](https://stackoverflow.com/questions/39228685/when-is-stdprocessexit-o-k-to-use)