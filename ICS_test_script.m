Cluster=parcluster('LionX');
Cluster.ResourceTemplate='-l nodes=2:ppn=2 -l walltime=24:00:00 -l pmem=1gb';
batch(Cluster,'batch_run','pool',3);