#!/bin/bash

# load global config file
. ./pipeline.cfg

submit_message="Submitting pipeline script '$pipeline_script' with $num_tasks tasks on $num_nodes nodes."

# echo for test of correct paths
echo "docker registry: $docker_registry"

# check if s3 should be used
if [[ $s3 == "on" ]]; then

		# check for the required S3 parameters
		if [[ -z $s3_database_dir ]]; then

			echo "ERROR: s3_database_dir is missing!" 1>&2
			exit 1

		elif [[ -z $s3_input_dir ]]; then

			echo "ERROR: s3_input_dir is missing!" 1>&2
			exit 1

		elif [[ -z $s3_region ]]; then

			echo "ERROR: s3_region is missing!" 1>&2
			exit 1

		else

			# load S3 credentials
			. ./.aws-credentials.properties

			# check for the cedentials
			if [[ -z $accessKey ]]; then

				echo "ERROR: S3 access key is missing!" 1>&2
				exit 1

			elif [[ -z $secretKey ]]; then

				echo "ERROR: S3 secret key is missing!" 1>&2
				exit 1

			fi

			# download database from S3
			echo "Loading database '$database_file' from '$s3_database_dir' region '$s3_region' to '$database_dir'."
			qsub -N "job_download_db" -t 1-$num_nodes download.sh \
				$accessKey \
				$secretKey \
				$s3_region \
				$num_nodes \
				$s3_database_dir \
				$database_dir \
				$db_download_type \
				$database_file

			# download input from S3
			echo "Loading input '$input_file' from '$s3_input_dir' to '$input_dir'."
			qsub -N "job_download_input" -hold_jid "job_download_db" -t 1-$num_nodes download.sh \
				$accessKey \
				$secretKey \
				$s3_region \
				$num_nodes \
				$s3_input_dir \
				$input_dir \
				$input_download_type \
				$input_file

			# start pipeline script
			echo $submit_message
			qsub -hold_jid "job_download_input" -t 1-$num_tasks $pipeline_script

			exit 0

		fi

else

	#no S3, assume data is located in NFS or local filesystem
	echo $submit_message
	qsub -t 1-$num_tasks $pipeline_script

	exit 0

fi
