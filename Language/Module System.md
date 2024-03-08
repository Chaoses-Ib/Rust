# Module System
## Crate
A **crate** is the smallest amount of code that the Rust compiler considers at a time. Crates can contain modules, and the modules may be defined in other files that get compiled with the crate.

Crates can come in one of two forms:
- Binary crates: programs you can compile to an executable that you can run

  A binary crate must have a `main()`.
- Library crates: define functionality intended to be shared with multiple projects

The **crate root** is a source file that the Rust compiler starts from and makes up the root module of your crate.

## Modules
**Modules** let us organize code within a crate for readability and easy reuse.

Here is a quick reference on how modules, paths, the `use` keyword, and the `pub` keyword work in the compiler, and how most developers organize their code:
1. Start from the crate root
 
   When compiling a crate, the compiler first looks in the crate root file for code to compile.
  
2. Declaring modules
 
   In the crate root file, you can declare new modules; say, you declare a “garden” module with `mod garden;`. The compiler will look for the module’s code in these places:
    - Inline, within curly brackets that replace the semicolon following `mod garden`
    - In the file `src/garden.rs`
    - In the file `src/garden/mod.rs`

   [Anonymous modules - compiler - Rust Internals](https://internals.rust-lang.org/t/anonymous-modules/15441/8)

3. Declaring submodules
 
   In any file other than the crate root, you can declare submodules. For example, you might declare `mod vegetables;` in `src/garden.rs`. The compiler will look for the submodule’s code within the directory named for the parent module in these places:
    - Inline, directly following `mod vegetables`, within curly brackets instead of the semicolon
    - In the file `src/garden/vegetables.rs`
    - In the file `src/garden/vegetables/mod.rs`

4. Paths to code in modules

   Once a module is part of your crate, you can refer to code in that module from anywhere else in that same crate, as long as the privacy rules allow, using the path to the code. For example, an `Asparagus` type in the garden vegetables module would be found at `crate::garden::vegetables::Asparagus`.
   
5. Private vs public

   Code within a module is private from its parent modules by default. Items in a parent module can’t use the private items inside child modules, but items in child modules can use the items in their ancestor modules.
   
   To make a module public, declare it with `pub mod` instead of `mod`. To make items within a public module public as well, use `pub` before their declarations.

6. The `use` keyword
 
   Within a scope, the `use` keyword creates shortcuts to items to reduce repetition of long paths. In any scope that can refer to `crate::garden::vegetables::Asparagus`, you can create a shortcut with `use crate::garden::vegetables::Asparagus;` and from then on you only need to write `Asparagus` to make use of that type in the scope.

## Paths
A path can take two forms:
- An _absolute path_ is the full path starting from a crate root; for code from an external crate, the absolute path begins with the crate name, and for code from the current crate, it starts with the literal `crate`.
- A _relative path_ starts from the current module and uses `self`, `super`, or an identifier in the current module.

### The `use` keyword
For example:
```rust
use std::fmt::Result;
use std::io::Result as IoResult;
```

We can use nested paths to use multiple items defined in the same crate or the same module:
```rust
use std::cmp::Ordering;
use std::io;
use std::io::Write;
```
```rust
use std::{cmp::Ordering, io::{self, Write}};
```

If we want to bring _all_ public items defined in a path into scope, we can specify that path followed by the `*` glob operator:
```rust
use std::collections::*;
```

We can also re-export names with `pub use`:
```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
}
```

See also [Prelude](https://doc.rust-lang.org/std/prelude/index.html).


## Packages
A **package** is a bundle of one or more crates that provides a set of functionality. A package can contain as many binary crates as you like, but at most only one library crate. A package contains a _Cargo.toml_ file that describes how to build those crates.

Cargo follows the following conventions on finding crate roots:
- `src/main.rs` is the crate root of a binary crate with the same name as the package.
- `src/lib.rs` is the crate root of a library crate with the same name as the package.
- Each file in `src/bin` is a separate binary create.
