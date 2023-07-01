# Textual Types
[The Rust Reference](https://doc.rust-lang.org/reference/types/textual.html)

## char
A value of type `char` is a [Unicode scalar value](http://www.unicode.org/glossary/#unicode_scalar_value) (i.e. a code point that is not a surrogate), represented as a 32-bit unsigned word in the 0x0000 to 0xD7FF or 0xE000 to 0x10FFFF range. It is immediate [Undefined Behavior](https://doc.rust-lang.org/reference/behavior-considered-undefined.html) to create a `char` that falls outside this range. A `[char]` is effectively a UCS-4 / UTF-32 string of length 1.

## Char array
- Finding a char

  ```rust
  array.iter().position(|c| c == 'p')
  ```

- Finding a subsequence

  A simple but slow solution:
  ```rust
  array.windows(pattern.len()).position(|window| window == pattern)
  ```

  [rust - How can I find a subsequence in a &[u8] slice? - Stack Overflow](https://stackoverflow.com/questions/35901547/how-can-i-find-a-subsequence-in-a-u8-slice)

## [str](https://doc.rust-lang.org/std/primitive.str.html)
A value of type `str` is represented the same way as `[u8]`, it is a slice of 8-bit unsigned bytes. However, the Rust standard library makes extra assumptions about `str`: methods working on `str` assume and ensure that the data in there is valid UTF-8. Calling a `str` method with a non-UTF-8 buffer can cause [Undefined Behavior](https://doc.rust-lang.org/reference/behavior-considered-undefined.html) now or in the future.

Since `str` is a [dynamically sized type](https://doc.rust-lang.org/reference/dynamically-sized-types.html), it can only be instantiated through a pointer type, such as `&str`.

- `str` is measured in bytes.

  [String offsets should always be in bytes · Issue #1849 · rust-lang/rust](https://github.com/rust-lang/rust/issues/1849)

  To measure a `str` in chars, call [chars](https://doc.rust-lang.org/std/primitive.str.html#method.chars).

- `str` cannot be indexed directly.

  To index a byte, call [as_bytes](https://doc.rust-lang.org/std/primitive.str.html#method.as_bytes) (v1.39.0) (`as_bytes()[i]`).

  To index a char, call [chars](https://doc.rust-lang.org/std/primitive.str.html#method.chars) (`chars().nth()`).

- `str` can be indexed with slices.

  - [get](https://doc.rust-lang.org/std/primitive.str.html#method.get) (v1.20.0)
  - [slice_unchecked](https://doc.rust-lang.org/std/primitive.str.html#method.slice_unchecked) (~v1.29.0)

Literals:
- [rust - What is the syntax for a multiline string literal? - Stack Overflow](https://stackoverflow.com/questions/29483365/what-is-the-syntax-for-a-multiline-string-literal)

  ```rust
  assert_eq!("line one
  line two",
  "line one\nline two");

  assert_eq!("one line \
      written over \
      several",
  "one line written over several");

  assert_eq!("multiple\n\
              lines\n\
              with\n\
              indentation",
  "multiple\nlines\nwith\nindentation");
  ```