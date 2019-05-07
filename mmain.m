%% Multiple runs simulation launch script

clear
close all;

tic

nruns = 100;

% indicators:
avg_queues = zeros(nruns,1);
avg_waittimes = zeros(nruns,1);
max_waittimes = zeros(nruns,1);
profits = zeros(nruns,1);

params.FreqPeak = 4;
params.FreqOffPeak = 2;
params.CarriagesPeak = [1, 3];
params.CarriagesOffPeak = [1, 3];
params.ShiftPeakStart = 0;
params.ShiftPeakEnd = 0;

scenario = NewScenario(params);
parfor i = 1:nruns
    [times, queues, waittime, gain, loss] = SimulationF(scenario);

    avg_queues(i) = mean(mean(queues));
    avg_waittimes(i) = mean(waittime);
    max_waittimes(i) = max(waittime);
    profits(i) = gain-loss;
end

% plotHistogram(avg_queues);
% xlabel('average queue length')
% ylabel('n')
% plotHistogram(avg_waittimes);
% xlabel('average waittime')
% ylabel('n')
% plotHistogram(max_waittimes);
% xlabel('maximum waittime')
% ylabel('n')
% plotHistogram(profits);
% xlabel('profits')
% ylabel('n')

toc
