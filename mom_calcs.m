% This script contains moment (statistic) calculations for search and learning model

% This script implements the file "system_of_moments_dj2.pdf"

%%%%%%%%%%%%%%%%%% Create regressors 

% number of clients
cli_no_f = clients_mat(:,1:2:end);

% share of first year matches  
match_fy = cell(S,1);
share_fy = cell(S,1);
for j=1:S % sum up all first years 
    [val,row] = max(match_sales_foreign_cell{j}~=0,[],1); %max takes the first element if there is a tie
    includes_first_obs_year = sparse(row,1:size(row,2),ones(size(row)),TT - burn,max(size(row,2),maxc)); %make it sparse
    match_fy{j} = includes_first_obs_year; %includes_first_obs_year(1:end,:) (NB: should remove first year?)
    share_fy{j} = sum(match_fy{j},2) ./ cli_no_f(1:end,j); %make it a share of total clients
end

% Age of exporter, first and last export year dummies
exp_age = zeros(size(firm_num_vec_mat)); exp_first = zeros(size(firm_num_vec_mat)); exp_last = zeros(size(firm_num_vec_mat)); 
last_firm_in_column = zeros(S,1); %this holds the last firm to loop through for each column of data
first_firm_in_column = zeros(S,1); %this holds the number of the first post-burn-in firm
%count durations and total export
firm_count = 0; %track the number of firms
exporter_count = 0; %track the number of exporters
for j = 1:S
    first_firm_in_column(j) = firm_num_vec_mat(1,j);
    last_firm_in_column(j) = firm_num_vec_mat(end,j);
    for k=first_firm_in_column(j):last_firm_in_column(j)
        [first_exp_row, ~] = find((sales_mat(:,2*j - 1)>0) & (firm_num_vec_mat(:,j) == k),1,'first'); %find first year of export
        [last_exp_row,~] = find((sales_mat(:,2*j - 1)>0) & (firm_num_vec_mat(:,j) == k),1,'last'); %find last year of export
        exp_age(first_exp_row:last_exp_row,j) = 1:last_exp_row - first_exp_row + 1; %running age
        exp_first(first_exp_row,j) = 1; exp_last(last_exp_row,j) = 1; %dummies for first and last year of exports
        firm_count = firm_count + 1; %iterate firm number
        if isempty(first_exp_row) == 0 %if this firm ever exports
            exporter_count = exporter_count + 1; %iterate exporter number
        end
    end
end

