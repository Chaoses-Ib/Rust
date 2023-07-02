# Async/await
[Asynchronous Programming in Rust](https://rust-lang.github.io/async-book/)

## Future
```rust
pub trait Future {
    type Output;

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output>;
}

pub enum Poll<T> {
    Ready(T),
    Pending,
}
```

```rust
pub struct TimerFuture {
    shared_state: Arc<Mutex<SharedState>>,
}

/// Shared state between the future and the waiting thread
struct SharedState {
    /// Whether or not the sleep time has elapsed
    completed: bool,

    /// The waker for the task that `TimerFuture` is running on.
    /// The thread can use this after setting `completed = true` to tell
    /// `TimerFuture`'s task to wake up, see that `completed = true`, and
    /// move forward.
    waker: Option<Waker>,
}

impl TimerFuture {
    /// Create a new `TimerFuture` which will complete after the provided
    /// timeout.
    pub fn new(duration: Duration) -> Self {
        let shared_state = Arc::new(Mutex::new(SharedState {
            completed: false,
            waker: None,
        }));

        // Spawn the new thread
        let thread_shared_state = shared_state.clone();
        thread::spawn(move || {
            thread::sleep(duration);
            let mut shared_state = thread_shared_state.lock().unwrap();
            // Signal that the timer has completed and wake up the last
            // task on which the future was polled, if one exists.
            shared_state.completed = true;
            if let Some(waker) = shared_state.waker.take() {
                waker.wake()
            }
        });

        TimerFuture { shared_state }
    }
}

impl Future for TimerFuture {
    type Output = ();
    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        // Look at the shared state to see if the timer has already completed.
        let mut shared_state = self.shared_state.lock().unwrap();
        if shared_state.completed {
            Poll::Ready(())
        } else {
            // Set waker so that the thread can wake up the current task
            // when the timer has completed, ensuring that the future is polled
            // again and sees that `completed = true`.
            //
            // It's tempting to do this once rather than repeatedly cloning
            // the waker each time. However, the `TimerFuture` can move between
            // tasks on the executor, which could cause a stale waker pointing
            // to the wrong task, preventing `TimerFuture` from waking up
            // correctly.
            //
            // N.B. it's possible to check for this using the `Waker::will_wake`
            // function, but we omit that here to keep things simple.
            shared_state.waker = Some(cx.waker().clone());
            Poll::Pending
        }
    }
}
```

Libraries:
- [futures-rs: Zero-cost asynchronous programming in Rust](https://github.com/rust-lang/futures-rs) ([Docs.rs](https://docs.rs/futures/latest/futures/))

  ```rust
  // `block_on` blocks the current thread until the provided future has run to
  // completion. Other executors provide more complex behavior, like scheduling
  // multiple futures onto the same thread.
  use futures::executor::block_on;
  
  async fn learn_song() -> Song { /* ... */ }
  async fn sing_song(song: Song) { /* ... */ }
  async fn dance() { /* ... */ }
  
  async fn learn_and_sing() {
      // Wait until the song has been learned before singing it.
      // We use `.await` here rather than `block_on` to prevent blocking the
      // thread, which makes it possible to `dance` at the same time.
      let song = learn_song().await;
      sing_song(song).await;
  }
  
  async fn async_main() {
      let f1 = learn_and_sing();
      let f2 = dance();
  
      // `join!` is like `.await` but can wait for multiple futures concurrently.
      // If we're temporarily blocked in the `learn_and_sing` future, the `dance`
      // future will take over the current thread. If `dance` becomes blocked,
      // `learn_and_sing` can take back over. If both futures are blocked, then
      // `async_main` is blocked and will yield to the executor.
      futures::join!(f1, f2);
  }
  
  fn main() {
      block_on(async_main());
  }
  ```

## Future executors
`Future` executors take a set of top-level `Future`s and run them to completion by calling `poll` whenever the `Future` can make progress. Typically, an executor will `poll` a future once to start off. When `Future`s indicate that they are ready to make progress by calling `wake()`, they are placed back onto a queue and `poll` is called again, repeating until the `Future` has completed.

The following simple executor works by sending tasks to run over a channel. The executor will pull events off of the channel and run them. When a task is ready to do more work (is awoken), it can schedule itself to be polled again by putting itself back onto the channel.

```rust
/// Task executor that receives tasks off of a channel and runs them.
struct Executor {
    ready_queue: Receiver<Arc<Task>>,
}

impl Executor {
    fn run(&self) {
        while let Ok(task) = self.ready_queue.recv() {
            // Take the future, and if it has not yet completed (is still Some),
            // poll it in an attempt to complete it.
            let mut future_slot = task.future.lock().unwrap();
            if let Some(mut future) = future_slot.take() {
                // Create a `LocalWaker` from the task itself
                let waker = waker_ref(&task);
                let context = &mut Context::from_waker(&waker);
                // `BoxFuture<T>` is a type alias for
                // `Pin<Box<dyn Future<Output = T> + Send + 'static>>`.
                // We can get a `Pin<&mut dyn Future + Send + 'static>`
                // from it by calling the `Pin::as_mut` method.
                if future.as_mut().poll(context).is_pending() {
                    // We're not done processing the future, so put it
                    // back in its task to be run again in the future.
                    *future_slot = Some(future);
                }
            }
        }
    }
}

