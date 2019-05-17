function params = Rand_OCarr(params, class, N)
%% Change off peak time carriage comp
%
%% INPUT:
%  params - parameters of the simulation
%  class - first or second class of carriages
%  N - rate of change
feasible = 0;
while ~feasible
    if rand() > 0.5
        params.CarriagesOffPeak(class) = params.CarriagesOffPeak(class) + N;
    else
        params.CarriagesOffPeak(class) = params.CarriagesOffPeak(class) - N;
    end
    feasible = CheckFeasibility(params);
end
end
