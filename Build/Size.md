# Binary Size
- `opt-level="s"` or `"z"`
- Type erasure

  [fix(driver): erase op type in driver by Berrysoft - Pull Request #348 - compio-rs/compio](https://github.com/compio-rs/compio/pull/348)

[johnthagen/min-sized-rust: 🦀 How to minimize Rust binary size 📦](https://github.com/johnthagen/min-sized-rust)

[Rustlog : Why is a Rust executable large?](https://lifthrasiir.github.io/rustlog/why-is-a-rust-executable-large.html)

[Thoughts on Rust bloat | Raph Levien's blog](https://raphlinus.github.io/rust/2019/08/21/rust-bloat.html)

[Analysis of Rust Crate Sizes on crates.io : r/rust](https://www.reddit.com/r/rust/comments/c9fzyp/analysis_of_rust_crate_sizes_on_cratesio/)

[Rust's Runtime](https://www.ductile.systems/rusts-runtime/)

Tools:
- [cargo-bloat: Find out what takes most of the space in your executable.](https://github.com/RazrFalcon/cargo-bloat)
  - `cargo bloat --release --crates`
  - `cargo bloat --release -n 10`
  - > only 'bin', 'dylib' and 'cdylib' crate types are supported

    [Run on Library Crates - Issue #5 - RazrFalcon/cargo-bloat](https://github.com/RazrFalcon/cargo-bloat/issues/5)
  - [cargo-bloat-action: Track rust binary sizes across builds using Github Actions](https://github.com/orf/cargo-bloat-action/)

[Question about Rust's binary size : r/rust](https://www.reddit.com/r/rust/comments/otam71/question_about_rusts_binary_size/)

[What is making a static library in Rust being much large than Go, Zig, and C#? : r/rust](https://www.reddit.com/r/rust/comments/1inh4vk/what_is_making_a_static_library_in_rust_being/)

[Rust staticlibs and optimizing for size - Rust Internals](https://internals.rust-lang.org/t/rust-staticlibs-and-optimizing-for-size/5746)
