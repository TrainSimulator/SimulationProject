%% Simulation launch script

% clean the workspace
clear all; %Removes all variables, functions, and MEX-files from memory, leaving the workspace empty
close all; % delete all figures whose handles are not hidden.
clc; % clear command window

% Program
scenario = NewScenario(1);

[times, queues] = Simulation(scenario);

% Plots
PlotQueues(times, queues);