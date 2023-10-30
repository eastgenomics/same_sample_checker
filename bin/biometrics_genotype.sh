# on a cloudworkstation
~$ cd /tmp
/tmp$ curl –O https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  860M  100  860M    0     0   297M      0  0:00:02  0:00:02 --:--:--  297M

/tmp$ bash Anaconda3-2023.03-1-Linux-x86_64.sh
# yes to all
/tmp$ source ~/.bashrc
/tmp$ conda update conda
/tmp$ conda update anaconda
/tmp$ conda create -n myenv -c bioconda -c conda-forge -c msk-access python=3.6 biometrics
/tmp$ cd ~
~$ conda activate myenv

~$ vcftools --vcf Omni25_genotypes_1525_samples_v2.b38.PASS.ALL.sites.vcf --bed probes_GRCh38_myeo_v1.0.bed \
--out Omni25_genotypes_1525_samples_v2.b38.PASS.ALL.sitesprobes_v1 --recode --keep-INFO-all

~$ for f in *.bam; do echo $f; 
biometrics extract \
  -sn $(echo $f | cut -d "-" -f1,2) \
  -sb $f \
  -st $(echo $f | cut -d "-" -f5) \
  -ss $(echo $f | cut -d "_" -f1 | rev | cut -d "-" -f 2) \
  -sg $(echo $f | cut -d "-" -f1,2) \
  --vcf Omni25_genotypes_1525_samples_v2.b38.PASS.ALL.sites_probes_v1.recode.vcf \
  --bed probes_GRCh38_myeo_v1.0.bed \
  -db output \
  -f GRCh38.no_alt_analysis_set_chr_mask21.fa.gz ;
done

~$ ls *.bam.bai | cut -d "-" -f1,2 > samples_names.txt
~$ cat samples_names.txt
~$ biometrics genotype  $(awk '{print "-i "$1}' samples_names.txt)     -db output --plot