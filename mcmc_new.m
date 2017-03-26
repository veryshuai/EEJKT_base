% This script generates a Metropolis-Hastings MCMC chain with Gibbs
% sampling

%UNTITLED Summary of this function goes here

    
% scale_h    =  exp(X(3));            home profit function scalar
% F          =  exp(X(1)+X(3));       fixed cost per match
% delta      =  X(2);                 exogenous match separation hazard
% scale_f    =  exp(X(3) + X(4));     foreign profit function scalar
% beta       =  X(5);                 cost function convexity
% ah         =  exp(X(7))*X(6);       beta dist. success parameter
% bh         =  exp(X(7))*(1-X(6));   beta dist. failure parameter
% L_z        =  X(8);                 hazard, match shock
% D_z        =  X(9);                 jump size, match shock
% L_b        =  X(10);                hazard, shipment order
% gam        =  X(11)*(1+beta)/beta;  cost function, network effect
% cs         =  exp(X(12));           cost function scalar  
% sig_p      =  X(13);                Pareto parameter

%% set priors (all uniform for now)

  X = [7.3336  0.5063  1.9312  0.0880  0.4448  0.3683  4.5883  1.7806 ...
       0.2093  4.4989 -2.9715  5.6038  0.3417];
% search cost function parameters: 

scst = [X(5),X(11),X(12)];
scst_lb = [0.001, -10, 0.1];
scst_ub = [10,     10,  10];  

% match flow payoff parameters:  

prof =[X(2),X(3),X(4),X(10)];
prof_lb = [  0.1,  0.1,  0.1,    0.1];  
prof_ub = [100.0,   10,   10,  100.0];

% match persistence parameters 

per =[X(1),X(8),X(9)]; 
per_lb = [  0.1,  0.005, 0.005];  
per_ub = [   10,   10.0, 10.00];

% heterogeneity parameters

het = [X(6),X(7),X(13)];
het_lb = [0.005,   0.1, 0.001];  
het_ub = [0.999, 100.0, 0.999];

%% set proposal densities

% search cost function: 

