# VirSorter

This is the QIB Fork of VirSorter
[![Build Status](https://travis-ci.org/telatin/VirSorter.svg?branch=master)](https://travis-ci.org/telatin/VirSorter)


# Original README

Source code of the VirSorter App, available on CyVerse (https://de.iplantcollaborative.org/de/)

## Publication

* VirSorter: mining viral signal from microbial genomic data
* https://peerj.com/articles/985/
* PubMed 26038737

## Result files
The main output files of VirSorter are:
- VIRSorter_global-phage-signal.csv: Comma-separated table listing the viral predictions from VirSorter (one row per prediction)
- Metrics_files/VIRSorter_affi-contigs.tab: Pipe("|")-delimited table listing the annotation of all predicted ORFs in all contigs. Lines starting with a ">" are "headers", i.e. information about the contig (contig name, number of genes, "c" for circular or "l" for linear). All other lines are information about the genes, with different columns as follows: Gene name, start, stop, length, strand, Hit in the virus protein cluster database, hit score, hit e-value, category of the virus protein cluster (see below), Hit in PFAM, hit score, hit e-value.
The categories of virus clusters represent the range of genomes in which this virus cluster was detected, i.e. 0: hallmark genes found in Caudovirales, 1: non-hallmark gene found in Caudovirales, 2: non-hallmarke gene found exclusively in virome(s), 3: hallmark gene not found in Caudovirales, 4: non-hallmark gene not found in Caudovirales
- Predicted_viral_sequences/: fasta and genbank files of predicted viral sequences
- Fasta_files/: intermediary files, including predicted proteins
- Tab_files/: intermediary files, including results of the search agasint PFAM and the virus database.

VirSorter results can be imported into [Anvi'o](http://merenlab.org/software/anvio/) by following [these instructions](http://merenlab.org/2018/02/08/importing-virsorter-annotations/).

VirSorter results can also be imported into R by following [these instructions](https://github.com/simroux/VirSorter/issues/37#issuecomment-475740536).

## Using a conda virtual environment (tested on Ubuntu and CentOS)
* First install [Anaconda or Miniconda](https://conda.io/docs/user-guide/install/index.html)
* Download the databases required by VirSorter which have been converted to be used with HMMER version 3.1b2. Change to the directory where you want the databases be, and then run the following commands:
```
wget https://zenodo.org/record/1168727/files/virsorter-data-v2.tar.gz
md5sum virsorter-data-v2.tar.gz
# md5sum should return dd12af7d13da0a85df0a9106e9346b45
tar -xvzf virsorter-data-v2.tar.gz
```
* Create and install your conda virtual environment. Change to the directory where you want VirSorter to be installed and run the following commands:
```
conda create --name virsorter -c bioconda mcl=14.137 muscle blast perl-bioperl perl-file-which hmmer=3.1b2 perl-parallel-forkmanager perl-list-moreutils diamond=0.9.14
git clone https://github.com/simroux/VirSorter.git
cd VirSorter/Scripts
make clean
make
```
* To run VirSorter from any directory, you can make symbolic links to `VirSorter/wrapper_phage_contigs_sorter_iPlant.pl` and `VirSorter/Scripts` and place them in the `bin` folder for your "virsorter" conda environment. An example location of this `bin` folder is `~/miniconda/envs/virsorter/bin`. Substitute this path with the path to the `bin` folder for your newly created "virsorter" environment.
```
ln -s ~/Applications/VirSorter/wrapper_phage_contigs_sorter_iPlant.pl ~/miniconda/envs/virsorter/bin
ln -s ~/Applications/VirSorter/Scripts ~/miniconda/envs/virsorter/bin
```
* Finally, you'll need to download MetaGeneAnnotator ([Noguchi et al, 2006](https://doi.org/10.1093/nar/gkl723)). You can put this directly in the "virsorter" environment's `bin` folder alongside the VirSorter symbolic links taht were just created.
```
cd ~/miniconda/envs/virsorter/bin
wget http://metagene.nig.ac.jp/metagene/mga_x86_64.tar.gz
tar -xvzf mga_x86_64.tar.gz
```
Alternatively, you can install MetaGeneAnnotator in the conda environment as follows (thxs Simone Pignotti for the tip !):
```
conda install --name virsorter -c bioconda metagene_annotator
```

To run VirSorter, type the following:

```
source activate virsorter
wrapper_phage_contigs_sorter_iPlant.pl -f assembly.fasta --db 1 --wdir output_directory --ncpu 4 --data-dir /path/to/virsorter-data
```

* Note: An option "--no_c" is available for cases where VirSorter result file is empty (0 virus sequences predicted) due to errors in compiling or running the C script used to calculate enrichment statistics. With the "--no_c" option, VirSorter will use a perl function instead, which is slower, but should work on most systems and architectures.


## Note for Conda installation
If error: "ListUtil.c: loadable library and perl binaries are mismatched", this is a known conda issue, that can be fixed with the following steps:
Create a file etc/conda/activate.d/update_perllib.sh in your conda environment folder including the following lines:
```
#!/bin/sh
export OLD_PERL5LIB=$PERL5LIB
export PERL5LIB=`pwd`/../../../lib/site_perl/5.26.2/
```
Then create a file etc/conda/deactivate.d/update_perllib.sh in your conda environment folder including the following lines:
```
#!/bin/sh
export PERL5LIB=$OLD_PERL5LIB
```
Note: you may have to create the folders "etc", "etc/conda", "etc/conda/activate.d/", and "etc/conda/deactivate.d/" (e.g. using mkdir) in your conda environment folder, as these are not always generated by default in every conda environment.

## Docker - from DockerHub (v1.0.5)

* Download the databases required by VirSorter which have been converted to be used with HMMER version 3.1b2. Change to the directory where you want the databases be, and then run the following commands:
```
wget https://zenodo.org/record/1168727/files/virsorter-data-v2.tar.gz
md5sum virsorter-data-v2.tar.gz
#m5sum should return dd12af7d13da0a85df0a9106e9346b45
tar -xvzf virsorter-data-v2.tar.gz
```
* Pull VirSorter 1.0.5 from dockerhub: $ docker pull simroux/virsorter:v1.0.5
* Then run VirSorter from docker, mounting the data directory as data, and the run directory as wdir:
```
    $ docker run -v /host/path/to/virsorter-data:/data -v /host/path/to/virsorter-run:/wdir -w /wdir --rm simroux/virsorter:v1.0.5 --db 2 --fna Input_contigs.fna

```
After "virsorter:v1.0.5", the options correspond to the ones described in wrapper_phage_contigs_sorter_iPlant.pl (here selecting the database "Viromes" and pointing VirSorter to the file "Input_contigs.fna").
* You can specify a userID to be the owner of the files that will be created by VirSorter by using the --user option of Docker, e.g.
```
    $ docker run --user `id -u` -v /host/path/to/virsorter-data:/data -v /host/path/to/virsorter-run:/wdir -w /wdir --rm simroux/virsorter:v1.0.5 --db 2 --fna Input_contigs.fna

```

## Docker - from DockerHub (v1.0.3)

* Download the databases required by VirSorter, available as a tarball archive on iMicrobe: http://mirrors.iplantcollaborative.org/browse/iplant/home/shared/imicrobe/VirSorter/virsorter-data.tar.gz
or /iplant/home/shared/imicrobe/VirSorter/virsorter-data.tar.gz through iPlant Discovery Environment
* Untar this package in a directory, e.g. /host/path/to/virsorter-data
* Pull VirSorter from dockerhub: $ docker pull discoenv/virsorter:v1.0.3
* Create a working directory for VirSorter which includes the input fasta file, e.g. /host/path/to/virsorter-run
* Then run VirSorter from docker, mounting the data directory as data, and the run directory as wdir:

    $ docker run -v /host/path/to/virsorter-data:/data -v /host/path/to/virsorter-run:/wdir -w /wdir --rm discoenv/virsorter:v1.0.3 --db 2 --fna /wdir/Input_contigs.fna

After "virsorter:v1.0.3", the options correspond to the ones described in wrapper_phage_contigs_sorter_iPlant.pl (here selecting the database "Viromes" and pointing VirSorter to the file "Input_contigs.fna").


## Docker - building packages from scratch


### Dependencies

Install the following into a "bin" directory:

* HMMER (http://hmmer.janelia.org/)
* MCL (http://micans.org/mcl/)
* Metagene Annotator (http://metagene.nig.ac.jp/metagene/download_mga.html)
* MUSCLE (http://www.drive5.com/muscle/)
* BLAST+ (ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/)
* DIAMOND (https://github.com/bbuchfink/diamond)

### Data Container

The 12G of dependent data exists as a separate data container 
called "virsorter-data."

This is the Dockerfile for that:

    FROM perl:latest

    MAINTAINER Ken Youens-Clark <kyclark@email.arizona.edu>

    COPY Generic_ref_file.refs /data/

    COPY PFAM_27 /data/PFAM_27

    COPY Phage_gene_catalog /data/Phage_gene_catalog

    COPY Phage_gene_catalog_plus_viromes /data/Phage_gene_catalog_plus_viromes

    COPY VirSorter_Readme.txt /data

    COPY VirSorter_Readme_viromes.txt /data

    VOLUME ["/data"]
  
Then do:

    $ docker build -t kyclark/virsorter-data .
    $ docker create --name virsorter-data kyclark/virsorter-data /bin/true

### Build

    $ docker build -t kyclark/virsorter .

### Run

A sample "run" command to use the current working directory for input/output:

    $ docker run --rm --volumes-from virsorter-data -v $(pwd):/de-app-work \
    -w /de-app-work kyclark/virsorter --fna Mic_1.fna --db 1

## Authors

Simon Roux <sroux@lbl.gov> is the author of Virsorter

Ken Youens-Clark <kyclark@email.arizona.edu> packaged this for Docker/iPlant.

Bryan D Merrill <bmerrill@stanford.edu> provided the improvements and additions for v1.0.5
