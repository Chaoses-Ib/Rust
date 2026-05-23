#import "@local/ib:0.1.0": *
#title[Thread Locals]
- #a[```rs std::thread::LocalKey```][https://doc.rust-lang.org/std/thread/struct.LocalKey.html]
  - #a[```rs std::thread_local```][https://doc.rust-lang.org/std/macro.thread_local.html]

- #a[`thread_local`: Per-object thread-local storage for Rust][https://github.com/Amanieu/thread_local-rs]
  - ```rs get()``` has an innegligible cost:
  
    ```rust
    pub fn get(&self) -> Option<&T> {
        let thread = thread_id::get() {
            THREAD.with(|thread| {
                if let Some(thread) = thread.get() {
                    thread
                } else {
                    get_slow(thread]
                }
            }]
        };
            
        let bucket_ptr =
            unsafe { self.buckets.get_unchecked(thread.bucket) }.load(Ordering::Acquire);
        if bucket_ptr.is_null() {
            return None;
        }
        unsafe {
            let entry = &*bucket_ptr.add(thread.index);
            // Read without atomic operations as only this thread can set the value.
            if (&entry.present as *const _ as *const bool).read() {
                Some(&*(&*entry.value.get()).as_ptr()]
            } else {
                None
            }
        }
    }
    ```

- #a[`os-thread-local`: OS-backed thread-local storage for rust][https://github.com/glandium/os-thread-local]
  - ```rs iter()``` is not supported.

- #a[`threadstack`: ergonomic library for thread local stacks][https://github.com/jgarvin/threadstack]

Thread locals cannot be mutated.
One must use the interior mutability pattern or ```rs unsafe``` to mutate the inner value.

= Destructors
- When the process exits, TLS destructors may not be run.

- Calling ```rs JoinHandle::join()``` in ```rs drop()``` will cause deadlock on Windows
  (but not on Linux).
  - In ```c RtlExitUserThread() { LdrpDrainWorkQueue() }```.
  #footnote[#a[Join Your Threads][https://matklad.github.io/2019/08/23/join-your-threads.html]]

#q[
Values that implement `Drop` get
destructed when a thread exits.
#footnote[#a[Guarantee `needs_drop` thread-local variables are destroyed at a well-defined point - Issue \#147342 - rust-lang/rust][https://github.com/rust-lang/rust/issues/147342]]
Some platform-specific caveats apply, which
are explained below.
Note that, should the destructor panic, the whole process will be aborted.
]

#q[
Note that a "best effort" is made to ensure that destructors for types
stored in thread local storage are run, but not all platforms can guarantee
that destructors will be run for all types in thread local storage. For
example, there are a number of known caveats where destructors are not run:

1. On Unix systems when pthread-based TLS is being used, destructors will
   not be run for TLS values on the main thread when it exits. Note that the
   application will exit immediately after the main thread exits as well.
2. On all platforms it's possible for TLS to re-initialize other TLS slots
   during destruction. Some platforms ensure that this cannot happen
   infinitely by preventing re-initialization of any slot that has been
   destroyed, but not all platforms have this guard. Those platforms that do
   not guard typically have a synthetic limit after which point no more
   destructors are run.
3. When the process exits on Windows systems, TLS destructors may only be
   run on the thread that causes the process to exit. This is because the
   other threads may be forcibly terminated.
]
#footnote[#a[TLS destructors on the main thread are not always run - Issue \#28129 - rust-lang/rust][https://github.com/rust-lang/rust/issues/28129]]

#q[
On Windows, synchronization operations (such as
#a[```rs JoinHandle::join()```][https://doc.rust-lang.org/std/thread/struct.JoinHandle.html#method.join]
) in
thread local destructors are prone to deadlocks and so should be avoided.
This is because the
#a[loader lock][https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-best-practices]
is held while a destructor is run. The
lock is acquired whenever a thread starts or exits or when a DLL is loaded
or unloaded. Therefore these events are blocked for as long as a thread
local destructor is running.
]
#footnote[#a[Joining thread in thread local storage destructor never returns on Windows - Issue \#74875 - rust-lang/rust][https://github.com/rust-lang/rust/issues/74875]]
For example:
#raw(read("tls/src/bin/join.rs"), block: true, lang: "rs")

- #a[Techcable/dropping-thread-local.rs: A dynamically allocated ThreadLocal that ensures destructors are run on thread exit][https://github.com/Techcable/dropping-thread-local.rs]
  #a-badge[https://docs.rs/dropping-thread-local/]
