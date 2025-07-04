# Macros
[The Rust Programming Language](https://doc.rust-lang.org/book/ch19-06-macros.html)

[The Little Book of Rust Macros](https://veykril.github.io/tlborm/)

- [rustc\_builtin\_macros](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_builtin_macros/index.html)
- [paste: Macros for all your token pasting needs](https://github.com/dtolnay/paste)
- [duplicate: Easy code duplicate with substitution for Rust](https://github.com/Emoun/duplicate)
- [trait\_gen: Trait implementation generator macro](https://github.com/blueglyph/trait_gen)

[What is your favorite derive macro crates? : r/rust](https://www.reddit.com/r/rust/comments/1juaxoj/what_is_your_favorite_derive_macro_crates/)

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

## [→Procedural macros](Procedural.md)

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

## Macro expansion
[Macro expansion - Rust Compiler Development Guide](https://rustc-dev-guide.rust-lang.org/macro-expansion.html)

- Eager expansion

  > Eager expansion means that we expand the arguments of a macro invocation before the macro invocation itself. This is implemented only for a few special built-in macros that expect literals.

  [RFC: Eager Macro Expansion by pierzchalski - Pull Request #2320 - rust-lang/rfcs](https://github.com/rust-lang/rfcs/pull/2320)

  [Why does a macro call inside another macro not expand, but instead I get "no rules expected the token `!`"? - Stack Overflow](https://stackoverflow.com/questions/65204193/why-does-a-macro-call-inside-another-macro-not-expand-but-instead-i-get-no-rul)

  [Use output of macro as parameter for another macro - Stack Overflow](https://stackoverflow.com/questions/51965979/use-output-of-macro-as-parameter-for-another-macro)
  > A macro can invoke another macro, but one cannot take the result of another.

Tools:
- [cargo-expand: Subcommand to show result of macro expansion](https://github.com/dtolnay/cargo-expand)
- [Rust Macro Expand: VS Code extension for expanding macros in Rust code. Enables macro expansion based on module, crate or any other parameters supported by the cargo-expand crate.](https://github.com/Odiriuss/rust-macro-expand)