Cluster=parcluster('LionX');

% short run for lionxq:
%  Cluster.ResourceTemplate='-l nodes=12:ppn=2 -l walltime=100:00:00 -l pvmem=10gb -q lionxg-econ';
%  batch(Cluster,'batch_run','pool',23);
%  
% for lionxg 
%   Cluster.ResourceTemplate='-l nodes=4:ppn=2 -l walltime=100:00:00 -l pvmem=10gb -q lionxg-econ';
%   batch(Cluster,'batch_run','pool',7);

% for lionxg 
 Cluster.ResourceTemplate='-l nodes=14:ppn=2 -l walltime=100:00:00 -l pvmem=10gb -q lionxg-econ';
 batch(Cluster,'batch_run','pool',27);

%   Cluster.ResourceTemplate='-l nodes=14:ppn=1 -l walltime=100:00:00 -l pvmem=10gb -q lionxg-econ';
%   batch(Cluster,'batch_run','pool',13);

