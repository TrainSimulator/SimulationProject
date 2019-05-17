function params = Rand_OFreq(params, N)
%% Change off peak time train frequency
%
%% INPUT:
%  params - parameters of the simulation
%  N - rate of change
feasible = 0;
while ~feasible
    if rand() > 0.5
        params.FreqOffPeak = params.FreqOffPeak + N;
    else
        params.FreqOffPeak = params.FreqOffPeak - N;
    end
    feasible = CheckFeasibility(params);
end
end
