#! /bin/bash

# Configuration. Change this if needed.
singularity_folder="orbit_cluster"

# Un-tar to local scratch (make sure you resever sufficient scratch volume).
tar -xf /cluster/work/rsl/"$USER"/"$singularity_folder"-sif.tar -C $TMPDIR

# Start singularity container and mount git and data folder 
# --> make sure that home/git contains all relevant repositories to run the code
# --> make sure that .../work/.../_isaac_sim folder contains isacc sim
echo "run name = $@" 
singularity exec -B /cluster/home/"$USER"/git:/home/git -B /cluster/work/rsl/"$USER"/_isaac_sim:/home/git/orbit/_isaac_sim --nv --writable --containall $TMPDIR/"$singularity_folder".sif bash -c "cd /home/git/orbit && python3 source/standalone/workflows/rsl_rl/train.py --task Isaac-Velocity-Rough-Anymal-D-v0 --headless --run_name $@"