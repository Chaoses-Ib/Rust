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