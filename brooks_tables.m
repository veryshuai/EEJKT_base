%The point of this script is to create brooks tables from our EEJKT
%simulated data to match the brooks tables in the actual US data

%We have simulated 3000 firms of each type of productivity/theta pair of
%firms.  We will draw 3000 firms randomly in each year from the exogenous
%distribution of productivity and theta, and then track them over time.

%randomly draw firms from distribution of productivities and success probabilities 
rng(80085);

load results/simulated_firm_data_death 

sales_rand_mat = ones(3000,10,10) * -1;  %(firms per year, first ten years of firms, year of birth)
clients_rand_mat = ones(3000,10,10) * -1;  
sales_sum_mat = ones(10,10) * -1;
active_sum_mat = ones(10,10) * -1;
clients_sum_mat = ones(10,10) * -1;

prod_dist = erg_pp;
succ_dist = th2_pdf;
prod_dist_cum = cumsum(erg_pp);
succ_dist_cum = cumsum(th2_pdf);

for year=1:10
    for k = 1:3000

        prod_lvl = find(rand() < prod_dist_cum,1,'first');
        succ_lvl = find(rand() < succ_dist_cum,1,'first');
        rand_col = randi(sim_firms);

        sales_rand = sales_cell{prod_lvl,succ_lvl,rand_col}(1:10,2); %first 10 years of foreign sales for random firm of type
        clients_rand = clients_cell{prod_lvl,succ_lvl,rand_col}(end-9:end,2);
        
        %if zero once, zero forever (only count exporters which started in
        %year one)
        for t=1:10
            if sales_rand(t) == 0
                sales_rand(t+1:end) = 0;   
            end
        end
        
        sales_rand_mat(k,1:10,year) = sales_rand;
        clients_rand_mat(k,:,year) = clients_rand; %last ten years
        
    end
    
    sales_sum_mat(:,year) = sum(squeeze(sales_rand_mat(:,:,year)),1);
    active_sum_mat(:,year) = sum(squeeze(sales_rand_mat(:,:,year)>0),1);
    
end

bt_sales = sales_sum_mat(:,1)';
bt_active = active_sum_mat(:,1)';
for k = 2:10
    zero_vec = zeros(1,k-1);
    bt_sales = [bt_sales;[zero_vec,sales_sum_mat(1:11-k,k)']];
    bt_active = [bt_active;[zero_vec,active_sum_mat(1:11-k,k)']];
end
bt_sales_per_firm = bt_sales./bt_active;

%transition matrix in clients
transitions = [];
for yr=1:10
    for period = 1:9
        transitions = [transitions;[clients_rand_mat(:,period,yr),clients_rand_mat(:,period+1,yr)];            ];
    end
end
freq_mat = -1 * ones(8); %zero, one, two, three, four, five, 6-10, 11+
for j=0:5
    for k = 0:5
        freq_mat(j+1,k+1) = sum(transitions(:,1) == j & transitions(:,2) == k);     
    end
    freq_mat(j+1,7) = sum(transitions(:,1) == j & (transitions(:,2) > 6 & transitions(:,2) < 11));
    freq_mat(j+1,8) = sum(transitions(:,1) == j & transitions(:,2) > 10);
end
for k = 0:5
    freq_mat(7,k+1) = sum(transitions(:,1) > 6 & transitions(:,1) < 11  & transitions(:,2) == k);
    freq_mat(8,k+1) = sum(transitions(:,1) > 10 & transitions(:,2) == k);
end
freq_mat(7,7) = sum(transitions(:,1) > 6 & transitions(:,1) < 11  & transitions(:,2) > 6 & transitions(:,2) < 11);
freq_mat(7,8) = sum(transitions(:,1) > 6 & transitions(:,1) < 11  & transitions(:,2) > 10);
freq_mat(8,7) = sum(transitions(:,1) > 10  & transitions(:,2) > 6 & transitions(:,2) < 11);
freq_mat(8,8) = sum(transitions(:,1) > 10  & transitions(:,2) > 10);
trans_mat = freq_mat ./ sum(freq_mat,2);
erg_dist = [1,0,0,0,0,0,0,0];
for k=1:1000
    erg_dist = erg_dist * trans_mat ;    
end
erg_dist_pos = erg_dist(2:end) / sum(erg_dist(2:end));

%write to files
csvwrite('results/brooks_sim/bt_sales.csv',bt_sales);
csvwrite('results/brooks_sim/bt_active.csv',bt_active);
csvwrite('results/brooks_sim/bt_sales_per_firm.csv',bt_sales_per_firm);
csvwrite('results/brooks_sim/client_trans_mat_sim.csv',trans_mat);
csvwrite('results/brooks_sim/ergodic_client_dist.csv',erg_dist_pos);



