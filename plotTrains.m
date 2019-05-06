function plotTrains(scenario)

figure;
barh(scenario.timetable/60, fliplr(scenario.carriages), 'stacked');  % flip only to start with second class (and make 1st class red)
xlabel('number of carriages per class');
ylabel('timetable');

end