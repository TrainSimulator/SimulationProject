
function scenario = NewRoad1()

% ============================================================================
% DESCRIPTION
%
% usage: scenario = NewRoad1()
%
% Builds a single road scenario.
%
% ----------------------------------------------------------------------------
% PARAMETERS
%
% ----------------------------------------------------------------------------
% RETURN VALUES
%
% scenario
% .DEMAND_DURATION  length of the demand interval (how long vehicles enter)
% .T0               1 x 1 matrix that contains the free flow travel time
% .LAMBDA           1 x 1 matrix that contains the external entry rate
% .MU               1 x 1 matrix that contains the road service rate
% .X1,X2,Y1,Y2      coordinate of the start and end of each link
% .JOBLENGTH        length of a single vehicle
%
% ============================================================================


scenario.DEMAND_DURATION = 50;
scenario.T0 = [1.0];
scenario.LAMBDA = [1.0];
scenario.MU = [1.0];

%
% for now, ignore the following entries; just for graphics
%

scenario.TURNS = [0.0 1.0];

scenario.X1 = [0.0];
scenario.Y1 = [0.0];
scenario.X2 = [1.0];
scenario.Y2 = [0.0];

scenario.TEXTPOS   = 0.2;
scenario.JOBLENGTH = 0.1;
scenario.STEPSIZE  = 0.1;
scenario.MINDELAY  = 0.0;

end
