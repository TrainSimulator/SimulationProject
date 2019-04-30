function Q = EvaluateCitySequence(x, problem)

% ============================================================================
% DESCRIPTION
%
% usage: Q = EvaluateCitySequence(x, problem)
%
% Returns the objective function value of the solution x.
% 
% ----------------------------------------------------------------------------
% PARAMETERS
%
% x        a row vector representing the solution to be evaluated
% problem  MATLAB data structure that contains supplementary information
%          about the problem, in particular the coordinates of the cities:
%          problem.CITIES is a matrix where every row contains the x- and y-
%          coordinate of one city.
% 
% ----------------------------------------------------------------------------
% RETURN VALUES
%
% Q        a scalar representing the objective function value of "x"
%
% ============================================================================

n = numel(x);
Q = 0;
for i=2:n
    dist = norm(problem.CITIES(x(i-1), :) - problem.CITIES(x(i), :));
    Q = Q + dist;
end
dist = norm(problem.CITIES(n, :) - problem.CITIES(1, :));
Q = Q + dist;