scst_diff = (scst_ub - scst_lb).^(0.5);
cov_mat   = (scst_diff'*scst_diff).^(0.5);
pf_scst = diag(scst_diff) - 0.2*cov_mat;
%chpf_scst = 0.05*chol(pf_scst);

% match flow payoff: 

prof_diff = (prof_ub - prof_lb).^(0.5);
cov_mat   = (prof_diff'*prof_diff).^(0.5);
pf_prof = diag(prof_diff) + 0.5*cov_mat;
%chpf_prof = 0.01*chol(pf_prof);

% match persistence:

per_diff = (per_ub - per_lb).^(0.5);
cov_mat   = (per_diff'*per_diff).^(0.5);
pf_per = diag(per_diff) + 0.3*cov_mat;
%chpf_per = 0.01*chol(pf_per);

% heterogeneity:

het_diff = (het_ub - het_lb).^(0.5);
cov_mat   = (het_diff'*het_diff).^(0.5);
pf_het =  diag(het_diff) + 0.1*cov_mat;
%chpf_het = 0.01*chol(pf_het);

% % Open the parallel pool
% pool = parpool('local',6)

%% Generate initial value for fit metric

% X = [2.792 0.400 2.247 0.883 0.491 0.534 15.083 3.526 0.036 9.453 0.000
% 11.269 0.698]; % for case of lognormal productivity shocks

cf_num = 0;
bigvec = X;
[f0,~,~,~] = distance_noprod(bigvec, cf_num, 1);
ff = f0;
cumvec = [0 X];
cumfit = [0 ff];

% Draw long list of uniform random draws to use for proposal evaluation
rand_list = rand(1e6,1);
rand_index = 1; %keep track of current location in list

%% MCMC Gibbs sampling loop

nrepit = 10000;       % number of elements in chain
burnin     = 0;       % burn-in iterations
nacc_scst  = 0;       % number of acceptances, sunk cost parameters
nacc_prof  = 0;       % number of acceptances, match flow profit parameters
nacc_per   = 0;       % number of acceptances, match persistence parameters
nacc_het   = 0;       % number of acceptances, heterogeneity parameters
icount     = 1;       % iteration count
scount     = 0;

while icount <= nrepit

%Read proposal distribution scalings from file
pd_scale = csvread('proposal_dist_scaling.csv')
chpf_scst = pd_scale(1) * chol(pf_scst);
chpf_prof = pd_scale(2) * chol(pf_prof);
chpf_per = pd_scale(3) * chol(pf_per);
chpf_het = pd_scale(4) * chol(pf_het);

'begin search cost draw'

block = [5,11,12];
[newvec, ff, iaccept,rand_index] = draw(bigvec, block, scst_lb, scst_ub, chpf_scst, ff, rand_list, rand_index);  
nacc_scst = nacc_scst + iaccept;
if iaccept == 1; bigvec = newvec; end;
accrate_scst = nacc_scst/icount;

'begin match flow profits draw'

block = [2,3,4,10];
[newvec, ff, iaccept, rand_index] = draw(bigvec, block, prof_lb, prof_ub, chpf_prof, ff, rand_list, rand_index);  
nacc_prof = nacc_prof + iaccept;
if iaccept == 1; bigvec = newvec; end;
accrate_prof = nacc_prof/icount;

'begin match persistence draw'

block = [1,8,9];
[newvec, ff, iaccept, rand_index] = draw(bigvec, block, per_lb, per_ub, chpf_per, ff, rand_list, rand_index);  
nacc_per = nacc_per + iaccept;
if iaccept == 1; bigvec = newvec; end;
accrate_per = nacc_per/icount;

'begin heterogeneity draw'

block = [6,7,13];
[newvec, ff, iaccept, rand_index] = draw(bigvec, block, het_lb, het_ub, chpf_het, ff, rand_list, rand_index);  
nacc_het = nacc_het + iaccept;
if iaccept == 1; bigvec = newvec; end;
accrate_het = nacc_het/icount;

%% saving and printing chain, acceptance rates

cumvec = cat(1,cumvec,[icount bigvec]);
cumfit = cat(1,cumfit,[icount ff]);
save ('results/chain.mat','cumfit','cumvec') 


 fileID2 = fopen('results/MCMC_fitness_chain.txt','a');
      fprintf(fileID2, '\r\n fitness: ');
          dlmwrite('results/MCMC_fitness_chain.txt',[icount ff],'-append','precision',12);
      fclose(fileID2);
   
 fileID1 = fopen('results/MCMC_output.txt','a');

      fprintf(fileID1,'\r\n fit metric: ');
      dlmwrite('results/MCMC_output.txt',ff,'-append','precision',12);
    
      fprintf(fileID1, '\r\n parameters: ');
      fprintf(fileID1, '\r\n%9.5f %9.5f %9.5f %9.5f %9.5f %9.5f %9.5f',bigvec(1:7));
      fprintf(fileID1, '\r\n%9.5f %9.5f %9.5f %9.5f %9.5f %9.5f',bigvec(8:13));
      fprintf(fileID1, '\r\n  ');

%       fprintf(fileID1, '\r\n coefficients = ');   
%       fprintf(fileID1, '\r\n%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f',mmm(1:9,:));  
%       fprintf(fileID1, '\r\n  ');
%       fprintf(fileID1, '\r\n%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f',mmm(10:18,:));  
%       fprintf(fileID1, '\r\n  ');
%       fprintf(fileID1, '\r\n%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f',mmm(19:27,:));  
%       fprintf(fileID1, '\r\n  ');
%       fprintf(fileID1, '\r\n%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f',mmm(28:36,:));  
%       fprintf(fileID1, '\r\n  ');   
      
%       fprintf(fileID1, '\r\n number of exporters     = ');
%           dlmwrite('results/running_output.txt',pbexp,'-append','precision',12);
%       fprintf(fileID1, ' maximum number of clients   = ');
%           dlmwrite('results/running_output.txt',maxcli_no,'-append','precision',12);
%       fprintf(fileID1, '\r\n  ');    

      fprintf(fileID1, '\r\n acceptance rate, search cost parameters        = ');
         dlmwrite('results/MCMC_output.txt',accrate_scst,'-append','precision',12);
      fprintf(fileID1, ' acceptance rate, match profit flow parameters  = ');
         dlmwrite('results/MCMC_output.txt',accrate_prof,'-append','precision',12);
      fprintf(fileID1, ' acceptance rate, persistence parameters        = ');
         dlmwrite('results/MCMC_output.txt',accrate_per,'-append','precision',12);
      fprintf(fileID1, ' acceptance rate, heterogeneity parameters      = ');
         dlmwrite('results/MCMC_output.txt',accrate_het,'-append','precision',12);

  
    fprintf(fileID1, '\r\n  ');              
    fclose(fileID1);


icount = icount + 1
scount = scount + 1;


end

%close the parallel pool
delete(pool)


