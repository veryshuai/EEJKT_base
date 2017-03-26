function [simulated_data,Model,diag_stats] =...
    moms_nocell(mm,lambda_f_orig,lambda_h_orig,lambda_f_new,lambda_h_new,c_val_h_orig,c_val_f_orig,c_val_h_new,c_val_f_new,cf_num,increase,seed)
%This function simulates the model and calculates the moments needed for the distance metric

    % initialize simulated data holder
    simulated_data = cell(11,1);

    % read in parameters
    moms_params
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Get Spells for own productivity jumps 
    sp_p = zeros(S,200); %200 possible jumps
    g = 1;
    while (min(sum(sp_p,2))<TT) %loop through jump numbers
        for k = 1:S
          sp_p(k,g) = expinv(rand,1/L_p); 
        end
        g = g + 1;
    end 
    
    %eliminating policy function cell arrrays in favor of multi-dimensional matrices gives the simulation a drastic speed boost
    if cf_num == 9 % catch no learning model flag
        [lambda_f_orig, lambda_h_orig, c_val_f_orig, c_val_h_orig]  = moms_decell_nln(lambda_f_orig, lambda_h_orig, c_val_f_orig, c_val_h_orig);
        [lambda_f_new, lambda_h_new, c_val_f_new, c_val_h_new]  = moms_decell_nln(lambda_f_new, lambda_h_new, c_val_f_new, c_val_h_new);
    else
        [lambda_f_orig, lambda_h_orig, c_val_f_orig, c_val_h_orig]  = moms_decell(lambda_f_orig, lambda_h_orig, c_val_f_orig, c_val_h_orig);
        [lambda_f_new, lambda_h_new, c_val_f_new, c_val_h_new]  = moms_decell(lambda_f_new, lambda_h_new, c_val_f_new, c_val_h_new);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model Simulation

    %% Get vector of state and time changes
    try 
        simulation_begins = datetime('now');
        [sales_mat,clients_mat,shipments_mat,firm_num_vec_mat,match_sales_foreign_cell,match_sales_home_cell,match_time_foreign_cell,match_time_home_cell,break_flag] =...
            st_traj_nocell(sp_p,lambda_f_orig,lambda_h_orig,lambda_f_new,lambda_h_new,c_val_h_orig,c_val_f_orig,c_val_h_new,c_val_f_new,burn,delta,d,S,n_size,net_size,Z,Phi,X_f,X_h,actual_h,actual_f,L_b,L_z,L_f,L_h,erg_pz,erg_pp,maxc,max_client_prod,mult_match_max,mms,scale_f,scale_h,eta,TT,cost,cf_num,succ_params,seed);
        simulation_ends = datetime('now');
        total_simulation_runtime = simulation_ends - simulation_begins
    catch err
        % report error
        display('Error in simulation');
        getReport(err, 'extended')
        sim_err %fill in parameters to make solver continue
        break_flag = 1; %flag that something went wrong
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Moments calculations
    if break_flag == 0 %check that simulation ran without error
        try 
            mom_calcs;
        
          Model = cat(1,match_death_coefs,match_ar1_coefs,...
            loglog_coefs,mavship,exp_dom_coefs,dom_ar1_coefs,match_lag_coefs,...
            last_match_coefs,succ_rate_coefs,sr_var_coefs,for_sales_shr,exp_frac); 
            
            diag_stats = [pbexp ub];
        
            % Reject if number of post-burn in exporters less than 500
            display(['Number of post-burn, ever active exporters is ', num2str(pbexp), '.']);
            display(['Fraction of post-burn, ever active exporters is ', num2str(exp_frac), '.']);
            if pbexp < 500
                sim_err %fill in parameters to make solver continue
            end
        
        catch err
            % report error
            display('Error in moment calculation');
            getReport(err, 'extended')
            sim_err %fill in parameters to make solver continue
        end
    else
        sim_err
    end
        

%             % save results 
%             if cf_num > 0 & cf_num < 6
%                 save('results/cf_sim_results') %for plotting counterfactuals
%             elseif cf_num == 6
%                 save('results/val_sim_results') %for calculating the value of the network
%             elseif cf_num == 7
%                 save('results/no_learning_sim_results') %for calculating no learning sales
%             elseif cf_num == 8
%                 save('results/boot_firm_dat') %for bootstrap standard error calculation
%             end
%     
%         else
%             %simulation error
%             sim_err %fill in parameters to make solver continue
%         end
%     else
%         %simulation error
%         sim_err %fill in parameters to make solver continue
%     end
% 
%     %free memory
%     clearvars -except simulated_data mavship loglog_coefs exp_dom_coefs dom_ar1_coefs cli_coefs exp_death_coefs match_death_coefs exp_sales_coefs match_ar1_coefs

end %end function
