Poet Grab
----

> 输入文本、记录操作的演示；计划中的诗句抓取功能尚未实现。

### 用户需要注意

开发与 CI 配对正式 Calcit / procs **0.40.0**。直接依赖为 Respo 0.19.5、UI 0.15.2、js-ffi 0.2.13 和 Reel 0.11.0，传递依赖为 Router 0.12.2。升级后重新严格解析依赖、重启开发服务并刷新。

文本输入发送具体 Op，组件状态路径按 CoordKey union 校验。业务视图直接派发具体 Op，Reel 面板与快捷键通过独立回调传递具体 Control。开发面板在同一 memo 帧内构造和渲染。

存储仍使用 `workflow` key，先恢复成功，再渲染和注册保存。解析或解码失败时，JS `hud!` 显示页面错误，随后中断启动；错误存档应先备份修复，不要清空浏览器数据。保留原 60 秒与 beforeunload 保存，继续写入 `:states` / `:content` Map 形状；legacy Map 和序列化 Store 都经过校验，未解决同来源 key 冲突。

### 开发与验证

使用 Calcit 0.40.0、Node.js 24、Yarn 4.18.0。npm 新解析版本等待 60 分钟，无单包豁免；已有锁定版本不重新计算等待时间。

```bash
caps --strict --ci
yarn install --immutable
caps verify --toolchain
calcit calcit.cirru --check-only --all-defs
calcit calcit.cirru test --tag unit --require-match
calcit calcit.cirru fix --workflow strict --verify
VITE_BASE_URL=https://cos-sh.tiye.me/Memkits/poet-grab/ yarn build
```

`yarn build` 先编译并读取 `VITE_BASE_URL`（默认 `./`）。`yarn dev` 先编译再启动 Vite；修改 Calcit 时在另一个终端运行 `yarn watch`，无需 concurrently。仅维护 `calcit.cirru` / `deps.cirru`，原 CI 继续禁止 compact/package 回流，保留 canonical、全部定义、完整 strict、公开合同及原两项测试。

前端产物仅为 `dist/`，PR 使用 `/pr/<number>/<run>/<attempt>/` 隔离前缀及 COS Action v1.2.0 内置公开内容/HTML 引用校验，不新增项目校验脚本。生产任务排队、不取消，并检查当前 main，过期构建跳过 COS 和服务器同步。原 rsync 目标仍为 `rsync-user@tiye.me:/web-assets/repo/Memkits/poet-grab`。本 PR 不合并或部署生产前端。

0.35.1 已通过严格依赖解析、全定义、公开定义、完整 strict、原两项测试及构建。此前隔离页面完成合成输入、run 日志、Reel 历史回看、两条记录逐项 Step、Run 与正常刷新恢复，控制台无警告或错误。未重测坏存档保护、60 秒定时保存或共享 key 冲突，不以正常刷新替代这些验收。

### 功能范围

输入事件使用 RespoEvent 并校验 value。混合 key 的 widget 状态仍是显式开放边界；不将其伪装为闭合业务模型。`run` 按钮只输出当前文本日志。使用 `?mode=dev`，按 Meta+Alt+Shift+K（macOS 为 ⌘⌥⇧K）展开 Reel 控件。

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
