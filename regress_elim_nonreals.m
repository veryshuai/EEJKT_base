function [coefs,resid] = regress_elim_nonreals(y,x0,x1,x2,x3,x4,x5)
%this function eliminates non-real entries and does regress

xytmp = horzcat(y(:),x0(:),x1(:),x2(:),x3(:),x4(:),x5(:));
xytmp = xytmp((sum(xytmp,2) > -Inf) & (sum(xytmp,2) < Inf),:); %only keep rows with all real entries
[~,nc] = size(xytmp); %extract numer of columns
[coefs] = xytmp(:,2:nc)\xytmp(:,1); %do the regression
resid = xytmp(:,1) - xytmp(:,2:nc) * coefs;
coefs(1) = mean(xytmp(:,1)); %replace first regression coefficient (constant, hopefully) with the mean of the dep. var.

end

