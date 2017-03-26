function [Data, W] = target_stats()
% returns the data statistics used in the loss function

    %% TARGETS: 
    % Regression coefficients from CJ system of equations May 12 COMPLETE.pdf (from email from Jim on 5/13/2015),
    % Marcela's regressions unsing DANE Encuesta Industrial data, from March 2013, and 
    % Jim's regressions disclosed through Penn State RDC December 2016 and February 2017
    
    match_death_coefsDAT = [0.79447 0.03421 -0.03163 -0.05370 -0.02778];
    match_ar1_coefsDAT =   [1.59164 0.82637 0.32834 0.06312 1.20786^2];  % careful--these orders do not match those in text table   
    loglog_coefsDAT = [0.02116 -1.88130 -0.05446];
    mavshipDAT = 0.9706402010; % average in logs 

    exp_dom_coefsDAT = [1.502486-(1-0.7268059)*log(2.156/0.654),0.7268059,2.1665^2]; %regression coefficients in Marcela's email of 3-22-2013, eam_moms_out( DIAN only 21 Feb 2013).log, [constant,coef,root MSE]
                       % conversion from thousands of 2009 pesos to 2009 dollars: divide by 2156/1000 = 2.156
                       % conversion from 2009 dollars to 1992 dollars: mulitply by (139.2+141.4)/(213.1+215.9)=0.6541, since C.J. used U.S. urban CPI 
    dom_ar1_coefsDAT = [0.3380132-(1-0.976442)*log(2.156/0.654),0.9764422,0.46207^2]; %regression coefficients in Marcela's email of 3-22-2013, eam_moms_out( DIAN only 21 Feb 2013).log, [constant,coef,root MSE]
                       % conversion from thousands of 2009 pesos to 2009 dollars: divide by 2156/1000 = 2.156
                       % conversion from 2009 dollars to 1992 dollars: mulitply by (139.2+141.4)/(213.1+215.9)=0.6541, since C.J. used U.S. urban CPI 
    match_lag_coefsDAT  = [-0.3258+log(12),-0.8181,0.3117,-1.1323,2.4514,-0.7082 ]; %regression coefficients from US customs records, disclosed 12-12-16
    last_match_coefsDAT = [0.8397,-0.6290,0.1205,0.0211,0.5976,-0.1290];            %regression coefficients from US customs records, disclosed 12-12-16 
    succ_rate_coefsDAT = [0.318,0.093]; % from RDC disclosure 2-3-17
    sr_var_coefsDAT =    [0.152,-0.060];  % from RDC disclosure 2-3-17

        
 % coefficient vector revised 12-17-16 
 
   Data = [match_death_coefsDAT,match_ar1_coefsDAT,loglog_coefsDAT,mavshipDAT,exp_dom_coefsDAT,...
       dom_ar1_coefsDAT,match_lag_coefsDAT,last_match_coefsDAT,succ_rate_coefsDAT,sr_var_coefsDAT];
     
%      Data = [match_death_coefsDAT (1-5),match_ar1_coefsDAT (6-10),loglog_coefsDAT (11-13),mavshipDAT (14),exp_dom_coefsDAT (15-17),...
%       dom_ar1_coefsDAT (18-20),match_lag_coefsDAT (21-26),last_match_coefsDAT (27-32),succ_rate_coefsDAT (33-34),sr_var_coefsDAT (35-36)];
  
    %% covariance matrices 
 
match_death_coefsCOV = ...    
    [0.000427699832  -0.000127448542  -0.000026253311  -0.000045560267 -0.000033872676; 
    -0.000127448542   0.000137342677   0.000001753036   0.000081273853 -0.000005694758; 
    -0.000026253311   0.000001753036   0.000002501209  -0.000000672050 -0.000000605574;
    -0.000045560267   0.000081273853  -0.000000672050   0.000081302304 -0.000027033495;
    -0.000033872676  -0.000005694758  -0.000000605574  -0.000027033495  0.000042624529];
 
match_ar1_coefsCOV = ...
     [0.002362705419 -0.000156827604 -0.000481368001 -0.000284962242  0       ;
     -0.000156827604  0.000014721579  0.000014300618 -0.000004772804  0       ;
     -0.000481368001  0.000014300618  0.000332671396  0.000124115947  0       ;
     -0.000284962242 -0.000004772804  0.000124115947  0.000193084788  0       ;
     0                0               0               0               0.00012];

loglog_coefsCOV = ...
  [0.022689638548  -0.015310017854   0.002420753146;
  -0.015310017854   0.012614810554  -0.002268716169;             
   0.002420753146  -0.002268716169   0.000443232645].*0.01;  % giving extra weight           

    mavshipCOV = 0.00415553^2;  % note that I squared the standard error here

 % The following two matrices come from Marcela's printout (DIAN only 21 Feb. 2013)

    exp_dom_coefsCOV = ...
        [0.1014345  0            0        ;
        0           0.0064868    0         ;
        0           0            0.0354].^2;  % see notes on printout for se(RSME)

    dom_ar1_coefsCOV = ...
        [0.0126289  0           0        ;
        0           0.0008622   0        ;
        0           0           0.000958].^2;  % see notes on printout for se(RSME)
    
    
% The following matrices are based on U.S. customs records. 

  match_lag_coefsCOV = ...
   [0.0105 0      0      0      0      0        ;
    0      0.1128 0      0      0      0        ;
    0      0      0.0168 0      0      0        ;
    0      0      0      0.2962 0      0        ;
    0      0      0      0      0.3956 0        ;
    0      0      0      0      0      0.0105]^2; %Results disclosed 12-12-16


  last_match_coefsCOV = ...
   [0.0038 0      0      0      0      0        ;
    0      0.0422 0      0      0      0        ;
    0      0      0.0063 0      0      0        ;
    0      0      0      0.1101 0      0        ;
    0      0      0      0      0.1470 0        ;
    0      0      0      0      0      0.0501]^2; % Results disclosed 12-12-16

succ_rate_coefsCOV = ...  % based on RDC disclosure 2-3-17
    [0.00000683 -0.00000698 ;
    -0.00000698  0.00000940];
 
 sr_var_coefsCOV = ...    % based on RDC disclosure 2-3-17
     [0.00000012  -0.00000012;
     -0.00000012   0.00000017];
%%
    
 % weighting matrix for moment vector revised 12-17-16  
   
        W = blkdiag(match_death_coefsCOV,...
       match_ar1_coefsCOV,loglog_coefsCOV,mavshipCOV,exp_dom_coefsCOV,...
       dom_ar1_coefsCOV,match_lag_coefsCOV,last_match_coefsCOV,...
       succ_rate_coefsCOV,sr_var_coefsCOV);
   
end