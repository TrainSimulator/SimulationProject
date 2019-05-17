function [params, rnd] = Rand_Parameters(params, weights, level)
%% Randomize simulation parameters:
nneighbourhoods = 30;
switch level
    case 1
        totalneighbours = nneighbourhoods;
        weights = weights(1:nneighbourhoods);
    case 2
        totalneighbours = nneighbourhoods + (nneighbourhoods-1)*(nneighbourhoods)/2;
end
rnd = randsample(totalneighbours, 1, true, weights);
% N = 1; % Define the amount of change, this might need to be a tunable parameter in the future for each randomization function

if rnd > nneighbourhoods
    nn = 2;
    sum = nneighbourhoods;
    for i = 1:nneighbourhoods-1
        sum = sum + i;
        if rnd <= sum
            k = sum - rnd + 2;
            neighbour = [i+1 k-1];
            break
        end
    end
else
    nn = 1;
    neighbour = rnd;
end

for i = 1:nn
    switch neighbour(i)
        case 1
            % Change off peak carriages for first or second class
            class = randsample(2,1);
            params = Rand_OCarr(params, class, 1);
        case 2
            % Change off peak carriages for first or second class
            class = randsample(2,1);
            params = Rand_OCarr(params, class, 2);
        case 3
            % Change peak carriages for first or second class
            class = randsample(2,1);
            params = Rand_PCarr(params, class, 1);
        case 4
            % Change peak carriages for first or second class
            class = randsample(2,1);
            params = Rand_PCarr(params, class, 2);
        case 5
            % Change off peak train frequency
            params = Rand_OFreq(params, 1);
        case 6
            % Change off peak train frequency
            params = Rand_OFreq(params, 2);
        case 7
            % Change off peak train frequency
            params = Rand_OFreq(params, 3);
        case 8
            % Change off peak train frequency
            params = Rand_PFreq(params, 1);
        case 9
            % Change off peak train frequency
            params = Rand_PFreq(params, 2);
        case 10
            % Change off peak train frequency
            params = Rand_PFreq(params, 3);
        case 11
            % Shift the peak time intervall in time
            params = Rand_ShiftPeak(params, 1);
        case 12
            % Shift the peak time intervall in time
            params = Rand_ShiftPeak(params, 2);
        case 13
            % Shift the peak time intervall in time
            params = Rand_ShiftPeak(params, 3);
        case 14
            % Shift the peak time intervall in time
            params = Rand_ShiftPeak(params, 4);
        case 15
            % Shift the peak time intervall in time
            params = Rand_ShiftPeak(params, 5);
        case 16
            % Shift the peak time intervall in time
            params = Rand_ShiftPeak(params, 6);
        case 17
            % Shift the peak time intervall in time
            params = Rand_ShiftPeak(params, 7);
        case 18
            % Shift the peak time intervall in time
            params = Rand_ShiftPeak(params, 8);
        case 19
            % Shift the peak time intervall in time
            params = Rand_ShiftPeak(params, 9);
        case 20
            % Shift the peak time intervall in time
            params = Rand_ShiftPeak(params, 10);
        case 21
            % Shift the peak time duration
            params = Rand_PeakDuration(params, 1);
        case 22
            % Shift the peak time duration
            params = Rand_PeakDuration(params, 2);
        case 23
            % Shift the peak time duration
            params = Rand_PeakDuration(params, 3);
        case 24
            % Shift the peak time duration
            params = Rand_PeakDuration(params, 4);
        case 25
            % Shift the peak time duration
            params = Rand_PeakDuration(params, 5);
        case 26
            % Shift the peak time duration
            params = Rand_PeakDuration(params, 6);
        case 27
            % Shift the peak time duration
            params = Rand_PeakDuration(params, 7);
        case 28
            % Shift the peak time duration
            params = Rand_PeakDuration(params, 8);
        case 29
            % Shift the peak time duration
            params = Rand_PeakDuration(params, 9);
        case 30
            % Shift the peak time duration
            params = Rand_PeakDuration(params, 10);
    end
end
end

