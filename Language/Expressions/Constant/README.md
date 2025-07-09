# Constant Evaluation
[Constant Evaluation - The Rust Reference](https://doc.rust-lang.org/reference/const_eval.html)

- > can't use generic parameters from outer item. a `const` is a separate item from the item that contains it
  - Const blocks

    [Inline const: use of generic parameter from outer item - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/inline-const-use-of-generic-parameter-from-outer-item/117455)

  [Tracking issue for generic const items - Issue #113521 - rust-lang/rust](https://github.com/rust-lang/rust/issues/113521)

## [`const` blocks](https://doc.rust-lang.org/reference/expressions/block-expr.html#const-blocks)
> A *const block* is a variant of a block expression whose body evaluates at compile-time instead of at runtime.

> Const blocks have the ability to reference generic parameters in scope, unlike free constant items. They are desugared to constant items with generic parameters in scope (similar to associated constants, but without a trait or type they are associated with). For example, this code:
```rust
fn foo<T>() -> usize {
    const { std::mem::size_of::<T>() + 1 }
}
```
is equivalent to:
```rust
fn foo<T>() -> usize {
    {
        struct Const<T>(T);
        impl<T> Const<T> {
            const CONST: usize = std::mem::size_of::<T>() + 1;
        }
        Const::<T>::CONST
    }
}
```

> If the const block expression is not executed at runtime, it may or may not be evaluated.

## Static assertions
- `const _: () = assert!(FOO == BAR, "assert_foo_equals_bar");` (Rust v1.57)
- `const _: [(); 0 - !{ const ASSERT: bool = $x; ASSERT } as usize] = [];`

  [static-assertions: Ensure correct assumptions about constants, types, and more in Rust](https://github.com/nvzqz/static-assertions)

[Nicer static assertions - language design - Rust Internals](https://internals.rust-lang.org/t/nicer-static-assertions/15986)
