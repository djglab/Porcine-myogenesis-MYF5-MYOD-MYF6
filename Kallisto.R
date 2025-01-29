library(stringr)
library(tidyverse)

r1 <- list.files('/home/garrydj/data_delivery/umgc/2023-q1/230109_VH00601_126_AACGWNWM5/Garry_Project_112', pattern = 'R1', full.names=TRUE, ignore.case=TRUE) 
r2 <- list.files('/home/garrydj/data_delivery/umgc/2023-q1/230109_VH00601_126_AACGWNWM5/Garry_Project_112', pattern = 'R2', full.names=TRUE, ignore.case=TRUE)
out <- gsub("_R2_001.fastq.gz","",gsub('/home/garrydj/data_delivery/umgc/2023-q1/230109_VH00601_126_AACGWNWM5/Garry_Project_112/', '', r2))

sh <- list()

for (i in 1:length(out)){
sh[[i]] <- sprintf('#!/bin/bash -l
#SBATCH -J %s_RNA-seq
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu=128g
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ma000332@umn.edu
#SBATCH -o %s.out
#SBATCH -p aglarge
                     
conda activate rna
cd /home/garrydj/ma000332/pig_bulk
kallisto quant -t 8 -i /home/garrydj/ma000332/pig_bulk/transcriptome.idx -o /home/garrydj/ma000332/pig_bulk/%s -b 100 %s %s',
out[[i]], out[[i]], out[[i]], r1[[i]], r2[[i]])}

for (i in 1:length(sh)){ write(sh[[i]], sprintf('%s_kallisto_quant.sh', out[[i]]))}
