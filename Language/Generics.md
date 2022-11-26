# Generics
## Generics
**Generics** are abstract stand-ins for concrete types or other properties.

### In function definitions
For example:
```rust
fn largest<T>(list: &[T]) -> &T {
    let mut largest = &list[0];

    for item in list {
        if item > largest {
            largest = item;
        }
    }

    largest
}

fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    let result = largest(&number_list);
    println!("The largest number is {}", result);

    let char_list = vec!['y', 'm', 'a', 'q'];

    let result = largest(&char_list);
    println!("The largest char is {}", result);
}
```

### In struct definitions
For example:
```rust
struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let integer = Point { x: 5, y: 10 };
    let float = Point { x: 1.0, y: 4.0 };
}
```

### In enum definitions
For example:
```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

### In method definitions
For example:
```rust
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}

fn main() {
    let p = Point { x: 5, y: 10 };

    println!("p.x = {}", p.x());
}
```

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

## Lifetimes
Rather than ensuring that a type has the behavior we want, **lifetimes** ensure that references are valid as long as we need them to be. The main aim of lifetimes is to prevent _dangling references_, which cause a program to reference data other than the data it’s intended to reference.

**Lifetime annotations** don’t change how long any of the references live. Rather, they describe the relationships of the lifetimes of multiple references to each other without affecting the lifetimes. Just as functions can accept any type when the signature specifies a generic type parameter, functions can accept references with any lifetime by specifying a generic lifetime parameter.

For example:
```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```
The returned reference will be valid as long as both the parameters are valid.

When we define structs to hold references, we need to add a lifetime annotation on every reference in the struct’s definition:
```rust
struct ImportantExcerpt<'a> {
    part: &'a str,
}

fn main() {
    let novel = String::from("Call me Ishmael. Some years ago...");
    let first_sentence = novel.split('.').next().expect("Could not find a '.'");
    let i = ImportantExcerpt {
        part: first_sentence,
    };
}
```

And the same for methods:
```rust
impl<'a> ImportantExcerpt<'a> {
    fn level(&self) -> i32 {
        3
    }
}
```

### The static lifetime
`'static` is a special lifetime that denotes the affected reference _can_ live for the entire duration of the program. All string literals have the `'static` lifetime, which we can annotate as follows:
```rust
let s: &'static str = "I have a static lifetime.";
```

### Lifetime elision
The patterns programmed into Rust’s analysis of references are called the **lifetime elision rules**. These aren’t rules for programmers to follow; they’re a set of particular cases that the compiler will consider, and if your code fits these cases, you don’t need to write the lifetimes explicitly.