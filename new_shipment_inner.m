function [new_sale,cli_hotel,cli_num,match_time_foreign] = new_shipment_inner(state,cli_hotel,demand_shock_matrix,de,Phi,X,Z,scale,cli_num,cont_val,macro_ind,match_num,maxc,match_time_foreign,burn)  
%This function calculates both the new sales and also endogenous drops which happen after a new shipment for either foreign or home

    %create productivity (just easier to remember)
    productivity = state(2);

    %get relevant client
    cli_at_hand = randi(cli_num);

    %get demand shock
    [cli_hotel_occupied_row_ind,~] = find(cli_hotel(1:min(match_num,maxc),1),cli_at_hand); %find first "cli_at_hand" indexes and values of occupied rooms in cli hotel
    demand_shock_matrix_position = cli_hotel(cli_hotel_occupied_row_ind(end),:); %get the demand matrix positions
    actual_demand_shock = demand_shock_matrix(demand_shock_matrix_position(2),demand_shock_matrix_position(1));
    
    %calculate the amount of the sale in level
    new_sale = exp(scale)*exp(Phi(productivity)).^(de-1).*exp(X(macro_ind)).*sum(exp(Z(actual_demand_shock)));
    
    %add it to the match annual total
    cli_hotel(cli_hotel_occupied_row_ind(end),4) = cli_hotel(cli_hotel_occupied_row_ind(end),4) + new_sale;

    %endogenous separation 
    if cont_val(actual_demand_shock,productivity,macro_ind)==0 %(demand shock, prod, macro) this means that the policy recommended an endogenous drop
        cli_hotel(cli_hotel_occupied_row_ind(end),1:2) = [0,0]; %empty the room
        cli_num = cli_num - 1; %reduce number of clients by one

        %flag exporter deaths
        if cli_num == 0
            if state(1) > burn
                last_match_time_row = find(match_time_foreign(:,1) ~= 0,1,'last');
                match_time_foreign(last_match_time_row,4) = 1; % flag last match 
            end
        end

    end

end
