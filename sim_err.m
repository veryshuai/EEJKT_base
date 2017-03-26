% This script fills in parameters if there is an error in simulation, in order to make solver continue to run.
    
    match_death_coefs = [100 100 100 100 100]';
    match_ar1_coefs   = [100 100 100 100 100]';    
    loglog_coefs      = [100 100 100]';
    mavship           = 100; 
    exp_dom_coefs     = [100 100 100]'; 
    dom_ar1_coefs     = [100 100 100]'; 
    match_lag_coefs   = [100 100 100 100 100 100]'; 
    last_match_coefs  = [100 100 100 100 100 100]';           
    succ_rate_coefs   = [100 100]'; 
    sr_var_coefs      = [100 100]';
    for_sales_shr     = 100;
    exp_frac          = 100;
    
    Model = cat(1,match_death_coefs,match_ar1_coefs,...
     loglog_coefs,mavship,exp_dom_coefs,dom_ar1_coefs,match_lag_coefs,...
     last_match_coefs,succ_rate_coefs,sr_var_coefs,for_sales_shr,exp_frac); 
 
    diag_stats = [-999 -999];

    
