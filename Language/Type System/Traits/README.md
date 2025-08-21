# Traits
## Traits
A **trait** defines functionality a particular type has and can share with other types.

For example:
```rust
pub trait Summary {
    fn summarize(&self) -> String;
}

pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}
```

We can also provide default behavior for some or all of the methods in a trait:
```rust
pub trait Summary {
    fn summarize(&self) -> String {
        String::from("(Read more...)")
    }
}

impl Summary for NewsArticle {}
```
Default implementations can call other methods in the same trait, even if those other methods don’t have a default implementation.
- [RFC: calling default trait methods from overriding impls by adamcrume - Pull Request #3329 - rust-lang/rfcs](https://github.com/rust-lang/rfcs/pull/3329)

由于 Rust 的 generics 不够强大，使用 static dispatch 可能会产生许多 boilerplate code，使用 macros 可以在一定程度上缓解这个问题，但 macros 本身也会引入新的问题。

[A failed experiment with Rust static dispatch - Julio Merino](https://jmmv.dev/2023/08/rust-static-dispatch-failed-experiment.html)
- [A failed experiment with Rust static dispatch : rust](https://www.reddit.com/r/rust/comments/15kdj78/a_failed_experiment_with_rust_static_dispatch/)

### Orphan rule
> Note that we can implement a trait on a type only if at least one of the trait or the type is local to our crate. For example, we can’t implement the `Display` trait on `Vec<T>` within our `aggregator` crate, because `Display` and `Vec<T>` are both defined in the standard library. This restriction is part of a property called _coherence_, and more specifically the _orphan rule_, so named because the parent type is not present. This rule ensures that other people’s code can’t break your code and vice versa. Without the rule, two crates could implement the same trait for the same type, and Rust wouldn’t know which implementation to use.

[Ixrec/rust-orphan-rules: An unofficial, experimental place for documenting and gathering feedback on the design problems around Rust's orphan rules](https://github.com/Ixrec/rust-orphan-rules)

New type pattern:
- [derive_more: Some more derive(Trait) options](https://github.com/JelteF/derive_more)
  - [`#[derive(Deref)]`](https://docs.rs/derive_more/latest/derive_more/derive.Deref.html)
  - [Support for deriveing `Borrow` - Issue #260](https://github.com/JelteF/derive_more/issues/260)
- [shrinkwraprs](https://crates.io/crates/shrinkwraprs) (discontinued)
  - `AsRef<InnerType>, Borrow<InnerType>, Deref<Target=InnerType>`
  - `fn transform<F>(&mut self, mut f: F) -> &mut Self where F: FnMut(&mut InnerType)`
  - `fn siphon<F, T>(self, mut f: F) -> T where F: FnMut(InnerType) -> T`
- [DanielKeep/rust-custom-derive: Custom derivation macro for Rust](https://github.com/DanielKeep/rust-custom-derive) (discontinued)
  - [newtype_derive](https://docs.rs/newtype_derive/latest/newtype_derive/)
- [derive_everything - Rust](https://docs.rs/derive_everything/0.1.2/derive_everything/)
  - `#[derive(Clone, Debug, Default, Eq, Hash, Ord, PartialEq, PartialOrd)]`

[The newtype idiom and trait boilerplate : r/rust](https://www.reddit.com/r/rust/comments/km5np7/the_newtype_idiom_and_trait_boilerplate/)

[`#[repr(transparent)]` + newtype auto-derive? : r/rust](https://www.reddit.com/r/rust/comments/11zcsch/reprtransparent_newtype_autoderive/)

[`#[derive(All)]` - language design - Rust Internals](https://internals.rust-lang.org/t/derive-all/21937)

### Trait bound syntax
We can use **trait bounds** to specify that a generic type can be any type that has certain behavior.

For example:
```rust
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}

pub fn notify<T: Summary + Display>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```

We can also use the `impl Trait` syntax:
```rust
pub fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}

pub fn notify(item: &(impl Summary + Display)) {
    println!("Breaking news! {}", item.summarize());
}
```

Or use a `where` clause:
```rust
pub fn notify<T>(item: &T)
where
    T: Summary + Display
{
    println!("Breaking news! {}", item.summarize());
}
```

[Tracking issue for negative impls - Issue #68318 - rust-lang/rust](https://github.com/rust-lang/rust/issues/68318)

[Add an `assert_not_impl` macro by 197g - Pull Request #17 - nvzqz/static-assertions](https://github.com/nvzqz/static-assertions/pull/17)
- [A macro to assert that a type *does not* implement trait bounds - announcements - The Rust Programming Language Forum](https://users.rust-lang.org/t/a-macro-to-assert-that-a-type-does-not-implement-trait-bounds/31179)

### Higher-rank trait bounds (HRTBs)
[The Rustonomicon](https://doc.rust-lang.org/nomicon/hrtb.html)

- `where for<'a> F: Fn(&'a (u8, u16)) -> &'a u8,`
- `where F: for<'a> Fn(&'a (u8, u16)) -> &'a u8,`

> `for<'a>` can be read as "for all choices of `'a`", and basically produces an *infinite list* of trait bounds that F must satisfy. Intense. There aren't many places outside of the `Fn` traits where we encounter HRTBs, and even for those we have a nice magic sugar for the common cases.

- `Fn`
- `IntoIterator`

  ```rust
  pub fn f<RefIntoIter, Paths, P>(paths: Paths)
  where
      Paths: AsRef<RefIntoIter> + Send + 'static,
      for<'a> &'a RefIntoIter: IntoIterator<Item = &'a P>,
      P: AsRef<Path>,
  {
      ()
  }

  fn test() {
      let paths = vec![PathBuf::from("test.txt")];
      f::<Vec<_>, _, _>(paths);
  }
  ```
  [iterator - Is there a trait supplying `iter()`? - Stack Overflow](https://stackoverflow.com/questions/39675949/is-there-a-trait-supplying-iter)

  [`#[builder]` with higher-rank trait bounds can cause confusing errors - Issue #307 - elastio/bon](https://github.com/elastio/bon/issues/307)

## Trait objects
[The Rust Programming Language](https://doc.rust-lang.org/book/ch17-02-trait-objects.html)

A **trait object** points to both an instance of a type implementing our specified trait and a table used to look up trait methods on that type at runtime.

We create a trait object by specifying some sort of pointer, such as a `&` reference or a `Box<T>` smart pointer, then the `dyn` keyword, and then specifying the relevant trait:
```rust
pub trait Draw {
    fn draw(&self);
}

pub struct Screen {
    pub components: Vec<Box<dyn Draw>>,
}
```

[Implementing an Object-Oriented Design Pattern - The Rust Programming Language](https://doc.rust-lang.org/book/ch17-03-oo-design-patterns.html)

- [Why can impl trait not be used to return multiple / conditional types? - Stack Overflow](https://stackoverflow.com/questions/52001592/why-can-impl-trait-not-be-used-to-return-multiple-conditional-types)

- `dyn A` and `dyn A + B` are different types, `impl for dyn A` doesn't automatically make `impl for dyn A + B`

  [Using anstream with tracing\_appender's `RollingFileAppender` - Issue #220 - rust-cli/anstyle](https://github.com/rust-cli/anstyle/issues/220)

- `impl Trait1 for dyn Trait2`
  - Generic dyn container pattern

    `impl AsLockedWrite for dyn std::io::Write + Send` + `impl<T: AsLockedWrite + ?Sized> AsLockedWrite for Box<T>`

  [Is `impl Trait1 for dyn Trait2` ever useful? - Mozilla](https://users.rust-lang.org/t/is-impl-trait1-for-dyn-trait2-ever-useful/60406)

[`std::ptr::DynMetadata`](https://doc.rust-lang.org/nightly/std/ptr/struct.DynMetadata.html)
- The vtable notably contains:
  - Type size
  - Type alignment
  - A pointer to the type's `drop_in_place` impl (may be a no-op for plain-old-data)
  - Pointers to all the methods for the type's implementation of the trait

  Note that the first three are special because they’re necessary to allocate, drop, and deallocate any trait object.

- [`pointer::to_raw_parts()`](https://doc.rust-lang.org/nightly/std/primitive.pointer.html#method.to_raw_parts)

- [How to obtain address of trait object? - Stack Overflow](https://stackoverflow.com/questions/61378906/how-to-obtain-address-of-trait-object)

  [Extracting raw pointer to a trait function - Stack Overflow](https://stackoverflow.com/questions/76889300/extracting-raw-pointer-to-a-trait-function)

  [Is there a way to determine the offsets of each of the trait methods in the VTable? - Stack Overflow](https://stackoverflow.com/questions/39714105/is-there-a-way-to-determine-the-offsets-of-each-of-the-trait-methods-in-the-vtab)
  - Comparing

[No need for pointer to member functions in Rust : r/rust](https://www.reddit.com/r/rust/comments/l99lft/no_need_for_pointer_to_member_functions_in_rust/)

Static dispatch:
- [enum\_dispatch](https://docs.rs/enum_dispatch/latest/enum_dispatch/) ([GitLab](https://gitlab.com/antonok/enum_dispatch))
- [typetag: Serde serializable and deserializable trait objects](https://github.com/dtolnay/typetag)

### [Dyn compatibility](https://doc.rust-lang.org/reference/items/traits.html#dyn-compatibility)
dyn compatibility, object safety

A trait is *object safe* if it has the following qualities (defined in [RFC 255](https://github.com/rust-lang/rfcs/blob/master/text/0255-object-safety.md)):
- It must not have any associated constants.
- All associated functions must either be dispatchable from a trait object or be explicitly non-dispatchable.
- Have a receiver with one of the following types: ...
  - The receiver cannot be `Self`, but can be `Box<Self>` and `&mut Self`.
- ...

[How to clone a struct storing a boxed trait object? - Stack Overflow](https://stackoverflow.com/questions/30353462/how-to-clone-a-struct-storing-a-boxed-trait-object)
- `fn clone_box(&self) -> Box<dyn MyTrait>;`

Async:
- [dtolnay/async-trait: Type erasure for async trait methods](https://github.com/dtolnay/async-trait)
  - `Box<T>` cost

  [why async fn in traits are hard - baby steps](https://smallcultfollowing.com/babysteps/blog/2019/10/26/async-fn-in-traits-are-hard/)

Workarounds:
- Enum dispatch
  - Not open
- Abstracting to another dyn-compatible trait
  - Need implement for concrete types / composited types as all supertraits must also be dyn compatible

## Associated types
[The Rust Programming Language](https://doc.rust-lang.org/book/ch19-03-advanced-traits.html#specifying-placeholder-types-in-trait-definitions-with-associated-types)

**Associated types** connect a type placeholder with a trait such that the trait method definitions can use these placeholder types in their signatures. The implementor of a trait will specify the concrete type to be used instead of the placeholder type for the particular implementation.

Define `Iterator` trait with generics:
```rust
pub trait Iterator<T> {
    fn next(&mut self) -> Option<T>;
}

impl Iterator<T> for Counter {
    fn next(&mut self) -> Option<T> {
        todo!()
    }
}
```

Define `Iterator` with associated types:
```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;
}

impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        todo!()
    }
}
```

The difference is that when using generics, we must annotate the types in each implementation; because we can also implement `Iterator<String> for Counter` or any other type, we could have multiple implementations of `Iterator` for `Counter`. In other words, when a trait has a generic parameter, it can be implemented for a type multiple times, changing the concrete types of the generic type parameters each time. When we use the `next` method on `Counter`, we would have to provide type annotations to indicate which implementation of `Iterator` we want to use.

With associated types, we don’t need to annotate types because we can’t implement a trait on a type multiple times. With the definition that uses associated types, we can only choose what the type of `Item` will be once, because there can only be one `impl Iterator for Counter`. We don’t have to specify that we want an iterator of `u32` values everywhere that we call `next` on `Counter`.

- Type equality constraints
  - `T: Iterator<Item = i32>`
  - `T: Iterator where T::Item == i32` not supported

    [Tracking issue for type equality constraints in where clauses - Issue #20041 - rust-lang/rust](https://github.com/rust-lang/rust/issues/20041)
  - `T: Iterator where (T::Item, i32): TypeEqual` / `where T::Item: TypeEqual<i32>`
  - `T: Iterator where T::Item: i32Like`

## Supertraits
[The Rust Programming Language](https://doc.rust-lang.org/book/ch19-03-advanced-traits.html#using-supertraits-to-require-one-traits-functionality-within-another-trait)

```rust
use std::fmt;

trait OutlinePrint: fmt::Display {
    fn outline_print(&self) {
        let output = self.to_string();
        let len = output.len();
        println!("{}", "*".repeat(len + 4));
        println!("*{}*", " ".repeat(len + 2));
        println!("* {} *", output);
        println!("*{}*", " ".repeat(len + 2));
        println!("{}", "*".repeat(len + 4));
    }
}

struct Point {
    x: i32,
    y: i32,
}

impl OutlinePrint for Point {}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}
```

虽然 supertrait 的语法看起来很像继承，但它实际上是组合而非继承。

类型不会自动实现自定义 trait，即使它是空的。这意味着 closures 可以满足 `Fn()`，但如果定义 `trait MyFn: Fn() {}`，closures 并不能满足 `MyFn`。

## Specialization
[1210-impl-specialization - The Rust RFC Book](https://rust-lang.github.io/rfcs/1210-impl-specialization.html)
- [Tracking issue for specialization (RFC 1210) - Issue #31844 - rust-lang/rust](https://github.com/rust-lang/rust/issues/31844)

[The state of specialization - community - The Rust Programming Language Forum](https://users.rust-lang.org/t/the-state-of-specialization/113560)
> Lifetime specialization is a problem because when the compiler actually generates code it no longer knows about lifetimes, thus if the specialized implementation requires some specific lifetimes (e.g. a lifetime to be `'static`, or two lifetimes `'a` and `'b` to be somehow related) then it no longer knows which implementation to use (is it the specialized one or the normal one?)
> 
> Lifetime specialization is not something you would want to write yourself, but unfortunately it comes up implicitly all the time. Do you want to write a specialized implementation for `(T, T)` for some generic type `T`? Unfortunately if `T` contains a lifetime you just forced two lifetimes to be equal, which is lifetime specialization! Do you want to specialize on whether `T` implements a trait `Foo`? Unfortunately any user can write a `impl Foo for &'static Bar` or `impl<T> Foo for (T, T)`, and now your specialization depends on lifetimes again.

- `min_specialization`: [Implement a feature for a sound specialization subset by matthewjasper - Pull Request #68970 - rust-lang/rust](https://github.com/rust-lang/rust/pull/68970)

- Autoderef-based specialization

  [Generalized Autoref-Based Specialization - Lukasʼ Blog](https://lukaskalbertodt.github.io/2019/12/05/generalized-autoref-based-specialization.html)

  - [castaway: Safe, zero-cost downcasting for limited compile-time specialization.](https://github.com/sagebind/castaway)

    > However, if no specialization is applicable because of the same Autoref-Based Specialization, the compiler generates completely unclear errors, which makes it difficult to use it in complex cases.

  [Rust already has specialization : r/rust](https://www.reddit.com/r/rust/comments/rnn32g/rust_already_has_specialization/)

- [try-specialize: Zero-cost specialization in generic context on stable Rust](https://github.com/zheland/try-specialize#alternative-crates)

  [try-specialize: a crate for limited, zero-cost specialization in generic context on stable Rust : r/rust](https://www.reddit.com/r/rust/comments/1g3dipy/tryspecialize_a_crate_for_limited_zerocost/)

- [downcast-rs](https://github.com/marcianx/downcast-rs)
  - > Specialized on trait objects (dyn) downcasting. Can't be used to specialize unconstrained types.
  - Not zero cost.

- [coe-rs](https://github.com/sarah-quinones/coe-rs)

  > Supports only static types and don't safely combine type equality check and specialization.
- [syllogism](https://crates.io/crates/syllogism) (discontinued)
- [yasuo-ozu/min\_specialization](https://github.com/yasuo-ozu/min_specialization)

Avoid conflicting:
- Changing design
- References
  - `Borrow`
  - `'static`

  [rust - Can one do generics over references and non-references? - Stack Overflow](https://stackoverflow.com/questions/62205437/can-one-do-generics-over-references-and-non-references)

  [Require that type NOT be a reference - The Rust Programming Language Forum](https://users.rust-lang.org/t/require-that-type-not-be-a-reference/61730)

  [How to indicate a generic T doesn't contain a reference? - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/how-to-indicate-a-generic-t-doesnt-contain-a-reference/18444)

[Specialization on stable - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/specialization-on-stable/108497)
