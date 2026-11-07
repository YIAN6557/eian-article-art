#!/bin/bash
# Generate ONE image with the user's Codex CLI and copy it to OUT.
#   codex_image2.sh PROMPT_FILE OUT.png [REF.png ...]
# Safe to run in parallel: the image is taken from this run's own session folder.
set -uo pipefail
# Find codex: $CODEX, then the codex command, then the one inside the ChatGPT desktop app.
CODEX="${CODEX:-$(command -v codex 2>/dev/null || true)}"
[ -n "$CODEX" ] || CODEX=/Applications/ChatGPT.app/Contents/Resources/codex-cli/bin/codex
[ -x "$CODEX" ] || { echo "codex not found. Install Codex, or set CODEX=/path/to/codex"; exit 1; }
if [ $# -lt 2 ]; then echo "usage: codex_image2.sh PROMPT_FILE OUT.png [REF.png ...]"; exit 1; fi
PROMPT_FILE="$1"; OUT="$2"; shift 2
for f in "$PROMPT_FILE" "$@"; do [ -s "$f" ] || { echo "file not found: $f"; exit 1; }; done
LOG="${OUT%.png}.codex.log"
REFS=(); for r in "$@"; do REFS+=(-i "$r"); done
{
  echo "Use your image generation tool to create exactly ONE image from the brief below."
  echo "Do not run shell commands and do not create or edit any files. When the image is done, reply with the single word: done."
  echo
  cat "$PROMPT_FILE"
} | "$CODEX" exec --skip-git-repo-check -s read-only -c model_reasoning_effort='"low"' -c 'notify=[]' ${REFS[@]+"${REFS[@]}"} - > "$LOG" 2>&1
SID=$(grep -m1 '^session id:' "$LOG" | awk '{print $3}')
DIR="${CODEX_HOME:-$HOME/.codex}/generated_images/$SID"
NEW=$(ls -t "$DIR"/*.png 2>/dev/null | head -1)
[ -n "$SID" ] && [ -n "$NEW" ] || { echo "no image for $OUT (session $SID); see $LOG"; exit 1; }
cp "$NEW" "$OUT"; cp "$PROMPT_FILE" "${OUT%.png}.prompt.txt"
echo "saved $OUT  (session images: $(ls "$DIR"/*.png | wc -l | tr -d ' '))"
