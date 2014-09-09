docker-kraken
=============

sudo docker build -t "asczyrba/kraken" .
sudo docker push asczyrba/kraken

qsub -t 1-2 -cwd -pe multislot 8 ~/docker-kraken/scripts/docker_run.sh /vol/scratch /vol/spool "/vol/scripts/kraken_pipeline.pl -krakendb s3://bibicloud-demo/kraken-db/minikraken_20140330 -infile s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_10M.fastq"

