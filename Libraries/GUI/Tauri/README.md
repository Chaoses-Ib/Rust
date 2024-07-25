# [Tauri](https://github.com/tauri-apps/tauri)
[Concepts](https://beta.tauri.app/concepts/)
- [Inter-Process Communication](https://beta.tauri.app/concepts/inter-process-communication/)

[Kill process on exit - tauri-apps/tauri - Discussion #3273](https://github.com/tauri-apps/tauri/discussions/3273)

[Is there a recommended way to debug a tauri application (react used as frontend) in vscode on Windows? - tauri-apps/tauri - Discussion #4210](https://github.com/tauri-apps/tauri/discussions/4210)

Release:
- `npm run tauri dev -- --release`
- ~~`npm run tauri dev --release`~~
- ~~`npm run tauri dev -- -- -r`~~

[\[feat\] Change `tauri.conf.json` based on build profile (dev/release) - Issue #8418 - tauri-apps/tauri](https://github.com/tauri-apps/tauri/issues/8418)

## Commands
- The output of `tauri::generate_handler!()` is of an `impl` generic type (closure).

  > The output of this macro is managed internally by Tauri, and should not be accessed directly on normal applications. It may have breaking changes in the future.

  Saving it to an variable would make rustc `cannot infer type` and `error[E0282]: type annotations needed`. And there is no way to write type annotations without some cumbersome generics.

Plugins:
- [tauri-specta: Completely typesafe Tauri commands](https://github.com/oscartbeaumont/tauri-specta)
  - The code will always be generated even `path()` is not called.
  - Default `BigIntExportBehavior` (for `i64`, `i128`...) is `Fail` and will result in `Err(BigIntForbidden)`.

- [tauri-interop: Easily connect your rust frontend and backend without writing duplicate code.](https://github.com/photovoltex/tauri-interop)
- [tauri-types: A small library that translates the types from `Rust` to `TypeScript` for better integration for the `invoke` function from `Tauri`.](https://github.com/Maki325/tauri-types)

## Logging
- [tauri-plugin-log](https://github.com/tauri-apps/tauri-plugin-log) ([Docs.rs](https://docs.rs/tauri-plugin-log/latest/tauri_plugin_log/))
  - `build()` will set the global logger.

## Distribution
- [BundleConfig](https://v2.tauri.app/reference/config/#bundleconfig) (v2)
  - `externalBin`: A list of—either absolute or relative—paths to binaries to embed with your application.

    [Embedding External Binaries](https://tauri.app/v1/guides/building/sidecar/)

  - `resources`: App resources to bundle. Each resource is a path to a file or directory. Glob patterns are supported.

    v1: [Embedding Additional Files](https://tauri.app/v1/guides/building/resources/)

    v2: [Embedding Additional Files | Tauri](https://v2.tauri.app/develop/resources/)
    - Resource mapping
  
      Using `*`/`**` in the source path will map files of all levels into the same target directory, which may lead to conflicts and make WiX stack overflow.

    Changing resources will not clear old ones.

    glob:
    - [`require_literal_separator == require_literal_leading_dot == false`](../../Files/README.md)
    - [The Filesystem Scope Glob Pattern is too Permissive - Advisory - tauri-apps/tauri](https://github.com/tauri-apps/tauri/security/advisories/GHSA-6mv3-wm7j-h4w5)

    Debug: Copied instead of hardlinked.

    v2: [\[docs\] How to load image resource in v2 - Issue #9667 - tauri-apps/tauri](https://github.com/tauri-apps/tauri/issues/9667)

  - `macOS`
    - `files`

  Python:
  - [How to embed Python for sidecar - tauri-apps/tauri - Discussion #2759](https://github.com/tauri-apps/tauri/discussions/2759)
  - [tauri-rust-py: A Tarui Python Sidecar Example, using Pyinstaller.](https://github.com/DRUMNICORN/tauri-rust-py)

- Debugging: `tauri build --debug`

OS:
- [Windows Installer](https://tauri.app/v1/guides/building/windows/)
  - No cross-compilation.
  - Installers: WiX, NSIS (default: both)
    - WiX: `C:\Program Files\{productName}\`
      - [\[bug\] build fail with Chinese productName in tauri.conf.json failed to bundle project: error running light.exe - Issue #8363 - tauri-apps/tauri](https://github.com/tauri-apps/tauri/issues/8363)
    - NSIS: `C:\Users\Chaoses\AppData\Local\{productName}`

- [macOS Bundle](https://tauri.app/v1/guides/building/macos)

  No cross-compilation.