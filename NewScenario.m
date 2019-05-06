function scenario = NewScenario(params)
% builds new scenario basod on params struckt


% hard coded from description, don't change these!
scenario.DemandDuration = 24 * 60;
scenario.MorningPeak = [7, 9] * 60; % Peak times
scenario.EveningPeak = [16, 18] * 60;
scenario.DemandPeak = [0, 1.5, 2.2, 1.3;
                       0, 0,   2.4, 1.1;
                       0, 0,   0,   3.3;
                       0, 0,   0,   0];
scenario.DemandOffPeak = [0, 0.4, 0.3, 0.5;
                          0, 0,   0.5, 0.3;
                          0, 0,   0,   0.5;
                          0, 0,   0,   0];                      
scenario.ClassPeak = [0, 0.13, 0.15, 0.17;
                      0, 0, 0.21, 0.18;
                      0, 0, 0, 0.32;
                      0, 0, 0, 0];
scenario.ClassOffPeak = [0, 0.21, 0.18, 0.23;
                         0, 0, 0.24, 0.23;
                         0, 0, 0, 0.19;
                         0, 0, 0, 0];
scenario.TravelTimes = [0, 40, 110, 170];
scenario.ticket = [40, 20]; % Ticket price per passenger per station
scenario.missed = [30, 10]; % Money lost for a passenger missing a train
scenario.empty = [20, 10]; % Money lost for empty seat per station


% build timetable
MorningPeak_ = [scenario.MorningPeak(1)+params.ShiftPeakStart, scenario.MorningPeak(2)+params.ShiftPeakEnd];
EveningPeak_ = [scenario.EveningPeak(1)+params.ShiftPeakStart, scenario.EveningPeak(2)+params.ShiftPeakEnd];
ITMinsPeak = 60/params.FreqPeak;  % Inter Train Minutes in peak periods
ITMinsOffPeak = 60/params.FreqOffPeak;  % Inter Train Minutes in off peak periods
scenario.timetable = unique([0:ITMinsOffPeak:MorningPeak_(1),...
                             MorningPeak_(1):ITMinsPeak:MorningPeak_(2),...
                             MorningPeak_(2):ITMinsOffPeak:EveningPeak_(1),...
                             EveningPeak_(1):ITMinsPeak:EveningPeak_(2),...
                             EveningPeak_(2):ITMinsOffPeak:scenario.DemandDuration]);

                         
% build carriages (and capacity)
ntrains = length(scenario.timetable);
carriages = zeros(ntrains, 2);
peak_idx = find(MorningPeak_(1) <= scenario.timetable & scenario.timetable <= MorningPeak_(2)...
                | EveningPeak_(1) <= scenario.timetable & scenario.timetable <= EveningPeak_(2));
for i=peak_idx
    carriages(i, :) = params.CarriagesPeak;
end
offpeak_idx = 1:ntrains;
offpeak_idx(peak_idx) = [];
for i=offpeak_idx
    carriages(i, :) = params.CarriagesOffPeak;
end
scenario.carriages = carriages;

scenario.capacity(:, 1) = scenario.carriages(:, 1) * 300;
scenario.capacity(:, 2) = scenario.carriages(:, 2) * 500;

end
