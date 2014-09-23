docker-kraken
=============

Edit the bibigrid.properties file provided in the repository and add your ceredentials and
path to your SSH key file.

Start bibigrid:

    bibigrid.sh -c -o bibigrid.properties

Login to master node (see BiBiGrid output how to set environment variables):

    ssh -i ~/.ssh/cmg_ec2euwest.pem ubuntu@ec2-???.???.???.???.eu-west-1.compute.amazonaws.com

Clone the Docker Kraken Pipeline from Github:

    git clone https://github.com/asczyrba/docker-kraken.git

Build the Docker image (optional, image is hosted by Docker Hub already):

    sudo docker build -t "asczyrba/kraken" .
    sudo docker push asczyrba/kraken

Start the pipeline:

Small example (4GB Kraken DB, 10 mio reads in FASTQ file):
This qsub command assumes that you have 3 compute nodes with 8 cores each.


   /vol/kraken/docker-kraken/scripts/submit_kraken_pipeline.sh 3 8 s3://bibicloud-demo/kraken-db/minikraken_20140330.tar s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_10M.fastq /vol/spool /vol/scratch


Large example (150 GB Kraken DB, 50 mio reads in FASTQ file):
This qsub command assumes that you have 10 compute nodes with 32 cores each.

    /vol/kraken/docker-kraken/scripts/submit_kraken_pipeline.sh 10 32 s3://bibicloud-demo/kraken-db/kraken_standard.tar s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_50M.fastq
    

After logout, terminate the BiBiGrid cluster:

    bibigrid.sh -l
    bibigrid.sh -t CLUSTERID
    

