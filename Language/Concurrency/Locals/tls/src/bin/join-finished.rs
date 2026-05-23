use std::{cell::LazyCell, thread, time::Duration};

struct NeedDrop {
    thread: Option<thread::JoinHandle<()>>,
}

impl NeedDrop {
    pub fn new() -> Self {
        let thread = thread::spawn(|| {
            println!("thread finish");
        });
        Self {
            thread: Some(thread),
        }
    }
}

impl Drop for NeedDrop {
    fn drop(&mut self) {
        println!("joining...");
        self.thread.take().unwrap().join().unwrap();
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
        });
        // Make sure sub thread exited
        thread::sleep(Duration::from_secs(2));
    })
    .join()
    .unwrap();
}
// joining...
// thread exit
// joined
//
// thread exit
// joining...
// joined