% Age of match, first and last match period dummies, as well as exporter age
match_age = cell(S,1); match_first = match_age; match_last = match_age; match_exp_age = match_age; match_sales_foreign_reduced = match_age;
%count durations and total export
for j = 1:S
    this_column_has_match = sum(match_sales_foreign_cell{j}); %we don't want to waste time on empty rooms
    [min_match_number,~] = find(this_column_has_match',1,'first');
    [max_match_number,~] = find(this_column_has_match',1,'last');
    match_sales_foreign = match_sales_foreign_cell{j}; %decell 
    match_age{j} = zeros(size(match_sales_foreign,1),max_match_number-min_match_number+1); match_first{j} = zeros(size(match_sales_foreign,1),max_match_number-min_match_number+1); match_last{j} = zeros(size(match_sales_foreign,1),max_match_number-min_match_number+1); match_exp_age{j} = zeros(size(match_sales_foreign,1),max_match_number-min_match_number+1); match_sales_foreign_reduced{j} = zeros(size(match_sales_foreign,1),max_match_number-min_match_number+1);%initialize
    for k = min_match_number:max_match_number
        if this_column_has_match(k) > 0
            [first_exp_row, ~] = find(match_sales_foreign(:,k),1,'first'); %find first year of match
            [last_exp_row, ~] = find(match_sales_foreign(:,k),1,'last'); %find last year of match
            match_age{j}(first_exp_row:last_exp_row,k-min_match_number + 1) = 1:last_exp_row - first_exp_row + 1; %running age
            match_exp_age{j}(first_exp_row:last_exp_row,k-min_match_number + 1) = exp_age(first_exp_row:last_exp_row,j); %age of exporting firm
            match_first{j}(first_exp_row,k-min_match_number + 1) = 1; match_last{j}(last_exp_row,k-min_match_number + 1) = 1; %dummies for first and last year of match
            match_sales_foreign_reduced{j}(first_exp_row:last_exp_row,k-min_match_number + 1) = match_sales_foreign(first_exp_row:last_exp_row,k); %make match sales matrix of same size as other matrices 
        end
    end
end          

% Average match age by firm
avg_match_age = zeros(size(firm_num_vec_mat));
for j=1:S % sum up all first years
    match_age_mat = match_age{j};
    avg_match_age(:,j) = sum(match_age_mat,2) ./ sum(match_age_mat~=0,2); %this gives me the average age by year, unless no clients in which case NaN 
end

% Match lag regression variables
match_lags = cell(size(firm_num_vec_mat,2),1); %a cell for each firm
last_match = cell(size(firm_num_vec_mat,2),1); %a cell for each firm
month_fe = cell(size(firm_num_vec_mat,2),1); %a cell for each firm
trials = cell(size(firm_num_vec_mat,2),1); %a cell for each firm
success = cell(size(firm_num_vec_mat,2),1); %a cell for each firm
success_rate = cell(size(firm_num_vec_mat,2),1); %a cell for each firm
unique_firm_id = cell(size(firm_num_vec_mat,2),1); %a cell for each firm
 
running_firm_id = 0;
for j=1:S %iterate through firms

	% find last recorded row%most matrices are sparse, this saves time by telling me how far down to search.  Flipud flips the matrix up to down, and max reports the backwards first entry of the highest firm number
	[maximum_val,last_backwards] = max(flipud(match_time_foreign_cell{j}(:,3)));
	if maximum_val > 0 
    	last = maxc - last_backwards + 1; %flip the answer from the last line around.  Last entry in the matrix
	else 
		last = 1;
	end
	
    % give each firm an id
    unique_firm_id{j} = match_time_foreign_cell{j}(1:last,3) + running_firm_id;
    running_firm_id = unique_firm_id{j}(last);

    % create match lags and a last match dummy
    new_firm = [1;match_time_foreign_cell{j}(2:last,3) ~= match_time_foreign_cell{j}(1:last-1,3)]; %flag firm changes, will use this a few times below in creating match lag regression varialbes.  Note entry is a new firm.
    match_lags{j} = [0;match_time_foreign_cell{j}(2:last,1) - match_time_foreign_cell{j}(1:last-1,1)]; %extra zero keeps index correct for regressions
    month_fe{j} = [0;floor(match_time_foreign_cell{j}(2:last,1) * 12)];
    match_lags{j}(new_firm==1) = 0; %don't count lag in times between firm changes (if the 2nd match is a new firm, we shouldn't count the first lag, etc.)
    last_match{j} = zeros(size(new_firm)); %set up empty matrix
    last_match{j}(1:end-1) = new_firm(2:last); %The last match is the match in which the next match is for a new firm (exogenous firm death)
    last_match{j}(1:end) = max(match_time_foreign_cell{j}(1:last,4),last_match{j}(1:end)); %Write in endogenous last matches

	%trials
    increment = (1:last)'; %will use this for trials
    [new_firm_row,~] = find(new_firm); % get the row indeces of new firms
    trials{j} = increment - new_firm_row(findgroups(match_time_foreign_cell{j}(1:last,3))) + 1; %hard to explain, but this resets the index for every new firm

    %successes (and last match correction, only want to loop through new_firm's once)
    success{j} = zeros(last,1);
    last_index = 1;
    for k=1:size(new_firm_row,1)
        success{j}(last_index:new_firm_row(k)) = cumsum(match_time_foreign_cell{j}(last_index:new_firm_row(k),2)); %cumulate successes

        %inside loop, all firms die.  Find method is slower, but more intuitive.  This gives same result 
        %  true_last_match = find(last_match{j}(last_index:new_firm_row(k)),1,'last');
        %  last_match{j}(last_index:new_firm_row(k)) = 0; 
        %  last_match{j}(last_index - 1 + true_last_match) = 1;
        if new_firm_row(k) ~= 1
            last_match{j}(last_index:new_firm_row(k)) = 0; 
            last_match{j}(new_firm_row(k)-1) = 1;
        end


        %next
        last_index = new_firm_row(k);

    end
    success{j}(last_index:last) = cumsum(match_time_foreign_cell{j}(last_index:last,2)); % loop above skips the last firm, this does it
    true_last_match = find(last_match{j}(last_index:last),1,'last'); 
    last_match{j}(last_index:last) = 0;
    if true_last_match == last_index -1 + last %Only want to change this if export ended before the end of the simulation 
        last_match{j}(last) = 1;
    end

    %cumulative success rate
    success_rate{j} = success{j} ./ trials{j};

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% convert things from cells to matrices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sale_h_mat = sales_mat(:,2:2:end);
%sale_f_spc = cell2mat(sale_f);
sale_f_mat = sales_mat(:,1:2:end);
ship_f_mat = shipments_mat(:,1:2:end);
share_fy_mat = cell2mat(share_fy);
success_mat = (cell2mat(success));
trials_mat = (cell2mat(trials));
success_rate_mat = (cell2mat(success_rate));
last_match_mat = (cell2mat(last_match));
match_lags_mat = (cell2mat(match_lags));
month_fe_mat = (cell2mat(month_fe));
month_fe_mat(month_fe_mat == 0) = 1; %can only create dummy vars with positive integers
unique_firm_id_mat = nominal(cell2mat(unique_firm_id)); %nominal creates a "categorical variable"  which we can use for fixed effects

%ship_f_spc = cell2mat(ship_f);
%sale_f_mat_count = (sale_f_mat>0);
%sh_ann_f_mat = cell2mat(sh_ann_f');
%sh_first_yr_dum_mat = cell2mat(sh_first_yr_dum');

%get matches in matrices, and only keep active match years
match_age_mat = cell2mat(match_age'); 
active_match = match_age_mat > 0;
match_first_mat = cell2mat(match_first'); match_first_mat = match_first_mat(active_match); 
match_last_mat = cell2mat(match_last'); match_last_mat = match_last_mat(active_match);
match_exp_age_mat = cell2mat(match_exp_age'); match_exp_age_mat = match_exp_age_mat(active_match);
match_sales_foreign_mat = cell2mat(match_sales_foreign_reduced'); match_sales_foreign_mat = match_sales_foreign_mat(active_match);
match_age_mat = match_age_mat(active_match);

% Offset client number and sales by one, which will make my life easier during the autoregression
cli_no_f_next_period = [cli_no_f(2:end,:);NaN * zeros(1,size(cli_no_f,2))];
match_sales_foreign_next_period = [match_sales_foreign_mat(2:end,:);NaN * zeros(1,size(match_sales_foreign_mat,2))];
sale_h_next_period = [sale_h_mat(2:end,:);NaN * zeros(1,size(sale_h_mat,2))];
sale_f_next_period = [sale_f_mat(2:end,:);NaN * zeros(1,size(sale_f_mat,2))];

%Make NaNs of firm changes
cli_no_f_next_period(firm_num_vec_mat ~= [firm_num_vec_mat(2:end,:);NaN * zeros(1,size(firm_num_vec_mat,2))]) = NaN; %if a firm dies, then set next period clients to NaN
sale_h_next_period(firm_num_vec_mat ~= [firm_num_vec_mat(2:end,:);NaN * zeros(1,size(firm_num_vec_mat,2))]) = NaN; %if a firm dies, then set next period home sales to NaN
sale_f_next_period(firm_num_vec_mat ~= [firm_num_vec_mat(2:end,:);NaN * zeros(1,size(firm_num_vec_mat,2))]) = NaN; %if a firm dies, then set next period foreign sales to NaN

%Prepare for match lag regressions
ln_inv_lag = - log(match_lags_mat); % expected value is the hazard rate
ln_trials  = log(1 + trials_mat);
ln_success = log(1 + success_mat);
ln_success2 = ln_success.^2;
ln_success_rate = log(1 + success_rate_mat);
ln_success_rate2 = ln_success_rate.^2;
ln_success_success_rate = ln_success .* ln_success_rate;

% %pack simulation info up to return it
% simulated_data{1} = cli_no_mat;
% simulated_data{2} = sale_h_mat;
% simulated_data{3} = sale_f_spc;
% simulated_data{4} = sale_f_mat;
% simulated_data{5} = ship_f_mat;
% simulated_data{6} = ship_f_spc;
% simulated_data{7} = sale_f_mat_count;
% simulated_data{8} = sh_ann_f_mat;
% simulated_data{9} = sh_first_yr_dum_mat;
% simulated_data{10} = [cost_f,cost_h];
% simulated_data{11} = [prods,succ_prob];
% simulated_data{12} = [st_cont,st_ind_cont,cost_vec];

%%%%%%%%%% Regressions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % To use stats package for fixed effect regs, we need a table object
% inc_row = isfinite(ln_inv_lag); %NaNs and infs not allowed
% tbl = table(ln_inv_lag(inc_row),ln_success(inc_row),ln_success2(inc_row),ln_success_rate(inc_row),ln_success_rate2(inc_row),ln_success_success_rate(inc_row),'VariableNames',{'inv_lag','success','success_sq','success_rate','success_rate_sq','success_success_rate_interact'});
% tbl.month_fe = nominal(month_fe_mat(inc_row)); %add fixed effects
% 
% % Now run the regression
% lag_reg_results = fitlm(tbl,'inv_lag ~ success + success_sq + success_rate + success_rate_sq + success_success_rate_interact + month_fe');
% match_lag_coefs = lag_reg_results.Coefficients.Estimate(2:6); %intercepts not reported in data

%% MATCH LAG ESTIMATION
%get only the reals
non_inf = ln_inv_lag > -Inf & ln_inv_lag < Inf; %find non infinite values of lhs
fe_base = findgroups(month_fe_mat(non_inf)); %matlab needs groups with consecutive integers starting at one to properly create fixed effects with dummyvar function
reg_mat = sparse([ln_inv_lag(non_inf),ones(size(ln_inv_lag(non_inf))),ln_success(non_inf),ln_success2(non_inf),ln_success_rate(non_inf),ln_success_rate2(non_inf),ln_success_success_rate(non_inf),dummyvar(fe_base)]);

% Test for rank
% if sprank(reg_mat(:,2:end-1)) ~= size(reg_mat(:,2:end-1),2)
%     ME = MException('mom_calcs:rank issue', ...
%         'Last match regressor matrix less than full rank');
%     throw(ME)
% end

match_lag_coefs = reg_mat(:,2:end-1) \ reg_mat(:,1);
%normalized_constant = mean([match_lag_coefs(1); match_lag_coefs(7:end)]); %stata reports "mean intercept", the intercept so that the average estimated fixed effect is zero
mean_match_lag = mean(reg_mat(:,1));
match_lag_coefs = [mean_match_lag;match_lag_coefs(2:6)]; %here is what we report

%% LAST MATCH ESTIMATION

last_match_coefs = reg_mat(:,2:end-1)\last_match_mat(non_inf);
%normalized_constant = mean([last_match_coefs(1); last_match_coefs(7:end)]); %stata reports "mean intercept", the intercept so that the average estimated fixed effect is zero
mean_last_match = mean(last_match_mat(non_inf));
last_match_coefs = [mean_last_match;last_match_coefs(2:6)]; %here is what we report
%% SUCCESS RATE ESTIMATION
sr_xmat = [ones(size(ln_success_rate(non_inf))),ln_trials(non_inf)];
succ_rate_coefs = sr_xmat \ ln_success_rate(non_inf);
succ_rate_coefs(1) = mean(ln_success_rate(non_inf));  %replace constant with mean of dep. var

uu_sq = (ln_success_rate(non_inf) - sr_xmat*succ_rate_coefs).^2;
sr_var_coefs = sr_xmat \ uu_sq;
sr_var_coefs(1) = mean(uu_sq);  %replace constant with mean of dep. var

%% OTHER ESTIMATION
% cli_coefs = regress_elim_nonreals(log(cli_no_f_next_period(cli_no_f(:) > 0)),ones(size(cli_no_f_next_period(cli_no_f(:) > 0))),share_fy_mat(cli_no_f(:) > 0),log(cli_no_f(cli_no_f(:) > 0)),log(cli_no_f(cli_no_f(:) > 0)).^2,log(avg_match_age(cli_no_f(:) > 0)),log(exp_age(cli_no_f(:) > 0)));

% exp_death_coefs = regress_elim_nonreals(exp_last(:),ones(size(cli_no_f_next_period(:))),cell2mat(share_fy),log(cli_no_f(:)),log(cli_no_f(:)).^2,log(avg_match_age(:)),log(exp_age(:)));

match_death_coefs = regress_elim_nonreals(match_last_mat,ones(size(match_last_mat)),match_first_mat,log(match_sales_foreign_mat),log(match_age_mat),log(match_exp_age_mat),[]);
% match_death_coefs(1) = mean(match_last_mat);  %replace constant with mean of dep. var

% exp_sales_coefs = regress_elim_nonreals(log(sale_f_mat) - log(cli_no_f),ones(size(sale_f_mat)),cell2mat(share_fy),log(cli_no_f),log(exp_age),[],[]);

[match_ar1_coefs,resids] = regress_elim_nonreals(log(match_sales_foreign_next_period(:)),ones(size(match_sales_foreign_next_period(:))),log(match_sales_foreign_mat(:)),match_first_mat(:),log(match_exp_age_mat(:)),[],[]);
match_ar1_coefs = [match_ar1_coefs;mean(resids.^2)]; % added the mean squared error for this regression 
% match_ar1_coefs(1) = mean(log(match_sales_foreign_next_period(match_sales_foreign_next_period(:)>0)));  %replace constant with mean of dep. var

[dom_ar1_raw_coefs,resids] = regress_elim_nonreals(log(sale_h_next_period(sale_h_mat > 0)),ones(size(sale_h_next_period(sale_h_mat>0))),log(sale_h_mat(sale_h_mat>0)),[],[],[],[]); 
dom_ar1_coefs = [dom_ar1_raw_coefs;mean(resids.^2)]; %added mse
% dom_ar1_coefs(1) = mean(log(sale_h_next_period(sale_h_next_period > 0)));  %replace constant with mean of dep. var

[exp_dom_raw_coefs,resids] = regress_elim_nonreals(log(sale_f_mat((sale_f_mat > 0) & (sale_h_mat > 0))),ones(size(sale_f_mat((sale_f_mat > 0) & (sale_h_mat > 0)))),log(sale_h_mat((sale_f_mat > 0) & (sale_h_mat > 0))),[],[],[],[]);
exp_dom_coefs = [exp_dom_raw_coefs;mean(resids.^2)];                                                  
% exp_dom_coefs(1) = mean(log(sale_f_mat((sale_f_mat > 0) & (sale_h_mat > 0))));  %replace constant with mean of dep. var
% intercept can be dropped in distance noprod 
                                                     
%foreign log log inverse-cdf slope and MSE
cli_no_for_only_mat = cli_no_f(cli_no_f(:) > 0);
% display('largest simulated client number:');
ub = max(cli_no_for_only_mat); %upper bound on client number
inv_cdf = zeros(ub,1);
try %allow errors due to no observations etc to be caught
    for k = 1:ub
        inv_cdf(k) = sum(cli_no_for_only_mat>=k);
    end
    inv_cdf = inv_cdf/size(cli_no_for_only_mat,1);
    [loglog_coefs,~,r] = regress(log(inv_cdf),[ones(ub,1),log((1:ub)'),log((1:ub)').^2]);
    loglog_coefs(1) = mean(log(inv_cdf));  %replace constant with mean of dep. var
    % display(b);
    MSE = sum(r.^2)/ub;
    clidist = [loglog_coefs(2);loglog_coefs(3);MSE]; % use this instead of loglog_coefs if want to include MSE
catch err
    getReport(err, 'extended') %report error
    clidist = [100;100];
end

% Print diagnostic information
% fprintf('\r\n Largest simulated client number is: '); 
% fprintf('\r\n%8.3f' ,ub);

%average shipments per foreign client per year
mavship = nanmean(log(ship_f_mat(ship_f_mat(:)>0 & ship_f_mat(:) < Inf)./cli_no_f(ship_f_mat(:) > 0& ship_f_mat(:) < Inf)));

%mean domestic sales over foreign sales for firms with positive foreign sales
for_sales_shr = mean(sale_f_mat(sale_f_mat>0)./(sale_f_mat(sale_f_mat>0)+sale_h_mat(sale_f_mat>0)));

% Count the number of exporters 
%pbexp = sum(sum(sale_f_mat)>1);
pbexp = exporter_count; %new count of exporters
exp_frac = exporter_count / firm_count; %fraction of exporters
