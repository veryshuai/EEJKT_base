% This script examines the role of learning in firm trajectories of EEJKT

clear all;

%Load simulated firms
load results/simulated_firm_data_learning_cf %there are sim_firms firms in cell{produtivity_level,success_level,firm_id}

%Loop through each firm type (prod/succ pair)
avg_clients_learning = -1 * ones(N_prod,N_theta2,TT);
avg_revenue_learning = -1 * ones(N_prod,N_theta2,TT);
avg_clients_no_uncertainty = -1 * ones(N_prod,N_theta2,TT);
avg_revenue_no_uncertainty = -1 * ones(N_prod,N_theta2,TT);

%Standard deviations
sd_clients_learning = -1 * ones(N_prod,N_theta2,TT);
sd_revenue_learning = -1 * ones(N_prod,N_theta2,TT);
sd_clients_no_uncertainty = -1 * ones(N_prod,N_theta2,TT);
sd_revenue_no_uncertainty = -1 * ones(N_prod,N_theta2,TT);

%Role of llearning three and ten years later
rel_clients_one = -1 * ones(N_prod,N_theta2);
rel_clients_two = -1 * ones(N_prod,N_theta2);
rel_clients_three = -1 * ones(N_prod,N_theta2);
rel_clients_ten = -1 * ones(N_prod,N_theta2);
rel_sales_one = -1 * ones(N_prod,N_theta2);
rel_sales_two = -1 * ones(N_prod,N_theta2);
rel_sales_three = -1 * ones(N_prod,N_theta2);
rel_sales_ten = -1 * ones(N_prod,N_theta2);

%Average clients three and ten years later
avg_clients_one = -1 * ones(N_prod,N_theta2);
avg_clients_two = -1 * ones(N_prod,N_theta2);
avg_clients_three = -1 * ones(N_prod,N_theta2);
avg_clients_ten = -1 * ones(N_prod,N_theta2);
avg_sales_one = -1 * ones(N_prod,N_theta2);
avg_sales_two = -1 * ones(N_prod,N_theta2);
avg_sales_three = -1 * ones(N_prod,N_theta2);
avg_sales_ten = -1 * ones(N_prod,N_theta2);

