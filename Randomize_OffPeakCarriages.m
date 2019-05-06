function new_params = Randomize_OffPeakCarriages(params)
% randomize off peak hour carriages: +/-1 to 1st/2nd class carriages

tmp = [-1, 1];
for i=1:100
    new_params = params;
    rnd = datasample(tmp, 1);
    if rand() > 0.5
        new_params.CarriagesOffPeak(1) = new_params.CarriagesOffPeak(1) + rnd;
    else
        new_params.CarriagesOffPeak(2) = new_params.CarriagesOffPeak(2) + rnd;
    end   
    feasible = CheckFeasibility(new_params);
    if feasible
       break
    end
end
if isequal(new_params, params)
    fprintf('Could not find feasible neighbor...');
end

end