function params = Rand_PCarr(params, class, N)
%% Change peak time carriage comp
%
%% INPUT:
%  params - parameters of the simulation
%  class - first or second class of carriages
%  N - rate of change
feasible = 0;
while ~feasible
    if rand() > 0.5
        params.CarriagesPeak(class) = params.CarriagesPeak(class) + N;
    else
        params.CarriagesPeak(class) = params.CarriagesPeak(class) - N;
    end
    feasible = CheckFeasibility(params);
end
end
