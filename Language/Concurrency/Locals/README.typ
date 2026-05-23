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
