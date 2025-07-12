# rustdoc
[The rustdoc book](https://doc.rust-lang.org/rustdoc/what-is-rustdoc.html)

A documentation generator with bad documentation.

`cargo doc`

- Bare URLs are not automatically turned into clickable links

  ...feels stupid.

```toml
[features]
doc = ["dep:document-features"]

[dependencies]
document-features = { version = "0.2", optional = true }

[package.metadata.docs.rs]
# We want to document all features.
all-features = true
# Since this crate's feature setup is pretty complicated, it is worth opting
# into a nightly unstable option to show the features that need to be enabled
# for public API items. To do that, we set 'docsrs', and when that's enabled,
# we enable the 'doc_auto_cfg' feature.
#
# To test this locally, run:
# ```
# RUSTDOCFLAGS="--cfg docsrs" cargo +nightly doc --all-features
# $env:RUSTDOCFLAGS="--cfg docsrs"; cargo +nightly doc --all-features
# ```
rustdoc-args = ["--cfg", "docsrs"]
```
```rust
//! ## Features
#![cfg_attr(docsrs, feature(doc_auto_cfg))]
#![cfg_attr(feature = "doc", doc = document_features::document_features!())]
```

## Features
- Conditional compilation: [`#[cfg(doc)]`](https://doc.rust-lang.org/rustdoc/advanced-features.html#cfgdoc-documenting-platform-specific-or-feature-specific-information)

  > For conditional compilation, Rustdoc treats your crate the same way the compiler does. Only things from the host target are available (or from the given `--target` if present), and everything else is "filtered out" from the crate. This can cause problems if your crate is providing different things on different targets and you want your documentation to reflect all the available items you provide.
  > 
  > If you want to make sure an item is seen by Rustdoc regardless of what platform it's targeting, you can apply `#[cfg(doc)]` to it. Rustdoc sets this whenever it's building documentation, so anything that uses that flag will make it into documentation it generates. To apply this to an item with other `#[cfg]` filters on it, you can write something like `#[cfg(any(windows, doc))]`. This will preserve the item either when built normally on Windows, or when being documented anywhere.

  `#[cfg(any(windows, doc))]`

  Feels stupid.

- Feature-gated item documentation
  - [`#[doc_cfg]`](https://doc.rust-lang.org/beta/unstable-book/language-features/doc-cfg.html)
    - `#[cfg_attr(docsrs, doc(cfg(any(feature = "alloc", feature = "std"))))]`

    Feels stupid.

  - Tells rustdoc to automatically generate `#[doc(cfg(...))]`: `#[doc_auto_cfg]`
  
    `#![cfg_attr(docsrs, feature(doc_auto_cfg))]`

    [rustdoc `doc_auto_cfg` incorrectly picks up cfg's - Issue #90497 - rust-lang/rust](https://github.com/rust-lang/rust/issues/90497)

  [Tracking issue for `#[doc(cfg(…))]`, `#[doc(cfg_hide(…))]` and `doc_auto_cfg` - Issue #43781 - rust-lang/rust](https://github.com/rust-lang/rust/issues/43781)

  [Split `doc_cfg` and `doc_auto_cfg` features by GuillaumeGomez - Pull Request #90502 - rust-lang/rust](https://github.com/rust-lang/rust/pull/90502)

  [Switch to `doc_auto_cfg` by pitdicker - Pull Request #1305 - chronotope/chrono](https://github.com/chronotope/chrono/pull/1305)

- Features documentation
  - [slint-ui/document-features: Extract documentation for the feature flags from comments in Cargo.toml](https://github.com/slint-ui/document-features)
    - Append to `lib.rs` docs (without a title)
    - Must be a dependency?

      `optional = true` + `features = ["document-features",` / `all-features = true`
    - `#![cfg_attr(feature = "doc", doc = document_features::document_features!())]`
    - Only documented (`##`) features will be displayed

    e.g. [`ib_matcher`](https://docs.rs/ib-matcher/latest/ib_matcher/#features), [`slint::docs::cargo_features`](https://docs.rs/slint/latest/slint/docs/cargo_features/index.html)

- Nightly
  - `#[cfg_attr(docsrs)]`

    [Document/standardize the `docsrs` "well-known" feature - Issue #13875 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/13875)
    > The cfg attribute was used just to conditionally include the `doc_cfg` feature so that it is only present in docs.rs builds and not require nightly on a daily basis. When adding this I found no mention or whatever about any requirements for the name of the additional cfg flag used for this guard. It looked like `docsrs` is most widely used (eg. by tokio).

    ```toml
    [package.metadata.docs.rs]
    # We want to document all features.
    all-features = true
    # Since this crate's feature setup is pretty complicated, it is worth opting
    # into a nightly unstable option to show the features that need to be enabled
    # for public API items. To do that, we set 'docsrs', and when that's enabled,
    # we enable the 'doc_auto_cfg' feature.
    #
    # To test this locally, run:
    # ```
    # RUSTDOCFLAGS="--cfg docsrs" cargo +nightly doc --all-features
    # $env:RUSTDOCFLAGS="--cfg docsrs"; cargo +nightly doc --all-features
    # ```
    rustdoc-args = ["--cfg", "docsrs"]
    ```
    `$env:RUSTDOCFLAGS="--cfg docsrs"; cargo +nightly doc --all-features`

    [Use `docsrs` attribute to indicate feature-gated items in documentation - Issue #986 - rust-random/rand](https://github.com/rust-random/rand/issues/986)

- `cargo doc`

  [There is currently no way to specify features automatically when using `cargo doc` - Issue #8905 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/8905)

[How to document optional features in API docs - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/how-to-document-optional-features-in-api-docs/64577/3)

[rust - How to get a feature requirement tag in the documentation generated by `cargo doc`? - Stack Overflow](https://stackoverflow.com/questions/61417452/how-to-get-a-feature-requirement-tag-in-the-documentation-generated-by-cargo-do)

[cargo doc: include all available features in generated docs. - Issue #8103 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/8103)

[Show crate features in rustdoc - Issue #96318 - rust-lang/rust](https://github.com/rust-lang/rust/issues/96318)

## Docs.rs
[Builds](https://docs.rs/about/builds)

`cargo publish` doesn't wait Docs.rs to build.
