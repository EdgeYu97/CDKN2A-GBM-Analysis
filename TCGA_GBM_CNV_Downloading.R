#!/usr/bin/env Rscript

#===============================================================================
#TCGA-GBM: Gene-level Copy Number Variation Data Download (ABSOLUTE LifrOver)
#Author: Guanqiao Yu (Edge)
#Date: 10/07/2025

# Purpose of the script: 
# To query, download, and prepare open-access to gene-level copy-number values 
# for TCGA-GBM primary glioblastoma multiforme samples using the GDC "Absolute 
# LiftOver" pipeline. 

#===============================================================================



#Packages Loading
suppressPackageStartupMessages({
  library(TCGAbiolinks)
  library(SummarizedExperiment)
  library(readr)
  library(tibble)
})

#Dataset Query
cnv_query <- GDCquery(
  project       = "TCGA-GBM",
  data.category = "Copy Number Variation",
  data.type     = "Gene Level Copy Number",
  access        = "open",
  sample.type   = "Primary Tumor",
  workflow.type = "ABSOLUTE LiftOver"
)
 
#Query Download
GDCdownload (cnv_query)

#Assemble data into a Summarized Experiment
se <- GDCprepare(cnv_query)

#Set output directory
dir.create("data/raw", recursive =TRUE, showWarnings = FALSE)
saveRDS(se, "data/raw/cnv_gene_se.rds")
