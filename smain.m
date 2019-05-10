%% Single run simulation launch script

clear
close all;

tic

%% Input parameters:
params.FreqPeak = 4;
params.FreqOffPeak = 2;
params.CarriagesPeak = [1, 3];
params.CarriagesOffPeak = [1, 3];
params.ShiftPeakStart = 0;
params.ShiftPeakEnd = 0;

%% Run simulation:
scenario = NewScenario(params);
[times, queues, waittime, gain, loss, gainb, lossb] = Simulation(scenario);

toc

%% Plotting:
profit = gain - loss;
disp(['profit: ' num2str(profit)])

plotHistogram(waittime, 'waittime');
ylabel('#passengers')

figure;
plot(times, queues)

figure;
hold all;
for i = 1:3
    subplot(4,1,i)
    plot(times/60, queues(:,i))
    set(gca,'xticklabel',{[]})
    xlim([0 24])
end

% figure;
subplot(4,1,4)
format shortEng
plot(times/60, gainb-lossb);
y = 0;
line([0 24],[y,y],'Color','black')
ylabel('profit [CHF]')
xlabel('time [h]');
xlim([0 24])
ax = gca;
ax.XTick = 0:4:max(xlim);
