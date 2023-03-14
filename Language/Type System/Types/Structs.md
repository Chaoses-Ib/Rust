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

