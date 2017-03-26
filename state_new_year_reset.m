function state = state_new_year_reset(state)
%reset state for a new year

%set annual sales and shipments to zero
state(8:11) = zeros(4,1);

end