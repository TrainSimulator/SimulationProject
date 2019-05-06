function new_params = Randomize_TrainFreq(params)
% randomize frequency of the trains: +/-[0, 1] to peak or off peak feq.

for i=1:100
    new_params = params;
    rnd = 2*rand()-1;  % random number from [-1, 1]
    if rand() > 0.5
        new_params.FreqPeak = new_params.FreqPeak + rnd;
    else
        new_params.FreqOffPeak = new_params.FreqOffPeak + rnd;
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