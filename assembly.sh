
SAMPLE="sampleID"

megahit \
  -1 "/trimdata/${SAMPLE}/${SAMPLE}R1P.fq.gz" \
  -2 "/trimdata/${SAMPLE}/${SAMPLE}R2P.fq.gz" \
  -o "/megahit/${SAMPLE}" \
  -t 28 \
  --presets meta-large