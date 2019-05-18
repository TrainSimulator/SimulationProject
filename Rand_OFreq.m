function newparams = Rand_OFreq(params, N)
%% Change off peak time train frequency
%
%% INPUT:
%  params - parameters of the simulation
%  N - rate of change
feasible = 0;
newparams = params;
while ~feasible
    if rand() > 0.5
        newparams.FreqOffPeak = params.FreqOffPeak + N;
    else
        newparams.FreqOffPeak = params.FreqOffPeak - N;
    end
    feasible = CheckFeasibility(newparams);
end
end
