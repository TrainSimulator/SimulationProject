function event = NewEvent(time, type, matrix, station, trainID)

% =========================================================================
% DESCRIPTION
% Generates a "type" event from input variables
%
% -------------------------------------------------------------------------
% PARAMETERS
% time:
% type: the type of the event; an integer number where
%       1 = GENERATION
%       2 = ARRIVAL
%       3 = DEPARTURE
% matrix: 4*4 matrix (from-to)
% station: (only for 2, 3)
% trainID: (only for 2, 3)
%
% -------------------------------------------------------------------------
% RETURN VALUES
% event: a data structure with the specified 4 fields
%
% =========================================================================

event.time = time;
event.type = type;
event.matrix = matrix;
event.station = station;
event.trainID = trainID;

end
