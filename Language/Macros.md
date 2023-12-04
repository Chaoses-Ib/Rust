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

## `macro_use` attribute
[Macros By Example - The Rust Reference](https://doc.rust-lang.org/reference/macros-by-example.html#the-macro_use-attribute)

> The `macro_use` attribute has two purposes:
> - First, it can be used to make a module's macro scope not end when the module is closed, by applying it to a module.
> - Second, it can be used to import macros from another crate, by attaching it to an `extern crate` declaration appearing in the crate's root module.
> 
>   Macros imported this way are imported into the `macro_use` prelude, not textually, which means that they can be shadowed by any other name.
>
>   ```rust
>   #[macro_use(lazy_static)] // Or #[macro_use] to import all macros.
>   extern crate lazy_static;
>   
>   lazy_static!{}
>   // self::lazy_static!{} // Error: lazy_static is not defined in `self`
>   ```

[rust - What does `#[macro_use]` before an extern crate statement mean? - Stack Overflow](https://stackoverflow.com/questions/54953571/what-does-macro-use-before-an-extern-crate-statement-mean)

> In newer Rust versions (edition 2018+) this syntax is no longer needed. However, there are still cases when it might come in handy, like **global macro imports**.