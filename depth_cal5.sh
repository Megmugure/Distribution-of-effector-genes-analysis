#!/usr/bin/bash

#SBATCH -p batch
#SBATCH -w taurus
#SBATCH -J dep_cal5
##SBATCH -n 8
#SBATCH -o /home/mwanjiku/bwa_effector_genes/output/slurm_out
#SBATCH -e /home/mwanjiku/bwa_effector_genes/output/slurm_errors

INFILE=/home/mwanjiku/bwa_effector_genes/refGenome/effectorG.fa
OUTDIR=/home/mwanjiku/bwa_effector_genes/output


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


MIN_COVERAGE_DEPTH=3
DATADIR=/home/mwanjiku/bwa_effector_genes/new_out3
REFGENOME=/home/mwanjiku/bwa_effector_genes/refGenome/effectorG.fa

#loading necessary tools
module load samtools/1.9

for num in 59 6 64 65 69 7 7- 70 71 9
do
    echo -e "\nisolate${num}"

         # get total number of bases covered at MIN_COVERAGE_DEPTH of 3 or higher of each of the 178 genes
        for i in $(cat ${OUTDIR}/headings2.txt)
        do

            NUM_BASES=$(samtools depth ${DATADIR}/isolate${num}_sorted.bam | grep -F "${i}" | \
                        awk -v X="${MIN_COVERAGE_DEPTH}" '{if ($3>=X) sum+=$3} END {print sum}')
            #echo "bases = ${NUM_BASES}"

            if [ ${NUM_BASES} -ne 0 ]
            then
                echo -e "${i}\n"
                # get length of each of the 178 genes on the reference genome
                LEN_GENE=$(samtools mpileup -aa -f ${REFGENOME} ${DATADIR}/isolate${num}_sorted.bam | \
                          grep -F "${i}" | wc -l)
                #echo "len_gene = ${LEN_GENE}"

                DEP_COV=$(bc <<< "scale=2;$NUM_BASES/$LEN_GENE")
                echo "coverage = ${DEP_COV}"


            else
                echo -e "${i}\n"
                echo "coverage = 0"
            fi

        done

done > ${OUTDIR}/solutions5.txt
