% This script translates starting values from the pre-3-12-17 mapping
% for use in the post-3-12-17 version of the code.

%  X =  [8.17138   0.50630   1.93120   0.08800   0.05256   0.17928   4.27533 ...
%        0.27685   1.94981   4.49890  -3.53790   5.38094   0.26983];
    
 X = [0.07861   2.00147   1.99789   2.51267   0.28871   0.68407   3.20415 ...
     82.58994   0.39032  92.09455  -6.04260   9.23057   0.72034]; % fit: 788428.946

scale_h =  zeros(1,2);  %  home profit function scalar
F       =  zeros(1,2);  %  fixed cost per match
delta   =  zeros(1,2);  %  exogenous match separation hazard
scale_f =  zeros(1,2);  %  foreign profit function scalar
beta    =  zeros(1,2);  %  cost function convexity
ah      =  zeros(1,2);  %  beta dist. success parameter
bh      =  zeros(1,2);  %  beta dist. failure parameter
L_z     =  zeros(1,2);  %  hazard, match shock
D_z     =  zeros(1,2);  %  jump size, match shock
L_b     =  zeros(1,2);  %  hazard, shipment order
gam     =  zeros(1,2);  % cost function, network effect
cs      =  zeros(1,2);  % cost function scalar  
sig_p   =  zeros(1,2);  % Pareto parameter  
  
% mapping from 3-11-17

scale_h(1) =  exp(X(3));           
F(1)       =  exp(X(1)*X(3));           
delta(1)   =  X(2);                
scale_f(1) =  exp(X(4)*X(3));      
beta(1)    =  X(5);                
ah(1)      =  X(7)*X(6);           
bh(1)      =  X(7)*(1-X(6));       
L_z(1)     =  X(8);                
D_z(1)     =  X(9);                
L_b(1)     =  X(10);               
gam(1)     =  X(11)*(1+beta)/beta; 
cs(1)      =  X(12)*X(3);          
sig_p(1)   =  X(13);               

% translation to new vector based on 3-12-17 mapping

Y(2)  = X(2);
Y(3)  = exp(X(3));
Y(1)  = exp(X(1)*X(3))/exp(X(3));
Y(4)  = exp(X(3)*X(4))/Y(3);
Y(5)  = (1+X(5))/X(5);
Y(6)  = X(6);
Y(7)  = X(7);
Y(8)  = X(8);
Y(9)  = X(9);
Y(10) = X(10);
Y(11) = X(11)*(1+X(5))/X(5);
Y(12) = X(12);
Y(13) = X(13);

% check mapping from 3-12-17
   
scale_h(2) =  Y(3);                
F(2)       =  Y(1)*Y(3);           
delta(2)   =  Y(2);                
scale_f(2) =  Y(4)*Y(3);           
beta(2)    =  1/(Y(5)-1);                
ah(2)      =  Y(7)*Y(6);           
bh(2)      =  Y(7)*(1-Y(6));       
L_z(2)     =  Y(8);                
D_z(2)     =  Y(9);                
L_b(2)     =  Y(10);               
gam(2)     =  Y(11); 
cs(2)      =  Y(12)*Y(3);          
sig_p(2)   =  Y(13);         

