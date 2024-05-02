# [Rust](https://www.rust-lang.org/)
[GitHub](https://github.com/rust-lang/rust), [Wikipedia](https://en.wikipedia.org/wiki/Rust_(programming_language))

Books:
- [The Rust Programming Language](https://doc.rust-lang.org/book/) ([GitHub](https://github.com/rust-lang/book))

  [update the book for async/await · Issue #1275 · rust-lang/book](https://github.com/rust-lang/book/issues/1275)
- [The Rust Reference](https://doc.rust-lang.org/reference/) ([GitHub](https://github.com/rust-lang/reference/))
- [Rust for C#/.NET Developers](https://microsoft.github.io/rust-for-dotnet-devs/latest/introduction.html)

Blogs:
- [Rust Blog](https://blog.rust-lang.org/)

> 如果对 C++ 很熟的话，一天上手问题不大，所有权那部分 C++ 有移动语义对应，泛型就是个退化的模板，唯一可能头疼点的就是 concurrency 那块了，Send 和 Sync 要理解一下，async/await 在 C++20 里才有，没用过的话也要适应下。

[Rust Search Extension: 🦀 The ultimate search extension for Rust](https://github.com/huhu/rust-search-extension)
- `rs`

## Pros
[Is the Rust the Future? | Why? (What about the competitors?) : rust](https://www.reddit.com/r/rust/comments/12aecme/is_the_rust_the_future_why_what_about_the/)

## Cons
- The curse of complexity
  
  > Worse is better，语言的流行需要的是简单，不是“好”。

  [Rust's Ugly Syntax](https://matklad.github.io/2023/01/26/rusts-ugly-syntax.html)

[Why Not Rust?](https://matklad.github.io/2020/09/20/why-not-rust.html)

[graydon2 | The Rust I Wanted Had No Future](https://graydon2.dreamwidth.org/307291.html)
- > The point is to indicate *thematic divergence*. The priorities I had while working on the language are broadly not the revealed priorities of the community that's developed around the language in the years since, or even that were being-revealed in the years during. **I would have traded performance and expressivity away for simplicity** -- both end-user cognitive load and implementation simplicity in the compiler -- and by doing so I would have taken the language in a direction *broadly* opposed to where a lot of people wanted it to go.

  > I don't think Graydon was about to reinvent Go, no. But the ideas he advocates for here - minimizing user- and implementer-facing complexity, actors/green threads, a fixed set of built-in containers, more support for dynamic dispatch, some acceptance for nonzero-cost abstractions - are all found in Go too.

- [The Rust I Wanted Had No Future : rust](https://www.reddit.com/r/rust/comments/1415is1/the_rust_i_wanted_had_no_future/)
- [The Rust I Wanted Had No Future - Graydon Hoare : ProgrammingLanguages](https://www.reddit.com/r/ProgrammingLanguages/comments/141qm6g/the_rust_i_wanted_had_no_future_graydon_hoare/)
- [The Rust I wanted had No Future - Graydon Hoare : programming](https://www.reddit.com/r/programming/comments/16268p1/the_rust_i_wanted_had_no_future_graydon_hoare/)

## Performance
Books:
- [The Rust Performance Book](https://nnethercote.github.io/perf-book/title-page.html) ([GitHub](https://github.com/nnethercote/perf-book))

Articles:
- [Why Not Rust?](https://matklad.github.io/2020/09/20/why-not-rust.html#:~:text=bigger%20build%20system.-,Performance,-%E2%80%9CUsing%20LLVM)
- [Optimization - Making Rust Code Go Brrrr](https://aspenuwu.me/posts/rust-optimization.html)