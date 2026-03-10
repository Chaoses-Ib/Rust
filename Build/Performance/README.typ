#import "@local/ib:0.1.0": *
#title[Rust Performance]
#a-badge(body: [The Rust Performance Book])[https://nnethercote.github.io/perf-book/]

= Build configuration
#footnote[#a[Build Configuration - The Rust Performance Book][https://nnethercote.github.io/perf-book/build-configuration.html]]
#footnote[#a[Cheap tricks for high-performance Rust - Pascal's Scribbles][https://deterministic.space/high-performance-rust.html]]
#footnote[#a[Compiling for maximum performance : r/rust][https://www.reddit.com/r/rust/comments/lyck1u/compiling_for_maximum_performance/]]

The following `Cargo.toml` settings are recommended if best performance is desired:
```toml
[profile.release]
lto = "fat"
codegen-units = 1
# panic = "abort"
```

Maybe also in `.cargo/config`:
```toml
[build]
rustflags = ["-C", "target-cpu=native"]
```

= Designs
- Keep as much as possible in cache
  - ```rs TypedArena```

- Keep as much as possible in registers

  #q[
  It's worth noting that since Rust restricts pointers more than C does, the ordering restrictions on pointers could be relaxed.
  This hasn't been implemented in LLVM yet since most of the optimization work is based on leveraging the rules of C and C-family languages.]

- Avoid ```rs Box<Trait>```
  - ```rs impl Trait```
  - Variadic generics
  - ```rs &dyn Trait```

- Use stack-based variable-length datatypes

- Loop unrolling is still cool

- ```rs assert!``` conditions beforehand
  - #a[```rs unsafe { core::hint::assert_unchecked(..) }```][https://doc.rust-lang.org/beta/std/hint/fn.assert_unchecked.html]

- Use link-time optimization

  #q[
  Normally, Rust can only inline functions that are either defined in-crate or, in the case of functions in other libraries, have ```rs #[inline]``` specified.
  LTO allows the compiler to inline cross-crate, at the cost of a compile-time speed penalty.
  I am of the opinion that compile times only matter for debug builds, so that's a tradeoff I'm willing to make.
  As with everything else here, profile and check that the tradeoff is worthwhile.]

  #a[`&[u8]` source type is much slower than `&str` - Issue \#541 - maciejhirsz/logos][https://github.com/maciejhirsz/logos/issues/541]

- Don't use ```rs #[inline(always)]```

- Parallelize, but not how you think
  - Data dependencies

#a[jFransham/Rust Optimization: Achieving warp speed with Rust][https://gist.github.com/jFransham/369a86eff00e5f280ed25121454acec1]
