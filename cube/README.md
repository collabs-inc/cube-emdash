# Emdash for Cube

Install `https://github.com/collabs-inc/cube-emdash` from Cube Apps. This fork pins
Emdash v1.2.7 (`f37a360069ffac8de8daff01da91aa32ead6fdc8`) and retains the original
Apache-2.0 source and notices. No application source build is required.

The installer verifies the official Linux Debian package against the committed
SHA-256 in `release.json`, then extracts it privately (no system package install).
Linux x64 and ARM64 are supported. x64 cache footprint is approximately 807 MB.
The extracted Electron updater metadata is removed so Cube owns runtime updates.
The original archive, source and licensing remain unchanged upstream.

Native profile/database/logs live in `~/.local/share/cube-emdash/profile`, with
display/keyring data under `~/.local/share/cube-emdash/bridge`. The release cache
is `~/.cache/cube-emdash`. XDG paths are honored; `CUBE_EMDASH_DATA_DIR` overrides
the persistent root. Cube checkout replacement leaves all these directories intact.
HOME and existing Claude/Codex/Git/GitHub login locations stay unchanged. Telemetry
is disabled. The integration does not read, copy or print credential files.

The native app uses the shared [desktop bridge](desktop/README.md) inside Cube's
authenticated app pane. Normal Chromium sandboxing remains enabled. The private
Secret Service may ask the user to create/unlock a keyring before saving new
secrets; there is no preset password or plaintext fallback. Native dialogs remain
visible. Agent CLI sign-ins already on the machine are reused.

Validation: `node --test cube/desktop/*.test.mjs`, `node --check cube/start.mjs`,
`sh -n cube/install.sh`. Cloud verification uses the exact released Linux binary.
