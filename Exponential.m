
function [rnd,rsr] = Exponential(lambda)

% ============================================================================
% DESCRIPTION
%
% usage: rnd = Exponential(lambda)
%
% Generates an exponentially distributed random variable.
%
% ----------------------------------------------------------------------------
% PARAMETERS
%
% lambda    the rate parameter, the inverse expectation of the distribution
%
% ---------------------------------------------------------------------------
% RETURN VALUES
%
% rnd       a draw from an exponentially distributed random variable with rate lambda
%
% ============================================================================

rsr=rand;
rnd=-lambda*log(rsr);
end
