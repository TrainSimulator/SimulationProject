%% Optimization via Variable Neighborhood Search
% constrained opt: keep waittime below certain level and opt profit
clear; close all; rng default;

max_it = 1000;  % max number of opt. iterations per waittime level (constraine)
nsims = 4;  % number of sims to run per 1 opt. iteration
reruns = 10;
% waittime_ubs = 20:-1:10;  % constraints (waittime upper bounds)
waittime_ubs = 20:-0.5:10;  % constraints (waittime upper bounds)
nconstr = length(waittime_ubs); % Constraint levels
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

% initial solution
[value, ~, ~] = RunSims(params, nsims);
for i = 1:nconstr
    clvl(i).params = params;
    clvl(i).value = value;
    clvl(i).it = 0;
end
disp(['Initial solution: waittime = ' num2str(value(:,1)) ', profit = ' num2str(value(:,2))])

figure; hold on;
params_all = params;
total_it = 1;
for run = 1:reruns
    for cidx = 1:nconstr
        waittime_ub = waittime_ubs(cidx);
        disp(['constraint level: ' num2str(waittime_ub)]);
        levelt = tic;
        it = 1;
        while it < max_it
            %% Change randomizer level depending on number of iterations
            if it > max_it / 2
                level = 2;
            else
                level = 1;
            end
            
            %% Change parameters:
            while 1
                try_it = 1; % Try to find an untested neighbourhood
                [candidate_params, rnd] = Rand_Parameters(clvl(cidx).params(end,:), weights, level); % Change parameters
                
                if ~equal_params(candidate_params, params_all)
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
            [clvl, improvement] = addToPareto(objectives, candidate_params, clvl, waittime_ubs, total_it);
            if improvement
                disp(['it = ' num2str(it) ', waittime = ' num2str(objectives(1)) ...
                    ', profit = ' num2str(objectives(2))])
                it = 1; % If improvement was done reset iteration counter
                % Plotting:
                clf; hold on;
                for k = 1:nconstr
                    scatter(clvl(k).value(end,1), clvl(k).value(end,2));
                end
                drawnow
                % Adjust weights:
                weights = AdjustWeights(weights, rnd, 1, level);
            else
                weights = AdjustWeights(weights, rnd, 0, level);
            end
            params_all = [params_all; params];
            it = it + 1;
            total_it = total_it + 1;
        end
        
        % save results (with diff name) at each constraint level
        disp([num2str(total_it) ' iterations done in ' num2str(toc(levelt)) ' seconds.']);
        disp(['weights = ' num2str(weights)]);
    end
    savename_ = sprintf('constrained_opt_it_%i', total_it);
    save(savename_, 'clvl');
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
