
PROJECT="GWM"
INDIR="/trimdata/${PROJECT}"
DBDIR="/database/metaphlan"
OUT_MAP="/${PROJECT}/result_bowtie2"
OUT_PROFILE="/${PROJECT}/result_profiled"
LOG_DIR="/${PROJECT}"

mkdir -p "$OUT_MAP" "$OUT_PROFILE" "$LOG_DIR"

SAMPLE_LIST=$(mktemp)

for sample in $(ls -1 "${INDIR}"); do
    if [[ -f "${OUT_PROFILE}/${sample}.txt" ]]; then
        echo "[SKIP] ${sample} (already processed)"
    else
        echo "$sample" >> "$SAMPLE_LIST"
    fi
done

echo
echo "[INFO] Samples to process:"
cat "$SAMPLE_LIST"
echo

echo "[INFO] Running MetaPhlAn with 16 parallel jobs..."

parallel -j 8 --joblog "${LOG_DIR}/parallel_joblog.txt" '
    sample={};

    log_file="'${LOG_DIR}'/${sample}.log"
    echo "[START] $sample" > "$log_file"
    echo "Start time: $(date)" >> "$log_file"

    metaphlan \
        "'${INDIR}'/${sample}/${sample}_R1P.fastq.gz","'${INDIR}'/${sample}/${sample}_R2P.fastq.gz" \
        --input_type fastq \
        --mapout "'${OUT_MAP}'/${sample}.bowtie2.bz2" \
        --nproc 16 \
        --db_dir "'${DBDIR}'" \
        --skip_unclassified_estimation \
        -o "'${OUT_PROFILE}'/${sample}.txt" \
        &>> "$log_file"

    echo "[DONE] $sample at $(date)" >> "$log_file"
' :::: "$SAMPLE_LIST"
rm -f "$SAMPLE_LIST"
echo "[INFO] All MetaPhlAn jobs finished."
