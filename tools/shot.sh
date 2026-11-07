#!/bin/bash
# 把一张 HTML 模板截成 PNG。  shot.sh 模板.html 输出.png [宽 高]
# 不写宽高：文件名含 cover 用 2000x800，其余用 1672x941。
set -euo pipefail
HTML="$1"; OUT="$2"
rm -f "$OUT"
case "$(basename "$HTML")" in cover*) W=${3:-2000}; H=${4:-800};; *) W=${3:-1672}; H=${4:-941};; esac
ABS_HTML="$(cd "$(dirname "$HTML")" && pwd)/$(basename "$HTML")"
# Find a Chrome-like browser: $CHROME, then Chrome, Chromium, Edge.
if [ -z "${CHROME:-}" ]; then
  for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
           "/Applications/Chromium.app/Contents/MacOS/Chromium" \
           "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
           "$(command -v google-chrome 2>/dev/null || true)" "$(command -v chromium 2>/dev/null || true)"; do
    [ -n "$c" ] && [ -x "$c" ] && { CHROME="$c"; break; }
  done
fi
[ -n "${CHROME:-}" ] || { echo "Chrome not found. Install Google Chrome, or set CHROME=/path/to/chrome" >&2; exit 1; }
mkdir -p "$(dirname "$OUT")"
ABS_OUT="$(cd "$(dirname "$OUT")" && pwd)/$(basename "$OUT")"
# file:// URL with # ? and other characters escaped
URL="$(python3 -c 'import pathlib,sys;print(pathlib.Path(sys.argv[1]).as_uri())' "$ABS_HTML" 2>/dev/null || echo "file://$ABS_HTML")"
"$CHROME" --headless=new --disable-gpu --hide-scrollbars \
  --force-device-scale-factor=1 --allow-file-access-from-files --window-size="$W,$H" \
  --virtual-time-budget=3000 --screenshot="$ABS_OUT" "$URL" >/dev/null 2>&1 || true
if [ ! -s "$ABS_OUT" ]; then
  echo "FAILED: Chrome made no image from $ABS_HTML" >&2
  echo "If you are Codex: Chrome cannot start inside the Codex sandbox. Run this same command again outside the sandbox (escalated permissions)." >&2
  exit 1
fi
echo "saved $ABS_OUT ($W x $H)"
