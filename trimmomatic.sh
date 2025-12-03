


input_dir=/raw
output_base=/trimdata
sample_list=/list.txt
joblog=/trim_joblog.txt
trimmomatic_jar=/software/Trimmomatic-0.39/trimmomatic-0.39.jar
log_output_base=/trim

find "$input_dir" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" > "$sample_list"

parallel -a "$sample_list" -j 3 --joblog "$joblog" '
  sample={};
  outdir='"$output_base"'/$sample;
  mkdir -p "$outdir";

  if [[ -f "$outdir/${sample}_R1P.fastq.gz" ]]; then
    echo "SKIP $sample (already processed)";
    exit 0;
  fi
  log_outdir='"$log_output_base"';
  log_file="$log_outdir/${sample}.log"

  echo "Processing $sample ..."
  echo "Start time: $(date)" > "$log_file"

  java -jar '"$trimmomatic_jar"' PE -threads 12 \
    '"$input_dir"'/$sample/${sample}_1.fastq.gz \
    '"$input_dir"'/$sample/${sample}_2.fastq.gz \
    "$outdir/${sample}_R1P.fastq.gz" "$outdir/${sample}_R1U.fastq.gz" \
    "$outdir/${sample}_R2P.fastq.gz" "$outdir/${sample}_R2U.fastq.gz" \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 \
    &>> "$log_file"

  echo "Finished $sample at: $(date)" >> "$log_file"
'

echo "✅ All Trimmomatic jobs submitted successfully."