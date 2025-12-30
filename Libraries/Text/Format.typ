#import "@local/ib:0.1.0": *
#title[Formatting]
#a-badge(body: [$arrow$$$Template Languages])[https://github.com/Chaoses-Ib/FormalLanguages/blob/main/Template/README.md]

- #a([```rs std::fmt```], <fmt>)

- #a[ufmt: a smaller, faster and panic-free alternative to core::fmt][https://github.com/japaric/ufmt]
  (discontinued)
  - Cannot be used with ```rs std::io::Cursor```.
  - #a[tfmt: A tiny, fast and panic-free alternative to core::fmt][https://github.com/simsys/tfmt]

  #a[μfmt - a smaller, faster and panic-free alternative to core::fmt : r/rust][https://www.reddit.com/r/rust/comments/g242r1/%CE%BCfmt_a_smaller_faster_and_panicfree_alternative/]

- #a[defmt: Efficient, deferred formatting for logging on embedded systems][https://github.com/knurling-rs/defmt]

= #a[```rs std::fmt```][https://doc.rust-lang.org/std/fmt/index.html]
<fmt>
- ```rs std::fmt``` =
  #a[```rs core::fmt```][https://doc.rust-lang.org/core/fmt/index.html]
  \+ ```rs format!()```

- ```rs write_fmt()``` can't optimize away the ```rs drop(std::io::Error)``` even when returns ```rs Ok()```,
  which introduces a deallocation call.
  - An outer ```rs forget()``` is not enough.
  - A workaround is to not use ```rs std::io``` traits.

  #a[Optimize `io::Write::write_fmt` for constant strings by thaliaarchi - Pull Request \#138650][https://github.com/rust-lang/rust/pull/138650]
