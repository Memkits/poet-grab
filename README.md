
Poet grab(TODO...)
----

> Toy for grabbing sentences from poets.

### Development

Use Calcit 0.27.0, Node.js 24, and Yarn 4.18.0:

```bash
caps --ci
yarn install --immutable
calcit calcit.cirru --check-only
calcit calcit.cirru test --tag unit --require-match
calcit calcit.cirru js
yarn vite build
```

The app builds frontend files into `dist/`. The CI workflow uses the CDN base
`https://cos-sh.tiye.me/Memkits/poet-grab/` (or its `/pr/` preview path), then
uploads and publicly verifies only `dist/` on COS. The existing production
rsync destination remains `rsync-user@tiye.me:/web-assets/repo/Memkits/poet-grab`.

### Workflow

Workflow https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
