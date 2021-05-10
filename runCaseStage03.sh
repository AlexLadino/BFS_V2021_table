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
#set -e  
#set -xv

module purge;
module load bluebear;
module load OpenFOAM/6-foss-2019b;
source $FOAM_BASH;

# correr deposicion paso final
echo "\n Stage 03 deposicion paso final ----------------------------"
cp -f ./system/controlDictLog.lptd ./system/controlDict
mpirun pimpleLPTFoam7PV2_2021 -parallel > log.lpt
echo "END STAGE 03 - SUCCESS"
# ---------------------------
# END JALadino Script -------
# ---------------------------
