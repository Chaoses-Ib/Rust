# Expressions
In Rust, a new scope block created with curly brackets is an expression, for example:
```rust
fn main() {
    let y = {
        let x = 3;
        x + 1
    };
    println!("The value of y is: {y}");  // 4
}
```

## If expressions
For example:
```rust
fn main() {
    let condition = true;
    let number = if condition { 5 } else { 6 };

    println!("The value of number is: {number}");
}
```
```rust
fn main() {
    let number = 6;

    if number % 3 == 0 {
        println!("number is divisible by 3");
    } else if number % 2 == 0 {
        println!("number is divisible by 2");
    } else {
        println!("number is not divisible by 3 or 2");
    }
}
```

- [likely](https://doc.rust-lang.org/std/intrinsics/fn.likely.html), [unlikely](https://doc.rust-lang.org/std/intrinsics/fn.unlikely.html)

## Loop expressions
For example:
```rust
fn main() {
    let mut counter = 0;

    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2;
        }
    };

    println!("The result is {result}");
}
```

Loop labels:
```rust
fn main() {
    let mut count = 0;
    'counting_up: loop {
        println!("count = {count}");
        let mut remaining = 10;

        loop {
            println!("remaining = {remaining}");
            if remaining == 9 {
                break;
            }
            if count == 2 {
                break 'counting_up;
            }
            remaining -= 1;
        }

        count += 1;
    }
    println!("End count = {count}");
}
```

### While loop
```rust
fn main() {
    let mut number = 3;

    while number != 0 {
        println!("{number}!");

        number -= 1;
    }

    println!("LIFTOFF!!!");
}
```

### For loop
```rust
fn main() {
    for number in (1..4).rev() {
        println!("{number}!");
    }
    println!("LIFTOFF!!!");
}
```

[\[Language\] for-else and while-else - Issue #3361 - rust-lang/rfcs](https://github.com/rust-lang/rfcs/issues/3361)

[for else loop, in Rust](https://programming-idioms.org/idiom/223/for-else-loop/3852/rust)