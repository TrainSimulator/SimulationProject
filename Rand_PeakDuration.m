function params = Rand_PeakDuration(params, N)
%% Change peak time duration
%
%% INPUT:
%  params - parameters of the simulation
%  N - rate of change
feasible = 0;
while ~feasible
    if rand() > 0.5
        params.ShiftPeakStart = params.ShiftPeakStart - 0.5*N;
        params.ShiftPeakEnd = params.ShiftPeakEnd + 0.5*N;
    else
        params.ShiftPeakStart = params.ShiftPeakStart + 0.5*N;
        params.ShiftPeakEnd = params.ShiftPeakEnd - 0.5*N;
    end
    feasible = CheckFeasibility(params);
end
end
