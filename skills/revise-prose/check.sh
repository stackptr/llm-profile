#!/usr/bin/env bash
# Flags the words listed under "Words to replace" in SKILL.md, with their
# inflections. Hits are candidates, not verdicts: "robust" can be the right
# technical term. Keep this list in step with SKILL.md.
#
# Usage: check.sh [file]   (reads stdin when no file is given)
set -euo pipefail

stems='delv|tapestr|meticulous|pivotal|intricat|interplay|underscor|garner|bolster|vibran|bustl|multifaceted|seamless|commendabl|ever-evolving|realm|landscape|testament|showcas|foster|harness|unlock|elevat|embark|navigat|robust|crucial|essential|profound|nuanc|holistic|myriad|plethora|leverag|additionally|moreover|furthermore|in conclusion'

if grep -niowE "($stems)[a-z]*" "${1:-/dev/stdin}"; then
  exit 1
fi
echo "No flagged words."
