#!/bin/sh
#
# Install holesail-cpp in Termux and wire up connect/disconnect shortcuts.
#
# This uses holesail-cpp, a C++ port of holesail that speaks the same protocol
# — same connection strings, same keys — in ~1.7 MB with no Node runtime. On a
# phone that matters: the JS holesail needs ~78 MB of RSS, this needs ~3 MB.
#
# It is a bionic build, not a static one. Android runs every app process behind
# a seccomp allowlist shaped around bionic's syscall set, and a static musl
# binary is killed with SIGSYS before main() — Termux shows that as
# "Unknown signal 31".
set -e

VERSION="v0.2.0"
REPO="jjacke13/holesail-cpp"
ASSET="holesail-$VERSION-aarch64-android"
BASE="https://github.com/$REPO/releases/download/$VERSION"

# arm64 only. Everything below would "work" on a 32-bit device right up until
# the binary refuses to exec, with a much less obvious message than this one.
arch=$(uname -m)
if [ "$arch" != "aarch64" ] && [ "$arch" != "arm64" ]; then
  echo "This installs an arm64 binary, but this device reports '$arch'."
  echo "Build from source instead: https://github.com/$REPO"
  exit 1
fi

# curl is all we need — the release asset is a bare binary, not an archive.
pkg update && pkg upgrade -y && pkg install curl -y

echo "Downloading holesail-cpp $VERSION..."
tmp=$(mktemp -d)
curl -fsSL -o "$tmp/holesail" "$BASE/$ASSET"
curl -fsSL -o "$tmp/SHA256SUMS.txt" "$BASE/SHA256SUMS.txt"

# Verify before it goes anywhere near PATH. SHA256SUMS.txt covers every asset
# in the release, so check the one line for ours rather than the whole file.
echo "Verifying checksum..."
want=$(grep " $ASSET\$" "$tmp/SHA256SUMS.txt" | cut -d' ' -f1)
got=$(sha256sum "$tmp/holesail" | cut -d' ' -f1)
if [ -z "$want" ] || [ "$want" != "$got" ]; then
  echo "Checksum mismatch — refusing to install."
  echo "  expected: ${want:-<not found in SHA256SUMS.txt>}"
  echo "  got:      $got"
  rm -rf "$tmp"
  exit 1
fi
echo "OK: $got"

chmod +x "$tmp/holesail"
mv "$tmp/holesail" "$PREFIX/bin/holesail"
rm -rf "$tmp"

# Get holesail key
echo "Paste your holesail key:"
read key

# Create connection script. termux-wake-lock keeps Android's doze from
# suspending the tunnel's sockets once the screen goes off; without it the
# connection dies quietly after a few minutes.
cat > ~/hole <<EOF
#!/bin/sh
command -v termux-wake-lock >/dev/null && termux-wake-lock
trap 'command -v termux-wake-unlock >/dev/null && termux-wake-unlock' EXIT
holesail $key
EOF
chmod +x ~/hole

# Create shortcuts
mkdir -p ~/.shortcuts
echo '#!/bin/sh
if [ -f ~/hole ]; then ~/hole; else echo "Run setup first"; fi' > ~/.shortcuts/connect
echo '#!/bin/sh
pkill -f holesail && echo "Disconnected"
command -v termux-wake-unlock >/dev/null && termux-wake-unlock' > ~/.shortcuts/disconnect
chmod +x ~/.shortcuts/*

# Add aliases and PATH
echo 'alias hs="~/hole"
alias stop="pkill -f holesail"
export PATH="$HOME/.shortcuts:$PATH"' >> ~/.bashrc

echo "Setup complete! ($(holesail --version))"
echo "Commands: 'hs' to connect, 'stop' to disconnect"
echo "Widgets: Add Termux widget, use 'connect' and 'disconnect'"
echo "Restart Termux or run: . ~/.bashrc"
