%% Multiple runs simulation launch script

clear
close all;

tic

scenario = NewScenario(2);
[times, queues, waittime, gain, loss] = SimulationF(scenario);

profit = gain - loss;
disp(['profit: ' num2str(profit)])

plotHistogram(waittime);
ylabel('#passengers')

toc
