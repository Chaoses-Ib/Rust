# Pattern Matching
[The Rust Programming Language](https://doc.rust-lang.org/book/ch18-00-patterns.html)

## Refutability
Patterns come in two forms: refutable and irrefutable.

Patterns that will match for any possible value passed are **irrefutable**:
- for loops
- let statements
- Function parameters

Patterns that can fail to match for some possible value are **refutable**.
- match expressions
- if let expressions
- while let loops

## Pattern syntax
[The Rust Programming Language](https://doc.rust-lang.org/book/ch18-03-pattern-syntax.html)

- Matching literals
  - Floating points
    
    ```rust
    match foo() {
        x if x == 3.0 => ...,
        _ => ...
    }
    ```

    [Tracking issue for `illegal_floating_point_literal_pattern` compatibility lint · Issue #41620 · rust-lang/rust](https://github.com/rust-lang/rust/issues/41620)

- Matching named variables

  Named variables are irrefutable patterns that match any value.

- Multiple patterns

  ```rust
  match x {
      1 | 2 => println!("one or two"),
      3 => println!("three"),
      _ => println!("anything"),
  }
  ```

- Matching ranges of values

  ```rust
  match x {
      1..=5 => println!("one through five"),
      _ => println!("something else"),
  }
  ```

- Destructuring to break apart values

  ```rust
  struct Point {
      x: i32,
      y: i32,
  }

  let p = Point { x: 0, y: 7 };

  let Point { x: a, y: b } = p;
  assert_eq!(0, a);
  assert_eq!(7, b);

  let Point { x, y } = p;
  assert_eq!(0, x);
  assert_eq!(7, y);

  match p {
      Point { x, y: 0 } => println!("On the x axis at {x}"),
      Point { x: 0, y } => println!("On the y axis at {y}"),
      Point { x, y } => {
          println!("On neither axis: ({x}, {y})");
      }
  }
  ```

- Destructuring enums

  ```rust
  match msg {
      Message::Quit => {
          println!("The Quit variant has no data to destructure.");
      }
      Message::Move { x, y } => {
          println!("Move in the x direction {x} and in the y direction {y}");
      }
      Message::Write(text) => {
          println!("Text message: {text}");
      }
      Message::ChangeColor(r, g, b) => {
          println!("Change the color to red {r}, green {g}, and blue {b}",)
      }
  }
  ```

- Destructuring nested structs and enums

  ```rust
  enum Color {
      Rgb(i32, i32, i32),
      Hsv(i32, i32, i32),
  }

  enum Message {
      Quit,
      Move { x: i32, y: i32 },
      Write(String),
      ChangeColor(Color),
  }

  let msg = Message::ChangeColor(Color::Hsv(0, 160, 255));

  match msg {
      Message::ChangeColor(Color::Rgb(r, g, b)) => {
          println!("Change color to red {r}, green {g}, and blue {b}");
      }
      Message::ChangeColor(Color::Hsv(h, s, v)) => {
          println!("Change color to hue {h}, saturation {s}, value {v}")
      }
      _ => (),
  }
  ```

- Destructuring structs and tuples

  ```rust
  let ((feet, inches), Point { x, y }) = ((3, 10), Point { x: 3, y: -10 });
  ```

- Ignoring values in a pattern

  Ignoring an entire value with `_`:
  ```rust
  fn foo(_: i32, y: i32) {
      println!("This code only uses the y parameter: {}", y);
  }
  ```

  Ignoring parts of a value with a nested `_`:
  ```rust
  let mut setting_value = Some(5);
  let new_setting_value = Some(10);

  match (setting_value, new_setting_value) {
      (Some(_), Some(_)) => {
          println!("Can't overwrite an existing customized value");
      }
      _ => {
          setting_value = new_setting_value;
      }
  }
  ```

  Ignoring an unused variable by starting its name with `_`:
  ```rust
  let _x = 5;
  ```

  Ignoring remaining parts of a value with `..`:
  ```rust
  let origin = Point { x: 0, y: 0, z: 0 };

  match origin {
      Point { x, .. } => println!("x is {}", x),
  }
  ```

- Extra conditionals with match guards

  A **match guard** is an additional `if` condition, specified after the pattern in a `match` arm, that must also match for that arm to be chosen.

  ```rust
  let num = Some(4);

  match num {
      Some(x) if x % 2 == 0 => println!("The number {} is even", x),
      Some(x) => println!("The number {} is odd", x),
      None => (),
  }
  ```

- @ bindings

  The at operator `@` lets us create a variable that holds a value at the same time as we’re testing that value for a pattern match.

  ```rust
  let msg = Message::Hello { id: 5 };

  match msg {
      Message::Hello {
          id: id_variable @ 3..=7,
      } => println!("Found an id in range: {}", id_variable),
      Message::Hello { id: 10..=12 } => {
          println!("Found an id in another range")
      }
      Message::Hello { id } => println!("Found some other id: {}", id),
  }
  ```

## match expressions
[The Rust Programming Language](https://doc.rust-lang.org/book/ch06-02-match.html)

## if let expressions
[The Rust Programming Language](https://doc.rust-lang.org/book/ch06-03-if-let.html)

## while let loops
```rust
while let Some(top) = stack.pop() {
    println!("{}", top);
}
```

## for loops
In a `for` loop, the value that directly follows the keyword `for` is a pattern.

```rust
for (index, value) in v.iter().enumerate() {
    println!("{} is at index {}", value, index);
}
```

## let statements
```rust
let PATTERN = EXPRESSION;
```

In statements like `let x = 5;` with a variable name in the `PATTERN` slot, the variable name is just a particularly simple form of a pattern.

```rust
let (x, y, z) = (1, 2, 3);
```

## Function parameters
```rust
fn print_coordinates(&(x, y): &(i32, i32)) {
    println!("Current location: ({}, {})", x, y);
}

fn main() {
    let point = (3, 5);
    print_coordinates(&point);
}
```