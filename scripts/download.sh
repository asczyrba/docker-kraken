#!/bin/bash
#$ -S /bin/bash
#download.sh
#called by qsub with file to download and storage path
if [[ -z $7 ]]; then
	echo "ERROR: Download Type must be set in pipeline.cfg"
	exit 1
else
	if [[ $7 == "folder" ]]; then
	
		java -jar /vol/scripts/bibis3-1.4.1.jar -r \
			--access-key "$1" \
			--secret-key "$2" \
			--region "$3" \
			--grid-download \
			--grid-nodes "$4" \
			--grid-current-node "$SGE_TASK_ID" \
			-d "$5" "$6"
	
	elif [[ $7 == "file" ]]; then
	
		java -jar /vol/scripts/bibis3-1.4.1.jar \
			--access-key "$1" \
			--secret-key "$2" \
			--region "$3" \
			--grid-download \
			--grid-nodes "$4" \
			--grid-current-node "$SGE_TASK_ID" \
			-d "$5/$8" "$6"

	elif [[ $7 == "split-fastq" ]]; then

		java -jar /vol/scripts/bibis3-1.4.1.jar \
			--access-key "$1" \
			--secret-key "$2" \
			--region "$3" \
			--grid-download \
			--grid-download-feature-fastq \
			--grid-nodes "$4" \
			--grid-current-node "$SGE_TASK_ID" \
			-d "$5/$8" "$6"
	fi
fi
	
