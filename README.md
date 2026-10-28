
Poet grab(TODO...)
----

> Toy for grabbing sentences from poets.

### 用户需要注意

配对正式 Calcit/procs 0.31.0，使用精确已发布 Respo 0.17.0-alpha.4、UI 0.9.0-alpha.4、Reel 0.7.0-alpha.4、js-ffi 0.2.7（传递 Router 0.9.0-alpha.3）。请重新严格解析完整依赖图、重启开发服务并刷新，不混用旧模块缓存；UI 库仍是 alpha 标签，不使用 hash 版本，不保证样式逐像素不变。

本轮不改变输入框、run 日志按钮、Reel、`workflow` key、Map/Struct 存档或 HUD。dispatch 参数由 Dynamic 收紧为明确的 DispatchOp Enum 别名；UI slot 从仅业务 Op 修正为包含匿名 Reel 控制事件的真实入口，因此不是所有接口都变得更窄。原 enum? 守卫、Reel 控制解码及闭合业务 Op 解码保持，别名不引入新的名义身份，也不把业务模型改成开放 Enum。

全部定义 189/189、公共定义 18/18、完整 strict（无诊断）、原两项测试、canonical、immutable 安装、Caps toolchain 与构建通过；独立只读评审无阻塞意见。隔离浏览器验证输入、run 实际日志、Reel 历史跳转/Step/Run、正常刷新恢复，控制台无新增 error/warn。坏存档保护及原 60 秒自动保存未在本轮重测，不用正常刷新替代异常存档验收；原测试和类型门禁未调整。

启动先恢复存档，再渲染和注册保存。解析或解码失败会调用 JS `hud!` 显示页面错误，
然后中断启动；不再吞掉错误后保存初始值。错误存档应先备份修复，不要清空浏览器数据。
原 60 秒保存和 beforeunload 保留，正常存档仍按原 Map 形状写入；不扩展计划中的抓取功能。

### Development

Use paired formal Calcit/procs 0.31.0, Node.js 24, and Yarn 4.18.0.
Use the exact published module tags in deps.cirru; the Respo/UI/Reel tags are still alpha releases.

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
