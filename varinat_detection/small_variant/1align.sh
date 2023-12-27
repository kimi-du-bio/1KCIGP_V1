#!/bin/bash
#SBATCH -J 1
#SBATCH -N 1
#SBATCH -n 18
#SBATCH --mem=200gb

rawdatafile=	##the file which rawdata locate
id=				##the sample ID final output
rawid=				##the ID of the raw data
line1=				##the first line
line2=			##the second line
output=				##the final output file

##switch to the work file
cd $output
mkdir $output/quality

##raw reads quality control
trim_galore -q 20 --phred33 --stringency 3 --length 70 -e 0.1 \
--paired $rawdatafile/$rawid\-$line1\_1.fq.gz $rawdatafile/$rawid\-$line1\_2.fq.gz \
--gzip -o $output -j 18
trim_galore -q 20 --phred33 --stringency 3 --length 70 -e 0.1 \
--paired $rawdatafile/$rawid\-$line2\_1.fq.gz $rawdatafile/$rawid\-$line2\_2.fq.gz \
--gzip -o $output -j 18

##clean reads quality detection
mkdir $output/quality/clean/
fastqc -o $output/quality/clean/ \
$output/$rawid\-$line1\_1\_val\_1.fq.gz $output/$rawid\-$line1\_2\_val\_2.fq.gz
fastqc -o $output/quality/clean/ \
$output/$rawid\-$line2\_1\_val\_1.fq.gz $output/$rawid\-$line2\_2\_val\_2.fq.gz

##merge data
cat $output/$rawid\-$line1\_1\_val\_1.fq.gz $output/$rawid\-$line2\_1\_val\_1.fq.gz > $output/$id\_clean\_1.fq.gz
cat $output/$rawid\-$line1\_2\_val\_2.fq.gz $output/$rawid\-$line2\_2\_val\_2.fq.gz > $output/$id\_clean\_2.fq.gz

##aligning to the reference genome
bwa mem -t 18 -M -R "@RG\tID:$id\tLB:$id\tPL:ILLUMINA\tSM:$id" \
reference.fa \
$output/$id\_clean\_1.fq.gz $output/$id\_clean\_2.fq.gz > $output/$id.sam

##reorder sam
gatk --java-options "-Xmx32G" ReorderSam \
-I $output/$id.sam -O $output/$id.reorder.sam  -R reference.fa

##sam to bam
samtools view -b -S \
$output/$id.reorder.sam -o $output/$id.reorder.bam

##sort bam
gatk --java-options "-Xmx32G" SortSam \
-I $output/$id.reorder.bam -O $output/$id.sort.bam  --SORT_ORDER coordinate

##PCR duplicates marked
gatk --java-options "-Xmx32G" MarkDuplicates \
-I $output/$id.sort.bam -O $output/$id.rmdup.bam  --MAX_FILE_HANDLES_FOR_READ_ENDS_MAP 8000 --REMOVE_DUPLICATES false --METRICS_FILE $output/$id.sort.rmdup.metric
samtools index $output/$id.rmdup.bam

##BQSR
gatk --java-options "-Xmx32G" BaseRecalibrator \
-R reference.fa -I $output/$id.rmdup.bam  --bqsr-baq-gap-open-penalty 30 \
--known-sites known-sites.vcf -O $output/$id.recal_data.grp
gatk --java-options "-Xmx32G" ApplyBQSR \
-R reference.fa  -I $output/$id.rmdup.bam --bqsr-recal-file $output/$id.recal_data.grp -O $output/$id.recal.bam

##index final bam file
samtools index $output/$id.recal.bam

##alignment detection
samtools flagstat $output/$id.recal.bam > $output/$id\_final.stat

##HaplotypeCaller
gatk HaplotypeCaller \
--emit-ref-confidence GVCF \
-R reference.fa \
-I $output/$id.recal.bam -O $output/$id.g.vcf
