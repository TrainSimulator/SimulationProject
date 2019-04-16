function EventList = PassengerEvents(scenario)
% Generate passenger events for time scenario.DemandDuration for each entry
% of probability matrix

nalloc = 1000000; % Preallocate events
EventList = zeros(nalloc,6);
counter = 0; % Total event counter

for origin = 1:4
    for destination = origin+1:4
        t = 0;
        while t < scenario.DemandDuration
            % Choose distribution based on time and origin/destination
            if (t >= scenario.MorningPeak(1) && t < scenario.MorningPeak(2)) ...
                || (t >= scenario.EveningPeak(1) && t < scenario.EveningPeak(2))
                rate = scenario.DemandPeak(origin,destination) * 1000/60;
                classprop = scenario.ClassPeak(origin,destination);
            else
                rate = scenario.DemandOffPeak(origin,destination) * 1000/60;
                classprop = scenario.ClassOffPeak(origin,destination);
            end
            t = t - log(rand) / rate; % Draw from the poisson distribution
            
            if t < scenario.DemandDuration
                counter = counter + 1;

                % Do another draw to decide if passenger is first or second class
                if rand() <= classprop
                    class = 1;
                else
                    class = 2;
                end
    %             class = 2 - (rand() <= classprop);
                % Add event to event list
                EventList(counter,:) = [t 1 origin destination 0 class];
            end
        end
    end
end
EventList = EventList(1:counter,:);
end
