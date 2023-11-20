# Scripts
- [Rhai - An embedded scripting language for Rust.](https://github.com/rhaiscript/rhai)

  ```rust
  const TARGET = 28;
  const REPEAT = 5;
  const ANSWER = 317_811;

  fn fib(n) {
      if n < 2 {
          n
      } else {
          fib(n-1) + fib(n-2)
      }
  }

  print(`Running Fibonacci(${TARGET}) x ${REPEAT} times...`);
  print("Ready... Go!");

  let result;
  let now = timestamp();

  for n in 0..REPEAT {
      result = fib(TARGET);
  }

  print(`Finished. Run time = ${now.elapsed} seconds.`);

  print(`Fibonacci number #${TARGET} = ${result}`);

  if result != ANSWER {
      print(`The answer is WRONG! Should be ${ANSWER}!`);
  }
  ```

- [Rune: An embeddable dynamic programming language for Rust.](https://github.com/rune-rs/rune)

  ```rust
  use std::future;

  struct Timeout;

  const SITE = "https://httpstat.us";

  async fn request(timeout) {
      let request = http::get(`${SITE}/200?sleep=${timeout}`);
      let timeout = time::delay_for(time::Duration::from_secs(1));

      let result = select {
          res = request => res,
          _ = timeout => Err(Timeout),
      }?;

      let text = result.text().await?;
      Ok(text)
  }

  pub async fn main() {
      let result = future::join((request(0), request(1500))).await;
      dbg(result);
  }
  ```

- [Dyon: A rusty dynamically typed scripting language](https://github.com/PistonDevelopers/dyon)

  ![](https://github.com/PistonDevelopers/dyon/blob/065afa9de8548d3ff155fbb461e55f0ec7ea2bd6/images/code.png?raw=true)