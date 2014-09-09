docker-kraken
=============

Start bibigrid:

    bibigrid.sh -c

Login to master node:

    ssh -i ~/.ssh/cmg_ec2euwest.pem ubuntu@ec2-???.???.???.???.eu-west-1.compute.amazonaws.com

Clone the Docker Kraken Pipeline from Github:

    git clone https://github.com/asczyrba/docker-kraken.git

Build the Docker image (optional, image is hosted by Docker Hub already):

    sudo docker build -t "asczyrba/kraken" .
    sudo docker push asczyrba/kraken

Start the pipeline:
This qsub command assumes that you have 4 compute nodes with 8 cores each.

Small example (4GB Kraken DB, 10 mio reads in FASTQ file):

    cd /vol/spool
    qsub -t 1-4 -cwd -pe multislot 8 ~/docker-kraken/scripts/docker_run.sh /vol/scratch /vol/spool "/vol/scripts/kraken_pipeline.pl -krakendb s3://bibicloud-demo/kraken-db/minikraken_20140330 -infile s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_10M.fastq"

Large example (150 GB Kraken DB, 50 mio reads in FASTQ file):

    cd /vol/spool
    qsub -t 1-4 -cwd -pe multislot 8 ~/docker-kraken/scripts/docker_run.sh /vol/scratch /vol/spool "/vol/scripts/kraken_pipeline.pl -krakendb s3://bibicloud-demo/kraken-db/standard -infile s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_50M.fastq"
    
After logout, terminate the BiBiGrid cluster:

    bibigrid.sh -l
    bibigrid.sh -t CLUSTERID
    

