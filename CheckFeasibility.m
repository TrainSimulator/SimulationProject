function feasible = CheckFeasibility(params)
% checks if timetable and train composition is feasible
% note: peak hour checks are hard coded here, but they should depend on scenario....

feasible = 1;

% check if parameters make sense at all...
if params.FreqPeak <= 0.0 || params.FreqOffPeak <= 0.0
    feasible = 0;
end
if any(params.CarriagesPeak < 0) || any(params.CarriagesOffPeak < 0)
    feasible = 0;
end
% don't shift peak hours out of the day
if params.ShiftPeakStart < -420 || params.ShiftPeakEnd > 360
   feasible = 0;
end
% don't shorten peak hours into negative time (don't make peak hours to short)
if params.ShiftPeakStart - params.ShiftPeakEnd >= 120
   feasible = 0;
end
% don't overlap morning and evening peak hours (don't make peak hours too long)
if params.ShiftPeakEnd - params.ShiftPeakStart >= 420
    feasible = 0;
end

% check time gaps between trains (see description)
if params.FreqPeak < 1.0 || params.FreqOffPeak < 1.0
    feasible = 0;
end
% maximum 6 carriage for all trains (see description)
if sum(params.CarriagesOffPeak) > 6 || sum(params.CarriagesPeak) > 6
    feasible = 0;
end
% maximum 3 different compositions per day (see description)
% -> no need to check due to param composition

end