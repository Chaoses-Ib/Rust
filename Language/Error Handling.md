# Error Handling
Rust groups errors into two major categories:
- Recoverable
- Unrecoverable

Most languages don’t distinguish between these two kinds of errors and handle both in the same way, using mechanisms such as exceptions. Rust doesn’t have exceptions. Instead, it has the type `Result<T, E>` for recoverable errors and the `panic!` macro that stops execution when the program encounters an unrecoverable error.

- Recoverable by the program: `Result<T, E>` + thiserror

- Recoverable by the user: `Result<T, E>` + anyhow
  - Or not worth writing the program to recover

  如果程序无法处理，结构化和类型就没有意义。

- Unrecoverable: `panic!`

  但 panic 实际上仍可以通过重启线程、进程来 recover。它的真正意义是提供了一种不侵入函数签名的错误处理方式。适用于“这个错误太过于罕见，不值得因它而让 API 变得更加复杂”的场景。

  显而易见，这种划分不会适合所有场景，比如需要处理内存分配失败的程序。常见的解决方案是增加另一套基于 `Result` 的 API，但这也显而易见地会带来新的问题：混乱、重复、复杂。

  panic 是对到处 `Result` 认知成本太高的妥协，不是一个自然的设计。基于块的异常虽然可以解决到处 `Result` 认知成本太高的问题，但是又有隐式的隐患，频繁处理异常也很啰嗦。

## Unrecoverable errors: panic!
By default, panics will print a failure message, unwind, clean up the stack, and quit. By setting the `RUST_BACKTRACE` environment variable to `1`, you can also have Rust display the call stack when a panic occurs to make it easier to track down the source of the panic.

