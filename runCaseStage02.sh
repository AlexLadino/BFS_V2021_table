#!/bin/bash
# -------------------------
#SBATCH --ntasks 4
#SBATCH --nodes  1-2
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 4G
#SBATCH --time 24:00:00
#SBATCH --mail-type FAIL
#SBATCH --job-name="PARTICLESTEST"
# -------------------------
##set -e  
#set -xv

module purge;
module load bluebear;
module load OpenFOAM/6-foss-2019b;
source $FOAM_BASH;


# ---------------------------
# Bash script by JALadino 
# cd ${0%/*} || exit 1   #@Jair:  This is a bad idea in a slurm script... need to get rid of these in all scripts
#. $WM_PROJECT_DIR/bin/tools/RunFunctions

# correr transient y deposicion
echo "\n Stage 02 deposicion ----------------------------"
mpirun pimpleLPTFoam7PV2_2021 -parallel
echo "END STAGE 02 - SUCCESS"

# ---------------------------
# END JALadino Script -------
# ---------------------------
