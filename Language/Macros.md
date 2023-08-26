# Macros
[The Rust Programming Language](https://doc.rust-lang.org/book/ch19-06-macros.html)

[The Little Book of Rust Macros](https://veykril.github.io/tlborm/)

## Declarative macros
```rust
#[macro_export]
macro_rules! vec {
    ( $( $x:expr ),* ) => {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}
```

[Is there a way to reference a local variable within a Rust macro? - Stack Overflow](https://stackoverflow.com/questions/63349678/is-there-a-way-to-reference-a-local-variable-within-a-rust-macro)

[Can I use compile-time if statements inside macros? : rust](https://www.reddit.com/r/rust/comments/dnwobq/can_i_use_compiletime_if_statements_inside_macros/)

[rust - How to write macro for similar matching arms? - Stack Overflow](https://stackoverflow.com/questions/44033221/how-to-write-macro-for-similar-matching-arms)

## Procedural macros
