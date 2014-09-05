#!/bin/bash

# script to submit to qsub array job, that calls "docker run..."
# -> qsub -t 1-<num_tasks> -cwd docker_run.sh <num_tasks> <filename> ...	

if [ $# -ne 6 ]
  then
    echo "Usage: docker_run.sh NUM_TASKS INFILE INDIR DBDIR OUTDIR COMMAND"
    exit 0;
fi

NUM_TASKS=$1
INFILE=$2
INDIR=$3
DBDIR=$4
OUTDIR=$5
COMMAND=$6

sudo docker run \
    -e "NUM_TASKS=$NUM_TASKS" \
    -e "TASK_ID=$SGE_TASK_ID" \
    -e "INFILE=$INFILE" \
    -v $INDIR:/vol/in \
    -v $DBDIR:/vol/db \
    -v $OUTDIR:/vol/out \
    asczyrba/kraken \
    $COMMAND


