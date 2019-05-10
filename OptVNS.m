%% Optimization via Variable Neighborhood Search
% constrained opt: keep waittime below certain level and opt profit
clc; clear all; close all; rng default;

max_it = 50;  % max number of opt. iterations per waittime level (constraine)
nsims = 50;  % number of sims to run per 1 opt. iteration
check_neighbors = 50;  % max number of random neighbors to check with one neighborhood structure
waittime_ubs = 20:-1:10;  % constraints (waittime upper bounds)
savename = 'constrained_opt';  % name of saved .mat file

tic;

for waittime_ub=waittime_ubs
    
    % initial parameters
    params.FreqPeak = 4;  % [0, 6]
    params.FreqOffPeak = 1.8;
    params.CarriagesPeak = [2, 3];  % [0, 6]-[6, 0]
    params.CarriagesOffPeak = [1, 2];
    params.ShiftPeakStart = -40;  % [-120, 60]
    params.ShiftPeakEnd = -10;

    feasible = CheckFeasibility(params);
    assert(feasible == 1);
    params_all = params;
    % initial solution
    [objectives_all, ~, ~] = RunSims(params, nsims);
    
    rnd = 1;
    randomize = @Randomize_TrainFreq;
    it = 1;
    while it
        
        % visit (finite number of) neighbors and update if the solution is better
        for i=1:check_neighbors
            candidate_params = randomize(params);
            [objectives, ~, ~] = RunSims(candidate_params, nsims);
            if objectives(1) < waittime_ub && objectives(2) < objectives_all(end, 2)
                params = candidate_params;
                params_all = [params_all; params];
                objectives_all = [objectives_all; objectives];
                break
            end
        end
        
        if size(objectives_all, 1) == it  % change neighborhood structure if local min is found
            if rnd == 1
                rnd = 2;
                randomize = @Randomize_OffPeakCarriages;
            elseif rnd == 2
                rnd = 3;
                randomize = @Randomize_PeakHour;
            elseif rnd == 3
                rnd = 4;
                randomize = @Randomize_PeakCarriages;
            elseif rnd == 4  % stop optimization if latest neighborhood isn't improving
                it = 0;
            end
        else
            rnd = 1;
            randomize = @Randomize_TrainFreq;
            it = it + 1;
        end
        if it == max_it  % stop optimization if max iterations is reached
            it = 0;
        end
    end
    % save results (with diff name) at each constraint level
    savename_ = sprintf('constrained_opt_%i', waittime_ub);
    save(savename_, 'params_all', 'objectives_all');
    fprintf('%s saved!\n', savename_);
end

toc;

% TODO: add pareto front plotting here...

% rerun with best solution and plot results
%[objectives, avg_waittimes, avg_profits] = RunSims(params, nsims);
%disp(params);
%disp(objectives(1));
%disp(-objectives(2));
%plotHistogram(avg_waittimes, 'avg. waittimes');
%plotHistogram(avg_profits, 'avg. profit');
%scenario = NewScenario(params);
%plotTrains(scenario);
