#!/usr/bin/env perl

use Getopt::Long;
use File::Path;
use Sys::Hostname;
use strict;

my ($infile, $krakendb, $grid_nodes, $current_node);


GetOptions("infile=s"       => \$infile,
	   "krakendb=s"     => \$krakendb
    );

$grid_nodes = $ENV{"SGE_TASK_LAST"};
$current_node = $ENV{"SGE_TASK_ID"};

unless ($infile && $krakendb) {
    die "\nusage: $0 -infile FASTQFILE_S3_URL -krakendb KRAKEN_DB_S3_URL

Example: kraken_pipeline.pl -krakendb s3://bibicloud-demo/kraken-db/minikraken_20140330 -infile s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_20M.fastq

";
}

my $host = hostname;
my $krakendb_dir = '/vol/scratch/krakendb';
mkpath($krakendb_dir);
print STDERR "host: $host, SGE_LAST_TASK: $grid_nodes, SGE_TASK_ID: $current_node\n";

print STDERR "Donwloading Database to /vol/scratch/krakendb/...\n";
print STDERR "/vol/scripts/download.pl -type folder -source $krakendb/ -dest $krakendb_dir\n";
system("/vol/scripts/download.pl -type folder -source $krakendb/ -dest $krakendb_dir");
print STDERR "Done downloading Database.\n";

print STDERR "Donwloading FASTQ File to /vol/scratch/...\n";
print STDERR "/vol/scripts/download.pl -type split-fastq -source $infile -dest /vol/scratch  -grid-nodes $grid_nodes -current-node $current_node\n";
system("/vol/scripts/download.pl -type split-fastq -source $infile -dest /vol/scratch  -grid-nodes $grid_nodes -current-node $current_node");
print STDERR "Done downloading FASTQ file.\n";


