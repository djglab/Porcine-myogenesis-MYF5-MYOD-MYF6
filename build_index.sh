#!/bin/bash -l         
#SBATCH --time=24:00:00
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu=128g
#SBATCH --tmp=10g
#SBATCH --mail-type=ALL  
#SBATCH --mail-user=ma000332@umn.edu
#SBATCH -p aglarge
#SBATCH -o build_index.out

conda activate rna
cd /home/garrydj/ma000332/pig_bulk

wget https://ftp.ensembl.org/pub/release-108/fasta/sus_scrofa/cdna/Sus_scrofa.Sscrofa11.1.cdna.all.fa.gz

gzip -d Sus_scrofa.Sscrofa11.1.cdna.all.fa.gz

cp Sus_scrofa.Sscrofa11.1.cdna.all.fa Sus_scrofa.Sscrofa11.1.cdna.all.fasta
 
kallisto index -i transcriptome.idx Sus_scrofa.Sscrofa11.1.cdna.all.fasta