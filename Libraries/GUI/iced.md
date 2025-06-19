# iced
[iced: A cross-platform GUI library for Rust, inspired by Elm](https://github.com/iced-rs/iced)

- MVU
- Backends: wgpu, tiny-skia
- [text\_input can't accept chinese input - Issue #1801 - iced-rs/iced](https://github.com/iced-rs/iced/issues/1801)

> iced感觉还行，虽然体积大、不支持输入法、布局支持比egui稍微好一点但不多、不认识wayland桌面的暗色模式、通信机制对用户不透明、changelog就跟没写一样没事就break几个重要的api，但是控件不少  
> iced什么时候能支持文本框里面右键能显示复制粘贴等功能菜单了，说不定就好起来了

> 1. iced 不能把子窗口直接通过“component”管理实现，需要自己拿着Window，自己分发render
> 2. iced 的component 没有显式的trait定义，需要自己跟着文档抄签名
> 3. iced支持的gpu加速后端wgpu，内存占用巨高
> 4. iced在web环境走古老的webgl，没有用api反复break的webgpu，不符合rua礼
> 5. iced相比于动态链接系列的gui库（fltk，winio，gtk，nwg，cacao），体积膨胀巨大
> 6. 然后iced的layout支持也是一绝，需要人自己去加spacing，没有margin/padding
> 
> 不过这些都不算最难绷的，iced在纯Rust gui里面其实算不错的  
> 但它是纯rust gui，走winit的，不支持wayland输入法  
> cosmic特色不就来了，自身组件不支持输入法的de（
