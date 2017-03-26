% This script calculates the fraction of sales from the largest client, using simulated data

load results/cf_sim_results.mat

% initialize 
sale_h = cell(S,1); % total home sales 
sale_largest_h = cell(S,1); %holds sales of only largest client
sale_f = cell(S,1); % total foreign sales
sale_largest_f = cell(S,1); %holds sales of only largest client
frac_largest_h = zeros(S,1); % firm by firm home fraction largest client sales
frac_largest_f = zeros(S,1); % firm by firm foreign fraction largest client sales
total_sale_to_largest_f = 0; % cross seller sales to largest client
total_sale_f = 0; % cross seller total sales

Z_big = [-inf,Z'];

for j = 1:S

    display(j)

    %Find the beginning and end of first post burn year
    beg_row = find(st_ind_cont{j}(:,1)<burn,1,'last');
    end_row = find(st_ind_cont{j}(:,1)<burn+1,1,'last');

    %Find largest home and foreign client (index)
    [home_largest_val,home_largest] = max(sum(exp(Z_big(ds{j}(beg_row:end_row,1:maxc)+1)).*sh{j}(beg_row:end_row,1:maxc),1)');
    [for_largest_val,for_largest] = max(sum(exp(Z_big(ds{j}(beg_row:end_row,maxc+1:2*maxc)+1)).*sh{j}(beg_row:end_row,maxc+1:2*maxc),1)');

    %Calculate home sales (continuous time)
    sale_h{j} = exp(scale_h)*exp(Phi(st_ind_cont{j}(beg_row:end_row,2))).^(eta-1).*exp(X_h(st_ind_cont{j}(beg_row:end_row,3))).*sum(exp(Z_big(ds{j}(beg_row:end_row,1:maxc)+1)).*sh{j}(beg_row:end_row,1:maxc),2); %total
    sale_largest_h{j} = exp(scale_h)*exp(Phi(st_ind_cont{j}(beg_row:end_row,2))).^(eta-1).*exp(X_h(st_ind_cont{j}(beg_row:end_row,3))).*sum(exp(Z_big(ds{j}(beg_row:end_row,home_largest)+1))'.*sh{j}(beg_row:end_row,home_largest),2); %largest client

    scale_f_vec = exp(scale_f); % Foreign sales scale

    % calculate foreign sales (continuous time
    sale_f{j} = scale_f_vec.*exp(Phi(st_ind_cont{j}(beg_row:end_row,2))).^(eta-1).*exp(X_f(st_ind_cont{j}(beg_row:end_row,4))).*sum(exp(Z_big(ds{j}(beg_row:end_row,maxc+1:2*maxc)+1)).*sh{j}(beg_row:end_row,maxc+1:2*maxc),2); %total
    sale_largest_f{j} = scale_f_vec.*exp(Phi(st_ind_cont{j}(beg_row:end_row,2))).^(eta-1).*exp(X_f(st_ind_cont{j}(beg_row:end_row,4))).*sum(exp(Z_big(ds{j}(beg_row:end_row,maxc + for_largest)+1))'.*sh{j}(beg_row:end_row,maxc + for_largest),2); %largest client
    
    %Calculate the fraction of sales from the largest client (possibly NaN
    %if zero sales
    frac_largest_h(j) = sum(sale_largest_h{j}) / sum(sale_h{j}); 
    frac_largest_f(j) = sum(sale_largest_f{j}) / sum(sale_f{j});

    %For CJ version, get running sum
    total_sale_to_largest_f = nansum([total_sale_to_largest_f;sale_largest_f{j}]);
    total_sale_f = nansum([total_sale_f;sale_f{j}]);

end

%Average fraction of sales from the largest client
avg_largest_frac_f = nansum(frac_largest_f) / nansum(frac_largest_f > 0) % baseline
avg_largest_frac_f_mult_clients = nansum(frac_largest_f(frac_largest_f < 1)) / nansum(frac_largest_f(frac_largest_f < 1) > 0) % only multiple seller firms

%CJ version
total_sale_to_largest_f / total_sale_f

%Histograms of raw and only multiple client firms
histogram(frac_largest_f); 
histogram(frac_largest_f(frac_largest_f < 1));



