function [solutions, values, dummy] = GreedyAlgorithm(problem)

% ============================================================================
% DESCRIPTION
%
% usage: [solutions, values, dummy] = GreedyAlgorithm(problem)
%
% Solves the optimization problem "problem" using a greedy algorithm.
% For example, visiting the closest city every step. 
% "problem" is a MATLAB data structure. Using a data structure allows to
% pass problem specific information between the different function handles
% specified further below.
%
% ----------------------------------------------------------------------------
% PARAMETERS
%
% problem.INITIAL_SOLUTION    a row vector that represents an initial solution
%                             of the problem                         
% problem.RANDOMIZE           a handle to a function that generates a proposal
%                             solution from a given solution; this function
%                             must take the following two parameters:
%                             1. the current solution (a row vector)
%                             2. the entire "problem" data structure 
%                             The return value of this function must again be
%                             a row vector of appropriate dimension.
% problem.OBJECTIVE_FUNCTION  a handle to a function that computes the
%                             objective function value for a given solution;
%                             this function must take the following 
%                             parameters:
%                             1. the solution to be evaluated (a row vector)
%                             2. the "problem" data structure
%                             The return value of this function must be a 
%                             scalar value.
% 
% ----------------------------------------------------------------------------
% RETURN VALUES
%
% solutions                   a matrix where the i-th row contains the 
%                             solution computed in the i-th iteration.
%                             Only one solution is returned by the greedy algorithm        
% values                      a column vector where the i-th row contains 
%                             the objective function value computed in the 
%                             i-th iteration.
%                             Only a value is returned by the greedy algorithm
% dummy                       a dummy output
%
% ============================================================================

% no need for problem.INITIAL_SOLUTION, problem.RANDOMIZE and problem.OBJECTIVE_FUNCTION here...
dummy = [];

n = numel(problem.INITIAL_SOLUTION);
solutions = [1];
remaining_cities = 2:n;
while numel(solutions)~=n
    % look for closest city from the remaining ones
    min_dist = norm(problem.CITIES(solutions(end), :) - problem.CITIES(remaining_cities(1), :));
    min_dist_val = remaining_cities(1);
    for i=2:numel(remaining_cities)
        dist = norm(problem.CITIES(solutions(end), :) - problem.CITIES(remaining_cities(i), :));
        if dist < min_dist
            min_dist = dist;
            min_dist_val = remaining_cities(i);
        end
    end
    % add to the solution, and delete city from the list
    solutions = [solutions, min_dist_val];
    remaining_cities = remaining_cities(remaining_cities~=min_dist_val);
end

values = problem.OBJECTIVE_FUNCTION(solutions, problem);


