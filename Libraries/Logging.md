# Logging
- [log: Logging implementation for Rust](https://github.com/rust-lang/log)
  ```rust
  #[cfg(not(test))] 
  use log::{error, warn, info, debug, trace};

  #[cfg(test)]
  use std::{eprintln as error, eprintln as warn, eprintln as info, eprintln as debug, eprintln as trace};
  ```

  - [fern: Simple, efficient logging for Rust](https://github.com/daboross/fern)
  - [win_dbg_logger](https://docs.rs/win_dbg_logger/*/win_dbg_logger/)