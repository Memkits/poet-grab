
Poet grab(TODO...)
----

> Toy for grabbing sentences from poets.

### 用户需要注意

保持精确正式 Calcit/procs 0.30.1，配对正式 Respo 0.16.126、UI 0.8.1、
Reel 0.6.42、js-ffi 0.2.6。请重新严格解析依赖、重启开发服务并完整刷新，不混用旧模块缓存。
两处样式合并调用头迁为 `.merge`，环境 Option 默认值调用头迁为 `.unwrap-or`；
样式覆盖顺序、`release` 默认值、原两项测试、类型及所有存档/页面错误提示行为不变。
原输入框、run 日志按钮、开发 Reel、`workflow` key 和 Map/Struct 存档合同保持。

启动先恢复存档，再渲染和注册保存。解析或解码失败会调用 JS `hud!` 显示页面错误，
然后中断启动；不再吞掉错误后保存初始值。错误存档应先备份修复，不要清空浏览器数据。
原 60 秒保存和 beforeunload 保留，正常存档仍按原 Map 形状写入；不扩展计划中的抓取功能。

### Development

Use paired formal Calcit/procs 0.30.1, Node.js 24, and Yarn 4.18.0.
Calcit modules use formal tags: Respo 0.16.126, UI 0.8.1, Reel 0.6.42
and JS-FFI 0.2.6.

Keep `calcit.cirru` and `deps.cirru` as the canonical source and dependency
files. Do not restore the retired `compact.cirru` or `package.cirru`; CI checks
that both canonical files exist and both retired files are absent.

```bash
caps --strict --ci
yarn install --immutable
calcit calcit.cirru --check-only --all-defs
calcit calcit.cirru test --tag unit --require-match
calcit calcit.cirru fix --workflow strict --verify
VITE_BASE_URL=https://cos-sh.tiye.me/Memkits/poet-grab/ yarn build
```

The app builds frontend files into `dist/`. The CI workflow uses the CDN base
`https://cos-sh.tiye.me/Memkits/poet-grab/` (or its `/pr/<number>/<run>/<attempt>/` preview path), then
uploads and publicly verifies only `dist/` on COS. The existing production
rsync destination remains `rsync-user@tiye.me:/web-assets/repo/Memkits/poet-grab`.

`yarn build` compiles once and reads `VITE_BASE_URL` (default `./`). `yarn dev`
compiles before Vite; run `yarn watch` in another terminal for Calcit edits,
without concurrently. COS Action v1.2.0 provides built-in public/HTML reference
verification, with no additional project checker. Production uploads queue
without cancellation and check the current main revision before deploying;
stale builds skip both COS and the existing server sync.

The current UI remains a text input, a `run` logging button and the development
Reel debugger; this migration does not implement the planned poetry-grabbing
feature. Store and Reel now have real typed Structs, and application operations
have checked nominal Enum payloads. Mixed-key widget state remains an explicit
open boundary. The input event is the actual Respo event Map, not an asserted
event Struct. The original two named unit tests are retained, with no extra test
runner, checker script or dependency.

Storage still uses `workflow`, beforeunload and the original 60-second interval.
It writes the original Map shape (`:states`, `:content`), so old data remains
readable. Both legacy Maps and serialized typed Stores are validated on hydration;
wrong field types are rejected rather than asserted valid. The storage key is
not renamed and shared-origin key collisions are not solved by this migration.
Set `?mode=dev`, then press Meta+Alt+Shift+K (⌘⌥⇧K on macOS) to open the typed
Reel controls. No source change
or successful preview authorizes production deployment; merging main retains the
existing frontend-only COS/rsync behavior and requires separate approval.

### Workflow

Workflow https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