[Item 18: Don't panic - Effective Rust](https://www.lurklurk.org/effective-rust/panic.html)

Panic 仅会结束当前 thread，而不是结束整个 process。
- [rust - How can I cause a panic on a thread to immediately end the main thread? - Stack Overflow](https://stackoverflow.com/questions/35988775/how-can-i-cause-a-panic-on-a-thread-to-immediately-end-the-main-thread)

Handling:
- [std::panic::set_hook](https://doc.rust-lang.org/std/panic/fn.set_hook.html)

  > The panic hook is invoked when a thread panics, but before the panic runtime is invoked. As such, the hook will run with both the aborting and unwinding runtimes.

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

[rayon-rs/either: The enum Either with variants Left and Right is a general purpose sum type with two cases.](https://github.com/rayon-rs/either)

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

  > A trait object based error type for easy idiomatic error handling in Rust applications.

  - [Recommendation on mixing exit codes with anyhow - Issue #247 - dtolnay/anyhow](https://github.com/dtolnay/anyhow/issues/247)

  [Why I use `anyhow::Error` even in libraries - The Rust Programming Language Forum](https://users.rust-lang.org/t/why-i-use-anyhow-error-even-in-libraries/68592)

  Libraries:
  - [eyre: A trait object based error handling type for easy idiomatic error handling and reporting in Rust applications](https://github.com/yaahc/eyre)
- [thiserror: derive(Error) for struct and enum error types](https://github.com/dtolnay/thiserror)
- [Quick Error: A rust-macro which makes errors easy to write](https://github.com/tailhook/quick-error)
- [errgo: Generate enum variants inline](https://github.com/aatifsyed/errgo)

  [err-as-you-go crate - anyhow meets thiserror : r/rust](https://www.reddit.com/r/rust/comments/11udxy8/errasyougo_crate_anyhow_meets_thiserror/)
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

[Operator expressions - The Rust Reference](https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-question-mark-operator)
> The question mark operator (`?`) unwraps valid values or returns erroneous values, propagating them to the calling function. It is a unary postfix operator that can only be applied to the types `Result<T, E>` and `Option<T>`.
> 
> When applied to values of the `Result<T, E>` type, it propagates errors. If the value is `Err(e)`, then it will return `Err(From::from(e))` from the enclosing function or closure. If applied to `Ok(x)`, then it will unwrap the value to evaluate to `x`.

[How to create an Error impl that can be converted to without `map_err` boilerplate - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/how-to-create-an-error-impl-that-can-be-converted-to-without-map-err-boilerplate/64391?u=detly)
- [Can thiserror be converted into from arbitrary errors? - Issue #154 - dtolnay/thiserror](https://github.com/dtolnay/thiserror/issues/154)
- [Conversion to anyhow - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/conversion-to-anyhow/54696)
> Using `?` is not like, say, deref coercion where the compiler just adds as many as it needs to make a thing compile. In all of my examples, I need a chain of **two** conversions to get from the function's error to my custom error, that is:
> ```
> (function's error) -> Box<dyn Error ...> -> (custom error)
> ```
> The `?` operator will only automate one level of this.
>
> The way I ended up doing this was (a) make a new associated type for event sources with the trait bound `Into<Box<dynError+Sync+Send>>` (note the `Into`!) and adjusting internal event loop code to accomodate this. It has turned out to be quite a useful interface and does not prevent implementors from using fully structured errors *or* eg. anyhow.

> Note that `anyhow::Error` doesn't actually implement `Error` precisely for this reason. You could possibly try opting for a similar solution. Alternatively, might it be possible to arrange things so that the user-defined callbacks always return a `Result<T, Box<dyn std::error::Error + Sync + Send>>`, which is then converted to your error type in your code where I assume the callback is actually called?

`r?` →：
- `r.context("")?`
- `r.map_err(anyhow::Error::from)?`
- `r.map_err(anyhow::Error::new)?`
- `r.map_err(|e| anyhow!(e))?`
- `r.map_err(|e| e.into())?`
- [Explicit constructor from Box<dyn Error + Send + Sync> - Issue #83 - dtolnay/anyhow](https://github.com/dtolnay/anyhow/issues/83)
- How about `r.anyhow()?`

  Typing `.any` + <kbd>Tab</kbd> is much easier than `.map_` + <kbd>Tab</kbd> + `anyh` + <kbd>Tab</kbd> + `::E` + <kbd>Tab</kbd> + `::f` (+ <kbd>Backspace</kbd> + <kbd>→</kbd> + <kbd>Backspace</kbd>*2 to delete `(value)`).

  ```rust
  pub trait Anyhow<T> {
      fn anyhow(self) -> anyhow::Result<T>;
  }

  impl<T, E> Anyhow<T> for std::result::Result<T, E>
  where
      E: std::error::Error + Send + Sync + 'static,
  {
      fn anyhow(self) -> anyhow::Result<T> {
          match self {
              Ok(value) => Ok(value),
              Err(e) => Err(e.into()),
          }
      }
  }
  ```
  - [Add `to_anyhow()` Result method. - Issue #312 - dtolnay/anyhow](https://github.com/dtolnay/anyhow/issues/312)
  - [ToAnyhow in zellij\_utils::errors - Rust](https://docs.rs/zellij-utils/latest/zellij_utils/errors/trait.ToAnyhow.html) ([GitHub](https://github.com/zellij-org/zellij/blame/main/zellij-utils/src/errors.rs#L779))

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

## Retry
- [backon: Retry with backoff without effort.](https://github.com/Xuanwo/backon)
  - [ConstantBuilder](https://docs.rs/backon/0.5.0/backon/struct.ConstantBuilder.html): delay, max times, jitter
  - Wasm

  [backon: Maybe the most elegant retry library ever : r/rust](https://www.reddit.com/r/rust/comments/10wodyu/backon_maybe_the_most_elegant_retry_library_ever/)

- [backoff: Exponential backoff and retry for Rust.](https://github.com/ihrwein/backoff) (discontinued)
  - Wasm

- [retrying: Retry macros for rust functions](https://github.com/dintegrity/retrying)

- Async-only
  - [tryhard: 💫 Easily retry futures 🦀](https://github.com/EmbarkStudios/tryhard)
  - [rust-tokio-retry: Extensible, asynchronous retry behaviours for futures/tokio](https://github.com/srijs/rust-tokio-retry) (discontinued)
    - [tokio-retry2](https://github.com/naomijub/tokio-retry) ([r/rust](https://www.reddit.com/r/rust/comments/1fk52o4/tokioretry2/?))
  - [futures-retry - GitLab](https://gitlab.com/mexus/futures-retry)
  - [again: ♻️ Retry faillible Rustlang std library futures](https://github.com/softprops/again)
  - [fure: Retrying futures using different policies](https://github.com/Leonqn/fure)

- Sync-only
  - [retry: A Rust library to retry some code until its return value satisfies a condition.](https://github.com/jimmycuadra/retry) (inactive)
    - [Fixed](https://docs.rs/retry/latest/retry/delay/struct.Fixed.html): delay, max times by `take()`, jitter by `map()`
    - [async support - Issue #41 - jimmycuadra/retry](https://github.com/jimmycuadra/retry/issues/41)
  - [waitfor: Retry a function until it succeeds, errors out, or a timeout/deadline is reached.](https://github.com/d-e-s-o/waitfor)

- [retry-policies: A collection of plug-and-play retry policies for Rust projects.](https://github.com/TrueLayer/retry-policies)
- [exponential-backoff: Exponential backoff generator with jitter.](https://github.com/yoshuawuyts/exponential-backoff)

Discussions:
- 2022-01 [Is there a retry / exponential backoff crate with these features? : r/rust](https://www.reddit.com/r/rust/comments/s8kry6/is_there_a_retry_exponential_backoff_crate_with/)

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