function [solutions, values, dummy] = FullEnumeration(problem)

% ============================================================================
% DESCRIPTION
%
% usage: [solutions, values, dummy] = FullEnumeration(problem)
%
% Solves the optimization problem "problem" using full enumeration.
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
%                             solution computed in the i-th iteration
% values                      a column vector where the i-th row contains 
%                             the objective function value computed in the 
%                             i-th iteration
% dummy                       a dummy output
%
% ============================================================================

% no need for problem.INITIAL_SOLUTION and problem.RANDOMIZE here...
dummy = [];

% pre-generate all solutions
n = numel(problem.INITIAL_SOLUTION);
tmp = perms(2:n);  % built in MATLAB permutations...
solutions = [ones(size(tmp, 1), 1), tmp];
% evaluate all solutions
values = [];
for i=1:size(solutions, 1)
    values = [values; problem.OBJECTIVE_FUNCTION(solutions(i, :), problem)];
end

% sort them to make it look like an optimization...
[values, sortidx] = sort(values, 'descend');
solutions = solutions(sortidx, :);





