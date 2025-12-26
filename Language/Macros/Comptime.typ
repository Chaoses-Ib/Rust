#import "@local/ib:0.1.0": *
#title[Comptime]
#a[Comptime | zig.guide][https://zig.guide/language-basics/comptime/]

#a[reflection and comptime - Rust Project Goals][https://rust-lang.github.io/rust-project-goals/2025h2/reflection-and-comptime.html]

- #a[First-class compile time type manipulation - Issue \#3669 - rust-lang/rfcs][https://github.com/rust-lang/rfcs/issues/3669]
- Crabtime
- #a[codebycruz/constime: Zig's comptime for Rust, with zero dependencies.][https://github.com/codebycruz/constime]
- #a[nhynes/comptime-rs: Zig comptime using Rust proc macros][https://github.com/nhynes/comptime-rs]

#a[Trying to understand and summarize the differences between Rust's `const fn` and Zig's `comptime` : r/rust][https://www.reddit.com/r/rust/comments/s8uula/trying_to_understand_and_summarize_the/]

#t[2508]
#a[How far is Rust lagging Zig regarding const eval? : r/rust][https://www.reddit.com/r/rust/comments/1mzyo79/how_far_is_rust_lagging_zig_regarding_const_eval/]

= Crabtime
#a-badge[https://github.com/wdanilo/crabtime]
#a-badge[https://docs.rs/crabtime/]

- Formerly `eval-macro`

  #t[250306]
  #a[[Media] Introducing eval_macro: A New Way to Write Rust Macros : r/rust][https://www.reddit.com/r/rust/comments/1j42fgi/media_introducing_eval_macro_a_new_way_to_write/]

#a[Crabtime: Zig's Comptime in Rust | Hacker News][https://news.ycombinator.com/item?id=43415820]
#a-badge[https://lobste.rs/s/r1hu2x/crabtime_zig_s_comptime_rust]

#q[
The content of a function annotated with `crabtime::function` is pasted into the `main`
function of a temporary Rust project. This project is created, compiled, executed, and (if
caching is disabled) removed at build time, and its `stdout` becomes the generated Rust code.
The generated `main` function looks something like this:
```rs
const SOURCE_CODE: &str = "..."; // Your code as a string.

# mod phantom_for_crabtime_name_crash_resolution {
mod crabtime {
    // Various utils described in this documentation.
    # pub fn push_as_str(str: &mut String, result: &()) {}
    # pub fn prefix_lines_with_output(input: &str) -> String { String::new() }
}

fn main() {
    let mut __output_buffer__ = String::new();
    let result = {
        // Your code.
    };
    crabtime::push_as_str(&mut __output_buffer__, &result);
    println!("{}", crabtime::prefix_lines_with_output(&__output_buffer__));
}
# }
# fn main() {}
```

The `output!` macro is essentially a shortcut for writing to output buffer using `format!`, so
this:
```rs
#[crabtime::function]
fn my_macro_expansion1(components: Vec<String>) {
    for dim in 1 ..= components.len() {
        let cons = components[0..dim].join(",");
        crabtime::output! {
            enum Position{{dim}} {
                {{cons}}
            }
        }
    }
}
my_macro_expansion1!(["X", "Y", "Z", "W"]);
# fn main() {}
```

Is equivalent to:
```rs
#[crabtime::function]
fn my_macro_expansion2(pattern!([$($components_arg:expr),*$(,)?]): _) {
    let components: Vec<String> = expand!(
        [$(crabtime::stringify_if_needed!($components_arg).to_string()),*]
    ).into_iter().collect();
    for dim in 1 ..= components.len() {
        let cons = components[0..dim].join(",");
        crabtime::output_str! {"
            enum Position{dim} {{
                {cons}
            }}
        "}
    }
}
my_macro_expansion2!(["X", "Y", "Z", "W"]);
# fn main() {}
```

Which, ultimately, is equivalent to:
```rs
#[crabtime::function]
fn my_macro_expansion4() {
    let components = ["X", "Y", "Z", "W"];
    for dim in 1 ..= components.len() {
        let cons = components[0..dim].join(",");
        println!("[OUTPUT] enum Position{dim} {{");
        println!("[OUTPUT]     {cons}");
        println!("[OUTPUT] }}");
    }
}
my_macro_expansion4!();
# fn main() {}
```
]

Compression:
```rs
macro_rules! compressed {
    ($e:expr) => {
        crabtime::eval! {
            #![dependency(flate2 = "1.0")]
            use std::io::prelude::*;
            use flate2::Compression;
            use flate2::write::DeflateEncoder;

            let mut e = DeflateEncoder::new(Vec::new(), Compression::default());
            e.write_all($e).unwrap();
            let data = format!("{:?}", e.finish().unwrap());

            crabtime::output! {
                {{data}}
            }
        }
    };
}
```
