# Sealed Traits
[A definitive guide to sealed traits in Rust](https://predr.ag/blog/definitive-guide-to-sealed-traits-in-rust/)

| | downstream code can use it as a bound | downstream code can call its methods | downstream types can impl it |
| --- |  --- |  --- | --- |
| **pub trait** | ✅ | ✅ | ✅ |
| **supertrait sealed trait** | ✅ | ✅ | ❌ |
| **method signature sealed trait** | ✅ | ❌ | ❌ |
| **private trait** | ❌ | ❌ | ❌ |

```rust
pub trait SealedTrait: Sealed {
    fn method(&self);
}

mod private {
    pub trait Sealed {}
}
use private::Sealed;

impl Sealed for T {}
```

[jmg-duarte/sealed-rs: Macro for sealing traits and structures](https://github.com/jmg-duarte/sealed-rs)
