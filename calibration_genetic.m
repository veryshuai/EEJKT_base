
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
lowb = [-10; -10;   0.001;   0.1; 0.005;  0.001; -5;  -10; 0.001;  -10; -10; -10];
upb =  [10;   20;   0.999; 100.0;   5.0;   100;   5;   20; 5.00;    10;  20;  20];

inpop =[...
      -4.69132  -5.21100   0.24336   2.64573   4.35547  16.08639  0.44049  11.00482   1.43957  -0.64093 12.95491 -4.81100;...
      -5.79756  -4.13020   0.23193   1.46214   1.88120  16.05066  0.38239  10.72108   1.38618  -1.29631  11.94630  -5.13566;...
      -5.79756  -4.13020   0.23193   1.46214   1.88120  16.05066  0.38239  10.72108   1.38618  -1.29631  11.94630  -5.13566;...
      -5.80063  -5.13575   0.23152   1.46217   1.88984  17.05394  1.38654  10.50482   1.38565  -1.29631  11.94567  -5.13575;...
      -5.80063  -5.13575   0.23152   1.46217   1.88984  17.05394  1.38654  10.50482   1.38565  -1.29631  11.94567  -5.13575;...
      -3.30077  -3.75520   0.23144   3.75072   2.19370  15.42601  0.41289  10.94623   1.38565  -1.26506  13.00126  -6.13549;...
      -3.30077  -3.75520   0.23144   3.75072   2.19370  15.42601  0.41289  10.94623   1.38565  -1.26506  13.00126  -6.13549;...
      -3.30077  -3.75520   0.23144   3.75072   2.19370  15.42601  0.41289  10.94623   1.38565  -1.26506  13.00126  -6.13549;...
      -5.80063  -5.13575   0.23152   1.46217   1.87921  16.05394  0.38654  10.94567   1.38565  -1.29631  11.94567  -5.13575;...
      -3.30077  -3.75520   0.23144   3.75072   2.19370  15.42601  0.41289  10.94623   1.38565  -1.26506  13.00126  -6.13549;...
      -3.30077  -3.75520   0.23144   3.75072   2.19370  15.42601  0.41289  10.94623   1.38565  -1.26506  13.00126  -6.13549;...
      -3.30077  -3.75520   0.23144   3.75072   2.19370  15.42601  0.41289  10.94623   1.38565  -1.26506  13.00126  -6.13549;...
      -5.79756  -3.75520   0.23144   2.46214   1.88120  15.42601  0.38239  10.94623   1.38618  -1.26506  13.00126  -6.13549;...
      -5.79756  -3.75520   0.23144   2.46214   1.88120  15.42601  0.38239  10.94623   1.38618  -1.26506  13.00126  -6.13549;...
      -5.79756  -3.75520   0.23144   2.46214   1.88120  15.42601  0.38239  10.94623   1.38618  -1.26506  13.00126  -6.13549...
      ];
    
    % Parallel setup
    clc
    
    % Put numbers in long format for printing
    format long;

    % random seed
    rng(80085);
    
% Options for ga only 
  
    gaoptions = gaoptimset('Display','iter','PopulationSize',30,'Generations',1500,...
    'StallTimeLimit',86400,'TimeLimit',360000,'MutationFcn',@mutationadaptfeasible,...
    'FitnessScalingFcn',@fitscalingrank,'InitialPopulation',inpop,'UseParallel','always',...
    'PlotFcns',@gaplotbestf,'EliteCount',0); 

  [X,fval,exitflag] = ga(@(X) distance(X),12,[],[],[],[],lowb, upb,[],gaoptions);

% To use fmincon only

%  X  = [-5.79756  -4.13020   0.23193   1.46214   1.88120  16.05066   0.38239  10.72108   1.38618  -1.29631  11.94630  -5.13566]; 
%  fminconoptions = optimset('Display','iter',10000,'DiffMinChange',1e-2,'UseParallel',1);%,'HybridFcn',{@fmincon,fminconoptions});
%  [X,fval,exitflag] = fmincon(@(X) distance(X),X,[],[],[],[],lowb, upb,[],fminconoptions);

% To use knitro only
% 
%  X = [-5.72446  -4.12239   0.23266   2.70436   2.16730  16.30953  0.42438  11.02430   1.39542  -1.29631  12.98462  -6.20709];
% [theta_out,fval]=knitrolink(@(X) distance(X),X,[],[],[],[],lowb,upb);

    % Save results
    save est_results_genetic;

