#! /bin/bash
#
# Launch a batched job running a bash script within a container.
# Special arguments described here https://scicomp.ethz.ch/wiki/Using_the_batch_system

# Job name.
echo "Execute submit.sh scipt with name $@"
job_name=`echo $@`

# Cluster magic.
sbatch \
  -n 7 \
  --mem-per-cpu=7000 \
  --tmp=2500 \
  --gpus=1 \
  --gres=gpumem:8000 \
  --time=4:00:00 \
  --account=es_hutter \
  --mail-type=END \
  --job-name=$job_name \
  --output=log_$job_name.out \
  /cluster/work/rsl/"$USER"/train_loco/train_loco.sh $job_name