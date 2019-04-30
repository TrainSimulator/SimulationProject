function [times, queues, waittime, gain, loss] = Simulation(scenario)

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
queue(3).p = zeros(0,6);
trains(ntrains,2).p = zeros(0,6);

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
            queue(station).p(end+1,:) = Event;
        case 2 % Train arrival
            trainID = Event(5);
            %% 1. Empty train:
            if station ~= 1
                % If train is not empty check if passengers leave the train
                npass = [length(trains(trainID,1).p) length(trains(trainID,2).p)]; % Number of passengers on train
                for class = 1:2
                    i = 1; % list iterator
                    while i <= npass(class)
                        destination = trains(trainID,class).p(i,4);
                        if destination == station
                            % Remove passsenger from train
                            trains(trainID,class).p(i,:) = [];
                            npass(class) = npass(class) - 1;
                        else
                            i = i + 1;
                        end
                    end
                end
            end
            
            %% 2. Board train:
            if station ~= 4
                nqueue = length(queue(station).p); % Number of passengers in station queue
                npass = [length(trains(trainID,1).p) length(trains(trainID,2).p)]; % Number of passengers on train
                i = 1;
                while i <= nqueue
                    % If passenger fits, put him on the train and remove
                    % from queue, add ticket price
                    class = queue(station).p(i,6);
                    if npass(class) < scenario.capacity(trainID,class)
                        destination = queue(station).p(i,4);
                        gain = gain + scenario.ticket(class) * (destination - station);
                        waittime(end+1) = t - queue(station).p(i,1);
                        trains(trainID,class).p(end+1,:) = queue(station).p(i,:);
                        queue(station).p(i,:) = [];
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
