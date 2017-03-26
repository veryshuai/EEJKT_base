function [state,cli_hotel] = new_sample_shipment(state,cli_hotel,demand_shock_matrix,de,Phi,X,Z,scale,cli_num,cont_val,new_client_row,foreign)
% This function adds sales from a random client to the state vector for a
% sample shipment

    %create productivity (just easier to remember)
    productivity = state(2);

    %get demand shock
    actual_demand_shock = demand_shock_matrix(cli_hotel(new_client_row,2),cli_hotel(new_client_row,1));
    
    %calculate the amount of the sale in level
    new_sale = exp(scale)*exp(Phi(productivity)).^(de-1).*exp(X(state(4 - foreign))).*sum(exp(Z(actual_demand_shock)));
    
    %Add new sale to correct annual sales position of state variable
    state(9 - foreign) = state(9 - foreign) + new_sale;
    state(11 - foreign) = state(11 - foreign) + 1; % new shipment!
    cli_hotel(new_client_row,4) = new_sale;

end
