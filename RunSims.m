function [objectives, avg_waittimes, avg_profits] = RunSims(params, nsims)
% runs simulations and return objectives

avg_waittimes = zeros(1, nsims);
avg_profits = zeros(1, nsims);
for i=1:nsims
    % run sims and store indicators
    scenario = NewScenario(params);
    [~, ~, waittime, gain, loss] = Simulation(scenario);
    avg_waittimes(1, i) = mean(waittime);
    avg_profits(1, i) = gain - loss;
end
% get objectives
objectives = [mean(avg_waittimes), -mean(avg_profits)];


end