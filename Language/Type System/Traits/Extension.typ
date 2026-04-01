#import "@local/ib:0.1.0": *
#title[Extension Traits]
#a[0445-extension-trait-conventions - The Rust RFC Book][https://rust-lang.github.io/rfcs/0445-extension-trait-conventions.html]

i.e. UFCS.

#a[Discussion: add grammar `trait FooExt for Foo` - language design - Rust Internals][https://internals.rust-lang.org/t/discussion-add-grammar-trait-fooext-for-foo/20937]

#a[Rust extension traits, greppability and IDEs - Eli Bendersky's website][https://eli.thegreenplace.net/2022/rust-extension-traits-greppability-and-ides/]
#a-badge[https://www.reddit.com/r/rust/comments/sfq6hw/rust_extension_traits_greppability_and_ides/]

= Concrete type extensions
Slightly different from extensions for generic types / traits,
extensions for concrete types can only access the type in ```rs impl```.
This makes it impossible to implement the extension purely via trait + default implementation.

Workarounds:
- #a[```rs Deref<Target = T>```][https://doc.rust-lang.org/std/ops/trait.Deref.html#implementors]
  #footnote[#a[How does Rust standard implements `Deref` trait for i32? - help - The Rust Programming Language Forum][https://users.rust-lang.org/t/how-does-rust-standard-implements-deref-trait-for-i32/102729]]
  / ```rs AsRef<T>```:
  Only work for ```rs &T```, not ```rs T```.
  #footnote[#a[How to make generic function accept both owned and borrowed types? - help - The Rust Programming Language Forum][https://users.rust-lang.org/t/how-to-make-generic-function-accept-both-owned-and-borrowed-types/37591]]

- A ```rs as_t()``` common method.

- An assert trait.
  #footnote[#a[`Ext` type trait and concrete types - help - The Rust Programming Language Forum][https://users.rust-lang.org/t/ext-type-trait-and-concrete-types/51450]]
  ```rs
  trait AssertType {
      type Is:?Sized;
      fn cast(self)->Self::Is where Self:Sized, Self::Is:Sized;
      fn cast_ref(&self)->&Self::Is;
      fn cast_mut(&mut self)->&mut Self::Is;
      
      fn cast_from(_:Self::Is)->Self where Self:Sized, Self::Is:Sized;
      fn cast_from_ref(_:&Self::Is)->&Self;
      fn cast_from_mut(_:&mut Self::Is)->&mut Self;
  }

  impl<T: ?Sized> AssertType for T {
      type Is = T;
      fn cast(self)->T where T:Sized { self }
      fn cast_ref(&self)->&T { self }
      fn cast_mut(&mut self)->&mut T { self }
      
      fn cast_from(x:T)->Self where T:Sized { x }
      fn cast_from_ref(x:&T)->&Self { x }
      fn cast_from_mut(x:&mut T)->&mut Self { x }
  }

  trait MyTrait<T> {
      fn method(&self) where T: AssertType<Is=bool> {
          /* ... */
      }
  }
  ```

= Implementations
Generally don't play very well with macro attributes. 食之无味，弃之可惜。

- Trait + default implementation
  - Doesn't work with method-level macros

- #a[taiki-e/easy-ext: A lightweight attribute macro for easily writing extension trait pattern.][https://github.com/taiki-e/easy-ext]
  - #a[Support trait or implementation-only attributtes like `tracing::instrument` - Issue \#41][https://github.com/taiki-e/easy-ext/issues/41]

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

- #a[davidpdrsn/extend: Create extensions for types you don't own with extension traits but without the boilerplate][https://github.com/davidpdrsn/extend]
  - > The name of the generated extension trait. Example: `#[ext(name = MyExt)]`. By default we generate a name based on what you extend.
  - `#[ext(supertraits = Default + Clone)]` instead of just `where Self: ...`
  - #a[Support attribute macros that should only be applied to the function implementation - Issue \#25][https://github.com/davidpdrsn/extend/issues/25]

- #a[danielhenrymantilla/ext-trait.rs: Annotation to easily define ad-hoc / one-shot extension traits][https://github.com/danielhenrymantilla/ext-trait.rs]
  (`ext-trait`, `extension-traits`)
  - #a[after updating to 2.0 it's impossible to use `#[tracing::instrument]` macro on methods - Issue \#7][https://github.com/danielhenrymantilla/ext-trait.rs/issues/7]
