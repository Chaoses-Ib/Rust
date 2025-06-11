# GUI
- [rust-windowing/winit: Window handling library in pure Rust](https://github.com/rust-windowing/winit)
  - [rust-windowing/raw-window-handle: A common windowing interoperability library for Rust](https://github.com/rust-windowing/raw-window-handle)
  - IME: [Tracking issue for IME / composition support - Issue #1497 - rust-windowing/winit](https://github.com/rust-windowing/winit/issues/1497)
    - ~~[IME on Windows does not work with multi-threading - Issue #3123 - rust-windowing/winit](https://github.com/rust-windowing/winit/issues/3123)~~

- [iced: A cross-platform GUI library for Rust, inspired by Elm](https://github.com/iced-rs/iced)
  - Elm
  - Backends: wgpu, tiny-skia
  - [text\_input can't accept chinese input - Issue #1801 - iced-rs/iced](https://github.com/iced-rs/iced/issues/1801)

  > iced感觉还行，虽然体积大、不支持输入法、布局支持比egui稍微好一点但不多、不认识wayland桌面的暗色模式、通信机制对用户不透明、changelog就跟没写一样没事就break几个重要的api，但是控件不少  
  > iced什么时候能支持文本框里面右键能显示复制粘贴等功能菜单了，说不定就好起来了

- [Dioxus: Fullstack app framework for web, desktop, mobile, and more.](https://github.com/DioxusLabs/dioxus)
  - React

  [\[Media\] I added instant hotreloading of (some) Rust code for Dioxus 0.6! : r/rust](https://www.reddit.com/r/rust/comments/1ezdjqx/media_i_added_instant_hotreloading_of_some_rust/)

  [\[media\] Dioxus 0.6 shipping soon with \`main.rs\` support for iOS and Android. Run \*any\* Rust executable on Mac, Windows, Linux, Web, iOS, and Android (with live hotreloading!) : r/rust](https://www.reddit.com/r/rust/comments/1fzakmk/media_dioxus_06_shipping_soon_with_mainrs_support/)

  [Dioxus 0.6 - Massive Tooling Improvements: Mobile Simulators, Magical Hot-Reloading, Interactive CLI, RSX Autocomplete, Streaming HTML, WGPU Overlays, and more! : r/rust](https://www.reddit.com/r/rust/comments/1hahy2d/dioxus_06_massive_tooling_improvements_mobile/)

- [egui: An easy-to-use immediate mode GUI in Rust that runs on both web and native](https://github.com/emilk/egui)

  > egui aims to be the easiest-to-use Rust GUI library, and the simplest way to make a web app in Rust.

- [Slint](Slint/README.md)

- [Xilem: An experimental Rust native UI framework](https://github.com/linebender/xilem)
  - winit, Vello and wgpu, Parley, AccessKit

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

2023-03 [桌面客户端web化已经是大势所趋啦吗？rust有什么原生的GUI库比较好用？ - Rust语言中文社区](https://rustcc.cn/article?id=e6c755d5-e813-4f47-81e4-fe82a2ef59db)
> egui和iced都不能直接使用系统的字体文件，必须把字体文件编译进去，这点很麻烦，而且对中文输入法的支持也不完美。可以试试Dioxus，但缺点和tauri一样，需要webview的支持。

## Windows
- [rusty-twinkle-tray: Twinkle Tray but 🦀](https://github.com/sidit77/rusty-twinkle-tray) ([r/rust](https://www.reddit.com/r/rust/comments/18mtdaz/native_semimodern_windows_guis_in_pure_rust/))
- [sotanakamura/winui-rust](https://github.com/sotanakamura/winui-rust)
- [microsoft/windows-app-rs: Rust for the Windows App SDK](https://github.com/microsoft/windows-app-rs)

ComCtl:
- Cross-platform
  - [Winio: Single-threaded asynchronous GUI runtime](https://github.com/compio-rs/winio)
    - Elm
    - Dark mode
    - [Win32 embedding usage - Issue #24 - compio-rs/winio](https://github.com/compio-rs/winio/issues/24)
  - [libui-rs/libui: Rust bindings to the minimalist, native, cross-platform UI toolkit `libui-ng`](https://github.com/libui-rs/libui)
  - [KISS-UI/kiss-ui: A simple UI framework for Rust built on top of IUP](https://github.com/KISS-UI/kiss-ui) (discontinued)
- [native-windows-gui: A light windows GUI toolkit for rust](https://github.com/gabdube/native-windows-gui) (discontinued)
  - [`Window`](https://docs.rs/native-windows-gui/latest/native_windows_gui/struct.Window.html)
  - Dialogs
  - Tray notification
  - Localization
  - Rich text box
  - WGPU canvas, plotters canvas, extern canvas OpenGL, GDI
  - Interactive tests
  - Problematic high DPI support
  - [Add dark mode support by Aurumaker72 - Pull Request #305 - gabdube/native-windows-gui](https://github.com/gabdube/native-windows-gui/pull/305)
  - [app crashes if build with --release - Issue #310 - gabdube/native-windows-gui](https://github.com/gabdube/native-windows-gui/issues/310)
- [rodrigocfd/winsafe: Windows API and GUI in safe, idiomatic Rust.](https://github.com/rodrigocfd/winsafe)
  - button, check box, combo box, date and time picker, edit, header, label, list box, list view, month calendar, progress bar, radio button, status bar, tab, track bar, tree view, up down
- [Lonami/rust-windows-gui: Build GUI applications with minimal dependencies in Rust](https://github.com/Lonami/rust-windows-gui) (discontinued)
- [aleo101/Rust-Win32-control-program: Win32 program written in Rust to get practice with Rust and Windows programming.](https://github.com/aleo101/Rust-Win32-control-program)
