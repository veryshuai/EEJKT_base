function [data_moms,data_cov] = target_stats_brooks()
    

aggs_by_age = [1 1 1 1;...
2  0.29 1.11 3.77;...
3  0.18 0.93 5.03;...
4  0.14 0.67 4.66;...
5  0.12 0.63 5.18;...
6  0.10 0.51 4.99;...
7  0.08 0.50 5.72;...
8  0.08 0.45 5.91;...
9  0.07 0.39 5.58;...
10 0.06 0.40 6.58];
% aggs_by_age: [cohort age, # exporters, total exports, avg. exports]
% figures are normalized relative to values for 1 year-old cohort.
cohort_aggsDAT = reshape(aggs_by_age(2:10,2:4),27,1);

match_death = [...
1 82.9 75.6 67.7 52.1;...
2 63.2 58.4 52.1 44.5;...
3 57.3 49.4 44.6 40.3;...
4 55.0 46.8 40.8 39.2;...
5 49.7 43.7 37.6 36.7];
% match_death = [match age, Q1 death rate, Q2 death rate, Q3 death rate, Q4 death rate]
match_drateDAT = reshape(match_death(:,2:5),20,1)./100;

degree_dist =...
[1 0.792; 2 0.112; 3 0.031; 4 0.016; 5 0.0099; 6 0.022; 7 0.016];
% degree_dist: [at least X clients, fraction of pop.]
% category 6 is 6-10 clients; category 7 is at least 10 clients
degree_distDAT = degree_dist(:,2);

match_ar1_coefsDAT   = [10.6653 0.82637 0.32834 0.06312 1.20786^2]; % [mean ln Xf(ijt), ln Xf(ijt-1), R(ijt-1), ln(exporter age),MSE]   
mavshipDAT           = 0.9706402010; % average ln(# shipments) 
exp_dom_coefsDAT     = [9.1770 ,0.3228142,2.606^2]; % [mean dep var.,coef,MSE]  
dom_ar1_coefsDAT     = [10.8038,0.9764422,0.46207^2]; % [mean dep var.,coef,MSE] 
ln_haz_coefsDAT      = -0.7188; % [mean dep. var]
succ_rate_coefsDAT   = [0.413,0.093];  % [mean succ rate, ln(1+meetings)]
sr_var_coefsDAT      = [0.0912,-0.060]; % [mean succ rate, ln(1+meetings)]
for_sales_shrDAT     =  0.1270; % mean share of exports to U.S. in total sales 
exp_fracDAT          =  0.1023; % fraction of firms that export to U.S.

   
 data_moms = [cohort_aggsDAT',match_drateDAT',degree_distDAT',match_ar1_coefsDAT,mavshipDAT,exp_dom_coefsDAT,...
    dom_ar1_coefsDAT,ln_haz_coefsDAT,succ_rate_coefsDAT,sr_var_coefsDAT,for_sales_shrDAT,exp_fracDAT];

%% covariance matrices--covariances 

% cohort age
cohort_size = [1052; 303; 193; 148; 124; 102; 89; 80; 73; 62];
agg_var = 1./cohort_size(2:10,1);
cohort_aggsCOV = diag(kron(ones(3,1),agg_var));
cohort_aggsCOV = 0.1*cohort_aggsCOV/trace(cohort_aggsCOV);


% match death rates
match_count = ones(5,4);
for j = 2:5
    match_count(j,:) = match_count(j-1,:).*match_death(j-1,2:5)/100;
end
mc_var = 1./match_count;
match_drateCOV = diag([mc_var(:,1);mc_var(:,2);mc_var(:,3);mc_var(:,4)]);
match_drateCOV = 0.0001*match_drateCOV/trace(match_drateCOV);

% degree dist.
degree_distCOV = diag(1./degree_distDAT);
degree_distCOV = 0.0001*degree_distCOV/trace(degree_distCOV);


% match AR1
    match_ar1_coefsCOV = ...
     [0.002362705419  0.000000000000  0.000000000000  0.000000000000  0       ;
      0.000000000000  0.000014721579  0.000014300618 -0.000004772804  0       ;
      0.000000000000  0.000014300618  0.000332671396  0.000124115947  0       ;
      0.000000000000 -0.000004772804  0.000124115947  0.000193084788  0       ;
      0               0               0               0               0.00012];

    mavshipCOV = 0.00415553^2;  % note that I squared the standard error here

 % The following two matrices come from Marcela's printout (DIAN only 21 Feb. 2013)

    exp_dom_coefsCOV = ...
      [0.0133969  0             0       ;     % first element is std. dev. of mean of dep. var
       0           0.0120728    0       ;     % 2.537503/sqrt(35877) = 0.0133969
       0           0            0.089016].^2; % see notes on printout for se(RSME)

    dom_ar1_coefsCOV = ...
       [0.0050684   0           0        ;    % first element is std. dev. of mean of dep. var
        0           0.0008622   0        ;    % 1.718554/sqrt(114968) = 0.0050684
        0           0           0.000958].^2; % see notes on printouts for se(RSME)
      
% The following matrices are based on U.S. customs records. 

   ln_haz_coefsCOV = 0.00621^2; %Results disclosed 5-7-19

   succ_rate_coefsCOV = ...  % based on RDC disclosure 2-3-17
       [0.00153^2   0.00000000 ;
        0.00000000  0.00000683];
 
   sr_var_coefsCOV = ...    % based on RDC disclosure 2-3-17 & 5-07-19
       [0.000265^2  0.00000000;
        0.00000000  0.00000012];
  
   for_sales_shrCOV = (.2433645^2)/12512;   % from Marcela's eam_moms_out.pdf 
   
   exp_fracCOV      = (.3030042^2)/11930;  % from Marcela's eam_moms_out.pdf

data_cov = blkdiag(cohort_aggsCOV,match_drateCOV,degree_distCOV,match_ar1_coefsCOV,mavshipCOV,exp_dom_coefsCOV,dom_ar1_coefsCOV,...
    ln_haz_coefsCOV,succ_rate_coefsCOV,sr_var_coefsCOV,for_sales_shrCOV,exp_fracCOV);
