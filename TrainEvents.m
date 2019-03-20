function EventList = TrainEvents(scenario)
% Generate train arrival events for time scenario.DemandDuration for each 
% entry in train shedule

ntrains = length(scenario.timetable);
EventList = zeros(ntrains, 6);
for trainID = 1:ntrains
    for station = 1:4
        time = scenario.timetable(trainID) + scenario.TravelTimes(station);
        EventList(4*(trainID-1)+station,:) = [time 2 station 0 trainID 0];
    end
end
end
