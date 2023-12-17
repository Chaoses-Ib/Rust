# Text
## Strings
- [std::string](https://doc.rust-lang.org/std/string/index.html)

  [Storing UTF-8 Encoded Text with Strings - The Rust Programming Language](https://doc.rust-lang.org/book/ch08-02-strings.html)

  - Size: 24 (64-bit)

- [compact_str: A memory efficient string type that can store up to 24* bytes on the stack](https://github.com/ParkMyCar/compact_str)
  - Size: 24 (64-bit)

- [smol_str](https://github.com/rust-analyzer/smol_str)
  - Size: 24 (64-bit)

- [flexstr: A flexible, simple to use, immutable, clone-efficient String replacement for Rust](https://github.com/nu11ptr/flexstr)
  - Size: 24 (64-bit)

- [smallstr: String-like container based on SmallVec](https://github.com/murarth/smallstr/tree/master)
  - Size: 24 (64-bit)

- [ecow: Compact, clone-on-write vector and string.](https://github.com/typst/ecow)
  - Size: 16 (64-bit)

- [varlen::Str](https://github.com/reinerp/varlen-rs)
  - Size: 8 (64-bit)

  See [Dynamically Sized Types](../Language/Type%20System/Dynamically%20Sized.md) for details.

- [ArrayString: Fixed capacity stack based generic string that works on stable](https://github.com/paulocsanz/arraystring)
  - Size: N + 1

- [fixedstr](https://docs.rs/fixedstr/latest/fixedstr/index.html)
  - Size: N + 1
  - Bad commit messages.

- [arrayvec::ArrayString](https://docs.rs/arrayvec/latest/arrayvec/struct.ArrayString.html)
  - Size: N + 4
  - [Can I change `LenUint` to `u8`? - Issue #247](https://github.com/bluss/arrayvec/issues/247)

- [staticvec::StaticString](https://docs.rs/staticvec/latest/staticvec/struct.StaticString.html)
  - Size: N + 8
  - [There's not actually any practical reason for the `length` field of a StaticVec to be of type `usize` - Issue #28](https://github.com/slightlyoutofphase/staticvec/issues/28)

## String pools
- [String Interner: A data structure to efficiently intern, cache and restore strings.](https://github.com/robbepop/string-interner)
- [miniintern: A minimalistic Rust string interning / pooling library.](https://github.com/alex05447/miniintern)

## [→Unicode](https://github.com/Chaoses-Ib/ArtificialIntelligence/blob/main/NLP/Encoding/Unicode/README.md)
- [bstr: A string type for Rust that is not required to be valid UTF-8.](https://github.com/BurntSushi/bstr)

  [Not everything is UTF-8](https://octobus.net/blog/2020-06-05-not-everything-is-utf8.html)

  [r/rust](https://www.reddit.com/r/rust/comments/gz33u6/not_everything_is_utf8/)

- [widestring: A wide string Rust library for converting to and from wide-character strings, including UTF-16 and UTF-32 encoding.](https://github.com/starkat99/widestring-rs)

## ASCII
### Case
- [str Utils: This crate provides some traits to extend types which implement `AsRef<[u8]>` or `AsRef<str>`.](https://github.com/magiclen/str-utils)

  [如何使Rust编程语言的`starts_with`和`ends_with`方法忽略大小写？ | MagicLen](https://magiclen.org/str-utils/)

  - [Make Unicode support as an optional feature - Issue #1](https://github.com/magiclen/str-utils/issues/1)
  - [Documentation about Unicode normalization - Issue #2](https://github.com/magiclen/str-utils/issues/2)

- [unicase: Unicode Case-folding for Rust](https://github.com/seanmonstar/unicase)
  - [Ascii in unicase - Rust](https://docs.rs/unicase/latest/unicase/struct.Ascii.html)

For hash maps:
```rust
#[derive(Debug, Clone)]
pub struct AsciiCaseInsensitiveString(String);

impl PartialEq for AsciiCaseInsensitiveString {
    fn eq(&self, other: &Self) -> bool {
        self.0.eq_ignore_ascii_case(&other.0)
    }
}

impl Eq for AsciiCaseInsensitiveString {}

impl Hash for AsciiCaseInsensitiveString {
    fn hash<H: Hasher>(&self, hasher: &mut H) {
        for byte in self.0.as_str().bytes().map(|b| b.to_ascii_lowercase()) {
            hasher.write_u8(byte);
        }
    }
}

impl AsciiCaseInsensitiveString {
    /// Note that `&str` is case sensitive.
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl From<String> for AsciiCaseInsensitiveString {
    fn from(value: String) -> Self {
        Self(value)
    }
}

impl From<&str> for AsciiCaseInsensitiveString {
    fn from(value: &str) -> Self {
        Self(String::from(value))
    }
}

impl Into<String> for AsciiCaseInsensitiveString {
    fn into(self) -> String {
        self.0
    }
}
```

## Algorithms
- [case-insensitive-hashmap: A Rust HashMap that uses Case-Insensitive strings.](https://github.com/PhilipDaniels/case-insensitive-hashmap)