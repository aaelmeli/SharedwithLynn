#PBS -N mooseMatlabOptimization

#PBS -l select=7:ncpus=48:mpiprocs=48

#PBS -l place=scatter:excl

#PBS -l walltime=16:0:00

#PBS -j oe

#PBS -P edu_res

 

cd $PBS_O_WORKDIR

 

source /etc/profile.d/modules.sh
module load use.moose moose-dev/2023-04-18

module load matlab/R2023a

matlab < /home/elmeabde/sawtooth1/projects/matlabMooseWrapper/matlab_and_moose/inverse_solve.m > optOutput.txt
