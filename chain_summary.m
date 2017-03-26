clear all;
% load 'results/chain.mat'

  load 'results_a/chain.mat'
  cumvec1 = cumvec;
  load 'results_b/chain.mat'
  cumvec = cat(1,cumvec1,cumvec);


indx    = cumvec(:,1);
X       = cumvec(:,2:14);
[nn,nc] = size(X);
theta   = zeros(nn,nc);


%% mapping from 2-10-17

% scale_h   =  X(:,3);              
% F         =  X(:,1).*X(:,3);         
% delta     =  X(:,2);                
% scale_f   =  X(:,4).*X(:,3);         
% kappa_1   =  X(:,5);                
% alpha     =  X(:,7).*X(:,6);         
% beta      =  X(:,7).*(1-X(:,6));     
% L_z       =  X(:,8);                
% D_z       =  X(:,9);                
% L_b       =  X(:,10);               
% gam       =  X(:,11).*(1+kappa_1)./kappa_1; 
% kappa_0   =  X(:,12).*X(:,3);           
% sig_p     =  X(:,13);   

%% mapping from 3-12-17
scale_h =  X(:,3);                
F       =  X(:,1).*X(:,3);           
delta   =  X(:,2);                
scale_f =  X(:,4).*X(:,3);           
kappa_1 =  1./(X(:,5)-1);                
alpha   =  X(:,7).*X(:,6);           
beta    =  X(:,7).*(1-X(:,6));       
L_z     =  X(:,8);                
D_z     =  X(:,9);                
L_b     =  X(:,10);               
gam     =  X(:,11); 
kappa_0 =  X(:,12).*X(:,3);          
sig_p   =  X(:,13);  

%% mapping to theta

theta(:,1)  = scale_h;   
theta(:,2)  = F;          
theta(:,3)  = delta;      
theta(:,4)  = scale_f;    
theta(:,5)  = kappa_1;       
theta(:,6)  = alpha;           
theta(:,7)  = beta;         
theta(:,8)  = L_z;       
theta(:,9)  = D_z;       
theta(:,10) = L_b;       
theta(:,11) = gam;        
theta(:,12) = kappa_0;        
theta(:,13) = sig_p;     
%% construct transformations of interest

convx = X(:,5);
succrate = theta(:,6)./(theta(:,6)+theta(:,7));

%% graph the markov chain

% theta = theta(1000:nn,:);

figure(1)
subplot(3,1,1)
plot(theta(:,1))
ylabel('$\Pi _{h}$','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('home profit function scalar')
hold on
subplot(3,1,2)
plot(theta(:,4))
ylabel('$\Pi _{f}$','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('foreign profit function scalar')
subplot(3,1,3)
plot(theta(:,12))
ylabel('$\kappa _{0}$','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('cost function scalar')
hold off

figure(2)
subplot(2,1,1)
plot(theta(:,2))
ylabel('F','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('fixed cost per relationship')
hold on
subplot(2,1,2)
plot(theta(:,3))
ylabel('$\delta $','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('Match separation hazard')
hold off

figure(3)
subplot(2,1,1)
convx = 1 + (1./theta(:,5));
plot(convx)
ylabel('$1+1/\kappa _{1}$','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('cost function convexity')
subplot(2,1,2)
plot(theta(:,11))
ylabel('$\gamma $','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('network effect')
hold off

figure(4)
subplot(3,1,1)
plot(theta(:,6))
ylabel('$\alpha$','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('success rate distribution parameter 1')
hold on
subplot(3,1,2)
plot(theta(:,7))
ylabel('$\beta$','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('success rate distribution parameter 2')

subplot(3,1,3)
plot(succrate)
ylabel('$\alpha /(\alpha +\beta )$','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('prior success rate')
hold off

figure(5)
subplot(3,1,1)
plot(theta(:,8))
ylabel('$\lambda _{z}$','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('jump hazard, match shock')
hold on
subplot(3,1,2)
plot(theta(:,9))
ylabel('$\Delta _{z}$','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('jump size, match shock')
subplot(3,1,3)
plot(theta(:,10))
ylabel('$\lambda ^{b}$','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('shipment hazard')
hold off

figure(6)
plot(theta(:,13))
ylabel('shape parameter','Interpreter','latex','FontSize',12,'FontWeight','bold');
title('productivity distribution parameter')

%% construct percentiles of parameter distributions, dropping burn-in

burn = 1000; % set burn-in length
theta = theta(burn:nn,:);
convx = convx(burn:nn,:);
succrate = succrate(burn:nn,:);

Z = prctile(theta,[5 50 95],1); 
convx_centile = prctile(convx,[5,50,95],1);
succrt_centile = prctile(succrate,[5,50,95],1);

'                     5th %    median    95th %'
fprintf('        scale_h: %9.5f %9.5f %9.5f ',Z(:,1)');
fprintf('\r\n              F: %9.5f %9.5f %9.5f ',Z(:,2)');
fprintf('\r\n          delta: %9.5f %9.5f %9.5f ',Z(:,3)');
fprintf('\r\n        scale_f: %9.5f %9.5f %9.5f ',Z(:,4)');
fprintf('\r\n        kappa_1: %9.5f %9.5f %9.5f ',Z(:,5)');
fprintf('\r\n          alpha: %9.5f %9.5f %9.5f ',Z(:,6)');
fprintf('\r\n           beta: %9.5f %9.5f %9.5f ',Z(:,7)');
fprintf('\r\n   jump hazz, z: %9.5f %9.5f %9.5f ',Z(:,8)');
fprintf('\r\n        delta z: %9.5f %9.5f %9.5f ',Z(:,9)');
fprintf('\r\n  shipment hazz: %9.5f %9.5f %9.5f ',Z(:,10)');
fprintf('\r\n          gamma: %9.5f %9.5f %9.5f ',Z(:,11)');
fprintf('\r\n        kappa_0: %9.5f %9.5f %9.5f ',Z(:,12)');
fprintf('\r\n    prod. param: %9.5f %9.5f %9.5f ',Z(:,13)');
fprintf('\r\n');
fprintf('\r\n    cost convex: %9.5f %9.5f %9.5f ',convx_centile');
fprintf('\r\n prior succ. rt: %9.5f %9.5f %9.5f ',succrt_centile');
fprintf('\r\n');

mn_theta = mean(theta);
z_theta  = mn_theta./sqrt(var(theta));
mn_X = mean(X);
z_X  = mn_X./sqrt(var(X));
