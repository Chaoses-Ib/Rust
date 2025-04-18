#![feature(coroutines)]
#![feature(proc_macro_hygiene, stmt_expr_attributes)]

use std::time::Duration;

use futures::stream::Stream;
use futures_async_stream::{for_await, stream};

// #[stream(item = i32)]
// async fn foo(stream: impl Stream<Item = i32>) {
//     let interval = tokio::time::interval(Duration::from_secs(1));
//     let sleep = tokio::time::sleep(Duration::from_secs(10));
//     interval.tick().await;
//     loop {
//         // TODO: https://github.com/taiki-e/futures-async-stream/issues/4
//         tokio::select! {
//             _ = interval.tick() => println!("{}", 1),
//             _ = sleep => println!("{}", 100),
//             else => break,
//         };
//     }
// }

fn foo(stream: impl Stream<Item = i32>) -> impl Stream<Item = i32> {
    async_stream::stream! {
        let mut interval = tokio::time::interval(Duration::from_secs(1));
        let sleep = tokio::time::sleep(Duration::from_secs(10));
        tokio::pin!(sleep);
        let mut i = 0;
        loop {
            tokio::select! {
                _ = interval.tick() => {
                    i += 1;
                    yield i
                },
                _ = &mut sleep => {
                    yield 100;
                    break
                },
                // else => (),
            };
        }
    }
}

#[tokio::main]
async fn main() {
    let stream = foo(futures::stream::iter(vec![1, 2, 3]));
    #[for_await]
    for value in stream {
        println!("{}", value);
    }
}
