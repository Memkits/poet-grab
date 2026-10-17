
Poet grab(TODO...)
----

> Toy for grabbing sentences from poets.

### Development

Use paired Calcit/procs 0.30.1-alpha.4 (a compiler prerelease, not stable
0.30.1), Node.js 24, and Yarn 4.18.0. Calcit modules use formal tags:
Respo 0.16.122, UI 0.7.41, Reel 0.6.39 and JS-FFI 0.2.3.

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
Set `?mode=dev` in the browser to see the typed Reel controls. No source change
or successful preview authorizes production deployment; merging main retains the
existing frontend-only COS/rsync behavior and requires separate approval.

### Workflow

Workflow https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
