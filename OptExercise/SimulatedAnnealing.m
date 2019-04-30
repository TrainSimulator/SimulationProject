
function [solutions, values, temperatures] = SimulatedAnnealing(problem)

% ============================================================================
% DESCRIPTION
%
% usage: [solutions, values, temperatures] = SimulatedAnnealing(problem)
%
% Solves the optimization problem "problem" using simulated annealing.
% "problem" is a MATLAB data structure. Using a data structure allows to
% pass problem specific information between the different function handles
% specified further below.
%
% ----------------------------------------------------------------------------
% PARAMETERS
%
% problem.M                   Number of temperature changes
% problem.K                   Number of iterations per level of temperature
% problem.D                   Average increase of the objective function
% problem.P0                  Initial acceptance probability
% problem.Pf                  Final acceptance probability
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
% temperatures                a vector with the temperature at each iteration
%
% ============================================================================


x = problem.INITIAL_SOLUTION;
solutions = x;
values = problem.OBJECTIVE_FUNCTION(x, problem);

T = -problem.D / log(problem.P0);
temperatures = T;
T_tmp = (problem.Pf - problem.P0)/problem.M;
m = 1;

while m < problem.M
    k = 1;
    while k~=problem.K
        candidate_solution = problem.RANDOMIZE(solutions(end, :), problem);
        value = problem.OBJECTIVE_FUNCTION(candidate_solution, problem);
        d = value - values(end);
        if d < 0  % accept if better
            solutions = [solutions; candidate_solution];
            values = [values; value];
        elseif exp(-d/T) > rand() % randomly accept based on how much worse it is
            solutions = [solutions; candidate_solution];
            values = [values; value];
        else
            solutions = [solutions; solutions(end, :)];
            values = [values; values(end)];
        end
        temperatures = [temperatures, T];
        k = k + 1;
    end
    % calc temperature for the next K iterations
    T = -problem.D / log(problem.P0 + T_tmp*m);
    m = m + 1;
end




