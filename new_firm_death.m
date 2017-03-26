function [cli_hotel_foreign,cli_hotel_home,state,cli_num_foreign,cli_num_home,firm_num] = new_firm_death(cli_hotel_foreign,cli_hotel_home,state,succ_params,prod_dist,next_time,firm_num)
%Kill the firm, reset everything except macro states and time to zero

new_state = zeros(size(state));
new_state(1:4) = state(1:4); %these are the time, productivity, foreign macro, and home macro states
[~,new_state(2)] = histc(rand,[0; prod_dist]); %Draw new productivity 
[new_state(12),new_state(13),~,new_state(14)] = update_succ_probs(succ_params);
state = new_state;

%kill all clients
cli_hotel_foreign = zeros(size(cli_hotel_foreign));
cli_hotel_home = zeros(size(cli_hotel_home));
cli_num_foreign = 0;
cli_num_home = 0;

%iterate firm number
firm_num = firm_num + 1;

end
