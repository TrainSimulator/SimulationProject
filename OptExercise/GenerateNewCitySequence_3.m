function y = GenerateNewCitySequence(x, problem)

% ============================================================================
% DESCRIPTION
%
% usage: y = GenerateNewCitySequence(x, problem)
%
% Returns a permutation of the row vector "x", where the first element
% of "x" stays unchanged. Implement different specifications.
%   - exchanges 4 randomly selected entries of "x"
% 
% ----------------------------------------------------------------------------
% PARAMETERS
%
% x         a row vector representing the current city sequence
% problem   the entire "problem" data structure. To be added as dummy if not used
% 
% ----------------------------------------------------------------------------
% RETURN VALUES
%
% y         a row vector with a permutation of "x" where the first element 
%           of "y" is the first element of "x"
%    
%
% ============================================================================

% swap 2 cities
y = x;
n = numel(x);
swapidx = datasample(2:n, 4, 'Replace', false);  % randomly select 4 elements
y(swapidx) = y(flip(swapidx));  % swap elements

