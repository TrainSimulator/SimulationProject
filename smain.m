%% Single run simulation launch script

clear
close all;

tic

params.FreqPeak = 4;
params.FreqOffPeak = 2;
params.CarriagesPeak = [1, 3];
params.CarriagesOffPeak = [1, 3];
params.ShiftPeakStart = 0;
params.ShiftPeakEnd = 0;

scenario = NewScenario(params);
[times, queues, waittime, gain, loss] = SimulationF(scenario);

profit = gain - loss;
% disp(['profit: ' num2str(profit)])

% plotHistogram(waittime, '#passengers');
% ylabel('#passengers')

toc
