function newparams = Rand_ShiftPeak(params, N)
%% Shift peak time intervall
%
%% INPUT:
%  params - parameters of the simulation
%  N - rate of change
PeakDuration = params.ShiftPeakEnd - params.ShiftPeakStart;
feasible = 0;
newparams = params;
while ~feasible
    if rand() > 0.5
        newparams.ShiftPeakStart = params.ShiftPeakStart + N;
    else
        newparams.ShiftPeakStart = params.ShiftPeakStart - N;
    end
    newparams.ShiftPeakEnd = newparams.ShiftPeakStart + PeakDuration;
    feasible = CheckFeasibility(newparams);
end
end
