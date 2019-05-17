function params = Rand_PFreq(params, N)
%% Change peak time train frequency
%
%% INPUT:
%  params - parameters of the simulation
%  N - rate of change
feasible = 0;
while ~feasible
    if rand() > 0.5
        params.FreqPeak = params.FreqPeak + N;
    else
        params.FreqPeak = params.FreqPeak - N;
    end
    feasible = CheckFeasibility(params);
end
end
