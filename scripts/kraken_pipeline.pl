#!/usr/bin/env perl

use Getopt::Long;
use Sys::Hostname;
use strict;

my ($s3src, $infile, $krakendb, $grid_nodes, $current_node);


GetOptions("s3src=s"        => \$s3src,
	   "infile=s"       => \$infile,
	   "krakendb=s"     => \$krakendb
    );

$grid_nodes = $ENV{"SGE_TASK_LAST"};
$current_node = $ENV{"SGE_TASK_ID"};

unless ($s3src && $infile && $krakendb) {
    die "\nusage: $0 -s3src S3URL -infile FASTQFILE -krakendb KRAKEN_DB

";
}

my $host = hostname;
print STDERR "host: $host, SGE_LAST_TASK: $grid_nodes, SGE_TASK_ID: $current_node\n";

print STDERR "Donwloading Database to /vol/scratch/krakendb/...\n";
print STDERR "/vol/scripts/download.pl -type folder -source $krakendb/ -dest /vol/scratch/krakendb/\n";
system("/vol/scripts/download.pl -type folder -source $krakendb/ -dest /vol/scratch/krakendb/");
print STDERR "Done downloading Database.\n";

print STDERR "Donwloading FASTQ File to /vol/scratch/...\n";
print STDERR "/vol/scripts/download.pl -type split-fastq -source $infile -dest /vol/scratch  -grid-nodes $grid_nodes -current-node $current_node\n";
system("/vol/scripts/download.pl -type split-fastq -source $infile -dest /vol/scratch  -grid-nodes $grid_nodes -current-node $current_node");
print STDERR "Done downloading FASTQ file.\n";


