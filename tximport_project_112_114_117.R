library(tximport)
library(tidyverse)
library(rhdf5)
library(biomaRt)

abundance <- read.table("/home/garrydj/ma000332/Garry_Project_114/212-4281_E62SKM_RHL_Emb1_S1/abundance.tsv", header = T)

#ensembl_sscrofa <- useEnsembl("ensembl","sscrofa_gene_ensembl")

#tx2gene <- getBM(attributes = c("ensembl_transcript_id_version",'ensembl_gene_id',"external_gene_name","ensembl_transcript_id"), 
#               filters = 'ensembl_transcript_id_version',values = abundance$target_id,
#               mart = ensembl_sscrofa)
tx2gene <- read.csv("/home/garrydj/ma000332/Garry_Project_114/tx2gene.csv")

##Get the directories generated by Kallisto which has the abundance.tsv file for each sample
base_dir1 <- list.dirs(path = "/home/garrydj/ma000332/Garry_Project_114", full.names = TRUE, recursive = TRUE) %>% str_subset("/.ipynb_checkpoints", negate = TRUE)

base_dir1 <- base_dir1[2:length(base_dir1)] 

base_dir2 <- list.dirs(path = "/home/garrydj/ma000332/Garry_Project_112/pig_bulk", full.names = TRUE, recursive = TRUE) %>% str_subset("/.ipynb_checkpoints", negate = TRUE)

base_dir2 <- base_dir2[2:length(base_dir2)]

# Project 117
base_dir3 <- list.dirs(path = "/home/garrydj/ma000332/Garry_Project_112_114_117", full.names = TRUE, recursive = TRUE) %>% str_subset("/.ipynb_checkpoints", negate = TRUE) %>% str_subset("LHL")

base_dir <- c(base_dir1, base_dir2, base_dir3)

##excluding the main directory
file_name1 <- gsub("/home/garrydj/ma000332/Garry_Project_114/",'',base_dir1)
file_name2 <- gsub("/home/garrydj/ma000332/Garry_Project_112/pig_bulk/",'',base_dir2)
file_name3 <- gsub("/home/garrydj/ma000332/Garry_Project_112_114_117/",'',base_dir3)

##File path of abundance.tsv that contains the countdata
files <- file.path(base_dir, "abundance.tsv") 
names(files) <- c(file_name1, file_name2, file_name3) ##naming the list with the sample names

##tximport extract transcript-level abundance, estimated counts and transcript lengths from the abundance.tsv file that can be used as an input for DESeq2
txi.kallisto.tsv <- tximport(files, type = "kallisto", tx2gene = tx2gene)

##Save file and put it in s3cmd
saveRDS(txi.kallisto.tsv, 'Garry_Project_112_114_117_pig_bulkRNA_33samples.rds')
