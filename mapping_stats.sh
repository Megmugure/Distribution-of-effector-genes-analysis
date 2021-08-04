#!/usr/bin/bash

#SBATCH -p batch
#SBATCH -w taurus
#SBATCH -J mapping_stats
##SBATCH -n 8
#SBATCH -o /home/mwanjiku/bwa_effector_genes/mapping_stats_output/slurm_out
#SBATCH -e /home/mwanjiku/bwa_effector_genes/mapping_stats_output/slurm_errors

INFILE=/home/mwanjiku/bwa_effector_genes/mapping_out
OUTDIR=/home/mwanjiku/bwa_effector_genes

mkdir ${OUTDIR}/mapping_stats_output

(for i in ${INFILE}/*sorted.bam ; do samtools flagstat -@ 8 ${i} ; done}) > ${OUTDIR}/mapping_stats_output
