Poet Grab
----

> 输入文本、记录操作的演示；计划中的诗句抓取功能尚未实现。

### 用户需要注意

开发与 CI 配对升级至正式 Calcit / procs **0.32.1**，同步新的类型标注语法。直接使用精确已发布 Respo 0.17.1、UI 0.9.0、js-ffi 0.2.9、Reel 0.7.0-alpha.5；传递依赖仍含 Router 0.9.0-alpha.4，不能视为整图全部正式版。重新严格解析依赖、重启开发服务并刷新；新版 UI 依赖不保证样式逐像素相同。

本轮仅迁移类型格式和依赖，18 个项目定义的完整官方视图与格式化后的原 main 相同，代码、schema 和原测试不变。保留 DispatchOp 别名、闭合业务 Op、匿名 Reel 控制事件及原解码守卫，不放宽类型门禁。项目 deps 版本 0.0.1、package 版本 0.1.0 均不变，不发布新项目版本。

存储仍使用 `workflow` key，先恢复成功，再渲染和注册保存。解析或解码失败时，JS `hud!` 显示页面错误，随后中断启动；错误存档应先备份修复，不要清空浏览器数据。保留原 60 秒与 beforeunload 保存，继续写入 `:states` / `:content` Map 形状；legacy Map 和序列化 Store 都经过校验，未解决同来源 key 冲突。

### 开发与验证

使用 Calcit 0.32.1、Node.js 24、Yarn 4.18.0。npm 新解析版本等待 60 分钟，无单包豁免；已有锁定版本不重新计算等待时间。

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

本轮本地通过 Caps 严格解析与工具链配对、immutable 安装、canonical、189 项全定义、18 项公开定义、完整 strict（无诊断）、原两项测试及相对路径构建。实际隔离页面完成合成输入、run 日志、Reel 历史回看、两条记录逐项 Step、Run 与正常刷新恢复，控制台无警告或错误。未重测坏存档保护、60 秒定时保存或共享 key 冲突，不以正常刷新替代这些验收。

### 功能范围

输入事件使用真实 Respo Map 并解码 value，不假定为事件 Struct。混合 key 的 widget 状态仍是显式开放边界；不将其伪装为闭合业务模型。`run` 按钮只输出当前文本日志。使用 `?mode=dev`，按 Meta+Alt+Shift+K（macOS 为 ⌘⌥⇧K）展开 Reel 控件。

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
