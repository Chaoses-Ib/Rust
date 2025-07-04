# Extension Traits
[0445-extension-trait-conventions - The Rust RFC Book](https://rust-lang.github.io/rfcs/0445-extension-trait-conventions.html)

i.e. UFCS.

[Discussion: add grammar `trait FooExt for Foo` - language design - Rust Internals](https://internals.rust-lang.org/t/discussion-add-grammar-trait-fooext-for-foo/20937)

[Rust extension traits, greppability and IDEs - Eli Bendersky's website](https://eli.thegreenplace.net/2022/rust-extension-traits-greppability-and-ides/)
- [Rust extension traits, greppability and IDEs : r/rust](https://www.reddit.com/r/rust/comments/sfq6hw/rust_extension_traits_greppability_and_ides/)

## Implementations
Generally don't play very well with macro attributes. 食之无味，弃之可惜。

- Trait + default implementation
  - Doesn't work with method-level macros

- [taiki-e/easy-ext: A lightweight attribute macro for easily writing extension trait pattern.](https://github.com/taiki-e/easy-ext)
  - [Support trait or implementation-only attributtes like \`tracing::instrument\` - Issue #41 - taiki-e/easy-ext](https://github.com/taiki-e/easy-ext/issues/41)

  ```rust
  use easy_ext::ext;

  #[ext(ResultExt)]
  pub impl<T, E> Result<T, E> {
      fn err_into<U>(self) -> Result<T, U>
      where
          E: Into<U>,
      {
          self.map_err(Into::into)
      }
  }
  ```

- [davidpdrsn/extend: Create extensions for types you don't own with extension traits but without the boilerplate](https://github.com/davidpdrsn/extend)
  - > The name of the generated extension trait. Example: `#[ext(name = MyExt)]`. By default we generate a name based on what you extend.
  - `#[ext(supertraits = Default + Clone)]` instead of just `where Self: ...`
  - [Support attribute macros that should only be applied to the function implementation - Issue #25](https://github.com/davidpdrsn/extend/issues/25)

- [danielhenrymantilla/ext-trait.rs: Annotation to easily define ad-hoc / one-shot extension traits](https://github.com/danielhenrymantilla/ext-trait.rs) (`ext-trait`, `extension-traits`)
  - [after updating to 2.0 it's impossible to use #\[tracing::instrument\] macro on methods - Issue #7 - danielhenrymantilla/ext-trait.rs](https://github.com/danielhenrymantilla/ext-trait.rs/issues/7)
