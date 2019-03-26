%% Simulation launch script
clear
close all

tic;

rng default;

scenario = NewScenario(2);
[times, queues, waittime, gain, loss] = Simulation(scenario);

profit = gain - loss;
avgwaittime = mean(waittime);
varwaittime = var(waittime);
maxwaittime = max(waittime);
minwaittime = min(waittime);
waittime95perc = prctile(waittime,0.95);

figure; plot(times/60, queues);
figure; histogram(waittime);
% figure; boxplot(waittime);

toc
