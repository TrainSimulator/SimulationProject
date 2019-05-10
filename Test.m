%% Helper file to play around with single sims...
clear all; close all; rng default; %clc

params.FreqPeak = 4;
params.FreqOffPeak = 1.8;
params.CarriagesPeak = [2, 3];
params.CarriagesOffPeak = [1, 2];
params.ShiftPeakStart = -40;
params.ShiftPeakEnd = -10;

feasible = CheckFeasibility(params);
assert(feasible == 1);

% run sim
tic;
scenario = NewScenario(params);
[times, queues, waittime, gain, loss] = SimulationF(scenario);
toc;

% plot (/display) results
profit = gain - loss
avg_waittime = mean(waittime)
plotTrains(scenario);
plotHistogram(waittime, 'waittimes');
plotQueues(times, queues);