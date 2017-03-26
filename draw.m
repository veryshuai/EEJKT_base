function [bigvec, ff, iaccept, rand_index] = draw(bigvec, block, lb, ub, chol_var, ff, rand_list, rand_index)

% draw innovation from normal proposal distribution

cat(1,lb,ub)

curr = bigvec(block);
[~,b] = size(curr);
prop = curr + (chol_var*norminv(rand_list(rand_index:rand_index+b-1),0,1))';
rand_index = rand_index + b;

% reject if prop outside bounds of prior. Since prior is uniform, all
% other proposed vectors get equal prior weight.

cat(1,lb,prop,ub)

if min(prop-lb) < 0 || max(prop-ub) > 0;
    iaccept = 0;
else

% otherwise determine whether to accept and update parameter vector

tempvec = bigvec;
tempvec(block) = prop;
[rllprop,~,~,~] = distance_noprod(tempvec, 0, 1);
delta   = -log(rllprop/ff)
accprob = min(0,delta);
u = log(rand_list(rand_index))
rand_index = rand_index + 1;
if u < accprob && rllprop < 1e+12; 
    iaccept = 1 ;
    bigvec = tempvec;
    ff = rllprop;
else    
    iaccept = 0;
end
end
end
