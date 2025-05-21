# Type Conversions
## Transmutes
Transmuting, bit casting

[Transmutes - The Rustonomicon](https://doc.rust-lang.org/nomicon/transmutes.html)

- [std::mem::transmute](https://doc.rust-lang.org/std/mem/fn.transmute.html)

  > Reinterprets the bits of a value of one type as another type.
- [TransmuteFrom in std::mem - Rust](https://doc.rust-lang.org/nightly/std/mem/trait.TransmuteFrom.html)
  - [Tracking Issue for Transmutability Trait: `#[transmutability]` - Issue #99571 - rust-lang/rust](https://github.com/rust-lang/rust/issues/99571)
- [google/zerocopy: Zerocopy makes zero-cost memory manipulation effortless. We write `unsafe` so you don't have to.](https://github.com/google/zerocopy) ([Docs.rs](https://docs.rs/zerocopy/latest/zerocopy/))
  - `Vec -> &[u8]`: `vec.as_bytes()`
  - `&[u8] -> &[T]`: `<[T]>::ref_from_bytes(bytes).unwrap()`
  - rand

    [Use zerocopy to replace some unsafe code by joshlf - Pull Request #1349 - rust-random/rand](https://github.com/rust-random/rand/pull/1349)

    [Rand now depends on zerocopy : r/rust](https://www.reddit.com/r/rust/comments/1igjiip/rand_now_depends_on_zerocopy/)
    > The people in the safe transmute project are the same people working on `zerocopy`.

    > Crates like bytemuck and zerocopy use syntactic heuristics, static assertions, and basic induction over traits to provide safe(er) APIs for some of the transmutes one might like to do. But because these crates don't have the same sort of visibility the compiler does, there are limits to how much they can do.

    [Make the dependency on zerocopy optional - Issue #1574 - rust-random/rand](https://github.com/rust-random/rand/issues/1574)
- [Lokathor/bytemuck: A crate for mucking around with piles of bytes](https://github.com/Lokathor/bytemuck)

[What is the difference between zerocopy 0.8 and bytemuck? : r/rust](https://www.reddit.com/r/rust/comments/1fz3ul5/what_is_the_difference_between_zerocopy_08_and/)
> bytemuck: simple, straightforward implementation that covers most use cases. Supports even ancient Rust versions. Stabilized, does what it set out to do, unlikely to change or break semver.
> 
> zerocopy: covers certain less common use cases that bytemuck doesn't (like the ones described in 0.8 changelog). Ongoing experimentation with the API, occasional breaking changes. More complex, therefore not as straightforward to audit (this may matter if you're adopting it in a company).
> 
> In the long run, both should become unnecessary once [`TransmuteFrom`](https://doc.rust-lang.org/nightly/std/mem/trait.TransmuteFrom.html) is be stabilized in the standard library. It provides the best coverage.

[Moving from zerocopy to bytemuck - Issue #82 - meilisearch/heed](https://github.com/meilisearch/heed/issues/82)

[Transmute is like, the most unsafe thing possible. It basically checks if the tw... | Hacker News](https://news.ycombinator.com/item?id=16226444)
