function [times, queues, waittime, gain, loss] = SimulationF(scenario)

% =========================================================================
% DESCRIPTION
% usage: [times, queues] = Simulation(scenario)
% Runs a simulation of "scenario"

%% Create event list:
PEventList = PassengerEvents(scenario);
TEventList = TrainEvents(scenario);
EventList = [PEventList; TEventList];

% npassengers = length(PEventList);
nevents = length(EventList);
ntrains = length(scenario.timetable);

nstat = 4; % Total number of stations
nclass = 2; % Total number of classes (1st, 2nd)

% Sort events for time:
[EventList, ~] = sortrows(EventList,1);

% Preallocate queues for stations and trains
queue(nstat-1, nclass).p = zeros(0);
trains = zeros(ntrains,nclass,nstat-1); % (trainID, class, destinations 1: Lausanne, 2: Bern, 3: Zuerich)

ndest = zeros(nclass,nstat-1);
nqueues = zeros(nstat-1,nclass); % Queue counter variable
ntrans = zeros(1,2);

% Preallocate queue book keeping vectors
queues = zeros(nevents,nstat-1);
times = zeros(nevents,1);

% Indicators:
waittime = [];
gain = 0;
loss = 0;

%% Handle event list:
for j = 1:nevents
    % Get entries from Event:
    t = EventList(j,1);
    type = EventList(j,2);
    station = EventList(j,3);
    
    switch type
        case 1 % Passenger generation
            class = EventList(j,6);
            queue(station,class).p(end+1) = j;
            nqueues(station,class) = nqueues(station,class) + 1;
        case 2 % Train arrival
            trainID = EventList(j,5);
            %% 1. Empty train:
            if station ~= 1
                trains(trainID,:,station-1) = 0;
            end
            %% 2. Board train:
            if station ~= nstat % If train at final stop
                npass = [sum(trains(trainID,1,:)) sum(trains(trainID,2,:))];
                space = scenario.capacity(trainID,:) - npass;
                fullq = space > nqueues(station,:);
                
                addtimes = [];
                for class = 1:nclass
                    if nqueues(station,class) ~= 0
                        if fullq(class)
                            ndest(class,:) = sum(EventList(queue(station,class).p,4) == 2:nstat);
                        else
                            ndest(class,:) = sum(EventList(queue(station,class).p(1:space(class)),4) == 2:nstat);
                        end
                        ntrans(class) = sum(ndest(class,:));
                        for dest = 1:nstat-1
                            trains(trainID,class,dest) = trains(trainID,class,dest) + ndest(class,dest);
                            gain = gain + ndest(class,dest) * (scenario.ticket(class) * (dest + 1 - station));
                        end
                        addtimes = [addtimes t - EventList(queue(station,class).p(1:ntrans(class)),1)'];
                        queue(station,class).p(1:ntrans(class)) = [];
                    else
                        ntrans(class) = 0;
                    end
                end
                waittime = [waittime addtimes];
                npass = npass + ntrans;
                nqueues(station,:) = nqueues(station,:) - ntrans;
                loss = loss + sum(nqueues(station,:) .* scenario.missed);
            end
            %% 3. After boarding:
            % Cost for empty seats on train
            emptyseats = scenario.capacity(trainID,:) - npass;
            loss = loss + sum(scenario.empty .* emptyseats);
    end
    %% Book keeping for each event:
    times(j) = t;
    queues(j,:) = nqueues(:,1) + nqueues(:,2);
end
end
