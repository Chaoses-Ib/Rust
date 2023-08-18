# Chrono
- [std::time](https://doc.rust-lang.org/std/time/index.html)
- [chrono: Date and time library for Rust](https://github.com/chronotope/chrono) ([Docs.rs](https://docs.rs/chrono/latest/chrono/))

[What timestamp format is 48 bits / 6 bytes long? - Stack Overflow](https://stackoverflow.com/questions/56621877/what-timestamp-format-is-48-bits-6-bytes-long)

## Windows
- [filetime: Accessing file timestamps in a platform-agnostic fashion in Rust](https://github.com/alexcrichton/filetime)
- [win32_filetime_utils: Conversion utils from, and to Windows's FILETIME, SYSTEMTIME, etc ...](https://docs.rs/crate/win32_filetime_utils/0.2.1/source/src/lib.rs)
- [filetime_win: Windows FILETIME and SYSTEMTIME string and binary serialization](https://docs.rs/filetime_win/latest/filetime_win/index.html)

From [`FILETIME`](https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-filetime) to `std::time::SystemTime`:
```rust
use std::time::{SystemTime, Duration};

pub fn system_time_from_file_time(file_time: i64) -> SystemTime {
    const NANOS_PER_SEC: u64 = 1_000_000_000;
    const INTERVALS_PER_SEC: u64 = NANOS_PER_SEC / 100;
    const INTERVALS_TO_UNIX_EPOCH: u64 = 11_644_473_600 * INTERVALS_PER_SEC;

    SystemTime::UNIX_EPOCH
        .checked_add(Duration::from_nanos((file_time as u64 - INTERVALS_TO_UNIX_EPOCH) * 100))
        // `SystemTime` is just a wrapper to `FILETIME`, so the result must can
        // be represented in `SystemTime`.
        .unwrap()
}
```