/// `Spawner` spawns new futures onto the task channel.
#[derive(Clone)]
struct Spawner {
    task_sender: SyncSender<Arc<Task>>,
}

impl Spawner {
    fn spawn(&self, future: impl Future<Output = ()> + 'static + Send) {
        let future = future.boxed();
        let task = Arc::new(Task {
            future: Mutex::new(Some(future)),
            task_sender: self.task_sender.clone(),
        });
        self.task_sender.send(task).expect("too many tasks queued");
    }
}

/// A future that can reschedule itself to be polled by an `Executor`.
struct Task {
    /// In-progress future that should be pushed to completion.
    ///
    /// The `Mutex` is not necessary for correctness, since we only have
    /// one thread executing tasks at once. However, Rust isn't smart
    /// enough to know that `future` is only mutated from one thread,
    /// so we need to use the `Mutex` to prove thread-safety. A production
    /// executor would not need this, and could use `UnsafeCell` instead.
    future: Mutex<Option<BoxFuture<'static, ()>>>,

    /// Handle to place the task itself back onto the task queue.
    task_sender: SyncSender<Arc<Task>>,
}

impl ArcWake for Task {
    fn wake_by_ref(arc_self: &Arc<Self>) {
        // Implement `wake` by sending this task back onto the task channel
        // so that it will be polled again by the executor.
        let cloned = arc_self.clone();
        arc_self
            .task_sender
            .send(cloned)
            .expect("too many tasks queued");
    }
}

fn new_executor_and_spawner() -> (Executor, Spawner) {
    // Maximum number of tasks to allow queueing in the channel at once.
    // This is just to make `sync_channel` happy, and wouldn't be present in
    // a real executor.
    const MAX_QUEUED_TASKS: usize = 10_000;
    let (task_sender, ready_queue) = sync_channel(MAX_QUEUED_TASKS);
    (Executor { ready_queue }, Spawner { task_sender })
}

fn main() {
    let (executor, spawner) = new_executor_and_spawner();

    // Spawn a task to print before and after waiting on a timer.
    spawner.spawn(async {
        println!("howdy!");
        // Wait for our timer future to complete after two seconds.
        TimerFuture::new(Duration::new(2, 0)).await;
        println!("done!");
    });

    // Drop the spawner so that our executor knows it is finished and won't
    // receive more incoming tasks to run.
    drop(spawner);

    // Run the executor until the task queue is empty.
    // This will print "howdy!", pause, and then print "done!".
    executor.run();
}
```


## Async runtimes
Unlike other Rust programs, asynchronous applications require runtime support. In particular, the following runtime services are necessary[^tokio]:

- An **I/O event loop**, called the driver, which drives I/O resources and dispatches I/O events to tasks that depend on them.
- A **scheduler** to execute [tasks](https://docs.rs/tokio/latest/tokio/task/index.html "mod tokio::task") that use these I/O resources.
- A **timer** for scheduling work to run after a set period of time.

Libraries:
- [Tokio: A runtime for writing reliable asynchronous applications with Rust. Provides I/O, networking, scheduling, timers, ...](https://github.com/tokio-rs/tokio) ([Docs.rs](https://docs.rs/tokio/latest/tokio/))
- [async-std: Async version of the Rust standard library](https://github.com/async-rs/async-std) ([Docs.rs](https://docs.rs/async-std/latest/async_std/))
- [smol: A small and fast async runtime for Rust](https://github.com/smol-rs/smol)

## Stackful coroutines
- [May: rust stackful coroutine library](https://github.com/Xudong-Huang/may)

  [Stackful Coroutine Async Story in Rust](https://xudong-huang.github.io/stackful_coroutine_story.html)


[^tokio]: [tokio::runtime - Rust](https://docs.rs/tokio/latest/tokio/runtime/index.html)