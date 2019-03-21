Nucleosome Dynamics - docker implementation
===================
Nucleosome Dynamics docker image is a containerized implementation of 'Nucleosome Dynamics suite' particularly developed for use with the [Galaxy platform](https://dev.usegalaxy.es/).

#### Nucleosome Dynamics
Nucleosome Dynamics is a suite of R programs for **nucleosome-related analyses** based on MNase-seq experimental data. The toolkit includes the following analyses:

- nucleR: define and classify the location of nucleosomes from MNase-seq data.
- Nucleosome Dynamics: compares different MNase-seq experiments identifying variations in nucleosomes location.
- NFR: locate nucleosome-free regions
- Periodicity: predicts  nucleosome phasing at gene level
- TSS: classify transcription start sites based on the surrounding nucleosomes
- Stiffness: computes nucleosome stiffness derived from a Gaussian function fitting

| Landing page | http://mmb.irbbarcelona.org/NucleosomeDynamics| 
| ------------ |----------------------------------------------|

#### Container software 
This docker image extends and distributes the following rellevant software:

* R libraries:
   * NucleR R library: https://bioconductor.org/packages/release/bioc/html/nucleR.html
   * Nucleosome Dynamics R library: http://mmb.pcb.ub.es/gitlab/NuclDynamics/NucleosomeDynamics_core
* R programs:
   * Nucleosome Dynamics analyses: http://mmb.pcb.ub.es/gitlab/NuclDynamics/nucleServ

# Build the image
The docker image for Nucleosome Dynamics can be found in the [docker hub](https://hub.docker.com/r/mmbirb/nucldyn) as `mmbirb/nucldyn`. However, this repository contains the data to manually rebuild it by running **docker build**.

```sh
docker build -t nucldyn .
```
> Note that the current working directory must contain the Dockerfile file.

# Running the Container
You can either run the container manually, or via the web-based [Galaxy platform](https://dev.usegalaxy.es/). For both cases, individual nucleosome-related analyses are offered as individual tools, as well as part of a greater workflow.

> Install [docker](https://docs.docker.com/engine/installation/) for your system, if not previously done.

### Running an analysis
You can run manually your containers using the following command:

```sh
docker run -v /path/to/data_dir/:/path/to/data_dir mmbirb/nucldyn  [analysis] [analysis_options]
```

In case you do not have the container stored locally, docker will download it for you. Once the execution is finished, the container will exit.

A short description of the parameters would be:
- `docker run` will run the container for you.
- `-v /path/to/data_dir/:/path/to/data_dir` will make the `data_dir` where input files are stored available to the container
- `mmbirb/nucldyn
` is the image name, which can be found in the [docker hub](https://dev.usegalaxy.es/).
- `[analysis] [analysis_options]` correspond to the analysis type you want to run and its paremeters.

Available analysis are:

| `[analysis]` | Description |
| -------- | -------- |
| readBAM	  | Read Aligned MSase-seq BAM into a RData structure (required for further process) |
| nucleR	   | Determine the positions of the nucleosomes across the genome |
| NFR		  | Short regions depleted of nucleosomes |
| txstart	  | Classify Transciption start accordint to the properties of surrounding nucleosomes	|
| periodicity  | Periodic properties of nucleosomes inside gene bodies |
| stiffness | Aparent stiffness constant foreach nucleosome obtained by fitting the coverage to a gaussian distribution |
| nucleR_stats|	 Nucleosome call statistics|
| nucDyn          | Comparison of two diferent MNase-seq experiments to nucleosome architecture local changes |
| NFR_stats|		 Nucleosome Free Regions statistics|
| txstart_stats|	 TSS and TTS statistics|
| periodicity_stats|  Statistics on Nucleosome periodicity|
| stiffness_stats|	Statistics on stiffness|
| nucDyn_stats|	   Statistics on Nucleosome Dynamics analysis|


Each analysis has its own input files and arguments. `docker run mmbirb/nucldyn [analysis] --help` will display such information in detail. Bellow, a summary of these options is described.

#### Usage

**readBAM** --input {bam} --output {RData} --type (single|paired)

	--input
		Sequence file in BAM format
	--output
		RData structure
	--type
		Type of sequence data: single|paired

**nucleR** --input {RData} --output {gff} --type (single|PAIRED) --width {int} --minoverlap {int}
[--dyad_length {int} --thresholdPercentage {double} --hthresh {double} --wthresh {double} --pcKeepComp {double} --fdrOverAmp {double} --components {int} --fragmentLen {int} --trim {int} --threshold {logical} --thresholdValue {int} --chr STR --start {int} --end {int} ]

	--input: 
		Input BAM file (RData format)
	--output:
		Nucleosome calls in GFF format. Annotations: Score_weight (0-1), Score_height (0-1), class (W, F, uncertain)
	--type
		Type of sequence data: single|paired
	--width: 
		Width given to nucleosome calls previous to merging (bp). 
	--minoverlap: 
		Minimum number of overlapping base pairs in two nucleosome calls for them to be merged into one (bp).
	--dyad_length: 
		Length of the reads that should be used for the nucleosome calling to define the dyad of the nucleosomes, keeping that number of bases around the center of   each fragment (bp). Optional. Default 50 bp.
	--hthresh: 
		Height threshold (between 0 and 1) to classify (in combination with width threshold) a nucleosome as either fuzzy or well-positioned according to the number of reads in the dyad of the nucleosome call. Nucleosomes below this value will be defined as fuzzy. Optional, default 0.4.
	--wthresh: 
		Width threshold (between 0 and 1) to classify (in combination with height threshold) a nucleosome as either fuzzy or well-positioned according to the disperion of the reads around the dyad. Nucleosomes below this value (that is, nucleosome calls not sharp enough) will be defined as fuzzy. Optional, default 0.4
	--pcKeepComp
		Parameter used in the coverage smoothing when Fourier transformation is applied. Number of components to select with respect to the total size of the sample. Allowed values are numeric (in range 0:1) for manual setting, or auto for automatic detection. Optional, default 0.02.
	--fdrOverAmp
		Optional, default 0.05. 
	--components
		Optional, default 1.
	--fragmentLen
		Fragment Length (bp). Optional, default 170.
	--trim
		Optional, default 50
	--threshold
		 Threshold to filter out which nucleosome calls are reported as significant enough. It can be supplied as either an absolute value (--thresholdValue) or as a relative value expressed as a percentage (--thresholdPercentage). If set to TRUE, the percentage value is considered. If set to FALSE, the absolute value does. Optional, default TRUE.
	--thresholdValue
		 Absolute value to filter out nucleosome calls. It is the minimum number of reads (coverage) in a nucleosome call expressed as reads per million of mapped reads. Optional, default 10.
	--thresholdPercentage: 
		Percentile of coverage in the experiment used as threshold to filter out nucleosome calls (i.e., '25%' would mean that only peaks with coverage in the 1st quantile would be considered). Optional, default 35(%)
	--chr
		Chromosome to consider for the analysis in the given input file. By default, all the genomic range is considered. Optional.
	--start
		Start genomic position to consider for the analysis in the given input file. By default, all the genomic range is considered. Optional.
	--end
		End genomic position to consider for the analysis in the given input file. By default, all the genomic range is considered. Optional.


**NFR**  --input {gff} --output {gff} [--minwidth {int} --threshold {int}  ]

	--input 
		Nucleosome calls in GFF format as obtained from NucleR
	--output {gff} 
		Nucleosome Free Regions in GFF format
	--minwidth [int, 110] 
		Minimum length (bp). Optional, default 110bp
	--threshold [int, 140]
		Maximum length (bp). Optional, default 140bp

**txstart**   ---calls {gff} --genome {gff} --output {gff}
[--window {int} --open_thresh {int}  --cores {int} --p1.max.merge {int} --p1.max.downstream {int} --max.uncovered {int} ]


	--calls
		Nucleosome calls as obtained form NucleR. GFF format
	--genome
		Gene positions from the reference genome. GFF Format
	--output
		Classification of TSS according to nucleosome types,  in GFF format
	--window 
		Number of nucleotides on each side of the TSS where -1 and +1 nucleosomes are searched for. Default 300
	--open_thresh
		Distance between nucleosomes -1 and +1 to discriminate between 'open' and 'close' classes. Default 215
	--cores
		Number of computer threads. Optional, default 1
	--p1.max.merge
		Optional, default 3
	--p1.max.downstream
		Optional, default 20
	--max.uncovered
		Optional, datault 150

**periodicity** --calls {gff} --reads {RData} --type (single|paired) --gffOutput {gff} --bwOutput {bw} --genes {gff} --chrom_sizes {chrom.sizes}
[--periodicity {int} --cores {int} ]

	--calls
		Nucleosome calls in GFF format as obtained from NucleR
	--reads
		Sequence Reads in RData format as obtained from readBAM
	--type 
		Type of reads (Single|paired)
	--gffOutput
		Periodicity output in GFF format
	--bwOutput
		Periodicity output in BigWig format
	--genes
		Position of genes in reference genome,in GFF format
	--chrom_sizes
		Chromosome sizes file in the reference genome
	--periodicity
		Average distance between two consecutive nucleosomes. It is used as the period of the nucleosome coverage signal. Optional, default 165
	--cores
		Number of computer threads. Optional, default 1

**stiffness** --calls {gff} --reads {RData} --output {gff} --range {str}  [--t {double}] ]

	--calls
		Nucleosome calls in GFF format as obtained from NucleR
	--reads
		Sequence data in RData format as obtained from readBAM
	--output
	 	Output stiffness in GFF format
	--range
	 	Genomic range to consider. Format: [str, All|chr|chr:start-end]  whre 'All' is all chromosomes, 'chr' is a single chomosome, and 'chr:start-end' is the  range indicated by the coordinates. Default All
	--t
		Temperature (K). Optional, default 310.15

**nucDyn**  --input1 {RData} --input2 {RData} --calls1 {gff} --calls2 {gff} --outputGff {gff} --outputBigWig {bw}  --genome {chrom.sizes} --range {str}
[ --plotRData {RData} --maxDiff {int} --maxLen {int} --shift_min_nreads {int} --shift_threshold {double} --indel_min_nreads {int} --indel_threshold {double} --cores {int} --equal_size (logical) --readSize {int} --roundPow [logical] --same_magnitude [logical] ]

	-- input1, --input2
		Input BAM from MNase-seq in RData format (from readBAM)
	--calls1, --calls2
		Nucleosome calls in GFF format as obtained from NucleR
	-outputGff
		Output of NucleosomeDynamics in GFF format
	--outputBigWig {bw}
		Output of NucleosomeDynamics in BigWig format: -log10 of the p-value of the significance of the differences found.
	--genome {chrom.sizes}
		Chromosome sizes from reference Genome
	--range (All|chr|chr:start-end)
	 	Genomic range to be analyzed. All: all chromosomes; chr: a Whole chromosome; chr:start-end: a specific region given the coordinates. Default All
	--plotRData {RData}
	
	--maxDiff
		Maximum distance between the centers of two fragments for them to be paired as shifts. (bp) Optional,default 70bp
	--maxLen
		This value is used in a preliminar filtering. Fragments longer than this will be filtered out, since they are likely the result of MNase under-digestion and represent two or more nucleosomes. (bp) Optional, default 140bp
	--shift_min_nreads
		Minimum number of shifted reads for a shift hostspot to be reported {int}, optional, default 3
	--shift_threshold
		Threshold applied to the shift hostpots. Only hotspots with a score better than the value will be reported. Notice the score has to be lower than the threshold, since these numbers represent p-values. Optional, default 0.1
	--indel_min_nreads
		Minimum number of shifted reads for an indel hostspot to be reported {int}, optional, default 3
	--indel_threshold [float, 0.05]
		Threshold applied to the indel hostpots. Only hotspots with a score better than the value will be reported. Notice the score has to be lower than the threshold, since these numbers represent p-values. Optional, default 0.05
	--cores [int, 1]
		Number of computer threads. Optional, default 1
	--equal_size
		Set all fragments to the same size. Optional, default FALSE
	--readSize [int, 140]
	
	--roundPow [logical]
	
	--same_magnitude [logical]


**nucleR_stats** --input {gff} --genome {gff} --out_genes {csv} --out_gw {csv}

	 --input
		Nucleosome calls in GFF format as obtained from NucleR
	--genome
		Gene positions from the reference genome. GFF Format
	--out_genes
	
	--out_gw

**NFR_stats** --input {gff}  --genome {gff} --out_gw {csv}
	--input
		Nucleosome calls in GFF format as obtained from NFR
	--genome 
		Gene positions from the reference genome. GFF Format
	--out_gw 
		Output NFR stats in CSV format

**txstart_stats** --input {gff} --genome {gff} --out_genes {csv} --out_gw {png} --out_gw2 {png}

	--input 
		Nucleosome calls in GFF format as obtained from txstart
	--genome
		Gene positions from the reference genome. GFF Format
	--out_genes
		Output txstart_stats in CSV format
	--out_gw

	--out_gw2
	

**periodicity_stats** --input {gff} --genome {gff} --out_genes {csv} --out_gw {csv}

	--input 
		Nucleosome calls in GFF format as obtained from periodicity
	--genome
		Gene positions from the reference genome. GFF Format
	--out_genes
			
	--out_gw

**stiffness_stats** -input {gff} --genome {gff} --out_genes {csv} --out_gw {csv} --out_gw2 {png}

	--input 
		Nucleosome calls in GFF format as obtained from stiffness_stats
	--genome
		Gene positions from the reference genome. GFF Format
	--out_genes
		Output stiffness_stats in CSV format
	--out_gw
	
	--out_gw2
	

**nucDyn_stats** --input {gff} --genome {gff} --out_genes {csv} --out_gw {png}

	--input 
		Nucleosome calls in GFF format as obtained from stiffness_stats
	--genome
		Gene positions from the reference genome. GFF Format
	--out_genes
		Output stiffness_stats in CSV format
	--out_gw




#### Example

TDB 

```sh
docker run -v $PWD/test/data/:$PWD/test/data mmbirb/nucldyn readBAM --input $PWD/test/data/cellcycleG2_chrII.bam --output $PWD/test/data/cellcycleG2_chrII.RData --type paired
```


# Running a workflow script
You can combine different analysis tools to build your own workflow. Galaxy platform allows... 
TDB 
