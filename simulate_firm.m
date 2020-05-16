%This script simulates a single firm for EEJKT
    
X = [ -4.60796  -3.75516   0.23144   2.46216   1.88125  15.42605...
  0.38246  10.72145   1.38618  -1.26451  13.00227  -6.13504];

X2params;
SetParams;
inten_sim_v1;
discrete_sim_parfor3;

save results/simulated_firm_data
