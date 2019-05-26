%% main file to play around with single sims...
clear all; close all; rng default; %clc 

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

% run sim
tic;
scenario = NewScenario(params);
[times, queues, waittime, gain, loss, gainb, lossb] = SimulationF(scenario);
toc;

% plot (/display) results
profit = gain - loss
avg_waittime = mean(waittime)
profits = gainb - lossb;
%plotTrains(scenario);
plotHistogram(waittime, 'waittimes (min)', 'waittimes');
plotQueues(times, queues);
plotProfit(times, profits);