for prod_level = 1:N_prod
    for succ_level = 1:N_theta2
        
        display(prod_level)
        display(succ_level)

        %create temporary matrices to hold firms (rather than cells)
        clients_temp_mat = zeros(TT,sim_firms);
        sales_temp_mat = zeros(TT,sim_firms);
        for k = 1:sim_firms
            clients_temp_learning(:,k) = clients_cell{prod_level,succ_level,k}(:,1);
            sales_temp_learning(:,k) = sales_cell{prod_level,succ_level,k}(:,1);
            clients_temp_no_uncertainty(:,k) = clients_cell{prod_level,succ_level,k}(:,2);
            sales_temp_no_uncertainty(:,k) = sales_cell{prod_level,succ_level,k}(:,2);
        end

        %Read in average trajectories
        avg_clients_learning(prod_level,succ_level,:) = mean(clients_temp_learning,2);
        avg_revenue_learning(prod_level,succ_level,:) = mean(sales_temp_learning,2);
        avg_clients_no_uncertainty(prod_level,succ_level,:) = mean(clients_temp_no_uncertainty,2);
        avg_revenue_no_uncertainty(prod_level,succ_level,:) = mean(sales_temp_no_uncertainty,2);

        %Read in standard devs
        sd_clients_learning(prod_level,succ_level,:) = mean(clients_temp_learning,2);
        sd_revenue_learning(prod_level,succ_level,:) = mean(sales_temp_learning,2);
        sd_clients_no_uncertainty(prod_level,succ_level,:) = mean(clients_temp_no_uncertainty,2);
        sd_revenue_no_uncertainty(prod_level,succ_level,:) = mean(sales_temp_no_uncertainty,2);
        
        %Any effect three years later?
        rel_clients_one(prod_level,succ_level) = avg_clients_learning(prod_level,succ_level,1) / avg_clients_no_uncertainty(prod_level,succ_level,1);
        rel_clients_two(prod_level,succ_level) = avg_clients_learning(prod_level,succ_level,2) / avg_clients_no_uncertainty(prod_level,succ_level,2);
        rel_clients_three(prod_level,succ_level) = avg_clients_learning(prod_level,succ_level,3) / avg_clients_no_uncertainty(prod_level,succ_level,3);
        rel_clients_ten(prod_level,succ_level) = avg_clients_learning(prod_level,succ_level,10) / avg_clients_no_uncertainty(prod_level,succ_level,10);
        rel_sales_one(prod_level,succ_level) = avg_revenue_learning(prod_level,succ_level,3) / avg_revenue_no_uncertainty(prod_level,succ_level,3);
        rel_sales_two(prod_level,succ_level) = avg_revenue_learning(prod_level,succ_level,3) / avg_revenue_no_uncertainty(prod_level,succ_level,3);
        rel_sales_three(prod_level,succ_level) = avg_revenue_learning(prod_level,succ_level,3) / avg_revenue_no_uncertainty(prod_level,succ_level,3);
        rel_sales_ten(prod_level,succ_level) = avg_revenue_learning(prod_level,succ_level,10) / avg_revenue_no_uncertainty(prod_level,succ_level,10);

        %Any effect three years later?
        avg_clients_learning_one(prod_level,succ_level) =   avg_clients_learning(prod_level,succ_level,1);
        avg_clients_learning_two(prod_level,succ_level) =   avg_clients_learning(prod_level,succ_level,2);
        avg_clients_learning_three(prod_level,succ_level) = avg_clients_learning(prod_level,succ_level,3);
        avg_clients_learning_ten(prod_level,succ_level) =   avg_clients_learning(prod_level,succ_level,10);
        avg_clients_no_uncertainty_one(prod_level,succ_level) =   avg_clients_no_uncertainty(prod_level,succ_level,1);
        avg_clients_no_uncertainty_two(prod_level,succ_level) =   avg_clients_no_uncertainty(prod_level,succ_level,2);
        avg_clients_no_uncertainty_three(prod_level,succ_level) = avg_clients_no_uncertainty(prod_level,succ_level,3);
        avg_clients_no_uncertainty_ten(prod_level,succ_level) =   avg_clients_no_uncertainty(prod_level,succ_level,10);
        avg_sales_learning_one(prod_level,succ_level) =   avg_revenue_learning(prod_level,succ_level,1);
        avg_sales_learning_two(prod_level,succ_level) =   avg_revenue_learning(prod_level,succ_level,2);
        avg_sales_learning_three(prod_level,succ_level) = avg_revenue_learning(prod_level,succ_level,3);
        avg_sales_learning_ten(prod_level,succ_level) =   avg_revenue_learning(prod_level,succ_level,10);
        avg_sales_no_uncertainty_one(prod_level,succ_level) =   avg_revenue_no_uncertainty(prod_level,succ_level,1);
        avg_sales_no_uncertainty_two(prod_level,succ_level) =   avg_revenue_no_uncertainty(prod_level,succ_level,2);
        avg_sales_no_uncertainty_three(prod_level,succ_level) = avg_revenue_no_uncertainty(prod_level,succ_level,3);
        avg_sales_no_uncertainty_ten(prod_level,succ_level) =   avg_revenue_no_uncertainty(prod_level,succ_level,10);

        %Approximate standard errors (using formula var(X/Y) approx (E(X)/E(Y))^2 (var(X)/E(X) + var(Y)/E(Y) - 2cov(X,Y)/E(X)E(Y)), assume no covariance)
        rel_clients_one_se(prod_level,succ_level) = rel_clients_one(prod_level,succ_level) * sqrt(sd_clients_learning(prod_level,succ_level,1)^2 / avg_clients_learning(prod_level,succ_level,1) + sd_clients_no_uncertainty(prod_level,succ_level,1)^2 / avg_clients_no_uncertainty(prod_level,succ_level,1)) / sqrt(sim_firms);
        rel_clients_two_se(prod_level,succ_level) = rel_clients_two(prod_level,succ_level) * sqrt(sd_clients_learning(prod_level,succ_level,2)^2 / avg_clients_learning(prod_level,succ_level,2) + sd_clients_no_uncertainty(prod_level,succ_level,2)^2 / avg_clients_no_uncertainty(prod_level,succ_level,2)) / sqrt(sim_firms);
        rel_clients_three_se(prod_level,succ_level) = rel_clients_three(prod_level,succ_level) * sqrt(sd_clients_learning(prod_level,succ_level,3)^2 / avg_clients_learning(prod_level,succ_level,3) + sd_clients_no_uncertainty(prod_level,succ_level,3)^2 / avg_clients_no_uncertainty(prod_level,succ_level,3)) / sqrt(sim_firms);
        rel_clients_ten_se(prod_level,succ_level) = rel_clients_ten(prod_level,succ_level) * sqrt(sd_clients_learning(prod_level,succ_level,10)^2 / avg_clients_learning(prod_level,succ_level,10) + sd_clients_no_uncertainty(prod_level,succ_level,10)^2 / avg_clients_no_uncertainty(prod_level,succ_level,10)) / sqrt(sim_firms);
        rel_sales_one_se(prod_level,succ_level) = rel_sales_one(prod_level,succ_level) * sqrt(sd_revenue_learning(prod_level,succ_level,1)^2 / avg_revenue_learning(prod_level,succ_level,1) + sd_revenue_no_uncertainty(prod_level,succ_level,1)^2 / avg_revenue_no_uncertainty(prod_level,succ_level,1)) / sqrt(sim_firms);
        rel_sales_two_se(prod_level,succ_level) = rel_sales_two(prod_level,succ_level) * sqrt(sd_revenue_learning(prod_level,succ_level,2)^2 / avg_revenue_learning(prod_level,succ_level,2) + sd_revenue_no_uncertainty(prod_level,succ_level,2)^2 / avg_revenue_no_uncertainty(prod_level,succ_level,2)) / sqrt(sim_firms);
        rel_sales_three_se(prod_level,succ_level) = rel_sales_three(prod_level,succ_level) * sqrt(sd_revenue_learning(prod_level,succ_level,3)^2 / avg_revenue_learning(prod_level,succ_level,3) + sd_revenue_no_uncertainty(prod_level,succ_level,3)^2 / avg_revenue_no_uncertainty(prod_level,succ_level,3)) / sqrt(sim_firms);
        rel_sales_ten_se(prod_level,succ_level) = rel_sales_ten(prod_level,succ_level) * sqrt(sd_revenue_learning(prod_level,succ_level,10)^2 / avg_revenue_learning(prod_level,succ_level,10) + sd_revenue_no_uncertainty(prod_level,succ_level,10)^2 / avg_revenue_no_uncertainty(prod_level,succ_level,10)) / sqrt(sim_firms);

    end
