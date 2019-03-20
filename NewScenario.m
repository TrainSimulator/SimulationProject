function scenario = NewScenario(id)

% ============================================================================
% DESCRIPTION
% usage: scenario = NewScenario(id)
% Builds a single scenario.
%
% ----------------------------------------------------------------------------
% PARAMETERS
% id: id of the scenario, 1 and 2 from the given description, remaining ones will be optimized
%
% ----------------------------------------------------------------------------
% RETURN VALUES
% scenario: data structure with the following fields:
% .DemandDuration: length of the demand interval (set to 24 hours)
% .MorningPeak: 1*2 vector representing morning peak hours (from exc. description)
% .EveningPeak: 1*2 vector representing evening peak hours (from exc. description)
% .DemandPeak: 4*4 matrix (from-to) representing passenger demand in peak hours (from exc. description)
% .DemandOffPeak: 4*4 matrix (from-to) representing passenger demand outside peak hours (from exc. description)
% .TravelTimes: 1*3 vector representing travel times between cities (from exc. description)
% .timetable(id): row vector with train time table (from exc. description)
% .trains(id): row vector of train composition (available number of seats) (from exc. description)
%
% ============================================================================

scenario.DemandDuration = 24 * 60;

% hard coded from description, don't change these!
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
                      
scenario.ClassPeak = [0 0.13 0.15 0.17;
0 0 0.21 0.18;
0 0 0 0.32;
0 0 0 0];

scenario.ClassOffPeak = [0 0.21 0.18 0.23;
0 0 0.24 0.23;
0 0 0 0.19;
0 0 0 0];

%TODO: add 1st/2nd class matrices
scenario.TravelTimes = [0, 40, 70, 60];

% pregenerate train time table (it's enough for now...)
%TODO: add 1st/2nd class nr. of seats
if id == 1
    scenario.timetable = 0:20:scenario.DemandDuration; 
    % hard coded 4*500 max capacity (no 1st/2nd class separation)
%     scenario.trains = 2000*ones(1, size(scenario.timetable, 2));
elseif id == 2
    scenario.timetable = unique([0:30:scenario.MorningPeak(1),...
                                 scenario.MorningPeak(1):15:scenario.MorningPeak(2),...
                                 scenario.MorningPeak(2):30:scenario.EveningPeak(1),...
                                 scenario.EveningPeak(1):15:scenario.EveningPeak(2),...
                                 scenario.EveningPeak(2):30:scenario.DemandDuration]);
    % hard coded 4*500 max capacity (no 1st/2nd class separation)
%     scenario.trains = 2000*ones(1, size(scenario.timetable, 2));
end

% Number carriages for the trains and their capacity, needs to be varied
% in the optimization part of the project
ntrains = length(scenario.timetable);
scenario.carriage(1:ntrains,1) = 1;
scenario.carriage(1:ntrains,2) = 3;
scenario.capacity(1:ntrains,1) = scenario.carriage(1:ntrains,1) * 300;
scenario.capacity(1:ntrains,2) = scenario.carriage(1:ntrains,2) * 500;
end
