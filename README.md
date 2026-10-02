
Poet grab(TODO...)
----

> Toy for grabbing sentences from poets.

### Development

Use Calcit 0.27.0, Node.js 24, and Yarn 4.18.0:

Keep `calcit.cirru` and `deps.cirru` as the canonical source and dependency
files. Do not restore the retired `compact.cirru` or `package.cirru`; CI checks
that both canonical files exist and both retired files are absent.

```bash
caps --strict --ci
yarn install --immutable
calcit calcit.cirru --check-only
calcit calcit.cirru test --tag unit --require-match
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

### Workflow

Workflow https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
