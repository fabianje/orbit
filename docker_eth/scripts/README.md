1. Get access to Euler cluster
    * tutorial https://docs.google.com/presentation/d/1y3iSIHqS2lKfDFyogOT1a8iEr3RIxxNjOJfKGM-5LAI/edit
    * best practice: https://github.com/leggedrobotics/workflows/tree/main/best-practices/cluster

2. On the cluster:
    * make git filder
    * clone legged_gym (dev/train_vae), rsl_rl (categorical), and isaacgym (master) into your git folder
3. On your personal PC, install (in the following order) 
    * "go" -> https://docs.sylabs.io/guides/3.0/user-guide/installation.html
    * "singularity" -> install from source as described here https://docs.sylabs.io/guides/3.0/user-guide/installation.html
    * "docker" -> https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
    * See also https://github.com/leggedrobotics/workflows/tree/main/workflows/singularity-cluster

4. Run the build.sh script from within this directory
    * do not use sudo!
    * make sure that on your machine, you checked our the correct branches for legged_gym and rsl_rl
    * it will build the singulairty folder and upload all relevent files and folder to the cluser

5. Collect data (optional, this will overwrtie the data already contained in your data folder). ssh into euler, and run a job called "test" as follows:
    * cd /cluster/work/rsl/user_name/collect_data
    * chmod +x submit_data.sh (only once)
    * ./submit_data.sh test

7. Train VAE. ssh into euler, and run a job called "test" as follows:
    * cd /cluster/work/rsl/user_name/train_vae
    * chmod +x submit_vae.sh (only once)
    * ./submit_vae.sh test
    * You can find the logs on the cluster in your git folder. Copy them to your personal PC.