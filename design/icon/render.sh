#!/bin/bash
# SVG を headless Chrome で PNG にレンダリングする。
#   usage: design/icon/render.sh input.svg output.png [size]
set -euo pipefail
IN="$1"; OUT="$2"; SIZE="${3:-1024}"
ABS_IN="$(cd "$(dirname "$IN")" && pwd)/$(basename "$IN")"
ABS_OUT="$(cd "$(dirname "$OUT")" && pwd)/$(basename "$OUT")"
TMP_HTML="$(mktemp -t icon).html"
{
  echo "<!doctype html><html><head><meta charset='utf-8'><style>html,body{margin:0;padding:0;width:${SIZE}px;height:${SIZE}px;overflow:hidden;background:transparent}svg{display:block;width:${SIZE}px;height:${SIZE}px}</style></head><body>"
  cat "$ABS_IN"
  echo "</body></html>"
} > "$TMP_HTML"
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu --hide-scrollbars \
  --default-background-color=00000000 --force-device-scale-factor=1 \
  --screenshot="$ABS_OUT" --window-size="${SIZE},${SIZE}" "file://${TMP_HTML}" >/dev/null 2>&1
rm -f "$TMP_HTML"
sips -g pixelWidth -g pixelHeight "$ABS_OUT" | tail -2 | tr -s ' ' | tr '\n' ' '; echo " -> $OUT"
