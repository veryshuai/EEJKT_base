function [Data, W] = target_stats()
% returns the data statistics used in the loss function

    %% TARGETS (ALL REGRESSION COEFFICIENTS, CJ system of equations May 12 COMPLETE.pdf, from email from Jim on May 13)
 %  cli_coefsDAT = [0.04783 0.02771 0.23173 0.24793 0.01436 0.05980];
    match_death_coefsDAT = [0.79447 0.03421 -0.03163 -0.05370 -0.02778];

 %  exp_sales_coefsDAT = [9.80376 -1.06980 0.28000 0.43155]; % careful--these orders do not match those in text table
    match_ar1_coefsDAT = [1.59164 0.82637 0.32834 0.06312 1.20786^2];  % careful--these orders do not match those in text table
    
    loglog_coefsDAT = [0.02116 -1.88130 -0.05446];
    mavshipDAT = 0.9706402010; % average in logs

    exp_dom_coefsDAT = [1.502486,0.7268059,2.1665^2]; %regression coefficients in Marcela's email of 3-22-2013, eam_moms_out( DIAN only 21 Feb 2013).log, [constant,coef,root MSE]
    dom_ar1_coefsDAT = [0.3380132,0.9764422,0.46207^2]; %regression coefficients in Marcela's email of 3-22-2013, eam_moms_out( DIAN only 21 Feb 2013).log, [constant,coef,root MSE]

    match_lag_coefsDAT  = [-0.3258+log(12),-0.8181,0.3117,-1.1323,2.4514,-0.7082 ]; %regression coefficients from US customs records, disclosed 12-12-16
    last_match_coefsDAT = [0.8397,-0.6290,0.1205,0.0211,0.5976,-0.1290];           %regression coefficients from US customs records, disclosed 12-12-16 

    succ_rate_coefsDAT = [0.3835,0.0207]; 
    sr_var_coefsDAT =  [0.1200,-0.0329];
        
%   Data = [cli_coefsDAT,match_death_coefsDAT,exp_sales_coefsDAT,match_ar1_coefsDAT,loglog_coefsDAT,mavshipDAT,exp_dom_coefsDAT,dom_ar1_coefsDAT,match_lag_coefsDAT,last_match_coefsDAT];
   
 % coefficient vector revised 12-17-16 
   Data = [match_death_coefsDAT,match_ar1_coefsDAT,loglog_coefsDAT,mavshipDAT,exp_dom_coefsDAT,...
       dom_ar1_coefsDAT,match_lag_coefsDAT,last_match_coefsDAT,succ_rate_coefsDAT,sr_var_coefsDAT];
  
    %% covariance matrices 

% cli_coefsCOV = ...   
%    [0.001701382136  -0.001647552086 -0.000264459058  0.000073487156 -0.000959542049 -0.000038182353;
%     -.001647552086   0.001668967452  0.000241358631 -0.000063003478  0.001042437496 -0.000022979405;
%     -.000264459058   0.000241358631  0.000314554178 -0.000132500191  0.000040625185 -0.000012385983;
%     0.000073487156  -0.000063003478 -0.000132500191  0.000073241876 -0.000015391800  0.000000882907;
%     -.000959542049   0.001042437496  0.000040625185 -0.000015391800  0.000979801955 -0.000093769282;
%     -.000038182353  -0.000022979405 -0.000012385983  0.000000882907 -0.000093769282  0.000069673070];
 
match_death_coefsCOV = ...    
    [0.000427699832  -0.000127448542  -0.000026253311  -0.000045560267 -0.000033872676; 
    -0.000127448542   0.000137342677   0.000001753036   0.000081273853 -0.000005694758; 
    -0.000026253311   0.000001753036   0.000002501209  -0.000000672050 -0.000000605574;
    -0.000045560267   0.000081273853  -0.000000672050   0.000081302304 -0.000027033495;
    -0.000033872676  -0.000005694758  -0.000000605574  -0.000027033495  0.000042624529];
    
% exp_sales_coefsCOV = ...
%     [0.005961707962 -0.005792913998 -0.001678065759 -0.000174738189; 
%     -0.005792913998  0.005773713389  0.001647870126  0.000090992680;
%     -0.001678065759  0.001647870126  0.000967730696 -0.000082167676; 
%     -0.000174738189  0.000090992680 -0.000082167676  0.000147385590];
 
match_ar1_coefsCOV = ...
     [0.002362705419 -0.000156827604 -0.000481368001 -0.000284962242  0       ;
     -0.000156827604  0.000014721579  0.000014300618 -0.000004772804  0       ;
     -0.000481368001  0.000014300618  0.000332671396  0.000124115947  0       ;
     -0.000284962242 -0.000004772804  0.000124115947  0.000193084788  0       ;
     0                0               0               0               0.00012];

loglog_coefsCOV = ...
  [0.022689638548  -0.015310017854   0.002420753146;
  -0.015310017854   0.012614810554  -0.002268716169;             
   0.002420753146  -0.002268716169   0.000443232645];            

    mavshipCOV = 0.00415553^2;  % note that I squared the standard error here

    exp_dom_coefsCOV = ...
        [0.1014345  0            0       ;
        0           0.0064868    0       ;
        0           0            0.00126];

    dom_ar1_coefsCOV = ...
        [0.0126289  0           0        ;
        0           0.0008622   0        ;
        0           0           0.000020];
    
    
