function plotProfit(times, profits)
% plots profit

times = times/60; % convert back to hours for visualization
profits = profits/1e6;

figure;
set(gcf,'units','points','position',[100,100,700,500]);

plot(times, profits, 'k-', 'LineWidth', 2.0);
ylims = get(gca, 'ylim');
if ylims(1) < 0.0
    ylims(1) = 0.0;
end
line([7, 7], ylims, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
line([9, 9], ylims, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
line([16, 16], ylims, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
line([18, 18], ylims, 'Color', [0.4,0.4,0.4], 'LineStyle', '--', 'LineWidth', 1.5);
xlim([0, 24]);
ylim(ylims);
xlabel("time (h)");
ylabel("profit (million CHF)");

set(gca,'fontsize',15,'box','off','TickDir','out','TickLength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','XColor',[.2 .2 .2],'YColor',[.2 .2 .2]);
saveas(gcf, 'profit.png')

end