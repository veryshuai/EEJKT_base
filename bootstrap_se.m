% %This script bootstraps standard errors for EEJKT
% %
% % Three steps:
% % 1. Simulate moments to recover covariance
% % 2. Find dM/dP, the dependence of moments on parameters
% % 3. Combine to recover standard erros
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Simulate moments many times
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X = [ -4.60796  -3.75516   0.23144   2.46216   1.88125  15.42605...
%   0.38246  10.72145   1.38618  -1.26451  13.00227  -6.13504];
% 
% N_boot_sims = 100;
% 
% X2params;
% SetParams;
% inten_sim_v1;
% 
% %want different rands each time, set seed once here
% seed = 0;
% rng(80085,'twister');
% 
% Model_holder = zeros(38,N_boot_sims);
% 
% for k=1:N_boot_sims
% 
%     display(k);
%     
%     discrete_sim_parfor3;
%     
%     match_death_coefsSIM = [match_exit_rate;beta_match_exit(2:5)]; % [match exit rate, 1st yr. dummy, lnXf(ijt), ln(match age), ln(exporter age),mse]
%     match_ar1_coefsSIM   = [ybar_match;beta_match(2:4);mse_match_ar1]; % [mean ln Xf(ijt), ln Xf(ijt-1), R(ijt-1), ln(exporter age)]   
%     loglog_coefsSIM      = [b_degree]; % [intercept, slope, quadratic term]
%     mavshipSIM           = [avg_ln_ships]; % average ln(# shipments) 
%     exp_dom_coefsSIM     = [ybar_hfsales;beta_hfsales(2);mse_hf]; % [mean dep var.,coef,MSE]  
%     dom_ar1_coefsSIM     = [ybar_fsales_h;beta_fsales_h(2);mse_h]; % [mean dep var.,coef,MSE] 
%     match_lag_coefsSIM   = [mean_ln_haz;b_haz(2:6)]; % [mean dep. var, ln(1+a), ln(1+a)^2, ln(1+r), ln(1+r)^2, ln(1+a)*ln(1+r)] 
%     last_match_coefsSIM  = [mkt_exit_rate;beta_mkt_exit(2:6)]; % [mean dep. var, ln(1+a), ln(1+a)^2, ln(1+r), ln(1+r)^2, ln(1+a)*ln(1+r)]            
%     succ_rate_coefsSIM   = [mean_succ_rate;b_succ_rate(2)]; % [mean succ rate, ln(1+meetings)]
%     sr_var_coefsSIM      = [mean_usq_succ;b_usq_succ(2)]; % [mean dep. var, ln(1+meetings)]
%     for_sales_shrSIM     = [avg_expt_rate]; % mean share of exports to U.S. in total sales 
%     exp_fracSIM          = [share_exptr]; % fraction of firms exporting to U.S.  
% 
%     Model = cat(1,match_death_coefsSIM,match_ar1_coefsSIM,loglog_coefsSIM,...
%         mavshipSIM,exp_dom_coefsSIM,dom_ar1_coefsSIM,match_lag_coefsSIM,...   
%         last_match_coefsSIM,succ_rate_coefsSIM,sr_var_coefsSIM,for_sales_shrSIM,...    
%         exp_fracSIM);   
% 
%     Model_holder(:,k) = Model;
%     
% end
% 
% save results/boot_data_temp

%Now we recover the gradient of the moments with respect to parameter
%changes

load results/boot_data_temp

X2params;
param_vec = [scale_h,F_h,F_f,scale_f,ah,bh,D_z,L_b,gam,cs_h,cs_f,sig_p];
param_names = {'scale_h','F_h','F_f','scale_f','ah','bh','D_z','L_b','gam','cs_h','cs_f','sig_p'};

param_moments = zeros(size(Model,1),size(param_vec,2));
grad_del = 3e-1 * param_vec; %scale the delta used in gradient calculation to the size of the parameter

dMdP = zeros(size(param_moments));

for loop_ind = 0:size(X,2)

    %make a small change to param_vec
    param_vec_new = param_vec;
    if loop_ind ~= 0
        param_vec_new(loop_ind) = param_vec(loop_ind) + grad_del(loop_ind);
    end
    pCell = num2cell(param_vec_new); 
    [scale_h,F_h,F_f,scale_f,ah,bh,D_z,L_b,gam,cs_h,cs_f,sig_p] = pCell{:}; %insane that there is no better way to assign vector values to variables
    %sig_p = param_vec_new(end);

    %don't want randomness driving results
    %NOTE THIS IS HARD CODED IN DISCRETE SIM AT THE MOMENT, MUST MANUALLY
    %CHECK
    seed = 1;
    rng(80085,'twister');
    seed_crand(80085);
    
    %generate moments
    SetParams;
    inten_sim_v1;
    discrete_sim_parfor3;
    
    match_death_coefsSIM = [match_exit_rate;beta_match_exit(2:5)]; % [match exit rate, 1st yr. dummy, lnXf(ijt), ln(match age), ln(exporter age),mse]
    match_ar1_coefsSIM   = [ybar_match;beta_match(2:4);mse_match_ar1]; % [mean ln Xf(ijt), ln Xf(ijt-1), R(ijt-1), ln(exporter age)]   
    loglog_coefsSIM      = [b_degree]; % [intercept, slope, quadratic term]
    mavshipSIM           = [avg_ln_ships]; % average ln(# shipments) 
    exp_dom_coefsSIM     = [ybar_hfsales;beta_hfsales(2);mse_hf]; % [mean dep var.,coef,MSE]  
    dom_ar1_coefsSIM     = [ybar_fsales_h;beta_fsales_h(2);mse_h]; % [mean dep var.,coef,MSE] 
    match_lag_coefsSIM   = [mean_ln_haz;b_haz(2:6)]; % [mean dep. var, ln(1+a), ln(1+a)^2, ln(1+r), ln(1+r)^2, ln(1+a)*ln(1+r)] 
    last_match_coefsSIM  = [mkt_exit_rate;beta_mkt_exit(2:6)]; % [mean dep. var, ln(1+a), ln(1+a)^2, ln(1+r), ln(1+r)^2, ln(1+a)*ln(1+r)]            
    succ_rate_coefsSIM   = [mean_succ_rate;b_succ_rate(2)]; % [mean succ rate, ln(1+meetings)]
    sr_var_coefsSIM      = [mean_usq_succ;b_usq_succ(2)]; % [mean dep. var, ln(1+meetings)]
    for_sales_shrSIM     = [avg_expt_rate]; % mean share of exports to U.S. in total sales 
    exp_fracSIM          = [share_exptr]; % fraction of firms exporting to U.S.  

    Model = cat(1,match_death_coefsSIM,match_ar1_coefsSIM,loglog_coefsSIM,...
        mavshipSIM,exp_dom_coefsSIM,dom_ar1_coefsSIM,match_lag_coefsSIM,...   
        last_match_coefsSIM,succ_rate_coefsSIM,sr_var_coefsSIM,for_sales_shrSIM,...    
        exp_fracSIM);
    
    if loop_ind == 0
        base_moments = Model;
    else
        param_moments(:,loop_ind) = Model;

        dMdP(:,loop_ind) = (param_moments(:,loop_ind) - base_moments) / grad_del(loop_ind);
    end
end

Mcov = cov(Model_holder');

G = -dMdP; %just change the notation to fit Joris' note 

[Data, W_inv] = target_stats(); %load in the weighting matrix
W = inv(W_inv);

V_bootstrap_raw = inv(G' * W * G) * G' * W * Mcov * W * G * inv(G' * W * G);
V_simple = inv(G' * W * G);

%read in missing weighting matrix entries with bootstrapped moments
weighting_mat_mean = mean(diag(W_inv));
Mcov_mean = mean(diag(Mcov)); %only use the non-zzero entries in the weighting matrix
Mcov_adjust = Mcov * weighting_mat_mean / Mcov_mean;
W_inv_adj = W_inv;
W_inv_adj(W_inv == 0) = Mcov_adjust(W_inv == 0);
W_adj = inv(W_inv_adj);
V_adj = inv(G' * W_adj * G);

AGS_sens = -inv(G' * W_adj * G) * G' * W_adj;

AGS_elas = AGS_sens .* repmat((W_adj * base_moments)',size(AGS_sens,1),1) ./ repmat(param_vec',1,size(AGS_sens,2));

stderr = sqrt(diag(V_adj));
se_table = table(param_names',param_vec',stderr);

save results/bootstrap_results


