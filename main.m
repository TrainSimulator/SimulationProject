%% Simulation launch script
clear all; close all; rng default; %clc

params.FreqPeak = 4;
params.FreqOffPeak = 2;
params.CarriagesPeak = [1, 3];
params.CarriagesOffPeak = [1, 3];
params.ShiftPeakStart = 0;
params.ShiftPeakEnd = 0;

feasible = CheckFeasibility(params);
assert(feasible == 1);

tic;
nsims = 50;  % number of simulations to run
% indicators:
avg_queues = zeros(1, nsims);
avg_waittimes = zeros(1, nsims);
avg_profits = zeros(1, nsims);
% only for plotting:
avg_waittime_avgs = zeros(1, nsims);
avg_waittime_vars = zeros(1, nsims);
controll_vars = zeros(1, nsims);
for i=1:nsims
    % run sim and store indicators
    scenario = NewScenario(params);
    [times, queues, waittime, gain, loss] = Simulation(scenario);

    avg_queues(1, i) = mean(queues, 'all');
    avg_waittimes(1, i) = mean(waittime);
    avg_profits(1, i) = gain - loss;
    
    % monitor mean and var of a selected indicator (+do var reduction)
    if i == 1
        avg_waittime_avg = mean(waittime);
        avg_waittime_var = 0;
        controll_var = 0;
    else
        [~, controll_var, ~] = ControlledMean(avg_waittimes, avg_queues, mean(avg_queues));
        [avg_waittime_avg, avg_waittime_var] = UpdatedStatistics(avg_waittime_avg, avg_waittime_var, mean(waittime), i);
    end
    avg_waittime_avgs(1, i) = avg_waittime_avg;
    avg_waittime_vars(1, i) = avg_waittime_var;
    controll_vars(1, i) = controll_var;
    % if (control) var is sufficiently low stop sims
    %if i>10 && sqrt(controll_var/i) < 0.05
    %    break
    %end
end
toc;

figure;
plot(avg_waittime_avgs, 'b');
hold on;
plot(avg_waittime_avgs+sqrt(avg_waittime_vars),'--b');
hold on;
plot(avg_waittime_avgs-sqrt(avg_waittime_vars),'--b');
hold on;
plot(avg_waittime_avgs+sqrt(controll_vars),'--k');
hold on;
plot(avg_waittime_avgs-sqrt(controll_vars),'--k');

plotHistogram(avg_queues, 'avg. queue lengths');
plotHistogram(avg_waittimes, 'avg. waittimes');
plotHistogram(avg_profits, 'avg. profit');
