%% Test EvaluateCitySequence.m function

%% clean the workspace
clear all; % remove all variables, functions, and MEX-files from memory, leaving the workspace empty
close all; % delete all figures whose handles are not hidden.
clc; % clear command window

%% Program
% Very simple test: salesman starts at city one with coordinates(0, 0),
% travels to city two with coordinates(1, 1), and then returns to city 1.

% coordinates of the cities
problem.CITIES       = [0 0];
problem.CITIES(2, :) = [1 1];

% control EvaluateCitySequence.m function 
expected   = 2 * sqrt(2); % expected distance
calculated =  EvaluateCitySequence([1 2], problem);  % calls your objective function

% show the results
strOut = strcat('Expected\t= \t',sprintf('%f',expected),'\nCalculated\t= \t',sprintf('%f',calculated),' ... \n');
fprintf(strOut);
if (abs(expected - calculated) < 1e-6)
    fprintf('OK\n');
else
    fprintf('NOT CORRECT\n');
end
