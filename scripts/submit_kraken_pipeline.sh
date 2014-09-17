#!/bin/sh

if [ $# -ne 4 ]
  then
    echo "Usage: submit_kraken_pipeline.sh TASKS SLOTS KRAKENDB FASTQ"
    echo
    echo "Example: submit_kraken_pipeline.sh 2 32 s3://bibicloud-demo/kraken-db/minikraken_20140330.tar s3://bibicloud-demo/HMP_Stool_Sample/SRS011405_10M.fastq"
    exit 1
fi

TASKS=$1
SLOTS=$2
KRAKENDB=$3
FASTQ=$4

PIPELINE_HOME="~/docker-kraken"
SPOOLDIR="/vol/spool"
SCRATCHDIR="/vol/scratch"

cd /vol/spool
echo "Submitting job to SGE and waiting until finished..."
echo qsub -sync y -t 1-$TASKS -cwd -pe multislot $SLOTS $PIPELINE_HOME/scripts/docker_run.sh $SCRATCHDIR $SPOOLDIR "$PIPELINE_HOME/scripts/kraken_pipeline.pl -krakendb $KRAKENDB -infile $FASTQ"
qsub -sync y -t 1-$TASKS -cwd -pe multislot $SLOTS $PIPELINE_HOME/scripts/docker_run.sh $SCRATCHDIR $SPOOLDIR "$PIPELINE_HOME/scripts/kraken_pipeline.pl -krakendb $KRAKENDB -infile $FASTQ"
echo "SGE job done."

## combine Kraken output and convert
echo "combining Kraken outputs"
echo "$PIPELINE_HOME/scripts/kraken_to_txt.py $SPOOLDIR $SPOOLDIR/kraken_output.combined n"
$PIPELINE_HOME/scripts/kraken_to_txt.py $SPOOLDIR $SPOOLDIR/kraken_output.combined n
echo "DONE combining Kraken outputs"

## create Krona file
echo "creating KRONA file:"
echo "$PIPELINE_HOME/krona/bin/ktImportText -o kraken_krona.html $SPOOLDIR/kraken_output.combined"
$PIPELINE_HOME/krona/bin/ktImportText -o $SPOOLDIR/kraken_krona.html $SPOOLDIR/kraken_output.combined
echo "KRONA report done."

echo "PIPELINE FINISHED."

