#!/bin/bash

# script to submit to qsub array job, that calls "docker run..."
# -> qsub -t 1-<num_tasks> -cwd docker_run.sh <num_tasks> <filename> ...	

sudo docker run \
	-e "FILE=$1" \
	-e "NUM_TASKS=$2" \
	-e "TASK_ID=$SGE_TASK_ID" \
	-e "DATABASE=$3" \
	-v $4:/vol/in \
	-v $5:/vol/db \
	-v $6:/vol/out \
	$7
