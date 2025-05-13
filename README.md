# Molecular Responses of Larval Pacific Cod to Climate Stressors

**Project repository for the companion transcriptomic study to Slesinger et al. (2024):**  
*Spencer et al. (2024) - Molecular indicators of warming and other climate stressors in larval Pacific cod*  
_Accepted in Canadian Journal of Fisheries and Aquatic Sciences_

## Summary

This repository contains code and resources for analyzing gene expression data from larval Pacific cod (*Gadus macrocephalus*) reared under projected climate stressor scenarios. The work aims to uncover molecular mechanisms underlying observed larval mortality during marine heatwaves in the Gulf of Alaska.

Larvae were reared in a factorial design of:
- **Three temperatures**: 3°C (cold), 6°C (control), 10°C (warm)
- **Two pCO₂ levels**: ambient (~390 μatm) and high (~1,560 μatm)

RNA sequencing (RNASeq) was conducted on whole-body larvae at matched developmental stages to evaluate differential gene expression and functional enrichment in response to warm and cold temperatures alone and when combined with acidification. 

## Key Findings

- **Warming caused major transcriptomic shifts**, including:
  - Downregulation of genes involved in lipid metabolism and energy production
  - Upregulation of immune/inflammatory genes, visual system development, and cell adhesion
- **Acidification effects were more subtle**, but implicated digestion and immune suppression
- **Cold exposure affected protein synthesis machinery** and lipid processes, suggesting metabolic acclimation
- **Combined stressors (warming + acidification)** dampened some molecular responses observed under warming alone

These results indicate that warming may directly impair larval physiology via metabolic mismatch and inflammation, potentially explaining observed recruitment failures in Pacific cod.

## Repository Contents

- `data/`: Links to metadata, multiqc report
- `notebooks/`: RMarkdown notebooks for differential expression analysis 
- `references/`: GadMor annotation files and reference functions 
- `results/`: Figures, tables, slidedecks
- `scripts/`: SLURM scripts for RNASeq data processing and alignment

## Data Availability

- **Raw RNASeq data**: Available on NCBI under BioProject [PRJNA1154236](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1154236)
- **Reference genome**: *Gadus morhua* (Atlantic cod), gadMor3.0 (GCA_902167405.1)

## Software & Packages

Analyses were conducted in R v4.1.2 using:

- `STAR` for alignment 
- `featurecounts` for gene count matrix  
- `DESeq2` for differential gene expression analysis
- `vegan` and `pairwiseAdonis` for PCA and PERMANOVA
- `DAVID` for functional enrichment
- `ggplot2`, `patchwork`, `dplyr`, and other tidyverse packages for visualization and data wrangling

## Citation

Spencer, L.H., Slesinger, E., Spies, I., Laurel, B.J., & Hurst, T.P. (2025).  
*Molecular indicators of warming and other climate stressors in larval Pacific cod*.  
Accepted in *Canadian Journal of Fisheries and Aquatic Sciences*.

## Contact

For questions, contact:  
Laura H. Spencer  
[laurahspencer.github.io](https://laurahspencer.github.io/)  
lhs3@uw.edu
