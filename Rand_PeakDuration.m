function newparams = Rand_PeakDuration(params, N)
%% Change peak time duration
%
%% INPUT:
%  params - parameters of the simulation
%  N - rate of change
feasible = 0;
newparams = params;
while ~feasible
    if rand() > 0.5
        newparams.ShiftPeakStart = params.ShiftPeakStart - 0.5*N;
        newparams.ShiftPeakEnd = params.ShiftPeakEnd + 0.5*N;
    else
        newparams.ShiftPeakStart = params.ShiftPeakStart + 0.5*N;
        newparams.ShiftPeakEnd = params.ShiftPeakEnd - 0.5*N;
    end
    feasible = CheckFeasibility(newparams);
end
end
