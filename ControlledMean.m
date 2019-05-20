function [avg, variance, newData] =  ControlledMean(data, controlData, expectedControl)

% ============================================================================
% DESCRIPTION
%
% usage: [mean, variance, newData] = ControlledMean(data, controlData, expectedControl)
%
% Computes the average of "data", using "controlData" as a control variate,
% where "expectedControl" is the expectation of "controlData". Returns the
% resulting average value "avg", its "variance", the optimal linear
% combination "newData" of "data" and "controlData"
%
% ----------------------------------------------------------------------------
% PARAMETERS
%
% data             a row vector of data points
%                  (called X in the lecture)
% controlData      a row vector of control variates; must have the same
%                  dimension as "data"
%                  (called Y in the lecture)
% expectedControl  the scalar expectation of "controlData"
%                  (called mu in the lecture)
%
% ---------------------------------------------------------------------------
% RETURN VALUES
%
% avg          the controlled mean of the data
% variance     the variance of "mean"
% newData      a row vector of the same dimension as "data" that contains
%              the optimal linear combination of "data" and "controlData"
%              (called Z in the lecture)
%
% ============================================================================

tmp = cov(data, controlData);
c = -tmp(1, 2)/tmp(2, 2);
newData = data + c*(controlData - expectedControl);
avg = mean(newData);
variance = var(newData,1);
