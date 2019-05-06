function new_params = Randomize_PeakHour(params)
% randomize start/end of the peak hours: +/-[0, 30] to start or end of peak hours

for i=1:100
    new_params = params;
    rnd = 60*rand()-1;  % random number from [-30, 30]
    if rand() > 0.5
        new_params.ShiftPeakStart = new_params.ShiftPeakStart + rnd;
    else
        new_params.ShiftPeakEnd = new_params.ShiftPeakEnd + rnd;
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