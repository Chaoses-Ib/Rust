# Ownership
[rust-lang/polonius: Defines the Rust borrow checker.](https://github.com/rust-lang/polonius)

## Splitting borrows
[The Rustonomicon](https://doc.rust-lang.org/nomicon/borrow-splitting.html)

### Field borrows
> The mutual exclusion property of mutable references can be very limiting when working with a composite structure. The borrow checker (a.k.a. borrowck) understands some basic stuff, but will fall over pretty easily. It does understand structs sufficiently to know that it's possible to borrow disjoint fields of a struct simultaneously.

[Multiple Mutable References](https://oribenshir.github.io/afternoon_rusting/blog/mutable-reference)

Macros