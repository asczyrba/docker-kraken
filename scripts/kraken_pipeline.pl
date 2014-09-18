#!/usr/bin/env perl

use Getopt::Long;
use File::Path;
use File::Basename;
use Sys::Hostname;
use strict;

$ENV{PATH} = "$ENV{PATH}:/vol/scripts:/vol/krona/bin";

my ($infile, $krakendb);


GetOptions("infile=s"       => \$infile,
	   "krakendb=s"     => \$krakendb
    );

my $grid_nodes = $ENV{"SGE_TASK_LAST"};
my $current_node = $ENV{"SGE_TASK_ID"};
my $threads = $ENV{"NSLOTS"};

unless ($infile && $krakendb) {
    die "\nusage: $0 -infile FASTQFILE_S3_URL -krakendb KRAKEN_DB_S3_URL

Small example (4GB Kraken DB, 2.6GB FASTQ file): 
kraken_pipeline.pl -krakendb s3://bibicloud-demo/kraken-db/minikraken_20140330.tar -infile s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_20M.fastq

Big example (142GB Kraken DB, 13GB FASTQ file):
kraken_pipeline.pl -krakendb s3://bibicloud-demo/kraken-db/kraken_standard.tar -infile s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_50M.fastq
";
}

my $host = hostname;
my $krakendb_dir = '/vol/scratch/krakendb';
mkpath($krakendb_dir);
print STDERR "host: $host, SGE_TASK_LAST: $grid_nodes, SGE_TASK_ID: $current_node, NSLOTS: $threads\n";

print STDERR "Downloading Database to /vol/scratch/krakendb/...\n";
print STDERR "/vol/scripts/download.pl -type file -source $krakendb -dest $krakendb_dir\n";
system("/vol/scripts/download.pl -type file -source $krakendb -dest $krakendb_dir");
chdir $krakendb_dir;
my $kraken_tarfile = basename($krakendb);
print STDERR "tar xvf $kraken_tarfile\n";
system("tar xvf $kraken_tarfile");
print STDERR "Done downloading Database.\n";

print STDERR "Downloading FASTQ File to /vol/scratch/...\n";
print STDERR "/vol/scripts/download.pl -type split-fastq -source $infile -dest /vol/scratch  -grid-nodes $grid_nodes -current-node $current_node\n";
system("/vol/scripts/download.pl -type split-fastq -source $infile -dest /vol/scratch  -grid-nodes $grid_nodes -current-node $current_node");
#print STDERR "/vol/scripts/download.pl -type file -source $infile -dest /vol/scratch\n";
#system("/vol/scripts/download.pl -type file -source $infile -dest /vol/scratch");
print STDERR "Done downloading FASTQ file.\n";

my $fastqfile = basename($infile);

chdir "/vol/spool";

## run kraken
print STDERR "running kraken:\n";
print STDERR "/vol/kraken/kraken --preload --db $krakendb_dir --threads $threads --fastq-input --output /vol/spool/kraken.out.$current_node /vol/scratch/$fastqfile\n";
system("/vol/kraken/kraken --preload --db $krakendb_dir --threads $threads --fastq-input --output /vol/spool/kraken.out.$current_node /vol/scratch/$fastqfile");
print STDERR "kraken done.\n";

## create reports
print STDERR "creating Kraken report:\n";
print STDERR "/vol/kraken/kraken-report --db $krakendb_dir /vol/spool/kraken.out.$current_node > /vol/spool/kraken.out.$current_node.report\n";
system("/vol/kraken/kraken-report --db $krakendb_dir /vol/spool/kraken.out.$current_node > /vol/spool/kraken.out.$current_node.report");
print STDERR "Kraken report done.\n";

