function [times, queues, waittime, gain, loss] = SimulationF(scenario)

% =========================================================================
% DESCRIPTION
% usage: [times, queues] = Simulation(scenario)
% Runs a simulation of "scenario"

%% Create event list:
PEventList = PassengerEvents(scenario);
TEventList = TrainEvents(scenario);
EventList = [PEventList; TEventList];

npassengers = length(PEventList);
nevents = length(EventList);
ntrains = length(scenario.timetable);

% Sort events for time:
[EventList, ~] = sortrows(EventList,1);

% Preallocate queues for stations and trains
queue(3).p = zeros(0);
% trains(ntrains,2).p = zeros(0);
trains = zeros(ntrains,2,3); % (trainID, class, destinations 1: Lausanne, 2: Bern, 3: Zuerich)

% Preallocate queue book keeping vectors
queues = zeros(nevents,3);
times = zeros(nevents,1);

% Indicators:
waittime = [];
gain = 0;
loss = 0;

%% Handle event list:
for j = 1:nevents
    % Get entries from Event:
    Event = EventList(j,:);
    t = Event(1);
    type = Event(2);
    station = Event(3);
    
    switch type
        case 1 % Passenger generation
            queue(station).p(end+1) = j;
        case 2 % Train arrival
            trainID = Event(5);
            %% 1. Empty train:
            if station ~= 1
                trains(trainID,:,station-1) = 0;
            end
            %% 2. Board train:
            if station ~= 4
                nqueue = length(queue(station).p); % Number of passengers in station queue
                npass = [sum(trains(trainID,1,:)) sum(trains(trainID,2,:))];
                i = 1;
                while i <= nqueue
                    % If passenger fits, put him on the train and remove
                    % from queue, add ticket price
                    class = EventList(queue(station).p(i),6);
                    if npass(class) < scenario.capacity(trainID,class)
                        destination = EventList(queue(station).p(i),4);
                        gain = gain + scenario.ticket(class) * (destination - station);
                        waittime(end+1) = t - EventList(queue(station).p(i),1);
                        trains(trainID,class,destination-1) = trains(trainID,class,destination-1) + 1;
                        queue(station).p(i) = [];
                        nqueue = nqueue - 1;
                        npass(class) = npass(class) + 1;
                    else
                        % Passenger misses train
                        loss = loss + scenario.missed(class);
                        i = i + 1;
                    end
                end
            end
            %% 3. After boarding:
            % Cost for empty seats on train
            emptyseats = scenario.capacity(trainID,:) - npass;
            loss = loss + sum(scenario.empty .* emptyseats);
    end
    %% Book keeping for each event:
    times(j) = t;
    queues(j,:) = [length(queue(1).p) length(queue(2).p) length(queue(3).p)];
end
end