end

%Write output
csvwrite('results/learning_cf/learning_cf_clients_three.csv',rel_clients_three,2,2);
csvwrite('results/learning_cf/learning_cf_clients_ten.csv',rel_clients_ten,2,2);
csvwrite('results/learning_cf/learning_cf_sales_three.csv',rel_sales_three,2,2);
csvwrite('results/learning_cf/learning_cf_sales_ten.csv',rel_sales_ten,2,2);
csvwrite('results/learning_cf/learning_cf_clients_three_se.csv',rel_clients_three_se,2,2);
csvwrite('results/learning_cf/learning_cf_clients_ten_se.csv',rel_clients_ten_se,2,2);
csvwrite('results/learning_cf/learning_cf_sales_three_se.csv',rel_sales_three_se,2,2);
csvwrite('results/learning_cf/learning_cf_sales_ten_se.csv',rel_sales_ten_se,2,2);
csvwrite('results/learning_cf/learning_cf_clients_learning_three.csv',avg_clients_learning_three,2,2);
csvwrite('results/learning_cf/learning_cf_clients_no_uncertainty_three.csv',avg_clients_no_uncertainty_three,2,2);
csvwrite('results/learning_cf/learning_cf_sales_learning_three.csv',avg_sales_learning_three,2,2);
csvwrite('results/learning_cf/learning_cf_sales_no_uncertainty_three.csv',avg_sales_no_uncertainty_three,2,2);
csvwrite('results/learning_cf/learning_cf_clients_learning_ten.csv',avg_clients_learning_ten,2,2);
csvwrite('results/learning_cf/learning_cf_clients_no_uncertainty_ten.csv',avg_clients_no_uncertainty_ten,2,2);
csvwrite('results/learning_cf/learning_cf_sales_learning_ten.csv',avg_sales_learning_ten,2,2);
csvwrite('results/learning_cf/learning_cf_sales_no_uncertainty_ten.csv',avg_sales_no_uncertainty_ten,2,2);

