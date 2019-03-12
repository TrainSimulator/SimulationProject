%% Simulation launch script

Dpeak = [0 1.5 2.2 1.3;
    0 0 2.4 1.1;
    0 0 0 3.3;
    0 0 0 0];

Doffpeak = [0 0.4 0.3 0.5;
    0 0 0.5 0.3;
    0 0 0 0.5;
    0 0 0 0];

T = 2*60; % Time set to two hours because of computation time
Tpmorning = [7 9]*60; % Peak times
Tpevening = [16 18]*60;

EventList = [];

%% Generate passengers events for time T for each entry in matrix
for origin = 1:4
    for destination = origin+1:4
        disp([num2str(origin) num2str(destination)])
        t=0;
        while t<T
            if (t >= Tpmorning(1) && t < Tpmorning(2)) || (t >= Tpevening(1) && t < Tpevening(2))
                rate = Dpeak(origin,destination)*1000/60;
            else
                rate = Doffpeak(origin,destination)*1000/60;
            end
            t = t-log(rand)/rate;
            Event = NewEvent(t, 1, origin, destination);
            EventList = UpdatedEventList(EventList, Event);
        end
    end
end

%% Create train arrival events
freq = 0:20:T;
A(1,:) = freq;
A(2,:) = freq + 40;
A(3,:) = freq + 110;
A(4,:) = freq + 170;

for station = 1:4
    for train = 1:length(A(station,:))
        Event = NewEvent(A(station,train), 2, station, train);
        EventList = UpdatedEventList(EventList, Event);
    end
end

%% TODO: Handle events, fill trains etc.
% city(1).queue(1).event = [];
% queue = [];
% % queue = zeros(4,1);
% trainp = zeros(length(A(station,:)),1);
% 
% while ~isempty(EventList)
%     t = EventList(1).time;
%     switch EventList(1).type
%         case 1 % GENERATION
%             city(EventList(1).station).queue(end+1).event = EventList(1);
%         case 2 % TRAIN ARRIVAL
%             
%     end
%     EventList = EventList(2:end);
% end
