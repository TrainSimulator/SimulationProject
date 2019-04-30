function [solutions, values, dummy] = VariableNeighborhoodSearch(problem)

% ============================================================================
% DESCRIPTION
%
% usage: [solutions, values, dummy] = VariableNeighborhoodSearch(problem)
%
% Solves the optimization problem "problem" using variable neighborhood search.
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
% problem.RANDOMIZE_2         a handle to a function with a different 
%                             neighborhood structures.
% problem.RANDOMIZE_...       a handle to a function with a different 
%                             neighborhood structures.
% problem.RANDOMIZE_k         a handle to a function with a different 
%                             neighborhood structures.
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
rnd = 1;  % id of neighborhood method
randomize = @problem.RANDOMIZE;
while it
    for i=1:1000  % set upper bound for visited neighboors
        candidate_solution = randomize(solutions(end, :), problem);
        value = problem.OBJECTIVE_FUNCTION(candidate_solution, problem);
        if value < values(end)
           solutions = [solutions; candidate_solution];
           values = [values, value];
           break
        end
    end
    % change neighborhood if local min is found
    if numel(values) == it
        if rnd == 1
            rnd = 2;
            randomize = @problem.RANDOMIZE_2;
        elseif rnd == 2
            rnd = 3;
            randomize = @problem.RANDOMIZE_3;
        elseif rnd == 3
            % stop optimization if local min is found with the latest
            % neighborhood method...
            it = 0;
        end
    else
        % go back to the original neighborhood structure if better
        % solutions is found with any of the neighborhoods
        rnd = 1;
        randomize = @problem.RANDOMIZE;
        it = it + 1;
    end
end

