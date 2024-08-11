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

Note that we can implement a trait on a type only if at least one of the trait or the type is local to our crate. For example, we can’t implement the `Display` trait on `Vec<T>` within our `aggregator` crate, because `Display` and `Vec<T>` are both defined in the standard library. This restriction is part of a property called _coherence_, and more specifically the _orphan rule_, so named because the parent type is not present. This rule ensures that other people’s code can’t break your code and vice versa. Without the rule, two crates could implement the same trait for the same type, and Rust wouldn’t know which implementation to use.

由于 Rust 的 generics 不够强大，使用 static dispatch 可能会产生许多 boilerplate code，使用 macros 可以在一定程度上缓解这个问题，但 macros 本身也会引入新的问题。

[A failed experiment with Rust static dispatch - Julio Merino](https://jmmv.dev/2023/08/rust-static-dispatch-failed-experiment.html)
- [A failed experiment with Rust static dispatch : rust](https://www.reddit.com/r/rust/comments/15kdj78/a_failed_experiment_with_rust_static_dispatch/)

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

[rust - Why can impl trait not be used to return multiple / conditional types? - Stack Overflow](https://stackoverflow.com/questions/52001592/why-can-impl-trait-not-be-used-to-return-multiple-conditional-types)

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

### [Object safety](https://doc.rust-lang.org/reference/items/traits.html#object-safety)
A trait is *object safe* if it has the following qualities (defined in [RFC 255](https://github.com/rust-lang/rfcs/blob/master/text/0255-object-safety.md)):
- It must not have any associated constants.
- All associated functions must either be dispatchable from a trait object or be explicitly non-dispatchable.
- Have a receiver with one of the following types: ...
  - The receiver cannot be `Self`, but can be `Box<Self>` and `&mut Self`.
- ...

[How to clone a struct storing a boxed trait object? - Stack Overflow](https://stackoverflow.com/questions/30353462/how-to-clone-a-struct-storing-a-boxed-trait-object)
- `fn clone_box(&self) -> Box<dyn MyTrait>;`

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