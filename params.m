% This file holds parameter values for use in running search and learning model code

% Link between X parameter values and parameters used in the model

% scale_h =  X(3);                home profit function scalar
% F       =  X(1)+X(3);           fixed cost per match
% delta   =  X(2);                exogenous match separation hazard
% scale_f =  X(4)+X(3);           foreign profit function scalar
% beta    =  X(5);                cost function convexity
% ah      =  X(7)*X(6);           beta dist. success parameter
% bh      =  X(7)*(1-X(6));       beta dist. failure parameter
% L_z     =  X(8);                hazard, match shock
% D_z     =  X(9);                jump size, match shock
% L_b     =  X(10);               hazard, shipment order
% gam     =  X(11)*(1+beta)/beta; cost function, network effect
% cs      =  X(12)+X(3);          cost function scalar  
% sig_p   =  X(13);               Pareto parameter
    
% for scripts that take a single parameter vector
 X = [0.07435   1.96853   1.28965   1.97301   4.27068   0.49133  56.74159 ...
      76.83565   0.61389  97.11336  -1.38562   0.82051   0.45380];

% for scripts that take multiple parameter vectors
pop = [...
%   5.51301   3.97805   0.53909   5.56393   0.30171   0.50289  60.28499  78.14594   0.45137  90.18291  -7.04802   2.02773   0.90473;...
%   5.51301   3.97805   1.00000   5.56393   0.30171   0.50289  60.28499  78.14594   0.45137  90.18291  -7.04802   2.02773   0.90473;...
%   0         1.00000   1.00000   -2.0000   0.29321  20.62624  78.38860  20.00000   0.45380  90.82833  -6.07644         0   0.91071;...  
    0.0217    2.0164    7.3739   20.5558    4.4678    0.6845    3.2053   82.5906    0.3905   92.0960  -26.9968     9.2309    0.7207;...
  ];

 
