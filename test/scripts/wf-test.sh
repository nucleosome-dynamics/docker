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

### OR SET CONTAINER PATHS
#NUCLDYN=/home/NucleosomeDynamics/NuclDyn # NucDyn installation path inside container - Do not change
#VOLUME=/test  # Path to your data as mounted inside container, i.e, -v [/local/path/data]:[VOLUME]

#### OR SET LOCAL PATHS
SCRIPTS_DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
NUCLDYN=$SCRIPTS_DIR/../../NucleosomeDynamics # NucDyn installation path
VOLUME=$SCRIPTS_DIR/.. # Test data dir

echo '#running readBAM (bin)'
/usr/bin/Rscript $NUCLDYN/bin/readBAM.R --input $VOLUME/data/cellcycleG2_chrII.bam --output $VOLUME/data/outputs/cellcycleG2_chrII.RData --type paired 
echo '#=============================================================='

echo '#running readBAM (bin)'
/usr/bin/Rscript $NUCLDYN/bin/readBAM.R --input $VOLUME/data/cellcycleM_chrII.bam --output $VOLUME/data/outputs/cellcycleM_chrII.RData --type paired
echo '#=============================================================='

echo '#running nucleR (bin)'
/usr/bin/Rscript $NUCLDYN/bin/nucleR.R --input $VOLUME/data/outputs/cellcycleG2_chrII.RData --output $VOLUME/data/outputs/NR_cellcycleG2_chrII.gff --type paired --width 147 --minoverlap 80 --dyad_length 50 --thresholdPercentage 35 --hthresh 0.4 --wthresh 0.6 --pcKeepComp 0.02
echo '#=============================================================='
echo '#running nucleR (bin)'
/usr/bin/Rscript $NUCLDYN/bin/nucleR.R --input $VOLUME/data/outputs/cellcycleM_chrII.RData --output $VOLUME/data/outputs/NR_cellcycleM_chrII.gff --type paired --width 147 --minoverlap 80 --dyad_length 50 --thresholdPercentage 35 --hthresh 0.4 --wthresh 0.6 --pcKeepComp 0.02
echo '#=============================================================='
echo '#running nucleR (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/nucleR.R --input $VOLUME/data/outputs/NR_cellcycleG2_chrII.gff --out_genes $VOLUME/data/outputs/NR_cellcycleG2_chrII_genes_stats.csv --out_gw $VOLUME/data/outputs/NR_cellcycleG2_chrII_stats.csv --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff
echo '#=============================================================='
echo '#running nucleR (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/nucleR.R --input $VOLUME/data/outputs/NR_cellcycleM_chrII.gff --out_genes $VOLUME/data/outputs/NR_cellcycleM_chrII_genes_stats.csv --out_gw $VOLUME/data/outputs/NR_cellcycleM_chrII_stats.csv --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff
echo '#=============================================================='
echo '#running NFR (bin)'
/usr/bin/Rscript $NUCLDYN/bin/NFR.R --input $VOLUME/data/outputs/NR_cellcycleG2_chrII.gff --output $VOLUME/data/outputs/NFR_cellcycleG2_chrII.gff --minwidth 110 --threshold 400
echo '#=============================================================='
echo '#running NFR (bin)'
/usr/bin/Rscript $NUCLDYN/bin/NFR.R --input $VOLUME/data/outputs/NR_cellcycleM_chrII.gff --output $VOLUME/data/outputs/NFR_cellcycleM_chrII.gff --minwidth 110 --threshold 400
echo '#=============================================================='
echo '#running NFR (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/NFR.R --input $VOLUME/data/outputs/NFR_cellcycleG2_chrII.gff --out_gw $VOLUME/data/outputs/NFR_cellcycleG2_chrII_stats.csv --genome $VOLUME/data/refGenomes//R64-1-1/genes.gff
echo '#=============================================================='
echo '#running NFR (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/NFR.R --input $VOLUME/data/outputs/NFR_cellcycleM_chrII.gff --out_gw $VOLUME/data/outputs/NFR_cellcycleM_chrII_stats.csv --genome $VOLUME/data/refGenomes//R64-1-1/genes.gff
echo '#=============================================================='
echo '#running txstart (bin)'
/usr/bin/Rscript $NUCLDYN/bin/txstart.R --calls $VOLUME/data/outputs/NR_cellcycleG2_chrII.gff --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff --output $VOLUME/data/outputs/TSS_cellcycleG2_chrII.gff --window 300 --open_thresh 215
echo '#=============================================================='
echo '#running txstart (bin)'
/usr/bin/Rscript $NUCLDYN/bin/txstart.R --calls $VOLUME/data/outputs/NR_cellcycleM_chrII.gff --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff --output $VOLUME/data/outputs/TSS_cellcycleM_chrII.gff --window 300 --open_thresh 215
echo '#=============================================================='
echo '#running txstart (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/txstart.R --input $VOLUME/data/outputs/TSS_cellcycleG2_chrII.gff --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff --out_genes $VOLUME/data/outputs/TSS_cellcycleG2_chrII_genes_stats.csv --out_gw $VOLUME/data/outputs/TSS_cellcycleG2_chrII_stats1.png --out_gw2 $VOLUME/data/outputs/TSS_cellcycleG2_chrII_stats2.png
echo '#=============================================================='
echo '#running txstart (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/txstart.R --input $VOLUME/data/outputs/TSS_cellcycleM_chrII.gff --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff --out_genes $VOLUME/data/outputs/TSS_cellcycleM_chrII_genes_stats.csv --out_gw $VOLUME/data/outputs/TSS_cellcycleM_chrII_stats1.png --out_gw2 $VOLUME/data/outputs/TSS_cellcycleM_chrII_stats2.png
echo '#=============================================================='
echo '#running periodicity (bin)'
/usr/bin/Rscript $NUCLDYN/bin/periodicity.R --calls $VOLUME/data/outputs/NR_cellcycleG2_chrII.gff --reads $VOLUME/data/outputs/cellcycleG2_chrII.RData --type paired --gffOutput $VOLUME/data/outputs/P_cellcycleG2_chrII.gff --bwOutput $VOLUME/data/outputs/P_cellcycleG2_chrII.bw --genes $VOLUME/data/refGenomes//R64-1-1/genes.gff --chrom_sizes $VOLUME/data/refGenomes/R64-1-1/R64-1-1.fa.chrom.sizes --periodicity 165
echo '#=============================================================='
echo '#running periodicity (bin)'
/usr/bin/Rscript $NUCLDYN/bin/periodicity.R --calls $VOLUME/data/outputs/NR_cellcycleM_chrII.gff --reads $VOLUME/data/outputs/cellcycleM_chrII.RData --type paired --gffOutput $VOLUME/data/outputs/P_cellcycleM_chrII.gff --bwOutput $VOLUME/data/outputs/P_cellcycleM_chrII.bw --genes $VOLUME/data/refGenomes//R64-1-1/genes.gff --chrom_sizes $VOLUME/data/refGenomes/R64-1-1/R64-1-1.fa.chrom.sizes --periodicity 165
echo '#=============================================================='
echo '#running periodicity (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/periodicity.R --input $VOLUME/data/outputs/P_cellcycleG2_chrII.gff --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff --out_genes $VOLUME/data/outputs/P_cellcycleG2_chrII_genes_stats.csv --out_gw $VOLUME/data/outputs/P_cellcycleG2_chrII_stats.csv
echo '#=============================================================='
echo '#running periodicity (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/periodicity.R --input $VOLUME/data/outputs/P_cellcycleM_chrII.gff --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff --out_genes $VOLUME/data/outputs/P_cellcycleM_chrII_genes_stats.csv --out_gw $VOLUME/data/outputs/P_cellcycleM_chrII_stats.csv
echo '#=============================================================='
echo '#running stiffness (bin)'
/usr/bin/Rscript $NUCLDYN/bin/stiffness.R --calls $VOLUME/data/outputs/NR_cellcycleG2_chrII.gff --reads $VOLUME/data/outputs/cellcycleG2_chrII.RData --output $VOLUME/data/outputs/STF_cellcycleG2_chrII.gff --range All
echo '#=============================================================='
echo '#running stiffness (bin)'
/usr/bin/Rscript $NUCLDYN/bin/stiffness.R --calls $VOLUME/data/outputs/NR_cellcycleM_chrII.gff --reads $VOLUME/data/outputs/cellcycleM_chrII.RData --output $VOLUME/data/outputs/STF_cellcycleM_chrII.gff --range All
echo '#=============================================================='
echo '#running stiffness (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/stiffness.R --input $VOLUME/data/outputs/STF_cellcycleG2_chrII.gff --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff --out_genes $VOLUME/data/outputs/STF_cellcycleG2_chrII_genes_stats.csv --out_gw $VOLUME/data/outputs/STF_cellcycleG2_chrII_stats1.csv --out_gw2 $VOLUME/data/outputs/STF_cellcycleG2_chrII_stats2.png
echo '#=============================================================='
echo '#running stiffness (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/stiffness.R --input $VOLUME/data/outputs/STF_cellcycleM_chrII.gff --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff --out_genes $VOLUME/data/outputs/STF_cellcycleM_chrII_genes_stats.csv --out_gw $VOLUME/data/outputs/STF_cellcycleM_chrII_stats1.csv --out_gw2 $VOLUME/data/outputs/STF_cellcycleM_chrII_stats2.png
echo '#=============================================================='
echo '#running nucDyn (bin)'
/usr/bin/Rscript $NUCLDYN/bin/nucDyn.R --input1 $VOLUME/data/outputs/cellcycleG2_chrII.RData --input2 $VOLUME/data/outputs/cellcycleM_chrII.RData --calls1 $VOLUME/data/outputs/NR_cellcycleG2_chrII.gff --calls2 $VOLUME/data/outputs/NR_cellcycleM_chrII.gff --outputGff $VOLUME/data/outputs/ND_cellcycleG2_chrII_cellcycleM_chrII.gff --outputBigWig $VOLUME/data/outputs/ND_cellcycleG2_chrII_cellcycleM_chrII.bw --plotRData $VOLUME/data/outputs/ND_cellcycleG2_chrII_cellcycleM_chrII_plot.RData --genome $VOLUME/data/refGenomes/R64-1-1/R64-1-1.fa.chrom.sizes --range All --maxDiff 70 --maxLen 140 --shift_min_nreads 3 --shift_threshold 0.1 --indel_min_nreads 3 --indel_threshold 0.05
echo '#=============================================================='
echo '#running nucDyn (statistics)'
/usr/bin/Rscript $NUCLDYN/statistics/nucDyn.R --input $VOLUME/data/outputs/ND_cellcycleG2_chrII_cellcycleM_chrII.gff --genome $VOLUME/data/refGenomes/R64-1-1/genes.gff --out_genes $VOLUME/data/outputs/ND_cellcycleG2_chrII_cellcycleM_chrII_genes_stats.csv --out_gw $VOLUME/data/outputs/ND_cellcycleG2_chrII_cellcycleM_chrII_stats.png
echo '#=============================================================='
