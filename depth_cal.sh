#!/usr/bin/bash

#SBATCH -p batch
#SBATCH -w taurus
#SBATCH -J dep_cal
#SBATCH -n 8
#SBATCH -o slurm_out
#SBATCH -e slurm_errors

INFILE=/home/mwanjiku/bwa_effector_genes/refGenome/effectorG.fa
OUTDIR=/home/mwanjiku/bwa_effector_genes/output

rm ${OUTDIR}/headings* ${OUTDIR}/dep_solution.txt

counter=1
while read line
do
    if [[ $line == ">"* ]]
        then
            echo "$line" >> ${OUTDIR}/headings.txt
        fi

    counter=$((counter+1))

done < ${INFILE}

cat ${OUTDIR}/headings.txt | sed 's/>//' >> ${OUTDIR}/headings2.txt

DATADIR=/home/mwanjiku/bwa_effector_genes/mapping_out2
OUTDIR=/home/mwanjiku/bwa_effector_genes/output

#loading necessary tools
module load samtools/1.9

for file in ${DATADIR}/*_sorted.bam
do
   NAME=$(echo ${file} | cut -d'/' -f 6 | cut -d'_' -f 1)
   echo "${NAME}"

    for i in $(cat ${OUTDIR}/headings2.txt)
    do 
        echo -e "${i}\n"
       samtools depth -a ${DATADIR}/${NAME}_sorted.bam | grep -F "${i}" | awk '{sum+=$3} END {print "Average = ",sum/NR}'
    done

done > ${OUTDIR}/dep_solution.txt
