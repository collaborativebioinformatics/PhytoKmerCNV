![image](https://github.com/collaborativebioinformatics/SVHack_Plants/assets/30478823/d77cf90a-bd17-44a8-8fc8-ea0ee9ea632b)


# PhytoKmerCNV: Assembly-free gene copy number estimates from whole genome sequencing reads using K-mers

This project is a product of the 2023 Pan-Structural Variation Hackathon in the Cloud that took place from 8/30-9/1/2023 hosted by [Baylor College of Medicine](https://www.bcm.edu) and sponsored by [DNAnexus](https://www.dnanexus.com) and [PacBio](https://www.pacb.com). 

## Team
![image](https://github.com/collaborativebioinformatics/SVHack_Plants/assets/30478823/15585c2b-4060-45ad-94ec-a8c7f6adefb9)

## Background
Copy number variation (CNV) is a common form of structural variant polymorphism in which segments of DNA are duplicated or deleted compared to a reference genome [1](https://www.nature.com/articles/nature05329#Sec4). CNV is an important factor in genome evolution [2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2989995/) and has been linked to phenotypic variation [3](https://www.science.org/doi/10.1126/science.83.2148.210) as well as to human disease [4](https://link.springer.com/article/10.1007/s40484-018-0137-6). Methods to detect CNV using whole-genome sequencing have typically used coverage-based approaches wherein reads are mapped to a reference genome assembly and CNV detected as deviations in coverage over a genomic region compared to the background [5](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-14-S11-S1). However, these coverage-based approaches are subject to ascertainment bias as they can only detect CNV of sequences present in the reference assembly and thus are unable to fully capture the spectrum of CNV within a population. Additionally, the coverage-based methods to detect CNV are dependent on a genome assembly, which is not available for non-model systems.  
  
Here we present PhytoKmerCNV, an alternative approach for producing copy number estimates of sequences of interest from K-mer abundances in whole-genome sequencing reads. The approach is based on comparing the K-mer frequency distributions between reads likely originating to sequences of interest to the respective distribution for the whole sample. As a use case, we have developed our tool with the objective of estimating the copy number of R genes in a collection of resequenced tomato genomes. R genes (also called NBS-LRR proteins) are disease resistance genes in plants that are characterized by having both a nucleotide binding (NBS) and leucine-rich repeat (LRR) domains [6](https://genomebiology.biomedcentral.com/articles/10.1186/gb-2006-7-4-212). R genes are rapid evolving, with copy number variation observed both between and within plant species [7](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC152331/), [8](https://www.pnas.org/doi/10.1073/pnas.1318211110).  

Our method demonstrates great promise as a reference-free approach for genotyping copy number variation (CNV) using whole-genome sequencing (WGS) reads. It fills a critical niche by offering a valuable tool for analyzing genomes that have not been extensively resequenced, particularly non-model systems with limited genomic resources. Moreover, its ploidy-agnostic nature makes it adaptable to genomes with varying levels of ploidy.

## Pipeline
![PhytoKmerCNV drawio](https://github.com/collaborativebioinformatics/SVHack_Plants/assets/30478823/100a3e16-ef06-4f4b-b929-bc9a32f2997d)

The pipeline takes as input whole-genome sequencing reads. The reads are first adapter and quality trimmed before being converted to FASTA format. The FASTA formatted reads are then queried to a database of NBS-LRR proteins to identify reads likely containing sequences from genes of this family (hereafter captured reads). K-mers are then counted in both the captured reads as well as the full sample and the distributions are then used to produce copy number estimates. 

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

## Future work
* get the pipeline working!
* test the pipeline using the tomato data
* test and tune various parameters to improve CNVs
* apply the tool to other systems!!! :)  

Next Steps: Moving forward, several promising next steps are on the horizon.

- Expansion to Other Plant Species: Extending the application of PhytoKmerCNV to a broader range of plant species, especially those with unique genomic characteristics, will enhance its utility in diverse research contexts.

- Integration of Phenotypic Data: Incorporating phenotypic data alongside CNV analysis can uncover genotype-phenotype relationships, shedding light on the functional significance of CNVs, particularly in the context of disease resistance and other traits.

- User-Friendly Interface: Developing a user-friendly interface and detailed documentation will make the tool more accessible to researchers with varying levels of computational expertise.

- Community Collaboration: Encouraging collaboration and feedback from the research community will foster improvements and adaptations of PhytoKmerCNV to meet evolving research needs.

## Acknowledgements
We thank the participants of the 2023 hackathon for ideas and inspiration that greatly improved our work. We also thank Ben Busby and Fritz Sedlazeck for running the hackathon and securing funding and compute resources. 
