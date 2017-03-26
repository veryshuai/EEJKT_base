function demand_shock_matrix = create_demand_shock_matrix(demand_dist,z_size)
% this function simulates a jump process to create the demand shock matrix used in singlefirm.m

% Random first row from ergodic distribution
demand_shock_matrix = zeros(10000,1000);
[~ , demand_shock_matrix(1,:)] = histc(rand(1,size(demand_shock_matrix,2)), [0; demand_dist]);

for col = 1:size(demand_shock_matrix,2)
    for row = 2:size(demand_shock_matrix,1);

       %Simulate orstein uhlenbeck jump process
        next_step = 1-2*(rand<.5*(1+(demand_shock_matrix(row-1,col)-z_size-1)/z_size));
        demand_shock_matrix(row,col) = demand_shock_matrix(row-1,col) + next_step; 

    end
end

end