% The following matrices are based DIAN customs records. Should be replaced
% with U.S. customs records results

%     match_lag_coefsCOV = ...
% [0.000357609 -8.71021E-05  3.66539E-06 -0.001238514  0.001030789  0.000131485;
% -8.71021E-05  0.002280669 -0.000221418 -0.008306071  0.011328116 -0.00222129;
%  3.66539E-06 -0.000221418  5.63498E-05  0.00087001  -0.000831284 -6.31069E-05;
% -0.001238514 -0.008306071  0.00087001   0.048612721 -0.062880173  0.006331889;
%  0.001030789  0.011328116 -0.000831284 -0.062880173  0.088067219 -0.012166842;
%  0.000131485 -0.00222129  -6.31069E-05  0.006331889 -0.012166842  0.004811316];
% 
% 
%    last_match_coefsCOV  = ...
% [
%  4.45023E-05 -1.2216E-05   7.05521E-07 -0.00015642   0.000133236 1.80913E-05;
% -1.2216E-05	0.000366137 -3.89047E-05 -0.001304411  0.001760753 -0.000342658;
%  7.05521E-07 -3.89047E-05  1.0444E-05   0.000148432 -0.000139208 -1.27613E-05;
% -0.00015642  -0.001304411  0.000148432  0.007305996 -0.009432104  0.000937084;
%  0.000133236  0.001760753 -0.000139208 -0.009432104  0.01326058  -0.001866552;
%  1.80913E-05 -0.000342658 -1.27613E-05  0.000937084 -0.00186655   0.000779931];


% The following matrices are based on U.S. customs records. Results disclosed 12-12-16

  match_lag_coefsCOV = ...
   [0.0105 0      0      0      0      0        ;
    0      0.1128 0      0      0      0        ;
    0      0      0.0168 0      0      0        ;
    0      0      0      0.2962 0      0        ;
    0      0      0      0      0.3956 0        ;
    0      0      0      0      0      0.0105]^2; 

  last_match_coefsCOV = ...
   [0.0038 0      0      0      0      0        ;
    0      0.0422 0      0      0      0        ;
    0      0      0.0063 0      0      0        ;
    0      0      0      0.1101 0      0        ;
    0      0      0      0      0.1470 0        ;
    0      0      0      0      0      0.0501]^2; 

% The following matrices are based DIAN customs records. Should be replaced
% with U.S. customs records results

succ_rate_coefsCOV = ...
    [0.0037   0;
     0   0.0019]^2;
 
 sr_var_coefsCOV = ...
     [0.0007  0;
      0  0.0003]^2;
%%
    
    % The following block is an ad hoc attempt to put the regressions on a more 
    % equal footing in terms of their weight in the fit metric.
    
%     ncli_coefsCOV         = cli_coefsCOV./trace(cli_coefsCOV);
%     nmatch_death_coefsCOV = match_death_coefsCOV./trace(match_death_coefsCOV);
%     nexp_sales_coefsCOV   = exp_sales_coefsCOV./trace(exp_sales_coefsCOV);
%     nmatch_ar1_coefsCOV   = match_ar1_coefsCOV./trace(match_ar1_coefsCOV);
%     nloglog_coefsCOV      = loglog_coefsCOV./trace(loglog_coefsCOV);
%     nmavshipCOV           = mavshipCOV./trace(mavshipCOV);
%     nexp_dom_coefsCOV     = exp_dom_coefsCOV./trace(exp_dom_coefsCOV);
%     ndom_ar1_coefsCOV     = dom_ar1_coefsCOV./trace( dom_ar1_coefsCOV);
%     nmatch_lag_coefsCOV   = match_lag_coefsCOV./trace(match_lag_coefsCOV); 
%     nlast_match_coefsCOV  = last_match_coefsCOV./trace(last_match_coefsCOV);
    
    
%    W = blkdiag(ncli_coefsCOV,nmatch_death_coefsCOV,nexp_sales_coefsCOV,...
%        nmatch_ar1_coefsCOV,nloglog_coefsCOV,nmavshipCOV,nexp_dom_coefsCOV,...
%        ndom_ar1_coefsCOV,nmatch_lag_coefsCOV,nlast_match_coefsCOV);
%%    
% weighting matrix for pre-12-17-16 moments

%      W = blkdiag(cli_coefsCOV,match_death_coefsCOV,exp_sales_coefsCOV,...
%        match_ar1_coefsCOV,loglog_coefsCOV,mavshipCOV,exp_dom_coefsCOV,...
%        dom_ar1_coefsCOV,match_lag_coefsCOV,last_match_coefsCOV);
 
 % weighting matrix for moment vector revised 12-17-16  
   
        W = blkdiag(match_death_coefsCOV,...
       match_ar1_coefsCOV,loglog_coefsCOV,mavshipCOV,exp_dom_coefsCOV,...
       dom_ar1_coefsCOV,match_lag_coefsCOV,last_match_coefsCOV,...
       succ_rate_coefsCOV,sr_var_coefsCOV);

    
    
end
