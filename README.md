# holesail-termux

A script to install [Holesail](https://holesail.io) in Termux and put
connect/disconnect shortcuts on your Android homescreen.

It installs **[holesail-cpp](https://github.com/jjacke13/holesail-cpp)** — a C++
port of holesail that speaks the same protocol as the original: same connection
strings, same keys, same DHT. It just does it in a ~1.7 MB binary with no Node
runtime, which on a phone is the difference between ~3 MB of RSS and ~78 MB.

Of course you can use the awesome Android Holesail app instead.
This repo is for the geeks and the hackers that like using terminal in their phones :)

## Steps

1. On your Android device, install the Termux app
2. Open termux and run:

		sh <(curl -L https://raw.githubusercontent.com/jjacke13/holesail-termux/refs/heads/main/holesail.sh)

3. Be patient and read and follow the instructions when it asks you stuff.
4. Optionally, you can install Termux:Widget in your phone and have shortcuts on your homescreen

## Notes

**arm64 only.** The script checks and stops early if the device is something else.

**The binary is verified before install.** Its SHA-256 is checked against the
`SHA256SUMS.txt` published with the same release, and nothing is moved onto your
`PATH` unless it matches.

**Doze.** `~/hole` takes a `termux-wake-lock` before connecting and releases it
on exit. Without one, Android suspends the tunnel's sockets shortly after the
screen goes off and the connection dies quietly.

If you are on Android 12 or newer and long-running connections still get killed,
it is the phantom process killer:

```
adb shell settings put global settings_enable_monitor_phantom_procs false
```

## Why not a static binary

Because Android kills it. Every app process runs behind a seccomp allowlist
built around bionic's syscall set, and a statically linked musl binary makes a
syscall outside it and dies with `SIGSYS` on startup — which Termux reports as
the wonderfully unhelpful `Unknown signal 31`. So the binary here links bionic
dynamically: `libm`, `libdl`, `libc`, nothing else.

PS.
Beware of rogue spaces and newlines :P
