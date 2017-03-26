function [sales_mat,clients_mat,shipments_mat,firm_num_vec_mat,match_sales_foreign_cell,match_sales_home_cell,match_time_foreign_cell,match_time_home_cell,break_flag] = st_traj_nocell(sp_p,lambda_f_orig,lambda_h_orig,lambda_f_new,lambda_h_new,c_val_h_orig,c_val_f_orig,c_val_h_new,c_val_f_new,burn,delta,d,S,n_size,net_size,Z,Phi,X_f,X_h,actual_h,actual_f,L_b,L_z,L_f,L_h,erg_pz,erg_pp,maxc,max_client_prod,mult_match_max,mms,scale_f,scale_h,de,esT,cost,cf_num,succ_params,seed)
    %This function does the simulation needed to calculate moments
    
    break_flag = 0; %this flag goes to one if there is a maximum matrix violation, and allows us to stop the loop  
    time_out_flag = 0; %this flag goes to one if the simulation takes too much time
    
    match_violation = 0; %this counts number of match per period violations
    max_mat_violation = 0; %counts number of matrix size violations
    violation = 0; %will count number of demand shock change violations
    match_number_violation = 0; %counts number of maximum match number violations
    no_more_rands = 0; %counts number of times end of random vector reached 
    
    %% SETTING UP
    
    % Initialize cells
    cind         = cell(S,1);
    cst          = cell(S,1);
    cds          = cell(S,1);
    csh          = cell(S,1);
    cact         = cell(S,1);
    cdeathmat    = cell(S,1);
    csh_val_h    = cell(S,1);
    csh_val_f    = cell(S,1);
    cprod        = cell(S,1);
    ccost_vec    = cell(S,1);
    csucc_prob   = cell(S,1);
    
    % cumulative versions of ergodic distributions and waiting times
    cum_erg_pz = cumsum(erg_pz);
    cum_erg_pp = cumsum(erg_pp);
    cum_sp_p = cumsum(sp_p,2);
    
    %find middle state
    Phi_mid = (size(Phi,1)+1)/2;
    X_f_mid = (size(X_f,1)+1)/2;
    Z_mid = (size(Z,1) +1)/2;
    
    x_size = size(X_f,1)-X_f_mid;
    Phi_size = size(Phi,1)-Phi_mid;
    z_size = size(Z,1)-Z_mid;
    
    %get firm specific simulation times
    TT = esT;
    
    %reset random seed
    if seed == 1%Seeding is optional
        if cf_num == 6 % for some calculations, we require different random shocks each simulation
            rng('shuffle')
        else
            rng(80085)
        end
    else
        rng('shuffle') % randomly reseed if seed option is off
    end 
    
    %create common aggregate shocks
    macro_shock_matrix = create_macro_shock_matrix(L_f,TT,x_size);

    % reset seeds (one matlab, one c++/mex)
    rng(80085);
    %seedMexRNG(80085);

    %create demand shock matrix
    demand_shock_matrix = create_demand_shock_matrix(cum_erg_pz,z_size);
    
    %give each firm a random seed
    seeds = randi(1e7,S,1);

    % %test mex seeding
    % printMexRand
    
    %% EXOGENOUS TRAJECTORIES (MACRO STATES AND SELF PRODUCTIVITY)
    sales_mat = zeros(TT-burn,2*S);
    clients_mat = zeros(TT-burn,2*S);
    shipments_mat = zeros(TT-burn,2*S);
    firm_num_vec_mat = zeros(TT-burn,S);
    match_sales_foreign_cell = cell(S,1);
    match_sales_home_cell = cell(S,1);
    match_time_foreign_cell = cell(S,1);
    match_time_home_cell = cell(S,1);
    
    %% Simulation start time
    simulation_start_time = datetime('now');

    %initialize break flag
    break_flag = 0;

    parfor j = 1:S

    %   if break_flag == 0

            % Check for timeout
            if datetime('now') - simulation_start_time > (900 / 86400) % time difference measured in days
    %           break_flag = 1;
                time_out_flag = 1;
            end

            rng(seeds(j)); %reset random seed!
            seedMexRNG(seeds(j)); %reset mex random seed!
            nonactives = 0;

             [sales,clients,shipments,firm_num_vec,match_sales_foreign_cell{j},match_sales_home_cell{j},match_time_foreign_cell{j},match_time_home_cell{j}] = singlefirm(j,max_mat_violation,match_violation,violation,match_number_violation,no_more_rands,x_size,Phi_size,z_size,TT,cum_erg_pz,cum_erg_pp,cum_sp_p,sp_p,lambda_f_orig,lambda_h_orig,lambda_f_new,lambda_h_new,c_val_h_orig,c_val_f_orig,c_val_h_new,c_val_f_new,burn,delta,d,S,n_size,net_size,Z,Phi,X_f,X_h,actual_h,actual_f,L_b,L_z,L_f,L_h,erg_pz,erg_pp,maxc,max_client_prod,mult_match_max,mms,scale_h,scale_f,de,cost,succ_params,cf_num,demand_shock_matrix,macro_shock_matrix,simulation_start_time);
             sales_cell{j} = sales;
             clients_cell{j} = clients;
             shipments_cell{j} = shipments;
             firm_num_vec_cell{j} = firm_num_vec;
        %lt = find((ind(:,1))'>0,1,'last');
        %ft = find((ind(:,1))'>0,1,'first')+1;
    
        %% read into sparses
        %cind{j}       = sparse(ind(ft:lt,:));
        %cds{j}        = sparse(ds(ft:lt,:));
        %csh{j}        = sparse(sh(ft:lt,:));
        %cact{j}       = sparse(act(ft:lt,:));
        %cdeathmat{j}  = sparse(deathmat(ft:lt,:));
        %csh_val_h{j}  = sparse(sh_val_h(ft:lt,:));
        %csh_val_f{j}  = sparse(sh_val_f(ft:lt,:));
        %cprod{j}      = sparse(prod_init);
        %ccost_vec{j}  = sparse(cost_vec);
        %csucc_prob{j} = sparse(succ_prob);
    %    end
    end

    %assign cell values to matrices.  Originally this was done in the for loop above, but parfor complained about the indeces changing with each loop.
   for j=1:S
             sales_mat(:,2*j-1:2*j) = sales_cell{j};
             clients_mat(:,2*j-1:2*j) = clients_cell{j};
             shipments_mat(:,2*j-1:2*j) = shipments_cell{j};
             firm_num_vec_mat(:,j) = firm_num_vec_cell{j};
    end




    display(['A total of ', num2str(match_number_violation),' maximum match violations']);
    display(['A total of ', num2str(max_mat_violation),' matrix size violations']);
    
    if break_flag == 1
        if time_out_flag == 1
            display('WARNING: Timeout in simulation!')
        else
            display('WARNING: Broke out of loop! Results not reliable.')
        end
    end


end
