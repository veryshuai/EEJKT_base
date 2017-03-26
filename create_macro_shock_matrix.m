function macro_shock_matrix = create_macro_shock_matrix(macro_change_hazard,total_years,x_size)
% this function simulates a jump process to create the demand shock matrix used in singlefirm.m

% First row is zero
macro_shock_matrix = zeros(10000,4);
macro_shock_matrix(1,2) = x_size; %assign median starting value 
macro_shock_matrix(1,4) = x_size; %assign median starting value

%foreign
next_time = 0;
row = 2;
while next_time<total_years %check to make sure there is still time for another shock
    next_increment = - log(rand) / macro_change_hazard; 
    next_time = next_time + next_increment; %time of shock
    new_shock = macro_shock_matrix(row - 1,2) +1-2*(rand<.5*(1+(macro_shock_matrix(row -1,2) - x_size - 1)/x_size)); %value of new shock
    macro_shock_matrix(row,1:2) = [next_time,new_shock]; %read in new value 
    row = row + 1; %increment row
end

%home
next_time = 0;
row = 2;
while next_time<total_years %check to make sure there is still time for another shock
    next_increment = - log(rand) / macro_change_hazard; 
    next_time = next_time + next_increment; %time of shock
    new_shock = macro_shock_matrix(row - 1,4) +1-2*(rand<.5*(1+(macro_shock_matrix(row -1,4) - x_size - 1)/x_size)); %value of new shock
    macro_shock_matrix(row,3:4) = [next_time,new_shock]; %read in new value 
    row = row + 1; %increment row
end


end
