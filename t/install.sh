wget http://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -bf
conda create --name virsorter -c bioconda mcl=14.137 muscle blast perl-bioperl perl-file-which hmmer=3.1b2 perl-parallel-forkmanager perl-list-moreutils diamond=0.9.14 metagene_annotator
conda activate virsorter



