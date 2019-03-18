function [times, queues] = Simulation(scenario)

% ============================================================================
% DESCRIPTION
% usage: [times, queues] = Simulation(scenario)
% Runs a simulation of "scenario"
%
% ----------------------------------------------------------------------------
% PARAMETERS
% scenario
% .DemandDuration: length of the demand interval (set to 24 hours)
% .MorningPeak: 1*2 vector representing morning peak hours (from exc. description)
% .EveningPeak: 1*2 vector representing evening peak hours (from exc. description)
% .DemandPeak: 4*4 matrix (from-to) representing passenger demand in peak hours (from exc. description)
% .DemandOffPeak: 4*4 matrix (from-to) representing passenger demand outside peak hours (from exc. description)
% .TravelTimes: 1*3 vector representing travel times between cities (from exc. description)
% .timetable: row vector with train time table (from exc. description)
% .trains: row vector of train composition (available number of seats) (from exc. description)
%
% ---------------------------------------------------------------------------
% RETURN VALUES
% times row vector of event times
% queues 3*times matrix with rows representing queues at every stations
%
% ============================================================================

% initialization
times = [];
queues = [];
T = scenario.DemandDuration;
nCities = size(scenario.DemandPeak, 1);

% pregenerate passenger generation times (since it has a constant rate and it's independent from everything else)
EventList = [];
for t = 0:1:T % iterate over minutes
    if (scenario.MorningPeak(1) <= t && t <= scenario.MorningPeak(2))
        nPassengers = scenario.DemandPeak * 1000/60;
    elseif (scenario.EveningPeak(1) <= t && t <= scenario.EveningPeak(2))
        nPassengers = scenario.DemandPeak * 1000/60;
    else
        nPassengers = scenario.DemandOffPeak * 1000/60;
    end
    event = NewEvent(t, 1, nPassengers, -1, -1);
    EventList = UpdatedEventList(EventList, event);
end

% add departures from Geneva
trainID = 1;
for t = scenario.timetable
    event = NewEvent(t, 3, zeros(nCities, nCities), 1, trainID);
    EventList = UpdatedEventList(EventList, event);
    trainID = trainID + 1;
end

% process queue
q = zeros(nCities, nCities);
TrainsCapacity = scenario.trains; % max number of passengers for every train
TrainsOccupancy = zeros(1, size(TrainsCapacity, 2)); % stores the number of current passengers for every train
while ~isempty(EventList)
    event = EventList(1);
    t = event.time;
    switch event.type
        
        case 1 % generation
            % generate passengers at every station and increase queue size
            nPassengers = event.matrix;
            q = q + floor(nPassengers);
            %times = [times, t];
            %queues = [queues, sum(q, 2)];
            
        case 2 % arrival
            station = event.station;
            trainID = event.trainID;
            % get passengers out
            PassengersOut = sum(event.matrix(:, station));
            TrainsOccupancy(1, trainID) = TrainsOccupancy(1, trainID) - PassengersOut;
            assert(TrainsOccupancy(1, trainID) >= 0, 'Less than 0 passengers in train %i after arrival to station %i\n', trainID, station);
            % trigger departure to the next station
            if station ~= nCities
                DepartureMatrix = event.matrix;
                DepartureMatrix(:, station) = 0;
                event = NewEvent(t+1, 3, DepartureMatrix, station, trainID); % count 1 minute for getting off-in the train
                EventList = UpdatedEventList(EventList, event);
            else
                assert(TrainsOccupancy(1, trainID) == 0, 'Passengers remained on train %i after arriving to the final station', trainID);
            end
            
        case 3 % departure
            station = event.station;
            assert(station ~= nCities, 'Trains should not depart from the final station');
            trainID = event.trainID;             
            % load in passengers
            PassengersIn = sum(q(station, station:end));
            if TrainsOccupancy(1, trainID) + PassengersIn <= TrainsCapacity(1, trainID)
                TrainsOccupancy(1, trainID) = TrainsOccupancy(1, trainID) + PassengersIn;
                % trigger arrival to next station
                ArrivalMatrix = event.matrix;
                ArrivalMatrix(station, station:end) = ArrivalMatrix(station, station:end) + q(station, station:end);
                tA = t + scenario.TravelTimes(station);
                event = NewEvent(tA, 2, ArrivalMatrix, station+1, trainID);
                EventList = UpdatedEventList(EventList, event);
                % decrease queue size
                q(station, station:end) = 0;
                times = [times, t];
                queues = [queues, sum(q, 2)];
            else
                % distribute remaining passengers evenly accross destinations
                RemainingPassengers = TrainsOccupancy(1, trainID) + PassengersIn - TrainsCapacity(1, trainID);
                RemainingStations = nCities - station;
                LeftOutPassengers = [zeros(1, nCities-RemainingStations), floor(RemainingPassengers/RemainingStations)*ones(1, RemainingStations)];
                assert(size(LeftOutPassengers, 2) == nCities, 'Problem with remaining passengers at station %i...', station);
                TrainsOccupancy(1, trainID) = TrainsCapacity(1, trainID);
                % trigger arrival to next station
                ArrivalMatrix = event.matrix;
                ArrivalMatrix(station, :) = ArrivalMatrix(station, :) + q(station, :) - LeftOutPassengers;
                tA = t + scenario.TravelTimes(station);
                event = NewEvent(tA, 2, ArrivalMatrix, station+1, trainID);
                EventList = UpdatedEventList(EventList, event);
                % decrease queue size
                q(station, :) = LeftOutPassengers;
                times = [times, t];
                queues = [queues, sum(q, 2)];           
            end

            
    end
    EventList = EventList(2:end);
end


end