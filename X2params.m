%% 
%  This file takes an X vector passed by the optimizaiton program
%  and turns it into parameters used in our simulation

%read in parameter names from the X vector

%% previous mapping

% scale_h    =  exp(X(3));
% F          =  exp(X(1)+X(3));
% delta      =  X(2);
% scale_f    =  exp(X(3) + X(4));
% beta       =  X(5);
% ah         =  exp(X(7))*X(6);  
% bh         =  exp(X(7))*(1-X(6));
% L_z        =  X(8);
% D_z        =  X(9);
% L_b        =  X(10);
% gam        =  X(11)*(1+beta)/beta;
% cs         =  exp(X(12));
% sig_p      =  X(13);

%% current mapping 

scale_h    =  X(3);              
F          =  X(1)*X(3);         
delta      =  X(2);                
scale_f    =  X(4)*X(3);         
beta       =  1 / (X(5) - 1);                
ah         =  X(7)*X(6); %X(6) is mean of beta dist ah / (ah + bh)
bh         =  X(7)*(1-X(6)); %X(7) is (ah + bh)
L_z        =  X(8);                
D_z        =  X(9);                
L_b        =  X(10);               
gam        =  X(11);
cs         =  X(12)*X(3);           
sig_p      =  X(13); %shape parameter, with scale parameter scaled so that mean of prod. dist = 1 

%% parameters no longer used that still require values

ag         =  .5;
bg         =  .5;
L_p        =  0;
D_p        =  0;
alp        =  0;
