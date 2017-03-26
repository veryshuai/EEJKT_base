function [next_event,time_increment,total_haz] = update_overall_event_hazard(state,cli_num,lambda_f,lambda_h,L_b,L_z,match_death_haz,firm_death_haz,learn_max,net_size)
% This function takes the current state, policy functions and parameters
% and returns an overall event hazard

%[time,prod,macro_for,macro_home,trials_for,succ_for,succ_home,ann_sales_for,ann_sales_home,ann_ship_for,ann_ship_home]

%Stop learning and network effects at user defined maximums
successes_learn_max = min(state(6),learn_max) + 1; %stop learning at maximum allowable size
trials_learn_max = min(state(5), learn_max) + 1; 
successes_network_max_foreign = min(state(6), net_size) + 1; %stop network size at maximum
successes_network_max_home = min(state(6), net_size) + 1; %stop network size at maximum

% client discovery hazards
new_foreign_client_hazard = lambda_f(successes_learn_max,trials_learn_max,1,successes_network_max_foreign,state(2),state(3));
new_home_client_hazard = lambda_h(1,state(14),successes_network_max_home,state(2),state(4));

% additional_event_hazards 
ship_haz = L_b * cli_num;
dem_shk_haz = L_z * cli_num;
match_death_cum_haz = match_death_haz * cli_num;

% Compute next event, this was a bottleneck, do it in c++
[next_event,time_increment,total_haz] = computeNextEvent(new_foreign_client_hazard,new_home_client_hazard,ship_haz,dem_shk_haz,match_death_cum_haz,firm_death_haz); 

end
