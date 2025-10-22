#[cfg(test)]
#[macro_use(test)]
extern crate test_log;

#[cfg(test)]
mod tests {
    use tracing::*;

    #[test]
    fn span() {
        // create span but not enter
        let span = span!(Level::INFO, "my_span", v = 123);
        info!("not entered yet");

        // manually enter and left a span
        let guard = span.enter();
        info!("inside my_span");
        drop(guard);
        info!("left my_span");

        // the alternative `entered()` api
        let span = span.entered();
        info!("entered again");
        // it not "exit()" explicitly, will exit on drop
        let span = span.exit();

        // the scoped api
        span.in_scope(|| {
            info!("inside scope of my_span");
        });
        info!("outside of my_span");
        span.in_scope(|| {
            info!("inside scope again");
        });
    }

    #[test]
    fn span_nest() {
        // create span but not enter
        let span = span!(Level::INFO, "parent", v = 123);
        let span2 = span!(Level::INFO, "child", v = 456);
        info!("not entered yet");

        // manually enter and left a span
        let guard = span.enter();
        info!("inside parent");
        let guard2 = span2.enter();
        info!("inside child");
        drop(guard);
        info!("left parent");
        drop(guard2);
        info!("left child");

        // the alternative `entered()` api
        let span = span.entered();
        info!("entered parent");
        // it not "exit()" explicitly, will exit on drop
        let span = span.exit();

        // the scoped api
        span.in_scope(|| {
            info!("inside scope of parent");
            span2.in_scope(|| {
                info!("inside scope of child");
            });
        });
    }
}
