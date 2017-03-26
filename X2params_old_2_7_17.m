%% 
%  This file takes an X vector passed by the optimizaiton program
%  and turns it into parameters used in our simulation

%read in parameter names from the X vector

scale_h    =  exp(X(3));
F          =  exp(X(1)+X(3));
delta      =  X(2);
scale_f    =  exp(X(3) + X(4));
beta       =  X(5);
ah         =  exp(X(7))*X(6);  
bh         =  exp(X(7))*(1-X(6));
L_z        =  X(8);
D_z        =  X(9);
L_b        =  X(10);
gam        =  X(11)*(1+beta)/beta;
cs         =  exp(X(12));
sig_p      =  X(13);

%% parameters no longer used that still require values

ag         =  .5;
bg         =  .5;
L_p        =  0;
D_p        =  0;
alp        =  0;
