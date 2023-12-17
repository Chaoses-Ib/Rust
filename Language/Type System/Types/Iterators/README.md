# Iterators
[The Rust Programming Language](https://doc.rust-lang.org/book/ch13-02-iterators.html)

[std::iter](https://doc.rust-lang.org/std/iter/index.html)

[Rust Iterator Cheat Sheet](https://danielkeep.github.io/itercheat_baked.html)

```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;

    // Provided methods
    fn next_chunk<const N: usize>(
        &mut self
    ) -> Result<[Self::Item; N], IntoIter<Self::Item, N>>
       where Self: Sized { ... }
    
    fn size_hint(&self) -> (usize, Option<usize>) { ... }

    fn count(self) -> usize
       where Self: Sized { ... }
    
    fn last(self) -> Option<Self::Item>
       where Self: Sized { ... }
    
    fn advance_by(&mut self, n: usize) -> Result<(), NonZeroUsize> { ... }

    fn nth(&mut self, n: usize) -> Option<Self::Item> { ... }

    fn step_by(self, step: usize) -> StepBy<Self>
       where Self: Sized { ... }
    
    fn chain<U>(self, other: U) -> Chain<Self, <U as IntoIterator>::IntoIter>
       where Self: Sized,
             U: IntoIterator<Item = Self::Item> { ... }
    
    fn zip<U>(self, other: U) -> Zip<Self, <U as IntoIterator>::IntoIter>
       where Self: Sized,
             U: IntoIterator { ... }
    
    fn intersperse(self, separator: Self::Item) -> Intersperse<Self>
       where Self: Sized,
             Self::Item: Clone { ... }
    
    fn intersperse_with<G>(self, separator: G) -> IntersperseWith<Self, G>
       where Self: Sized,
             G: FnMut() -> Self::Item { ... }
    
    fn map<B, F>(self, f: F) -> Map<Self, F>
       where Self: Sized,
             F: FnMut(Self::Item) -> B { ... }
    
    fn for_each<F>(self, f: F)
       where Self: Sized,
             F: FnMut(Self::Item) { ... }
    
    fn filter<P>(self, predicate: P) -> Filter<Self, P>
       where Self: Sized,
             P: FnMut(&Self::Item) -> bool { ... }
    
    fn filter_map<B, F>(self, f: F) -> FilterMap<Self, F>
       where Self: Sized,
             F: FnMut(Self::Item) -> Option<B> { ... }
    
    fn enumerate(self) -> Enumerate<Self>
       where Self: Sized { ... }
    
    fn peekable(self) -> Peekable<Self>
       where Self: Sized { ... }
    
    fn skip_while<P>(self, predicate: P) -> SkipWhile<Self, P>
       where Self: Sized,
             P: FnMut(&Self::Item) -> bool { ... }
    
    fn take_while<P>(self, predicate: P) -> TakeWhile<Self, P>
       where Self: Sized,
             P: FnMut(&Self::Item) -> bool { ... }
    
    fn map_while<B, P>(self, predicate: P) -> MapWhile<Self, P>
       where Self: Sized,
             P: FnMut(Self::Item) -> Option<B> { ... }
    
    fn skip(self, n: usize) -> Skip<Self>
       where Self: Sized { ... }
    
    fn take(self, n: usize) -> Take<Self>
       where Self: Sized { ... }
    
    fn scan<St, B, F>(self, initial_state: St, f: F) -> Scan<Self, St, F>
       where Self: Sized,
             F: FnMut(&mut St, Self::Item) -> Option<B> { ... }
    
    fn flat_map<U, F>(self, f: F) -> FlatMap<Self, U, F>
       where Self: Sized,
             U: IntoIterator,
             F: FnMut(Self::Item) -> U { ... }
    
    fn flatten(self) -> Flatten<Self>
       where Self: Sized,
             Self::Item: IntoIterator { ... }
    
    fn fuse(self) -> Fuse<Self>
       where Self: Sized { ... }
    
    fn inspect<F>(self, f: F) -> Inspect<Self, F>
       where Self: Sized,
             F: FnMut(&Self::Item) { ... }
    
    fn by_ref(&mut self) -> &mut Self
       where Self: Sized { ... }
    
    fn collect<B>(self) -> B
       where B: FromIterator<Self::Item>,
             Self: Sized { ... }
    
    fn try_collect<B>(
        &mut self
    ) -> <<Self::Item as Try>::Residual as Residual<B>>::TryType
       where Self: Sized,
             Self::Item: Try,
             <Self::Item as Try>::Residual: Residual<B>,
             B: FromIterator<<Self::Item as Try>::Output> { ... }
    
    fn collect_into<E>(self, collection: &mut E) -> &mut E
       where E: Extend<Self::Item>,
             Self: Sized { ... }
    
    fn partition<B, F>(self, f: F) -> (B, B)
       where Self: Sized,
             B: Default + Extend<Self::Item>,
             F: FnMut(&Self::Item) -> bool { ... }
    
    fn partition_in_place<'a, T, P>(self, predicate: P) -> usize
       where T: 'a,
             Self: Sized + DoubleEndedIterator<Item = &'a mut T>,
             P: FnMut(&T) -> bool { ... }

    fn is_partitioned<P>(self, predicate: P) -> bool
       where Self: Sized,
             P: FnMut(Self::Item) -> bool { ... }

    fn try_fold<B, F, R>(&mut self, init: B, f: F) -> R
       where Self: Sized,
             F: FnMut(B, Self::Item) -> R,
             R: Try<Output = B> { ... }

    fn try_for_each<F, R>(&mut self, f: F) -> R
       where Self: Sized,
             F: FnMut(Self::Item) -> R,
             R: Try<Output = ()> { ... }

    fn fold<B, F>(self, init: B, f: F) -> B
       where Self: Sized,
             F: FnMut(B, Self::Item) -> B { ... }

    fn reduce<F>(self, f: F) -> Option<Self::Item>
       where Self: Sized,
             F: FnMut(Self::Item, Self::Item) -> Self::Item { ... }

    fn try_reduce<F, R>(
        &mut self,
        f: F
    ) -> <<R as Try>::Residual as Residual<Option<<R as Try>::Output>>>::TryType
       where Self: Sized,
             F: FnMut(Self::Item, Self::Item) -> R,
             R: Try<Output = Self::Item>,
             <R as Try>::Residual: Residual<Option<Self::Item>> { ... }

    fn all<F>(&mut self, f: F) -> bool
       where Self: Sized,
             F: FnMut(Self::Item) -> bool { ... }

    fn any<F>(&mut self, f: F) -> bool
       where Self: Sized,
             F: FnMut(Self::Item) -> bool { ... }

    fn find<P>(&mut self, predicate: P) -> Option<Self::Item>
       where Self: Sized,
             P: FnMut(&Self::Item) -> bool { ... }

    fn find_map<B, F>(&mut self, f: F) -> Option<B>
       where Self: Sized,
             F: FnMut(Self::Item) -> Option<B> { ... }

    fn try_find<F, R>(
        &mut self,
        f: F
    ) -> <<R as Try>::Residual as Residual<Option<Self::Item>>>::TryType
       where Self: Sized,
             F: FnMut(&Self::Item) -> R,
             R: Try<Output = bool>,
             <R as Try>::Residual: Residual<Option<Self::Item>> { ... }

    fn position<P>(&mut self, predicate: P) -> Option<usize>
       where Self: Sized,
             P: FnMut(Self::Item) -> bool { ... }

    fn rposition<P>(&mut self, predicate: P) -> Option<usize>
       where P: FnMut(Self::Item) -> bool,
             Self: Sized + ExactSizeIterator + DoubleEndedIterator { ... }

    fn max(self) -> Option<Self::Item>
       where Self: Sized,
             Self::Item: Ord { ... }

    fn min(self) -> Option<Self::Item>
       where Self: Sized,
             Self::Item: Ord { ... }

    fn max_by_key<B, F>(self, f: F) -> Option<Self::Item>
       where B: Ord,
             Self: Sized,
             F: FnMut(&Self::Item) -> B { ... }

    fn max_by<F>(self, compare: F) -> Option<Self::Item>
       where Self: Sized,
             F: FnMut(&Self::Item, &Self::Item) -> Ordering { ... }

    fn min_by_key<B, F>(self, f: F) -> Option<Self::Item>
       where B: Ord,
             Self: Sized,
             F: FnMut(&Self::Item) -> B { ... }

    fn min_by<F>(self, compare: F) -> Option<Self::Item>
       where Self: Sized,
             F: FnMut(&Self::Item, &Self::Item) -> Ordering { ... }

    fn rev(self) -> Rev<Self>
       where Self: Sized + DoubleEndedIterator { ... }

    fn unzip<A, B, FromA, FromB>(self) -> (FromA, FromB)
       where FromA: Default + Extend<A>,
             FromB: Default + Extend<B>,
             Self: Sized + Iterator<Item = (A, B)> { ... }

    fn copied<'a, T>(self) -> Copied<Self>
       where T: 'a + Copy,
             Self: Sized + Iterator<Item = &'a T> { ... }

    fn cloned<'a, T>(self) -> Cloned<Self>
       where T: 'a + Clone,
             Self: Sized + Iterator<Item = &'a T> { ... }

    fn cycle(self) -> Cycle<Self>
       where Self: Sized + Clone { ... }

    fn array_chunks<const N: usize>(self) -> ArrayChunks<Self, N>
       where Self: Sized { ... }

    fn sum<S>(self) -> S
       where Self: Sized,
             S: Sum<Self::Item> { ... }

    fn product<P>(self) -> P
       where Self: Sized,
             P: Product<Self::Item> { ... }

    fn cmp<I>(self, other: I) -> Ordering
       where I: IntoIterator<Item = Self::Item>,
             Self::Item: Ord,
             Self: Sized { ... }

    fn cmp_by<I, F>(self, other: I, cmp: F) -> Ordering
       where Self: Sized,
             I: IntoIterator,
             F: FnMut(Self::Item, <I as IntoIterator>::Item) -> Ordering { ... }

    fn partial_cmp<I>(self, other: I) -> Option<Ordering>
       where I: IntoIterator,
             Self::Item: PartialOrd<<I as IntoIterator>::Item>,
             Self: Sized { ... }

    fn partial_cmp_by<I, F>(self, other: I, partial_cmp: F) -> Option<Ordering>
       where Self: Sized,
             I: IntoIterator,
             F: FnMut(Self::Item, <I as IntoIterator>::Item) -> Option<Ordering> { ... }

    fn eq<I>(self, other: I) -> bool
       where I: IntoIterator,
             Self::Item: PartialEq<<I as IntoIterator>::Item>,
             Self: Sized { ... }

    fn eq_by<I, F>(self, other: I, eq: F) -> bool
       where Self: Sized,
             I: IntoIterator,
             F: FnMut(Self::Item, <I as IntoIterator>::Item) -> bool { ... }

    fn ne<I>(self, other: I) -> bool
       where I: IntoIterator,
             Self::Item: PartialEq<<I as IntoIterator>::Item>,
             Self: Sized { ... }

    fn lt<I>(self, other: I) -> bool
       where I: IntoIterator,
             Self::Item: PartialOrd<<I as IntoIterator>::Item>,
             Self: Sized { ... }

    fn le<I>(self, other: I) -> bool
       where I: IntoIterator,
             Self::Item: PartialOrd<<I as IntoIterator>::Item>,
             Self: Sized { ... }

    fn gt<I>(self, other: I) -> bool
       where I: IntoIterator,
             Self::Item: PartialOrd<<I as IntoIterator>::Item>,
             Self: Sized { ... }

    fn ge<I>(self, other: I) -> bool
       where I: IntoIterator,
             Self::Item: PartialOrd<<I as IntoIterator>::Item>,
             Self: Sized { ... }

    fn is_sorted(self) -> bool
       where Self: Sized,
             Self::Item: PartialOrd<Self::Item> { ... }

    fn is_sorted_by<F>(self, compare: F) -> bool
       where Self: Sized,
             F: FnMut(&Self::Item, &Self::Item) -> Option<Ordering> { ... }

    fn is_sorted_by_key<F, K>(self, f: F) -> bool
       where Self: Sized,
             F: FnMut(Self::Item) -> K,
             K: PartialOrd<K> { ... }
}

/// An iterator that always continues to yield `None` when exhausted.
pub trait FusedIterator: Iterator { }

/// An iterator that reports an accurate length using `size_hint`.
pub unsafe trait TrustedLen: Iterator { }

/// An iterator that knows its exact length.
pub trait ExactSizeIterator: Iterator {
    // Provided methods
    fn len(&self) -> usize { ... }
    fn is_empty(&self) -> bool { ... }
}

/// An iterator able to yield elements from both ends.
pub trait DoubleEndedIterator: Iterator {
    fn next_back(&mut self) -> Option<Self::Item>;

    // Provided methods
    fn advance_back_by(&mut self, n: usize) -> Result<(), NonZeroUsize> { ... }

    fn nth_back(&mut self, n: usize) -> Option<Self::Item> { ... }

    fn try_rfold<B, F, R>(&mut self, init: B, f: F) -> R
       where Self: Sized,
             F: FnMut(B, Self::Item) -> R,
             R: Try<Output = B> { ... }
    
    fn rfold<B, F>(self, init: B, f: F) -> B
       where Self: Sized,
             F: FnMut(B, Self::Item) -> B { ... }
    
    fn rfind<P>(&mut self, predicate: P) -> Option<Self::Item>
       where Self: Sized,
             P: FnMut(&Self::Item) -> bool { ... }
}
```

Iterators, although a high-level abstraction, get compiled down to roughly the same code as if you’d written the lower-level code yourself. Iterators are one of Rust’s zero-cost abstractions, by which we mean using the abstraction imposes no additional runtime overhead.[^performance]

- Backward iterators

  [list - Iterating forward and backward - Stack Overflow](https://stackoverflow.com/questions/38227722/iterating-forward-and-backward)

  - `clone()`
  - [prev-iter: Iterator which allows you to view the previous element](https://github.com/AgostonSzepessy/prev-iter)

## Consuming adaptors
Methods that call next are called **consuming adaptors**, because calling them uses up the iterator.

- `Extend`
  - [Tracking Issue for `Extend::{extend_one,extend_reserve}` - Issue #72631 - rust-lang/rust](https://github.com/rust-lang/rust/issues/72631)
    - `extend([v])`

## Iterator adaptors
**Iterator adaptors** are methods defined on the `Iterator` trait that don’t consume the iterator. Instead, they produce different iterators by changing some aspect of the original iterator.

[Itertools: Extra iterator adaptors, iterator methods, free functions, and macros.](https://github.com/rust-itertools/itertools)

Merging:
- [itertools::kmerge](https://docs.rs/itertools/latest/itertools/trait.Itertools.html#method.kmerge)
- [\[Solved\] Merge multiple sorted vectors using iterators - help - The Rust Programming Language Forum ](https://users.rust-lang.org/t/solved-merge-multiple-sorted-vectors-using-iterators/6543)


[^performance]: [Comparing Performance: Loops vs. Iterators - The Rust Programming Language](https://doc.rust-lang.org/book/ch13-04-performance.html)