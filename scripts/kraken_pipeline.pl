#!/usr/bin/env perl

use Getopt::Long;
use File::Path;
use File::Basename;
use Sys::Hostname;
use strict;

my ($infile, $krakendb);


GetOptions("infile=s"       => \$infile,
	   "krakendb=s"     => \$krakendb
    );

my $grid_nodes = $ENV{"SGE_TASK_LAST"};
my $current_node = $ENV{"SGE_TASK_ID"};
my $threads = $ENV{"NSLOTS"};

unless ($infile && $krakendb) {
    die "\nusage: $0 -infile FASTQFILE_S3_URL -krakendb KRAKEN_DB_S3_URL

Example: kraken_pipeline.pl -krakendb s3://bibicloud-demo/kraken-db/minikraken_20140330 -infile s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_20M.fastq

";
}

my $host = hostname;
my $krakendb_dir = '/vol/scratch/krakendb';
mkpath($krakendb_dir);
print STDERR "host: $host, SGE_TASK_LAST: $grid_nodes, SGE_TASK_ID: $current_node, NSLOTS: $threads\n";

print STDERR "Donwloading Database to /vol/scratch/krakendb/...\n";
print STDERR "/vol/scripts/download.pl -type folder -source $krakendb/ -dest $krakendb_dir\n";
system("/vol/scripts/download.pl -type folder -source $krakendb/ -dest $krakendb_dir");
print STDERR "Done downloading Database.\n";

print STDERR "Donwloading FASTQ File to /vol/scratch/...\n";
#print STDERR "/vol/scripts/download.pl -type split-fastq -source $infile -dest /vol/scratch  -grid-nodes $grid_nodes -current-node $current_node\n";
#system("/vol/scripts/download.pl -type split-fastq -source $infile -dest /vol/scratch  -grid-nodes $grid_nodes -current-node $current_node");
print STDERR "/vol/scripts/download.pl -type file -source $infile -dest /vol/scratch\n";
system("/vol/scripts/download.pl -type file -source $infile -dest /vol/scratch");
print STDERR "Done downloading FASTQ file.\n";

my $fastqfile = basename($infile);

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

