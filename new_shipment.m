function [state,cli_hotel_foreign,cli_hotel_home,cli_num_foreign,cli_num_home,match_time_foreign,match_time_home] = new_shipment(state,cli_hotel_foreign,cli_hotel_home,demand_shock_matrix,de,Phi,X_f,X_h,Z,scale_f,scale_h,cli_num_foreign,cli_num_home,cont_val_f,cont_val_h,match_num_foreign,match_num_home,maxc,match_time_foreign,match_time_home,burn)
% This function adds sales from a random client to the state vector

%is it foreign or home?
foreign=0;
if rand < cli_num_foreign / (cli_num_foreign + cli_num_home)
    
    foreign = 1; %flag for foreign shipment
    [new_sale,cli_hotel_foreign,cli_num_foreign] = new_shipment_inner(state,cli_hotel_foreign,demand_shock_matrix,de,Phi,X_f,Z,scale_f,cli_num_foreign,cont_val_f,state(3),match_num_foreign,maxc,match_time_foreign,burn);  

else
    
    [new_sale,cli_hotel_home,cli_num_home] = new_shipment_inner(state,cli_hotel_home,demand_shock_matrix,de,Phi,X_h,Z,scale_h,cli_num_home,cont_val_h,state(4),match_num_home,maxc,match_time_home,burn);  

end

%Add new sale to correct annual sales position of state variable
state(9 - foreign) = state(9 - foreign) + new_sale;
state(11 - foreign) = state(11 - foreign) + 1; % new shipment!

end
