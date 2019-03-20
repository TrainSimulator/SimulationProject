function [times, queues] = Simulation(scenario)

% =========================================================================
% DESCRIPTION
% usage: [times, queues] = Simulation(scenario)
% Runs a simulation of "scenario"

%% Create event list:
PEventList = PassengerEvents(scenario); 
TEventList = TrainEvents(scenario);
EventList = [PEventList; TEventList];
counter = length(EventList);
ntrains = length(TEventList);

% Sort events for time:
[EventList, ~] = sortrows(EventList,1);

% Preallocate queues for stations and trains
queue(3).p = zeros(0,6);
trains(ntrains).p = zeros(0,6);

% Preallocate queue book keeping vectors
queues = zeros(counter,3);
times = zeros(counter,1);

%% Handle event list:
for j = 1:counter
    % Get entries from Event:
    Event = EventList(j,:);
    t = Event(1);
    type = Event(2);
    station = Event(3);
    
    switch type
        case 1 % Passenger generation
            queue(station).p(end+1,:) = Event;
        case 2 % Train arrival
            trainID = Event(5);
            %% 1. Empty train:
            if station ~= 1
                % If train is not empty check if passengers leave the train
                i = 1; % list iterator
                npass = length(trains(trainID).p); % Number of passengers on train
                while i <= npass
                    destination = trains(trainID).p(i,4);
                    if destination == station
                        % Remove passsenger from train
                        trains(trainID).p(i,:) = [];
                        npass = npass - 1;
                    else
                        i = i + 1;
                    end
                end
            end

            %% 2. Board train:
            if station ~= 4
                % Here every class is equal TODO: do class management
                nqueue = length(queue(station).p); % Number of passengers in station queue
                npass = length(trains(trainID).p); % Number of passengers on train
                i = 1;
                while i <= nqueue
                    % If passenger fits, put him on the train and remove
                    % from queue
                    if npass < scenario.capacity(trainID,1) + scenario.capacity(trainID,2)
                        trains(trainID).p(end+1,:) = queue(station).p(i,:);
                        queue(station).p(i,:) = [];
                        nqueue = nqueue - 1;
                        npass = npass + 1;
                    else
                        i = i + 1;
                    end
                end
            end
    end
    %% Book keeping for each event:
    times(j) = t;
    queues(j,:) = [length(queue(1).p) length(queue(2).p) length(queue(3).p)];
end
end
