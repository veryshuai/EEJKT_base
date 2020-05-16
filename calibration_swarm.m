
%This function initiates the genetic algorithm to solve for
%the parameters of the model.  Initial parameter guesses can be set here,
%as well as optional settings for the genetic algorithm.


% relation between parameters and the X vector:

%% relation between parameters and the X vector:
    
% F_h      =  exp(X(1));     % home match fixed cost
% scale_h  =  X(2);          % log of home profit function scalar       
% delta    =  0.326;         % exogenous match death hazard (per year)                                 
% beta     = 1;              % cost function convexity parameter               
% ah       =  X(4)*X(3);     % X(3) is mean of beta dist ah / (ah + bh)
% bh       =  X(4)*(1-X(3)); % X(4) is (ah + bh)        
% L_z      =  4;             % buyer shock jump hazard (once per quarter)           
% D_z      =  X(5);          % buyer shock jump size            
% L_b      =  X(6);          % shipment hazard            
% gam      =  X(7);          % network effect
% cs_h     =  exp(X(8));     % cost function scalar, home market  
% sig_p    =  X(9);          % std. dev. of log productivity shock 
% F_f      =  exp(X(10));    % foreign match fixed cost
% cs_f     =  exp(X(11));    % cost function scalar, foreign market
% scale_f  =  X(12);         % log of foreign profit function scalar 

%%
lowb = [-10; -10;   0.001;   0.1; 0.005;  0.001; -2;   -2; 0.001;  -10; -10; -10];
upb =  [10;   10;   0.999;  10.0;   8.0;     50;  4;   20;  5.00;   10;  20;  20];

inpop =[...
      -5.86761  -5.25532   0.24327   1.43162   1.88984  16.45042   0.40897  10.93005   1.41226  -1.18815 11.93005 -5.25532;...
      -4.69132  -5.21100   0.24336   2.64573   4.35547  16.08639   0.44049  11.00482   1.43957  -0.64093 12.95491 -5.21100;...
      -4.69132  -5.21100   0.24336   2.64573   4.35547  16.08639   0.44049  11.00482   1.43957  -0.64093 12.95491 -5.01100;...
      -4.69132  -5.21100   0.24336   2.64573   4.35547  16.08639   0.44049  11.00482   1.43957  -0.64093 12.95491 -4.81100;...
      -5.79756  -4.13020   0.23193   1.46214   1.88120  16.05066   0.38239  10.72108   1.38618  -1.29631  11.94630  -5.13566;...
      -5.79756  -4.13020   0.23193   1.46214   1.88120  16.05066   0.38239  10.72108   1.38618  -1.29631  11.94630  -5.13566;...
      -5.79756  -4.13020   0.23193   1.46214   1.88120  16.05066   0.38239  10.72108   1.38618  -1.29631  11.94630  -5.13566;...
      -5.80063  -5.13575   0.23152   1.46217   1.88984  17.05394   1.38654  10.50482   1.38565  -1.29631  11.94567  -5.13575;...
      -5.80063  -5.13575   0.23152   1.46217   1.88984  17.05394   1.38654  10.50482   1.38565  -1.29631  11.94567  -5.13575;...
      -5.80063  -5.13575   0.23152   1.46217   1.88984  17.05394   1.38654  10.50482   1.38565  -1.29631  11.94567  -5.13575;...   
      -5.72446  -4.12239   0.23266   2.70436   2.16730  16.30953   0.42438  11.02430   1.39542  -1.29631  12.98462  -6.20709;...
      -5.72446  -4.12239   0.23266   2.70436   2.16730  16.30953   0.42438  11.02430   1.39542  -1.29631  12.98462  -6.20709;...
      -5.72446  -4.12239   0.23266   2.70436   2.16730  16.30953   0.42438  11.02430   1.39542  -1.29631  12.98462  -6.20709;...
      -5.80063  -5.13575   0.23152   1.46217   1.87921  16.05394   0.38654  10.94567   1.38565  -1.29631  11.94567  -5.13575...
      ];
    
    % Parallel setup
    clc
    
    % Put numbers in long format for printing
    format long;

    % random seed
    rng(80085);
 
% set up problem object for particle swarm

 particle_swarm_options = optimoptions('particleswarm','SwarmSize',24,...
    'InitialSwarmMatrix',inpop,'UseParallel', 'always','HybridFcn',{@fmincon,fminconoptions}); 

    problem_particleswarm = struct('solver','particleswarm','objective',@(X) distance(X, cf_num, 1),...
        'nvars',12,'lb',lowb,'ub',upb,'options',particle_swarm_options);
    % Save results
    save est_results_genetic;

