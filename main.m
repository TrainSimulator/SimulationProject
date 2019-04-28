%% Simulation launch script
clc;
clear all;
close all;
rng default;

tic;

% indicators:
avg_queues = [];
avg_waittimes = [];
max_waittimes = [];
avg_profits = [];
% only for plotting:
avg_waittime_avgs = [];
avg_waittime_vars = [];
controll_vars = [];
for i=1:100
    % run sim and store indicators
    scenario = NewScenario(2);
    [times, queues, waittime, gain, loss] = Simulation(scenario);

    avg_queues = [avg_queues, mean(queues, 'all')];
    avg_waittimes = [avg_waittimes, mean(waittime)];
    max_waittimes = [max_waittimes, max(waittime)];
    avg_profits = [avg_profits, gain-loss];
    
    % monitor mean and var of a selected indicator (+do var reduction)
    if i == 1
        avg_waittime_avg = avg_waittimes;
        avg_waittime_var = 0;
        controll_var = 0;
    else
        [~, controll_var, ~] = ControlledMean(avg_waittimes, avg_queues, mean(avg_queues));
        [avg_waittime_avg, avg_waittime_var] = UpdatedStatistics(avg_waittime_avg, avg_waittime_var, mean(waittime), i);
    end
    avg_waittime_avgs = [avg_waittime_avgs, avg_waittime_avg];
    avg_waittime_vars = [avg_waittime_vars, avg_waittime_var];
    controll_vars = [controll_vars, controll_var];
    % if (control) var is sufficiently low stop sims
    if i>10 && sqrt(controll_var/i) < 0.05
        break
    end
end

toc

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

plotHistogram(avg_queues);
plotHistogram(avg_waittimes);
plotHistogram(max_waittimes);
plotHistogram(avg_profits);
