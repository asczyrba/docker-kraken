#!/bin/sh

if [ $# -ne 6 ]
  then
    echo "Usage: submit_kraken_pipeline.sh TASKS SLOTS KRAKENDB FASTQ SPOOLDIR TMPDIR"
    echo
    echo "Example: submit_kraken_pipeline.sh 2 32 s3://bibicloud-demo/kraken-db/minikraken_20140330.tar s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_10M.fastq /vol/spool /vol/scratch"
    exit 1
fi

TASKS=$1
SLOTS=$2
KRAKENDB=$3
FASTQ=$4
SPOOLDIR=$5
SCRATCHDIR=$6

PIPELINEHOME="/vol/kraken/docker-kraken"

export PATH=$PIPELINEHOME/krona/bin:$PATH

cd $SPOOLDIR
echo "Submitting job to SGE and waiting until finished..."
echo qsub -sync y -t 1-$TASKS -cwd -pe multislot $SLOTS $PIPELINEHOME/scripts/docker_run.sh $SCRATCHDIR $SPOOLDIR "/vol/scripts/kraken_pipeline.pl -krakendb $KRAKENDB -infile $FASTQ"
qsub -sync y -t 1-$TASKS -cwd -pe multislot $SLOTS $PIPELINEHOME/scripts/docker_run.sh $SCRATCHDIR $SPOOLDIR "/vol/scripts/kraken_pipeline.pl -krakendb $KRAKENDB -infile $FASTQ"
echo "SGE job done."

## combine Kraken output and convert
echo "combining Kraken outputs"
echo "$PIPELINEHOME/scripts/kraken_to_txt.py $SPOOLDIR $SPOOLDIR/kraken_output.combined n"
$PIPELINEHOME/scripts/kraken_to_txt.py $SPOOLDIR $SPOOLDIR/kraken_output.combined n
echo "DONE combining Kraken outputs"

## create Krona file
echo "creating KRONA file:"
echo "$PIPELINEHOME/krona/bin/ktImportText -o kraken_krona.html $SPOOLDIR/kraken_output.combined"
$PIPELINEHOME/krona/bin/ktImportText -o $SPOOLDIR/kraken_krona.html $SPOOLDIR/kraken_output.combined
echo "KRONA report done."

echo "PIPELINE FINISHED."

