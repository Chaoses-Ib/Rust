#import "@local/ib:0.1.0": *
#title[C++ FFI]
= Google Crubit: C++/Rust Bidirectional Interop Tool
<crubit>
#a-badge[https://github.com/google/crubit]

#q[
Crubit currently expects deep integration with the build system, and is difficult to deploy to environments dissimilar to Google's monorepo.
We do not have our tooling set up to accept external contributions at this time.
]

#a[Usage outside of Google][https://crubit.rs/overview/status#usage-outside-of-google]:
#q[In 2026, we are building Crubit up to be a tool shaped like OSS users expect: an IDL-based FFI tool with Cargo integration, with _options_ for a better experience in codebases with strong control over the build environment.
(Though for calling Rust from C++, we might stop short of an IDL, and instead rely on compiler-synced binary releases, since there is only one compiler.)

In particular, this involves decomposing Crubit into a collection of parts that can be used on their own, without needing to consume the whole:

- Reusable libraries that implement C++ functionality (e.g., forward declarations, nontrivial object semantics.)
- An IDL-based core, with optional compiler integration at the front-end.
- Support for building with Cargo, stable named versions of Clang or Rust, etc.
]
- #a[Using Crubit for external C++ projects outside Chrome - Issue \#13][https://github.com/google/crubit/issues/13]
