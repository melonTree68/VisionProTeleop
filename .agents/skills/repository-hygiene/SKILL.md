---
name: repository-hygiene
description: Maintain this repository's ignore rules and remove tracked local caches or editor state while preserving build dependencies and published documentation.
---

# Repository hygiene

The root `.gitignore` covers macOS/editor debris, Xcode and Swift build output, personal workspace state, Python caches/environments, recordings, downloads, and credentials. Cloudflare/Node rules belong in `infrastructure/signaling-server/.gitignore`.

When cleaning tracked files, inspect `git ls-files` and remove confirmed local artifacts with `git rm --cached`, preserving local copies. Stage only the selected paths; unrelated work and project instructions may already be untracked.

Keep these intentional repository inputs:

- `Tracking Streamer/OpenCV/opencv2.xcframework` is a vendored dependency.
- Swift/Python protobuf outputs are shipped source files.
- `Package.resolved`, shared Xcode schemes, Reality Composer project settings, model meshes, and calibration assets are shared inputs.
- `docs/build/html` is the direct input of `.github/workflows/deploy-docs.yml`. Keep published HTML and static files tracked; ignore only `.doctrees` and `.buildinfo` until the deployment workflow changes.

## Common issues

Personal Xcode state and Reality Composer camera/editor state were previously tracked, including copies embedded under `Assets.xcassets/RealityKitContent`. Ignore `xcuserdata`, `*.xcuserstate`, and `*.rcuserdata`; the asset catalog's copied `.swiftpm` directory and personal-state dataset are also ignored. Preserve scene and material assets.

The old blanket `build/` rule masked updates to published documentation. Root build output now uses `/build/`, with Sphinx cache paths handled explicitly. Blender numbered backup files are ignored while their `.blend` source remains tracked.

After changing rules, use `git ls-files -ci --exclude-standard` to check for remaining tracked ignored files, and `git check-ignore --no-index` on representative generated and retained paths.
