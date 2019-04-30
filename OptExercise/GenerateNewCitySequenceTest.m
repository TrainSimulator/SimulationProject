%% Test GenerateNewCitySequence.m function

%% clean the workspace
clear all; % remove all variables, functions, and MEX-files from memory, leaving the workspace empty
close all; % delete all figures whose handles are not hidden.
clc; % clear command window 

%% Program
n = 10;     % number of cities to visit
x = 1:n;    % initial solution

problem = []; % dummy variable

data = zeros(n, n); % (matrix) results. Initialize the variable that store the results. 

for i = 1:10000
    x = GenerateNewCitySequence(x, problem); % calls your function to generate new solution
    for j = 1:n
        data(j, x(j)) = data(j, x(j)) + 1; % store the results
    end
end

% plot the results
%% Implement some controls to check that your solution is correct.

% For example, in case of exchange of two randomly selected entries of "x":
figure; bar(1:n, data);
title({'Ten histograms from left to right';'Each one showing the distribution of the cities in that position'});
drawnow();
