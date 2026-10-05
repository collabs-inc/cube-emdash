#!/bin/sh
set -eu
umask 077
version=1.2.7
case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) target=linux-x64; asset=emdash-amd64.deb; digest=712cccf29417df64f7835195f58c01dec9c76459aebf75721cc4a1a24b0e6e18 ;;
  Linux-aarch64|Linux-arm64) target=linux-arm64; asset=emdash-arm64.deb; digest=5558558899c82fd2214bf4d29fba45e63aa894122bbab79c1514c94a24d61f40 ;;
  *) echo 'Emdash for Cube requires Linux x64 or ARM64.' >&2; exit 1 ;;
esac
cache="${XDG_CACHE_HOME:-$HOME/.cache}/cube-emdash"
runtime="$cache/$version-$target"
if [ -x "$runtime/opt/Emdash/Emdash" ] && [ -f "$runtime/.cube-sha256" ] && [ "$(cat "$runtime/.cube-sha256")" = "$digest" ]; then
  echo "Emdash $version is installed."
  exit 0
fi
command -v dpkg-deb >/dev/null 2>&1 || { echo 'dpkg-deb is required to extract the upstream package.' >&2; exit 1; }
mkdir -p "$cache"
stage=$(mktemp -d "$cache/.install-XXXXXX")
trap 'rm -rf "$stage"' EXIT HUP INT TERM
curl --fail --location --retry 3 --silent --show-error \
  "https://github.com/generalaction/emdash/releases/download/v$version/$asset" \
  --output "$stage/runtime.deb"
actual=$(sha256sum "$stage/runtime.deb" | cut -d ' ' -f 1)
[ "$actual" = "$digest" ] || { echo 'Emdash archive checksum mismatch.' >&2; exit 1; }
mkdir "$stage/runtime"
dpkg-deb --extract "$stage/runtime.deb" "$stage/runtime"
[ -x "$stage/runtime/opt/Emdash/Emdash" ] || { echo 'Upstream Emdash executable was not found.' >&2; exit 1; }
printf '%s\n' "$digest" > "$stage/runtime/.cube-sha256"
rm -rf "$runtime"
mv "$stage/runtime" "$runtime"
echo "Installed Emdash $version ($target)."
