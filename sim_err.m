% This script fills in parameters if there is an error in simulation, in order to make solver continue to run.
    
    match_death_coefs = [inf inf inf inf inf]';
    match_ar1_coefs   = [inf inf inf inf inf]';    
    loglog_coefs      = [inf inf inf]';
    mavship           = inf; 
    exp_dom_coefs     = [inf inf inf]'; 
    dom_ar1_coefs     = [inf inf inf]'; 
    match_lag_coefs   = [inf inf inf inf inf inf]'; 
    last_match_coefs  = [inf inf inf inf inf inf]';           
    succ_rate_coefs   = [inf inf]'; 
    sr_var_coefs      = [inf inf]';
    for_sales_shr     = inf;
    exp_frac          = inf;
    
    Model = cat(1,match_death_coefs,match_ar1_coefs,...
     loglog_coefs,mavship,exp_dom_coefs,dom_ar1_coefs,match_lag_coefs,...
     last_match_coefs,succ_rate_coefs,sr_var_coefs,for_sales_shr,exp_frac); 
 
    diag_stats = [-999 -999];

    
