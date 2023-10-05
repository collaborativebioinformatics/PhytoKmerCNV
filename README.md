![image](https://github.com/collaborativebioinformatics/SVHack_Plants/assets/30478823/d77cf90a-bd17-44a8-8fc8-ea0ee9ea632b)

# PhytoKmerCNV: Assembly-free gene copy number estimates from whole genome sequencing reads using K-mers

This project is a product of the 2023 Pan-Structural Variation Hackathon in the Cloud that took place from 8/30-9/1/2023 hosted by [Baylor College of Medicine](https://www.bcm.edu) and sponsored by [DNAnexus](https://www.dnanexus.com) and [PacBio](https://www.pacb.com). Software is provided "as is", without warranty of any kind. 

## Team
![image](https://github.com/collaborativebioinformatics/SVHack_Plants/assets/30478823/15585c2b-4060-45ad-94ec-a8c7f6adefb9)

## Background
Copy number variation (CNV) is a common form of structural variant polymorphism in which segments of DNA are duplicated or deleted compared to a reference genome [[1]](https://www.nature.com/articles/nature05329#Sec4). CNV is an important factor in genome evolution [[2]](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2989995/) and has been linked to phenotypic variation [[3]](https://www.science.org/doi/10.1126/science.83.2148.210) as well as to human disease [[4]](https://link.springer.com/article/10.1007/s40484-018-0137-6). Methods to detect CNV using whole-genome sequencing have typically used coverage-based approaches wherein reads are mapped to a reference genome assembly and CNV detected as deviations in coverage over a genomic region compared to the background [[5]](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-14-S11-S1). However, these coverage-based approaches are subject to ascertainment bias as they can only detect CNV of sequences present in the reference assembly and thus are unable to fully capture the spectrum of CNV within a population. Additionally, the coverage-based methods to detect CNV are dependent on a genome assembly, which is not available for non-model systems.  
  
Here we present PhytoKmerCNV, an alternative approach for producing copy number estimates of sequences of interest from K-mer abundances in whole-genome sequencing reads. The approach is based on comparing the K-mer frequency distributions between reads likely originating to sequences of interest to the respective distribution for the whole sample. As a use case, we have developed our tool with the objective of estimating the copy number of R genes in a collection of resequenced tomato genomes [[6]](https://www.nature.com/articles/s41586-022-04808-9#MOESM2). R genes (also called NBS-LRR proteins) are disease resistance genes in plants that are characterized by having both a nucleotide binding (NBS) and leucine-rich repeat (LRR) domains [[7]](https://genomebiology.biomedcentral.com/articles/10.1186/gb-2006-7-4-212). R genes are rapid evolving, with copy number variation observed both between and within plant species [[9]](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC152331/), [[9]](https://www.pnas.org/doi/10.1073/pnas.1318211110).  

Our method demonstrates great promise as a reference-free approach for genotyping copy number variation (CNV) using whole-genome sequencing (WGS) reads. It fills a critical niche by offering a valuable tool for analyzing genomes that have not been extensively resequenced, particularly non-model systems with limited genomic resources. Moreover, its ploidy-agnostic nature makes it adaptable to genomes with varying levels of ploidy.

## Pipeline Overview
![PhytoKmerCNV drawio](https://github.com/collaborativebioinformatics/SVHack_Plants/assets/30478823/100a3e16-ef06-4f4b-b929-bc9a32f2997d)

The pipeline takes as input whole-genome sequencing reads. The reads are first adapter and quality trimmed before being converted to FASTA format. The FASTA formatted reads are then queried to a database of NBS-LRR proteins to identify reads likely containing sequences from genes of this family (hereafter captured reads). K-mers are then counted in both the captured reads as well as the full sample and the distributions are then used to produce copy number estimates. As a first test we calculated the sum of 21-mers in captured reads and compared this value to the sum of 21-mers in the full readset. As a "truth set" we compared the R gene copy number estimates to the number of genes annotated with NBS-LRR domain in each genome (see hmmscan.sh).   

## DNAnexus Setup
The pipeline was designed to run on the DNAnexus platform but can be deployed on any Linux machine. Software dependencies are handled using conda. Here's how to set up the pipeline on DNAnexus:
* Start an analysis with the `tty` image
* git clone this repository and cd into the checked out repository
* Set up the compute environment by executing `scripts/setup_environment.sh`. This creates the conda environment `plantkmer` that installs all required software.
* Re-read the bash config file: `source ~/.bashrc`
* Activate the project environment using `conda activate plantkmer`
* The data in the DNAnexus environment is available in `/mnt/project/`

## Software Usage

The main pipeline script is `scripts/PhytoKmerCNV.sh`. The software in `requirements.yml` must be available for the pipeline to run, see above for setting up a suitable conda enviroment.

```
PhytoKmerCNV.sh -i <input-fastq> [-t <threads>]

Parameters:
-i input FASTQ file (mandatory)
-t number of threads (optional, default 1)
```

## Practical Use Cases
These practical use cases illustrate the versatility of PhytoKmerCNV for CNV analysis in plant genomes. Researchers can adapt the tool to address a wide range of research questions, from investigating genetic diversity to understanding the functional implications of CNVs in plant biology. The provided examples of input and output files, along with explanations of parameters, facilitate its application in diverse research contexts.

### Use Case 1: Comparative Analysis of NBS-LRR CNV Across Plant Species
Objective: Compare CNV patterns of NBS-LRR genes across multiple plant species.

* Input:
  * Sequencing Reads (FASTA): Raw sequencing reads from various plant species, including tomato, potato, and eggplant (e.g., "tomato_genome.fasta," "potato_genome.fasta," "eggplant_genome.fasta").
* Parameters:
  * Reference K-mers (FASTA): K-mers representing known NBS-LRR genes in tomato (e.g., "tomato_NBS_LRR_kmers.fasta").
  * Species Annotations (GFF3): Genome annotations for each species, specifying gene locations (e.g., "tomato_annotations.gff3," "potato_annotations.gff3," "eggplant_annotations.gff3").
* Output:
  * CNV Comparison (CSV): A comparative table summarizing CNV estimates for NBS-LRR genes in each species, highlighting variations and conserved patterns (e.g., "NBS_LRR_CNV_comparison.csv").

### Use Case 2: Assessing Copy Number Variation in Non-Model Plant Genomes
Objective: Estimate CNV in a non-model plant genome lacking extensive resequencing data.

* Input:
  * Sequencing Reads (FASTA): Raw sequencing reads from 32 individual genomes of a non-model plant species (e.g., "speciesA_genome1.fasta," "speciesA_genome2.fasta," etc.).
* Parameters:
  * Reference K-mers (FASTA): A set of K-mers representing known NBS-LRR genes in the plant species of interest (e.g., "NBS_LRR_kmers.fasta").
* Output:
  * CNV Estimates (CSV): A table providing CNV estimates for NBS-LRR genes in each genome, including gene identifiers and inferred copy numbers (e.g., "CNV_estimates_speciesA.csv").

### Use Case 3: Low-Pass Sequencing for CNV Analysis
Objective: Assess CNV using low-pass sequencing data to reduce costs.

* Input:
  * Sequencing Reads (FASTA): Low-pass sequencing reads from a set of 20 genomes (e.g., "low_pass_genomes.fasta").
* Parameters:
  * Reference K-mers (FASTA): K-mers representing known NBS-LRR genes in the target species (e.g., "target_species_NBS_LRR_kmers.fasta").
* Output:
  * CNV Estimates (CSV): A table providing CNV estimates for NBS-LRR genes using the cost-effective low-pass sequencing approach (e.g., "CNV_estimates_low_pass_genomes.csv").


## Future Work

Over the next week: 
* get the pipeline working!
* test the pipeline using the tomato data
* test and tune various parameters to improve CNVs
* apply the tool to other systems!!! :)  

Over the next year: Moving forward, several promising next steps are on the horizon.

- Expansion to Other Plant Species: Extending the application of PhytoKmerCNV to a broader range of plant species, especially those with unique genomic characteristics, will enhance its utility in diverse research contexts.

- Integration of Phenotypic Data: Incorporating phenotypic data alongside CNV analysis can uncover genotype-phenotype relationships, shedding light on the functional significance of CNVs, particularly in the context of disease resistance and other traits.

- User-Friendly Interface: Developing a user-friendly interface and detailed documentation will make the tool more accessible to researchers with varying levels of computational expertise.

- Community Collaboration: Encouraging collaboration and feedback from the research community will foster improvements and adaptations of PhytoKmerCNV to meet evolving research needs.

## Acknowledgements
We thank the participants of the 2023 hackathon for ideas and inspiration that greatly improved our work. We also thank Ben Busby and Fritz Sedlazeck for running the hackathon and securing funding and compute resources. 
