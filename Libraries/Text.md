# Text
## Strings
- [std::string](https://doc.rust-lang.org/std/string/index.html)

  [Storing UTF-8 Encoded Text with Strings - The Rust Programming Language](https://doc.rust-lang.org/book/ch08-02-strings.html)
- [varlen::Str](https://github.com/reinerp/varlen-rs)

  See [Dynamically Sized Types](../Language/Type%20System/Dynamically%20Sized.md) for details.
- [compact_str: A memory efficient string type that can store up to 24* bytes on the stack](https://github.com/ParkMyCar/compact_str)
- [smol_str](https://github.com/rust-analyzer/smol_str)
- [flexstr: A flexible, simple to use, immutable, clone-efficient String replacement for Rust](https://github.com/nu11ptr/flexstr)
- [ArrayString: Fixed capacity stack based generic string that works on stable](https://github.com/paulocsanz/arraystring)
- [ecow: Compact, clone-on-write vector and string.](https://github.com/typst/ecow)

## String pools
- [String Interner: A data structure to efficiently intern, cache and restore strings.](https://github.com/robbepop/string-interner)
- [miniintern: A minimalistic Rust string interning / pooling library.](https://github.com/alex05447/miniintern)

## [→Unicode](https://github.com/Chaoses-Ib/ArtificialIntelligence/blob/main/NLP/Encoding/Unicode/README.md)
- [widestring: A wide string Rust library for converting to and from wide-character strings, including UTF-16 and UTF-32 encoding.](https://github.com/starkat99/widestring-rs)

### Case-insensitive
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
- [bluss/twoway: Twoway / Fast substring search for strings and byte strings (Rust) / Also assorted benchmarks and string search snippets](https://github.com/bluss/twoway)
- [case-insensitive-hashmap: A Rust HashMap that uses Case-Insensitive strings.](https://github.com/PhilipDaniels/case-insensitive-hashmap)