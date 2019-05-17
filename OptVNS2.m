%% Optimization via Variable Neighborhood Search
% constrained opt: keep waittime below certain level and opt profit
clear; close all; rng default;

max_it = 50;  % max number of opt. iterations per waittime level (constraine)
nsims = 4;  % number of sims to run per 1 opt. iteration
% waittime_ubs = 20:-1:10;  % constraints (waittime upper bounds)
waittime_ubs = 20:-1:10;  % constraints (waittime upper bounds)
savename = 'constrained_opt';  % name of saved .mat file

nneighbourhoods = 30;
totalneighbours = nneighbourhoods + (nneighbourhoods-1)*(nneighbourhoods)/2;
weights = 10000*ones(1, totalneighbours);

totaltime = tic;

% initial parameters
params.FreqPeak = 1;  % [0, 6]
params.FreqOffPeak = 6;
params.CarriagesPeak = [1, 1];  % [0, 6]-[6, 0]
params.CarriagesOffPeak = [3, 1];
params.ShiftPeakStart = 60;  % [-120, 60]
params.ShiftPeakEnd = -10;
% params.FreqPeak = 4;  % [0, 6]
% params.FreqOffPeak = 2;
% params.CarriagesPeak = [2, 3];  % [0, 6]-[6, 0]
% params.CarriagesOffPeak = [1, 2];
% params.ShiftPeakStart = -40;  % [-120, 60]
% params.ShiftPeakEnd = -10;

feasible = CheckFeasibility(params);
assert(feasible == 1);
params_all = params;

% initial solution
[objectives_all, ~, ~] = RunSims(params, nsims);
disp(['Initial solution: waittime = ' num2str(objectives_all(end,1)) ', profit = ' num2str(objectives_all(end,2))])

for waittime_ub = waittime_ubs
    levelt = tic;
    % Initialize new constraint with best solutation from previous runs
    params_all = params_all(end,:);
    objectives_all = objectives_all(end,:);
    params_worse = []; % Reset tested parameters array
    total_it = 1;
    
    it = 1;
    while it < max_it
        if it > max_it / 2
            level = 2;
        else
            level = 1;
        end
        
        %% Change parameters:
        while 1
            try_it = 1; % Try to find an untested neighbourhood
            [candidate_params, rnd] = Rand_Parameters(params, weights, level); % Change parameters
            
            if ~equal_params(candidate_params, [params_all; params_worse])
                break
            else
                try_it = try_it + 1;
            end
            if try_it > 5000
                if it > max_it / 2
                    it = max_it;
                else
                    it = max_it / 2;
                end
                disp('Could not find new neighbourhoods.');
                break
            end
        end
        
        %% Execute simulations. If optimization values are improved keep the new parameters
        [objectives, ~, ~] = RunSims(candidate_params, nsims);
        if (objectives(1) < waittime_ub && objectives(2) < objectives_all(end, 2)) ...
                || (objectives_all(end, 1) > waittime_ub && objectives(1) < objectives_all(end, 1))
            params = candidate_params;
            params_all = [params_all; params];
            objectives_all = [objectives_all; objectives];
            disp(['it = ' num2str(it) ', waittime = ' num2str(objectives_all(end,1)) ...
                ', profit = ' num2str(objectives_all(end,2))])
            it = 1; % If improvement was done reset iteration counter
            
            % Adjust weights:
            if level == 2
                weights = weights - 1;
                weights(rnd) = weights(rnd) + totalneighbours + 1;
            else
                weights(1:nneighbourhoods) = weights(1:nneighbourhoods) - 1;
                weights(rnd) = weights(rnd) + nneighbourhoods + 1;
            end
        else
            params_worse = [params_worse; params]; % Store worse parameters, so they will not be tested again
            % Adjust weights:
            if level == 2
                weights = weights + 1;
                weights(rnd) = weights(rnd) - totalneighbours - 1;
            else
                weights(1:nneighbourhoods) = weights(1:nneighbourhoods) + 1;
                weights(rnd) = weights(rnd) - nneighbourhoods - 1;
            end
        end
        it = it + 1;
        total_it = total_it + 1;
    end
    % save results (with diff name) at each constraint level
    disp([num2str(total_it) ' iterations done in ' num2str(toc(levelt)) ' seconds.']);
    disp(['weights = ' num2str(weights)]);
    savename_ = sprintf('constrained_opt_%i_%i', waittime_ub, runs);
    save(savename_, 'params_all', 'objectives_all');
    fprintf('%s saved!\n', savename_);
end

toc(totaltime);

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
