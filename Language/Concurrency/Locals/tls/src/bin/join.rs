use std::{
    cell::LazyCell,
    sync::{Arc, OnceLock},
    thread,
    time::Duration,
};

struct NeedDrop {
    lock: Arc<OnceLock<()>>,
    thread: Option<thread::JoinHandle<()>>,
}

impl NeedDrop {
    pub fn new() -> Self {
        let lock = Arc::new(OnceLock::new());
        let thread = thread::spawn({
            let lock = lock.clone();
            move || {
                println!("waiting...");
                lock.wait();
                println!("waited");
            }
        });
        Self {
            lock,
            thread: Some(thread),
        }
    }
}

impl Drop for NeedDrop {
    fn drop(&mut self) {
        println!("joining...");
        self.lock.set(()).unwrap();

        // self.thread.take().unwrap().join().unwrap();
        let thread = self.thread.take().unwrap();
        while !thread.is_finished() {
            thread::sleep(Duration::from_secs(1));
        }
        println!("joined");
    }
}

thread_local! {
    static A: LazyCell<NeedDrop> = const { LazyCell::new(NeedDrop::new) };
}

fn main() {
    drop(NeedDrop::new());
    println!();

    thread::spawn(|| {
        A.with(|a| {
            LazyCell::force(a);
        })
    })
    .join()
    .unwrap();
}
// joining...
// waiting...
// waited
// joined
//
// joining...
