%% Simulation launch script
clear
close all

tic;

scenario = NewScenario(1);
[times, queues] = Simulation(scenario);
plot(times, queues)

toc
