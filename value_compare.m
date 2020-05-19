
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
all_matches_one_year = all_matches(all_matches(:,1) == 40,1:4);
[unique_firms,uniq_ind,~] = unique(all_matches_one_year(:,3));
annual_sales = accumarray(all_matches_one_year(:,3),all_matches_one_year(:,4));
all_exporters = [unique_firms,all_matches_one_year(uniq_ind,2),annual_sales(annual_sales>0)];
all_exporters(:,4:5) = pt_type(all_exporters(:,2),:);
all_exporters = sortrows(all_exporters,3); %sort based on sales

% median_prod = [10,floor(prctile(all_exporters(:,4),10));50,floor(prctile(all_exporters(:,4),50));90,floor(prctile(all_exporters(:,4),90))]
median_succ = [10,floor(prctile(all_exporters(:,5),10));50,floor(prctile(all_exporters(:,5),50));90,floor(prctile(all_exporters(:,5),90))]

median_prod = [10,14;50,15;90,16] %these are from the learning version, to make plots comparable

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Now we have both the median productivity and success probabilities in hand
%simulate value for these different types and plot

X = [-3.28408	-3.46017	0.11078	5.24215	1.95079	15.43122 0.50771	12.47973	1.40083	-1.20141	13.66635	-6.27298];

X2params;

%USE FOREIGN PARAMETERS FOR HOME
%This way we can use value functions to learn about the importance of learning vs network
scale_h = scale_f;
F_h = F_f;
cs_h = cs_f;
    
SetParams;
inten_sim_v1;

% Key to value functions
% value_f (succ, trial, common succ rate (defunct), network size, prod of firm, F macro shock) 
% value_h (common succ rate (defunct), known succ rate, network size, prod of firm, H macro shock)

%marginal value of another successful foreign client
marg_val_succ_f = zeros(20,3);
val_succ_f = zeros(20,3);
marg_val_succ_f_percent = zeros(20,3);

%marginal value of another unsuccessful foreign client
marg_val_fail_f = zeros(20,3);
val_fail_f = zeros(20,3);
marg_val_fail_f_percent = zeros(20,3);

%marginal value of another successful home client
marg_val_succ_h = zeros(20,3);
val_succ_h = zeros(20,3);
marg_val_succ_h_percent = zeros(20,3);

%marginal value of alternating success and failures for foreign client
marg_val_alt_f = zeros(20,3);
val_alt_f = zeros(20,3);
marg_val_alt_f_percent = zeros(20,3);

%median_succ(:,2) = 7; %only matters for home anyway!  Set to maximum

for type = 1:3

    % for k = 1:20
    %     val_succ_f(k,type) = value_f(k,k,1,k,median_prod(type,2),7); marg_val_succ_f(k,type)  = value_f(k+1,k+1,1,k+1,median_prod(type,2),7) - value_f(k,k,1,k,median_prod(type,2),7);
    %     marg_val_succ_f_percent(k,type) = (value_f(k+1,k+1,1,k+1,median_prod(type,2),7) - value_f(k,k,1,k,median_prod(type,2),7))/value_f(k,k,1,k,median_prod(type,2),7);
    % end

    for k = 1:20
        val_succ_f(k,type) = value_f(1,3,k,median_prod(type,2),7);
        marg_val_succ_f(k,type)  = value_f(1,3,k+1,median_prod(type,2),7) - value_f(1,3,k,median_prod(type,2),7);
        marg_val_succ_f_percent(k,type) = (value_f(1,3,k+1,median_prod(type,2),7) - value_f(1,3,k,median_prod(type,2),7))/value_f(1,3,k,median_prod(type,2),7);
    end
    
    for k = 1:20
        val_alt_f(k,type) = value_f(1,3,floor(k/2) + mod(k,2),median_prod(type,2),7);
        marg_val_alt_f(k,type)  = value_f(1,3,floor((k+1)/2)+mod(k+1,2),median_prod(type,2),7) - value_f(1,3,floor((k)/2)+mod(k,2),median_prod(type,2),7);
        marg_val_alt_f_percent(k,type) = (value_f(1,3,floor((k+1)/2)+mod(k+1,2),median_prod(type,2),7) - value_f(1,3,floor((k)/2)+mod(k,2),median_prod(type,2),7))/value_f(1,3,floor((k)/2)+mod(k,2),median_prod(type,2),7);
    end
    
    for k = 1:20
        val_fail_f(k,type) = value_f(1,3,1,median_prod(type,2),7);
        marg_val_fail_f(k,type)  = value_f(1,3,1,median_prod(type,2),7) - value_f(1,3,1,median_prod(type,2),7);
        marg_val_fail_f_percent(k,type) = (value_f(1,3,1,median_prod(type,2),7) - value_f(1,3,1,median_prod(type,2),7))/value_f(1,3,1,median_prod(type,2),7);
    end
