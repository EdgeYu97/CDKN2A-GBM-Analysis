#!/usr/bin/env bash
#=====================================================================
# Filter TCGA-GBM gene-level Copy Number Variation for Unambiguous Non-Deleted Samples (>=2 copies)
# Author: Guanqiao Yu (Edge)
# Date: 10/07/2025

set -euo pipefail

ROOT="${1:-data/gdc_cache/TCGA-GBM/Copy_Number_Variation/Gene_Level_Copy_Number}"
OUT="${2:-results/cnv_cdkn2a_mtap_ge2.tsv}"
GENE="${3:-CDKN2A}"
THRESH="${5:-2}"

mkdir -p "$(dirname "$OUT")"

# Header
printf "SampleID\t%s_Copy\n" "$GENE" > "$OUT"

find "$ROOT" -type f -name '*.tsv' -print0 |
while IFS= read -r -d '' f; do
  # UUID is the parent directory of the TSV
  uuid="$(basename "$(dirname "$f")")"

  awk -v FS='\t' -v OFS='\t' -v SAMPLE="$uuid" -v G="$GENE" -v T="$THRESH" '
    NR==1 { next }                   # skip header
    $2==G { seen=1; cn=$6+0; mn=$7+0; mx=$8+0 }
    END {
      ok = (seen && cn>=T && mn==cn && mx==cn)
      if (ok) printf "%s\t%d\n", SAMPLE, cn
    }' "$f" >> "$OUT"
done

echo "Filtered results saved to $OUT"