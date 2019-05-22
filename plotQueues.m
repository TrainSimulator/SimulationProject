function plotQueues(times, queues)
% plots queue length at every station

times = times/60; % convert back to hours for visualization

figure;
set(gcf,'units','points','position',[100,100,700,500]);

q1 = plot(times, queues(:, 1), 'LineWidth', 1.5);
hold on;
q2 = plot(times, queues(:, 2), 'LineWidth', 1.5);
hold on;
q3 = plot(times, queues(:, 3), 'LineWidth', 1.5);
ylim = get(gca, 'ylim');
line([7, 7], ylim, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
line([9, 9], ylim, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
line([16, 16], ylim, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
line([18, 18], ylim, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
l = legend([q1, q2, q3], 'Geneva', 'Lausanne', 'Bern');
xlim([0, 24]);
xlabel("time (h)");
ylabel("passengers in the queue");

set(l,'fontsize',18,'box','off','Location','Best');
set(gca,'fontsize',15,'box','off','TickDir','out','TickLength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','XColor',[.2 .2 .2],'YColor',[.2 .2 .2]);
saveas(gcf, 'queue.png')

end