function [] = calibration_multistart2(pop, varargin)
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
    clc;
    
    % Start timer
    tic;
    
    % Put numbers in long format for printing
    format long;
    % Read params
    params 

    % random seed
    rng(80085);
    
    fminconoptions = optimoptions('fmincon','Display','iter','DiffMinChange',1e-2,'UseParallel',1,'OptimalityTolerance',1e-3,'StepTolerance',1e-4);%,'HybridFcn',{@fmincon,fminconoptions});
  
    % Options for multistart only 
    multi_start_object = MultiStart('Display','iter','UseParallel',1);
 
    % Network parameter restrictions 
    net_lb = -5.0;
    net_ub =  5.0;
    if rst_type == 'nnt'
        net_lb = 0;
        net_ub = 0;
    end 

    % set up problem object for multistart
    problem_multistart = createOptimProblem('fmincon','objective',@(X) distance_noprod(X, cf_num, 1),'x0',X,...
'lb',[0.800;   0.1;    1.0;   0.1;  .001; 0.05;  2.0;  0.005; 0.005;  0.5; net_lb;   1; 0.0001],...
'ub',[12.000;  2.0;   12.0;   2.0; 0.500; 0.99; 100.0; 15.000; 1.000; 20.0; net_ub;  400; 0.4999],...
'options',fminconoptions);

    % 7.184   0.499  8.315   0.966 0.449  0.427 61.215 1.392  0.447  3.947 -1.142  83.215  1.379;...% 206836, 0.67
    % 3.370   0.581  2.325   1.323 0.491  0.561 13.49  3.072  0.035  9.305 -0.242  7.757   0.456;...% 117806, 0.89
    % 3.664   0.930  3.680   0.480 0.202  0.612 41.320 1.980  0.257  5.647  0.014  99.730  1.090;..
    % 3.664   0.930   3.68    0.48 0.202  0.612 41.32  1.98   0.257  5.647  0.014  99.73  1.09;...% 83,960 (no trace normalization) 
    % 4.507   1.18    5.83    1.18 0.006  0.69  24.86  7.99   0.258  7.416 -0.367   5.08  0.94;...%  11,387 
    % 6.863   0.50    4.74    1.25 0.092  0.55   7.00  4.85   0.131  5.306 -0.918  15.58  0.12;...% ~14,500
    % 4.241   0.48    5.71    0.90 0.082  0.98   2.00  3.37   0.567  2.188 -2.839 155.04  0.57;...% ~12,000  



% To start with multistart
run(multi_start_object,problem_multistart,1000); % last number is number of vectors to try

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
    save est_results_multistart;

end
