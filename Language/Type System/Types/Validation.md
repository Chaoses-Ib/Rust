# Validation
- `try_new()`
- `TryInto`
- [validator: Simple validation for Rust structs](https://github.com/Keats/validator)
  - [Help with maintenance - Issue #201](https://github.com/Keats/validator/issues/201)
- [garde: A powerful validation library for Rust](https://github.com/jprochazk/garde) (inactive)

  > This crate is heavily inspired by the [validator](https://github.com/Keats/validator) crate. It is essentially a full rewrite of `validator`. The creation of this crate was prompted by [this comment](https://github.com/Keats/validator/issues/201#issuecomment-1167018511) and a few others talking about a potential rewrite.

  > The major differences are:
  > 
  > * Validation rules are traits, so they may be implemented for custom types. ([Use traits for validation rules #205](https://github.com/Keats/validator/issues/205))
  > * The generated trait accepts a `Context` type, which is passed to each `custom` validator. This allows arbitrary customization to the validation process, and it opens the space up for use-cases like localization of error messages.
  > * The derive macro supports enums. ([Support enum #77](https://github.com/Keats/validator/issues/77))
  > * Added `Valid<T>` and `Unvalidated<T>`, which implement the typestate pattern. ([Enforce validation with typestate #185](https://github.com/Keats/validator/issues/185))
  >   `Unvalidated` may be created from arbitrary values, but the only way to create `Valid` is to call `validate` on `Unvalidated`. `Unvalidated` also implements `serde::Deserialize`, so it may be used in [integrations with web frameworks](https://github.com/jprochazk/garde/issues/12).
  > * Rules are responsible for generating error messages, and the resulting errors do not receive params afterwards. This means that `sensitive` should no longer be necessary, but I might also be totally wrong about this approach, not sure about this!
  > 
  > [Lots of remaining work to do](https://github.com/jprochazk/garde/milestone/1), but as far as I can tell, the only features which are missing for feature parity with `validator` are the `nested` and `required` rules. I'm really interested in seeing what people think!

- [Nutype: Rust newtype with guarantees 🇺🇦 🦀](https://github.com/greyblake/nutype)

  [NNN: a new take on nutype : r/rust](https://www.reddit.com/r/rust/comments/1hovz1p/nnn_a_new_take_on_nutype/)

- [prae: prae is a crate that aims to provide a better way to define types that require validation.](https://github.com/teenjuna/prae) (inactive)

  > I like the concept, but did they *have* to go with that COBOL/Ruby BDD-ish "our DSL's syntax is scared of punctuation" aesthetic?

- [validators: A library for validating and modeling user input.](https://github.com/magiclen/validators)

Discussions:
- 2021-08 [Idiomatic Way to Validate Struct Field Values : r/rust](https://www.reddit.com/r/rust/comments/paflme/idiomatic_way_to_validate_struct_field_values/)
- 2021-09 [(Learning) Why doesn't rust have an easy way of validating custom-type fields? : r/rust](https://www.reddit.com/r/rust/comments/pfsitq/learning_why_doesnt_rust_have_an_easy_way_of/)
