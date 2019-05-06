%% Optimization via Variable Neighborhood Search
clc; clear all; close all; rng default;

max_it = 10;  % maximal number of opt. iterations
nsims = 20;  % number of sims to run per 1 opt. iteration
savename = 'first_opt';  % name of saved .mat file
randomize = @Randomize_TrainFreq;

% initial parameters
params.FreqPeak = 4;
params.FreqOffPeak = 1.8;
params.CarriagesPeak = [2, 3];
params.CarriagesOffPeak = [1, 2];
params.ShiftPeakStart = -40;
params.ShiftPeakEnd = -10;

feasible = CheckFeasibility(params);
assert(feasible == 1);
params_all = params;

tic;
% initial solution:
[objectives_all, ~, ~] = RunSims(params, nsims);

it = 1;
while it
    % visit neighbor and update if the solution is better
    for i=1:10
        candidate_params = randomize(params);
        [objectives, ~, ~] = RunSims(candidate_params, nsims);
        if any((objectives - objectives_all(end, :)) < 0.)
            params = candidate_params;
            params_all = [params_all; params];
            objectives_all = [objectives_all; objectives];  
            break
        end
    end
    % save results (frequently)
    if mod(it, 2) == 0
        save(savename, 'params_all', 'objectives_all');
        fprintf('%i iterations reached, results saved!\n', it);
    end
    % stop optimization if the solution is not improving
    if size(objectives_all, 1) == it
        it = 0;
    elseif it == max_it  % or max iterations is reached
        it = 0;
    else
        it = it + 1;
    end
end
toc;

% save final results
save(savename, 'params_all', 'objectives_all');

% rerun with best solution and plot results
[objectives, avg_waittimes, avg_profits] = RunSims(params, nsims);
disp(params);
disp(objectives(1));
disp(-objectives(2));
plotHistogram(avg_waittimes, 'avg. waittimes');
plotHistogram(avg_profits, 'avg. profit');
scenario = NewScenario(params);
plotTrains(scenario);
