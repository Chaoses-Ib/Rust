# Enumerations
[Enumerations - The Rust Reference](https://doc.rust-lang.org/reference/items/enumerations.html), [Enumerated types - The Rust Reference](https://doc.rust-lang.org/reference/types/enum.html)

```rust
enum IpAddrKind {
    V4,
    V6,
}

struct IpAddr {
    kind: IpAddrKind,
    address: String,
}

let home = IpAddr {
    kind: IpAddrKind::V4,
    address: String::from("127.0.0.1"),
};

let loopback = IpAddr {
    kind: IpAddrKind::V6,
    address: String::from("::1"),
};
```

```rust
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}

let home = IpAddr::V4(127, 0, 0, 1);

let loopback = IpAddr::V6(String::from("::1"));
```

Just as we’re able to define methods on structs using `impl`, we’re also able to define methods on enums.

[`std::mem::discriminant`](https://doc.rust-lang.org/std/mem/fn.discriminant.html) (v1.21.0)

## Enum optimization
Any `enum` value consumes as much memory as the largest variant for its corresponding `enum` type, as well as the size needed to store a discriminant. 一个 enum 是否需要 discriminant 由编译器判断，无法手动指定互斥值域来避免。

[Enum Optimization in Rust | Waterlens' Blog](https://yangrq.org/posts/rust-enum/)
- [performance - What is the overhead of Rust's Option type? - Stack Overflow](https://stackoverflow.com/questions/16504643/what-is-the-overhead-of-rusts-option-type)

  ```rust
  Type                      T    Option<T>
  i32                       4    8
  &i32                      8    8
  Box<i32>                  8    8
  &[i32]                   16   16
  Vec<i32>                 24   24
  Result<(), Box<i32>>      8   16
  ```

[Fun fact: size of Option<String> : rust](https://www.reddit.com/r/rust/comments/174ndzi/fun_fact_size_of_optionstring/)

## Pointer enums
```rust
enum Cow<'a>
{
    Borrowed(&'a String),
    Owned(Box<String>),
}
```

The size of an enum with two pointers is two pointers long, not one pointer plus a bool.

In fact, one can store the discriminant in the pointer itself, known as **[tagged pointers](https://en.wikipedia.org/wiki/Tagged_pointer)**:
- [ptr-union: Pointer unions the size of a pointer](https://github.com/CAD97/pointer-utils) ([Docs.rs](https://resume.cad97.com/pointer-utils/ptr_union/index.html))
- [enum-ptr: Ergonomic tagged pointer](https://github.com/QuarticCat/enum-ptr)
- [tagged-pointer-as-enum](https://github.com/iliabylich/tagged-pointer-as-enum)