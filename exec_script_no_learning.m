Cluster=parcluster('LionX');
% Cluster.ResourceTemplate='-l nodes=2:ppn=3 -l walltime=100:00:00 -l pmem=1gb -q lionxg-econ';
% batch(Cluster,'batch_run','Matlabpool',5);

cd /gpfs/home/dcj138/work/EEJKT_est

Cluster.ResourceTemplate='-l nodes=7:ppn=2 -l walltime=100:00:00 -l pmem=3gb -q lionxg-econ';
batch(Cluster,'batch_run_no_learning','Matlabpool',13);
