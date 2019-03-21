#  Copyright 2019 Barcelona Supercomputing Center
#  
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#      http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

  
#!/bin/sh
NUCLDYN=/home/NucleosomeDynamics/NuclDyn
DATADIR=/data_dir
PUBLICDIR=/public_dir
#running readBAM (bin)
/usr/bin/Rscript $NUCLDYN/bin/readBAM.R --input $DATADIR/input/cellcycleG2_chrII.bam --output $DATADIR/cellcycleG2_chrII.RData --type paired 
#==============================================================
#running readBAM (bin)
/usr/bin/Rscript $NUCLDYN/bin/readBAM.R --input $DATADIR/input/cellcycleM_chrII.bam --output $DATADIR/cellcycleM_chrII.RData --type paired
#==============================================================
#running nucleR (bin)
/usr/bin/Rscript $NUCLDYN/bin/nucleR.R --input $DATADIR/cellcycleG2_chrII.RData --output $DATADIR/NR_cellcycleG2_chrII.gff --type paired --width 147 --minoverlap 80 --dyad_length 50 --thresholdPercentage 35 --hthresh 0.4 --wthresh 0.6 --pcKeepComp 0.02
#==============================================================
#running nucleR (bin)
/usr/bin/Rscript $NUCLDYN/bin/nucleR.R --input $DATADIR/cellcycleM_chrII.RData --output $DATADIR/NR_cellcycleM_chrII.gff --type paired --width 147 --minoverlap 80 --dyad_length 50 --thresholdPercentage 35 --hthresh 0.4 --wthresh 0.6 --pcKeepComp 0.02
#==============================================================
#running nucleR (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/nucleR.R --input $DATADIR/NR_cellcycleG2_chrII.gff --out_genes $DATADIR/NR_cellcycleG2_chrII_genes_stats.csv --out_gw $DATADIR/NR_cellcycleG2_chrII_stats.csv --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff
#==============================================================
#running nucleR (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/nucleR.R --input $DATADIR/NR_cellcycleM_chrII.gff --out_genes $DATADIR/NR_cellcycleM_chrII_genes_stats.csv --out_gw $DATADIR/NR_cellcycleM_chrII_stats.csv --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff
#==============================================================
#running NFR (bin)
/usr/bin/Rscript $NUCLDYN/bin/NFR.R --input $DATADIR/NR_cellcycleG2_chrII.gff --output $DATADIR/NFR_cellcycleG2_chrII.gff --minwidth 110 --threshold 400
#==============================================================
#running NFR (bin)
/usr/bin/Rscript $NUCLDYN/bin/NFR.R --input $DATADIR/NR_cellcycleM_chrII.gff --output $DATADIR/NFR_cellcycleM_chrII.gff --minwidth 110 --threshold 400
#==============================================================
#running NFR (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/NFR.R --input $DATADIR/NFR_cellcycleG2_chrII.gff --out_gw $DATADIR/NFR_cellcycleG2_chrII_stats.csv --genome $PUBLICDIR/refGenomes//R64-1-1/genes.gff
#==============================================================
#running NFR (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/NFR.R --input $DATADIR/NFR_cellcycleM_chrII.gff --out_gw $DATADIR/NFR_cellcycleM_chrII_stats.csv --genome $PUBLICDIR/refGenomes//R64-1-1/genes.gff
#==============================================================
#running txstart (bin)
/usr/bin/Rscript $NUCLDYN/bin/txstart.R --calls $DATADIR/NR_cellcycleG2_chrII.gff --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff --output $DATADIR/TSS_cellcycleG2_chrII.gff --window 300 --open_thresh 215
#==============================================================
#running txstart (bin)
/usr/bin/Rscript $NUCLDYN/bin/txstart.R --calls $DATADIR/NR_cellcycleM_chrII.gff --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff --output $DATADIR/TSS_cellcycleM_chrII.gff --window 300 --open_thresh 215
#==============================================================
#running txstart (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/txstart.R --input $DATADIR/TSS_cellcycleG2_chrII.gff --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff --out_genes $DATADIR/TSS_cellcycleG2_chrII_genes_stats.csv --out_gw $DATADIR/TSS_cellcycleG2_chrII_stats1.png --out_gw2 $DATADIR/TSS_cellcycleG2_chrII_stats2.png
#==============================================================
#running txstart (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/txstart.R --input $DATADIR/TSS_cellcycleM_chrII.gff --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff --out_genes $DATADIR/TSS_cellcycleM_chrII_genes_stats.csv --out_gw $DATADIR/TSS_cellcycleM_chrII_stats1.png --out_gw2 $DATADIR/TSS_cellcycleM_chrII_stats2.png
#==============================================================
#running periodicity (bin)
/usr/bin/Rscript $NUCLDYN/bin/periodicity.R --calls $DATADIR/NR_cellcycleG2_chrII.gff --reads $DATADIR/cellcycleG2_chrII.RData --type paired --gffOutput $DATADIR/P_cellcycleG2_chrII.gff --bwOutput $DATADIR/P_cellcycleG2_chrII.bw --genes $PUBLICDIR/refGenomes//R64-1-1/genes.gff --chrom_sizes $PUBLICDIR/refGenomes/R64-1-1/R64-1-1.fa.chrom.sizes --periodicity 165
#==============================================================
#running periodicity (bin)
/usr/bin/Rscript $NUCLDYN/bin/periodicity.R --calls $DATADIR/NR_cellcycleM_chrII.gff --reads $DATADIR/cellcycleM_chrII.RData --type paired --gffOutput $DATADIR/P_cellcycleM_chrII.gff --bwOutput $DATADIR/P_cellcycleM_chrII.bw --genes $PUBLICDIR/refGenomes//R64-1-1/genes.gff --chrom_sizes $PUBLICDIR/refGenomes/R64-1-1/R64-1-1.fa.chrom.sizes --periodicity 165
#==============================================================
#running periodicity (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/periodicity.R --input $DATADIR/P_cellcycleG2_chrII.gff --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff --out_genes $DATADIR/P_cellcycleG2_chrII_genes_stats.csv --out_gw $DATADIR/P_cellcycleG2_chrII_stats.csv
#==============================================================
#running periodicity (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/periodicity.R --input $DATADIR/P_cellcycleM_chrII.gff --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff --out_genes $DATADIR/P_cellcycleM_chrII_genes_stats.csv --out_gw $DATADIR/P_cellcycleM_chrII_stats.csv
#==============================================================
#running gausfitting (bin)
/usr/bin/Rscript $NUCLDYN/bin/gausfitting.R --calls $DATADIR/NR_cellcycleG2_chrII.gff --reads $DATADIR/cellcycleG2_chrII.RData --output $DATADIR/STF_cellcycleG2_chrII.gff --range All
#==============================================================
#running gausfitting (bin)
/usr/bin/Rscript $NUCLDYN/bin/gausfitting.R --calls $DATADIR/NR_cellcycleM_chrII.gff --reads $DATADIR/cellcycleM_chrII.RData --output $DATADIR/STF_cellcycleM_chrII.gff --range All
#==============================================================
#running gausfitting (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/gausfitting.R --input $DATADIR/STF_cellcycleG2_chrII.gff --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff --out_genes $DATADIR/STF_cellcycleG2_chrII_genes_stats.csv --out_gw $DATADIR/STF_cellcycleG2_chrII_stats1.csv --out_gw2 $DATADIR/STF_cellcycleG2_chrII_stats2.png
#==============================================================
#running gausfitting (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/gausfitting.R --input $DATADIR/STF_cellcycleM_chrII.gff --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff --out_genes $DATADIR/STF_cellcycleM_chrII_genes_stats.csv --out_gw $DATADIR/STF_cellcycleM_chrII_stats1.csv --out_gw2 $DATADIR/STF_cellcycleM_chrII_stats2.png
#==============================================================
#running nucDyn (bin)
/usr/bin/Rscript $NUCLDYN/bin/nucDyn.R --input1 $DATADIR/cellcycleG2_chrII.RData --input2 $DATADIR/cellcycleM_chrII.RData --outputGff $DATADIR/ND_cellcycleG2_chrII_cellcycleM_chrII.gff --outputBigWig $DATADIR/ND_cellcycleG2_chrII_cellcycleM_chrII.bw --plotRData $DATADIR/ND_cellcycleG2_chrII_cellcycleM_chrII_plot.RData --genome $PUBLICDIR/refGenomes/R64-1-1/R64-1-1.fa.chrom.sizes --range All --maxDiff 70 --maxLen 140 --shift_min_nreads 3 --shift_threshold 0.1 --indel_min_nreads 3 --indel_threshold 0.05
#==============================================================
#running nucDyn (statistics)
/usr/bin/Rscript $NUCLDYN/statistics/nucDyn.R --input $DATADIR/ND_cellcycleG2_chrII_cellcycleM_chrII.gff --genome $PUBLICDIR/refGenomes/R64-1-1/genes.gff --out_genes $DATADIR/ND_cellcycleG2_chrII_cellcycleM_chrII_genes_stats.csv --out_gw $DATADIR/ND_cellcycleG2_chrII_cellcycleM_chrII_stats.png
#==============================================================
