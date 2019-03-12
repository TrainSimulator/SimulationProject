function event = NewEvent(time, type, station, var)
% =========================================================================
%
% DESCRIPTION
%
% Generates a "type" event from input variables
%
% -------------------------------------------------------------------------
%
% PARAMETERS
%
% time   the time at which the event occurred; a real number
% type   the type of the event; an integer number where
%          1 = GENERATION
%          2 = ARRIVAL event
%          3 = DEPARTURE (service) event
%          4 = SIMULATION END
%
% station
%    1 = Geneva
%    2 = Lausanne
%    3 = Bern
%    4 = Zurich
%
% var - can be a destination (for passengers) or a trainID
% flag other variable with -1
%
% -------------------------------------------------------------------------
%
% RETURN VALUES
%
% event  a data structure with the three fields "time" and "type"
%        that represents the respective event
%
% =========================================================================
%

event.time = time;
event.type = type;
event.station = station;

if type == 1 % For generates passenger set destination
    event.destination = var;
    event.trainID = -1;
else
    if type == 2 % For train arrivals set train number
        event.trainID = var;
        event.destination = -1;
    end
end
end
