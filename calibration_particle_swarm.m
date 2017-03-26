function [] = calibration(pop, varargin)
%This function initiates the genetic algorithm to solve for
%the parameters of the model.  Initial parameter guesses can be set here,
%as well as optional settings for the genetic algorithm.

    % set defaults for optional inputs
    optargs = {0};

    % overwrite defaults with user input
    numvarargs = size(varargin, 2);
    optargs(1:numvarargs) = varargin;

    % memorable variable names
    rst = optargs{1}; % parameter restriction?

    % what type of parameter restriction?
    rst_type = 'non';
    cf_num = 0; % This typically controls whether we are running a simulation, or a counterfactual exercise.  It is carried through the simulation routine, so we use it here as a flag in the no_learning model
    if rst == 1
        rst_type = query(['Which type of parameter restriction?' char(10) 'nln (no learning)' char(10) 'nnt (no network effect)?'],{'nln','nnt'});
    elseif rst == 2
        rst_type = 'nnt'; %set no network
    elseif rst == 3
        rst_type = 'nln'; %set no learning
        cf_num = 9; %Flag no learning in simulation
    end

    % Parallel setup
    clc
%     if matlabpool('size')~=4 %if pool not equal to 12, open 12
%        if matlabpool('size')>0
%          matlabpool close
%        end
%        matlabpool open 4 
%     end
    
    % Start timer
    tic;
    
    % Put numbers in long format for printing
    format long;
    % Read params
    params 

    % random seed
    rng(80085);
    
    % Options for genetic algorithm without fmincon finish

%     options = gaoptimset('Display','iter','PopulationSize',26,'Generations',1000,...
%     'StallTimeLimit',86400,'MutationFcn',@mutationadaptfeasible,...
%     'FitnessScalingFcn',@fitscalingrank,'InitialPopulation',pop,'UseParallel','always',...
%     'PlotFcns',@gaplotbestf,'EliteCount',1);  %,'HybridFcn',{@fmincon,fminconoptions});

%  fminconoptions = optimset('Display','iter','DiffMinChange',1e-3);%,'HybridFcn',{@fmincon,fminconoptions});

   fminconoptions = optimset('Display','iter','DiffMinChange',1e-2,'UseParallel',1);%,'HybridFcn',{@fmincon,fminconoptions});

 % Options for starting with ga, then calling fmincon  
   
%    gaoptions = gaoptimset('Display','iter','PopulationSize',26,'Generations',1000,...
%      'StallTimeLimit',86400,'MutationFcn',@mutationadaptfeasible,...
%      'FitnessScalingFcn',@fitscalingrank,'InitialPopulation',pop,'UseParallel','always',...
%      'PlotFcns',@gaplotbestf,'EliteCount',0,'HybridFcn',{@fmincon,fminconoptions});

  % Options for ga only 
  
    gaoptions = gaoptimset('Display','iter','PopulationSize',26,'Generations',1500,...
    'StallTimeLimit',86400,'MutationFcn',@mutationadaptfeasible,...
    'FitnessScalingFcn',@fitscalingrank,'InitialPopulation',pop,'UseParallel','always',...
    'PlotFcns',@gaplotbestf,'EliteCount',0);  

    particle_swarm_options = optimoptions('particleswarm','SwarmSize',26,...
    'InitialSwarmMatrix',pop,'UseParallel', 'always','HybridFcn',{@fmincon,fminconoptions});  
 
    % Network parameter restrictions 
    net_lb = -2.0;
    net_ub =  0.7;
    if rst_type == 'nnt'
        net_lb = 0;
        net_ub = 0;
    end 
    
    % set up problem object for particle swarm
    problem_particleswarm = struct('solver','particleswarm','objective',@(X) distance_noprod(X, cf_num, 1),'nvars',13,'lb',...
[0.800;  0.4;    2.0;    0.4;  .005; 0.05;  4.0;  0.005; 0.005;  0.5; net_lb;   10; 0.01],...
'ub',...
[8.000;  2.0;   12.0;    2.0; 0.500; 0.99; 25.0;  8.000; 1.000; 20.0; net_ub;  250; 2.00],...
'options',particle_swarm_options);

    % set up problem object for multistart
    problem_multistart = createOptimProblem('fmincon','objective',@(X) distance_noprod(X, cf_num, 1),'x0',X,'lb',...
[0.800;  0.4;    2.0;    0.4;  .005; 0.05;  4.0;  0.005; 0.005;  0.5; net_lb;   10; 0.01],...
'ub',...
[8.000;  2.0;   12.0;    2.0; 0.500; 0.99; 25.0;  8.000; 1.000; 20.0; net_ub;  250; 2.00],...
'options',fminconoptions);

% To use fmincon only

% [X,fval,exitflag] = fmincon(@(X) distance_noprod(X, cf_num, 1),X,[],[],[],[],...
% [0.800;  0.4;    2.0;    0.4;  .005; 0.05;  4.0;  0.005; 0.005;  0.5; net_lb;   10; 0.01],...
% [8.000;  2.0;   12.0;    2.0; 0.500; 0.99; 25.0;  8.000; 1.000; 20.0; net_ub;  250; 2.00],[],fminconoptions);
  
%  To start with ga

%[X,fval,exitflag] = ga(@(X) distance_noprod(X, cf_num, 1),13,[],[],[],[],...
%[0.800;  0.4;    2.0;    0.4;  .005; 0.05;  4.0;  0.005; 0.005;  0.5; net_lb;   10; 0.01],...
%[8.000;  2.0;   12.0;    2.0; 0.500; 0.99; 25.0;  8.000; 1.000; 20.0; net_ub;  250; 2.00],[],gaoptions);

% To start with particleswarm
[X,fval,exitflag] = particleswarm(problem_particleswarm);

% To start with multistart
%run(multi_start_object,problem_multistart,5000); % last number is number of vectors to try

%   X1    X2      X3      X4     X5   X6    X7      X8     X9   X10     X11   X12    X13

    % lnF         =  scale_h+log(X(1));
    % delta       =  X(2);
    % scale_h     =  X(3);
    % scale_f     =  scale_h + log(X(4));
    % beta        =  X(5);
    % a           =  X(6)*X(7);
    % b           =  X(7)*(1-X(6));
    % L_z         =  X(8);
    % D_z         =  X(9);
    % L_b         =  X(10);
    % gam         =  X(11)*(1+beta)/beta;
    % cost scalar =  X(12);
    % sig p       =  X(13);
    % End timer
    toc

  
    % Save results
    save est_results_particle_swarm;

end
