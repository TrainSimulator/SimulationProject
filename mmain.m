%% main file to play around with multiple sims...
clear all; close all; rng default; %clc 

nsims = 100;  % number of simulations to run

% scenario 1
%params.FreqPeak = 3;
%params.FreqOffPeak = 3;
% scenario 2
params.FreqPeak = 4;
params.FreqOffPeak = 2;
params.CarriagesPeak = [1, 3];
params.CarriagesOffPeak = [1, 3];
params.ShiftPeakStart = -40;
params.ShiftPeakEnd = -10;

% hand tuned scenario
%params.FreqPeak = 4;
%params.FreqOffPeak = 1.8;
%params.CarriagesPeak = [2, 3];
%params.CarriagesOffPeak = [1, 2];
%params.ShiftPeakStart = -40;
%params.ShiftPeakEnd = -10;

feasible = CheckFeasibility(params);
assert(feasible == 1);

% run sims
tic;

% indicators:
avg_queues = zeros(1, nsims);
avg_waittimes = zeros(1, nsims);
profits = zeros(1, nsims);
% only for plotting:
avg_waittime_avgs = zeros(1, nsims);
avg_waittime_vars = zeros(1, nsims);
controll_vars = zeros(1, nsims);
for i=1:nsims
    % run sim and store indicators
    scenario = NewScenario(params);
    [~, queues, waittime, gain, loss, ~, ~] = SimulationF(scenario);

    avg_queues(1, i) = mean(queues, 'all');
    avg_waittimes(1, i) = mean(waittime);
    profits(1, i) = gain - loss;
    
    % monitor mean and var of a selected indicator (+do var reduction)
    if i == 1
        avg_waittime_avg = mean(waittime);
        avg_waittime_var = 0;
        controll_var = 0;
    else
        [~, controll_var, ~] = ControlledMean(avg_waittimes(1:i), avg_queues(1:i), mean(avg_queues(1:i)));
        %sqrt(controll_var/i)
        [avg_waittime_avg, avg_waittime_var] = UpdatedStatistics(avg_waittime_avg, avg_waittime_var, mean(waittime), i);
    end
    avg_waittime_avgs(1, i) = avg_waittime_avg;
    avg_waittime_vars(1, i) = avg_waittime_var;
    controll_vars(1, i) = controll_var;
end

toc;

% plot (/display) results
plotVars(1:nsims, avg_waittime_avgs, avg_waittime_vars, controll_vars);
plotHistogram(avg_waittimes, 'average waittimes (min)', 'avg_waittimes');
profits = profits/1e6;
plotHistogram(profits, 'profits (million CHF)', 'profits');
% bootstrap
BootstrapMSE_waittimes = BootstrapMSE(avg_waittimes, @mean, mean(avg_waittimes), 100)
BootstrapMSE_profit = BootstrapMSE(profits, @mean, mean(profits), 100)
