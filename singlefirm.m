function [sales,clients,shipments,firm_num_vec,match_sales_foreign,match_sales_home,match_time_foreign,match_time_home] = singlefirm(j,max_mat_violation,match_violation,violation,match_number_violation,no_more_rands,x_size,Phi_size,z_size,TT,cum_erg_pz,cum_erg_pp,cum_sp_p,sp_p,lambda_f_orig,lambda_h_orig,lambda_f_new,lambda_h_new,c_val_h_orig,c_val_f_orig,c_val_h_new,c_val_f_new,burn,delta,d,S,n_size,net_size,Z,Phi,X_f,X_h,actual_h,actual_f,L_b,L_z,L_f,L_h,erg_pz,erg_pp,maxc,max_client_prod,mult_match_max,mms,scale_h,scale_f,de,cost,succ_params,cf_num,demand_shock_matrix,macro_shock_matrix,simulation_start_time)
% This function generates the matrix of annual information we need for each firm

    %Begin timer
    tic
    
    %Temporary set up
    lambda_f = lambda_f_orig; %CHANGE ONCE WE WOULD LIKE TO IMPLEMENT COUNTERFACTUALS (FINE FOR BASELINE EST)
    lambda_h = lambda_h_orig; 
    match_death_haz = delta; %this makes the variable name more descriptive
    firm_death_haz = d; %ditto
    learn_max = n_size; %ditto
    prod_dist = cum_erg_pp; %ditto
    demand_shock_mat_cols = size(demand_shock_matrix,2);
    cont_val_f = c_val_f_orig; %Ths continuation value of a relationship, zero if endogenously not worth continuing in light of cost (function of (dem_shock,prod,macroshock)
    cont_val_h = c_val_h_orig; %ditto
    
    
    % Preallocate data vectors columns (foreign,home)
    rec_years = TT - burn; %Only keep period after burn in
    sales = zeros(rec_years,2);
    clients = zeros(rec_years,2);
    %trials = zeros(rec_years);
    shipments = zeros(rec_years,2);
    firm_num_vec = zeros(rec_years,1);
    match_sales_foreign = zeros(rec_years,maxc);
    match_sales_home = zeros(rec_years,maxc);
    match_time_foreign = zeros(maxc,4); %time, successful?,which firm,last before non-export dummy
    match_time_home = zeros(maxc,4); %time, successful?,which firm,last before non-export dummy,last before non-export dummy
    
    % The state
    % [time,prod,macro_for,macro_home,trials_for,succ_for,succ_home,ann_sales_for,ann_sales_home,ann_ship_for,ann_ship_home,foreign_success_prob,home_success_prob,home_discretized_success_probability]
    state = zeros(14,1);
    
    % Set productivity
    [~,state(2)] = histc(rand,[0; prod_dist]);
    
    % Set macro states
    state(3) = macro_shock_matrix(1,2);
    state(4) = macro_shock_matrix(1,4);
    macro_shock_row_foreign = 1; %ditto 
    macro_shock_row_home = 1; % keep track of rows 
    
    % Set success probabilities (actual foreign success, actual home
    % success prob, discretized home success prob for policy function
    [state(12),state(13),~,state(14)] = update_succ_probs(succ_params);
    
    % Active clients
    cli_hotel_foreign = zeros(maxc,4); %Holds the demand shock matrix (column) number of each client, as well as their current index in the matrix (row), match number, and sales in the year to date
    cli_hotel_home = zeros(maxc,4); %Holds the demand shock matrix (column) number of each client, as well as their current index in the matrix (row), match number and sales in the year to date

    % Initiate client numbers (current and annual recordable
    cli_num_foreign = 0; cli_num_foreign_rec = 0;
    cli_num_home = 0; cli_num_home_rec = 0;
    
    % Initiate firm and match numbers
    firm_num = 1;
    match_num_foreign = 1;
    match_num_home = 1;
    
    % Iterate until we get up to time TT
    while state(1) < TT;

        % Macro change flag
        mac_change = 0;
        
        % Calculate overall hazard 
        cli_num = cli_num_foreign + cli_num_home;
        
        % MEX to calculate next event
        [next_event,time_increment,total_haz] = update_overall_event_hazard(state,cli_num,lambda_f,lambda_h,L_b,L_z,match_death_haz,firm_death_haz,learn_max,net_size);
        
        % Check for too large a hazard 
        max_runtime = 10;
        if total_haz > 4000 || toc >max_runtime 
            %break_flag = 1;
            display(toc);
			if toc > max_runtime
			    ME = MException('singlefirm:total_haz_too_large', ...
			'Single firm simulation time exceeds maximum allowed value');
                display('ERROR: Single firm simulation time exceeds maximum allowed value! file: singlefirm.m')
			else
			    ME = MException('singlefirm:total_haz_too_large', ...
			'Total event hazard too large');
                display('ERROR: Total event hazard too large in simulation: singlefirm.m')
			end
			throw(ME)
            break;
        end
        
        % Draw a new event time
        next_time = state(1) + time_increment;
        
        % Check for the passage of a macro state
        if next_time > macro_shock_matrix(macro_shock_row_foreign+1,1) || next_time > macro_shock_matrix(macro_shock_row_home+1,3) 
            mac_change = 1; %trip flag for macro state change
            if macro_shock_matrix(macro_shock_row_foreign+1,1) < macro_shock_matrix(macro_shock_row_home+1,3)
                macro_shock_row_foreign = macro_shock_row_foreign + 1; %increment row
                next_time = macro_shock_matrix(macro_shock_row_foreign,1); %get the current next time of an event
                state(3) = macro_shock_matrix(macro_shock_row_foreign,2); %get the current macro state
            else
                macro_shock_row_home = macro_shock_row_home + 1; %increment row
                next_time = macro_shock_matrix(macro_shock_row_home,3); %current time
                state(4) = macro_shock_matrix(macro_shock_row_home,4); %current state
            end
        end
        
        % Check for passage of a year or a firm death
        if (floor(next_time) ~= floor(state(1)) && floor(state(1)) < TT) || (next_event == 6 && mac_change == 0)
            
            % %Start the following year (so as not to overlap with record from previous firm
            if next_event == 6
                next_time = floor(next_time + 1);
            end
            
            %record at all year intervals
            while  floor(state(1)) < floor(next_time)
                if floor(state(1)) >= burn && floor(state(1)) < TT % start recording after the burn in
                    rec_row = floor(state(1)) + 1 - burn; %rename the row we will record in to make reading easier
                    clients(rec_row,:) = [cli_num_foreign_rec,cli_num_home_rec]; %record client counts
                    %trials(rec_row,:) = [state(5)]; %record trials to date 
                    sales(rec_row,:) = state(8:9); %record annual sales
                    shipments(rec_row,:) = state(10:11); %record annual shipments
                    firm_num_vec(rec_row,:) = firm_num; %record firm number
                    match_sales_foreign(rec_row,cli_hotel_foreign(cli_hotel_foreign(1:min(match_num_foreign,maxc),3) > 0,3)) = cli_hotel_foreign(cli_hotel_foreign(1:min(match_num_foreign,maxc),3) > 0,4); %record foreign match sales
                    match_sales_home(rec_row,cli_hotel_home(cli_hotel_home(1:min(match_num_home,maxc),3) > 0,3)) = cli_hotel_home(cli_hotel_home(1:min(match_num_home,maxc),3) > 0,4); %record home match sales
                end
                state(1) = state(1) + 1;
            end 
            state = state_new_year_reset(state); %reset shipments and sales
            cli_hotel_foreign = cli_hotel_new_year_reset(cli_hotel_foreign,match_num_foreign);
            cli_hotel_home = cli_hotel_new_year_reset(cli_hotel_home,match_num_home);
            cli_num_foreign_rec = cli_num_foreign; %reset recordable clients
            cli_num_home_rec = cli_num_home; %ditto
        end

        % Update time
        state(1) = next_time;

        if mac_change == 0 %check to see if the event wasn't a macro change
           
            % Which event? [new meeting foreign, new meeting home, shipment, demand change, exog death match, exog death firm]
            switch next_event
                
                case 1
                    cli_num_foreign_rec = cli_num_foreign_rec + 1; %record all clients met during a year
                    [state, cli_hotel_foreign, cli_num_foreign,~,match_num_foreign,match_time_foreign] = meet_new_foreign(state,cli_hotel_foreign,demand_shock_mat_cols,cli_num_foreign,demand_shock_matrix,de,Phi,X_f,Z,scale_f,cont_val_f,match_num_foreign,maxc,match_time_foreign,firm_num,burn);
                    
                case 2
                    cli_num_home_rec = cli_num_home_rec + 1; %record all clients met during the year
                    [state, cli_hotel_home, cli_num_home,~,match_num_home,match_time_home] = meet_new_home(state,cli_hotel_home,demand_shock_mat_cols, cli_num_home,demand_shock_matrix,de,Phi,X_h,Z,scale_h,cont_val_h,match_num_home,maxc,match_time_home,firm_num,burn);
                   
                case 3
                    [state, cli_hotel_foreign, cli_hotel_home,cli_num_foreign,cli_num_home,match_time_foreign,match_time_home] = new_shipment(state,cli_hotel_foreign,cli_hotel_home,demand_shock_matrix,de,Phi,X_f,X_h,Z,scale_f,scale_h,cli_num_foreign,cli_num_home,cont_val_f,cont_val_h,match_num_foreign,match_num_home,maxc,match_time_foreign,match_time_home,burn);
                    
                case 4
                    [cli_hotel_foreign,cli_hotel_home] = new_demand(cli_hotel_foreign,cli_hotel_home,cli_num_foreign,cli_num_home);
                    
                case 5
                    [cli_hotel_foreign,cli_hotel_home,cli_num_foreign,cli_num_home,match_time_foreign,match_time_home] = new_match_death(cli_hotel_foreign,cli_hotel_home,cli_num_foreign,cli_num_home,match_num_foreign,match_num_home,maxc,match_time_foreign,match_time_home,state,burn);
                    
                case 6
                    [cli_hotel_foreign,cli_hotel_home,state,cli_num_foreign,cli_num_home,firm_num] = new_firm_death(cli_hotel_foreign,cli_hotel_home,state,succ_params,prod_dist,next_time,firm_num);
            end
        end
    end
    
    % make sparse matrices
    match_sales_foreign = sparse(match_sales_foreign);
    match_sales_home = sparse(match_sales_home);
    match_time_foreign = sparse(match_time_foreign);
    match_time_home = sparse(match_time_home);
end
