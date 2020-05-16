
% %This script calculates values of clients
% clear all;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % First order of business is figuring
% % out typical productivities and success
% % probabilities for "high revenue" and
% % "low revenue" firm sales percentiles
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
rng(80085);
% 
load results/value_plots/val_dat

%create data set containing only variables we need (no information about counterparty)
% all_exporters = [agg_type,firmID,annual_sales,prod_type,theta_type]
all_matches = all_matches(all_matches(:,1)>5,:); %post burn in only
firm_yr_id = all_matches(:,3) * 1000 + all_matches(:,1);
[unique_firms,uniq_ind,~] = unique(firm_yr_id);
annual_sales = accumarray(firm_yr_id,all_matches(:,4));
all_exporters = [unique_firms,all_matches(uniq_ind,2),annual_sales(annual_sales>0)];
all_exporters(:,4:5) = pt_type(all_exporters(:,2),:);
all_exporters = sortrows(all_exporters,3); %sort based on sales

%sales of top N% as share of total sales
top_ten_ind = floor(size(all_exporters,1)/10);
top_one_ind = floor(size(all_exporters,1)/100);
total_sales = sum(all_exporters(:,3));
top_ten_sales = sum(all_exporters(end-top_ten_ind:end,3));
top_one_sales = sum(all_exporters(end-top_one_ind:end,3));
percent_top_firm = all_exporters(end,3) / total_sales;
percent_top_one = top_one_sales / total_sales;
percent_top_ten = top_ten_sales / total_sales;

%empirical cdf
ecdf(log(all_exporters(:,3)));
xlabel('Log Sales')
saveas(gcf,"results/empirical_cdf/ecdf_log.png");

%empirical cdf
ecdf(all_exporters(:,3));
xlabel('Sales')
saveas(gcf,"results/empirical_cdf/ecdf_level.png");

%create data set containing only variables we need (no information about counterparty)
% all_exporters = [agg_type,firmID,annual_sales,prod_type,theta_type]
all_matches = all_matches(all_matches(:,1)>5,:); %post burn in only
firm_id = all_matches(:,3);
[unique_firms,uniq_ind,~] = unique(firm_id);
total_firm_sales = accumarray(firm_id,all_matches(:,4));
years_active = accumarray(firm_id,ones(size(all_matches,1),1));
annual_sales = total_firm_sales ./ years_active;
all_exporters = [unique_firms,all_matches(uniq_ind,2),annual_sales(annual_sales>0)];
all_exporters(:,4:5) = pt_type(all_exporters(:,2),:);
all_exporters = sortrows(all_exporters,3); %sort based on sales

%sales of top N% as share of total sales
top_ten_ind = floor(size(all_exporters,1)/10);
top_one_ind = floor(size(all_exporters,1)/100);
total_sales = sum(all_exporters(:,3));
top_ten_sales = sum(all_exporters(end-top_ten_ind:end,3));
top_one_sales = sum(all_exporters(end-top_one_ind:end,3));
percent_top_firm = all_exporters(end,3) / total_sales;
percent_top_one_avg = top_one_sales / total_sales;
percent_top_ten_avg = top_ten_sales / total_sales;

%empirical cdf
ecdf(log(all_exporters(:,3)));
xlabel('Log Sales')
saveas(gcf,"results/empirical_cdf/ecdf_log_avg.png");

%empirical cdf
ecdf(all_exporters(:,3));
xlabel('Sales')
saveas(gcf,"results/empirical_cdf/ecdf_level_avg.png");
