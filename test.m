cli_hotel_test1 = cli_hotel(1:100,:);
cli_hotel_test2 = cli_hotel(1:100,:);
tic;
insert_val(0,all_occupied_rooms,1,cli_hotel); %replace values in that row with zero
insert_val(0,all_occupied_rooms,2,cli_hotel); %replace values in that row with zero
toc
tic;
cli_hotel_test2(hotel_row_ind,1:2) = [0,0]; %replace values in that row with zero
toc