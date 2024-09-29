# Reflection
## Type reflection
[Rust 反射，反射库 bevy\_reflect，实现运行时检测是否实现了 trait - 知乎](https://zhuanlan.zhihu.com/p/615577638)

Libraries:
- Serde
- [reflect: Compile-time reflection API for developing robust procedural macros (proof of concept)](https://github.com/dtolnay/reflect)
- [bevy_reflect](https://github.com/bevyengine/bevy/tree/main/crates/bevy_reflect) ([Docs.rs](https://docs.rs/bevy_reflect/0.14.2/bevy_reflect/))
  - `#[doc]` with `documentation` feature
  - `TypeInfo` cannot be serialized
  - [Automatically register types for `Reflect` - Issue #3936 - bevyengine/bevy](https://github.com/bevyengine/bevy/issues/3936)
  - [bevy\_reflect: Consider API for getting kind info - Issue #14378](https://github.com/bevyengine/bevy/issues/14378)
- [frunk: Funktional generic type-level programming in Rust: HList, Coproduct, Generic, LabelledGeneric, Validated, Monoid and friends.](https://github.com/lloydmeta/frunk)
- [struct-metadata: A utility library for letting rust types describe themselves.](https://github.com/adam-douglass/struct-metadata/) ([Docs.rs](https://docs.rs/struct-metadata/latest/struct_metadata/))
  - `#[doc]`

  [struct-metadata: Macros for attaching metadata to structs. : r/rust](https://www.reddit.com/r/rust/comments/1frp4za/structmetadata_macros_for_attaching_metadata_to/)

- [field\_names: proc-macro for accessing struct field names at runtime](https://github.com/TedDriggs/field_names)
- [fields-iter: A crate that allows iterating over struct's fields](https://github.com/ChayimFriedman2/fields-iter) ([Docs.rs](https://docs.rs/fields-iter/latest/fields_iter/))
- [runtime\_struct\_field\_names\_as\_array](https://github.com/0cv/runtime_struct_field_names_as_array)

- [deflect: Reflection via DWARF.](https://github.com/jswrenn/deflect)

  [Native Reflection in Rust | Hacker News](https://news.ycombinator.com/item?id=34001435) ([Hacker News](https://news.ycombinator.com/item?id=34001435))

[→Documentation reflection](../Comments.md#reflection)

## Module reflection
Structs:
```python
import glob
from pathlib import Path
import re

structs = []
for rs in glob.glob('src/**.rs', recursive=True):
    rs = Path(rs).read_text(encoding='utf-8')
    for s in re.findall(r'pub struct ([^\s\(]+)', rs):
        structs.append(s)
print(structs)

structs = ',\n'.join(f'{s}' for s in structs)
Path('src/structs.in.rs').write_text(f'{structs}', encoding='utf-8')
print(structs)
```

[Get all types that implement a trait - Rust Internals](https://internals.rust-lang.org/t/get-all-types-that-implement-a-trait/13553)

[How can I get a list of types that implement a particular trait in Rust? - Stack Overflow](https://stackoverflow.com/questions/55216559/how-can-i-get-a-list-of-types-that-implement-a-particular-trait-in-rust)

## Package reflection
- [inventory: Typed distributed plugin registration](https://github.com/dtolnay/inventory)
  - [Wasm support - Issue #71](https://github.com/dtolnay/inventory/issues/71)
- [linkme: Safe cross-platform linker shenanigans](https://github.com/dtolnay/linkme)
- [rust-ctor: Module initialization/global constructor functions for Rust](https://github.com/mmastrac/rust-ctor)

[Question on the future of inventory, typetag, linkme, ctor, and related crates affected by #47384 : r/rust](https://www.reddit.com/r/rust/comments/sm0m4z/question_on_the_future_of_inventory_typetag/)

[Function/type registration at startup - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/function-type-registration-at-startup/23458)