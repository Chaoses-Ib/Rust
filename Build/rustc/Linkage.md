# Linkage
[The Rust Reference](https://doc.rust-lang.org/reference/linkage.html)

[Cargo Targets - The Cargo Book](https://doc.rust-lang.org/cargo/reference/cargo-targets.html)

## `staticlib`
[micahsnyder/cmake-rust-demo: A project that demonstrates building a C application with CMake that has Rust static library components](https://github.com/micahsnyder/cmake-rust-demo)

[→CXX](/Language/FFI.md#cxx)

## CRT
[How to link CRT statically when building with MSVC? : r/rust](https://www.reddit.com/r/rust/comments/ekts0d/how_to_link_crt_statically_when_building_with_msvc/)

`.cargo/config.toml`:
```toml
[target.x86_64-pc-windows-msvc]
rustflags = ["-C", "target-feature=+crt-static"]
```

```toml
[target.'cfg(all(target_os = "windows", target_env = "msvc"))']
rustflags = ["-C", "target-feature=+crt-static"]
```

[rustc always links against non-debug Windows runtime - Issue #39016 - rust-lang/rust](https://github.com/rust-lang/rust/issues/39016)
- `$env:CFLAGS=$env:CXXFLAGS='/MTd'`
- [The MSVC CRT library is not overrideable by other build systems - Issue #107570 - rust-lang/rust](https://github.com/rust-lang/rust/issues/107570)
- [Windows MSVC CRT linking - Issue #211 - rust-lang/libs-team](https://github.com/rust-lang/libs-team/issues/211)
- [CXX how to get a MSVCRTD-based debug-build LIB on Windows : r/rust](https://www.reddit.com/r/rust/comments/14wjxih/cxx_how_to_get_a_msvcrtdbased_debugbuild_lib_on/)