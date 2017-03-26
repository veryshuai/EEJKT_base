function [cli_hotel_foreign,cli_hotel_home,cli_num_foreign,cli_num_home,match_time_foreign,match_time_home] = new_match_death(cli_hotel_foreign,cli_hotel_home,cli_num_foreign,cli_num_home,match_num_foreign,match_num_home,maxc,match_time_foreign,match_time_home,state,burn)
%This function randomly deletes one row from either cli_hotel_foreign or
%cli_hotel_home

%check for foreign
foreign = 0;
if rand < cli_num_foreign / (cli_num_foreign + cli_num_home)
   
   foreign = 1;
   cli_hotel = cli_hotel_foreign;
   cli_num = cli_num_foreign;
   match_num = match_num_foreign;
    
else
    
    cli_hotel = cli_hotel_home;
    cli_num = cli_num_home;
    match_num = match_num_home;
    
end

kill_this_row = randi(cli_num); %choose the row to eliminate

all_occupied_rooms = find(cli_hotel(1:min(match_num,maxc),1) > 0,kill_this_row,'first'); %return first "kill_this_row" occupied rooms
%hotel_row_ind = all_occupied_rooms(end); %index of kill_this_rowth client in hotel
%cli_hotel(hotel_row_ind,1:2) = [0,0]; %replace values in that row with zero
insert_val(0,all_occupied_rooms,1,cli_hotel); %replace values in that row (1st and 2nd columns) with zero

if foreign == 1
    
    cli_hotel_foreign = cli_hotel;
    cli_num_foreign = cli_num_foreign - 1;

    %flag exporter deaths
    if cli_num_foreign == 0
        if state(1) > burn
            last_match_time_row = find(match_time_foreign(:,1) ~= 0,1,'last');
            match_time_foreign(last_match_time_row,4) = 1; % flag last match 
        end
    end
    
else
    
    cli_hotel_home = cli_hotel;
    cli_num_home = cli_num_home - 1;

    %flag exporter deaths
    if cli_num_home == 0
        if state(1) > burn
            last_match_time_row = find(match_time_home(:,1) ~= 0,1,'last');
            match_time_home(last_match_time_row,4) = 1; % flag last match 
        end
    end
    
end

end
