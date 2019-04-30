%% Single run simulation launch script

clear
close all;

tic

nruns = 10;

% indicators:
avg_queues = zeros(nruns,1);
avg_waittimes = zeros(nruns,1);
max_waittimes = zeros(nruns,1);
profits = zeros(nruns,1);

parfor i = 1:nruns
    scenario = NewScenario(2);
    [times, queues, waittime, gain, loss] = SimulationF(scenario);

    avg_queues(i) = mean(mean(queues));
    avg_waittimes(i) = mean(waittime);
    max_waittimes(i) = max(waittime);
    profits(i) = gain-loss;
end

plotHistogram(avg_queues);
plotHistogram(avg_waittimes);
plotHistogram(max_waittimes);
plotHistogram(profits);

% disp(['profit: ' num2str(profits(end))])
% plotHistogram(waittime);
% ylabel('#passengers')

toc
