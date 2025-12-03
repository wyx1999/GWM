
SAMPLE="sampleID"

gunzip -c /trimdata/*R1P.fastq.gz > ${SAMPLE}_1.fastq
gunzip -c /trimdata/*R2P.fastq.gz > ${SAMPLE}_2.fastq

metawrap binning   -a /${SAMPLE}/final.contigs.fa   -o /metawrap/${SAMPLE}   -t 8 -m 150   --metabat2 --maxbin2 --concoct   /${SAMPLE}/${SAMPLE}_1.fastq   /${SAMPLE}/${SAMPLE}_2.fastq 

rm -v *.fastq


metawrap bin_refinement -t 32 -m 180 -c 50 -o /metawrap/${SAMPLE}/bins -A /metawrap/${SAMPLE}/maxbin2_bins -B /metawrap/${SAMPLE}/concoct_bins -C /metawrap/${SAMPLE}/metabat2_bins -x 10

