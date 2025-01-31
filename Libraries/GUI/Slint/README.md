# [Slint](https://slint.dev/)
[GitHub](https://github.com/slint-ui/slint)

> A declarative GUI toolkit to build native user interfaces for Rust, C++, or JavaScript apps.

- DSL
  - AOT/JIT
- Rendering backends
  - `femtovg`: OpenGL ES 2.0
  - `skia`
  - `software`: CPU
- Widgets
  - [Widget styles](https://releases.slint.dev/1.2.1/docs/slint/src/advanced/style)
  - [Slint Widget Gallery Demo (Web Assembly version)](https://docs.slint.dev/latest/demos/gallery/)
- [SlintPad](https://slintpad.com/)
- Size of [Todo app](https://github.com/slint-ui/slint/tree/master/examples/todo)
  - Wasm: 5.2 (1.9) MB
- Licenses
  - Royalty-free (AD) excluding embedded
  - GPLv3
  - Paid

[Hacker News](https://news.ycombinator.com/item?id=39223499)

> 这个安装器是用 slint-ui 实现的，也很有意思；目前对于原生的Rust GUI框架（编写模式），它是我最满意的。在很多小问题修复/新增之后，它可能会是（我心中）最优秀的 Rust gui 框架。
> 
> 首先，他的业务逻辑和界面定义是分离的。界面定义由一个类似 Qt qml 的语言编写，并对于动画有原生的良好支持（Animated Property 等）。同时，它提供了不用提供示例数据的 Live Preview & Designer，这规避了 Rust 热重载支持差及重编译/增量编译速度慢的问题，使得良好的 UI 设计与快捷的开发速度兼备成为可能。另外，他的 std-widgets 提供了多种主题（fluent-ui, 苹果风, MDYou（他的mdyou现在还写得很烂））。
> 
> 在我的浅浅体验下，对于异步网络请求，极大列表（虚拟化），多窗口等它都可以非常自然地胜任。甚至从 Counter 到 异步请求并返回 不需要多看一点 example 就可以自然而然地写出来。

[NGI0 Grant for LibrePCB 2.0 | LibrePCB Blog](https://librepcb.org/blog/2024-10-17_roadmap_2.0/) ([r/rust](https://www.reddit.com/r/rust/comments/1g7f8zw/librepcb_project_plans_to_move_towards_rust_and/))
> LibrePCB Project plans to move towards Rust and rewrite its Qt Components UI with Slint
