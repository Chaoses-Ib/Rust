# GUI
- [iced: A cross-platform GUI library for Rust, inspired by Elm](https://github.com/iced-rs/iced)

- [Dioxus: Fullstack app framework for web, desktop, mobile, and more.](https://github.com/DioxusLabs/dioxus)
  - React

  [\[Media\] I added instant hotreloading of (some) Rust code for Dioxus 0.6! : r/rust](https://www.reddit.com/r/rust/comments/1ezdjqx/media_i_added_instant_hotreloading_of_some_rust/)

  [\[media\] Dioxus 0.6 shipping soon with \`main.rs\` support for iOS and Android. Run \*any\* Rust executable on Mac, Windows, Linux, Web, iOS, and Android (with live hotreloading!) : r/rust](https://www.reddit.com/r/rust/comments/1fzakmk/media_dioxus_06_shipping_soon_with_mainrs_support/)

  [Dioxus 0.6 - Massive Tooling Improvements: Mobile Simulators, Magical Hot-Reloading, Interactive CLI, RSX Autocomplete, Streaming HTML, WGPU Overlays, and more! : r/rust](https://www.reddit.com/r/rust/comments/1hahy2d/dioxus_06_massive_tooling_improvements_mobile/)

- [egui: An easy-to-use immediate mode GUI in Rust that runs on both web and native](https://github.com/emilk/egui)

  > egui aims to be the easiest-to-use Rust GUI library, and the simplest way to make a web app in Rust.

- [Slint](Slint/README.md)

- [Xilem: An experimental Rust native UI framework](https://github.com/linebender/xilem)

  [Xilem: an architecture for UI in Rust | Raph Levien's blog](https://raphlinus.github.io/rust/gui/2022/05/07/ui-architecture.html)

  [Announcing Masonry 0.1, and my vision for Rust UI - PoignardAzur](https://poignardazur.github.io//2023/02/02/masonry-01-and-my-vision-for-rust-ui/) ([Hacker News](https://news.ycombinator.com/item?id=34671478))

- [Vizia: A declarative GUI library written in Rust](https://github.com/vizia/vizia)

- [Ribir: Non-intrusive GUI framework for Rust/WASM](https://github.com/RibirX/Ribir)
  - DSL macro

- [Pax: User interface engine with an integrated vector design tool, built in Rust](https://github.com/paxdotdev/pax) ([r/rust](https://www.reddit.com/r/rust/comments/1fdmjzl/pax_enters_beta_rust_guis_with_an_integrated/))
  - Zero screenshots

- [Actuate: A framework for declarative programming in Rust](https://github.com/actuate-rs/actuate)

  [\[Blog Post\] UI and Declarative Programming in Rust : r/rust](https://www.reddit.com/r/rust/comments/1h3hnz7/blog_post_ui_and_declarative_programming_in_rust/)

  [\[Media\] Actuate UI: Now with Material design components, better ergonomics with Bevy, and a faster runtime with support for pause/resume : r/rust](https://www.reddit.com/r/rust/comments/1h87jod/media_actuate_ui_now_with_material_design/)

- [Winio: Single-threaded asynchronous GUI runtime](https://github.com/compio-rs/winio)

- [ejaa3/declarative: Code reactive views with ease!](https://github.com/ejaa3/declarative)

- [Panoramix: A prototype implementation of reactive UI in rust](https://github.com/PoignardAzur/panoramix) (discontinued)

[Tauri vs Iced vs egui: Rust GUI framework performance comparison (including startup time, input lag, resize tests) - Lukasʼ Blog](https://lukaskalbertodt.github.io/2023/02/03/tauri-iced-egui-performance-comparison.html) ([Lobsters](https://lobste.rs/s/zgxvxw/rust_gui_framework_performance))

Web:
- [Tauri](Tauri/README.md)
- [Leptos: Build fast web applications with Rust.](https://github.com/leptos-rs/leptos)
- [Sycamore: A library for creating reactive web apps in Rust and WebAssembly](https://github.com/sycamore-rs/sycamore)
- [MoonZoon: Rust Fullstack Framework](https://github.com/MoonZoon/MoonZoon)
  - React
- [rsx: Advanced JSX-like templating for Rust](https://github.com/victorporof/rsx)

C++:
- Qt
  - cxx-qt
    - QtQuick

  [Rewriting Qt in Rust | Qt Forum](https://forum.qt.io/topic/142885/rewriting-qt-in-rust)

.NET:
- Avalonia

  [Rust bindings for Avalonia UI Framework : r/programming](https://www.reddit.com/r/programming/comments/12cty31/rust_bindings_for_avalonia_ui_framework/)

Flutter:
- rinf
- flutter_rust_bridge

> Flutter 那边的 Native Binding 插件无一例外全有大病，你想修个窗口样式得搞进来三四个插件，而且这玩意还讲究配方，你配不对插件之间就会打架，什么画面撕裂画面变白之类乱七八糟的问题都会有，Release Mode 和 Debug Mode 表现不一样也会有
>
> Flutter 配 Rust 最爆炸的一集是 Android 的 FS Access，安卓的文件系统权限设计决定了你不能简单地用 Rust 的 FS API 来解决问题
>
> 另外，我推荐用 rinf，flutter rust bridge 的自动类型推断速度很慢，而且经常翻车，不如像 rinf 一样直接写 protobuf 定义了……
>
> 就，写 GUI 用 Flutter 写肯定是比用 Rust 写舒服的（in terms of 生态），气氛上 Flutter 的 bug 也应该比 tauri 少……
>
> Flutter 也就画画 GUI，写业务就是一坨屎

## Windows
- [rusty-twinkle-tray: Twinkle Tray but 🦀](https://github.com/sidit77/rusty-twinkle-tray) ([r/rust](https://www.reddit.com/r/rust/comments/18mtdaz/native_semimodern_windows_guis_in_pure_rust/))
- [sotanakamura/winui-rust](https://github.com/sotanakamura/winui-rust)
- [microsoft/windows-app-rs: Rust for the Windows App SDK](https://github.com/microsoft/windows-app-rs)
