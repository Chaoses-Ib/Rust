#import "@local/ib:0.1.0": *
#title[Cargo Cache]
= Build cache
#a[Build Cache - The Cargo Book][https://doc.rust-lang.org/cargo/reference/build-cache.html]
- `build-dir`: path of where to place intermediate build artifacts.
  - `CARGO_BUILD_BUILD_DIR`, `build.build-dir`
- `target-dir`: path of where to place final build artifacts.
  - `CARGO_TARGET_DIR`, `build.target-dir`, `--target-dir`

#q[By default, both directories point to a directory named `target` in the root of your workspace.]

== `build-dir`
Path of where to place intermediate build artifacts.

`build-dir` was laid out like:
- `target/`
  - `<target-platform>/`?
    - `<profile>/`
      - `incremental/`
      - `build/`
        - `<package>-<hash>/`
          - `build*script-*`
      - `deps/`
        - `<package>-<hash>*`

Issues:
- #a[cargo ./target fills with outdated artifacts as toolchains are updated/changed - Issue \#5026][https://github.com/rust-lang/cargo/issues/5026]
- #a[More granular locking in cargo_rustc - Issue \#4282][https://github.com/rust-lang/cargo/issues/4282]
- #a[Per-user compiled artifact cache - Issue \#5931][https://github.com/rust-lang/cargo/issues/5931]

These could be aided by re-arranging the `build-dir` to be organized around `<package>-<hash>`, like:
- `target/`
  - `<target-platform>/`?
    - `<profile>/`
      - `incremental/`
      - `build/`
        - `<package>-<hash>/`
          - `build*script-*`
          - `*.d`

#a[Re-organize build-dir by package + hash, rather than artifact type - Issue \#15010][https://github.com/rust-lang/cargo/issues/15010]

=== `RUSTFLAGS`
#a[Reconsider RUSTFLAGS artifact caching. - Issue \#8716][https://github.com/rust-lang/cargo/issues/8716]
- #a[fix(fingerprint): Don't throwaway the cache on RUSTFLAGS changes by epage - Pull Request \#14830][https://github.com/rust-lang/cargo/pull/14830]

== `target-dir`
Path of where to place final build artifacts.

#a[Redefine `CARGO_TARGET_DIR` to be only an artifacts directory - Issue \#14125][https://github.com/rust-lang/cargo/issues/14125]

#q[We'd need a separate lock for the artifact directory though `cargo check` and `cargo clippy` shouldn't need that.]
- #a[Do not lock the `artifact-dir` for check builds by ranger-ross - Pull Request \#16230][https://github.com/rust-lang/cargo/pull/16230]

== `artifact-dir`
