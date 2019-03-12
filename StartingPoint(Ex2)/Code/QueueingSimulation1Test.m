%% Test the implementation of QueueingSimulation1.m function

%% clean the workspace
clear %Removes all variables, functions, and MEX-files from memory, leaving the workspace empty
close all % delete all figures whose handles are not hidden.

%% Program
% Set the scenario
scenario = NewRoad1();

% Run the simulation
% for i = 1:1000

[times, queues] = QueueingSimulation1(scenario);

% Graphical animation of the results
% DrawNetwork(scenario, times, queues);

% Chart of the results

DrawQueues(times, queues);
% end
