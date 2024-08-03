# Files
- [glob: Support for matching file paths against Unix shell style patterns.](https://github.com/rust-lang/glob)
  - [`require_literal_separator == require_literal_leading_dot == false` by default](https://docs.rs/glob/latest/glob/struct.MatchOptions.html)
- [fs\_extra: Expanding opportunities standard library std::fs and std::io](https://github.com/webdesus/fs_extra)
  - Copy files (optionally with information about the progress).
  - Copy directories recursively (optionally with information about the progress).
    - Cofusing options.
    - `to` must exist (`std::fs::create_dir_all(&to).unwrap()`)
  - Move files (optionally with information about the progress).
  - Move directories recursively (optionally with information about the progress).
  - A single method for create and write `String` content in file.
  - A single method for open and read `String` content from file.
  - Get folder size
  - Get collection of directory entries
- [copy\_dir: Copy a directory recursively in Rust](https://github.com/mdunsmuir/copy_dir) (discontinued)
- [tempfile: Temporary file library for rust](https://github.com/Stebalien/tempfile)

## Paths
- [std::path](https://doc.rust-lang.org/std/path/index.html)
- [camino: Like Rust's `std::path::Path`, but UTF-8.](https://github.com/camino-rs/camino)
- [directories-rs: a mid-level library that provides config/cache/data paths, following the respective conventions on Linux, macOS and Windows](https://github.com/dirs-dev/directories-rs#basedirs)