%     for k = 1:20
%         val_fail_f(k,type) = value_f(1,k,1,1,median_prod(type,2),7);
%         marg_val_fail_f(k,type)  = value_f(1,k+1,1,1,median_prod(type,2),7) - value_f(1,k,1,1,median_prod(type,2),7);
%         marg_val_fail_f_percent(k,type) = (value_f(1,k+1,1,1,median_prod(type,2),7) - value_f(1,k,1,1,median_prod(type,2),7))/value_f(1,k,1,1,median_prod(type,2),7);
%     end
    
    for k = 1:20
        val_succ_h(k,type) = value_h(1,7,k,median_prod(type,2),7);
        marg_val_succ_h(k,type)  = value_h(1,7,k+1,median_prod(type,2),7) - value_h(1,7,k,median_prod(type,2),7);
        marg_val_succ_h_percent(k,type) = (value_h(1,7,k+1,median_prod(type,2),7) - value_h(1,7,k,median_prod(type,2),7))/value_h(1,7,k,median_prod(type,2),7);
    end

    for k = 1:20
        val_alt_h(k,type) = value_h(1,7,k,median_prod(type,2),7);
        marg_val_alt_h(k,type)  = value_h(1,7,k+1,median_prod(type,2),7) - value_h(1,7,k,median_prod(type,2),7);
        marg_val_alt_h_percent(k,type) = (value_h(1,7,k+1,median_prod(type,2),7) - value_h(1,7,k,median_prod(type,2),7))/value_h(1,7,k,median_prod(type,2),7);
    end

%     for k = 1:20
%         succs = floor(k/2) + 1;
%         val_alt_f(k,type) = value_f(succs,k,1,succs,median_prod(type,2),7); 
%         marg_val_alt_f(k,type)  = value_f(succs-mod(k,2)+1,k+1,1,succs-mod(k,2)+1,median_prod(type,2),7) - value_f(succs,k,1,succs,median_prod(type,2),7);
%         marg_val_alt_f_percent(k,type) = (value_f(succs-mod(k,2)+1,k+1,1,succs-mod(k,2)+1,median_prod(type,2),7) - value_f(succs,k,1,succs,median_prod(type,2),7))/value_f(succs,k,1,succs,median_prod(type,2),7);
%     end

end

%Plots
plot(log(val_succ_f));
hold on
plot(log(val_alt_f));
hold on
plot(log(val_fail_f));
xlabel('Matches')
ylabel('1992 USD')
title({'Log value in foreign market','Excludes profit flow from current relationships'})
hold off
saveas(gcf,"results/value_plots/val_f_three_types.png");

plot(val_succ_f(:,2));
hold on
plot(val_alt_f(:,2));
hold on
plot(val_fail_f(:,2));
xlabel('Matches')
ylabel('1992 USD')
title({'Value in foreign market','Excludes profit flow from current relationships'})
hold off
saveas(gcf,"results/value_plots/val_f.png");

plot(marg_val_succ_f(:,2));
hold on
plot(marg_val_alt_f(:,2));
hold on
plot(marg_val_fail_f(:,2));
xlabel('Matches')
ylabel('1992 USD')
title({'Marginal client value in foreign market','Excludes additional profit flow'})
hold off
saveas(gcf,"results/value_plots/marg_val_f.png");

plot(marg_val_succ_f_percent(:,2));
hold on
plot(marg_val_alt_f_percent(:,2));
hold on
plot(marg_val_fail_f_percent(:,2));
xlabel('Matches')
ylabel('1992 USD')
title({'Marginal client value in foreign market','fraction of total value'})
hold off
saveas(gcf,"results/value_plots/marg_val_f_percent.png");

%Plots
plot(val_alt_h(:,2));
xlabel('Matches')
ylabel('1992 USD')
title({'No learning value in foreign market','Excludes profit flow from current relationships'})
hold on
plot(val_alt_f(:,2));
hold off
saveas(gcf,"results/value_plots/val_h.png");

plot(marg_val_alt_h(:,2));
xlabel('Matches')
ylabel('1992 USD')
title({'No learning marginal client value in foreign market','Excludes additional profit flow'})
saveas(gcf,"results/value_plots/marg_val_h.png");

plot(marg_val_alt_h_percent(:,2));
xlabel('Matches')
ylabel('1992 USD')
title({'No learning marginal client value in foreign market','fraction of total value'})
hold off
saveas(gcf,"results/value_plots/marg_val_h_percent.png");

%%% Time to learn

% In this exercise, we consider how long it will take identical firms to
% reach N matches, conditional on the arrival of successes.  Let us assume
% that the firm will get exactly N/2 successes, the question is when the
% successes arrive.  Just so we have a simple ordering, we assume that the
% successes all arrive consecutively, but start in different years.

% value_h (common succ rate (defunct), known succ rate, network size, prod of firm, H macro shock)

cum_year_mat = zeros(6,1);
for start_yr = 1:6

    succ_seq = zeros(10);
    succ_seq(start_yr:start_yr + 4) = 1;
    
    cum_years = 0;
    succs = 1;
    trials = 1;
    for match_no = 0:10
        trials = trials + 1;
        succs = succs + succ_seq(match_no + 1); 
        cum_years = cum_years + 1 / (12 * lambda_f(1,3,succs,17,7));
    end
    
    cum_year_mat(start_yr) = cum_years;
end
    
bar(cum_year_mat);
xlabel('Year of first success');
ylabel('Years to ten trials');
title('Five successes in ten trials');
saveas(gcf,"results/value_plots/success_order.png");




