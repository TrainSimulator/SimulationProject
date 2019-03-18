function PlotQueues(times, queues)

% =========================================================================
% DESCRIPTION
% usage: PlotQueues(times, queues)
% Plots queues at different stations at every timestamp
%
% -------------------------------------------------------------------------
% PARAMETERS
% times: row vector with timestamps (see `Simulation.m`)
% queues: 3*time matrix (see `Simulation.m`)
%
% -------------------------------------------------------------------------
% RETURN VALUES
%
% =========================================================================

times = times/60; % convert back to hours for visualization

figure;
plot(times, queues(1, :));
hold on;
plot(times, queues(2, :));
hold on;
plot(times, queues(3, :));
legend('Geneva', 'Lausanne', 'Bern');
title("Queues at different stations");
xlim([0, 24]);
xlabel("Time (min)");
ylabel("Passengers in the queue");

end