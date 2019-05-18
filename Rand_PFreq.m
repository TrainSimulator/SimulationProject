function newparams = Rand_PFreq(params, N)
%% Change peak time train frequency
%
%% INPUT:
%  params - parameters of the simulation
%  N - rate of change
feasible = 0;
newparams = params;
while ~feasible
    if rand() > 0.5
        newparams.FreqPeak = params.FreqPeak + N;
    else
        newparams.FreqPeak = params.FreqPeak - N;
    end
    feasible = CheckFeasibility(newparams);
end
end
