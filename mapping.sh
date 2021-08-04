#!/usr/bin/bash

#SBATCH -p batch
#SBATCH -w taurus
#SBATCH -J mapping
#SBATCH -n 8
#SBATCH -o /home/mwanjiku/bwa_effector_genes/mapping_out2/slurm_out
#SBATCH -e /home/mwanjiku/bwa_effector_genes/mapping_out2/slurm_errors

#loading necessary tools
module load bwa/0.7.4
module load samtools/1.9


INDIR=/home/mwanjiku/bwa_effector_genes/SRA_reads
OUTDIR=/home/mwanjiku/bwa_effector_genes/mapping_out2
REFDIR=/home/mwanjiku/bwa_effector_genes/refGenome
REF_FASTA=${REFDIR}/effectorG.fa

##building an index of the reference genome for bwa
#cd ${REFDIR}
#bwa index -a bwtsw ${REF_FASTA}

##mapping the reads to the indexed reference genome

for i in `(ls ${INDIR})`
do

  echo ${i}

  cd ${INDIR}/${i}

  bwa mem -t 8 ${REF_FASTA} ${INDIR}/${i}/${i}_1.fastq ${INDIR}/${i}/${i}_2.fastq > ${OUTDIR}/${i}.sam

  samtools view -@ 3 -bT ${REF_FASTA} -o ${OUTDIR}/${i}.bam ${OUTDIR}/${i}.sam

  samtools sort -@ 4 -o ${OUTDIR}/${i}_sorted.bam ${OUTDIR}/${i}.bam

  samtools index ${OUTDIR}/${i}_sorted.bam

done

