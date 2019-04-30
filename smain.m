%% Single run simulation launch script

clear
close all;

tic

scenario = NewScenario(1);
[times, queues, waittime, gain, loss] = SimulationF(scenario);

plotHistogram(waittime);
ylabel('#passengers')

toc
