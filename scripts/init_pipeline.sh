#!/bin/bash

# script inside the docker image, that handles the complete pipeline

# $FILE is the input filename
# $NUM_TASKS is the number of grid-tasks
# $TASK_ID is the qsub task id of this container

volume_input="/vol/in"
volume_output="/vol/out"
volume_db="/vol/db"
volume_tmp="/vol/tmp"

input_file="$volume_input/$FILE"
output_file="$volume_tmp/$FILE"

/extract_part.py $input_file $output_file $NUM_TASKS $TASK_ID

blastp -db $volume_db/$DATABASE -query $output_file -out $volume_output/$FILE.$TASK_ID.out