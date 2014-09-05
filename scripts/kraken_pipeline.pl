#!/usr/bin/env perl

use Getopt::Long;
use Sys::Hostname;
use strict;

my ($s3src, $infile, $krakendb, $grid_nodes, $current_node);


GetOptions("s3src=s"        => \$s3src,
	   "infile=s"       => \$infile,
	   "krakendb=s"     => \$krakendb
    );

$grid_nodes = $ENV{"SGE_LAST_TASK"};
$current_node = $ENV{"SGE_TASK_ID"};

unless ($s3src && $infile && $krakendb) {
    die "\nusage: $0 -s3src S3URL -infile FASTQFILE -krakendb KRAKEN_DB

";
}

my $host = hostname;
print "host: $host, SGE_LAST_TASK: $grid_nodes, SGE_TASK_ID: $current_node\n";
