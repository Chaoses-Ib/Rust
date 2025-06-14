# Generics
## Generics
**Generics** are abstract stand-ins for concrete types or other properties.

[C++ & Rust: Generics and Specialization](https://www.tangramvision.com/blog/c-rust-generics-and-specialization)

[Generics partial specialization in Rust - Stack Overflow](https://stackoverflow.com/questions/66832882/generics-partial-specialization-in-rust)

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

[How to design an enum where one variant can store a closure - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/how-to-design-an-enum-where-one-variant-can-store-a-closure/59322)
```rust
pub enum ServiceFilter<F: Fn(&Value) -> bool> {
  Name(String),
  Object(Map<String, Value>),
  Function(F),
}

let services = filter_services::<fn(&Value) -> bool>(ServiceFilter::Name("myName".to_string()));
```
Default types do not work.

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

## Defaults
[Tracking issue for `invalid_type_param_default` compatibility lint - Issue #36887 - rust-lang/rust](https://github.com/rust-lang/rust/issues/36887)
- Defaults for type parameters are only allowed in `struct`, `enum`, `type`, or `trait` definitions.

## Const generics
[Const Generics - Rust By Practice](https://practice.rs/generics-traits/const-generics.html)

```rust
struct ArrayPair<T, const N: usize> {
    left: [T; N],
    right: [T; N],
}

impl<T: Debug, const N: usize> Debug for ArrayPair<T, N> {
    // ...
}
```

[Tracking Issue for more complex const parameter types: `feature(adt_const_params)` · Issue #95174 · rust-lang/rust](https://github.com/rust-lang/rust/issues/95174)
- [std::marker::ConstParamTy](https://doc.rust-lang.org/nightly/std/marker/trait.ConstParamTy.html)

## Variadic generics
- Implement for `<A>`, `<A, B>`, `<A, B, C>` ...

- `(Item, Rest)`

  > In practice, I’ve heard of a lot of people wishing they could use variadics, but I’ve never heard of anyone using the “simple” design above, probably because of its verbosity (you need to write one trait and two trait implementations for every trait you want to use inside a variadic). And it only covers the basic “implement trait for tuple” use-case.

  - [variadics - Rust](https://docs.rs/variadics/latest/variadics/)

- [Trait objects](Traits.md#trait-objects)
  - Dyn compatibility

[Variadic generics, again - PoignardAzur](https://poignardazur.github.io/2023/11/08/time-for-variadic-generics/) ([r/rust](https://www.reddit.com/r/rust/comments/17qp7v4/variadic_generics_again/))

[variadics\_analysis.md](https://gist.github.com/PoignardAzur/aea33f28e2c58ffe1a93b8f8d3c58667)

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

[→Lazy initialization](../../Libraries/Paradigms/Object-oriented.md#lazy-evaluation)

[→Generic statics](../Variables/Static.md#generic-statics)

### Lifetime elision
[The Rustonomicon](https://doc.rust-lang.org/nomicon/lifetime-elision.html)

The patterns programmed into Rust’s analysis of references are called the **lifetime elision rules**. These aren’t rules for programmers to follow; they’re a set of particular cases that the compiler will consider, and if your code fits these cases, you don’t need to write the lifetimes explicitly.

Elision rules are as follows:
- Each elided lifetime in input position becomes a distinct lifetime parameter.
- If there is exactly one input lifetime position (elided or not), that lifetime is assigned to _all_ elided output lifetimes.
- If there are multiple input lifetime positions, but one of them is `&self` or `&mut self`, the lifetime of `self` is assigned to _all_ elided output lifetimes.
- Otherwise, it is an error to elide an output lifetime.
