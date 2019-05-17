function params = Rand_ShiftPeak(params, N)
%% Shift peak time intervall
%
%% INPUT:
%  params - parameters of the simulation
%  N - rate of change
PeakDuration = params.ShiftPeakEnd - params.ShiftPeakStart;
feasible = 0;
while ~feasible
    if rand() > 0.5
        params.ShiftPeakStart = params.ShiftPeakStart + N;
    else
        params.ShiftPeakStart = params.ShiftPeakStart - N;
    end
    params.ShiftPeakEnd = params.ShiftPeakStart + PeakDuration;
    feasible = CheckFeasibility(params);
end
end
