
function [solutions, values, dummy] = LocalSearch(problem)

% ============================================================================
% DESCRIPTION
%
% usage: [solutions, values, dummy] = LocalSearch(problem)
%
% Solves the optimization problem "problem" using local search.
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


dummy = [];

x = problem.INITIAL_SOLUTION;
solutions = x;
values = problem.OBJECTIVE_FUNCTION(solutions, problem);

it = 1;
while it
    for i=1:1000  % set upper bound for visited neighboors
        candidate_solution = problem.RANDOMIZE(solutions(end, :), problem);
        value = problem.OBJECTIVE_FUNCTION(candidate_solution, problem);
        if value < values(end)
           solutions = [solutions; candidate_solution];
           values = [values; value];
           break
        end
    end
    % stop optimization if local min is found
    if numel(values) == it
        it = 0;
    else
        it = it + 1;
    end
end


