function plotQueues(times, queues)
% plots queue length at every station

times = times/60; % convert back to hours for visualization

figure;
q1 = plot(times, queues(:, 1));
hold on;
q2 = plot(times, queues(:, 2));
hold on;
q3 = plot(times, queues(:, 3));
ylim = get(gca, 'ylim');
line([7, 7], ylim, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
line([9, 9], ylim, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
line([16, 16], ylim, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
line([18, 18], ylim, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
legend([q1, q2, q3], 'Geneva', 'Lausanne', 'Bern');
xlim([0, 24]);
xlabel("time");
ylabel("#passengers in the queue");

end