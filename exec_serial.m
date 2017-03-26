Cluster=parcluster('LionX');
% 
% % for lionxg:
% %  Cluster.ResourceTemplate='-l nodes=14:ppn=2 -l walltime=100:00:00 -l pvmem=60gb -q lionxg-econ';
% %  batch(Cluster,'batch_run','pool',27);
%  
% 
  Cluster.ResourceTemplate='-l nodes=1 :ppn=1 -l walltime=100:00:00 -l pvmem=10gb -q lionxg-econ';
  batch(Cluster,'batch_run','pool',1);

% #!/bin/sh
% #PBS -l nodes=1:ppn=1
% #PBS -l walltime=01:30:00
% #PBS -q lionxg-econ
% #PBS -N batch_run
% #PBS -m abe
% #PBS -M user@cse.psu.edu
% #
% PROG=/home/users/prescott/hello-world
% ARGS=""
% #
% cd $PBS_O_WORKDIR
% # run the program
% #
% $PROG $ARGS
% exit 0