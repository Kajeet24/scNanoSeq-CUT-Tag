#!/bin/bash
workdir=`pwd`
bin_file=$workdir/mm10_repeat_CDS/mm10_L1Md_A_CDS_region.Query.bin.bed
outdir=$workdir/scNanoseq_cuttag
mkdir -p $outdir

cd $workdir/../scNanoseq_cuttag/

ls *.bed|while read file
do

    sample=$(echo $file|sed 's/.bed//g')

    less ${sample}.bed |  \
    bedtools intersect -a  $bin_file -b - -wo | \
    awk '{print $0"\t"$8-$7}'|awk '{if ($11>=150)print}'| \
    awk -vOFS='\t'  '{print $1,$2,$3,$4,$5,1}'|bedtools groupby -g 1,2,3,4,5 -c 6 -o sum|\
    bedtools intersect -a $bin_file -b - -loj|\
    awk -vOFS='\t'  '{if ($7>0)print $1,$2,$3,$4,$5,$11;else print $1,$2,$3,$4,$5,0}'| \
    sort -k 4,4V -k 5,5V |uniq >$outdir/${sample}_mm10_L1Md_A_CDS.scNanoseq_cuttag.bed

done



