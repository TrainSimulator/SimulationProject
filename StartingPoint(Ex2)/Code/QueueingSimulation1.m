function [times, queues] = QueueingSimulation1(scenario)

% ============================================================================
% DESCRIPTION
%
% usage: [times, queues] = QueueingSimulation1_mod(scenario)
%
% Runs a simulation of "scenario".
%
% ----------------------------------------------------------------------------
% PARAMETERS
%
% scenario
% .DEMAND_DURATION  length of the demand interval (how long vehicles enter)
% .T0               1 x 1 matrix that contains the free flow travel time
% .LAMBDA           1 x 1 matrix that contains the external entry rate
% .MU               1 x 1 matrix that contains the road service rate
% .JOBLENGTH        length of a single vehicle
%
% ---------------------------------------------------------------------------
% RETURN VALUES
%
% times             row vector of event times
% queues            row vector of queue sizes at the event times
%
% ============================================================================

% tA, tD, tG, T
times = [];
queues = [];

T = scenario.DEMAND_DURATION;
EventList = UpdatedEventList([], NewEvent(T, 4));

tG = Exponential(scenario.LAMBDA);
EventList = UpdatedEventList(EventList, NewEvent(tG, 1));
q = 0;

while ~isempty(EventList)
    t = EventList(1).time;
    switch EventList(1).type
        case 1 % GENERATION
            tA = t + rand * scenario.T0;
            EventList = UpdatedEventList(EventList, NewEvent(tA, 2));
            if t < T
                tG = t + Exponential(scenario.LAMBDA);
                EventList = UpdatedEventList(EventList, NewEvent(tG, 1));
            end
            
        case 2 % ARRIVAL
            q = q + 1;
            if q == 1
                tD = t + Exponential(scenario.MU);
                EventList = UpdatedEventList(EventList, NewEvent(tD, 3));
            end
            
        case 3 % DEPARTURE
            q = q - 1;
            if q > 0
                tD = t + Exponential(scenario.MU);
                EventList = UpdatedEventList(EventList, NewEvent(tD, 3));
            end
            
    end
    times(end+1) = EventList(1).time; %#ok<*AGROW>
    queues(end+1) = q;
    EventList = EventList(2 : end);
    
end
end
