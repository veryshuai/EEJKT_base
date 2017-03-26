function cli_hotel = cli_hotel_new_year_reset(cli_hotel,match_num)
%resets client hotel, eliminating dead relationships, etc. NOTE: no reason
%to search farther than "match_num", as that part of client hotel cannot be
%filled.

    cli_hotel(1:match_num,4) = 0; %zero out match sales

    %reset dead matches    
    cli_hotel(cli_hotel(1:match_num,1) == 0,3) = 0;

end