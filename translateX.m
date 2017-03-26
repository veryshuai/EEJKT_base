 XX = [6.61984 8.56381 0.41292  1.10981 1.41984 0.21571 4.20905 ...
      1.87329 0.20780 3.16470 -4.14745 3.78781 0.54715];


%% mapping 1, with some log transformations

new_scale_h    =  exp(XX(3));
new_F          =  exp(XX(1)+XX(3));
new_delta      =  XX(2);
new_scale_f    =  exp(XX(3) + XX(4));
new_beta       =  XX(5);
new_ah         =  exp(XX(7))*XX(6);  
new_bh         =  exp(XX(7))*(1-XX(6));
new_L_z        =  XX(8);
new_D_z        =  XX(9);
new_L_b        =  XX(10);
new_gam        =  XX(11)*(1+new_beta)/new_beta;
new_cs         =  exp(XX(12));
new_sig_p      =  XX(13);

%% mapping 2, uniform in levels

% scale_h    =  XXX(3);                home profit function scalar
% F          =  XXX(1)*XXX(3);         fixed cost per match
% delta      =  XXX(2);                exogenous match separation hazard
% scale_f    =  XXX(4)*XXX(3);         foreign profit function scalar
% beta       =  XXX(5);                cost function convexity
% ah         =  XXX(7)*XXX(6);         beta dist. success parameter
% bh         =  XXX(7)*(1-XXX(6));     beta dist. failure parameter
% L_z        =  XXX(8);                hazard, match shock
% D_z        =  XXx(9);                jump size, match shock
% L_b        =  XXX(10);               hazard, shipment order
% gam        =  XXX(11)*(1+beta)/beta; cost function, network effect
% cs         =  XXX(12)*XXX(3);        cost function scalar  
% sig_p      =  XXX(13);               Pareto parameter

XXX(3) = new_scale_h;
XXX(1) = new_F/XXX(3);
XXX(2) = new_delta;
XXX(4) = new_scale_f/XXX(3);
XXX(5) = new_beta;
XXX(6) = new_ah/(new_ah+new_bh);
XXX(7) = (new_ah+new_bh);
XXX(8) = new_L_z;
XXX(9) = new_D_z;
XXX(10) = new_L_b;
XXX(11) = new_gam*new_beta/(1+new_beta);
XXX(12) = new_cs/XXX(3);
XXX(13) = new_sig_p;

new2_scale_h    =  XXX(3);              
new2_F          =  XXX(1)*XXX(3);         
new2_delta      =  XXX(2);                
new2_scale_f    =  XXX(4)*XXX(3);         
new2_beta       =  XXX(5);                
new2_ah         =  XXX(7)*XXX(6);         
new2_bh         =  XXX(7)*(1-XXX(6));     
new2_L_z        =  XXX(8);                
new2_D_z        =  XXX(9);                
new2_L_b        =  XXX(10);               
new2_gam        =  XXX(11)*(1+new2_beta)/new2_beta; 
new2_cs         =  XXX(12)*XXX(3);           
new2_sig_p      =  XXX(13);               


%% correspondence check 1

diff = zeros(1,13);
diff(1) = new_scale_h - new2_scale_h;
diff(2) = new_F - new2_F;
diff(3) = new_delta - new2_delta;     
diff(4) = new_scale_f - new2_scale_f;   
diff(5) = new_beta - new2_beta;       
diff(6) = new_ah - new2_ah;        
diff(7) = new_bh - new2_bh;       
diff(8) = new_L_z - new2_L_z;
diff(9) = new_D_z - new2_D_z;       
diff(10) = new_L_b - new2_L_b;
diff(11) = new_gam - new2_gam;        
diff(12) = new_cs  - new2_cs;
diff(13) = new_sig_p - new2_sig_p;     

diff
ssr = diff*diff'

XXX