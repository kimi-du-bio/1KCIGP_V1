#!/bin/bash
#SBATCH -J mito
#SBATCH -N 1
#SBATCH -n 18
#SBATCH --mem=100gb

rawdatafile=	##the file which rawdata locate
id=				##the sample ID final output
rawid=				##the ID of the raw data
line1=				##the first line
line2=			##the second line
output= 	##the final output file

##switch to the work file
cd $output

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
bwa mem -t 6 -M -R "@RG\tID:$id\tLB:$id\tPL:ILLUMINA\tSM:$id" \
MT.fa \
$output/$id\_clean\_1.fq.gz $output/$id\_clean\_2.fq.gz > $output/$id.sam

##reorder sam
gatk --java-options "-Xmx32G" ReorderSam \
-I $output/$id.sam -O $output/$id.reorder.sam  -R MT.fa

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

##coverage detection
samtools index $output/$id.rmdup.bam
samtools flagstat $output/$id.rmdup.bam > $output/$id\_final.stat
java -Xmx32G -jar GenomeAnalysisTK-3.8/GenomeAnalysisTK.jar -T DepthOfCoverage \
-R /MT.fa -o $output/finaldepth -I $output/$id.rmdup.bam --omitDepthOutputAtEachBase --omitIntervalStatistics -ct 1 -ct 10 -ct 20

##extract aligned
samtools view -hF 12 $output/$id.rmdup.bam > $output/$id.sam
samtools view -b $output/$id.sam > $output/$id.bam
samtools sort -n $output/$id.bam | samtools fastq -1 $output/$id\_1.fastq \
-2 $output/$id\_2.fastq -

##filter
seqkit grep -f <(seqkit seq -n -i $output/$id\_1.fastq ) $output/$id\_2.fastq  > $output/$id\_2.filter.fastq
seqkit grep -f <(seqkit seq -n -i $output/$id\_2.fastq ) $output/$id\_1.fastq  > $output/$id\_1.filter.fastq

##assemble
mkdir $output/MT/ && cd $output/MT/
mitozEnv/bin/python3 /home/liujf/software/MitoZ-master/version_2.4-alpha/release_MitoZ_v2.4-alpha/MitoZ.py all \
--clade Chordata --outprefix $output/MT/$id \
--thread_number 18 \
--fastq1 $output/$id\_1.filter.fastq \
--fastq2 $output/$id\_2.filter.fastq \
--fastq_read_length 150 \
--insert_size 250  \
--run_mode 2 \
--filter_taxa_method 1 \
--requiring_taxa 'Chordata'
