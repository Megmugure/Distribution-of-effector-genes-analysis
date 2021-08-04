#!/usr/bin/bash

#SBATCH -p batch
#SBATCH -w compute04
#SBATCH -J dep_cal
#SBATCH -n 8
#SBATCH -o slurm_out
#SBATCH -e slurm_errors

INFILE=/home/mwanjiku/bwa_effector_genes/refGenome/effectorG.fa
OUTDIR=/home/mwanjiku/bwa_effector_genes/output

counter=1
while read line
do
    if [[ $line == ">"* ]]
        then
	    echo "$line" >> ${OUTDIR}/headers.txt
        fi

    counter=$((counter+1))

done < ${INFILE}

cat ${OUTDIR}/headers.txt | sed 's/>//' >> ${OUTDIR}/headers2.txt
