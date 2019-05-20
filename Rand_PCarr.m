function newparams = Rand_PCarr(params, class, N)
%% Change peak time carriage comp
%
%% INPUT:
%  params - parameters of the simulation
%  class - first or second class of carriages
%  N - rate of change
feasible = 0;
newparams = params;
while ~feasible
    % Fringe case that makes it otherwise impossible to do a change for N = 2:
    if params.CarriagesPeak(1) + params.CarriagesPeak(2) > 4 && params.CarriagesPeak(class) == 1
        N = 1;
    end

    if rand() > 0.5
        newparams.CarriagesPeak(class) = params.CarriagesPeak(class) + N;
    else
        newparams.CarriagesPeak(class) = params.CarriagesPeak(class) - N;
    end
    feasible = CheckFeasibility(newparams);
end
end
