function [state,cli_hotel_home,cli_num_home,your_room_sir,match_num_home,match_time_home] = meet_new_home(state,cli_hotel_home,demand_shock_mat_cols, cli_num_home,demand_shock_matrix,de,Phi,X_h,Z,scale_h,cont_val_h,match_num_home,maxc,match_time_home,firm_num,burn)
%This function draws a new client position in the client hotel, and the
%state

    
    %assign a spot in the client hotel
    your_room_sir = find(cli_hotel_home(1:min(match_num_home,maxc),3) == 0,1,'first');
    if isempty(your_room_sir)
        display('ERROR: HOME CLIENT HOTEL IS FULL');
    end
    
    %assign a column in demand shock matrix
    cli_hotel_home(your_room_sir,1) = randi(demand_shock_mat_cols); %assign a column in the demand shock matrix
    cli_hotel_home(your_room_sir,2) = 1; %start demand shocks from the first row
    cli_hotel_home(your_room_sir,3) = match_num_home; %record match number
    
    %update match number
    match_num_home = match_num_home + 1;    

    %sample shipment
    [state,cli_hotel_home] = new_sample_shipment(state,cli_hotel_home,demand_shock_matrix,de,Phi,X_h,Z,scale_h,cli_num_home,cont_val_h,your_room_sir,0);

    %update match time matrix
    if state(1) > burn
        empty_match_time_row = find(match_time_home(:,1) == 0,1,'first');
        match_time_home(empty_match_time_row,1) = state(1); % time
        match_time_home(empty_match_time_row,3) = firm_num; % firm identity 
    end

    % Was the match successful?
    if rand < state(13)
    
        state(7) = state(7) + 1; %increment successes    
        if state(1) > burn
            match_time_home(empty_match_time_row,2) = 1; % successful match 
        end

        %add a client
        cli_num_home = cli_num_home + 1;
    
    else
    
        cli_hotel_home(your_room_sir,1:2) = [0,0]; %reset client hotel
        if state(1) > burn
            match_time_home(empty_match_time_row,2) = 0; % unsuccessful match 
        end

    end
   
end %end the function
