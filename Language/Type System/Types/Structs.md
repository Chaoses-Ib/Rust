# Structs
A **struct (structure)** is a custom data type that lets you package together and name multiple related values that make up a meaningful group.

For example:
```rust
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}
```

## Offsets
- [`core::mem::offset_of!()`](https://doc.rust-lang.org/std/mem/macro.offset_of.html) (v1.77)
- [memoffset: offsetof for Rust](https://github.com/Gilnaa/memoffset)
  - [offset\_of! for unsized structs - Issue #25 - Gilnaa/memoffset](https://github.com/Gilnaa/memoffset/issues/25)
- [field-offset: Safe pointer-to-member functionality for rust](https://github.com/Diggsey/rust-field-offset)
  - 通过 uninit_ptr 和 closure 间接算出偏移。
- [repr\_offset\_crates: Offsets of fields for types with a stable layout](https://github.com/rodrimati1992/repr_offset_crates/)

[Idea: "Access" trait and member offset - language design - Rust Internals](https://internals.rust-lang.org/t/idea-access-trait-and-member-offset/8355)

## Bit fields
[rust - How to implement bitwise operations on a bitflags enum? - Stack Overflow](https://stackoverflow.com/questions/43509560/how-to-implement-bitwise-operations-on-a-bitflags-enum)

Libraries:
- [bitflags: A macro to generate structures which behave like bitflags](https://github.com/bitflags/bitflags)

- [Enumflags: Rust library for typesystem-assisted bitflags.](https://github.com/meithecatte/enumflags2)

- [Bitfield Struct: Procedural macro for bitfields.](https://github.com/wrenger/bitfield-struct-rs)

  ```rust
  /// Define your type like this with the bitfield attribute
  #[bitfield(u8)]
  struct MyByte {
      /// The first field occupies the least significant bits
      #[bits(4)]
      kind: usize,
      /// Booleans are 1 bit large
      system: bool,
      /// The bits attribute specifies the bit size of this field
      #[bits(2)]
      level: usize,
      /// The last field spans over the most significant bits
      present: bool
  }
  // The macro creates three accessor functions for each field:
  // <name>, with_<name> and set_<name>
  let my_byte = MyByte::new()
      .with_kind(15)
      .with_system(false)
      .with_level(3)
      .with_present(true);

  assert!(my_byte.present());
  ```
  - [Public getter and private setter for one field - Issue #25](https://github.com/wrenger/bitfield-struct-rs/issues/25)
  - [Converters instead of traits to support external types - Issue #26](https://github.com/wrenger/bitfield-struct-rs/issues/26)

- [rust-bitfield: This crate provides macros to generate bitfield-like struct.](https://github.com/dzamlo/rust-bitfield)

  ```rust
  bitfield!{
      struct IpV4Header(MSB0 [u8]);
      u32;
      get_version, _: 3, 0;
      get_ihl, _: 7, 4;
      get_dscp, _: 13, 8;
      get_ecn, _: 15, 14;
      get_total_length, _: 31, 16;
      get_identification, _: 47, 31;
      get_df, _: 49;
      get_mf, _: 50;
      get_fragment_offset, _: 63, 51;
      get_time_to_live, _: 71, 64;
      get_protocol, _: 79, 72;
      get_header_checksum, _: 95, 79;
      get_source_address, _: 127, 96;
      get_destination_address, _: 159, 128;
  }
  ```

- [`atomic_bitfield`: Bitfield abstraction for Rust's core atomic types](https://github.com/amiraeva/atomic_bitfield)

## Tuple structs
**Tuple structs** have the added meaning the struct name provides but don’t have names associated with their fields; rather, they just have the types of the fields. For example:
```rust
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

fn main() {
    let black = Color(0, 0, 0);
    let origin = Point(0, 0, 0);
}
```

You can also define structs that don’t have any fields, i.e., *unit-like structs*:
```rust
struct AlwaysEqual;

fn main() {
    let subject = AlwaysEqual;
}
```
Unit-like structs can be useful when you need to implement a trait on some type but don’t have any data that you want to store in the type itself.

## Associated functions
**Associated functions** are functions defined within the context of a struct (or an enum or a trait object). **Methods** are associated functions whose first parameter is `self`, which represents the instance of the struct the method is being called on.

Associated functions that aren’t methods are often used for constructors that will return a new instance of the struct. These are often called `new`, but `new` isn’t a special name and isn’t built into the language.
- `new` 没有被内置和不能重载也有关系
- 不能像 C++ 一样自动调用 ctor，例如 `std::string s;`，只能 `let s = String::new();`，稍微啰嗦一些
  - 不过可以 `Default::default()`，换类型了也能自动推导，C++ 里就没法 `auto x;` 这样写
- 可以只声明不初始化，例如 `let s;`

For example:
```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}

fn main() {
    let rect1 = Rectangle {
        width: 30,
        height: 50,
    };

    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area()
    );
}
```
The `&self` is actually short for `self: &Self`. Within an `impl` block, the type `Self` is an alias for the type that the `impl` block is for.

Having a method that takes ownership of the instance by using just `self` as the first parameter is rare; this technique is usually used when the method transforms `self` into something else and you want to prevent the caller from using the original instance after the transformation.

Rust doesn’t allow us to mark only certain fields in a struct as immutable, but we can make the fields private and implement public *getters* to enable read-only access to the fields.

Each struct is allowed to have multiple `impl` blocks.

[Characteristics of Object-Oriented Languages - The Rust Programming Language](https://doc.rust-lang.org/book/ch17-01-what-is-oo.html)

[Rust Is Beyond Object-Oriented, Part 1: Intro and Encapsulation :: The Coded Message](https://www.thecodedmessage.com/posts/oop-1-encapsulation/)
- [Rust Is Beyond Object-Oriented, Part 2: Polymorphism :: The Coded Message](https://www.thecodedmessage.com/posts/oop-2-polymorphism/)

## Instances
To use a struct after we’ve defined it, we create an **instance** of that struct by specifying concrete values for each of the fields:
```rust
fn main() {
    let user1 = User {
        email: String::from("someone@example.com"),
        username: String::from("someusername123"),
        active: true,
        sign_in_count: 1,
    };
}
```
We don’t have to specify the fields in the same order in which we declared them in the struct.

### Field init shorthand syntax
If the variable name and the struct field names are exactly the same, we can use the *field init shorthand* syntax to create an instance:
```rust
fn build_user(email: String, username: String) -> User {
    User {
        email,
        username,
        active: true,
        sign_in_count: 1,
    }
}
```

### Struct update syntax
It’s often useful to create a new instance of a struct that includes most of the values from another instance, but changes some. You can do this using _struct update syntax_:
```rust
fn main() {
    // ...
    let user2 = User {
        email: String::from("another@example.com"),
        ..user1
    };
}
```

## Builders
[Rethinking Builders... with Lazy Generics -- Geo's Notepad -- Mostly Programming and Math](https://geo-ant.github.io/blog/2024/rust-rethinking-builders-lazy-generics/) ([r/rust](https://www.reddit.com/r/rust/comments/1g1gueh/rethinking_builders_with_lazy_generics/))

Libraries:
- [bon: Next-gen compile-time-checked builder generator, named function's arguments, and more!](https://github.com/elastio/bon)
  - Structs and functions
  - [Positional Members | Bon](https://elastio.github.io/bon/guide/positional-members)
    - Doesn't support functions?
    - [ ] All non-optional as positional

  Discussions:
  - 2024-08 [Why would you use Bon : r/rust](https://www.reddit.com/r/rust/comments/1exko4h/why_would_you_use_bon/)
  - 2024-08 [Bon builder generator 2.0 release 🎉 : r/rust](https://www.reddit.com/r/rust/comments/1f1uzkw/bon_builder_generator_20_release/)
  - 2024-09 [\[Media\] Next-gen builder macro Bon 2.1 release 🎉. Compilation is faster by 36% 🚀 : r/rust](https://www.reddit.com/r/rust/comments/1f6d7vr/media_nextgen_builder_macro_bon_21_release/)
  - 2024-09 [\[Media\] Next-gen builder macro Bon 2.3 release 🎉. Positional arguments in starting and finishing functions 🚀 : r/rust](https://www.reddit.com/r/rust/comments/1fgmbo7/media_nextgen_builder_macro_bon_23_release/)

- [rust-typed-builder: Compile-time type-checked builder derive](https://github.com/idanarye/rust-typed-builder)
  - > 没办法让某个 field 的 setter 返回 `Result<Builder, Error>`？
  - > 似乎没办法给 enum 类型提供像 option 那样的 strip_option 方式。我有一个field 是c, c 的类型不是 option, 是一个 enum ，如果能给enum 中的每一种情况都加一个构造函数就好了

- [buildstructor: Derive a builder for your constructors in Rust](https://github.com/BrynCooke/buildstructor)
  - Structs and functions

- [named\_params: Fast, simple named parameters for Rust functions](https://github.com/michaeleisel/named_params)

  [named\_params: A Rust crate for fast, simple named function parameters : r/rust](https://www.reddit.com/r/rust/comments/1fqoyuv/named_params_a_rust_crate_for_fast_simple_named/)

- [typestate-builder](https://github.com/aalowlevel/typestate-builder)

  [I published a crate that combines typestate and builder patterns. : r/rust](https://www.reddit.com/r/rust/comments/1fpf49x/i_published_a_crate_that_combines_typestate_and/)

- [structbuilder\_derive: Rust macro for deriving a builder for simple structs](https://github.com/reidswan/structbuilder_derive)