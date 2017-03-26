function [cli_hotel_foreign,cli_hotel_home] = new_demand(cli_hotel_foreign,cli_hotel_home,cli_num_foreign,cli_num_home)
%This function randomly iterates a single home or foreign clients demand
%shock

%Check if its foreign
foreign = 0;
if rand < cli_num_foreign / (cli_num_foreign + cli_num_home)
    
    foreign = 1;
    cli_num = cli_num_foreign;
    cli_hotel = cli_hotel_foreign;
    
else
    
    cli_num = cli_num_home;
    cli_hotel = cli_hotel_home;
    
end

%choose which client to update
update_index = randi(cli_num);
    
%find index in client hotel
first_n_occupied_rows = find(cli_hotel,update_index,'first');
update_row = first_n_occupied_rows(end);
cli_hotel(update_row,2) = cli_hotel(update_row,2) + 1;

if foreign
    cli_hotel_foreign = cli_hotel;
else
    cli_hotel_home = cli_hotel;
end

end