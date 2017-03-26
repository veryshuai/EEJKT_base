function [] = calibration_noprod(pop, varargin)
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
    if rst == 1
        rst_type = query(['Which type of parameter restriction?' char(10) 'nln (no learning)' char(10) 'nnt (no network effect)?'],{'nln','nnt'});
    elseif rst == 2
        rst_type = 'nnt' %set no network
    elseif rst == 3
        rst_type = 'nln' %set no learning
    end


    % Parallel setup
    clc

    
    % Start timer
    tic;
    
    % Put numbers in long format for printing
    format long;
    
    % Read params
    params 

    % random seed
    rng(80085);
    
    % Options for genetic algorithm
    gaoptions = gaoptimset('Display','iter','PopulationSize',26,'Generations',1000,...
    'StallTimeLimit',86400,'TimeLimit',360000,'MutationFcn',@mutationadaptfeasible,...
    'FitnessScalingFcn',@fitscalingrank,'InitialPopulation',pop,'UseParallel','always',...
    'PlotFcns',@gaplotbestf,'EliteCount',0);%,'HybridFcn',{@fmincon,fminconoptions});

    % Network parameter restrictions 
    net_lb =  -10;
    net_ub =   10;
    if rst_type == 'nnt'
        net_lb = 0;
        net_ub = 0;
    end 
    
    % Call genetic algorithm routine
    [X,fval,exitflag] = ga(@(X) distance_noprod(X, 0, 1),13,[],[],[],[],...
   [0.001;   0.001;  0.001;  0.001; 1.001; 0.001;   0.1; 0.001;  0.001; 0.001; net_lb; 0.001; 0.001],...
   [   10;    10.0;    100;    100;   100; 0.999;  100.0;   100;    10; 100.0; net_ub; 100;   0.999],[],gaoptions); 
  %    X1     X2       X3       X4     X5    X6     X7       X8     X9    X10     X11   X12    X13

% scale_h =  X(3);                
% F       =  X(1)*X(3);           
% delta   =  X(2);                
% scale_f =  X(4)*X(3);           
% beta    =  1/(X(5)-1);                
% ah      =  X(7)*X(6);           
% bh      =  X(7)*(1-X(6));       
% L_z     =  X(8);                
% D_z     =  X(9);                
% L_b     =  X(10);               
% gam     =  X(11); 
% cs      =  X(12)*X(3);          
% sig_p   =  X(13);   
  
    % End timer
    toc
    
    % Close parallel
    matlabpool close
    
    % Save results
    save est_results;
end
