#![feature(coroutines)]
#![feature(proc_macro_hygiene, stmt_expr_attributes)]

use futures::stream::Stream;
use futures_async_stream::{for_await, stream};

#[stream(item = i32)]
async fn foo(stream: impl Stream<Item = i32>) {
    #[for_await]
    for x in stream {
        yield x + 100;
    }
}

async fn test() {
    let stream = foo(futures::stream::iter(vec![1, 2, 3]));
    #[for_await]
    for value in stream {
        println!("{}", value);
    }
}

fn main() {
    futures::executor::block_on(test())
}
