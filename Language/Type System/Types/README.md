# Types
[The Usability of Advanced Type Systems: Rust as a Case Study](https://arxiv.org/abs/2301.02308)

## Scalar types
### Integer types

Length | Signed | Unsigned
--- | --- | ---
8-bit | `i8` | `u8`
16-bit | `i16` | `u16`
32-bit | **`i32`** | [`u32`](https://doc.rust-lang.org/std/primitive.u32.html)
64-bit | `i64` | `u64`
128-bit | `i128` | `u128`
arch | `isize` | `usize`

- Constants: `MIN`, `MAX`, `BITS`

Integer literals:

Number literals | Example
--- | ---
Decimal | `98_222`
Hex | `0xff`
Octal | `0o77`
Binary | `0b1111_0000`
Byte (`u8` only) | `b'A'`

Number literals that can be multiple numeric types allow a type suffix, such as `57u8`, to designate the type.

### Floating-point types
Rust’s floating-point types are `f32` and **`f64`**.

### The boolean type
`bool` has two possible values: `true` and `false`.

### The character type
`char` type is four bytes in size and represents a Unicode scalar value.

## Compound
**Compound types** can group multiple values into one type.

### The tuple type
A **tuple** is a general way of grouping together a number of values with a variety of types into one compound type.

For example:
```rust
fn main() {
    let tup: (i32, f64, u8) = (500, 6.4, 1);
    let tup = (500, 6.4, 1);
    
    let (x, y, z) = tup;  // destructuring
    
    let x = tup.0;
    let y = tup.1;
    let z = tup.2;
}
```

The tuple without any values has a special name, **unit**. This value and its corresponding type are both written `()` and represent an empty value or an empty return type. Expressions implicitly return the unit value if they don’t return any other value.

### The array type
Unlike a tuple, every element of an **array** must have the same type.

```rust
fn main() {
    let a: [i32; 5] = [1, 2, 3, 4, 5];
    let a = [1, 2, 3, 4, 5];

    let a = [3; 5];  // [3, 3, 3, 3, 3]

    let first = a[0];
}
```

The length of an array is part of its type. For this reason, this length must be a compile-time constant. However, you can use a **boxed slice** instead:

```rust
let n = 5;
let a: Box<[i32]> = vec![3; n].into_boxed_slice();

// vec![e; n] will clone the element n times
let a: Box<[Box<[i32]>]> = vec![vec![1, 2, 3].into_boxed_slice(); n].into_boxed_slice();
```

Partial initialization:
- [Explicit partial array initialisation in Rust - Stack Overflow](https://stackoverflow.com/questions/32452708/explicit-partial-array-initialisation-in-rust)

## Dynamic
- [value-bag: Dynamic structured values for Rust](https://github.com/sval-rs/value-bag)
- [rust\_dynamic: Dynamic datatype for Rust](https://github.com/vulogov/rust_dynamic)