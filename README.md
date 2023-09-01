# SVHack_Plants

## Our 2023 Hackathon Team
![image](https://github.com/collaborativebioinformatics/SVHack_Plants/assets/30478823/15585c2b-4060-45ad-94ec-a8c7f6adefb9)

## Biological Scope
* Plants don’t have immune systems the way other organisms and mammals have
* There’s an evolutionary arms race between evolving resistance and the pathogen evolving to escape this detection
* NBS (nucleotide binding site) + LRR (leucine-rich repeats) domains widely-conserved and well-studied regions of plant genomes
* LRR and NBS domains are relatively conserved (despite the rapid evolutionary pressure on plant defense genes)
* These NBS-LRR (R genes) act as the immune systems in plants
* They typically cluster in the same regions and evolve quickly
* The more R genes plants have, the more likely they can defend against threats
* Plants don’t have antibodies
* These genes are transcribed and they’re then used in RNAinterference; there’s hairpins in the genes and they have some regions which target the pathogen sequences
<br>
</br>

## Project Overview
![image](https://github.com/collaborativebioinformatics/SVHack_Plants/assets/30478823/5ad66f81-6b4b-4e1f-aabf-6b8f15dbe19e)

<br>
</br>

## Expected Workflow
![image](https://github.com/collaborativebioinformatics/SVHack_Plants/assets/30478823/9ccf6ac8-e713-48a9-9893-fbc50ed3ada7)


<br>
</br>

## Pipeline Schematic
![pipeline-figure drawio](https://github.com/collaborativebioinformatics/SVHack_Plants/assets/30478823/6e1e3141-742a-4f54-8fa2-af21c2abe7e5)

<br>
</br>

## DNAnexus Setup

* Start an analysis with the `tty` image
* git clone this repository and cd into the checked out repository
* Set up the compute environment by executing `scripts/setup_environment.sh`. This creates the conda environment `plantkmer` that installs all required software.
* Add the conda distribution to the path: `PATH=~/miniconda3/bin:$PATH`
* Activate the project environment using `conda activate plantkmer`
* The data in the DNAnexus environment is available in `/mnt/project/`

## Benchmarking Goals
We will work together today across 4 timezones to get our DNAnexus workspace booted up. The goal is to have a working prototype of our pipeline implemented by tomorrow.

<br>
</br>

## Finetuning Experiments
We are actively discussing and planning finetuning experiments to bring our project home by the hackathon's end

<br>
</br>

## Manuscript 
By tomorrow morning, we will contribute 6 paragraphs to the collective manuscript document. 
