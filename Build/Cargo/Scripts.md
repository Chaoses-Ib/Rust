# Build Scripts
[The Cargo Book](https://doc.rust-lang.org/cargo/reference/build-scripts.html)

[built: Provides a crate with information from the time it was built.](https://github.com/lukaslueg/built)

[rust-lang/cc-rs: Rust library for build scripts to compile C/C++ code into a Rust library](https://github.com/rust-lang/cc-rs)

[Need a reliable way to get the target dir from the build script - Issue #9661 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/9661)

[Copy files to target directory after build, before run - Issue #1759 - rust-lang/cargo](https://github.com/rust-lang/cargo/issues/1759)
- [copy\_to\_output: A small rust library to copy files/folders from the project directory to the output directory](https://github.com/samwoodhams/copy_to_output)

  [`out_path` will be broken if `get_cargo_target_dir()` succeeds - Issue #9](https://github.com/samwoodhams/copy_to_output/issues/9)

- ```rust
  use std::fs;

  /// https://github.com/rust-lang/cargo/issues/9661#issuecomment-1722358176
  fn get_cargo_target_dir() -> Result<std::path::PathBuf, Box<dyn std::error::Error>> {
      let out_dir = std::path::PathBuf::from(std::env::var("OUT_DIR")?);
      let profile = std::env::var("PROFILE")?;
      let mut target_dir = None;
      let mut sub_path = out_dir.as_path();
      while let Some(parent) = sub_path.parent() {
          if parent.ends_with(&profile) {
              target_dir = Some(parent);
              break;
          }
          sub_path = parent;
      }
      let target_dir = target_dir.ok_or("not found")?;
      Ok(target_dir.to_path_buf())
  }

  fn main() {
      let target = get_cargo_target_dir().unwrap();
      #[cfg(target_os = "windows")]
      fs::copy("../libs/simple/libsimple.dll", target.join("libsimple.dll")).unwrap();
      #[cfg(target_os = "macos")]
      fs::copy("../libs/simple/libsimple.dylib", target.join("libsimple.dylib"),).unwrap();
  }
  ```
  ```rust
  fn main() {
      let target = get_cargo_target_dir().unwrap();

      const DLL: &str = if cfg!(target_arch = "x86_64") {
          "SDK64.dll"
      } else if cfg!(target_arch = "x86") {
          "SDK32.dll"
      } else {
          unimplemented!()
      };
      let target_dll = target.join(DLL);
      fs::copy(format!("lib/{DLL}"), &target_dll).unwrap();

      println!("cargo:rerun-if-changed=lib/");
      println!("cargo:rerun-if-changed={}", target_dll.to_string_lossy());
  }
  ```
