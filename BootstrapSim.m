%% Test the implementation of QueueingSimulation1.m function

%% clean the workspace
clear %Removes all variables, functions, and MEX-files from memory, leaving the workspace empty
close all % delete all figures whose handles are not hidden.

tic

%% Program
% Initialize the variable
avg_waittime_avg = 0; % average of the average waittime of a passenger
avg_waittime_var = 0;
avg_waittime_all = [];
avg_waittime_avg_all = [];
avg_waittime_var_all = [];
run = 0; % number of run

% Set the scenario
scenario = NewScenario(1);
BootstrapMSE_Mean = inf;

% Main loop
while BootstrapMSE_Mean > 2.5e-04 % multiple run simulation until the stopping criteria is met

    % Run the simulation
    [times, queues, waittime, gain, loss] = Simulation(scenario);

    % Collect statistics
    avg_waittime = mean(waittime); % [veh] maximum length of the queue in this simulation run
    if run == 0
      avg_waittime_avg = avg_waittime;
      avg_waittime_var = 0;
    else
      [avg_waittime_avg, avg_waittime_var] = UpdatedStatistics(avg_waittime_avg, avg_waittime_var, avg_waittime, run);
    end

    run = run + 1;

    % Collect statistics for all runs
    avg_waittime_all(run) = avg_waittime;
    avg_waittime_avg_all(run) = avg_waittime_avg;
    avg_waittime_var_all(run) = avg_waittime_var;

    %% Criteria for stopping simulating new runs
    if run > 50 % Let atleast 50 run
        Mean = mean(avg_waittime_all);
        MSE_Mean = var(avg_waittime_all)/run; % compare with the analytical MSE
        BootstrapMSE_Mean = BootstrapMSE(avg_waittime_all, @mean, Mean, 100);
    end
end

% Plot the average maximum queue length and standard deviation
plot(avg_waittime_avg_all,'k');
hold on;
plot(sqrt(avg_waittime_var_all),'--k');
hold off;
xlabel('simulation run');ylabel('waittime');legend('avg avg waittime','std avg waittime','Location','Best');

% Plot the histogram of maximum queue length
plotHistogram(avg_waittime_all);drawnow

%% Bootstrap
figure; cdfplot(avg_waittime_all); %plot the empirical CDF

% Mean maximum-queue-lenght
Mean = mean(avg_waittime_all);
MSE_Mean = var(avg_waittime_all)/run; % compare with the analytical MSE
BootstrapMSE_Mean = BootstrapMSE(avg_waittime_all, @mean, Mean, 100);
display(Mean);
display(MSE_Mean);
display(BootstrapMSE_Mean);

% 95 percentile of the maximum-queue-length
PRC95 = Prc95(avg_waittime_all);
BootstrapMSE_Prc95 = BootstrapMSE(avg_waittime_all, @Prc95, PRC95, 100);
display(PRC95);
display(BootstrapMSE_Prc95);

% Worst scenario of the maximum-queue-length
Worst = max(avg_waittime_all);
BootstrapMSE_Worst = BootstrapMSE(avg_waittime_all, @max, Worst, 100);
display(Worst);
display(BootstrapMSE_Worst);

toc
