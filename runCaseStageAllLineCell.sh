#!/bin/bash
# -------------------------
#SBATCH --ntasks 4
#SBATCH --nodes  1-2
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 4G
#SBATCH --time 24:00:00
#SBATCH --mail-type FAIL
#SBATCH --job-name="other"
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

numProc=4
numProc_1=3

echo "\n Stage 01 ----------------------------------"
	cp ./system/userLocationSamples.lineCell ./system/userLocationSamples
	cp ./system/decomposeParDict.orig ./system/decomposeParDict
	UFile="./system/decomposeParDict"
	sed s/"\(numberOfSubdomains[ \t]*\) 4"/"\1 $numProc"/g $UFile > temp.$$
	mv -f temp.$$ $UFile
	decomposePar
	
	mpirun renumberMesh -overwrite -parallel

	for j in $(seq 0 1 $numProc_1)
	do
	cp  constant/kinematicCloud1InjectionsTable ./processor$j/constant/
	cp  constant/kinematicCloud2InjectionsTable ./processor$j/constant/
	cp  constant/kinematicCloud3InjectionsTable ./processor$j/constant/
	cp  constant/kinematicCloud4InjectionsTable ./processor$j/constant/
	cp  constant/kinematicCloud5InjectionsTable ./processor$j/constant/
	cp  constant/kinematicCloud6InjectionsTable ./processor$j/constant/
	cp  constant/kinematicCloud7InjectionsTable ./processor$j/constant/
	done

	cp ./system/fvSolution.lptd ./system/fvSolution  # ok
	cp ./system/controlDict.lptd ./system/controlDict	
echo "END STAGE 01 - SUCCESS"

echo "\n Stage 02 deposicion ----------------------------"
	mpirun pimpleLPTFoam7PV2_2021 -parallel
echo "END STAGE 02 - SUCCESS"

echo "\n Stage 03 deposicion paso final ----------------------------"
	cp -f ./system/controlDictLog.lptd ./system/controlDict
	mpirun pimpleLPTFoam7PV2_2021 -parallel > log.lpt
echo "END STAGE 03 - SUCCESS"

echo "\n Stage 04 turbulent budget ----------------------------"
	
	for j in $(seq 0 1 $numProc_1)
      do
      rm ./processor$j/0.02010000/UMean*
      rm ./processor$j/0.02010000/pMean*
      rm ./processor$j/0.02010000/RMean*
      done

      # correr turbulent budgets
      cp ./system/controlDict.tke ./system/controlDict
      mpiexec pimpleTKEFoamV2021 -parallel
		
echo "END STAGE 04 - SUCCESS"


# ---------------------------
# END JALadino Script -------
# ---------------------------
