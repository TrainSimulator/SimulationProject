function plotHistogram(data, xlabel_, savename_)
% plots histogram with mean and percentiles

figure;
set(gcf,'units','points','position',[100,100,700,500]);

histogram(data, 20);
xlabel(xlabel_);
ylabel('frequency');
set(get(gca,'child'),'FaceColor',[0.4,0.4,0.4]);
% Add mean
ylim = get(gca,'ylim');
l1 = line([mean(data), mean(data)], ylim, 'Color','r','LineWidth',2.0); % mean
% And percentile
l2 = line([prctile(data,5), prctile(data,5)], ylim, 'LineStyle','--','Color','r','LineWidth',2.0); %  5 percentile
line([prctile(data,95) prctile(data,95)], ylim, 'LineStyle','--','Color','r','LineWidth',2.0); % 95 percentile
% Addmax
l3 = line([max(data) max(data)], ylim, 'LineStyle',':','Color','r','LineWidth',2.0); %  max
% Legend
l = legend([l1 l2 l3], 'mean', '5 and 95 percentile', 'max', 'Location', 'Best');

set(l,'fontsize',18,'box','off','Location', 'Best');
set(gca,'fontsize',15,'box','off','TickDir','out','TickLength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','XColor',[.2 .2 .2],'YColor',[.2 .2 .2]);
saveas(gcf, sprintf('%s.png', savename_))

end
