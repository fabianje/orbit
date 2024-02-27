#! /bin/bash
# 
# This file builds the singularity folder and moves all relevant files to the cluster. 
# Assumes cluster accces (Euler) for user user_name. 
# 
#run
# 1. only once: chmod u+x ./git/orbit/docker_eth/scripts/build.sh
# 2. followed by: ./git/orbit/docker_eth/scripts/build.sh

# Configuration. Change this if needed.
path="/home/"$USER"/git/orbit/"
path_exports="$path""docker_eth/exports/"
path_docker="$path""/docker_eth/scripts/"
path_cluster="/cluster/work/rsl/"$USER""
file="orbit_cluster"

# Clean up first.
sudo docker system prune -a -f
sudo singularity cache clean
sudo rm -rf "$path_exports"/*

# Create docker image (rslethz/orbit_cluster)
echo "=========== (1) Create docker file ==========="
cd /home/"$USER" && tar -cf "$path_docker"/git.tar git/rsl_rl/ git/orbit/
cd /home/"$USER" && tar -cf "$path_docker"/isaac.tar -C ${HOME}/.local/share/ov/pkg isaac_sim-2023.1.1
cd "$path_docker" && export DOCKER_BUILDKIT=1 && sudo docker build --progress=plain -f Dockerfile -t rslethz/orbit_cluster ./
cd "$path_docker" && rm -rf git.tar && rm -rf isaac.tar
# Note: 
# > List available images: sudo docker image
# > Run docker image: sudo docker run -i -t rslethz/orbit_cluster:latest

# Create singularity container (e.g. file.sif)
echo "=========== (2) Create singularity container ==========="
cd "$path_exports" && SINGULARITY_NOHTTPS=1 sudo singularity build --sandbox "$file".sif docker-daemon://rslethz/orbit_cluster:latest

# Tar singularity container (e.g. file-sif.tar)
echo "=========== (3) Compress singularity container ==========="
cd "$path_exports" && sudo tar -cf "$file"-sif.tar "$file".sif && sudo rm -rf "$file".sif

# Move everythong to cluster
echo "=========== (4) Move to cluster ==========="
cd "$path_exports" && scp "$file"-sif.tar "$USER"@euler:"$path_cluster"
#cd "$path_docker" && scp -r train_loco "$USER"@euler:"$path_cluster"