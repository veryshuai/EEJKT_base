function [state,cli_hotel_foreign,cli_num_foreign,your_room_sir,match_num_foreign,match_time_foreign,firm_num] = meet_new_foreign(state,cli_hotel_foreign,demand_shock_mat_cols,cli_num_foreign,demand_shock_matrix,de,Phi,X_f,Z,scale_f,cont_val_f,match_num_foreign,maxc,match_time_foreign,firm_num,burn)
%This function draws a new client position in the client hotel, and the
%state

    % Increment the trials
    state(5) = state(5) + 1;

    %assign a spot in the client hotel
    your_room_sir = find(cli_hotel_foreign(1:min(match_num_foreign,maxc),3) == 0,1,'first');
    if isempty(your_room_sir)
        display('ERROR: FOREIGN CLIENT HOTEL IS FULL!');
    end

    %assign a column in demand shock matrix
    cli_hotel_foreign(your_room_sir,1) = randi(demand_shock_mat_cols); %assign a column in the demand shock matrix
    cli_hotel_foreign(your_room_sir,2) = 1; %start demand shocks from the first row
    cli_hotel_foreign(your_room_sir,3) = match_num_foreign; %write in match number
 
    %update match_num_foreign
    match_num_foreign = match_num_foreign + 1; %don't allow match_num_foreign to rise above maxc.  This will kill the loop unnecessarily.

    %sample shipment
    [state,cli_hotel_foreign] = new_sample_shipment(state,cli_hotel_foreign,demand_shock_matrix,de,Phi,X_f,Z,scale_f,cli_num_foreign,cont_val_f,your_room_sir,1);

    %update match time matrix
    if state(1) > burn
        empty_match_time_row = find(match_time_foreign(:,1) == 0,1,'first');
        match_time_foreign(empty_match_time_row,1) = state(1); % time
        match_time_foreign(empty_match_time_row,3) = firm_num; % firm identity 
    end
    
    % Was the match successful?
    if rand < state(12)
    
        state(6) = state(6) + 1; %increment successes
        cli_num_foreign = cli_num_foreign + 1; %increment clients
        if state(1) > burn
            match_time_foreign(empty_match_time_row,2) = 1; % successful match 
        end

    else
    
        cli_hotel_foreign(your_room_sir,1:2) = [0,0]; %reset client hotel
        if state(1) > burn
            match_time_foreign(empty_match_time_row,2) = 0; % unsuccessful match 
        end

    end
   
end %end the function
